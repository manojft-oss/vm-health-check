#!/bin/bash

echo "Allocating memory..."
MEM_HOG=$(head -c 1G </dev/zero | tr '\0' 'x')
sleep 60
unset MEM_HOG
echo "Released memory."


