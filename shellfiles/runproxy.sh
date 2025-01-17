#!/bin/bash

HOST_IP=`hostname --ip-address`

# sync config with dashboard
sed -i "s/DASHBOARD_IP/${DASHBOARD}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/ZOOKEEPER_IP/${ZOOKEEPER}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/PRODUCT_NAME/${PRODUCT}/g" $CODIS_HOME/codisconf/config.ini

# config codis-proxy
sed -i "s/ZOOKEEPER_IP/${ZOOKEEPER}/g" $CODIS_HOME/proxyconf/config.ini
sed -i "s/DASHBOARD_ADDR/${DASHBOARD}/g" $CODIS_HOME/proxyconf/config.ini
sed -i "s/PRODUCT_NAME/${PRODUCT}/g" $CODIS_HOME/proxyconf/config.ini
sed -i "s/PROXY_ID/${PROXYID}/g" $CODIS_HOME/proxyconf/config.ini

# start codis-proxy
$CODIS_HOME/bin/codis-proxy -c $CODIS_HOME/proxyconf/config.ini -L ${CODIS_HOME}/proxylog/`date +"%Y%m%d"`.log  --cpu=2 --addr=${HOST_IP}:19000 --http-addr=${HOST_IP}:11000 >> $CODIS_HOME/proxylog/${PRODUCT}.log 2>&1
