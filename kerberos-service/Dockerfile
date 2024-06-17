FROM centos:7.9.2009

RUN yum -y update
RUN yum -y install openssh-server krb5-workstation vim
RUN yum -y clean all

EXPOSE 22

RUN ssh-keygen -A

# configuration for the SSH server
COPY sshd_config /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/sshd", "-D"]