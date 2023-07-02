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

# 更改固件版本信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt 21.02'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=''/g" package/base-files/files/etc/openwrt_release

# 添加删除软件
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
#rm -rf feeds/luci/applications/luci-app-openclash
svn co https://github.com/kiddin9/openwrt-packages/trunk/lua-maxminddb package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr package/luci-app-vssr
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
#git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone -b luci https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
#svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash

# 替换默认主题 luci-theme-argon
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# 默认ip 192.168.1.1
#sed -i 's/192.168.[0-9]\{1,3\}.1/192.168.1.1/g' package/base-files/files/bin/config_generate

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

# 
MTK_HNAT(){
  rm -rf target/linux/mediatek/files-5.4/drivers/net/ethernet/mediatek/mtk_hnat
  svn co https://github.com/padavanonly/immortalwrtARM/branches/mt7981/target/linux/mediatek/files-5.4/drivers/net/ethernet/mediatek/mtk_hnat
  mv mtk_hnat target/linux/mediatek/files-5.4/drivers/net/ethernet/mediatek/mtk_hnat
}

MT_WIFI(){
  rm -rf package/mtk/drivers/mt_wifi
  svn co https://github.com/padavanonly/immortalwrtARM/branches/mt7981/package/mtk/drivers/mt_wifi
  mv mt_wifi package/mtk/drivers/mt_wifi
}

MTK_HNAT
echo '-------------------------------------------------------------------------------------------------'
MT_WIFI
