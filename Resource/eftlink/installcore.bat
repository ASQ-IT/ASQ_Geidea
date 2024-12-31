@echo off
cls
setlocal enabledelayedexpansion

Set _ROOT=%~d0\\
Set _ROOT_Folder=%~p0
set _ROOT_Folder=%_ROOT_Folder:~1,-1%

::create installx directory
set _INSTALLXFOLDER=%_ROOT%%_ROOT_Folder%\installx
	IF NOT EXIST %_INSTALLXFOLDER% (
		echo create folder
		md "%_INSTALLXFOLDER%"
	)

set _ROOT_Folder=%_ROOT_Folder:\=/%
Set _EFTLINK_ROOT=%_ROOT%%_ROOT_Folder%
Set _ANSWER_FILE="%_EFTLINK_ROOT%/installx/install.properties"

Set LOGFILE=log\%~n0.log
Set /A TOTALCORES=0

	Echo ----------------------
	Call :Log START, "Installing EFTLink",echo
	Echo ----------------------

	echo installDir = %_EFTLINK_ROOT% >%_ANSWER_FILE%
	
	set interactive=1
	echo %cmdcmdline% | find /i "%~0" >nul
	if not errorlevel 1 set interactive=0
	
	if _%interactive%_==_0_ (
	 SET RUN_SILENT=false
	) else (
	 SET RUN_SILENT=true
	)

	IF /I [%RUN_SILENT%] EQU [false] (
		Call :Log INFO		, "Running in interactive mode"
		Call :InstallationMode
		Call :eftlinkPort 0 10100
		Call :eftlinkPort 1 10101
		Call :UserInput
	) else (
		echo installationMode = standalone>>%_ANSWER_FILE%
		echo ServerChannel0 = 10100 >>%_ANSWER_FILE%
		echo ServerChannel1 = 10101 >>%_ANSWER_FILE%
		set /A Counter=0
		
		IF [%1] EQU [] (
			SET RUN_SILENT=false
			Call :Log INFO		, "Running in interactive mode"
			Call :InstallationMode
			Call :eftlinkPort 0 10100
			Call :eftlinkPort 1 10101
			Call :UserInput
		) else (
				FOR %%a IN (%*) do (
					Call :GetCores %%a, !Counter!
					if !Counter! GTR 0 (
						SET RUN_SILENT=true
						
						Call :DesignatedCores %%a, !Counter!, EwalletCore
						Call :DesignatedCores %%a, !Counter!, GiftCardCore
						Call :DesignatedCores %%a, !Counter!, CustomFormCore
						Call :DesignatedCores %%a, !Counter!, ReferralCore
						Call :DesignatedCores %%a, !Counter!, PayByLinkCore
					) else (
						echo EwalletCore = 0 >>%_ANSWER_FILE%
						echo GiftCardCore = 0 >>%_ANSWER_FILE%
						echo CustomFormCore = 0 >>%_ANSWER_FILE%
						echo ReferralCore = 0 >>%_ANSWER_FILE%
						echo PayByLinkCore = 0 >>%_ANSWER_FILE%
					)
					set /A Counter+=1
				)
				
				echo ServerChannel0 = 10100>>%_ANSWER_FILE%
				echo ServerChannel1 = 10101>>%_ANSWER_FILE%
				echo NumEPSCores = !Counter!>>%_ANSWER_FILE%
				
				IF !Counter! GTR 1 (
					Call :Log INFO		, "user configuring a multi core environment"
					echo coreSetup = multicore>>%_ANSWER_FILE%
				) else (
					Call :Log INFO		, "user configuring a single core environment"
					echo coreSetup = singlecore>>%_ANSWER_FILE%
				)
			)
		)

	Call :EFTLink_Install %_ANSWER_FILE%
	
	IF %ERRORLEVEL% EQU 0 (
		Call :Finished
		Exit /B %ERRORLEVEL%
	) else (
		Call :Failed
	)


:InstallationMode

	cls
	Call :Log INFO		, "user input Required: Type in EFTLink Installation Types"

    Echo.
	Echo. EFTLink Installation Types 
	Echo. --------------------------
	Echo.
	Echo. *Stand Alone           - standalone
	Echo. Server                 - server
	Echo. Server + PedPooling    - pedpooling
	Echo.
	Echo. Ex type pedpooling for Server + PedPooling
	Echo.
	SET /P TYPE="Type in from the option above: "
	Echo.
	
	Call :Log INFO		, "user entered: %TYPE%"

				
	IF [%TYPE%] EQU [] (
		echo installationMode = standalone>>%_ANSWER_FILE%
		Exit /B %ERRORLEVEL%
	)
	
	IF /I %TYPE%==standalone (
		echo installationMode = %TYPE%>>%_ANSWER_FILE%
		Exit /B %ERRORLEVEL%

	)
	IF /I %TYPE%==server (
		echo installationMode = %TYPE%>>%_ANSWER_FILE%
		CALL :NumServers
		Exit /B %ERRORLEVEL%

	)	
	IF /I %TYPE%==pedpooling (
		echo installationMode = %TYPE%>>%_ANSWER_FILE%
		CALL :NumServers
		Exit /B %ERRORLEVEL%
	)
	
	Exit /B %ERRORLEVEL%


