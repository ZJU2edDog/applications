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
SERVER_FILENAME=${BUILD_DIR}/${TARGET_DIR}/zookeeper-dist/target/zookeeper-${VERSION}.tar.gz

#######################################################################################
if [ ! "$(tool_check_exists ${SERVER_FILENAME})"  == 0 ]; then
      echo "HBase-${VERSION} has not been built successfully"
      exit -1
fi

TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})
if [ "$(tool_check_exists ${INSTALL_DIR}/${TARGET_DIR}/bin/zookeeper)"  == 0 ]; then
      echo "ZooKeeper-${VERSION} has been installed successfully"
      exit 0
fi

####################################################################################
# Prepare for install
####################################################################################
$(tool_add_sudo) useradd hbase
$(tool_add_sudo) passwd hbase hbasetest
$(tool_add_sudo) mkdir -p ${INSTALL_DIR}
$(tool_add_sudo) chown hbase.$(whoami) ${INSTALL_DIR}

tar -zxvf ${SERVER_FILENAME} -C ${INSTALL_DIR}
TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})
source /etc/profile
echo "Finish install preparation......"
