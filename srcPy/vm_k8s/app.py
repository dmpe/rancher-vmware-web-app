import os
import sys
from functools import wraps

import mariadb
from flask import Flask, request, jsonify
from werkzeug.exceptions import Unauthorized
from werkzeug.wrappers.request import Request

app = Flask(__name__)


def get_db_con(con_string=os.environ.get("DB_CON")):
    conn = mariadb.connect(
        user="jm",
        password="benz",
        host=con_string,
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
def index():
    return "Homepage"


@app.route("/ping")
def ping_pong():
    return "pong"


# // GET
@app.route("/freehosts")
@check_api_key
def virt_mach():
    cn = get_db_con()
    cur = cn.cursor()
    cur.execute("Select host_name, host_id FROM api.free_hostnames")
    
    contacts = []
    for (host_name, host_id) in cur:
        contacts.append({"host_name": host_name, "host_id":host_id})
    
    close_db(cn)
    return(jsonify(contacts))

# // GET
@app.route("/cluster_nodes_vm/<string:name>")
@check_api_key
def cluster_nodes_vm(name):
    cn = get_db_con()
    cur = cn.cursor()
    statement = "CALL sp_nodes_in_cluster_name(%s)"
    data = (name,)
    cur.execute(statement,data)

    contacts = []
    for i in cur:
        contacts.append(i)
    
    close_db(cn)
    return(jsonify(contacts))

# // GET
@app.route("/cluster_nodes_id/<int:id>")
@check_api_key
def cluster_nodes_id(id):
    cn = get_db_con()
    cur = cn.cursor()
    statement = "CALL sp_nodes_in_cluster_id(%s)"
    data = (id,)
    cur.execute(statement,data)

    contacts = []
    for i in cur:
        contacts.append(i)

    close_db(cn)
    return(jsonify(contacts))


# @app.route("/update_node_str/<str:name>")
# @check_api_key
# def update_node_str(name):
#     cn = get_db_con()
#     cur = cn.cursor()
# , vmware_created=False, rancher_allocated=False, ip="::0.0.0.0"
#     statement = "UPDATE api.vmware_master_data SET vmware_created=%s, rancher_allocated=%s, ip=%s WHERE host_name=%s"
#     data = (vmware_created,rancher_allocated,ip,name)
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
#     data = (vmware_created,rancher_allocated,ip,id)
#     cur.execute(statement,data)
#     cn.commit()
#     close_db(cn)
#     return(jsonify(cur))
