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
  8.8.8.8
  77.88.8.8
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
digger | sort | uniq

title="A"
type=A
header
digger | sort | uniq

title="MX"
type=MX
header
digger | sort | uniq

title="TXT"
type=TXT
header
digger | sort | uniq

title="DMARC"
sub="_dmarc"
type=TXT
header
digger | sort | uniq

title="RDNS"
header
for n in ${ns[@]}; do
  rdns=`dig $n +short $domain`
  echo $(dig $n +short -x $rdns) [ RDNS: $rdns ]
done

title="SRV"
type=SRV
header
digger | sort | uniq

title="SOA"
type=SOA
header
digger | sort | uniq

echo
