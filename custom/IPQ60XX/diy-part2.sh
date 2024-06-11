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
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 添加删除软件
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-unblockneteasemusic
merge_package https://github.com/kiddin9/openwrt-packages openwrt-packages/lua-maxminddb
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/luci-app-openclash
merge_package https://github.com/0118Add/helloworld helloworld/shadow-tls
merge_package https://github.com/0118Add/helloworld helloworld/luci-app-ssr-plus
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/sing-box
merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages/tuic-client
git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
#git clone https://github.com/gngpp/luci-app-design-config package/luci-app-design-config

# 修改插件名字
#sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/custom/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
#sed -i 's/Frp 内网穿透/内网穿透/g' feeds/luci/applications/luci-app-frpc/po/zh-cn/frp.po

# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}
