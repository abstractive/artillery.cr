#!/bin/bash

shards install

echo "Compiling bin/artillery-mountpoint"
crystal build --release src/processes/artillery-mountpoint.cr -o bin/artillery-mountpoint

echo "Compiling bin/artillery-launcher"
crystal build --release src/processes/artillery-launcher.cr -o bin/artillery-launcher
