# 自用固件 - OpenWrt 增强安全版

> 基于 OpenWrt 25.12 x86_64 的自定义构建配置，集成安全加固、现代网络工具和隐私保护功能

![OpenWrt Version](https://img.shields.io/badge/OpenWrt-25.12-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Language](https://img.shields.io/badge/language-Shell-orange)

---

## 🎯 功能特性

### 🔐 安全强化
- **内核安全防护**
  - 栈保护 (Stack Canary with STACKPROTECTOR_STRONG)
  - SLAB 内存保护 (Freelist randomization & hardening)
  - 页表隔离 (PTI - Page Table Isolation)
  - YAMA ptrace 限制 (进程追踪限制)

- **网络安全**
  - 现代防火墙 (firewall4 + nftables)
  - DNSSEC 完整支持
  - OpenSSL TLS 1.3 最新加密
  - 禁用弱密码算法

- **访问控制**
  - SSH 服务器默认禁用
  - 远程管理受限
  - Fail2ban 暴力破解防护

### 🛡️ 隐私保护
- OpenVPN 完整支持
- WireGuard VPN 集成
- UPnP 默认禁用 (减少自动端口映射风险)
- DNS 隐私保护
- Cloudflare Zero Trust 支持

### 🌐 网络增强
- OpenClash (策略路由、DNS 分流)
- Passwall (V2Ray、Xray、Shadowsocks 等)
- TCP BBR 拥塞控制
- SQM 流量整形 (CAKE 算法)

### 📊 管理与监控
- LuCI Web 管理界面 (Argon 主题)
- Netdata 系统监控
- 流量监控 (nlbwmon)
- 在线保留配置升级 (attendedsysupgrade)
- IP 封禁/黑名单管理 (banip)
- ACME 自动证书管理
- DDNS 动态域名

### 🌍 国际化
- 完整中文语言包
- IPv6 全栈支持
- 中国时区支持

---

## 📦 包含的核心组件

| 组件 | 版本 | 功能 |
|------|------|------|
| OpenWrt | 25.12 | 路由系统 |
| firewall4 | - | 现代防火墙 (nftables) |
| dnsmasq-full | - | DHCP/DNS + DNSSEC |
| OpenVPN | - | VPN 隧道 |
| WireGuard | - | 新一代 VPN |
| OpenClash | - | 代理和分流 |
| Passwall | - | VPN 和代理工具 |
| LuCI | - | Web 管理界面 |

---

## 🚀 快速开始

### 前置要求
- Linux 编译环境 (Ubuntu 20.04+ / Debian 11+)
- 最少 4GB RAM，推荐 8GB+
- 最少 30GB 磁盘空间
- 互联网连接

### 编译步骤

#### 1. 克隆 OpenWrt 官方源
```bash
git clone https://github.com/openwrt/openwrt.git openwrt-25.12
cd openwrt-25.12
git checkout v25.12
```

#### 2. 应用本配置
```bash
# 复制配置文件
cp /path/to/.config .config

# 或者复制 DIY 脚本
cp /path/to/diy-part1.sh .
cp /path/to/diy-part2.sh .
```

#### 3. 执行 DIY 脚本（可选）
```bash
bash diy-part1.sh  # 配置 feeds（执行前请检查脚本内容）
./scripts/feeds update -a
./scripts/feeds install -a
bash diy-part2.sh  # 配置参数
```

#### 4. 开始编译
```bash
# 安装依赖
./scripts/feeds install -a

# 配置
make menuconfig  # 或直接使用现有 .config

# 编译（可选：并行编译加速）
make download V=s
make -j$(nproc) V=s

# 或者两步编译（推荐）
make -j1 V=s  # 第一次编译确保正确
make -j$(nproc) V=s  # 后续编译可并行
```

#### 5. 获取镜像
编译完成后，镜像位于 `bin/targets/x86/64/` 目录：
- `openwrt-*-x86-64-generic-ext4-combined.img.gz` - EXT4 分区镜像
- `openwrt-*-x86-64-generic-squashfs-combined.img.gz` - SquashFS 只读镜像
- `openwrt-*-x86-64-vmdk-combined.tar.gz` - VMDK 虚拟机镜像

### 常见编译问题

**问题：编译出错，提示依赖缺失**
```bash
# Ubuntu/Debian 安装依赖
sudo apt-get install build-essential libncurses5-dev libncursesw5-dev zlib1g-dev gawk git gettext libssl-dev xsltproc rsync wget unzip python3 python3-dev python3-distutils
```

**问题：编译缓慢**
```bash
# 使用国内镜像源（可选）
sed -i 's/github.com/ghproxy.com\/https:\/\/github.com/g' feeds.conf.default

# 编译时使用更多并行任务
make -j8 V=s  # 根据 CPU 核心数调整
```

---

## 🔧 配置说明

### 配置文件详解

#### `.config` 配置文件
主要包含以下部分：

1. **目标平台** - x86_64 (通用虚拟机 + 物理机)
2. **镜像格式** - VMDK, EXT4, SquashFS
3. **引导程序** - GRUB2 (支持 EFI 和 Legacy BIOS)
4. **包管理** - apk-openssl (OpenWrt 25.12 默认)
5. **网络驱动** - 虚拟化 + 主流物理网卡
6. **防火墙** - firewall4 + nftables
7. **VPN** - OpenVPN + WireGuard
8. **代理工具** - OpenClash + Passwall
9. **内核加固** - 详见 SECURITY.md

### DIY 脚本

#### `diy-part1.sh` - Feed 配置
在更新 feeds 前执行，添加第三方 package feeds：
- flrz - 自定义包源
- openclash - OpenClash 支持

#### `diy-part2.sh` - 参数调整
在更新 feeds 后执行，修改系统参数：
- 默认 IP 地址：192.168.1.1 → 192.168.6.9

---

## 📝 首次使用

### 1. 初始登录
- **Web 管理界面**: http://192.168.6.9 (默认 IP)
- **默认用户**: root
- **默认密码**: 空 (建议立即修改)

### 2. 安全配置
```bash
# SSH 连接（如果启用）
ssh root@192.168.6.9

# 修改 root 密码
passwd

# 配置防火墙规则
# 进入 LuCI → Network → Firewall
```

### 3. 网络配置
- **WAN 接口**: 自动配置或手动设置 DHCP/静态 IP
- **LAN 接口**: 默认 192.168.6.0/24
- **DHCP 服务**: 自动分配 192.168.6.100-200

### 4. VPN 配置
- **OpenVPN**: LuCI → VPN → OpenVPN
- **WireGuard**: LuCI → VPN → WireGuard

### 5. 代理配置
- **OpenClash**: LuCI → Services → OpenClash
- **Passwall**: LuCI → Services → Passwall

---

## 🔄 系统维护

### 定期更新
```bash
# 更新包列表
opkg update

# 升级所有包
opkg upgrade

# 或在 LuCI 中操作
# System → Software → Available Packages → Update lists
```

### 系统备份与恢复
```bash
# 生成备份（在 LuCI 中）
# System → Backup / Flash Firmware → Backup

# 恢复备份
# System → Backup / Flash Firmware → Restore
```

### 日志查看
```bash
# 系统日志
logread

# 防火墙日志
logread | grep fw

# 实时日志
logread -f
```

---

## 🐛 故障排除

### Web 界面无法访问
```bash
# 检查 uhttpd 服务
/etc/init.d/uhttpd status

# 重启 uhttpd
/etc/init.d/uhttpd restart

# 检查防火墙规则
ufw status
```

### 网络无法连接
```bash
# 检查 WAN 接口
ip link show

# 检查 DHCP 状态
udhcpc -i eth0 -v

# 查看路由表
ip route show

# 测试 DNS
nslookup google.com
```

### VPN 连接失败
```bash
# 检查 OpenVPN 日志
logread | grep openvpn

# 检查 WireGuard 状态
wg show

# 测试连接
ping 8.8.8.8
```

---

## 📚 文档与参考

- [OpenWrt 官方文档](https://openwrt.org/docs/guide-user/start)
- [OpenWrt 编译指南](https://openwrt.org/docs/guide-developer/build-system/start)
- [LuCI 使用手册](https://openwrt.org/docs/guide-user/luci/start)
- [防火墙配置](https://openwrt.org/docs/guide-user/firewall/firewall_configuration)
- [OpenClash 文档](https://github.com/vernesong/OpenClash)

---

## 🔐 安全建议

### ⚠️ 重要提示
- **立即修改默认密码** - 首次登录后必须修改 root 密码
- **定期更新系统** - 及时应用安全补丁
- **谨慎配置防火墙** - 不正确的规则可能导致网络故障
- **备份重要配置** - 定期导出系统配置
- **监控系统日志** - 关注异常活动

### 安全检查清单
- [ ] 修改默认密码
- [ ] 配置防火墙规则
- [ ] 启用 HTTPS（若需要远程管理）
- [ ] 更新系统和包
- [ ] 配置备份定时任务
- [ ] 启用日志记录和监控

详见 [SECURITY.md](SECURITY.md)

---

## 🤝 贡献指南

欢迎提出 Issue 或 Pull Request！

### 报告问题
- 提供详细的问题描述
- 包含相关日志信息
- 说明您的硬件环境和编译版本

### 提交改进
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/your-feature`)
3. 提交更改 (`git commit -am 'Add some feature'`)
4. 推送到分支 (`git push origin feature/your-feature`)
5. 创建 Pull Request

### 报告安全漏洞
**请勿在 Issue 中公开报告安全漏洞**，详见 [SECURITY.md](SECURITY.md)

---

## 📄 许可证

本项目配置基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 并遵循 MIT License。

详见 [LICENSE](LICENSE) 文件。

---

## 致谢

感谢以下项目和开发者的贡献：
- [OpenWrt 项目](https://openwrt.org)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [vernesong/OpenClash](https://github.com/vernesong/OpenClash)
- 所有参与的开源社区

---

**最后更新**: 2026-06-25

**⭐ 如果对您有帮助，请给个 Star！**
