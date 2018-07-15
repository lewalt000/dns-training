# Download base centos image
FROM centos:7

# Expose DNS ports
EXPOSE 53 53/udp

# yum update and Install bind
RUN yum -y update 
RUN yum -y install bind bind-utils
RUN yum clean all
RUN rm -rf /var/cache/yum


# Copy configs
RUN mkdir -p /etc/bind/zones/
COPY config/named.conf /etc/named.conf
COPY config/zones/* /etc/bind/zones

# Start named service via entrypoint script
COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
