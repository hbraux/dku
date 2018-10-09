#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  # disable all services from System
  rm -f /etc/systemd/system/*.wants/*
  cd /lib/systemd/system/multi-user.target.wants 
  for f in *
  do [[ $f == systemd-update-utmp-runlevel.service ]] || rm -f $f
  done
  rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service
  rm -f /lib/systemd/system/local-fs.target.wants/*
  rm -f /lib/systemd/system/sockets.target.wants/*udev*
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*
  rm -f /lib/systemd/system/sockets.target.wants/*journald*
  rm -f /lib/systemd/system/sysinit.target.wants/systemd-machine-id-commit.service
  rm -f /lib/systemd/system/sysinit.target.wants/*udev*
  rm -f /lib/systemd/system/sysinit.target.wants/*journal*


  # configure SSHD
  mkdir /var/run/sshd 
  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
  sed -i "s/^#Port 22/Port ${SSHD_PORT}/" /etc/ssh/sshd_config 
  systemctl enable sshd


  # create user 
  sed -i 's/^%wheel.*/%wheel  ALL=(ALL)    NOPASSWD:ALL/' /etc/sudoers 
  useradd ${SSH_USER} -g wheel 
  echo -e "${SSH_PASS}\n${SSH_PASS}" | (passwd --stdin ${SSH_USER})
  
  touch .setup
}

function _start {
  _setup
  exec /usr/lib/systemd/systemd --system --unit=multi-user.target 
}


export -f _setup _start

case $1 in
  start)  _start;;
  *)      exec $@;;
esac

