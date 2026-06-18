---
title: Claude Code 踩坑一个月，这些经验你一定要知道
categories: AI探索
tags: [Claude Code,AI编程,经验分享,踩坑记录]
date: 2026-06-18 16:00:00
id: 0117
---

前七篇我们聊了 Claude Code 的安装配置、快捷键、命令、CLAUDE.md 配置、Skills、MCP 和 Subagents。这篇来说说实战经验和踩坑经历。

说实话，用了一个月，踩了不少坑。有些是文档里没写的，有些是自己摸索出来的。希望我的经验能帮你少走弯路。

## 踩坑一：上下文管理是核心技能

这是我踩得最深的坑。

刚开始用的时候，我只顾着让 Claude 干活，完全没注意上下文用量。结果聊了 20 分钟，它就开始"变笨"——忘记之前的讨论，重复提问，给出不相关的回答。

**症状识别**：

当 Claude 开始：
- 忘记之前讨论的内容
- 重复问同样的问题
- 给出不相关的回答
- 建议你已经做过的事情

这些通常是因为上下文快满了。

**我的解决方案**：

1. **定期检查**：每隔 30 分钟用 `/context` 看一下用量
2. **及时压缩**：超过 50% 就执行 `/compact`
3. **任务切换**：开始新任务时用 `/clear` 彻底重开
4. **隔离任务**：大量代码阅读任务用 Subagent

**一个真实案例**：

有一次我在分析一个复杂的代码库，让 Claude 读了 50 多个文件。聊了 20 分钟后，它开始忘记之前分析的内容，甚至重复问同样的问题。

我用 `/context` 一看，上下文已经用了 85%。执行 `/compact` 后，它又恢复正常了。

**我的习惯**：

```bash
# 每天开始工作前
claude -c  # 继续昨天的会话

# 每隔 30 分钟
/context   # 检查用量
/compact   # 如果超过 50%

# 切换任务时
/clear     # 彻底重开
```

## 踩坑二：CLAUDE.md 太长会被忽略

刚开始，我把所有规范都写进了 CLAUDE.md，写了 300 多行。结果发现 Claude 经常不遵守里面的规则。

**原因**：CLAUDE.md 太长，规则被淹没了，Claude 会忽略部分内容。

**解决方案**：

1. **精简到 200 行以内**
2. **重要规则放顶部**
3. **用强调词**："MUST"、"IMPORTANT"、"NEVER"
4. **分层管理**：全局规范放 `~/.claude/CLAUDE.md`，项目规范放项目级

**我的 CLAUDE.md 结构**：

```markdown
# 最重要的规则（必须遵守）

## 语言偏好
- 代码注释使用英文
- 交互对话使用中文

## 代码风格
- 使用 2 空格缩进
- 使用单引号

# 项目特定规则

## 构建命令
- `npm run dev` - 启动开发服务器
- `npm test` - 运行测试

## Git 规范
- Commit message 使用 conventional commits 格式
- 提交前必须运行测试
```

**一个技巧**：把 CLAUDE.md 加入 Git，让团队共同维护。这样大家用同一套规范，Claude 的表现更一致。

## 踩坑三：权限模式选错了

刚开始，我一直用 Normal 模式，每次修改文件都要确认。做一个重构任务，要确认 20 多次，效率很低。

后来我学会了根据任务选择权限模式：

**我的选择策略**：

| 任务类型 | 权限模式 | 原因 |
|----------|----------|------|
| 探索新项目 | Plan Mode | 只看不动，安全 |
| 日常开发 | Normal | 平衡安全和效率 |
| 重构代码 | Auto-Accept Edits | 批量修改，效率高 |
| CI/CD | Bypass Permissions | 自动化，但要限制工具 |

**一个真实场景**：

上周我要重构一个认证模块，涉及 15 个文件。一开始用 Normal 模式，每改一个文件都要确认，改了 5 个我就烦了。

切到 Auto-Accept Edits 模式后，10 分钟就改完了。然后我用 `git diff` 看了一遍，确认没问题再提交。

**建议**：新手先用 Normal 模式，熟悉了再尝试其他模式。Auto-Accept Edits 虽然爽，但改错了你可能都不知道。

## 踩坑四：非交互模式没设 max-turns

有一次，我用非交互模式跑一个任务，忘了设 `--max-turns`。结果它跑了 30 多分钟还没停，我一看，它在无限循环。

**解决方案**：

1. **务必指定 `--max-turns`**
2. **简单任务用 5**
3. **复杂任务用 10-15**
4. **加系统级超时**：`timeout 30m claude -p "..."`

**我的常用配置**：

```bash
# 简单任务
claude -p "分析这个文件" --max-turns 5

# 中等任务
claude -p "重构这个模块" --max-turns 10

# 复杂任务
claude -p "实现用户认证" --max-turns 15

# 加系统级超时
timeout 30m claude -p "分析代码库" --max-turns 10
```

## 踩坑五：MCP 消耗太多上下文

