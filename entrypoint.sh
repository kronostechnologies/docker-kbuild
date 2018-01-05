#!/bin/bash

[[ -n $(getent group "${GROUPID}") ]] && getent group ${GROUPID} | awk -F: '{ print $1 }' |xargs delgroup

groupadd -o -g ${GROUPID:-1000} docker
useradd -o -d /code/.kbuild -u ${USERID:-1000} -g docker -M docker

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
  exec sudo -u docker kbuild "$@"
else
  exec sudo -u docker "$@"
fi
