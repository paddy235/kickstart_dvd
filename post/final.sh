#!/usr/bin/env bash
# checking post setting
# =================================

echo "checking post setting"
echo "============================"
sleep 0.5

# create user
# =================================
echo "user"
echo "============================"
tail -n 2 /etc/passwd
echo
sleep 1

# password policy
# =================================
echo "password policy"
echo "============================"
grep ^PASS_ /etc/login.defs
echo
sleep 1

# ssh 
# =================================
echo "ssh config"
echo "============================"
grep ^Permit /etc/ssh/sshd_config
grep ^UseDNS /etc/ssh/sshd_config
echo
sleep 1

# control+alt+del
# =================================
echo "disable control+alt+delete"
echo "============================"
grep start /etc/init/control-alt-delete.conf
echo
sleep 1

# repo
echo "repository"
# =================================
echo "============================"
grep ^baseurl /etc/yum.repos.d/CentOS-Base.repo
echo
sleep 1

# service
# =================================
echo "services"
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
sleep 0.5

echo "Public - 1.1.1.x/26"
echo -n "Enter the IP address last octet : "
read PUB_ADDRESS
echo "Private - 192.168.212.x/24"
echo -n "Enter the IP address last octet : "
read PRI_ADDRESS
echo

echo "GATEWAY=1.1.1.129"
echo "GATEWAY=1.1.1.129" >> /etc/sysconfig/network
cat /etc/sysconfig/network
echo

cp -f /root/post/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "5s/^IPADDR=/IPADDR=1.1.1.${PUB_ADDRESS}/" /etc/sysconfig/network-scripts/ifcfg-eth0
cat /etc/sysconfig/network-scripts/ifcfg-eth0

cp -f /root/post/ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i "5s/^IPADDR=/IPADDR=192.168.212.${PRI_ADDRESS}/" /etc/sysconfig/network-scripts/ifcfg-eth1
cat /etc/sysconfig/network-scripts/ifcfg-eth1
echo

# restart network
# =================================
#/etc/init.d/network restart
#echo

# check ip address
# =================================
ifconfig
echo

# check network using ping command
# =================================
#ping -c 3 ${I_GATEWAY}

# add DNS
# =================================
echo "add DNS - 8.8.8.8"
echo "============================"
echo "nameserver 8.8.8.8" > /etc/resolv.conf
cat /etc/resolv.conf
echo

# update
# =================================
yum -y update

# ntp
# =================================
yum -y install ntpdate
echo "0 0 * * * root /usr/sbin/ntpdate tw.pool.ntp.org > /dev/null 2>&1 && /sbin/hwclock -w" >> /etc/crontab
ntpdate tw.pool.ntp.org
echo
date
echo

# change password
# =================================
passwd test_user
echo

# clear
# =================================
rm -f /root/post/ifcfg-eth0 /root/post/ifcfg-eth1 /root/post/CentOS-Base.repo

echo "done"
