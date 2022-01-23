#!/bin/bash

docker build -t flaskapp:latest -f $(pwd)/Dockerfile.python .
