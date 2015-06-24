#!/bin/bash -e

: ${GLOBUS_HOSTNAME:='localhost'}
: ${GLOBUS_IP_ADDRESS:=''}
: ${GRIDFTP_PORT:='2811'}
: ${LCMAPS_DEBUG_LEVEL:='2'}

export LCMAPS_DEBUG_LEVEL

if [ "x$GLOBUS_IP_ADDRESS" == "x" ]
then
	GLOBUS_IP_ADDRESS=`dig +short "$GLOBUS_HOSTNAME"`
fi

if [ ! -f /etc/.setup.once ]
then

if [ "x$GLOBUS_USE_LDAP" != "x" ]
then
	sed -i 's/^passwd:.*/passwd:	files ldap/' /etc/nsswitch.conf
	sed -i 's/^shadow:.*/shadow:	files ldap/' /etc/nsswitch.conf
	sed -i 's/^group:.*/group:	files ldap/' /etc/nsswitch.conf
fi

sed -i 's/^port .*/port '$GRIDFTP_PORT'/' /etc/gridftp.conf
	
echo "$GLOBUS_IP_ADDRESS $GLOBUS_HOSTNAME" >> /etc/hosts

mkdir -p /srv/globus/etc/gridftp.d
mkdir -p /srv/globus/var/log
if [ ! -f /srv/globus/etc/lcmaps.db ]
then
	mv /etc/lcmaps.db /srv/globus/etc/lcmaps.db
else
	mv -f /etc/lcmaps.db /srv/globus/etc/lcmaps.db.new
fi
if [ ! -f /srv/globus/etc/gridftp.conf ]
then
	mv /etc/gridftp.conf /srv/globus/etc/gridftp.conf
else
	mv -f /etc/gridftp.conf /srv/globus/etc/gridftp.conf.new
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
	mv -f /etc/gridftp.d/udt-osg-gridftp.conf /srv/globus/etc/udt-osg-gridftp.conf.newdisabled
fi
mkdir -p /etc/lcmaps
ln -s /etc/lcmaps.db /etc/lcmaps/lcmaps.db
rm -rf /etc/gridftp.d
ln -s /srv/globus/etc/lcmaps.db /etc/lcmaps.db
ln -s /srv/globus/etc/gridftp.conf /etc/gridftp.conf
ln -s /srv/globus/etc/grid-security /etc/grid-security
ln -s /srv/globus/etc/gridftp.d /etc/gridftp.d
ln -s /srv/globus/var/log/gridftp-auth.log /var/log/gridftp-auth.log
ln -s /srv/globus/var/log/gridftp.log /var/log/gridftp.log
touch /srv/globus/var/log/gridftp-auth.log
touch /srv/globus/var/log/gridftp.log

touch /etc/.setup.once
fi #End setup run once

export LCMAPS_LOG_FILE=/srv/globus/var/log/lcmaps
. /usr/share/osg/sysconfig/globus-gridftp-server
