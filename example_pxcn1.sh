#!/bin/bash

pas=""
usr=""
hst=""
prt=""
tps=""
tar=""

# The -ignore HUP ignores expect end sending SIGHUP to spawn subprocess
# therefore allowing the spawn subprocess continue to exist
/usr/bin/expect << EOF
set timeout 10
spawn -ignore HUP ssh -D ${tar} ${usr}@${hst} -p ${prt}
expect "assword"
send "${pas}\r"
interact
EOF
echo -ne "\n"
sleep 1
sshpid=$(netstat -antup | grep "127.0.0.1:${tar}" | grep ssh | awk '{print $NF}' | awk -F/ '{print $1}')
echo "$0: Dynamic link to ${usr}@${hst}:${prt} at ${tar} established with ${sshpid} PID."

pxy="${tps} 127.0.0.1 ${tar} ${usr} ${pas}"
cat ./my_t_conf_pxcn | sed 's:PPPPP1:'"${pxy}"':g' > /etc/proxychains.conf
echo "$0"': ./my_t_conf_pxcn write to /etc/proxychains.conf for proxychains4.'
echo "$0"':   > proxychains4 curl www.google.com < is available.'

cat ./my_t_conf_v2ray | sed 's:PPPPP:'"${tar}"':g' > ./my_t_conf_v2ray.tmp
echo "$0"': ./my_t_conf_v2ray write to ./my_t_conf_v2ray.tmp for v2ray.'
