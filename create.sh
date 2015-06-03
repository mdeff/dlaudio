#!/usr/bin/env bash
rm -rf ~/.virtualenvs/dlaudio
rm -rf pyu_repo pyunlocbox

source /etc/bash_completion.d/virtualenvwrapper
mkvirtualenv --system-site-packages --python=/usr/bin/python2.7 dlaudio
#mkvirtualenv --system-site-packages --python=/usr/bin/python3 dlaudio

# Audio processing.
pip install scikits.samplerate
pip install librosa
#git clone https://github.com/bmcfee/librosa.git  # If using Python 3.

# Latest notebook format.
pip install --upgrade ipython
pip install pyzmq tornado jsonschema mistune  # If not available.

# HDF5.
pip install h5py

# PyUNLocBoX.
#pip install --upgrade pyunlocbox
git clone https://github.com/epfl-lts2/pyunlocbox.git pyu_repo
ln -s pyu_repo/pyunlocbox pyunlocbox

# Profiling.
pip install line_profiler
pip install memory_profiler
pip install objgraph

#mkdir data; cd data
#wget http://opihi.cs.uvic.ca/sound/genres.tar.gz
#tar -zxvf genres.tar.gz
