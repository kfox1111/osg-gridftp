#!/bin/bash -e

: ${GLOBUS_HOSTNAME:='localhost'}
: ${GLOBUS_IP_ADDRESS:=''}

if [ "x$GLOBUS_IP_ADDRESS" == "x" ]
then
	GLOBUS_IP_ADDRESS=`dig +short "$GLOBUS_HOSTNAME"`
fi

if [ "x$GLOBUS_USE_LDAP" != "x" ]
then
	sed -1 's/^passwd:.*/passwd:	files ldap/' /etc/nsswitch.conf
	sed -1 's/^shadow:.*/shadow:	files ldap/' /etc/nsswitch.conf
	sed -1 's/^group:.*/group:	files ldap/' /etc/nsswitch.conf
fi
	
echo "$GLOBUS_IP_ADDRESS $GLOBUS_HOSTNAME" >> /etc/hosts

mkdir -p /srv/globus/etc/gridftp.d
mkdir -p /srv/globus/var/log
if [ ! -f /srv/globus/etc/lcmaps.db ]
then
	mv /etc/lcmaps.db /srv/globus/etc/lcmaps.db
else
	mv /etc/lcmaps.db /srv/globus/etc/lcmaps.db.new
fi
if [ ! -f /srv/globus/etc/gridftp.conf ]
then
	mv /etc/gridftp.conf /srv/globus/etc/gridftp.conf
else
	mv /etc/gridftp.conf /srv/globus/etc/gridftp.conf.new
fi
if [ ! -d /srv/globus/etc/grid-security ]
then
	mv /etc/grid-security /srv/globus/etc
else
	rm -rf /etc/grid-security
fi
if [ ! -f /srv/globus/etc/gridftp.d/udt-osg-gridftp.conf ]
then
	mv /etc/gridftp.d/udt-osg-gridftp.conf /srv/globus/etc/gridftp.d/udt-osg-gridftp.conf
else
	mv /etc/gridftp.d/udt-osg-gridftp.conf /srv/globus/etc/udt-osg-gridftp.conf.newdisabled
fi
rm -rf /etc/gridftp.d
ln -s /srv/globus/etc/lcmaps.db /etc/lcmaps.db
ln -s /srv/globus/etc/gridftp.conf /etc/gridftp.conf
ln -s /srv/globus/etc/grid-security /etc/grid-security
ln -s /srv/globus/etc/gridftp.d /etc/gridftp.d
ln -s /srv/globus/var/log/globus-auth.log /var/log/globus-auth.log
ln -s /srv/globus/var/log/globus.log /var/log/globus.log
/usr/sbin/globus-gridftp-server -c /etc/gridftp.conf -C /etc/gridftp.d -pidfile /var/run/globus-gridftp-server.pid

