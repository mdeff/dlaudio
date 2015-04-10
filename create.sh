#!/usr/bin/env bash
source /etc/bash_completion.d/virtualenvwrapper
rm -rf ~/.virtualenvs/dlaudio
mkvirtualenv --system-site-packages --python=python2.7 dlaudio
pip install --upgrade pyunlocbox ipython pyzmq tornado jsonschema mistune
