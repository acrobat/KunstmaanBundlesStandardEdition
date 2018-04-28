#!/usr/bin/env bash

echo "Prepare behat environment"

# Configure display
/sbin/start-stop-daemon --start --quiet --pidfile /tmp/xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1680x1050x16
export DISPLAY=:99

chromium-browser --version

# Download and configure ChromeDriver
if [ ! -f $BUILD_CACHE_DIR/chromedriver ]; then
    # Using ChromeDriver 2.33 which supports Chrome 60-62, we're using Chromium 60
    curl http://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip > chromedriver.zip
    unzip chromedriver.zip
    mv chromedriver $BUILD_CACHE_DIR
fi

# Run Selenium with ChromeDriver
echo "Start selenium"
PATH=$PATH:$BUILD_CACHE_DIR vendor/bin/selenium-server-standalone > $TRAVIS_BUILD_DIR/selenium.log 2>&1 &

echo "Setup application"

mysql -e 'create database IF NOT EXISTS kunstmaanbundles;'
cp app/config/parameters.yml.dist app/config/parameters.yml
sed -i 's/dbuser/travis/g' app/config/parameters.yml

bin/console doctrine:schema:drop --env=dev --force --no-interaction
bin/console doctrine:schema:create --env=dev --no-interaction

#bin/console doctrine:database:create --env=test_travis -vvv || exit $?
#bin/console cache:warmup --env=test_travis --no-debug -vvv || exit $?
#bin/console doctrine:schema:update --force --env=test_travis || exit $?

echo "Setting the web assets up"
bin/console assets:install --env=test_travis --no-debug -vvv || exit $?
