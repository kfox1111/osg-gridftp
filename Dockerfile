FROM kfox1111/osg-base
MAINTAINER Kevin Fox "Kevin.Fox@pnnl.gov"

RUN yum install -y globus-gridftp-server m2crypto osg-gridftp lcmaps-plugins-gums-client lcmaps-plugins-basic lcmaps-plugins-verify-proxy nss-pam-ldapd
ADD ./setup.sh /etc/setup.sh
RUN chmod +x /etc/setup.sh
ADD ./start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

CMD ["/etc/start.sh"]
