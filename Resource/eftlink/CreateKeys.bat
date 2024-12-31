@echo off

set classpath=.;eftlink.jar;lib/log4j-1.2-api-2.20.0.jar;lib/log4j-api-2.20.0.jar;lib/log4j-core-2.20.0.jar;

rem example usage:
rem CreateKeys.bat -e RSA 4096 SHA256withRSA 750
rem or
rem CreateKeys.bat -e RSA 4096 SHA256withRSA 750 -dname 

c:\jre\bin\java manito.eft.tls.Keygen %1 %2 %3 %4 %5 %6



