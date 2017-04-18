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

# add DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
cat /etc/resolv.conf

# update
yum -y update

# ntp
yum -y install ntpdate
echo "0 0 * * * root /usr/sbin/ntpdate tw.pool.ntp.org > /dev/null 2>&1 && /sbin/hwclock -w" >> /etc/crontab
ntpdate tw.pool.ntp.org
date

# interactive network setting
# add gateway
# add ip address
