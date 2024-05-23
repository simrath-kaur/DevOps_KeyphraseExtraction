# #!/bin/bash

# FILE_ID=$1
# DESTINATION=$2

# # Create cookies file to store the confirmation token
# curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null

# # Extract the confirmation token
# CONFIRM=$(awk '/download/ {print $NF}' /tmp/gcookie)

# # Download the file using the confirmation token
# curl -Lb /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o ${DESTINATION}

#!/bin/bash

FILE_ID=$1
FILE_NAME=$2

# Fetching the confirmation token
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+).*/\1\n/p')

# Downloading the file using the confirmation token
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -O ${FILE_NAME} && rm -rf /tmp/cookies.txt
