#!/usr/bin/env bash

# jq path
JQP=/usr/local/bin/jq

set -e

read -p 'Domain (defaults to media.admiralcloud.com): ' DOMAIN
DOMAIN=${DOMAIN:=media.admiralcloud.com}

TRC=$(host $DOMAIN | head -1 | perl -pe 'if(($v)=/(([0-9]+([.][0-9]+)+))/){print"$v\n";exit}$_=""')
echo "Detected IP: $TRC"

LOCDOM=$(dig -x $TRC +short)
LOC=$(dig -x $TRC +short | perl -pe 'if(($v)=/(\w.*)\.(\w{4,6})\./){print"$2\n";exit}$_=""' | tr [a-z] [A-Z])
#echo "Resolves to $LOC"

PATH='.'$LOC
L=$($JQP $PATH locations.json)
if [ $L="null" ]; then
  echo "$DOMAIN is delivered via $LOCDOM"
else
  echo "$DOMAIN is using AWS CF Edge $LOC in $L"
fi

