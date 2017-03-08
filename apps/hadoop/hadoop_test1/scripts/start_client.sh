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
        sed -i "s/hibench\.scale\.profile.*/hibench\.scale\.profile\ ${2}/g" ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
        sed -i "s/hibench\.${1}\.datasize.*//g" ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
        sed -i "s/hibench\.workload\.datasize.*//g" ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
        #echo "hibench.${1}.datasize \${hibench.wordcount.${2}.datasize}" >> ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
        #echo "hibench.workload.datasize  \${hibench.${1}.datasize}" >> ${HIBENCH_CMD_DIR}/workloads/${1}/conf/10-${1}-userdefine.conf
    fi 
 
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
