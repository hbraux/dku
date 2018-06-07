#!/bin/bash
# A docker helper to build, run and manage Docker images

TOOL_NAME=docker-util
TOOL_VERS=0.0.5

###############################################################################
# BEGIN: common.sh 2.3
###############################################################################
# Warning versions 2.x are not compatible with 1.x

[[ -n $TOOL_NAME ]] || TOOL_NAME=${0/.sh/}

# -----------------------------------------------------------------------------
# Shell Colors
# -----------------------------------------------------------------------------
declare BLACK="\e[m"
declare RED="\e[1;31m"
declare GREEN="\e[0;32m"
declare BLUE="\e[0;34m"
declare PURPLE="\e[1;35m"
declare BOLD="\e[1;30m"

# -----------------------------------------------------------------------------
# Global variables that can be used anywhere
# -----------------------------------------------------------------------------

# Temporary File and Directory (purged on exit)
declare TmpFile=$HOME/tmp.${TOOL_NAME}_f$$
declare TmpDir=$HOME/tmp.${TOOL_NAME}_d$$

# Log file (appending)
declare LogFile=${TOOL_NAME}.log
# by defaults logs are in current directory unless there's a logs directory
[[ -d $HOME/logs ]] && LogFile=$HOME/logs/$LogFile

# command line parameters
declare Command=
declare Arguments=

# -----------------------------------------------------------------------------
# Internal variables (reserved for common part)
# -----------------------------------------------------------------------------

# file cheksum, updated when commiting in Git
_MD5SUM="c5aab26a3b0714c329670a7a5991c6e5"

# config file
declare _CfgFile=$(dirname $0)/.${TOOL_NAME}.cfg

# command line Options
declare -A _Opts

# -----------------------------------------------------------------------------
# Log functions
# -----------------------------------------------------------------------------
# logging is by default to stdout, unless -L is specified

function _log {
  level=$1
  shift
  dt=$(date +'%F %T')
  echo -e "$level\t$dt\t$*" >>$LogFile
}

function debug {
  [[ ${_Opts[D]} -eq 1 ]] || return
  [[ ${_Opts[L]} -eq 1 ]] && _log DEBUG $* && return
  echo -e "${BLUE}# $*${BLACK}"
}
function info {
  [[ ${_Opts[L]} -eq 1 ]] && _log INFO $* && return
  echo -e "${BOLD}$*${BLACK}"
}
function warn {
  [[ ${_Opts[L]} -eq 1 ]] && _log WARN $* && return
  echo -e "${PURPLE}WARNING: $*${BLACK}"
}
function error {
  [[ ${_Opts[L]} -eq 1 ]] &&  _log ERROR $* 
  # always print errors to stdout
  echo -e "${RED}ERROR: $*${BLACK}"
}

# -----------------------------------------------------------------------------
# quit and die functions
# -----------------------------------------------------------------------------

