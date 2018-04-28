#!/usr/bin/env bash

#cp "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/files/behat-travis.yml" ./behat.yml

# this checks that the YAML config files contain no syntax errors
bin/console lint:yaml app/config || exit $?
# this checks that the composer.json and composer.lock files are valid
#composer validate --strict || exit $?

chmod -R 777 .travis/build

bin/console kuma:generate:bundle --namespace="MyProject\\WebsiteBundle" --dir=src --no-interaction
bin/console kuma:generate:default-site --namespace="MyProject\\WebsiteBundle" --prefix="myproject_" --demosite --browsersync=kunstmaanbundlescms.dev --articleoverviewpageparent="HomePage,ContentPage" --no-interaction
bundle install
npm install
bower install
gulp build || grunt build
bin/console doctrine:schema:drop --env=dev --force --no-interaction
bin/console doctrine:schema:create --env=dev --no-interaction
bin/console doctrine:fixtures:load --env=dev --no-interaction
bin/console kuma:generate:admin-tests --namespace="MyProject\\WebsiteBundle"
sudo ln -s $(which sass) /usr/local/bin/sass
bin/console assets:install --env=test --no-interaction
bin/console assetic:dump --env=test --no-interaction
bin/console cache:clear --env=test  --no-interaction
bin/console cache:warmup --env=test --no-interaction
#chmod -R 777 var/cache/ var/logs/
bin/console server:start
php -d memory_limit=2048M bin/behat --suite=default --strict -f progress || exit $?
bin/console server:stop



# Run webserver
#bin/console server:run 127.0.0.1:8080 --env=test_travis --router=app/config/router_test_travis.php --no-debug --quiet > /dev/null 2>&1 &

# Run behat tests
#vendor/bin/behat --strict -f progress || exit $?
