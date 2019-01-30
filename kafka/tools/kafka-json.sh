#!/bin/bash
# KAFKA JSON message generator
# THIS TOOL IS OBSOLETE. USE THE PYTHON VERSION

TOOL_NAME=kafka-json

# ------------------------------------------
# Constants
# ------------------------------------------

COUNT_EVERY=1000
SAVE_FILE=output.json

# ------------------------------------------
# Global Variables
# ------------------------------------------

declare -i Delay=0
declare -i Count=1
declare -i Console=0
declare -i Post=10000
declare Brokers
declare Protocol=""

# ------------------------------------------
# usage
# ------------------------------------------

function usage {
  echo "JSON message generator and producer for Kafka

Syntax: $TOOL_NAME.sh [options] [BROKERS] TOPIC KEY=VALUE KEY=VALUE ...

When BROKERS is not provided environment variable \$SITE_KAFKA is used

Supported options:
  --console : output messages to console (do not publish)
  --count N : generate N messages
  --post  P : post messages every P messages (default is 10000)
  --delay D : delay in seconds between each message (none by default)

Supported values:
 - string (no quote, no space)
 - number (digits string)
 - %seq   : incremental sequence, starting at 1000000
 - %uuid  : uuid  
 - %now   : current date in ISO8601 format
 - %randk : random key (10 char)
 - %rands : random string (40 char)
 - %randi : random integer
"
  exit
}


# ------------------------------------------
# Main function
# ------------------------------------------

function json {
  topic=$1
  shift

  # concatenate all args and converts to JSON
  msg=$(echo $* | sed -e 's/ /~,~/g' -e 's/=/~:~/g' -e 's/^/{~/' -e 's/$/~}/' -e 's/:~\([0-9]\+\)~/:\1/g' -e 's/~\%randi~/%randi/g' -e 's/~\%seq~/%seq/g' -e 's/%/$/g') 
  seq=0
  n=0
  seq=1000000
  randomchars=$(head -1000 /dev/urandom | tr -dc [:alnum:])
  [[ $Delay -eq 0 ]] && [[ $Count -ge $COUNT_EVERY ]] && echo -e "Generating messages ... \c"
  countpercent=$(($Count / 100))
  tmpfile=$HOME/tmp.${TOOL_NAME}_f$$
  while [[ $n -lt $Count ]]; do
    n=$((n + 1))
    seq=$((seq + 1))
    now=$(date '+%FT%H:%M:%S')
    uuid=$(cat /proc/sys/kernel/random/uuid)
    randk=${randomchars:$RANDOM:10}
    rands=${randomchars:$RANDOM:40}
    randi=$RANDOM
    eval "json=$msg"
    json=${json//\~/\"}
    if [[ $Delay -gt 0 ]]; then
      if [[ $Console -eq 1 ]]; then
	echo $json
      else
	echo $json | kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic >/dev/null 
      fi
      sleep $Delay
    else 
      echo $json >>$tmpfile
      if [[ $Console -eq  0 ]]; then
	[[ $((n % $COUNT_EVERY)) -eq 0 ]] && echo -e "$(($n / $countpercent))% \c"
	if [[ $((n % $Post)) -eq 0 ]]; then 
	  echo -e "(posting) \c"
	  kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic --request-required-acks 1 <$tmpfile >/dev/null
	  rm -f $tmpfile
	fi
      fi
    fi
  done
  # bulk produce
  if [[ -f $tmpfile ]]; then     
    if [[ $Console -eq 1 ]]; then
      cat $tmpfile
    else
      [[ $Delay -eq 0 && $Count -ge $COUNT_EVERY ]] && echo -e "(posting)"
      kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic --request-required-acks 1 <$tmpfile >/dev/null
    fi
    rm -f $tmpfile
  fi
}

# ------------------------------------------
# Command line
# ------------------------------------------

while [[ ${1:0:2} == -- ]]
do 
  case ${1:2} in 
    count) Count=$2; shift;;
    delay) Delay=$2; shift;;
    post)  Post=$2; shift;;
    console)  Console=1;;
    *) usage;
  esac
  shift
done

[[ $# -ge 2 ]] || usage

if [[ -n $SITE_KAFKA ]]; then 
  echo "$1" | grep -q ':'
  if [[ $? -eq 0 ]]; then
    Brokers=$1
    shift
  else
    Brokers=$SITE_KAFKA
  fi
  [[ -n $KAFKA_CLIENT_KERBEROS_PARAMS ]] \
    && Protocol="--security-protocol SASL_SSL"
else 
  echo "$1" | grep -q ':'
  if [[ $? -eq 0 ]]; then
    Brokers=$1
    shift
  else
    echo "BROKERS shall be server:port[,server:port,..]" ; exit 1
  fi
fi

[[ $# -ge 2 ]] || usage

if [[ $Console -eq 0 ]]; then
  which kafka-console-producer.sh >/dev/null 2>&1
  if [[ $? != 0 ]] 
  then [ -x /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh ] \
    || echo "Cannot find PATH to kafka-console-producer.sh" &&  exit 1
    PATH=/usr/hdp/current/kafka-broker/bin:$PATH
  fi
fi
json $@
