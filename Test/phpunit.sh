#!/usr/bin/env bash
# the docker image to use for phpunit testing
DOCKER_IMAGE="devkba/cake2-app-template:staging"
# the path to prepend to the test case
TEST_PREFIX="Plugin/Filter/"
# compile PHPUnit parameters
PARAMS=""
for arg in "$@"; do
    # add prefix in case an argument is a path to a test
    if [[ "${arg}" == *Test.php ]]; then
        arg="${TEST_PREFIX}${arg}"
    fi
    # in case this is the first argument, don't add $IFS
    if [ "${PARAMS}" == "" ]; then
        PARAMS="${arg}"
    else
        PARAMS="${PARAMS}${IFS}${arg}"
    fi
done
# pull latest docker image
docker pull "${DOCKER_IMAGE}" || exit $?
# run actual PHPUnit inside docker container
docker run \
    --rm \
    --init \
    -it \
    -v "$(pwd)":/cakephp-filter-plugin \
    -e DEBUG=0 \
    -e BEFORE_SCRIPT="/cakephp-filter-plugin/Test/before_script.sh" \
    -e AFTER_SCRIPT="/cakephp-filter-plugin/Test/after_script.sh" \
    "${DOCKER_IMAGE}" vendor/bin/phpunit ${PARAMS}
