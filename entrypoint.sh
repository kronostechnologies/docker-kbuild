#!/bin/bash

groupadd -g ${GROUPID:-1000} docker
useradd -d /code/.kbuild -u ${USERID:-1000} -g ${GROUPID:-1000} docker

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
  sudo -u docker bash -c "kbuild $@"
else
  sudo -u docker bash -c "$@"
fi