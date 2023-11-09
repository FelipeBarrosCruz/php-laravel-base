#!/bin/bash

# If there's a build script, run it
if [ -e /var/app/build.sh ]
then
	bash /var/app/build.sh
fi

# Then start the daemons with supervisor
exec supervisord -c /etc/supervisor/supervisord.conf