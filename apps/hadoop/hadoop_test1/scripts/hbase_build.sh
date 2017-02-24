
. ${APP_ROOT}/toolset/setup/basic_cmd.sh

######################################################################################
# Notes:
#  To install Hadoop
#
#####################################################################################
BUILD_DIR="/u01/hbase"
SERVER_FILENAME=$1
VERSION="1.3.0"
TARGET_DIR=$(tool_get_first_dirname ${BUILD_DIR})

####################################################################################
# Prepare for build
####################################################################################
if [ ! -z "${BUILD_DIR}" ]; then
      tar -zxvf ${SERVER_FILENAME} -C ${BUILD_DIR}
fi
TARGET_DIR=$(tool_get_first_dirname ${BUILD_DIR})

if [ -z "$(grep MAVEN_OPTS /etc/profile)" ] ; then 
    echo 'export MAVEN_OPTS="-Xms512m -Xmx2000m"' >> /etc/profile
fi
echo "Finish build preparation......"

######################################################################################
# Build HBase
######################################################################################
pushd ${BUILD_DIR}/${TARGET_DIR} > /dev/null
source /etc/profile
set Platform=aarch64

#Since it could not compile Hadoop by using jdk1.8, 
#so we will use jdk1.7 to compile Hadoop temporaily.
#However it will still use jdk1.8 to execute hadoop due to performance reason
OLD_JAVA_HOME=${JAVA_HOME}
JAVA_1_7_HOME=""
for dirname in $(ls /usr/lib/jvm/) 
do
   if [ ! -d "/usr/lib/jvm/"${dirname} ] ; then
       continue
   fi
      
   if [[ "${dirname}" =~ ^"java-1.7.0-openjdk".* ]] || [[ "${dirname}" == "java-1.7.0-openjdk-arm64" ]] ; then
       JAVA_1_7_HOME="/usr/lib/jvm/"${dirname}
       break
   fi
done

if [ -z "${JAVA_1_7_HOME}" ] ; then
   echo "Please install java-1.7.0-openjdk firstly"
   exit 0
fi

JAVA_HOME=${JAVA_1_7_HOME}
echo "Apply numa patch which is only valid for hadoop-2.6.0 so far "
${APP_ROOT}/apps/hadoop/hadoop_test1/scripts/hadoop_numa_patch.sh ${APP_ROOT}/apps/hadoop/hadoop_test1/src/hadoop_numa ./

echo "Begin to build Hadoop"
mvn clean install -DskipTests -Dmaven.javadoc.skip=true
JAVA_HOME=${OLD_JAVA_HOME}
popd > /dev/null
