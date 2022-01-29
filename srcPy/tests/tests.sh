#!/bin/bash


curl -H 'Authorization: YWRtaW46YWRtaW4=' http://0.0.0.0:9091/next_hosts?limit=10 | jq .

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://0.0.0.0:9091/next_host | jq .

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://0.0.0.0:9091/cluster_nodes_vm/t1

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://0.0.0.0:9091/cluster_nodes_vm/t2

curl -H 'Authorization: YWRtaW46YWRtaW4=' http://0.0.0.0:9091/cluster_nodes_vm/p1

