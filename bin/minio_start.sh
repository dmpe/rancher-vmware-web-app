#!/bin/bash
set -e

docker pull minio/minio
docker run \
  -p 9000:9000 \
  -p 9001:9001 \
  -v ~/Documents/vmware-postgress-dns/lib/sqlite:/data \
  -e "MINIO_ROOT_USER=test" \
  -e "MINIO_ROOT_PASSWORD=123456" \
  -e "MINIO_REGION=alpha-east-3" \
  minio/minio server /data --console-address ":9001"

mc alias set minio http://172.17.0.2:9000 test 123456
mc ls minio