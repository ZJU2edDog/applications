#!/bin/bash

. ${APP_ROOT}/toolset/setup/basic_cmd.sh

if [ $# -lt 1 ]; then
    echo "Usage: start_server.sh <local | remote>"
    exit 0
fi

BASE_DIR=$(cd ~; pwd)

source /etc/profile

if [ -z "${HBASE_INSTALL}" ] ; then
    echo "HBASE_INSTALL is not set so far. Probably Hadoop has not been installed"
    exit 0
fi


NUMA_CMD=""
#NUMA_CMD="numactl --cpunodebind=0,1,2,3 --localalloc

##############################################################################
#Start load mode hbase
start_local_hbase() {
    #Update local configurations
    $(tool_add_sudo) cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/local-hdfs-site.xml ${HBASE_INSTALL}/conf/hdfs-site.xml
    $(tool_add_sudo) cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/local-core-site.xml ${HBASE_INSTALL}/conf/core-site.xml
    $(tool_add_sudo) cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/local-yarn-site.xml ${HBASE_INSTALL}/conf/yarn-site.xml
    $(tool_add_sudo) cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/local-mapred-site.xml ${HBASE_INSTALL}/conf/mapred-site.xml
    $(tool_add_sudo) cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/local-hbase-site.xml ${HBASE_INSTALL}/conf/hbase-site.xml
    #Start HBase
    sed -i "s/export.*JAVA_HOME.*=.*\${JAVA_HOME}//g" ${HBASE_INSTALL}/conf/hbase-env.sh
    echo "export JAVA_HOME=${JAVA_HOME}" >> ${HBASE_INSTALL}/conf/hbase-env.sh
    
    ${NUMA_CMD} ${HBASE_INSTALL}/bin/start-hbase.sh
}

start_local_hbase
echo "Local HBase starts successfully"