:NumServers

	cls
	Call :Log INFO		, "user input Required: Type in the Total Number Of Servers"
	
    Echo.
	Echo.
	Echo. Total Number Of Servers 
	Echo. --------------------------

	Echo.
	
	SET /P NUMSERVER="Number of eftlink instances to be hosted: "
	
	Call :Log INFO		, "user entered: %NUMSERVER%"
				
	IF [%NUMSERVER%] EQU [] (
		echo NumServers = 1 >>%_ANSWER_FILE%
	)
	IF NOT [%NUMSERVER%] EQU [] (
	 echo NumServers = %NUMSERVER% >>%_ANSWER_FILE%
	)
	
	Exit /B %ERRORLEVEL%
	
:eftlinkPort
	cls
	Call :Log INFO		, "user input Required: Type in a the Channel %1 Port"

    Echo.
	Echo.
	Echo. EFTlink Port Configuration 
	Echo. --------------------------
	Echo.
	Echo. EFTLink Channel %1 Port       - %2
	Echo.
	
	SET /P PORT="Enter a new value (or press enter to accept the default): "
	
	Call :Log INFO		, "user entered: %PORT%"
				
	IF [%PORT%] EQU [] (
		echo ServerChannel%1 = %2>>%_ANSWER_FILE%
	)
	IF NOT [%PORT%] EQU [] (
	 echo ServerChannel%1 = %PORT%>>%_ANSWER_FILE%
	)
	
	Exit /B %ERRORLEVEL%

:UserInput
	set /A Counter=0
	cls
	Call :Log INFO		, "user input Required: Type in a list of all the cores you wish to activate"
		
    Echo.
	Echo.
	CALL :Listcores
	Echo.
	SET CORES=none
	Echo. Specify more than one core via comma dilimeted list
	Echo. The first specified is the primary core (core0) and all cores Specified after are secondary cores.
	Echo.
	Echo. Ex
	Echo. if typed "OPIRetail,PayByLink" then core0 would equal OPIRetail and core1 would equal PayByLink
	Echo.	
	SET /P CORES="Type in a list of all the cores you wish to activate: "
	
	Call :Log INFO		, "user entered: %CORES%"
	Echo.
		
	IF [%CORES:~0,4%] EQU [none] (
		Call :Log INFO		, "no cores were specified",echo
		echo no cores were specified
		pause
		Exit /B 1
	)
		
	FOR %%a IN (%CORES%) do (
		Call :GetCores %%a, !Counter!
		if !Counter! GTR 0 (
			Call :DesignatedCores %%a, !Counter!, EwalletCore
			Call :DesignatedCores %%a, !Counter!, GiftCardCore
			Call :DesignatedCores %%a, !Counter!, CustomFormCore
			Call :DesignatedCores %%a, !Counter!, ReferralCore
			Call :DesignatedCores %%a, !Counter!, PayByLinkCore
		) else (
			echo EwalletCore = 0 >>%_ANSWER_FILE%
			echo GiftCardCore = 0 >>%_ANSWER_FILE%
			echo CustomFormCore = 0 >>%_ANSWER_FILE%
			echo ReferralCore = 0 >>%_ANSWER_FILE%
			echo PayByLinkCore = 0 >>%_ANSWER_FILE%
		)
				
		IF %ERRORLEVEL% GTR 0 (
		  EXIT /B %ERRORLEVEL%
		)
		set /A Counter+=1
	)
	Echo.
	Echo.
	
	echo NumEPSCores = !Counter!>>%_ANSWER_FILE%
	
	IF !Counter! GTR 1 (
		Call :Log INFO		, "user configuring a multi core environment"
		echo coreSetup = multicore>>%_ANSWER_FILE%
	) else (
		Call :Log INFO		, "user configuring a single core environment"
		echo coreSetup = singlecore>>%_ANSWER_FILE%
	)
	
	Exit /B %ERRORLEVEL%


:DesignatedCores
	set coreName=%1
	set value=%2
	set key=%3

	SET INPUTNAME=N
	Call :Log INFO		, "Would you like the %coreName% core to handle %key:~0,-4% transaction."
	
	cls
	Echo.
	SET /P INPUTNAME="Would you like the %coreName% core to handle %key:~0,-4% transactions?<Y/*N>: "
	
	Call :Log INFO		, "user entered: %INPUTNAME%"
		
	IF /I [%INPUTNAME%] EQU [Y] (
	 echo %key% = %value% >>%_ANSWER_FILE%
	)
	IF /I [%INPUTNAME%] EQU [Yes] (
	 echo %key% = %value% >>%_ANSWER_FILE%
	)
	
	Exit /B 0


