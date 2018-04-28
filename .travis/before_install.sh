#!/usr/bin/env bash

echo "extension = memcached.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/travis.ini

cp /home/travis/.phpenv/versions/$(phpenv version-name)/etc/conf.d/xdebug.ini ~/xdebug.ini
# Disable XDebug
phpenv config-rm xdebug.ini || exit $?
# Create build cache directory
mkdir -p \"${BUILD_CACHE_DIR}\" || exit $?

# No memory limit for running the behat tests
echo "memory_limit = -1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/travis.ini

# Update composer to the latest stable release as the build env version is outdated
composer self-update --stable || exit $?

# TODO: check if still needed
google-chrome-stable --headless --disable-gpu --remote-debugging-port=9222 http://localhost &
