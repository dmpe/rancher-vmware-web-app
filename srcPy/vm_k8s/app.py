import os
import sys
import json
import apsw
from functools import wraps
import boto3
import sqlite_s3vfs
from flask import Flask, jsonify, make_response, request
from prometheus_flask_exporter.multiprocess import GunicornPrometheusMetrics
from werkzeug.exceptions import Unauthorized
from werkzeug.wrappers.request import Request
import logging
from contextlib import closing, contextmanager

app = Flask(__name__)
metrics = GunicornPrometheusMetrics(app)
key_prefix = "rancher.db"

# static information as metric
metrics.info("app_info", "FlaskApp Alpha", version="1.0.1")


def aws_bucket():
    s3_client = boto3.resource(
        "s3",
        region_name="alpha-east-3",
        verify=False,
        aws_access_key_id="test",
        aws_secret_access_key="123456789",
        endpoint_url="http://172.17.0.2:9000",
    )
    return s3_client


# Create Flask Decorator:
# A decorator is a function that wraps and replaces another function.
# Since the original function is replaced, you need to remember to copy the original
# function’s information to the new function. Use functools.wraps() to handle this for you.
# https://flask.palletsprojects.com/en/2.0.x/patterns/viewdecorators/
def check_api_key(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        er_msg = "Authorization Basic header not found."
        auth_header = request.headers.get("Authorization")

        if auth_header is None:
            raise Unauthorized(er_msg)
        return f(*args, **kwargs)

    return wrapper


@app.route("/")
@metrics.counter("homepage_index", "Homepage invocations")
def index():
    return "Homepage"


@app.route("/ping")
@metrics.counter("ping_pong_index", "Ping/Pong invocations")
def ping_pong():
    return "pong"


@app.route("/next_hosts", methods=["GET"])
@app.route("/next_host", methods=["GET"])
@check_api_key
def get_next_free_vm():
    """
    In order to read a DB file on s3, you first have to deserialize sqlite DB (usually 1 file), and only then read it.
    By doing that, you convert 1 file into many chunks.
    Exactly like https://github.com/uktrade/sqlite-s3vfs#serializing-getting-a-regular-sqlite-file-out-of-the-vfs
    describes
    """
    limit = request.args.get("limit")
    as_bucket = aws_bucket().Bucket("test")
    source_obj = as_bucket.Object(key_prefix)

    s3vfs = sqlite_s3vfs.S3VFS(bucket=as_bucket)

    # for my_bucket_object in as_bucket.objects.all():
    #     print(my_bucket_object)

    with apsw.Connection(
        key_prefix,
        vfs=s3vfs.name,
    ) as db:
        print("      Using APSW file", apsw.__file__)  # from the extension module
        print("         APSW version", apsw.apswversion())  # from the extension module
        print(
            "   SQLite lib version", apsw.sqlitelibversion()
        )  # from the sqlite library code
        print(
            "SQLite header version", apsw.SQLITE_VERSION_NUMBER
        )  # from the sqlite header file at compile time
        cursor = db.cursor()

        bytes_iter = source_obj.get()["Body"].iter_chunks()
        s3vfs.deserialize_iter(key_prefix="rancher2.sqlite", bytes_iter=bytes_iter)

    with closing(apsw.Connection("rancher2.sqlite", vfs=s3vfs.name)) as db:

        cursor = db.cursor()
        # cursor.execute("SELECT * FROM sqlite_master;")
        # print(cursor.fetchall())


        if limit is None:
            cursor.execute('Select host_name, host_id FROM free_hostnames;')
        else:
            statement = "Select host_name, host_id FROM free_hostnames LIMIT %s;"
            data = (limit,)
            cursor.execute(statement, data)

        dt = cursor.fetchall()

    # Convert again to a new 1 file, called rancher3.db
    target_obj = as_bucket.Object('rancher3.db')
    target_obj.upload_fileobj(s3vfs.serialize_fileobj(key_prefix="rancher2.sqlite"))

    free_VMs = []
    for (host_name, host_id) in dt:
        free_VMs.append({"host_name": host_name, "host_id": host_id})

    return jsonify(free_VMs)


# TODO
@app.route("/created/<string:name>", methods=["POST"])
@check_api_key
def post_created_update(name):
    req = request.get_json()
    with apsw.Connection(
        key_prefix,
        flags=(apsw.SQLITE_OPEN_READWRITE | apsw.SQLITE_OPEN_URI),
        vfs=s3vfs.name,
    ) as db:
        cursor = db.cursor()
        statement = "UPDATE vmware_master_data SET vmware_created=%s, rancher_allocated=%s, ip=%s WHERE host_name=%s"
        data = (
            vmware_created,
            rancher_allocated,
            ip,
            name,
        )
        cur.execute(statement, data)
        cur.commit()

    response_body = {
        "message": "Update has been successful.",
        "sender": req.get("name"),
    }

    res = make_response(jsonify(response_body), 200)
    return res


# // GET
@app.route("/cluster_nodes_vm/<string:name>")
@check_api_key
def get_cluster_nodes_vm(name):
    cn = get_db_con()
    cur = cn.cursor()
    statement = "CALL api.sp_nodes_in_cluster_name(%s)"
    data = (name,)
    cur.execute(statement, data)

    cl_nodes = []
    for i in cur:
        cl_nodes.append(i)

    close_db(cn)
    return jsonify(cl_nodes)


# // GET
@app.route("/cluster_nodes_id/<int:id>")
@check_api_key
def get_cluster_nodes_id(id):
    cn = get_db_con()
    cur = cn.cursor()
    statement = "CALL api.sp_nodes_in_cluster_id(%s)"
    data = (id,)
    cur.execute(statement, data)

    cl_nodes = []
    for i in cur:
        cl_nodes.append(i)

    close_db(cn)
    return jsonify(cl_nodes)


# @app.route("/update_node_id/<int:id>")
# @check_api_key
# def update_node_id(id, vmware_created=False, rancher_allocated=False, ip="::0.0.0.0"):
#     cn = get_db_con()
#     cur = cn.cursor()
#     statement = "UPDATE api.vmware_master_data SET vmware_created=%s, rancher_allocated=%s, ip=%s WHERE host_id=%s"
#     data = (vmware_created,rancher_allocated,ip,id,)
#     cur.execute(statement,data)
#     cn.commit()
#     close_db(cn)
#     return(jsonify(cur))
