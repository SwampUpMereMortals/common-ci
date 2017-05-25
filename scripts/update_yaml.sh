#!/bin/bash

# this will later become a more friendly language and parse the actual yaml
YAML_FILE=$1
IMAGE_NAME=$2
IMAGE_TAG=$3

sed -ie "s%^\( *image: *.\).*\(.\)$%\1$IMAGE_NAME:$IMAGE_TAG\2%g" $YAML_FILE
