# 安全政策 (Security Policy)

## 报告安全漏洞

如果您发现与本项目相关的安全漏洞，**请勿在 Issues 中公开报告**。

### 如何报告
请通过 GitHub 的私密安全咨询功能报告：
1. 访问仓库 → Security → Advisories
2. 点击 "Report a vulnerability"
3. 详细描述漏洞信息

或者直接联系维护者（通过私信或邮件）。

## 受支持的版本

| 版本 | 状态 | 支持期限 |
|------|------|--------|
| OpenWrt 25.12 | ✅ 活跃 | 当前主分支 |
| 早期版本 | ❌ 不支持 | 不再更新 |

## 安全特性

本固件配置包含以下安全增强：

- ✅ **内核安全强化**
  - Stack Canary (STACKPROTECTOR_STRONG)
  - SLAB 内存保护
  - 页表隔离 (PTI)
  - YAMA ptrace 限制

- ✅ **网络安全**
  - firewall4 + nftables 现代防火墙
  - DNSSEC 支持
  - OpenSSL TLS 1.3
  - 禁用弱密码算法

- ✅ **访问控制**
  - SSH 服务器默认禁用
  - 远程管理受限
  - Fail2ban 暴力破解防护

- ✅ **隐私保护**
  - UPnP 禁用（减少自动端口映射风险）
  - DNS 隐私支持
  - VPN 集成 (OpenVPN + WireGuard)

## 依赖安全

本项目依赖以下关键组件：
- OpenWrt 官方软件包
- OpenSSL 1.1.x 或更新版本
- 来自 GitHub 的第三方 feeds（见 feeds.conf.default）

**重要提示**：定期更新这些依赖以获得最新的安全补丁。

## 安全最佳实践

使用此固件时请遵循：

1. **定期更新**
   ```bash
   opkg update
   opkg upgrade
   ```

2. **更改默认密码**
   - 首次登录后立即修改 LuCI Web 管理密码

3. **防火墙配置**
   - 定期审查防火墙规则
   - 仅开放必要的端口
   - 启用 IP 防火墙日志记录

4. **VPN 使用**
   - 验证 VPN 证书有效期
   - 定期轮换 VPN 密钥

5. **监控**
   - 启用系统日志记录
   - 使用 Netdata 或其他监控工具观察异常活动

## 已知限制

- OpenWrt 作为网关/路由器，直接暴露在互联网上时需要额外加固
- VPN 性能受硬件限制
- 某些高级安全功能可能增加 CPU 占用

## 联系方式

- 维护者: flrz
- 仓库: https://github.com/flrz/8664

---

*最后更新: 2026-06-25*
