# encrypt
export CLASSPATH=.:./cores/OciusSentinel/ociussentinelcore.jar:../cores/OciusSentinel/ociussentinelcore.jar:./eftlink.jar:./lib/log4j-1.2-api-2.20.0.jar:./lib/log4j-api-2.20.0.jar:./lib/log4j-core-2.20.0.jar:

/opt/jre/bin/java -cp $CLASSPATH manito.eft.ocius_sentinel.Main $1 $2 $3 $4 $5 $6 $7 $8 $9