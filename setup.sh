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
mkdir -p /srv/globus/etc/grid-security/certificates
if [ ! -f /srv/globus/etc/grid-security/gsi-authz.conf ]
then
	cp -a /etc/grid-security/gsi-authz.conf /srv/globus/etc/grid-security/
fi

if [ ! -d /srv/globus/etc/grid-security/vomsdir ]
then
	cp -a /etc/grid-security/vomsdir /srv/globus/etc/grid-security/vomsdir
fi
mv /etc/grid-security /etc/grid-security.orig
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

SAVE_LCMAPS_DB_FILE="$LCMAPS_DB_FILE"
SAVE_LCMAPS_POLICY_NAME="$LCMAPS_POLICY_NAME"
SAVE_LLGT_LIFT_PRIVILEGED_PROTECTION="$LLGT_LIFT_PRIVILEGED_PROTECTION"
SAVE_LCMAPS_DEBUG_LEVEL="$LCMAPS_DEBUG_LEVEL"

. /usr/share/osg/sysconfig/globus-gridftp-server

if [ "x$SAVE_LCMAPS_DB_FILE" != "x" ]; then export LCMAPS_DB_FILE="$SAVE_LCMAPS_DB_FILE"; fi
if [ "x$SAVE_LCMAPS_POLICY_NAME" != "x" ]; then export LCMAPS_POLICY_NAME="$SAVE_LCMAPS_POLICY_NAME"; fi
if [ "x$SAVE_LLGT_LIFT_PRIVILEGED_PROTECTION" != "x" ]; then export LLGT_LIFT_PRIVILEGED_PROTECTION="$SAVE_LLGT_LIFT_PRIVILEGED_PROTECTION"; fi
if [ "x$SAVE_LCMAPS_DEBUG_LEVEL" != "x" ]; then export LCMAPS_DEBUG_LEVEL="$SAVE_LCMAPS_DEBUG_LEVEL"; fi
