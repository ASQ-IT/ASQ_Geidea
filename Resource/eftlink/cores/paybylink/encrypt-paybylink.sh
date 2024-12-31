# encrypt
export CLASSPATH=.:./cores/paybylink/paybylink.jar:../cores/paybylink/paybylink.jar:./eftlink.jar:./lib/log4j-1.2-api-2.20.0.jar:./lib/log4j-api-2.20.0.jar:./lib/log4j-core-2.20.0.jar:

/opt/jre/bin/java -cp $CLASSPATH oracle.eftlink.paybylink.encryption.EncryptorUtility $1 $2 $3 $4 $5 $6 $7 $8 $9