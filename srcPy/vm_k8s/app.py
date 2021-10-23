import os
import sys
from functools import wraps

import mariadb
from flask import Flask, jsonify, request
from prometheus_flask_exporter.multiprocess import GunicornPrometheusMetrics
from werkzeug.exceptions import Unauthorized
from werkzeug.wrappers.request import Request
import logging
app = Flask(__name__)
metrics = GunicornPrometheusMetrics(app)

# static information as metric
metrics.info("app_info", "FlaskApp info", version="1.0.0")

def get_db_con(
    _con_string=os.environ.get("DB_CON"),
    _user=os.environ.get("DB_USER"),
    _pass=os.environ.get("DB_PASS"),
):
    conn = mariadb.connect(
        user=_user,
        password=_pass,
        host=_con_string,
        port=3306,
    )
    return conn


def close_db(con):
    con.close()


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
@metrics.counter("cnt_index", "Homepage invocations")
def index():
    return "Homepage"


@app.route("/ping")
def ping_pong():
    return "pong"


# // GET
@app.route("/freehosts")
@app.route("/freehost")
@check_api_key
def get_next_free_vm():
    limit = request.args.get('limit')        
    cn = get_db_con()
    cur = cn.cursor()
    if limit is None:
        cur.execute("Select host_name, host_id FROM api.free_hostnames")
    else:
        statement = "Select host_name, host_id FROM api.free_hostnames LIMIT %s"
        data=(limit,)
        cur.execute(statement, data)

    free_VMs = []
    for (host_name, host_id) in cur:
        free_VMs.append({"host_name": host_name, "host_id": host_id})

    close_db(cn)
    return jsonify(free_VMs)


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
