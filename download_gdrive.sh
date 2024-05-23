#!/bin/bash

FILE_ID=$1
FILE_NAME=$2

# Function to download the file with a confirmation token
download_file() {
    CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
              "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- | \
              sed -rn 's/.confirm=([0-9A-Za-z_]+).*/\1\n/p')

    wget --load-cookies /tmp/cookies.txt \
         "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" \
         -O ${FILE_NAME} && rm -rf /tmp/cookies.txt
}

# Initial download attempt
wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
     "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O ${FILE_NAME}

# Check if the downloaded file is an HTML file
if grep -q '<html>' ${FILE_NAME}; then
    echo "First attempt failed, trying with confirmation token."
    # Remove the incorrect file
    rm ${FILE_NAME}
    # Retry with confirmation
    download_file
fi

# Final check to ensure the download was successful
if [[ ! -f "${FILE_NAME}" || ! -s "${FILE_NAME}" ]]; then
    echo "Download failed or file is empty: ${FILE_NAME}"
    exit 1
fi

# Call the Python script to extract confirmation code and download the file
python download_google_drive.py $FILE_ID $FILE_NAME
