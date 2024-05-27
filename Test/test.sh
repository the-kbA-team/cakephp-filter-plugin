#!/usr/bin/env sh

phpdismod xdebug;

service mysql start

mysql -h localhost -u root -e "CREATE DATABASE database_name;CREATE DATABASE test_database_name;CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON * . * TO 'user'@'localhost';"

composer config repositories.cakephp-filter-plugin '{"type": "path", "url": "/cakephp-filter-plugin", "options": {"symlink": true}}'
composer config repo.packagist false
composer require --prefer-source kba-team/cakephp-filter-plugin:@dev
vendor/bin/phpunit Plugin/Filter/Test/Case/Controller/Component/FilterComponentTest.php
E=$?
service mysql stop
exit $E
