#!/bin/sh

function _setup {
  [ -f .setup ] && return

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

if [ -n "${EXTRA_PACKAGES}" ]; then
  if [ -n "${PYPI_MIRROR}" ]; then
    pip install -i ${PYPI_MIRROR} ${EXTRA_PACKAGES/,/ }
  else
    pip install ${EXTRA_PACKAGES/,/ }
  fi
fi

case $1 in
  start) _start;;
  console) exec jupyter console;;
  *)       exec $@;;
esac

