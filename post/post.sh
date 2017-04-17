#!/usr/bin/env bash

# linux settings after installation
# =================================

# add iiu account
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

# copy repository file
cp -f /root/CentOS-Base.repo /etc/yum.repos.d
