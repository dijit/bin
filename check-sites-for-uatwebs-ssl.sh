#!/bin/bash 
#
# Checks which hosts in your /etc/hosts file are up or down
#
# Author: Jan Harasym <janharasym@venda.com>
# Purpose: Check Paypal sites work with DNS records.

ENABLE_IPV6=true
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

OK="[  ${GREEN}OK${RESET}  ]"
DOWN="[ ${RED}DOWN${RESET} ]"

#ipv4
grep -Ev '(^[#$]|::|0\.0\.0\.0)' /etc/hosts | tr '\t' ' ' | \
cut -d ' ' -f1  | xargs -I@ echo openssl s_client -connect @:443 '&>/dev/null' '&&' echo -e @ \
"\"${OK}"\" '||' echo -e @ "\"[${RED}DOWN${RESET}]"\"" | bash | awk '{ printf "%-22s %s\n", $1, $2 }'

if [ $ENABLE_IPV6 == true ]
then
    #ipv6 
    grep "::" /etc/hosts | grep -v "^$" | tr '\t' ' ' | \
    cut -d ' ' -f1 | xargs -I@ echo ping6 -W2 -c1 @ '&>/dev/null' '&&' echo -e @ \
    "\"[${GREEN}OK${RESET}]\"" '||' echo -e @ "\"[${RED}DOWN${RESET}]\"" \
    | bash | awk '{ printf "%-22s %s\n", $1, $2 }'
fi

