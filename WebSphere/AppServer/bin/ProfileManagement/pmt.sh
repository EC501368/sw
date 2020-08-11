#!/bin/sh

CUR_DIR=`pwd`
binDir=`dirname ${0}`

cd "${binDir}"
binDir=`pwd`

REPLACE_WAS_HOME=`dirname "${binDir}"`
REPLACE_WAS_HOME=`dirname "${REPLACE_WAS_HOME}"`
. "${REPLACE_WAS_HOME}"/bin/setupCmdLine.sh

case ${COMMAND_SDK} in
	*32) ${binDir}/eclipse32/pmt.sh "$@" ;;
	*64) ${binDir}/eclipse64/pmt.sh "$@" ;;
esac

cd "${CUR_DIR}"