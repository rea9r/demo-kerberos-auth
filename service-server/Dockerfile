FROM centos:7.9.2009

RUN yum -y update
RUN yum -y install openssh-server krb5-workstation vim
RUN yum -y clean all

# locale
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN ssh-keygen -A

EXPOSE 22

# configuration for the SSH server
COPY sshd_config /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/sshd", "-D"]