IBM SDK Java Technology Edition, Version 6
==========================================

This README file applies to IBM SDK Java Technology Edition, Version 6 when used with an IBM J9 2.6
virtual machine, and to all subsequent releases, modifications, and service refreshes, 
in this configuration until otherwise indicated in a new README file.

This README file provides essential release notes that were not incorporated into the packages.

Documentation to support all releases of IBM SDK Java Technology Edition, Version 6 can be found
in IBM Knowledge Center: 
http://www.ibm.com/support/knowledgecenter/SSYKE2_6.0.0/welcome/welcome_javasdk_version.html

For additional or changed capabilities for IBM SDK Java Technology Edition Version 6 when the SDK or 
JRE includes the IBM J9 2.6 virtual machine, see this guide:
http://www.ibm.com/support/knowledgecenter/SSYKE2_6.0.0/com.ibm.java.doc.60_26/homepage/plugin-homepage-java626.html



Known issues and limitations
============================

In some situations a JVM crash on shutdown can be caused by a known 
problem in the GNU C library (GLIBC).  This problem has been fixed 
in RHEL 5.6, glibc-2.5-58. If you are using an earlier RHEL release, 
ensure that you have updated to the latest GLIBC.