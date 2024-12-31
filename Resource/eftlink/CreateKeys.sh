# CreateKeys
export CLASSPATH=.:eftlink.jar:lib/log4j-1.2-api-2.20.0.jar:lib/log4j-api-2.20.0.jar:lib/log4j-core-2.20.0.jar

# example usage:
# ./CreateKeys.sh -e RSA 4096 SHA256withRSA 750
# or
# ./CreateKeys.sh -e RSA 4096 SHA256withRSA 750 -dname 

/opt/jre/bin/java -cp $CLASSPATH manito.eft.tls.Keygen $1 $2 $3 $4 $5 $6