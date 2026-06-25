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

# 备份原始文件（用于调试和恢复）
if ! cp feeds.conf.default feeds.conf.default.backup; then
    error_exit "Failed to backup feeds.conf.default"
fi

# 添加 flrz feed
if sed -i '1i src-git flrz https://github.com/flrz/openwrt-packages' feeds.conf.default; then
    success_msg "Added flrz feed source"
else
    error_exit "Failed to add flrz feed source"
fi

# 添加 OpenClash feed
if sed -i '2i src-git openclash https://github.com/vernesong/OpenClash' feeds.conf.default; then
    success_msg "Added OpenClash feed source"
else
    error_exit "Failed to add OpenClash feed source"
fi

# 其他可选 feed（已注释）
# if sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default; then
#     success_msg "Added kenzo feed source"
# else
#     error_exit "Failed to add kenzo feed source"
# fi
#
# if sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default; then
#     success_msg "Added small feed source"
# else
#     error_exit "Failed to add small feed source"
# fi

success_msg "diy-part1.sh completed successfully"
