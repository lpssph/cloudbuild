#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

echo "开始配置……"
echo "========================="

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

sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/emortal/autocore/files/generic/index.htm

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 更改固件版本信息
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt 18.06'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='R24.6.6'/g" package/lean/default-settings/files/zzz-default-settings

# 添加删除软件
rm -rf feeds/packages/net/{chinadns-ng,hysteria,xray-core,v2ray-core,v2ray-geodata,sing-box,shadowsocks-rust,shadowsocksr-libev}
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
#rm -rf feeds/luci/applications/luci-app-openclash
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-smartdns
#git clone https://github.com/0118Add/luci-app-vssr package/luci-app-vssr
git clone --depth=1 -b luci-smartdns-dev https://github.com/xiaorouji/openwrt-passwall package/passwall
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/sing-box
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/tuic-client
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/chinadns-ng
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/hysteria
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/shadowsocksr-libev
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/v2ray-core
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/v2ray-geodata
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/shadowsocks-rust
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/xray-core
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/shadow-tls
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/luci-app-ssr-plus
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-bypass
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone https://github.com/gngpp/luci-theme-design package/luci-theme-design
git clone https://github.com/gngpp/luci-app-design-config package/luci-app-design-config
#git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
git clone https://github.com/CHN-beta/rkp-ipid package/rkp-ipid
git clone https://github.com/Zxilly/UA2F package/UA2F
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/custom/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

# 去掉ssr+中shadowsocksr-libev的libopenssl-legacy依赖支持
sed -i 's/ +libopenssl-legacy//g' package/custom/shadowsocksr-libev/Makefile

# 替换默认主题 luci-theme-argon
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# 修改时区 UTF-8
sed -i 's/UTC/CST-8/g'  package/base-files/files/bin/config_generate

# 修改主机名 OP
sed -i 's/ImmortalWrt/OpenWrt/g'  package/base-files/files/bin/config_generate

# 时区
sed -i 's/time1.apple.com/time1.cloud.tencent.com/g'  package/base-files/files/bin/config_generate
sed -i 's/time1.google.com/ntp.aliyun.com/g'  package/base-files/files/bin/config_generate
sed -i 's/time.cloudflare.com/cn.ntp.org.cn/g'  package/base-files/files/bin/config_generate
sed -i 's/pool.ntp.org/cn.pool.ntp.org/g'  package/base-files/files/bin/config_generate

# 替换源 
sed -i 's,mirrors.vsean.net/openwrt,mirrors.pku.edu.cn/immortalwrt,g'  package/emortal/default-settings/files/99-default-settings-chinese
