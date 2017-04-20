#!/usr/bin/env bash
# checking post setting
# =================================

echo "checking post setting"
echo "============================"
sleep 1

# create user
echo "============================"
tail -n 2 /etc/passwd
echo
sleep 1

# password policy
echo "============================"
grep ^PASS_ /etc/login.defs
echo
sleep 1

# ssh 
echo "============================"
grep ^Permit /etc/ssh/sshd_config
grep ^UseDNS /etc/ssh/sshd_config
echo
sleep 1

# control+alt+del
echo "============================"
grep start /etc/init/control-alt-delete.conf
echo
sleep 1

# repo
echo "============================"
grep ^baseurl /etc/yum.repos.d/CentOS-Base.repo
echo
sleep 1

# service
echo "============================"
chkconfig --list | grep 3:on
echo
echo
sleep 1

# final settings after installation 
# using networking
# =================================

echo "network setting"
echo "============================"
sleep 1

echo "step1. Public"
echo -n "IP : "
read I_ADDRESS

echo -n "Netmask : "
read I_NETMASK

echo -n "Gateway : "
read I_GATEWAY

echo "GATEWAY=$I_GATEWAY" >> /etc/sysconfig/network

cp -f ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "5s/^IPADDR=/IPADDR=$I_ADDRESS/" /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "6s/^NETMASK=/NETMASK=$I_NETMASK/" /etc/sysconfig/network-scripts/ifcfg-eth0

echo "step2. Private"
echo -n "IP : "
read I_ADDRESS

echo -n "Netmask : "
read I_NETMASK

cp -f ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i "5s/^IPADDR=/IPADDR=$I_ADDRESS/" /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i "6s/^NETMASK=/NETMASK=$I_NETMASK/" /etc/sysconfig/network-scripts/ifcfg-eth1

# restart network
/etc/init.d/network restart
echo

# check ip address
ifconfig
echo


# add private route
#route add -net x.x.x.x netmask x.x.x.x gw x.x.x.x
#echo "route add -net x.x.x.x netmask x.x.x.x gw x.x.x.x" >> /etc/rc.local

# check network using ping command
#ping -c 3 ${I_GATEWAY }
#ping -c 3 x.x.x.x

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
rm -f ifcfg-eth0 ifcfg-eth1 CentOS-Base.repo

passwd test_user
echo

echo "done"
