#!/bin/sh

digger="dig +multiline +noall +answer +nocmd"

domain=$1

if [ -z "$1" ]; then
  echo "Error: You need to pass a domain! Exiting..."
  exit
fi

cat << EOF

  ScoopDNS - Just scoop the DNS
 ========================================
EOF

echo -e "\n NS \n------------------------------"
$digger $domain NS

echo -e "\n A \n------------------------------"
$digger $domain A

echo -e "\n MX \n------------------------------"
$digger $domain MX

echo -e "\n TXT \n------------------------------"
$digger $domain TXT

echo -e "\n DMARC \n------------------------------"
$digger _dmarc.$domain TXT

echo -e "\n SRV \n------------------------------"
$digger $domain SRV

echo -e "\n SOA \n------------------------------"
$digger $domain SOA

echo -e "\n Host \n------------------------------"
host $domain

echo
