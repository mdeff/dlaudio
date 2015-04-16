#!/usr/bin/env bash
source /etc/bash_completion.d/virtualenvwrapper
rm -rf ~/.virtualenvs/dlaudio
mkvirtualenv --system-site-packages --python=python2.7 dlaudio
pip install --upgrade pyunlocbox
pip install --upgrade ipython pyzmq tornado jsonschema mistune
pip install --upgrade librosa scikits.samplerate
