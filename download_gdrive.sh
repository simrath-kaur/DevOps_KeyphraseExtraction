#!/bin/bash

FILE_ID=$1
DESTINATION=$2

# Create cookies file to store the confirmation token
curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null

# Extract the confirmation token
CONFIRM=$(awk '/download/ {print $NF}' /tmp/gcookie)

# Download the file using the confirmation token
curl -Lb /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o ${DESTINATION}
