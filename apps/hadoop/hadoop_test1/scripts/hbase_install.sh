#!/bin/bash

. ${APP_ROOT}/toolset/setup/basic_cmd.sh
######################################################################################
# Notes:
#  To install HBase
#
#####################################################################################
VERSION="1.3.0"
INSTALL_DIR="/u01/hbase"
TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})

#######################################################################################

####################################################################################
# Prepare for install
####################################################################################
$(tool_add_sudo) useradd hbase
$(tool_add_sudo) passwd habse hbasetest
$(tool_add_sudo) mkdir -p ${INSTALL_DIR}
$(tool_add_sudo) chown hbase.$(whoami) ${INSTALL_DIR}

TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})
source /etc/profile
echo "Finish install preparation......"

######################################################################################
# Install HBase
######################################################################################

if [ -z "$(grep HBASE_INSTALL /etc/profile)" ] ; then
    echo "export HBASE_INSTALL=${INSTALL_DIR}/${TARGET_DIR}" >> /etc/profile
    echo 'export PATH=${HBASE_INSTALL}/bin:${HBASE_INSTALL}/sbin:${PATH}' >> /etc/profile
    echo 'export PATH=$HBASE_INSTALL/bin:$PATH' >> /etc/profile
fi
source /etc/profile

