#!/bin/bash
CONTAINER=$1

if [[ -n $CONTAINER ]]; then
  echo "Rebuilding $CONTAINER"
  docker-compose up -d --build $CONTAINER
else
  echo "Rebuilding..."
  docker-compose up -d --build mountpoint
  docker-compose up -d --build launcher
fi
