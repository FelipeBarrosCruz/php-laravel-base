#!/bin/bash

# If there's a build script, run it
if [ -e /var/app/build.sh ]
then
	bash /var/app/build.sh
fi

# Installing composer

composer install

composer run post-root-package-install

composer run post-create-project-cmd

# Then start the daemons with supervisor
exec supervisord -c /etc/supervisor/supervisord.conf