#!/bin/bash

    RED='\e[91m'
    GREEN='\e[32;m'
    BLUE='\033[36m'
    BLACK='\033[30m'
    NC='\033[0m'

    mv -f /root/hinaswifi.sh /usr/bin/wifi
   chmod 777 /usr/bin/wifi
    sed -i '8,13d' /usr/bin/wifi
   echo -e "${BLUE}脚本已安装完成，可以输入wifi进入脚本${NC}"
   echo -e "${BLACK}----------------------------------------------------${NC}"
  
    while true; do
    echo -e "${GREEN}1. 安装wifi驱动${NC}"
    echo -e "${GREEN}2. 卸载wifi驱动${NC}"
    echo -e "${GREEN}3. 连接wifi${NC}"
    echo -e "${GREEN}4. 卸载脚本${NC}"
    echo -e "${GREEN}5. 退出脚本${NC}"
    read -p "请输入选项序号: " choice
case $choice in

1)
    mkdir /root/hinaswifi

    wget -nc -P /root/hinaswifi/ https://ghfast.top/https://github.com/benbenhuo/hinaswifi/raw/main/hi_kernel-mv100-0808.bin
    wget -nc -P /root/hinaswifi/ https://ghfast.top/https://github.com/benbenhuo/hinaswifi/raw/main/wifi_install.sh
    wget -nc -P /root/hinaswifi/ https://ghfast.top/https://github.com/benbenhuo/hinaswifi/raw/main/hiwifi.md5sum
    wget -nc -P /root/hinaswifi/ https://ghfast.top/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188ftv-0808.tar.gz
    wget -nc -P /root/hinaswifi/ https://ghfast.top/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188etv-0808.tar.gz
    chmod 777 /root/hinaswifi/wifi_install.sh

    apt install kmod -y
if [ $? -ne 0 ];then
    sed -i "s|repo.huaweicloud.com|mirrors.tuna.tsinghua.edu.cn|g" /etc/apt/sources.list
    apt update && apt install kmod -y
fi
    
    cd /root/hinaswifi 
    md5sum rtl8188etv-0808.tar.gz rtl8188ftv-0808.tar.gz wifi_install.sh hi_kernel-mv100-0808.bin > hiwifilocal.md5sum
    md5sum hiwifilocal.md5sum -c hiwifi.md5sum
if [ $? -ne 0 ];then
    echo -e "${RED}数据下载异常或者MD5校验未通过${NC}"
    cd
    rm -r /root/hinaswifi
    wifi

else
    echo -e "${GREEN}数据下载成功并且MD5校验通过${NC}"
    dd if=/root/hinaswifi/hi_kernel-mv100-0808.bin of=/dev/mmcblk0p6
fi
    echo -e "${GREEN}安装完成后会自动重启，等待开机后，连接终端选择要连接的wifi${NC}"
    echo -e "${GREEN}想再次连接wifi可以输入“nmtui-connect”${NC}"
    echo -e "${GREEN}选择驱动（RTL8188FTV按y）（RTL8188ETV按n）${NC}"

    echo "#!/bin/bash" > /etc/profile.d/wifi.sh
read -p "(y/n): " gujian

if [ "$gujian" = "y" ]; then
    echo "bash /root/hinaswifi/wifi_install.sh -f /root/hinaswifi/rtl8188ftv-0808.tar.gz" >> /etc/profile.d/wifi.sh
elif [ "$gujian" = "n" ]; then
    echo "bash /root/hinaswifi/wifi_install.sh -f /root/hinaswifi/rtl8188etv-0808.tar.gz" >> /etc/profile.d/wifi.sh
fi

    rm /etc/network/interfaces.d/eth0
    echo "##auto eth0" > /etc/network/interfaces.d/eth0
    echo "allow-hotplug eth0" >> /etc/network/interfaces.d/eth0
    echo "iface eth0 inet dhcp" >> /etc/network/interfaces.d/eth0
    chmod 644 /etc/network/interfaces.d/eth0

    echo "sleep 2s" >> /etc/profile.d/wifi.sh
    echo "rm -r /root/hinaswifi" >> /etc/profile.d/wifi.sh
    echo "rm /etc/profile.d/wifi.sh" >> /etc/profile.d/wifi.sh
    echo "nmtui-connect" >> /etc/profile.d/wifi.sh
    echo "wifi" >> /etc/profile.d/wifi.sh
    chmod 777 /etc/profile.d/wifi.sh
    reboot
    ;;
2)
    modprobe -r rtl8188fu 2>/dev/null
    modprobe -r rtl8188eu 2>/dev/null
    rm -r /usr/lib/modules/4.4.35_ecoo_*
    rm /etc/modules-load.d/wifi.conf
    depmod -a
    echo -e "${GREEN}删除wifi驱动完成${NC}"
    ;;
3)
    nmtui-connect
    ;;
4)
    rm /usr/bin/wifi
    echo -e "${GREEN}卸载脚本完成，再见${NC}"
    exit 1
    ;;
5)
    exit 1
    ;;
*)
    echo -e "${RED}无效的选择${NC}"
    ;;

esac
done
 
