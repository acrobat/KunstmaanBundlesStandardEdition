#!/usr/bin/env bash

vendor/bin/upload-textfiles "${TRAVIS_BUILD_DIR}/*.log"

echo "Uploading behat failed step screenshots..."

# Please generate a client key for yourself and don't use ours to avoid reaching the rate limit.
clientid='6747e004f45c83a'

for image in ${TRAVIS_BUILD_DIR}/*.png
do
    res=$(curl -sH "Authorization: Client-ID $clientid" -F "image=@$image" "https://api.imgur.com/3/upload")

    echo $res | grep -qo '"status":200' && link=$(echo $res | sed -e 's/.*"link":"\([^"]*\).*/\1/' -e 's/\\//g')

    #Print uploaded image url
    echo $link
done
