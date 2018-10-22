#!/bin/sh

if [ -n "$PACKAGES" ]; then
  echo "*** Installing packages ***"
  pip install ${PACKAGES/,/ }
fi

exec $@
