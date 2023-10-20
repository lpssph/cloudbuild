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

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/extra/autocore/files/generic/index.htm

# 添加删除软件
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-unblockneteasemusic
svn co https://github.com/kiddin9/openwrt-packages/trunk/lua-maxminddb package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr package/luci-app-vssr
svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
svn co https://github.com/fw876/helloworld/trunk/shadow-tls package/shadow-tls
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/luci-app-bypass
#svn co https://github.com/xiaorouji/openwrt-passwall/branches/packages/tuic-client package/tuic-client
#svn co https://github.com/xiaorouji/openwrt-passwall/branches/packages/sing-box package/sing-box
svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk/sing-box package/sing-box
svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk/tuic-client package/tuic-client
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
git clone https://github.com/0118Add/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
git clone https://github.com/gngpp/luci-app-design-config package/luci-app-design-config
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
#svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash

# 修改插件名字
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
sed -i 's/Frp 内网穿透/内网穿透/g' feeds/luci/applications/luci-app-frpc/po/zh-cn/frp.po
