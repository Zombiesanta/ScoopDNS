#!/bin/sh

ns=(
  ns1.inmotionhosting.com ns2.inmotionhosting.com
  ns1.webhostinghub.com ns2.webhostinghub.com
  8.8.8.8 8.8.4.4
)

sdns="dig +multiline +noall +answer +nocmd"

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
$sdns $domain NS

echo -e "\n A \n------------------------------"
$sdns $domain A

echo -e "\n MX \n------------------------------"
$sdns $domain MX

echo -e "\n TXT \n------------------------------"
$sdns $domain TXT

echo -e "\n DMARC \n------------------------------"
$sdns _dmarc.$domain TXT

echo -e "\n PTR \n------------------------------"
echo $(dig +short -x `dig +short awoa.com`) [ RDNS: `dig +short awoa.com` ]

echo -e "\n SRV \n------------------------------"
$sdns $domain SRV

echo -e "\n Host \n------------------------------"
host $domain

echo -e "\n SOA \n------------------------------"
$sdns $domain SOA
echo
