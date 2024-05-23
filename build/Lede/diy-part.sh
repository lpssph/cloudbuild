#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好


# 后台IP设置
export Ipv4_ipaddr="10.0.0.1"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="0"                # 修改主机名称为OpenWrt(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="16"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算，填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="500"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算，填0为不作修改),如果你不懂就填0

# 默认主题设置
export Mandatory_theme="0"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="0"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="0"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="0"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="0"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="0"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6、IPV4 选择
export Enable_IPV6_function="1"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="0"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)

# 替换passwall的源码(默认luci分支)
export PassWall_luci_branch="0"             # passwall的源码分别有【luci分支】和【luci-smartdns-new-version分支】(填0为使用luci分支,填1为使用luci-smartdns-new-version分支)

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为使用master分支,填1为使用dev分支)
export OpenClash_Core="2"                   # 增加OpenClash时,把核心下载好,(填1为下载【dev单核】,填2为下载【dev/meta/premium三核】,填0为不需要核心)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="0"  # 个性签名,你想写啥就写啥，(填0为不作修改)

# 更换固件内核
export Replace_Kernel="6.6"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)

# 禁用ssrplus和passwall的NaiveProxy
export Disable_NaiveProxy="1"                # 因个别源码的分支不支持编译NaiveProxy,不小心选择了就编译错误了,为减少错误,打开这个选项后,就算选择了NaiveProxy也会把NaiveProxy干掉不进行编译的(1为启用命令,填0为不作修改)

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="0"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)

# 去除网络共享(autosamba)
export Disable_autosamba="0"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)

# 强制显示2500M和全双工（默认PVE下VirtIO不识别）
# sed -i '/exit 0/i\ethtool -s eth0 speed 10000 duplex full' /etc/rc.local

# 手动更换默认主题
# uci set luci.main.mediaurlbase='/luci-static/neobird' && uci commit luci

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    # find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}
rm -rf package/custom; mkdir package/custom

# 替换文件
wget -O ./package/kernel/linux/modules/netsupport.mk https://raw.githubusercontent.com/0118Add/X86-N1-Actions/main/general/netsupport.mk

# 修改系统文件
curl -fsSL https://raw.githubusercontent.com/0118Add/N1-Actions-Dabao56/master/backup/index.htm > ./package/lean/autocore/files/x86/index.htm
curl -fsSL https://raw.githubusercontent.com/0118Add/OpenWrt/main/scripts/autocore > ./package/lean/autocore/files/x86/autocore
curl -fsSL https://raw.githubusercontent.com/0118Add/OpenWrt/main/images/cpuinfo > ./package/lean/autocore/files/x86/sbin/cpuinfo

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y-%m-%d") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore

# 修改连接数
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/8688Add/feeds_packages_lang_node feeds/packages/lang/node

# 移除重复软件包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-serverchan

# 添加额外软件包
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/dae
git clone https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone https://github.com/0118Add/luci-app-vssr package/luci-app-vssr
#merge_package https://github.com/0118Add/openwrt-packages openwrt-packages/luci-app-bypass
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/sing-box
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
#git clone https://github.com/fw876/helloworld.git package/helloworld
merge_package https://github.com/fw876/helloworld helloworld/luci-app-ssr-plus
merge_package https://github.com/fw876/helloworld helloworld/lua-neturl
merge_package https://github.com/fw876/helloworld helloworld/mosdns
merge_package https://github.com/fw876/helloworld helloworld/shadow-tls
merge_package https://github.com/fw876/helloworld helloworld/redsocks2
#git clone https://github.com/xiaorouji/openwrt-passwall2 package/passwall2
git clone https://github.com/QiuSimons/luci-app-daed-next package/luci-app-daed-next
git clone https://github.com/8688Add/luci-theme-argon-dark-mod.git package/luci-theme-argon-dark-mod
git clone https://github.com/justice2001/luci-app-multi-frpc package/luci-app-multi-frpc
git clone -b dev --depth 1 https://github.com/vernesong/OpenClash package/luci-app-openclash
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
git clone https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone -b master https://github.com/0118Add/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-design
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/gngpp/luci-theme-design package/luci-theme-design
# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="0"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="0"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)


# 晶晨CPU系列打包固件设置(不懂请看说明)
export amlogic_model="s905d"
export amlogic_kernel="5.10.01_6.1.01"
export auto_kernel="true"
export rootfs_size="2560"
export kernel_usage="stable"


# 修改插件名字
sed -i 's/Argon 主题设置/Argon设置/g' feeds/luci/applications/luci-app-argon-config/po/zh-cn/argon-config.po
sed -i 's/Design 主题设置/Design设置/g' feeds/luci/applications/luci-app-design-config/po/zh-cn/design-config.po
sed -i 's/一键分区扩容/分区扩容/g' package/luci-app-partexp/po/zh-cn/partexp.po
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/custom/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/Frpc内网穿透/内网穿透/g' package/luci-app-multi-frpc/po/zh-cn/frp.po
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
sed -i 's/WireGuard 状态/WiGd状态/g' feeds/luci/applications/luci-app-wireguard/po/zh-cn/wireguard.po
sed -i 's/Turbo ACC 网络加速/网络加速/g' feeds/luci/applications/luci-app-turboacc/po/zh-cn/turboacc.po


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
cat >"$CLEAR_PATH" <<-EOF
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF
