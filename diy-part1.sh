#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
# 建立 OpenClash 內核存放目錄
mkdir -p package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/

# 設定內核下載地址 (以 x86_64 為例，如果是 ARM 請修改對應名稱)
# 這裡使用 curl 直接抓取最新 release 的下載連接（簡單做法是指定版本號）
CORE_VER="v1.18.0" # 建議手動指定一個穩定版本，或使用 API 獲取最新 tag
DOWNLOAD_URL="https://github.com{CORE_VER}/mihomo-linux-amd64-${CORE_VER}.gz"

# 下載並解壓內核
curl -fL -o /tmp/clash_meta.gz "$DOWNLOAD_URL"
gzip -d /tmp/clash_meta.gz

# 移動並更名，同時賦予執行權限
mv /tmp/clash_meta package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/clash_meta
chmod +x package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/clash_meta
          
# Add a feed source
sed -i '1i src-git flrz https://github.com/flrz/openwrt-packages' feeds.conf.default
#sed -i '2i src-git openclash https://github.com/vernesong/OpenClash' feeds.conf.default
#sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
#sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
#sed -i '3i src-git golang https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang' feeds.conf.default
#sed -i '3i src-git openwrt-passwall-packages https://github.com/flrz/openwrt-passwall-packages' feeds.conf.default
