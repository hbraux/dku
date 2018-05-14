#!/bin/bash
# KAFKA JSON message generator

TOOL_NAME=kafka-json
TOOL_VERS=0.1.15

##################################################
# BEGIN: common.sh 1.8
##################################################
# expect TOOL_NAME and TOOL_VERS to be defined in header
[[ -n $TOOL_NAME ]] || TOOL_NAME=$0

# config file
declare CfgFile=$(dirname $0)/.${TOOL_NAME}.cfg

# tmp file and dir to be used in the code
declare TmpFile=$HOME/tmp.${TOOL_NAME}_f$$
declare TmpDir=$HOME/tmp.${TOOL_NAME}_d$$

# command line options
declare -A _Opts

# colors
declare Black="\e[m"
declare Red="\e[0;31m"
declare Green="\e[0;32m"
declare Blue="\e[0;34m"
declare Purple="\e[0;35m"

# log functions
function debug {
  opt D && echo -e "${Blue}# $*${Black}"
}
function info {
  echo -e "$*"
}
function warn {
  echo -e "${Purple}WARNING: $*${Black}"
}
function error {
  echo -e "${Red}ERROR: $*${Black}"
}

# quit: replace exit. cleanup tmp
function quit {
  if [[ $# -eq 0 ]]
  then exitcode=0
  else exitcode=$1
  fi
  [[ -f $TmpFile ]] && rm -f $TmpFile
  [[ -d $TmpDir ]] && rm -fr $TmpDir
  exit $exitcode
}

# die: quit with error message
function die {
  if [[ $# -eq 0 ]]
  then error "command failed"
  else error "$*"
  fi
  quit 1
}

# load config file and check expected variables 
function load_cfg {
  if [[ -f $CfgFile ]]
  then 
     . $CfgFile || die "cannot load $CfgFile"
     for var in $*
     do eval "val=\$$var"
        [[ -z $val ]] && die "cannot find $var in file $Cfgfile"
     done
  else [[ $# -eq 0 ]] || die "file $CfgFile is missing"
  fi
}

# read options -x in command line
function read_opts {
  if [[ ${#_Opts[@]} -eq 0 ]]
  then for ((i=1; i<${#1}; i++ ))
       do _Opts[${1:$i:1}]=0
       done
       # option Debug (-D) is always supported
      _Opts[D]=0
  fi
  # ignore options --param
  [[ ${2:0:2} == '--' ]] && return 1
  if [[ ${2:0:1} == '-' ]]
  then [[ -n ${_Opts[${2:1}]} ]] || die "option $2 not supported"
       _Opts[${2:1}]=1
  else return 1
  fi 
}

# check if option -x was set
function opt {
  [[ -n ${_Opts[${1}]} ]] || die "(bash) missing option -$1 in read_opts"
  [[ ${_Opts[${1}]} -eq 1 ]] || return 1
}


# file cheksum, updated when commiting in Git
_MD5SUM="1b2ccd49b615f4b19762b6871000523d"

# about display tool name and version
function about {
  suffix=""
  [[ $(egrep -v '^_MD5SUM=' $0 | /usr/bin/md5sum | sed 's/ .*//') \
      != $_MD5SUM ]] && suffix=".draft"
  echo "$TOOL_NAME $TOOL_VERS$suffix"
}

##################################################
# END: common.sh
##################################################


# ------------------------------------------
# Constants
# ------------------------------------------

POST_EVERY=10000
COUNT_EVERY=1000
SAVE_FILE=output.json

# ------------------------------------------
# Global Variables
# ------------------------------------------

declare -i Verbose=0
declare -i Delay=0
declare -i Count=1
declare -i Save=0
declare Brokers
declare Protocol=""

# ------------------------------------------
# usage
# ------------------------------------------

function usage {
  echo "JSON message generator and producer for Kafka

Syntax: $TOOL_NAME.sh [-opts] <brokers> <topic> <key>=<value> <key>=<value> ...

<brokers> is optional when variable \$SITE_KAFKA is set

Supported options:
  --save    : save messages to output.json
  --count N : generate N messages
  --delay D : delay in seconds between each message (none by default)

Supported values:
 - string (no quote, no space)
 - number (digits string)
 - %seq   : incremental sequence, starting at 1000000
 - %uuid  : uuid  
 - %now   : current date in ISO8601 format
 - %rands : random string
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
  # concatenate all args and convrts to JSON
  msg=$(echo $* | sed -e 's/ /~,~/g' -e 's/=/~:~/g' -e 's/^/{~/' -e 's/$/~}/' -e 's/:~\([0-9]\+\)~/:\1/g' -e 's/~\%randi~/%randi/g' -e 's/~\%seq~/%seq/g' -e 's/%/$/g') 
  seq=0
  n=0
  seq=1000000
  randomchars=$(head -1000 /dev/urandom | tr -dc [:alnum:])
  [[ $Delay -eq 0 ]] && [[ $Count -ge $COUNT_EVERY ]] && info "Generating messages ... \c"
  countpercent=$(($Count / 100))
  [[ $Save -eq 1 ]] && rm -f $SAVE_FILE
  while [[ $n -lt $Count ]]
  do
      n=$((n + 1))
      seq=$((seq + 1))
      now=$(date '+%FT%H:%M:%S')
      uuid=$(cat /proc/sys/kernel/random/uuid)
      rands=${randomchars:$RANDOM:20}
      randi=$RANDOM
      eval "json=$msg"
      json=${json//\~/\"}
      if [[ $Delay -gt 0 ]] 
      then [[ $Save -eq 1 ]] && echo $json >>$SAVE_FILE
	   echo $json | kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic >/dev/null 
	   sleep $Delay
      else echo $json >>$TmpFile
	   [[ $Save -eq 1 ]] && echo $json >>$SAVE_FILE
	   [[ $((n % $COUNT_EVERY)) -eq 0 ]] && info "$(($n / $countpercent))% \c"
	   if [[ $((n % $POST_EVERY)) -eq 0 ]]
	   then info "(posting) \c"
	        kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic --request-required-acks 1 <$TmpFile >/dev/null
		rm -f $TmpFile
	   fi
      fi
  done
  # bulk produce
  if [[ -f $TmpFile ]] 
  then [[ $Delay -eq 0 ]] && [[ $Count -ge $COUNT_EVERY ]] && info "(posting)"
       opt D && cp -f $TmpFile out.json
       kafka-console-producer.sh --broker-list $Brokers $Protocol --topic $topic --request-required-acks 1 <$TmpFile >/dev/null
       info "Done"
  fi

}

# ------------------------------------------
# Command line
# ------------------------------------------

about
while read_opts -D $1; do shift ;done

while [[ ${1:0:2} == -- ]]
do 
  case ${1:2} in 
    count) Count=$2; shift;;
    delay) Delay=$2; shift;;
    save)  Save=1;;
    *) usage;
  esac
  shift
done

[[ $# -ge 2 ]] || usage

if [[ -n $SITE_KAFKA ]]
then echo "$1" | grep -q ':'
     if [ $? -eq 0 ]
     then Brokers=$1;  shift
     else Brokers=$SITE_KAFKA
     fi
     [[ -n $KAFKA_CLIENT_KERBEROS_PARAMS ]] \
       && Protocol="--security-protocol SASL_SSL"
else Brokers=$1;  shift
fi

[[ $# -ge 2 ]] || usage

which kafka-console-producer.sh >/dev/null 2>&1
if [ $? -ne 0 ]
then [ -x /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh ] \
  || die "Cannot find PATH to kafka-console-producer.sh"
  PATH=/usr/hdp/current/kafka-broker/bin:$PATH
fi

json $@
quit
