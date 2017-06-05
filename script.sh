#!/bin/bash

date > /tmp/date.out

sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin yes/;s/.*PasswordAuthentication.*$/PasswordAuthentication yes/;s/^.*PubkeyAuthentication.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

F='/root/.ssh/authorized_keys'
if [ -f "$F" ] ; then
	chmod 600 $F
	chown root:root $F
fi 
