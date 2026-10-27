---
title: QQ 接入 DeepSeek Harness：全程提示词教程
categories: AI探索
tags: [DeepSeek,QQ机器人,Agent,MCP,提示词,教程]
date: 2026-10-27 09:00:00
id: 0212
---

最近「把 AI Agent 接进 QQ 群」这件事突然火了起来——让模型像一个真实的群友一样读消息、接话、甚至主动发言，体验相当奇妙。我自己完整走了一遍：QQ 客户端通过 SnowLuma 注入并翻译成 OneBot v11 协议，再由 qq-bridge 接入 DeepSeek Harness（下文简称 DSH），全程只用提示词驱动 agent 干活。

这篇把整个过程整理成可复现的教程。全文只有一种做法：**你在 DSH 里把提示词发给 agent，agent 执行**。你真正要动手的只有 4 件事：登录 DSH、扫 QQ 码、在 SnowLuma 点"同意 + 改密"、决定白名单。

**实测环境**：Windows 11 · DSH 0.2.1-rc.3 · QQ NT 9.9.36 · SnowLuma v2.2.0 · qq-bridge 0.2.1-r1（文中所有 QQ 号、群号均为占位符，请替换成你自己的）

## 先理解要装成什么样

```
QQ 客户端 (QQ NT)  ← SnowLuma 注入，翻译成 OneBot v11
    ├─ HTTP  127.0.0.1:3000   （发消息、查好友群）
    └─ WS    127.0.0.1:3001   （收消息事件）
         ├─ qq-bridge（独立进程，控制台 3100）↔ DSH 会话
         └─ DSH 内 3 个 MCP（snowluma / snowluma-host / web-search-safe）
```

四个组件、三个进程，**启动顺序固定**：`QQ → SnowLuma → qq-bridge`。

## 第 1 步：安装 DSH 并登录（人工）

这一步没有提示词，是纯人工的准备工作：

1. 从官方渠道安装 **DeepSeek Harness 桌面版**。
2. 首次启动后用你的 DeepSeek 账号登录，完成引导。
3. 随便发一句话确认能正常对话（说明账号与模型都通了）。
4. **记下窗口标题/地址栏里的端口**（形如 `http://127.0.0.1:49822`）——第 4 步要用；这个端口每次启动可能变。

装完先让 agent 自检一遍，顺便把它的"体检报告"留作基线：

```
请检查当前 DSH 的版本、Web 端口、可用的 provider 与模型（含各模型的 reasoning 档位），列成表。
```

期望输出类似：

```
版本       0.2.1-rc.3
Web 端口   49822
provider   deepseek-account（唯一可路由）
模型       deepseek-flash / deepseek-v4-pro
档位       off / low / high / max
```

> 如果 agent 说拿到多个 provider，以后写桥接配置时**只能填"可路由"的那个**，填错不会报错，只会静默降级。

## 第 2 步：装 QQ NT

**提示词**

```
帮我装 NT 版 QQ（Windows x64），绑定账号 <机器人QQ号>。

要求：
1. 只用官方渠道的安装包；安装前先验 Authenticode 签名，签名主体必须是
   Tencent Technology (Shenzhen) Company Limited，否则停下来告诉我；
2. 如果官方直链返回 403，先判断是不是出口 IP 的地域限制（同域名下旧版包能 200
   就说明是地域问题），不要从第三方下载站取安装包；
3. 装完启动 QQ，把登录窗口留给我扫码。
```

**agent 会做**：取官方最新版号 → 下载 → 验签 → 静默安装 → 启动。
**你必须做**：用手机 QQ 扫码登录机器人账号。
**判定标准**：`%USERPROFILE%\Documents\Tencent Files\<机器人QQ号>` 目录出现，且 `Get-Process QQ` 有进程。

> 这是第一个"人工闸口"：agent 说"已登录"而你没扫码，就是它在猜。

## 第 3 步：装 SnowLuma

**提示词**

```
装 SnowLuma（Windows x64 完整版），装到 C:\SnowLuma。

要求：
1. 用官方 GitHub release，解压后确认 launcher.bat、index.mjs、node.exe、native 目录都在；
2. 启动时把 stdout 重定向到文件再启动 —— 初始密码只打印在标准输出、不写进日志；
3. 把 WebUI 的初始登录凭据告诉我；
4. 验证日志里出现 [Hook] login detected 且 UIN 是我要的号，并确认 OneBot HTTP 3000
   和 WS 3001 都在监听。
```

**agent 会做**：下载 → 解压 → 重定向启动 → 从日志/标准输出抓初始密码 → 验证注入与端口。
**你必须做**：打开 <http://localhost:5099>，用 `admin` + 它给的密码登录，**同意 EULA/隐私政策并改密**。
**判定标准**：

```
[Hook] login detected: PID=xxxx UIN=<机器人QQ号>
[OneBot.HTTP] [http-default] listening 127.0.0.1:3000/
[OneBot.WS-Server] [ws-default] listening 127.0.0.1:3001/
```

