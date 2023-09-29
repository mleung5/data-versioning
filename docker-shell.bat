
REM set BASE_DIR=$(pwd)
set BASE_DIR=%CD%%
REM echo %BASE_DIR%

REM set SECRETS_DIR=$(pwd)/../secrets/
set SECRETS_DIR=%BASE_DIR%\..\secrets
REM echo %SECRETS_DIR%

REM set GCS_BUCKET_NAME="lec5_bucket"
set GCS_BUCKET_NAME=lec5_bucket
echo %GCS_BUCKET_NAME%

REM set GCP_PROJECT="AC215-mleung"
SET GCP_PROJECT=AC215-mleung

REM set GCP_ZONE="us-central1-a"
SET GCP_ZONE=us-central1-a

REM Create the network if we don't have it yet
docker network inspect data-versioning-network >/dev/null 2>&1 || docker network create data-versioning-network

REM Build the image based on the Dockerfile
docker build -t data-version-cli -f Dockerfile .

REM Run Container
@REM docker run --rm --name data-version-cli -ti \
@REM -v "$BASE_DIR":/app \
@REM -v "$SECRETS_DIR":/secrets \
@REM -e GOOGLE_APPLICATION_CREDENTIALS=/secrets/data-service-account.json \
@REM -e GCP_PROJECT="AC215-mleung" \
@REM -e GCP_ZONE="us-central1-a" \
@REM --network data-versioning-network data-version-cli

docker run --rm --name data-version-cli -ti ^
-v "%BASE_DIR%:/app" ^
-v "%SECRETS_DIR%:/secrets" ^
-v "~/.gitconfig:/etc/gitconfig" ^
-e GOOGLE_APPLICATION_CREDENTIALS=/secrets/data-service-account.json ^
-e GCP_PROJECT=%GCP_PROJECT% ^
-e GCP_ZONE=%GCP_ZONE% ^
-e GCS_BUCKET_NAME=%GCS_BUCKET_NAME% ^
--network data-versioning-network data-version-cli
