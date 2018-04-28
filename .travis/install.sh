#!/usr/bin/env bash

echo "Install dependencies"

#composer install --no-interaction --no-scripts --prefer-dist --classmap-authoritative || exit $?
composer install --no-interaction --no-scripts --prefer-dist || exit $?

# Setup frontend dependencies
npm set progress=false
gem install sass
npm install -g bower
npm install grunt
npm install grunt-cli
npm install uglify-js
npm install uglifycss
