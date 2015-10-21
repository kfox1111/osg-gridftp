FROM kfox1111/osg-base
MAINTAINER Kevin Fox "Kevin.Fox@pnnl.gov"

RUN yum install -y globus-gridftp-server m2crypto osg-gridftp lcmaps-plugins-gums-client lcmaps-plugins-basic lcmaps-plugins-verify-proxy nss-pam-ldapd globus-ftp-client
RUN rpm -Uvh http://www.efox.cc/temp/gridftp-adler32/gridftp-dsi-storm-adler32-1.2.0-1.el6.x86_64.rpm
ADD ./setup.sh /etc/setup.sh
RUN chmod +x /etc/setup.sh
ADD ./start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

CMD ["/etc/start.sh"]
