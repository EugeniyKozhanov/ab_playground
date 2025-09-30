#!/bin/bash

IMAGE_NAME="abtest_playground"

# check if the image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "Docker image $IMAGE_NAME not found. Building the image..."
  cd docker
  docker build --no-cache -t $IMAGE_NAME .
  cd ..
fi

docker run -it --rm \
  --privileged \
  -v $(pwd)/project_dir:/opt/project_dir \
  -v $(pwd)/board:/opt/board \
  $IMAGE_NAME 
