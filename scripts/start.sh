#!/bin/bash

docker-compose up -d
./scripts/scale.sh
./scripts/console.sh