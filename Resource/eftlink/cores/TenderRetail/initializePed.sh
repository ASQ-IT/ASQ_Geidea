# encrypt
export CLASSPATH=.:./cores/tenderretail/epstenderretail.jar:./eftlink.jar:./lib/log4j-1.2-api-2.20.0.jar:./lib/log4j-api-2.20.0.jar:./lib/log4j-core-2.20.0.jar:

java -cp $CLASSPATH manito.eft.tenderretail.Main -i $1 $2 $3 $4 $5 $6 $7 $8