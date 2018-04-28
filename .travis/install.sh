#!/usr/bin/env bash

echo "Install dependencies"

composer install --no-interaction --no-scripts --prefer-dist --classmap-authoritative || exit $?
