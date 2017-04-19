#!/usr/bin/env bash
# checking post setting
# =================================

echo "==== checking post setting"
sleep 1

# create user
tail -n 2 /etc/passwd
echo
sleep 1

# password policy
grep ^PASS_ /etc/login.defs
echo
sleep 1

# ssh 
grep ^Permit /etc/ssh/sshd_config
grep ^UseDNS /etc/ssh/sshd_config
echo
sleep 1

# control+alt+del
grep start /etc/init/control-alt-delete.conf
echo
sleep 1

# repo
grep ^baseurl /etc/yum.repos.d/CentOS-Base.repo
echo
sleep 1

# service
chkconfig --list | grep 3:on
echo
echo
sleep 1

# final settings after installation 
# using networking
# =================================

echo "==== network setting"
sleep 1

# input
echo "step1. Public"
echo -n "IP : "
read I_ADDRESS

echo -n "Netmask : "
read I_NETMASK

echo -n "Gateway : "
read I_GATEWAY

echo "$I_ADDRESS $I_NETMASK $I_GATEWAY"

# interactive network setting
# add gateway
echo "GATEWAY=$I_GATEWAY" >> /etc/sysconfig/network

# add public ip address
cp -f ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "5s/^IPADDR=/IPADDR=$I_ADDRESS/" /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "6s/^NETMASK=/NETMASK=$I_NETMASK/" /etc/sysconfig/network-scripts/ifcfg-eth0

# add private ip address
# cp -f ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1
echo

/etc/init.d/network restart
echo

ifconfig
echo

# add DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
cat /etc/resolv.conf
echo

# update
yum -y update

# ntp
yum -y install ntpdate
echo "0 0 * * * root /usr/sbin/ntpdate tw.pool.ntp.org > /dev/null 2>&1 && /sbin/hwclock -w" >> /etc/crontab
ntpdate tw.pool.ntp.org
echo
date
echo

# clear
rm -f ifcfg-eth0 ifcfg-eth1


passwd test_user
echo

echo "done"
