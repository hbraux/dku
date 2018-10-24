FROM centos:7

# Can be set to custom mirror eg http://centos.mirrors.ovh.net/ftp.centos.org
# if let blank using fastestmirror plugin
ARG SITE_YUMMIRROR=""

ENV SYSTEMD_VERSION 7

ENV SSH_USER ansible 
ENV SSH_PASS ansible
ENV SSHD_PORT 2022


LABEL Description="CentOS7 image with Systemd and SSH server"
LABEL Usage="docker run -d --privileged --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -p $SSHD_PORT:$SSHD_PORT sshd start"

# @RUNOPTS@ --privileged --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro 

RUN if [ -n "${SITE_YUMMIRROR}" ]; then  sed -i 's/^enabled=.*/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf && sed -i "s/^mirrorlist=//g;s~^#baseurl=http://mirror.centos.org/centos~baseurl=${SITE_YUMMIRROR}~g" /etc/yum.repos.d/CentOS-Base.repo ; fi

RUN yum install -y sudo openssh-server


COPY entrypoint.sh /

EXPOSE ${SSHD_PORT}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

