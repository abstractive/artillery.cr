#!/bin/bash

docker-compose up -d
./scale.sh
./console.sh