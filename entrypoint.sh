#!/bin/bash

addgroup -g ${GROUPID:-1000} docker
adduser -h /code/.kbuild -u ${USERID:-1000} -G docker -D docker

if [[ ! -z "$COMPOSER_API_KEY" ]]; then
  sudo -u docker composer config -g github-oauth.github.com $COMPOSER_API_KEY
fi

if [[ -z "$@" ]]; then
cat << EOF
    Usage

    --dev      run kbuild --dev
    --release  run kbuild --release
    ...        run any command in kbuild image (npm, bower, composer, grunt)

EOF
elif [[ "$@" == --* ]]; then
  sudo -u docker kbuild $@
else
  sudo -u docker $@
fi
