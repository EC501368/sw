#!/bin/sh
# Copyright IBM Corp. 2002

binDir=`dirname $0`
$binDir/versionInfo.sh -format html -file versionReport.html -maintenancePackages -componentDetail
