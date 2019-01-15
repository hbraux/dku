#!/bin/bash

case $1 in
  submit)  scala -cp $2;;
  *)       exec $@;;
esac

