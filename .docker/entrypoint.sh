#!/bin/bash

/etc/init.d/mysql start
/etc/init.d/cron start
source /etc/apache2/envvars
exec apache2 -D FOREGROUND