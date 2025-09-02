#!/bin/bash

# Add your Docker commands here
docker rm andreu_rpg_esim
docker run \
    --name andreu_rpg_esim \
    --gpus '"device=1"' \
    -it \
    andreu_rpg_esim
