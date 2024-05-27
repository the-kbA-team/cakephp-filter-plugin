#!/usr/bin/env sh
# start mysql database service
service mysql start
# create default database and user from cake2-app-template:/Config/.env.default
mysql -h localhost -u root -e "CREATE DATABASE database_name;CREATE DATABASE test_database_name;CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON * . * TO 'user'@'localhost';"
# use this repository symlinked into the app template
composer config repositories.cakephp-filter-plugin '{"type": "path", "url": "/cakephp-filter-plugin", "options": {"symlink": true}}'
# prevent composer from looking up packages on packagist.org
composer config repo.packagist false
# require the current dev version of the filter plugin
composer require --prefer-source kba-team/cakephp-filter-plugin:@dev
# Either use the test case from the parameter, or run all tests
if [ -n "${1}" ]; then
    # call PHPUnit and remember return code
    vendor/bin/phpunit "Plugin/Filter/${1}"
    E=$?
else
    (>&2 echo "ERROR: Missing test case!")
fi
# stop mysql service at the end of the tests
service mysql stop
# exit with the return code of phpunit
exit $E
