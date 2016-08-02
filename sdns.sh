#!/bin/bash

domain=$1
if [ -z "$1" ]; then
  echo "Error: You need to pass a domain! Exiting..."
  exit
fi

cat << EOF

 ========================================
 => ScoopDNS - Just scoop the DNS
 ========================================

EOF

ns=(
  ns1.inmotionhosting.com
  ns1.webhostinghub.com
  8.8.8.8
)

header() {
  echo -e "\n $title\n------------------------------"
}

digger() {
  sdns="dig +multiline +noall +answer +nocmd"

  for n in ${ns[@]}; do
    $sdns $n $sub$domain $type
  done
}

sorter() {
  sort | uniq
}

title="Nameservers"
header
type=NS
digger | sorter

title="A"
header
type=A
digger | sorter

title="MX"
header
type=MX
digger | sorter

title="TXT"
header
type=TXT
digger | sorter

title="DMARC"
sub="_dmarc"
type=TXT
header
digger | sorter
sub=""

title="RDNS"
header
for n in ${ns[@]}; do
  rdns=`dig $n +short $domain`
  echo $(dig $n +short -x $rdns) [ RDNS: $rdns ]
done

title="SRV"
type=SRV
header
digger | sorter

title="SOA"
type=SOA
header
digger | uniq

echo
