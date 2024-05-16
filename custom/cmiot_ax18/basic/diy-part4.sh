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

echo "开始 DIY2 配置……"
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
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
sed -i 's/os.date()/os.date("%Y-%m-%d") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/extra/autocore/files/generic/index.htm

# 添加删除软件
rm -rf package/net/{xray-core,smartdns,shadowsocks-rust,hysteria,chinadns-ng}
rm -rf package/openwrt-helloworld/{luci-app-homeproxy}
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/applications/luci-app-smartdns
#rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-unblockneteasemusic
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-bypass
git clone https://github.com/0118Add/luci-app-vssr package/luci-app-vssr
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/luci-app-openclash
git clone https://github.com/firkerword/openwrt-helloworld package/openwrt-helloworld
#merge_package https://github.com/0118Add/helloworld helloworld/shadow-tls
#merge_package https://github.com/0118Add/helloworld helloworld/luci-app-ssr-plus
#merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/luci-app-bypass
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/sing-box
#merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/tuic-client
#git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
#git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
git clone -b master https://github.com/0118Add/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
git clone https://github.com/gngpp/luci-app-design-config package/luci-app-design-config
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush

# 修改插件名字
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/openwrt-helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
#sed -i 's/Frp 内网穿透/内网穿透/g' feeds/luci/applications/luci-app-frpc/po/zh-cn/frp.po
