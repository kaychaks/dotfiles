#!/bin/bash

CA_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
CTS_CERT_LOC=/Users/kaushik/Developer/Keys/certs

for f in $CTS_CERT_LOC/*.pem
do
    echo "adding cert $f..."
    cat "$f" >> $CA_CERT_FILE
done

echo "restarting docker..."
service docker restart

echo "done"
