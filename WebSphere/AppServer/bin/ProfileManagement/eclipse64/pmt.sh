#!/bin/sh

CUR_DIR=`pwd`
binDir=`dirname ${0}`

cd "${binDir}"
binDir=`pwd`

REPLACE_WAS_HOME=`dirname "${binDir}"`
REPLACE_WAS_HOME=`dirname "${REPLACE_WAS_HOME}"`
REPLACE_WAS_HOME=`dirname "${REPLACE_WAS_HOME}"`
. "${REPLACE_WAS_HOME}"/bin/setupCmdLine.sh

cd "${binDir}"
./eclipse -perspective com.ibm.ws.pmt.views.standalone.perspectives.standAlonePerspective -vm "${JAVA_HOME}/jre/bin/javaw" "$@" -vmargs -Xbootclasspath/a:"${WAS_HOME}/lib/bootstrap.jar" -Djava.endorsed.dirs="${WAS_HOME}/endorsed_apis":"${JAVA_HOME}/jre/lib/endorsed" -Declipse.refreshBundles=true -DJAVA_NATIVE_LIB_DIR="${JAVA_NATIVE_LIB_DIR}" -DWAS_HOME="${WAS_HOME}"
cd "${CUR_DIR}"

