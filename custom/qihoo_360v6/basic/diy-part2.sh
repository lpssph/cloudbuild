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

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='R24.6.6'/g" package/lean/default-settings/files/zzz-default-settings
sed -i 's/os.date()/os.date("%Y-%m-%d") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/extra/autocore/files/generic/index.htm

# 添加删除软件
rm -rf feeds/packages/net/{xray-core,smartdns,sing-box,hysteria,shadowsocks-rust}
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-unblockneteasemusic
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/smartdns
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-smartdns
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-bypass
git clone https://github.com/0118Add/luci-app-vssr package/luci-app-vssr
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/luci-app-openclash
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
merge_package https://github.com/sbwml/openwrt_helloworld openwrt_helloworld/shadowsocks-rust
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
#git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
#git clone https://github.com/sbwml/openwrt_helloworld package/openwrt_helloworld
git clone -b master https://github.com/0118Add/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
git clone https://github.com/gngpp/luci-app-design-config package/luci-app-design-config
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush

# 修改插件名字
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/custom/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
