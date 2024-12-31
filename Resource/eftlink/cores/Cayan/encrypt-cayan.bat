@echo off
set classpath=.;./cores/Cayan/cayancore.jar;../cores/Cayan/cayancore.jar;./eftlink.jar;./lib/log4j-1.2-api-2.20.0.jar;./lib/log4j-api-2.20.0.jar;./lib/log4j-core-2.20.0.jar;

set /a paramcounter=1

:getnextarg

if "%1"=="" goto nomoreargs
set arg%paramcounter%=%1
shift
set /a paramcounter=%paramcounter%+1
goto getnextarg

:nomoreargs

c:\jre\bin\java manito.eft.cayan.Main %arg1% %arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8% %arg9% %arg10% %arg11%
pause