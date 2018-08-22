#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  if [ -n "$PYPI_PACKAGES" ] ; then
    pip install ${PYPI_PACKAGES/,/ }
  fi
  mkdir .jupyter
  cat >.jupyter/jupyter_notebook_config.py <<EOF 
c.NotebookApp.ip = '*'
c.NotebookApp.token = u''
EOF

  cat >.gitconfig <<EOF
[core]
attributesfile = ~/.gitattributes_global
[filter "nbstrip_full"]
clean = "jq --indent 1 \
        '(.cells[] | select(has(\"outputs\")) | .outputs) = []  \
        | (.cells[] | select(has(\"execution_count\")) | .execution_count) = null  \
        | .metadata = {\"language_info\": {\"name\": \"python\", \"pygments_lexer\": \"ipython3\"}} \
        | .cells[].metadata = {} \
        '"
smudge = cat
required = true
EOF

  cat >.gitattributes_global<<EOF
*.ipynb filter=nbstrip_full
EOF
  touch .setup
}

function _start {
  _setup
  su-exec jupyter jupyter-notebook --no-browser
}

case $1 in
  start) _start;;
  *)       exec $@;;
esac