> 第二个"人工闸口"：法律同意必须你本人点，不要接受"帮你点了同意"。
> 密码丢了不用慌：删 `C:\SnowLuma\config\webui.json` 重启会重新生成并打印一次。

## 第 4 步：装 qq-bridge 并接入 DSH

**提示词**

```
装 qq-bridge（github.com/Derpyu520/qq-bridge）到当前工作区，并把它接入 DSH 的
desktop profile。

要求：
1. npm install；如果报 npm-cache EPERM，就把 cache 放到工作区再装
   （npm install --cache <工作区>\_npm-cache）；
2. 从 config.example.json 生成 config.json：
   - dsh.baseUrl 用当前 DSH 的实际端口（不是默认 3080）
   - dsh.provider/model 用 session.modelCatalog 里真实可路由的
   - snowluma 段取 SnowLuma 的 config/onebot_<机器人QQ号>.json 里的端口和 HTTP token
     （HTTP 与 WS 的 token 不是一个值），homeDir 指向 C:\SnowLuma
3. 跑 node scripts/setup-dsh.mjs desktop，然后验证：preset qq-chat / qq-chat-v2、
   3 个 MCP（snowluma / snowluma-host / web-search-safe）、2 个插件
   （qq-mode-console / qq-agent-presets）都已加载；
4. 启动桥接（start.bat，守护模式），确认 /api/status 里 snowluma.connected 和
   dshReady 都是 true，并把机器人昵称报给我。
```

**agent 会做**：拉仓库 → 装依赖（含 postinstall 修补 `@snowluma/sdk` 的 ESM bug）→ 生成配置 → 注册 bundle/preset/MCP → 起桥接 → 验证。
**你必须做**：无（等它报结果）。
**判定标准**：

```json
{"mode":"reserved2","dshReady":true,
 "snowluma":{"connected":true,"good":true,"goodSource":"heartbeat"}}
```

日志里应连续出现 `SnowLuma 已连接` → `机器人昵称：xxx` → `DSH 已就绪`。

> 首次启动看到一次 `连接断开（code=1006）` 是**正常**的：桥接会自愈 WS token 再连一次。
> 真正有问题的是反复出现 `token 自愈失败`——那通常是 QQ 没登录或 SnowLuma 没起来。

## 第 5 步：配白名单与管理员

**提示词**

```
管理员 QQ 是 <你的QQ号>（ownerQQ，不是机器人号）。
只把群 <群号> 加进白名单，私聊只放行管理员本人；其余群一律不加。
配完把 /api/whitelist 的实际返回贴给我，并说明这几个字段的判定优先级：
allow / deny / allowAllWhenEmpty。
```

**agent 会做**：写 `ownerQQ`、`allow.private`、`allow.groups`，回读验证。
**你必须做**：确认群号和自己的号没写错。
**判定标准**：`allowGroups` 只含目标群，`allowPrivate` 只含你自己，`allowAllWhenEmpty` 保持 `false`。

> 第三个"人工闸口"：白名单填错，轻则群友没人理，重则把账号交给陌生人。

## 第 6 步：配"不用 @ 也主动判断回复"

**提示词**

```
这个群不要 @ 才回：把 group:<群号> 的唤醒配置切成 active（anyMessage、无限期），
并把唤醒频率上限放开到能自然接话的量级。

说明：改了哪几项、各自的改前改后值、以及代价（每条消息都会触发一次模型回合）。
```

**agent 会做**：改该群会话的 `wakeConfig`（`mode=active` → `anyMessage=true`）→ 调整 `maxWakePerMinute` / `maxWakePerHour` → 落盘并复验。
**你必须做**：接受它的成本说明。
**判定标准**：

```
wakeConfig.mode = active
wakeConfig.triggers.anyMessage = true
wakeConfig.infinite = true
wakeConfig.confirmedBy = set_wake_config
maxWakePerMinute = 3, maxWakePerHour = 30
```

行为变成：群里有消息 → 8 秒内的多条合并成一批 → 唤醒会话 → 模型读上下文后决定「接话」或输出 `[SILENT]` 不发言。

> 默认上限是 **1 次/分钟、12 次/小时**，不放开的话「每条都判断」会被压成几乎不接话。

## 第 7 步：验收

**提示词**

```
端到端验证整条链路，逐项给证据，不要只说"已配置"：
QQ 进程 → SnowLuma 注入（UIN）→ OneBot 3000/3001 → 桥接 /api/status
→ MCP qq_status → 白名单 → 唤醒配置。
任一项不通就定位到根因再修。
```

**期望清单**

| 检查点 | 期望 |
|---|---|
| QQ 进程 | 存在，且已登录目标号 |
| SnowLuma 注入 | 日志 `login detected ... UIN=<机器人号>` |
| OneBot | 3000 `get_login_info` 返回 200；3001 在监听 |
| 桥接 | `/api/status` 200，`snowluma.connected=true`、`dshReady=true` |
| MCP | `qq_status` → `{"user_id":<机器人>,"online":true}` |
| 白名单 | 只含目标群 + 管理员私聊 |
| 唤醒 | `active` + `anyMessage` |

