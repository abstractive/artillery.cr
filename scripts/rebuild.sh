#!/bin/bash
SERVICE_NAME=$1

if [[ -n $SERVICE_NAME ]]; then
  echo "Rebuilding $SERVICE_NAME"
  docker-compose up -d --build $SERVICE_NAME
else
  echo "Rebuilding..."
  docker-compose up -d --build mountpoint
  docker-compose up -d --build launcher
fi
