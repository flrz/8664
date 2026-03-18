#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# 1. 進入 OpenClash 內核目錄 (如果目錄不存在則創建)
mkdir -p package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/

# 2. 獲取 Mihomo (Meta) 最新版本號 (透過 GitHub API)
CORE_VER=$(curl -s https://api.github.com | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# 3. 下載對應架構的內核 (這裡以 x86_64 為例)
# 如果你是編譯 ARM64 (如 R6S/樹莓派)，請將 amd64 改為 arm64
echo "正在下載 Mihomo 內核版本: $CORE_VER"
curl -fL -o /tmp/clash_meta.gz "https://github.com{CORE_VER}/mihomo-linux-amd64-${CORE_VER}.gz"

# 4. 解壓並移動到插件目錄，更名為 OpenClash 識別的 'clash_meta'
gzip -d /tmp/clash_meta.gz
mv /tmp/clash_meta package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/clash_meta

# 5. 賦予執行權限
chmod +x package/feeds/openclash/luci-app-openclash/root/etc/openclash/core/clash_meta

echo "✓ Mihomo (Meta) 內核已集成到編譯路徑"

# Modify default IP
sed -i 's/192.168.1.1/192.168.6.9/g' package/base-files/files/bin/config_generate
