FROM centos:7.9.2009

RUN yum -y update
RUN yum -y install krb5-server krb5-libs krb5-workstation vim
RUN yum -y clean all

# Environment variables
ENV REALM ${REALM:-EXAMPLE.COM}
ENV SUPPORTED_ENCRYPTION_TYPES ${SUPPORTED_ENCRYPTION_TYPES:-aes256-cts-hmac-sha1-96:normal}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-adminpassword}

EXPOSE 749 88/udp

COPY init-script.sh /tmp/
RUN chmod +x /tmp/init-script.sh
CMD /tmp/init-script.sh
