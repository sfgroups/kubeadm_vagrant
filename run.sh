
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

systemctl stop firewalld
systemctl disable firewalld

yum install -y yum-utils 
yum install -y epel-release

yum install -y docker ntp etcd flannel net-tools wget util-linux socat lsof ansible htop

systemctl stop ntpd
timedatectl   set-timezone  America/New_York
ntpdate pool.ntp.org
systemctl enable ntpd
systemctl start ntpd
 
 modprobe br_netfilter
lsmod |grep  br_netfilter
sysctl -w net.bridge.bridge-nf-call-ip6tables=1 net.bridge.bridge-nf-call-iptables=1

