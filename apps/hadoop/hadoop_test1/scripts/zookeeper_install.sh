#!/bin/bash

. ${APP_ROOT}/toolset/setup/basic_cmd.sh
######################################################################################
# Notes:
#  To install ZooKeeper
#
#####################################################################################
BUILD_DIR="./"$(tool_get_build_dir $1)
VERSION="3.9.4"
INSTALL_DIR="/u01/zookeeper"
TARGET_DIR=$(tool_get_first_dirname ${BUILD_DIR})
SERVER_FILENAME=${BUILD_DIR}/${TARGET_DIR}/build/zookeeper-${VERSION}.jar

#######################################################################################
if [ -z "${INSTALL_DIR}" ]; then
      echo "zookeeper-${VERSION} has not been built successfully"
      exit -1
fi

####################################################################################
# Prepare for install
####################################################################################
$(tool_add_sudo) useradd hbase
$(tool_add_sudo) passwd hbase hbasetest
$(tool_add_sudo) mkdir -p ${INSTALL_DIR}
$(tool_add_sudo) chown hbase.$(whoami) ${INSTALL_DIR}

tar -zxvf ${SERVER_FILENAME} -C ${INSTALL_DIR}

if [ -z "$(grep HBASE_INSTALL /etc/profile)" ] ; then
    echo "export ZOOKEEPER_INSTALL=${INSTALL_DIR}/${TARGET_DIR}" >> /etc/profile
    echo 'export PATH=${ZOOKEEPER_INSTALL}/bin:${ZOOKEEPER_INSTALL}/sbin:${PATH}' >> /etc/profile
    echo 'export PATH=$ZOOKEEPER_INSTALL/bin:$PATH' >> /etc/profile
fi
source /etc/profile
echo "Finish install preparation......"