有一次，我添加了 5 个 MCP 服务器，结果还没开始对话，上下文就消耗了 40%。

**原因**：每个 MCP 服务器都会在每次请求中添加工具定义，消耗大量上下文。

**解决方案**：

1. **只添加真正需要的 MCP**
2. **用 `/mcp` 检查上下文开销**
3. **不用的 MCP 及时关闭**
4. **使用工具搜索**：默认启用，延迟工具定义直到 Claude 需要它们

**我的建议**：先从 1-2 个 MCP 开始，比如 GitHub。等熟悉了再添加更多。

## 踩坑六：Prompt 引号问题

刚开始用非交互模式，我经常犯这个错误：

```bash
# 错误——shell 会拆分
claude -p Analyze this file

# 正确——用引号包裹
claude -p 'Analyze this file and generate a report'
```

**原因**：shell 会把空格分隔的词当作多个参数。

**解决方案**：始终用引号包裹 prompt。

## 踩坑七：费用控制

刚开始用 API Key 模式，一个月花了 $50。后来我学会了控制费用。

**我的费用控制策略**：

1. **日常用 Sonnet**：处理 90% 的任务，便宜
2. **深度推理用 Opus**：只在需要时用，贵
3. **设置用量限制**：用 `/usage` 设置每周限制
4. **非交互模式用 `--max-turns`**：控制 token 消耗

**我的实际费用**：

- Claude Pro 订阅：$20/月
- 日常使用：每天 10-20 次对话
- 偶尔用 Opus：每周 2-3 次
- 月均费用：$20-25

**建议**：先从 $20 档开始用一个月，看看自己的实际使用量。如果经常碰到限额，再升级也不迟。

## 踩坑八：Git 集成不装 gh CLI

刚开始，我让 Claude 创建 PR，它说需要 gh CLI。我一查，没装。

**解决方案**：

```bash
# macOS
brew install gh

# Linux
sudo apt install gh

# Windows
winget install GitHub.cli

# 登录
gh auth login
```

**安装后 Claude 可以**：
- 创建 Issue
- 开 PR
- 读评论
- 查看 PR 状态

**我的建议**：装了 gh CLI 后，Claude 的 Git 集成能力大幅提升。强烈推荐安装。

## 踩坑九：Skills 没有设置 disable-model-invocation

我创建了一个部署 Skill，结果 Claude 在我代码写到一半时就自动触发了部署。

**原因**：默认情况下，Claude 可以自动调用任何 Skill。

**解决方案**：

对于有副作用的 Skill，设置 `disable-model-invocation: true`：

