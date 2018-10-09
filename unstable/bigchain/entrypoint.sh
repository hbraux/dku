#!/bin/bash

function _setup {
  export BIGCHAINDB_CONFIG_PATH=/data/.bigchaindb
  if [[ ! -f .setup ]]
  then 
    # configure Tendermint 
    mkdir -p $TMHOME/config
    [[ -n $VALIDATOR ]] && echo $VALIDATOR >$TMHOME/config/priv_validator.json
    tendermint init 
    sed -i "s/\"chain_id\":.*/\"chain_id\":\"${CHAIN_ID}\",/" $TMHOME/config/genesis.json
    sed -i "s/\"genesis_time\":.*/\"chain_id\":\"${GENESIS_TIME}\",/" $TMHOME/config/genesis.json
    if [[ -n $VALIDATOR_KEYS  ]]
    then 
      for key in $(echo ${KEYRING/,/ /}) 
      do grep -q $key $TMHOME/config/genesis.json || sed  -i "5i{\"pub_key\": {\"type\":\"AC26791624DE60\",\"value\": \"$key\"},\"power\": 10,\"name\": \"\"}," $TMHOME/config/genesis.json
      done
    fi

    # configure BigchainDB
    export BIGCHAINDB_SERVER_WORKERS=1
    export BIGCHAINDB_SERVER_BIND=0.0.0.0:9984
    export BIGCHAINDB_WSSERVER_HOST=0.0.0.0
    export BIGCHAINDB_WSSERVER_ADVERTISED_HOST=0.0.0.0 
    export BIGCHAINDB_TENDERMINT_PORT=46657
    bigchaindb -y configure localmongodb
    touch .setup
  else
    if [[ -n $BIGCHAINDB_KEYRING ]]
    then sed -i "s/\"keyring\":.*/\"keyring\": [\"$BIGCHAINDB_KEYRING\"]/" $BIGCHAINDB_CONFIG_PATH
    fi
  fi
}

export -f _setup

function _start {
  _setup
  # start MongoDB
  mongod --smallfiles --oplogSize 128 &
  # start Tendermint withoup p2p exchange
  tendermint  node --p2p.pex=false --rpc.unsafe --consensus.create_empty_blocks=false &
  exec bigchaindb start
}

case $1 in
  start)  _start;;
  shell)  exec mongo --host ${SERVER_NAME};;
  *)      exec $@;;
esac


