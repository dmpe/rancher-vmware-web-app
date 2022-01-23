import os
import sys
import json
import sqlite3
import apsw
from functools import wraps
import boto3
import sqlite_s3vfs
from flask import Flask, jsonify, make_response, request
from prometheus_flask_exporter.multiprocess import GunicornPrometheusMetrics
from werkzeug.exceptions import Unauthorized
from werkzeug.wrappers.request import Request
import logging
app = Flask(__name__)
metrics = GunicornPrometheusMetrics(app)

# static information as metric
metrics.info("app_info", "FlaskApp Alpha", version="1.0.1")

def ct_bucket():
    s3_client = boto3.resource(
        resource_name='s3',
        region_name='alpha-east-3',
        verify='/etc/ssl/certs/ca-bundle.crt',
        aws_access_key_id='abc',
        aws_secret_access_key='dew',
        endpoint_url='https://bucket.vpce-abc123-abcdefgh.s3.us-east-1.vpce.amazonaws.com', 
    )
    bucket = s3_client.Bucket('my-bucket')
    return bucket

s3vfs = sqlite_s3vfs.S3VFS(bucket=ct_bucket())

key_prefix = 'rancher.sqlite'


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
    limit = request.args.get('limit')        
    
    with apsw.Connection(key_prefix, vfs=s3vfs.name) as db:
        cursor = db.cursor()
        if limit is None:
            cursor.execute("Select host_name, host_id FROM free_hostnames")
        else:
            statement = "Select host_name, host_id FROM free_hostnames LIMIT %s"
            data=(limit,)
            cursor.execute(statement, data)
    
        cur=cursor.fetchall()

    free_VMs = []
    for (host_name, host_id) in cur:
        free_VMs.append({"host_name": host_name, "host_id": host_id})

    return jsonify(free_VMs)

# TODO
@app.route("/created/<str:name>", methods=["POST"])
def post_created_update(name):
    req = request.get_json()
    with apsw.Connection(key_prefix, vfs=s3vfs.name) as db:
        cursor = db.cursor()
        statement = "UPDATE vmware_master_data SET vmware_created=%s, rancher_allocated=%s, ip=%s WHERE host_name=%s"
        data = (vmware_created,rancher_allocated,ip,name,)
        cur.execute(statement,data)
        cur.commit()
    
    response_body = {
        "message": "Update has been successful.",
        "sender": req.get("name")
    }

    res = make_response(jsonify(response_body), 200)
    return(res)

# # // GET
# @app.route("/cluster_nodes_vm/<string:name>")
# @check_api_key
# def get_cluster_nodes_vm(name):
#     cn = get_db_con()
#     cur = cn.cursor()
#     statement = "CALL api.sp_nodes_in_cluster_name(%s)"
#     data = (name,)
#     cur.execute(statement, data)

#     cl_nodes = []
#     for i in cur:
#         cl_nodes.append(i)

#     close_db(cn)
#     return jsonify(cl_nodes)


# # // GET
# @app.route("/cluster_nodes_id/<int:id>")
# @check_api_key
# def get_cluster_nodes_id(id):
#     cn = get_db_con()
#     cur = cn.cursor()
#     statement = "CALL api.sp_nodes_in_cluster_id(%s)"
#     data = (id,)
#     cur.execute(statement, data)

#     cl_nodes = []
#     for i in cur:
#         cl_nodes.append(i)

#     close_db(cn)
#     return jsonify(cl_nodes)


# @app.route("/update_node_str/<str:name>")
# @check_api_key
# def update_node_str(name):
#     cn = get_db_con()
#     cur = cn.cursor()
# , vmware_created=False, rancher_allocated=False, ip="::0.0.0.0"
#     statement = "UPDATE api.vmware_master_data SET vmware_created=%s, rancher_allocated=%s, ip=%s WHERE host_name=%s"
#     data = (vmware_created,rancher_allocated,ip,name,)
#     cur.execute(statement,data)
#     cn.commit()
#     close_db(cn)
#     return(jsonify(cur))


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
