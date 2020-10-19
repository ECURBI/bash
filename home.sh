// CentOS 7 开启BBR //
# 下载更换内核
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y

# 更新 grub 系统引导文件并重启
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'

# default 0表示第一个内核设置为默认运行, 选择最新内核就对了
grub2-set-default 0  

# 重启
reboot

# 开启BBR
# 开机后 uname -r 看看是不是内核4.9、4.10或4.11
# 执行 lsmod | grep bbr，如果结果中没有 tcp_bbr 的话就先执行

modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

# 保存生效
sysctl -p

# 执行
lsmod | grep bbr
# 如果结果都有bbr, 则证明你的内核已开启bbr。

// Azure 开启root登录 //
vim /etc/ssh/sshd_config

# 在 sshd_config 文件里的 “Authentication” 部分加上以下内容
PermitRootLogin yes
# 完成以后退出 vim 并保存

service sshd restart # 重启 ssh 服务以应用更改
passwd root # 直接修改 Root 用户的密码


