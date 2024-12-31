@echo off
set classpath=.;./cores/tenderretail/epstenderretail.jar;../cores/tenderretail/epstenderretail.jar;./eftlink.jar;./lib/log4j-1.2-api-2.20.0.jar;./lib/log4j-api-2.20.0.jar;./lib/log4j-core-2.20.0.jar;

c:\jre\bin\java manito.eft.tenderretail.Main %1 %2 %3 %4 %5 %6 %7 %8 %9
pause