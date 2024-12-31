@echo off

REM It is now possible to send a ped initialization request to the TenderRetail client through the command line using arguments.

REM To achieve this, the following steps must be followed:

	REM 1. Stop any instance of EFTLink.
	REM 2. Ensure the Tender Retail client connection is running
	REM 3. Run *initializePed.bat
	
REM *initializePed.bat is calling manito.eft.tenderretail.Main with an argument of -i.

REM For additional arguments please see examples below:

REM Usgage "PinPad initialization: arguments -i [<terminalId> [<hostName> <hostPort> <timeout_1> <timeout_2> <ackInterval> <checkServerOnStartup>]]
	
    REM Required arguments
	REM ------------------
	REM -i			If set this will trigger ped initialization request. All cofiguration for the request will be obtained from tenderretail.properties
	
	REM Optional arguments
	REM ------------------
	REM <terminalId> 			sets the terminal to be used e.g. java manito.eft.tenderretail.Main -i 300
	REM <hostName> 				sets the hostName to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 
	REM <hostPort> 				sets the hostPort to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 3858
	REM <timeout_1> 			sets the timeout_1 to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 3858 120000 
	REM <timeout_2> 			sets the timeout_2 to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 3858 120000 2000 
	REM <ackInterval> 			sets the ackInterval to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 3858 120000 2000 5000 
	REM <checkServerOnStartup> 	sets the checkServerOnStartup to be used e.g. java manito.eft.tenderretail.Main -i 300 localhost 3858 120000 2000 5000 true

set classpath=.;./cores/tenderretail/epstenderretail.jar;./eftlink.jar;./lib/log4j-1.2-api-2.20.0.jar;./lib/log4j-api-2.20.0.jar;./lib/log4j-core-2.20.0.jar;

java manito.eft.tenderretail.Main -i %1 %2 %3 %4 %5 %6 %7 %8
pause