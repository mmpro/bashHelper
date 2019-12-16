#!/usr/bin/env bash
# Creates key and certificate for a given domain using RSA 2048 as default (https://docs.aws.amazon.com/acm/latest/userguide/import-certificate-prerequisites.html)

read -p 'Enter domain: ' domain
read -p "Enter RSA [2048]: " rsa
rsa=${rsa:-2048}

date=`date +'%Y%m%d'`
key=${date}_${domain}_${rsa}.key
csr=${date}_${domain}_${rsa}.csr

echo ""
echo "Key: $key"
echo "CSR: $csr"
echo ""

openssl req -new -newkey rsa:$rsa -nodes -keyout $key -out $csr

