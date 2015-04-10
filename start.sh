#!/usr/bin/env bash
source /etc/bash_completion.d/virtualenvwrapper
workon dlaudio
ipython notebook --profile=dlaudio
