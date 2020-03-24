#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP PYTHON NOW OK THANKS"

apt-get install -y python-setuptools

# A crude install of Pipenv
curl https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py | python