:GetCores

	Call :Log INFO		, "Retriving details for EFTLink Core %1",echo
	
	IF [%2] EQU [] (
	 set n=0
	)
	IF [%2] EQU [0] (
	 set n=0
	)
	IF [%2] GTR [0] (
	 set n=%2
	)
	
	set coreName=
	set class=
		
	IF /I %1==Geidea (
		set coreName=Geidea
		set class=com.asq.geidea.AsqGeideaCore
	)	
	IF /I %1==Adyen (
		set coreName=Adyen
		set class=manito.eft.adyen.AdyenCore
	)
	IF /I %1==Cayan (
		Set coreName=Cayan
		Set class=manito.eft.cayan.CayanCore
	)
	IF /I %1==FIPay (
		Set coreName=FIPay
		Set class=manito.eft.ajb.FIPayCore
	)
	IF /I %1==OciusSentinel (
		Set coreName=OciusSentinel
		Set class=manito.eft.ocius_sentinel.OciusSentinelCore
	)
	IF /I %1==OPIRetail (
		Set coreName=OPIRetail
		Set class=oracle.eftlink.opiretail.OPIRetailCore
	)
	IF /I %1==PayByLink (
		Set coreName=PayByLink
		Set class=oracle.eftlink.paybylink.PayByLinkCore
	)
	IF /I %1==PayPal (
		Set coreName=PayPal
		Set class=oracle.eftlink.paypal.PayPalCore
	)
	IF /I %1==PointUS (
		Set coreName=PointUS
		Set class=manito.eft.pointus.PointUSCore
	)
	IF /I %1==SixPay (
		Set coreName=SixPay
		Set class=manito.eft.sixpay.SixpayMPDOPIClient
	)
	IF /I %1==SolveConnect (
		Set coreName=SolveConnect
		Set class=manito.eft.solveconnect.SolveConnectCore
	)
	IF /I %1==TenderRetail (
		Set coreName=TenderRetail
		Set class=manito.eft.tenderretail.TenderRetailCore
	)
	IF /I %1==WorldPay (
		Set coreName=WorldPay
		Set class=manito.eft.worldpay.WorldPayCore
	)

	IF [%coreName%] EQU [] (
		cls
		Set errorlevel=-1
		Echo.
		CALL :Listcores
		CALL :Failed "Invalid core: %1"
	)
	
	echo EPSCore!n! = %class% >>%_ANSWER_FILE%
	
	
	Exit /B %ERRORLEVEL%

:EFTLink_Install

	Call :Log INFO		, "EFTLink_Install"
	Call :Log INFO		, "Setting classpath %classpath%"
	set classpath=.;./eftlink.jar;./lib/log4j-1.2-api-2.20.0.jar;./lib/log4j-api-2.20.0.jar;./lib/log4j-core-2.20.0.jar;
	
	Call :Log INFO		, "Running manito.eft.install.Install -i "%1""
	Call c:\jre\bin\java manito.eft.install.Install -i %1

	Exit /B %ERRORLEVEL%

:Failed
	IF /I [%RUN_SILENT%] EQU [false] pause
	Exit %ERRORLEVEL%

:Finished
	Echo.
	Echo.
	Call :Log FINISHED, "Installation complete",echo
	IF /I [%RUN_SILENT%] EQU [false] pause
	Exit /B %ERRORLEVEL%

:Log
	FOR /F "delims=" %%I IN (%2) DO SET msg=%%I
	
	IF [%3] EQU [echo] (
	Echo   %1 %msg%
	)
		
	Echo %DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%,%TIME:~0,2%:%TIME:~3,2%	%1	%msg%	  >>%LOGFILE%
	Exit /B 0

:Listcores
	Echo. Available Cores
	Echo. ---------------
	Echo. Adyen           - Adyen
	Echo. Cayan           - Cayan
	Echo. FIPay           - AJB FIPay
	Echo. OciusSentinel   - Verifone Ocius Sentinel
	Echo. OPIRetail       - OPIRetail
	Echo. PayByLink       - PayByLink (as secondary core only)
	Echo. PayPal          - PayPal (supports Ewallet transactions only)
	Echo. PointUS         - Verifone Point (US)
	Echo. SixPay          - Six Payment Services MPD
	Echo. SolveConnect    - The Logic Group SolveConnect
	Echo. TenderRetail    - TenderRetail
	Echo. WorldPay        - WorldPay
	Echo. Geidea          - Geidea
	Exit /B 0