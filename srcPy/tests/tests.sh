#!/bin/bash


curl -H 'Authorization: YWRtaW46YWRtaW4=' http://192.168.226.128:32242/freehosts?limit=10 | jq .

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://192.168.226.128:32242/freehost?limit=1 | jq .

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://192.168.226.128:32242/cluster_nodes_vm/t1

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://192.168.226.128:32242/cluster_nodes_vm/t2

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://192.168.226.128:32242/cluster_nodes_vm/p1

