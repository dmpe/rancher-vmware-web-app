#!/bin/bash
set -e
base=$(dirname $(dirname "${BASH_SOURCE[0]}"))

AUTH_HEADER="pen10"

docker build --build-arg=AUTH_HEADER=${AUTH_HEADER} -t flaskapp:latest -f $base/Dockerfile.python .

docker run -it -p 9091:9091 \
  -p 8080:8080 flaskapp:latest bash