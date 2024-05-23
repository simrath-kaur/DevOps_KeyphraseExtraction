#!/bin/bash

FILE_ID=$1
FILE_NAME=$2

# Fetching the confirmation token
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+).*/\1\n/p')

# Downloading the file using the confirmation token
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -O ${FILE_NAME} && rm -rf /tmp/cookies.txt

# Check if the download was successful
if [[ ! -f "${FILE_NAME}" || ! -s "${FILE_NAME}" ]]; then
  echo "Download failed or file is empty: ${FILE_NAME}"
  exit 1
fi
