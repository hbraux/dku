#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  mkdir -p $HOME/.jupyter/
  cat > $HOME/.jupyter/jupyter_notebook_config.py <<EOF 
c.NotebookApp.ip = '*'
c.NotebookApp.token = u''
EOF
  touch .setup
}

function _start {
  _setup
  exec jupyter notebook --no-browser
}

case $1 in
  start) _start;;
  *)       exec $@;;
esac