function quit {
  if [[ $# -eq 0 ]]
  then exitcode=0
  else exitcode=$1
  fi
  [[ -f $TmpFile ]] && rm -f $TmpFile
  [[ -d $TmpDir ]] && rm -fr $TmpDir
  exit $exitcode
}

function die {
  if [[ $# -eq 0 ]]
  then error "command failed"
  else error "$*"
  fi
  quit 1
}

# -----------------------------------------------------------------------------
# internal functions
# -----------------------------------------------------------------------------

# load config file and check expected variables 
function _loadcfg {
  if [[ -f $_CfgFile ]]
  then 
     # check that syntax is consistent
     [[ $(egrep -v '^#' $_CfgFile | egrep -v '^[ ]*$' | egrep -vc '^[A-Z_]*_=') -eq 0 ]] || die "Config file $_CfgFile is not correct"
     # load by sourcing it (stop on error)
     set -e 
     . $_CfgFile 
     set +e
  fi
}

# set supported options 
function _setopts {
  for ((i=0; i<${#1}; i++ ))
  do _Opts[${1:$i:1}]=0
  done
  # option Debug (-D) and Log (-L) are always supported
  _Opts[D]=0
  _Opts[L]=0
}

# read options -X in command line
function _readopts {
  # ignore arguments --xxx
  [[ ${1:0:2} == -- ]] && return 1
  if [[ ${1:0:1} == - ]]
  then
    for ((i=1; i<${#1}; i++ ))
    do o=${1:$i:1}
       [[ -n ${_Opts[$o]} ]] || die "option -$o not supported by $TOOL_NAME"
       _Opts[$o]=1
    done
  else return 1
  fi 
}

# display tool name and version
function _about {
  suffix=""
  [[ $(egrep -v '^_MD5SUM=' $0 | /usr/bin/md5sum | sed 's/ .*//') \
      != $_MD5SUM ]] && suffix=".draft"
  echo "# $TOOL_NAME $TOOL_VERS$suffix"
}

# -----------------------------------------------------------------------------
# public functions
# -----------------------------------------------------------------------------

# opt X check if option -X was set (return 0 if true) 
function opt {
  if [[ -z ${_Opts[${1}]} ]]
  then echo -e "${RED}CODE ERROR: missing option -$1 in init${BLACK}"; exit 1
  fi
  [[ ${_Opts[${1}]} -eq 1 ]] || return 1
}


# analyse command line and set $Command $Arguments and options
# the first arguments are supported options, the second $@ 
function init {
  _about
  if [[ ${1:0:1} == - ]]
  then _setopts ${1:1} ; shift
  fi
  [[ $# -eq 0 ]] && usage
  _loadcfg
  cmdline=$@
  Command=$1
  shift
  # read options (support -abc but also -a -b -c)
  while _readopts $1
  do shift ;done
  Arguments=$@
  opt L && _log INFO "COMMAND: $TOOL_NAME.sh $cmdline"
}


###############################################################################
# END: common.sh
###############################################################################

# ------------------------------------------
# Constants
# ------------------------------------------

DOCKER_NETWORK=${DOCKER_NETWORK:-udn}  # for DNS purpose

# ------------------------------------------
# Parameters (loaded from Config file)
# ------------------------------------------

# ------------------------------------------
# Global variables
# ------------------------------------------

declare Proxy
declare DockerDir
declare DockerImg
declare DockerContainer
declare DockerVolume
declare -i DockerTty=1
declare -i DockerMount=0
declare SquidIP

# ------------------------------------------
# usage
# ------------------------------------------

function usage {
  echo "Usage: $TOOL_NAME.sh command [options] arguments*

Options:
  -f : force
  -v : verbose

commands:
 status            : docker status (default if no command provided)
 help              : show this message
 b|build <image>   : build an image
 [run]   <image>...: run an image (run is optional)
 stop    <image>   : stop  image
 destroy <image>   : stop and remove a container
 test    <image>   : test a docker image
 l|logs  <image>   : docker logs
 i|info  <image>   : image's info
 clean             ! docker clean
"
  quit
}

# ------------------------------------------
# Implementation 
# ------------------------------------------

function getProxy {
  [[ -n $Proxy ]] && return
  if [[ -n $PROXY_SQUID ]] 
  then SquidIP=$(grep $PROXY_SQUID /etc/hosts | cut -d\  -f1 )
       Proxy=http://$SquidIP:${PROXY_PORT-3128}  
  fi
  Proxy=${Proxy:-$http_proxy}
  export http_proxy=
  export https_proxy=
}


# small helper to display the docker command being run
function _docker {
  info "\$ docker $*"
  docker $*
}

function dockerCheck {
  getProxy
  which docker >/dev/null 2>&1 || die "Docker not installed"
  [[ -n $DOCKER_HOST ]] || die "DOCKER_HOST not defined"
  ping -c1 $DOCKER_HOST >/dev/null 2>&1
  [[ $? -eq 0 ]] || die "Docker host $DOCKER_HOST not reachable"
  egrep -q '^[0-9]+' <<<$DOCKER_HOST || die "\$DOCKER_HOST must be an IP"
  _docker network ls | grep -q $DOCKER_NETWORK 
  [[ $? -eq 0 ]] || _docker network create --driver bridge $DOCKER_NETWORK || die

}

function getDockerImg {
  [[ $# -eq 0 ]] && usage
  DockerImg=$1
  dockerCheck
  if [[ -d $1 ]]
  then DockerDir=$1
       [[ $DockerDir == . ]] && DockerDir=$(pwd)
       DockerImg=${DockerDir##*/}
  else [[ -d $HOME/docker ]]  || die "Missing $HOME/docker"
       DockerDir=$HOME/docker/$DockerImg
  fi
  if [[ ! -d $DockerDir ]] 
  then [[ $Command == build ]] && die "no docker repository named '$DockerImg'"
    die "Command '$Command' not supported; and no docker repository named '$DockerImg'"
  fi
  [[ -f $DockerDir/Dockerfile ]] || die "No file $DockerDir/Dockerfile"
  # Using the image name for container's name
  DockerContainer=${DockerImg}
  # as  well for the volume name
  DockerVolume=${DockerImg}
}

function dockerBuild {
  info "Building image from $DockerDir"
  id=$(docker images -q ${DockerImg} |head -1)
  if [[ -n $id ]]
  then warn "Image $DockerImg [$id] already built"
       opt f || return
       docker rmi -f  $id
  fi
  egrep -q '^VOLUME \[' $DockerDir/Dockerfile && die "$TOOL_NAME does not support VOLUME in JSON format"
  vers=$(egrep -i "^ENV ${DockerImg/alpine-}[A-Z]*_VERSION" $DockerDir/Dockerfile | awk '{print $3}')
  [[ -n $vers ]] || warn "No VERSION found in Dockerfile"
  # check if this a  server or an intermediate image
  egrep -q '^ENTRYPOINT' $DockerDir/Dockerfile
  if [[ $? -eq 0 ]]
  then 
    egrep -q '^LABEL Description' $DockerDir/Dockerfile || \
      warn "No Description Label in Dockerfile"
    egrep -q '^LABEL Usage' $DockerDir/Dockerfile || \
      warn "No Usage Label in Dockerfile"
  fi
  tags="-t $DockerImg:latest"
  [[ -n $vers ]] && tags="$tags -t $DockerImg:$vers"

  buildargs="--build-arg http_proxy=$Proxy --build-arg https_proxy=$Proxy --build-arg no_proxy=${PROXY_BYPASS:-127.0.0.1}"
  for arg in $(egrep "^ARG " $DockerDir/Dockerfile | sed 's/ARG \([A-Z_]*\)=.*/\1/') 
  do [[ -n ${!arg} ]] && buildargs="$buildargs --build-arg $arg=${!arg}"
  done
  if [[ -x $DockerDir/build.sh ]]
  then info "$ build.sh $buildargs"
       cd $DockerDir && ./build.sh $tags $buildargs 
  else _docker build $tags $buildargs $DockerDir |tee $LogFile
  fi
  info "$ docker images .."
  docker images --format 'table{{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}' --filter=reference='*:[0-9]*'
}


function dockerRun {
  args=$*
  if [[ $# -eq 0 && $(egrep -c '^ENTRYPOINT' $DockerDir/Dockerfile) -eq 1 ]]
  then # server mode
      id=$(docker ps -a | grep "${DockerContainer}\$" | awk '{print $1}')
       if [[ -n $id ]]
       then _docker ps | grep -q "${DockerContainer}\$"
	    if [ $? -eq 0 ]
	    then warn "Container $DockerImg [$id] already running"
	    else _docker start $id
            fi
	    return
       fi
       opts="-d --name=${DockerContainer} --network=$DOCKER_NETWORK"
       volume=$(egrep '^VOLUME' $DockerDir/Dockerfile | awk '{print $2}')
       [[ -n $volume ]] && opts="$opts --mount source=${DockerVolume},target=$volume"
       for port in $(egrep '^EXPOSE ' $DockerDir/Dockerfile | cut -c 8-)
       do grep -q '[$]' <<<$port
	  if [[ $? -ne 0 ]]
	  then opts="$opts -p $port:$port"
	  else
	    for ev in $(egrep '^ENV ' $DockerDir/Dockerfile | awk '{print "port=${port/\\$\\{" $2 "\\}/" $3 "}" }')
	    do eval $ev
            done
	    # echo "DEBUG: port=$port"
	    opts="$opts -p $port:$port"
	  fi
       done
       for e in $(env | egrep '^[A-Z_]*=' | egrep -v '^PATH=' | cut -d= -f1)
       do egrep -q "^ENV $e " $DockerDir/Dockerfile && opts="$opts -e $e=${!e}"
       done
       # WA for NIFI-4761
       [[ $DockerImg == nifi ]] && opts="$opts -h nifi"
       args=start
  else # command mode
       opts="-i --rm --network=$DOCKER_NETWORK"
       if [[ $DockerMount -eq 1 ]] 
       then volume=$(egrep '^VOLUME' $DockerDir/Dockerfile | awk '{print $2}')
	    [[ -n $volume ]] && opts="$opts --mount source=${DockerVolume},target=$volume"
       fi
     [[ $DockerTty -eq 1 ]] && opts="-t $opts"       
  fi
  _docker run $opts $DockerImg $args
}

function dockerStop {
  id=$(docker ps  | grep "${DockerContainer}\$" | awk '{print $1}')
  if [[ -z $id ]]
  then warn "Container ${DockerContainer} not running"
       return 1
  else _docker stop $id
  fi
}


function dockerDestroy {
  id=$(docker ps  -a | grep "${DockerContainer}\$" | awk '{print $1}')
  if [[ -z $id ]]
  then warn "No container ${DockerContainer}"
       return 1
  else 
    _docker stop $id
    _docker rm $id
    docker volume ls | grep -q $DockerVolume && _docker volume rm $DockerVolume
  fi
}

function dockerStatus {
  dockerCheck
  opt v 
  if [[ $? -eq 0 ]]
  then 
    _docker images
    _docker ps -a
  else 
    info "$ docker images .."
    docker images --format 'table{{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}' --filter=reference='*:[0-9]*'
    info "$ docker ps .."
    docker ps -a  --format 'table{{.Image}}:{{.Names}}\t{{.ID}}\t{{.Status}}'
  fi
  _docker volume ls
}

function dockerClean {
  dockerCheck
  _docker container prune -f
  for vol in $(docker volume ls -q)
  do grep -q "[0-9a-f]\{64\}" <<<$vol && _docker volume rm $vol
  done
  ids=$(docker images -f "dangling=true" -q)
  [[ -n $ids ]] && _docker rmi -f $ids
  echo
  dockerStatus
}

function dockerTest {
  testfile=$DockerDir/test-server.sh
  [[ -f $testfile ]] || die "No file $testfile"
  dockerDestroy 
  dockerBuild
  dockerInfo
  info "\nStarting $DockerImg\n------------------------------------------"
  dockerRun
  # wating 10 sec. for server to start
  sleep 10
  docker ps | grep -q " ${DockerContainer}"
  if [ $? -ne 0 ]
  then docker logs $DockerImg
       die "Server failed to start"
  fi
  # execute test file
  info "\nTesting $DockerImg health\n------------------------------------------"
  DockerTty=0 DockerMount=1 source $testfile |& tee $TmpFile || die
  grep -qi "exception \|error " $TmpFile
  [[ $? -eq 0 ]] && die 
  # check persistence (volume)
  testfile=$DockerDir/test-volume.sh
  if [[ -f $testfile ]] 
  then info "\nTesting $DockerImg persistence\n------------------------------------------"
       dockerStop
       sleep 1
       dockerRun
       sleep 5
       DockerTty=0 source $testfile  || die
  fi
  dockerDestroy
  info "\nTESTING OK"
}

function dockerLogs {
  _docker logs $DockerImg
} 

function dockerInfo {
  # output labels
  docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' $DockerImg
}


function dockerCopy {
  [[ -n $DOCKER_COPY_HOST ]]  || die "DOCKER_COPY_HOST not defined"
  info "$ docker save $DockerImg"
  docker save $DockerImg >$TmpFile
  info "($DOCKER_COPY_HOST) $ docker load -i .."
  DOCKER_HOST=$DOCKER_COPY_HOST docker load -i $TmpFile
  DOCKER_HOST=$DOCKER_COPY_HOST docker images
  rm $TmpFile
}
  
# ------------------------------------------
# Command Line
# ------------------------------------------

# analyse command line
if [[ $# -eq 0 ]]
then init -fv status
else init -fv $@
fi

case $Command in
  help)     usage;;
  b|build)  getDockerImg $Arguments; dockerBuild;;
  run)      getDockerImg $Arguments; dockerRun ${Arguments/$DockerImg/};;
  destroy)  getDockerImg $Arguments; dockerDestroy;;
  stop)     getDockerImg $Arguments; dockerStop;;
  test)     getDockerImg $Arguments; dockerTest;;
  l|logs)   getDockerImg $Arguments; dockerLogs;;
  i|info)   getDockerImg $Arguments; dockerInfo;;
  copy)     getDockerImg $Arguments; dockerCopy;;
  status)   dockerStatus;;
  clean)    dockerClean ;;
  *) getDockerImg $Command; dockerRun $Arguments;;
esac

quit
