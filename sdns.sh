#!/bin/sh

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
  8.8.8.8 8.8.4.4
  77.88.8.8 77.88.8.1
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

title="Nameservers"
type=NS
header
digger

title="A"
type=A
header
digger

title="MX"
type=MX
header
digger

title="TXT"
type=TXT
digger

title="DMARC"
sub="_dmarc"
type=TXT
header
digger

title="RDNS"
header
for n in ${ns[@]:1:3}; do
  rdns=`dig $n +short $domain`
  echo $(dig $n +short -x $rdns) [ RDNS: $rdns ]
done

title="SRV"
type=SRV
header
digger

title="SOA"
type=SOA
header
digger

echo
