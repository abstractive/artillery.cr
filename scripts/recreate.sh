#!/bin/bash
CONTAINER=$1
if [[ -n $CONTAINER ]]; then
  docker-compose up -d --force-recreate --build $CONTAINER
  ./scripts/scale.sh $CONTAINER
else
  docker-compose up --force-recreate -d
  ./scripts/scale.sh
fi
./scripts/console.sh