```yaml
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

**我的建议**：
- 部署、发布等有副作用的 Skill：设置 `disable-model-invocation: true`
- 代码审查、测试生成等无副作用的 Skill：保持默认

## 踩坑十：Subagent 上下文满了

我让一个 Subagent 分析一个大型代码库，结果它也开始"变笨"。

**原因**：Subagent 也有上下文限制。

**解决方案**：

1. **使用 `/compact` 压缩 Subagent 上下文**
2. **减少 Subagent 的工具权限**
3. **使用更小的上下文窗口**
4. **限制 Subagent 的执行轮次**（`maxTurns`）

**我的建议**：Subagent 不是万能的，也要注意上下文管理。

## 踩坑十一：MCP 服务器断开连接

有一次，我的 GitHub MCP 服务器断开了，我让 Claude 创建 PR，它说找不到工具。

**原因**：MCP 服务器可能因为网络问题或超时而断开。

**解决方案**：

1. **使用 `/mcp` 检查服务器状态**
2. **使用 `/mcp reconnect <server>` 重新连接**
3. **Claude Code 会自动重新连接**（最多五次尝试）

**我的建议**：定期检查 MCP 状态，特别是长时间运行的会话。

## 踩坑十二：Vim 模式下的快捷键冲突

我启用了 Vim 模式，结果发现一些 Claude Code 的快捷键被 Vim 占用了。

**原因**：Vim 模式会接管一些按键，如 `Esc`、`i`、`a` 等。

**解决方案**：

1. **了解 Vim 模式下的特殊按键**
2. **使用 `/config` 切换编辑器模式**
3. **在 Vim NORMAL 模式下使用 Claude Code 快捷键**

**我的建议**：如果你不熟悉 Vim，建议保持默认的编辑器模式。

## 踩坑十三：忽略了 /btw 命令

我经常在 Claude 工作时想问一个快速问题，但又不想打断它。以前我只能等它完成。

**原因**：不知道有 `/btw` 命令。

**解决方案**：

使用 `/btw` 命令提出快速附加问题：

```text
/btw what was the name of that config file again?
```

**特点**：
- 即使 Claude 正在处理响应时，您也可以运行 `/btw`
- 侧面问题仅从已在上下文中的内容回答
- 不会添加到对话历史

**我的建议**：`/btw` 是一个被低估的命令，非常实用。

## 踩坑十四：忽略了会话回顾功能

我经常离开终端去做其他事情，回来后不知道 Claude 做了什么。

**原因**：不知道有会话回顾功能。

**解决方案**：

Claude Code 会自动显示会话回顾：

- 当您从离开后返回终端时，Claude Code 会显示到目前为止会话中发生的情况的单行回顾
- 运行 `/recap` 以按需生成摘要

**我的建议**：离开终端后回来看看回顾，快速了解 Claude 做了什么。

## 踩坑十五：忽略了 PR 审查状态

我经常在 Claude Code 中处理 PR，但不知道它会显示 PR 的审查状态。

**原因**：不知道有 PR 审查状态功能。

**解决方案**：

Claude Code 在页脚中显示可点击的 PR 链接（例如"PR #446"），带有彩色下划线：

- 绿色：已批准
- 黄色：待审查
- 红色：请求更改
- 灰色：草稿

**我的建议**：`Cmd+click`（Mac）或 `Ctrl+click`（Windows/Linux）点击链接以在浏览器中打开拉取请求。

## 调试技巧

### 技巧1：Plan Mode 先分析

在动手修改之前，先用 Plan Mode 让 Claude 分析：

```text
Shift+Tab  # 切换到 Plan Mode
分析这个模块的架构
```

这样 Claude 会给你一个完整的分析，不会动手修改。

### 技巧2：Subagent 隔离

大量代码阅读任务用 Subagent 隔离：

```text
用 Explore 子代理分析 src/ 目录的架构
```

这样主对话的上下文不会被撑满。

### 技巧3：/rewind 回退

改错了文件，用 `/rewind` 回退：

```text
/rewind
```

会显示可回退的节点列表。

### 技巧4：git diff 验证

修改完成后，用 `git diff` 验证：

```bash
git diff
```

确保修改符合预期。

### 技巧5：/doctor 诊断

Claude Code 运行异常时，用 `/doctor` 诊断：

```text
/doctor
```

会显示状态图标，按 `f` 让 Claude 修复任何报告的问题。

### 技巧6：/debug 调试

Claude Code 行为异常时，用 `/debug` 调试：

```text
/debug Claude is not responding to my commands
```

会启用调试日志记录并通过读取会话调试日志来排查问题。

## 我的使用习惯总结

经过一个月的使用，我形成了自己的使用习惯：

**1. 上下文管理**

- 每 30 分钟：`/context` 查看用量
- 超过 50%：`/compact` 压缩
- 超过 80%：`/clear` 清空
- 切换任务：`/clear` 开新会话

**2. 权限模式**

- 日常开发：Normal 模式
- 重构代码：Auto-Accept Edits 模式
- 探索项目：Plan Mode

**3. 模型选择**

- 日常开发：DeepSeek（性价比高）
- 复杂任务：Claude Opus（推理能力强）
- 快速查询：Claude Haiku（速度快）

**4. MCP 管理**

- 只添加必要的 MCP 服务器
- 定期检查 MCP 状态
- 上下文消耗过大时关闭不必要的 MCP

**5. Subagent 使用**

- 大量代码阅读：用 Explore 子代理
- 方案规划：用 Plan 子代理
- 代码验证：用 Verify 子代理

**6. 费用控制**

- 日常用 Sonnet
- 深度推理用 Opus
- 非交互模式用 `--max-turns`

## 最后的建议

1. **从小项目开始**：别一上来就用在你的核心项目上，找个测试项目练练手
2. **一定要跑 `/init`**：这一步能让 Claude 理解你的项目，省去很多麻烦
3. **学会用 `/compact`**：上下文管理是核心技能，别让 Claude "变笨"
4. **多用 Plan Mode**：按 `Shift+Tab` 切换到 Plan Mode，让它先分析再动手
5. **装 gh CLI**：Git 集成能力大幅提升
6. **只添加必要的 MCP**：避免上下文消耗过大
7. **有副作用的 Skill 设置 `disable-model-invocation: true`**：避免自动触发
8. **定期检查 `/context` 和 `/mcp`**：保持上下文健康

## 下一篇预告

这篇是踩坑经验篇，也是这个系列的最后一篇。希望我的经验能帮你少走弯路。

---

**相关推荐：**
- [Claude Code 入门：从安装到模型配置，以 DeepSeek 为例](/archives/0110/)
- [Claude Code 快捷键：这 15 个键让我效率翻倍](/archives/0111/)
- [Claude Code 命令大全：这 20 个命令你必须掌握](/archives/0112/)
- [Claude Code 配置：CLAUDE.md 与上下文管理的艺术](/archives/0113/)
- [Claude Code Skills：让 AI 记住你的工作流程](/archives/0114/)
- [Claude Code MCP：连接外部世界的桥梁](/archives/0115/)
- [Claude Code Subagents：让 AI 分身帮你干活](/archives/0116/)

**P.S.** 踩坑不可怕，可怕的是踩了坑还不知道为什么。希望我的经验能帮你少走弯路，快速上手 Claude Code。如果你也有踩坑经验，欢迎在评论区分享！
