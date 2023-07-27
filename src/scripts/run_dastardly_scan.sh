#!/bin/bash
set +e
docker run --user "$(id -u)" --rm -v "$(pwd)":/dastardly -e DASTARDLY_TARGET_URL="$(circleci env subst "${PARAM_TARGET_URL}")" -e DASTARDLY_OUTPUT_FILE=/dastardly/"$(circleci env subst "${PARAM_OUTPUT_FILENAME}")" public.ecr.aws/portswigger/dastardly:latest
exitCode=$?
if [ "$exitCode" -eq 1 ] && [ "${PARAM_FAIL_ON_FAILURE}" -eq 0 ]
then
    exit 0
else
    exit "$exitCode"
fi