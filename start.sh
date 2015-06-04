#!/bin/bash -e

. /etc/setup.sh

/usr/sbin/globus-gridftp-server -c /etc/gridftp.conf -C /etc/gridftp.d -pidfile /var/run/globus-gridftp-server.pid

