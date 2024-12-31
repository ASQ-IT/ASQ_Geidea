#!/bin/bash
clear
EFTCORE=$1
EFTCORE=${EFTCORE,,}
DATE=$(date +"%d"-"%m"-"%Y","%H":"%M")
LOGFILE=$(basename ${0} .sh)
LOG=./log/$BUILDID.log

echo ------------------
echo Installing EFTLink
echo ------------------
echo $DATE		START		Installing EFTLink >>$LOG
 
export JAVA_HOME=/opt/jre
export JAVA=$JAVA_HOME/bin/java

if [ -f "$JAVA" ]; then

	if [[ $($JAVA -version 2>&1) == *"64-Bit"* ]]; then
	 if [ -d "linux_64/bin" ]; then
		echo
		echo Copying 64-Bit wrapper files to bin
		echo $DATE INFO		Copying 64-Bit wrapper files to bin >>$LOG
		echo
		cp -vr linux_64/bin .
	 fi
	else 
	 if [ -d "linux/bin" ]; then
		echo
		echo Copying 32-Bit wrapper files to bin
		echo $DATE INFO		Copying 32-Bit wrapper files to bin >>$LOG
		echo
		cp -vr linux/bin .
	 fi
	fi
else
	echo
	echo *WARNING* $JAVA not found!
	echo $DATE	WARN		$JAVA not found! >>$LOG
	echo 	Defaulting to 64 bit
	echo $DATE	WARN		Defaulting to 64 bit >>$LOG
	
	echo Copying 64-Bit wrapper files to bin
	echo $DATE	WARN		Copying 64-Bit wrapper files to bin >>$LOG
	echo
	cp -vr linux_64/bin .
fi

chmod +x bin/wrapper
chmod +x eftlink.sh

case $EFTCORE in
	adyen|Adyen )
	 FOLDER=Adyen
	 CLASS=manito.eft.adyen.AdyenCore
	 ;;
	cayan|Cayan )
	 FOLDER=Cayan
	 CLASS=manito.eft.cayan.CayanCore
	 ;;	
	fipay|Fipay|FIPay|ajb )
	 FOLDER=FIPay
	 CLASS=manito.eft.ajb.FIPayCore
	 ;;
	ociussentinel|OciusSentinel|ocius )
	 FOLDER=OciusSentinel
	 CLASS=manito.eft.ocius_sentinel.OciusSentinelCore
	 ;;	 
	opiretail|OPIRetail|opiRetail )
	 FOLDER=opiRetail
	 CLASS=oracle.eftlink.opiretail.OPIRetailCore
	 ;;	
	pointus|PointUS )
	 FOLDER=PointUS
	 CLASS=manito.eft.pointus.PointUSCore
	 ;;
	sixpay|SixPay )
	 FOLDER=SixPay
	 CLASS=manito.eft.sixpay.SixpayMPDOPIClient
	 ;;
	solveconnect|SolveConnet|solve )
	 FOLDER=SolveConnect
	 CLASS=manito.eft.solveconnect.SolveConnectCore
	 ;;
	tenderretail|TenderRetail )
	 FOLDER=TenderRetail
	 CLASS=manito.eft.tenderretail.TenderRetailCore
	 ;;	 
	worldpay|WorldPay )
	 FOLDER=WorldPay
	 CLASS=manito.eft.worldpay.WorldPayCore
	 ;;
	 	 
	* )
	echo available cores
	echo ---------------
	echo Adyen           - Adyen
	echo Cayan           - Cayan
	echo FIPay           - AJB FIPay
	echo OciusSentinel   - Verifone Ocius Sentinel
	echo OPIRetail		 - OPIRetail
	echo PointUS         - Verifone Point US
	echo Sixpay          - Six Payment Services MPD
	echo SolveConnect    - The Logic Group SolveConnect
	echo TenderRetail    - TenderRetail
	echo WorldPay        - WorldPay
	return 0
esac

echo
echo Installing $FOLDER Core
echo $DATE		INFO		Installing $FOLDER Core  >>$LOG
echo
echo Copying core files to eftlink folder
echo $DATE	INFO		Copying core files to eftlink folder >>$LOG
echo		
cp -v cores/$FOLDER/*.properties . 2>/dev/null
cp -v cores/$FOLDER/*.sh . 2>/dev/null 
cp -v cores/$FOLDER/*.xml . 2>/dev/null


echo Setting core 0 to $CLASS
echo $DATE	INFO		Setting core 0 to %class%  >>$LOG
echo
sed s/^EPSCore0.*/'EPSCore0 = '$CLASS/ EftlinkConfig.properties > EftlinkConfig.tmp
echo
cp -v EftlinkConfig.tmp EftlinkConfig.properties
rm -v EftlinkConfig.tmp

echo
echo 	'***Installation complete***'
echo $DATE	FINISHED	Installation complete	  >>$LOG
