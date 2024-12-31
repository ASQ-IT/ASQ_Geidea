# encrypt
export CLASSPATH=.:./cores/PayPal/PayPalCore.jar:../cores/PayPal/PayPalCore.jar:./eftlink.jar:../../lib/log4j-1.2-api-2.20.0.jar:../../lib/log4j-api-2.20.0.jar:../../lib/log4j-core-2.20.0.jar:

/opt/jre/bin/java -cp $CLASSPATH oracle.eftlink.paypal.encryption.EncryptionApp $1 $2 $3 $4 $5 $6 $7