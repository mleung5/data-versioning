#!/bin/bash

#################################
## need to run "source docker-shell.sh" using source instead of sh
## so that the environment variables can still within the current session.
##
## need to take the following out
#set -e

export BASE_DIR=$(pwd)
export SECRETS_DIR=$(pwd)/../secrets/
export GCS_BUCKET_NAME="lec5_bucket"
export GCP_PROJECT="AC215-mleung"
export GCP_ZONE="us-central1-a"

# Create the network if we don't have it yet
docker network inspect data-versioning-network >/dev/null 2>&1 || docker network create data-versioning-network

# Build the image based on the Dockerfile
docker build -t data-version-cli --platform=linux/arm64/v8 -f Dockerfile .

# Run Container
# docker run --rm --name data-version-cli -ti \
## not sure why this winpty is needed before docker run command
winpty docker run --rm --name data-version-cli -ti \
-v "$BASE_DIR":/app \
-v "$SECRETS_DIR":/secrets \
-v ~/.gitconfig:/etc/gitconfig \
-e GOOGLE_APPLICATION_CREDENTIALS=../secrets/data-service-account.json \
-e GCP_PROJECT=$GCP_PROJECT \
-e GCP_ZONE=$GCP_ZONE \
-e GCS_BUCKET_NAME=$GCS_BUCKET_NAME \
--network data-versioning-network data-version-cli

## needs to add ../ to path so that /secrets/data-service-account.json is visible
## otherwise wrong path is resulted File C:/Program Files/Git/secrets/data-service-account.json