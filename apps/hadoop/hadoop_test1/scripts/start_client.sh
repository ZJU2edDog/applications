#!/bin/bash

if [ $# -lt 0 ]; then
    echo "Usage: client_start.sh {all | or specific func name}  <ip_address>"
    exit 0
fi

HIBENCH_CMD_DIR=/run/bigdata/hibench
#######################################################################################
# Notes:
#  To start client tests
#######################################################################################

if [ "x${1}" == "xall" ] ; then
    ${HIBENCH_CMD_DIR}/bin/run-all.sh
else
    #Update date size scale
    if [ ! -z "${2}" ] ; then
        sed -i "s/hibench\.scale\.profile.*/hibench\.scale\.profile\ ${2}/g" ${APP_ROOT}/apps/hadoop/hadoop_test1/config/${1}_hibench_hadoop.conf
        sed -i "s/hibench\.${1}\.datasize.*//g" ${APP_ROOT}/apps/hadoop/hadoop_test1/config/${1}_hibench_hadoop.conf
        sed -i "s/hibench\.workload\.datasize.*//g" ${APP_ROOT}/apps/hadoop/hadoop_test1/config/${1}_hibench_hadoop.conf
        #echo "hibench.${1}.datasize \${hibench.wordcount.${2}.datasize}" >> ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
        #echo "hibench.workload.datasize  \${hibench.${1}.datasize}" >> ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
    fi 
    #Update Hadoop Config
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/bayes_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/ml/bayes.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/join_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/sql/join.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/aggregation_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/sql/aggregation.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/pagerank_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/websearch/pagerank.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/sleep_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/micro/sleep.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/scan_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/sql/scan.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/dfsioe_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/micro/dfsioe.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/wordcount_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/micro/wordcount.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/terasort_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/micro/terasort.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/sort_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/micro/sort.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/kmeans_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/ml/kmeans.conf
${tool_add_sudo} cp ${APP_ROOT}/apps/hadoop/hadoop_test1/config/nutchindexing_hibench_hadoop.conf ${HIBENCH_CMD_DIR}/conf/workloads/websearch/nuthindexing.conf
 
 
     case "${1}" in
        "pagerank")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/websearch/pagerank/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/websearch/pagerank/hadoop/run.sh
        ;;
        "wordcount")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/wordcount/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/wordcount/hadoop/run.sh
        ;;
        "dfsioe")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/dfsioe/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/dfsioe/hadoop/run.sh
        ;;
        "terasort")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/terasort/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/terasort/hadoop/run.sh
        ;;
        "sort")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/sort/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/micro/sort/hadoop/run.sh
        ;;
        "scan")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/sql/scan/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/sql/scan/hadoop//run.sh
        ;;
        "kmeans")
            echo "Prepare Data ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/ml/kmeans/prepare/prepare.sh
 
            echo "Begin to execute benchmark ......"
            ${HIBENCH_CMD_DIR}/bin/workloads/ml/kmeans/hadoop/run.sh
        ;;
    esac
fi

echo "Test Result Report:"
cat ${HIBENCH_CMD_DIR}/report/hibench.report
echo "**********************************************************************************"