最后在群里发一句话，日志应出现 `新会话 group:<群号> -> session-...`，随后有 `[reserved2] 工具统一发送`。

## 日常运维（学会这一次就够）

**开机后的固定顺序**（顺序错 = 表现为"连不上"）：

```
1. 启动 QQ 并登录机器人号
2. C:\SnowLuma\launcher.bat
3. <工作区>\qq-bridge\start.bat
```

**脚本与日志**

| 用途 | 位置 |
|---|---|
| 起桥接（守护，崩溃自动拉起） | `qq-bridge\start.bat` |
| 重启桥接（杀旧实例 + 清锁） | `qq-bridge\restart.bat` |
| 桥接日志 | `qq-bridge\state\bridge.log` |
| SnowLuma 日志 | `C:\SnowLuma\logs\snowluma-<日期>.log` |
| 桥接控制台 | `http://127.0.0.1:3100`（令牌在 `state\console-token`） |

## 常见故障速查

| 现象 | 根因 | 让 agent 做什么 / 你自己做什么 |
|---|---|---|
| 群里完全没反应，日志 `忽略未授权会话 group:xxx` | 群不在白名单 | 让 agent 加群号 |
| 日志 `白名单为空且 allowAllWhenEmpty=false` | fail-closed 默认值 | 填白名单 |
| 桥接 401 + `token 自愈失败`，但手工 curl 能通 | 桥接启动早于 token 写入 | `restart.bat` |
| 桥接反复 1006 断线 | QQ 没登录 / SnowLuma 没起 | 按上面顺序重启 |
| `唤醒频率超限，Ns 后重试` | 撞上限 | 让 agent 调高上限或改概率唤醒 |
| 只在被 @ 时回复 | 唤醒配置还是 `diving` | 让 agent 切 `active` |
| DSH 重启后桥接连不上 DSH | DSH 端口变了 | 改 `dsh.baseUrl` 后重启桥接 |
| `已有实例在运行` | 单实例锁 | 用 `restart.bat` |
| SnowLuma WebUI 密码忘了 | 只打印一次 | 删 `config\webui.json` 重启 |
| `HTTP 426` | 把 3001 填进了 `httpUrl` | 3000 是 HTTP、3001 是 WS |
| 官方直链 403 | 出口 IP 不在大陆 | 换国内网络下载，别用第三方站 |

## 安全与合规（简短版）

1. SnowLuma 是第三方项目，与腾讯无关；其 EULA §5.4 禁止把原生组件并入第三方安装包 / 镜像、自动化脚本部署、及任何商业用途——个人非商业自托管可以，**别重打包分发**。
2. 白名单只放你信任的群；`ownerQQ` 填你自己的号，**不要填机器人号自己**。
3. 机器人账号建议单独注册，别用主号。
4. `state\` 里有控制台令牌和聊天记录；若桥接提示 `未能收紧 state/ 目录权限`，按它打印的 `icacls` 命令用管理员身份补一次。

## 附：参考配置值

文中所有账号信息均为占位符，部署时替换成你自己的实际值即可：

| 项 | 值 |
|---|---|
| DSH | 0.2.1-rc.3，profile `desktop`，Web 端口 `<启动时实际端口>` |
| 机器人 QQ | `<机器人QQ号>`（建议单独注册小号） |
| 管理员 QQ | `<你的QQ号>`（ownerQQ） |
| 白名单 | 群 `<群号>` + 私聊 `<你的QQ号>` |
| 唤醒 | 目标群 `active`，3 次/分钟、30 次/小时，批窗 8s |
| QQ NT | 9.9.36.53644 → `C:\Program Files\Tencent\QQNT` |
| SnowLuma | v2.2.0 → `C:\SnowLuma`，WebUI `http://localhost:5099` |
| OneBot | HTTP 3000 / WS 3001 |
| 桥接 | `<工作区>\qq-bridge`，控制台 3100 |
| DSH 端已装 | preset `qq-chat`/`qq-chat-v2`；MCP `snowluma`/`snowluma-host`/`web-search-safe`；插件 `qq-mode-console`/`qq-agent-presets` |

整条链路跑通后，群里那个"新群友"就能自然接话了。玩得开心，也记得守住最后那条底线：**白名单只放你信任的群，机器人永远别用主号**。

---

**相关推荐：**
- [Claude Code MCP：连接外部世界的桥梁](/archives/115/)
- [Claude Code Subagents：让 AI 分身帮你干活](/archives/116/)
- [Meta 押注的东西，Codex 和 Claude Code 两周内也全上了：Agent 记忆之战开打](/archives/120/)
- [AI 的许可证时代——从封杀到分级许可，模型使用权正在变成政治许可](/archives/118/)
