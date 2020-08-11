curDir=`pwd`
wasDir=`dirname $0`/../
cd ${wasDir}
WAS_HOME=`pwd`
cd "${curDir}"

. ${WAS_HOME}/bin/sdk/_setupSdk.sh  ${WAS_HOME}
WAS_ENDORSED_DIRS="$WAS_HOME"/endorsed_apis:"$JAVA_HOME"/jre/lib/endorsed