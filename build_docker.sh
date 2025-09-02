#!/bin/bash

# Build docker image
docker build --no-cache -t andreu_rpg_esim:latest -f docker_env/Dockerfile .