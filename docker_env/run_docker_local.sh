#!/bin/bash

# Add your Docker commands here
docker rm andreu_rpg_esim
docker run \
    --name andreu_rpg_esim \
    -it \
    -e DISPLAY=host.docker.internal:0 \
    -e LIBGL_ALWAYS_INDIRECT=1 \
    -e QMLSCENE_DEVICE=softwarecontext \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    andreu_rpg_esim