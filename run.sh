#!/usr/bin/env bash

# Parameters:
# 1) Name of the notebook.
# 2) Output format, e.g. html or notebook.

source /etc/bash_completion.d/virtualenvwrapper
workon dlaudio

# Execute via IPython (default timeout is 30s per cell).
ipython nbconvert --to=$2 --ExecutePreprocessor.enabled=True --ExecutePreprocessor.timeout=1000000 $1 > log.txt 2>&1

# Execute via Python.
#ipython3 nbconvert --to python $1
#python3 "${1%.ipynb}.py"
