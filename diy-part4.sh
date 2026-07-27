#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part4.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
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

# 配置目标文件路径
CONFIG_FILE="package/base-files/files/bin/config_generate"

# 检查配置文件是否存在
if [[ ! -f "${CONFIG_FILE}" ]]; then
    error_exit "Config file not found: ${CONFIG_FILE}"
fi

# 备份原始文件
if ! cp "${CONFIG_FILE}" "${CONFIG_FILE}.backup"; then
    error_exit "Failed to backup ${CONFIG_FILE}"
fi

# 修改默认 IP 地址，从 192.168.1.1 改为 192.168.6.9
# 使用引号保护变量，防止路径中出现特殊字符
if sed -i 's/192\.168\.1\.1/192.168.6.9/g' "${CONFIG_FILE}"; then
    success_msg "Modified default IP address: 192.168.1.1 → 192.168.6.9"
else
    error_exit "Failed to modify default IP address"
fi

# 验证修改是否成功（可选检查）
if grep -q "192.168.6.9" "${CONFIG_FILE}"; then
    success_msg "Verified: New IP address is present in config"
else
    error_exit "Verification failed: New IP address not found in config"
fi

# 检查是否还有旧 IP（警告）
if grep -q "192.168.1.1" "${CONFIG_FILE}"; then
    echo "⚠️  Warning: Old IP address 192.168.1.1 still found in config"
fi

success_msg "diy-part2.sh completed successfully"
