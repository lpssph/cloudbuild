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
curl -fsSL https://raw.githubusercontent.com/0118Add/OpenWrt-CI/main/ipq60xx/index.htm > ./package/extra/autocore/files/generic/index.htm

# 修改插件名字
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' feeds/luci/applications/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/解除网易云音乐播放限制/解锁网易音乐/g' feeds/luci/applications/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua
sed -i 's/Frp 内网穿透/内网穿透/g' feeds/luci/applications/luci-app-frpc/po/zh-cn/frp.po
