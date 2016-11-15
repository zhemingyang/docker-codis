#!/bin/bash

HOST_IP=`hostname --ip-address`

# sync codis config with dashboard
sed -i "s/DASHBOARD_IP/${DASHBOARD}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/ZOOKEEPER_IP/${ZOOKEEPER}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/PRODUCT_NAME/${PRODUCT}/g" $CODIS_HOME/codisconf/config.ini

# initialize slot
${CODIS_HOME}/bin/codis-config -c ${CODIS_HOME}/codisconf/config.ini slot init -f

# config codis-server
sed -i "s/LOCAL_IP/${HOST_IP}/g" $CODIS_HOME/serverconf/conf/server_6900.conf

# start codis-server
$CODIS_HOME/bin/codis-server $CODIS_HOME/serverconf/conf/server_6900.conf

# config codis-server group
$CODIS_HOME/bin/codis-config -c ${CODIS_HOME}/codisconf/config.ini server add 1 ${HOST_IP}:6900 master

# config codis-server group slot
$CODIS_HOME/bin/codis-config -c ${CODIS_HOME}/codisconf/config.ini slot range-set 0 1023 1 online
