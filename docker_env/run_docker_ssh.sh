#!/bin/bash

# Add your Docker commands here
docker rm andreu_rpg_esim
docker run \
    --name andreu_rpg_esim \
    -it \
    -p 8896:8896 \
    -v /home/andreu/work/projects/research/POLED-BW_dev:/home/user/app \
    -v /home/andreu/datasets:/home/user/datasets \
    -v /petaco:/petaco \
    -v /home/andreu/work/andreu_utils:/home/user/global_utils \
    andreu_rpg_esim
