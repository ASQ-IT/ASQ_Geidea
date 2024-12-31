@echo off
set classpath=.;./cores/PayPal/PayPalCore.jar;./lib/gson-2.10.1.jar;./eftlink.jar;./lib/log4j-1.2-api-2.20.0.jar;../../lib/log4j-api-2.20.0.jar;../../lib/log4j-core-2.20.0.jar;

java oracle.eftlink.paypal.LocationService %1
pause