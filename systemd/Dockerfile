FROM centos:7
# @RUNOPTS@ --privileged --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro 

ENV SYSTEMD_VERSION 7

ENV SSH_USER ansible 
ENV SSH_PASS ansible
ENV SSHD_PORT 2022
ENV CENTOS_MIRROR http://centos.mirrors.ovh.net/ftp.centos.org

LABEL Description="CentOS7 image with Systemd and SSH server"
LABEL Usage="docker run -d --privileged --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -p $SSHD_PORT:$SSHD_PORT sshd start"


RUN sed -i 's/^enabled=.*/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf \
    && sed -i "s/^mirrorlist=//g;s~^#baseurl=http://mirror.centos.org/centos~baseurl=${CENTOS_MIRROR}~g" /etc/yum.repos.d/CentOS-Base.repo \
    && yum install -y sudo openssh-server


COPY entrypoint.sh /

EXPOSE ${SSHD_PORT}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

