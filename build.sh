#!/bin/bash

# docker build -t fsharp:latest -f $(pwd)/Dockerfile.fsharp .
docker build -t flaskapp:latest -f $(pwd)/Dockerfile.python .
