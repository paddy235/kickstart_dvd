#!/usr/bin/env bash

# kickstart post settings
# =================================

# create account
useradd -G wheel test_user
echo 'test_user:qwer1234' | chpasswd

# modify password policy
sed -i "25s/99999/60/" /etc/login.defs
sed -i "26s/0/1/" /etc/login.defs
sed -i "27s/5/8/" /etc/login.defs
sed -i "28s/7/14/" /etc/login.defs

# modify ssh configuration
sed -i "42s/#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "65s/#PermitEmptyPasswords no/PermitEmptyPasswords no/" /etc/ssh/sshd_config
sed -i "122s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

# disable control+alt+del
sed -i "9s/start on control-alt-delete/#start on control-alt-delete/" /etc/init/control-alt-delete.conf

# copy repository file
cp -f /root/post/CentOS-Base.repo /etc/yum.repos.d

# service disable
chkconfig --level 3 auditd off
chkconfig --level 3 cpuspeed off
chkconfig --level 3 kdump off
chkconfig --level 3 rdma off
chkconfig --level 3 iptables off
chkconfig --level 3 ip6tables off
chkconfig --level 3 lvm2-monitor off
chkconfig --level 3 mdmonitor off
chkconfig --level 3 netfs off
