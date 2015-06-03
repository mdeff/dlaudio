#!/usr/bin/env bash

source /etc/bash_completion.d/virtualenvwrapper
workon dlaudio

# Execute via IPython (default timeout is 30s per cell).
ipython nbconvert --to=html --ExecutePreprocessor.enabled=True --ExecutePreprocessor.timeout=1000000 $1 > log.txt 2>&1

# Execute via Python.
#ipython3 nbconvert --to python $1
#python3 "${1%.ipynb}.py"
