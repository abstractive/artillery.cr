#!/bin/bash
CONTAINER=$1
if [[ -n $CONTAINER ]]; then
  docker-compose up -d --force-recreate --build $CONTAINER
  ./scale.sh $CONTAINER
else
  docker-compose up --force-recreate -d
  ./scale.sh
fi
./console.sh