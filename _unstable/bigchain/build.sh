#!/bin/bash

set -e

# Clone the repo from Git
if [[ ! -d bigchaindb ]]
then git clone https://github.com/bigchaindb/bigchaindb
     echo "/bigchaindb" >.gitignore
fi
# remove rethinkdb from deps
sed -i "s/'rethinkdb/#rethinkdb/" bigchaindb/setup.py

http_proxy="" docker build $@ .



