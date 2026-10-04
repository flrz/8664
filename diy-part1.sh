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

# 严格模式：在出错时立即退出，禁止使用未定义的变量
set -euo pipefail

# 错误处理函数
error_exit() {
    echo "❌ Error: $1" >&2
    exit 1
}

# 成功提示函数
success_msg() {
    echo "✅ $1"
}

# 检查 feeds.conf.default 是否存在
if [[ ! -f feeds.conf.default ]]; then
    error_exit "feeds.conf.default not found in current directory"
fi

# 备份原始文件
if ! cp feeds.conf.default feeds.conf.default.backup; then
    error_exit "Failed to backup feeds.conf.default"
fi

# ==================== 添加额外 feeds ====================

# 1. flrz
echo "src-git flrz https://github.com/flrz/openwrt-packages" >> feeds.conf.default && \
    success_msg "Added flrz feed" || \
    error_exit "Failed to add flrz feed"

# 2. OpenClash
echo "src-git openclash https://github.com/vernesong/OpenClash" >> feeds.conf.default && \
    success_msg "Added OpenClash feed" || \
    error_exit "Failed to add OpenClash feed"

# 3. MosDNS (sbwml 维护的 v5 版本，推荐)
echo "src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;v5" >> feeds.conf.default && \
    success_msg "Added mosdns feed" || \
    error_exit "Failed to add mosdns feed"

# 可选：如果需要官方 passwall 源，取消下面注释
# echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> feeds.conf.default && \
#     success_msg "Added passwall feed"

# ==================== 显示最终配置 ====================
echo ""
echo "=========================================="
echo "Final feeds configuration:"
echo "=========================================="
cat feeds.conf.default
echo "=========================================="
success_msg "DIY Part1 completed successfully"
