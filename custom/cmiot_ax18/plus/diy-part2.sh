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

# Modify version
#sed -i 's/R22.11.11/V22.11.11/g' package/addition/default-settings/files/99-default-settings

rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-openclash

svn co https://github.com/kiddin9/openwrt-packages/trunk/lua-maxminddb package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core
