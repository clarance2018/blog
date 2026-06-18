---
title: Claude Code 命令大全：这 20 个命令你必须掌握
categories: AI探索
tags: [Claude Code,AI编程,效率工具,Slash命令]
date: 2026-06-18 11:00:00
id: 0112
---

前两篇我们聊了 Claude Code 的安装配置和快捷键。这篇来说说真正让我效率翻倍的命令。

说实话，刚用 Claude Code 的时候，我只把它当成一个"能跑命令的 ChatGPT"。直到我发现了这些命令，才明白为什么有人说它是"程序员的终极武器"。

## 典型工作流程中的命令

大多数命令在会话的特定点很有用，从设置项目到发布更改。

### 首次在存储库中的会话

运行 `/init` 以生成启动器 `CLAUDE.md`，然后运行 `/memory` 以完善它。使用 `/mcp` 和 `/agents` 来设置项目需要的任何服务器或子代理，并使用 `/permissions` 来设置您想要的批准规则。

### 在任务期间

`/plan` 在大型更改前切换到 Plan Mode。`/model` 和 `/effort` 调整您花费的推理量。当对话变长时，`/context` 显示窗口的去向，`/compact` 将其总结下来；使用 `/btw` 进行快速附加说明，不应该增加历史记录。

### 并行运行工作

`/agents` 打开管理器以处理子代理，Claude 可以将侧面任务委派给这些子代理，`/tasks` 列出当前会话后台运行的内容。`/background` 分离整个会话以继续作为后台代理运行，并释放您的终端。对于跨越代码库的大型更改，`/batch` 将其分解为独立单元，并在其自己的 worktrees 中运行每个单元。

### 在您发布之前

`/diff` 显示更改的内容，`/code-review` 检查差异以查找正确性错误和清理，并可以使用 `--fix` 应用这些发现，`/review` 或 `/security-review` 进行更深入的只读检查。`/code-review ultra` 在云中运行多代理审查。

### 在会话之间

`/clear` 在保持项目内存的同时开始新任务。`/resume` 和 `/branch` 让您返回或分叉早期的对话。`/teleport` 将网络会话拉入此终端，`/remote-control` 让您从另一台设备继续此本地会话。

### 当出现问题时

`/rewind` 将代码和对话回滚到检查点，或总结对话的一部分。`/doctor` 和 `/debug` 诊断安装和运行时问题，`/feedback` 报告附加会话上下文的错误。

## 会话管理命令

### /init：初始化项目（首次必做！）

**功能**：使用 `CLAUDE.md` 指南初始化项目

**使用场景**：
- 第一次进入项目时
- 项目结构发生重大变化后

**实际案例**：

```bash
cd ~/your-project
claude
/init
```

Claude 会自动扫描你的项目，识别：
- 构建系统（npm、yarn、pnpm 等）
- 测试框架（jest、pytest 等）
- 代码模式和规范
- 项目结构

然后生成一个 `CLAUDE.md` 文件，这是 Claude Code 的"项目说明书"。

**进阶用法**：设置 `CLAUDE_CODE_NEW_INIT=1` 以获得交互式流程，该流程还会引导您完成 skills、hooks 和个人内存文件。

**我的建议**：首次使用必做！我第一次用的时候没做这步，结果 Claude 连我的项目用什么包管理器都搞错了。

### /clear：清空对话

**功能**：使用空上下文启动新对话

**使用场景**：
- 切换到完全不同的任务
- 上下文已经混乱，想重新开始
- 想释放上下文空间

**基本用法**：

```
/clear
```

**传递名称**：可以在 `/resume` 选择器中标记之前的对话

```
/clear my-task
```

**重要**：之前的对话在 `/resume` 中保持可用。要在继续同一对话的同时释放上下文，请改用 `/compact`。

**别名**：`/reset`、`/new`

**我的使用习惯**：
- 切换任务时用 `/clear`
- 上下文超过 80% 时用 `/clear`
- 想彻底重来时用 `/clear`

### /compact：压缩上下文（必会！）

**功能**：通过总结到目前为止的对话来释放上下文

**使用场景**：
- 上下文超过 50% 时
- 想保留对话历史，但释放空间
- 长时间对话后

**基本用法**：

```
/compact
```

**带焦点压缩**：

```
/compact focus on API changes
```

这会告诉 Claude 重点保留与 API 变更相关的内容。

**实际案例**：

我在重构一个模块，聊了 30 分钟，上下文用了 65%。执行 `/compact` 后，上下文降到了 35%，Claude 还记得之前讨论的关键点。

**我的使用习惯**：
- 每隔 30 分钟看一次 `/context`
- 超过 50% 就 `/compact`
- 重要任务用 `/compact focus on xxx`

### /context：查看上下文使用量

**功能**：将当前上下文使用情况可视化为彩色网格

**使用场景**：
- 想知道上下文用了多少
- 决定是否需要 `/compact`
- 监控上下文消耗

**基本用法**：

```
/context
```

**显示全部信息**：

```
/context all
```

会显示上下文密集型工具、内存膨胀和容量警告的优化建议。

**我的使用习惯**：
- 每隔 30 分钟看一次
- 超过 50% 就 `/compact`
- 超过 80% 就 `/clear`

### /model：切换模型

**功能**：切换 AI 模型并将其保存为新会话的默认值

**使用场景**：
- 想从 DeepSeek 切换到 Claude
- 想试试不同的模型
- 复杂任务需要更强的模型

**基本用法**：

```
/model
```

会显示所有可用的模型列表。

**直接切换**：

```
/model deepseek-chat
/model claude-sonnet-4-6
/model claude-opus-4-6
```

**调整工作量级别**：对于支持的模型，使用左/右箭头调整工作量级别。

**重要**：当对话有先前输出时，选择器要求确认，因为下一个响应会重新读取完整历史记录而不使用缓存的上下文。

**我的使用习惯**：
- 日常开发：DeepSeek（性价比高）
- 复杂任务：Claude Opus（推理能力强）
- 快速查询：Claude Haiku（速度快）

### /resume：恢复会话

**功能**：按 ID 或名称恢复对话，或打开会话选择器

**使用场景**：
- 想继续昨天的工作
- 想切换到其他项目的会话
- 想恢复中断的会话

**基本用法**：

```
/resume
```

会显示所有可恢复的会话列表。

**指定会话**：

```
/resume session-id
/resume my-task
```

**命令行方式**：

```bash
claude --resume           # 交互选择恢复某个会话
claude --resume <id>      # 恢复指定 session ID 的会话
```

**别名**：`/continue`

**我的使用习惯**：
- 早上开始工作：`claude -c` 继续昨天的会话
- 切换项目：`claude --resume` 选择之前的会话

## 代码审查与发布命令

### /diff：查看差异

**功能**：打开交互式差异查看器，显示未提交的更改和每轮差异

**使用场景**：
- 想看 Claude 改了什么
- 想查看未提交的更改
- 想对比不同轮次的差异

**基本用法**：

```
/diff
```

**操作方式**：
- 使用左/右箭头在当前 git 差异和单个 Claude 轮次之间切换
- 使用上/下浏览文件

### /code-review：代码审查

**功能**：审阅当前差异以查找正确性错误以及重用、简化和效率清理

**使用场景**：
- 提交前想检查代码质量
- 想让 Claude 帮你找 bug
- 想优化代码

**基本用法**：

```
/code-review
```

**应用修复**：

```
/code-review --fix
```

**发布为 PR 评论**：

```
/code-review --comment
```

**深度云审查**：

```
/code-review ultra
```

**工作量级别**：
- `low`：快速检查
- `medium`：标准检查
- `high`：深入检查
- `xhigh`：非常深入
- `max`：最大深度
- `ultra`：云中多代理审查

**我的使用习惯**：
- 日常开发：`/code-review`（标准检查）
- 重要提交：`/code-review high`（深入检查）
- 想自动修复：`/code-review --fix`

### /review：审阅 PR

**功能**：在当前会话中本地审阅 pull request

**使用场景**：
- 想审查别人的 PR
- 想检查代码变更

**基本用法**：

```
/review
```

**指定 PR**：

```
/review #123
/review https://github.com/user/repo/pull/123
```

### /security-review：安全审查

**功能**：分析当前分支上的待处理更改以查找安全漏洞

**使用场景**：
- 提交前想检查安全问题
- 想查找潜在的安全漏洞

**基本用法**：

```
/security-review
```

会审查 git 差异并识别注入、身份验证问题和数据泄露等风险。

## 并行工作命令

### /background：后台运行

**功能**：将当前会话分离以作为后台代理运行并释放此终端

**使用场景**：
- Claude 正在执行耗时任务
- 你想继续做其他事情
- 想同时运行多个会话

**基本用法**：

```
/background
```

**传递提示**：

```
/background continue working on the auth module
```

**监控后台会话**：

```bash
claude agents
```

**别名**：`/bg`

**我的使用习惯**：
- 耗时任务：`/background` 放后台
- 多任务并行：启动多个后台会话

### /tasks：查看后台任务

**功能**：查看和管理后台运行的所有内容

**使用场景**：
- 想查看有哪些后台任务在运行
- 想管理后台任务
- 想监控任务进度

**基本用法**：

```
/tasks
```

**别名**：`/bashes`

### /batch：批量更改

**功能**：在整个代码库中并行编排大规模更改

**使用场景**：
- 需要跨多个文件进行大规模重构
- 想并行处理多个独立单元
- 需要为每个单元创建单独的 PR

**基本用法**：

```
/batch migrate src/ from Solid to React
```

**工作流程**：
1. 研究代码库
2. 将工作分解为 5 到 30 个独立单元
3. 呈现一个计划
4. 获得批准后，在隔离的 git worktree 中为每个单元生成一个后台 subagent
5. 每个 subagent 实现其单元、运行测试并打开一个 pull request

**重要**：需要一个 git 存储库。

## 调试与诊断命令

### /doctor：诊断安装

**功能**：诊断并验证您的 Claude Code 安装和设置

**使用场景**：
- Claude Code 运行异常
- 想检查安装是否正确
- 想查看配置状态

**基本用法**：

```
/doctor
```

会显示状态图标。按 `f` 让 Claude 修复任何报告的问题。

### /debug：调试日志

**功能**：为当前会话启用调试日志记录并通过读取会话调试日志来排查问题

**使用场景**：
- Claude Code 行为异常
- 想查看详细的执行日志
- 需要排查问题

**基本用法**：

```
/debug
```

**描述问题**：

```
/debug Claude is not responding to my commands
```

**重要**：调试日志默认关闭，除非您使用 `claude --debug` 启动，因此在会话中途运行 `/debug` 会从该点开始捕获日志。

### /feedback：提交反馈

**功能**：提交反馈、报告错误或分享您的对话

**使用场景**：
- 发现了 bug
- 想提供建议
- 想分享对话

**基本用法**：

```
/feedback
```

**别名**：`/bug`、`/share`

### /rewind：回退操作

**功能**：将对话和/或代码倒回到上一个点，或从选定的消息进行总结

**使用场景**：
- Claude 改错了文件，想撤回
- 想回到之前的对话节点
- 想撤销最近的操作

**基本用法**：

```
/rewind
```

会显示可回退的节点列表。

**别名**：`/checkpoint`、`/undo`

**我的使用习惯**：
- 改错了文件：`/rewind` 回退代码
- 对话跑偏了：`/rewind` 回退对话
- 想重新来过：`/rewind` 回退到之前的节点

## 权限与配置命令

### /permissions：管理权限

**功能**：管理工具权限的允许、询问和拒绝规则

**使用场景**：
- 想查看当前权限设置
- 想修改某些工具的权限
- 想添加或移除工具白名单

**基本用法**：

```
/permissions
```

会打开交互式对话框，您可以：
- 按范围查看规则
- 添加或删除规则
- 管理工作目录
- 查看最近的自动模式拒绝

**别名**：`/allowed-tools`

### /config：打开设置

**功能**：打开设置界面以调整主题、模型、输出样式和其他偏好设置

**使用场景**：
- 想修改 Claude Code 的设置
- 想切换主题
- 想调整输出样式

**基本用法**：

```
/config
```

**别名**：`/settings`

## MCP 管理命令

### /mcp：管理 MCP 服务器

**功能**：管理 MCP server 连接和 OAuth 身份验证

**使用场景**：
- 想查看哪些 MCP 服务器在运行
- 想重新连接断开的服务器
- 想启用或禁用 MCP 服务器

**基本用法**：

```
/mcp
```

会打开交互式列表。

**重新连接服务器**：

```
/mcp reconnect github
```

**启用/禁用服务器**：

```
/mcp enable github
/mcp disable all
```

**我的使用习惯**：
- 定期检查 MCP 状态
- 上下文消耗过大时关闭不必要的 MCP

## 子代理命令

### /agents：管理子代理

**功能**：管理 agent 配置

**使用场景**：
- 想查看有哪些子代理可用
- 想配置子代理
- 想创建自定义子代理

**基本用法**：

```
/agents
```

### /fork：分叉子代理

**功能**：生成一个分叉的 subagent：一个继承完整对话的后台 subagent，在您继续进行时处理该指令

**使用场景**：
- 想让子代理处理某个任务
- 想继续做其他事情
- 想并行处理多个任务

**基本用法**：

```
/fork implement the user authentication module
```

**重要**：其结果在完成时返回到您的对话。要自己切换到对话的副本，请使用 `/branch`。

### /branch：创建分支

**功能**：在此点创建当前对话的分支，以便您可以尝试不同的方向而不会丢失当前的对话

**使用场景**：
- 想尝试不同的方案
- 想保留当前对话
- 想分叉对话

**基本用法**：

```
/branch
```

**指定名称**：

```
/branch try-react-approach
```

**重要**：切换到分支并保留原始分支，您可以使用 `/resume` 返回。

## 非交互模式命令

非交互模式（Headless Mode）让你可以在命令行中一次性执行任务，不需要进入交互界面。

### claude -p：单次执行

**功能**：执行单次任务，不进入交互模式

**基本用法**：

```bash
claude -p "分析这个项目的架构"
```

**实际案例**：

```bash
# 代码审查
claude -p "审查 src/ 目录的代码，找出潜在的 bug" \
  --allowedTools "Read,Grep,Glob" \
  --permission-mode plan \
  --max-turns 5

# 批量重构
claude -p "把所有的 console.log 替换成 logger" \
  --allowedTools "Read,Write,Edit,Bash" \
  --max-turns 10
```

### claude -c：继续上一个会话

**功能**：继续上一个会话，不创建新会话

**基本用法**：

```bash
claude -c
```

**我的使用习惯**：
- 早上开始工作：`claude -c` 继续昨天的会话

### claude --resume：恢复会话

**功能**：恢复之前的会话

**基本用法**：

```bash
claude --resume           # 交互选择恢复某个会话
claude --resume <id>      # 恢复指定 session ID 的会话
```

### --max-turns：限制轮次

**功能**：限制 Claude 执行的轮次，防止无限循环

**使用场景**：
- 非交互模式下，防止 Claude 无限循环
- 限制执行时间
- 控制成本

**基本用法**：

```bash
claude -p "分析代码" --max-turns 5
```

**我的使用习惯**：
- 简单任务：`--max-turns 3-5`
- 中等任务：`--max-turns 5-10`
- 复杂任务：`--max-turns 10-15`

**重要提醒**：非交互模式务必指定 `--max-turns`，防止无限循环。

### --output-format：输出格式

**功能**：指定输出格式

**可选值**：
- `text`：纯文本（默认）
- `json`：JSON 格式
- `stream-json`：流式 JSON

**基本用法**：

```bash
claude -p "分析代码" --output-format json
```

**实际案例**：

```bash
# 生成 JSON 报告
claude -p "分析代码" --output-format json > report.json

# 流式输出
claude -p "分析代码" --output-format stream-json
```

### --session-id：会话 ID

**功能**：指定会话 ID，实现多轮会话

**基本用法**：

```bash
claude -p "分析代码" --session-id review-001
claude -p "刚才发现了什么 bug？" --session-id review-001
claude -p "修复最严重的那个 bug" --session-id review-001
```

## CLI 参数速查表

| 参数 | 功能 | 示例 |
|------|------|------|
| `-p` | 单次执行 | `claude -p "分析代码"` |
| `-c` | 继续上一个会话 | `claude -c` |
| `--resume` | 恢复会话 | `claude --resume <id>` |
| `--max-turns` | 限制轮次 | `claude -p "分析" --max-turns 5` |
| `--output-format` | 输出格式 | `claude -p "分析" --output-format json` |
| `--session-id` | 会话 ID | `claude -p "分析" --session-id xxx` |
| `--allowedTools` | 工具白名单 | `claude -p "分析" --allowedTools "Read,Grep"` |
| `--permission-mode` | 权限模式 | `claude -p "分析" --permission-mode plan` |
| `--model` | 指定模型 | `claude -p "分析" --model deepseek-chat` |

## 命令组合技巧

### 管道输入

**功能**：将文件内容传给 Claude

**基本用法**：

```bash
cat error.log | claude -p "分析错误日志，找到根本原因"
git diff HEAD~1 | claude -p "审查这个 diff，列出潜在问题"
```

**实际案例**：

```bash
# 分析错误日志
cat error.log | claude -p "分析错误日志，找到根本原因并给出修复建议"

# 审查 Git 变更
git diff HEAD~1 | claude -p "审查这个 diff，列出潜在问题"

# 分析代码
cat src/auth.ts | claude -p "分析这个文件的认证逻辑"
```

### 会话 ID 管理

**功能**：用会话 ID 维持多轮对话

**基本用法**：

```bash
# 第一轮：分析
claude -p "分析 src/ 目录的代码" --session-id review-001

# 第二轮：提问
claude -p "刚才发现了什么 bug？" --session-id review-001

# 第三轮：修复
claude -p "修复最严重的那个 bug" --session-id review-001
```

### 批量执行脚本

**功能**：用脚本批量执行 Claude 命令

**实际案例**：

```bash
#!/bin/bash
# 每日代码审查脚本

git diff HEAD~1 | claude -p "审查这个 diff，找出：
1. 潜在的 bug
2. 安全问题
3. 性能问题
4. 代码质量问题
请给出具体的修复建议。" \
  --allowedTools "Read,Grep,Glob" \
  --permission-mode plan \
  --max-turns 5 \
  --output-format json > review-$(date +%Y%m%d).json
```

## 我的命令使用习惯

经过一个月的使用，我形成了自己的命令习惯：

**1. 会话管理**

- 每天开始：`claude -c` 继续昨天的会话
- 新任务：`claude` 开新会话
- 切换项目：`claude --resume` 选择会话

**2. 上下文管理**

- 每 30 分钟：`/context` 查看用量
- 超过 50%：`/compact` 压缩
- 超过 80%：`/clear` 清空

**3. 模型切换**

- 日常开发：DeepSeek
- 复杂任务：Claude Opus
- 快速查询：Claude Haiku

**4. 代码审查**

- 日常审查：`/code-review`
- 深入审查：`/code-review high`
- 自动修复：`/code-review --fix`
- 安全审查：`/security-review`

**5. 非交互模式**

- 代码审查：`claude -p "审查代码" --max-turns 5`
- 批量重构：`claude -p "重构代码" --max-turns 10`
- 分析日志：`cat log | claude -p "分析日志"`

**6. 调试诊断**

- 查看 MCP：`/mcp`
- 回退操作：`/rewind`
- 查看帮助：`/help`
- 诊断问题：`/doctor`

## 下一篇预告

这篇讲了常用命令。下一篇文章，我会详细介绍 Claude Code 的 CLAUDE.md 配置与上下文管理——这些配置能让 Claude 更懂你。

---

**相关推荐：**
- [Claude Code 入门：从安装到模型配置，以 DeepSeek 为例](/archives/0110/)
- [Claude Code 快捷键：这 15 个键让我效率翻倍](/archives/0111/)
- [Claude Code 配置：CLAUDE.md 与上下文管理的艺术](/archives/0113/)（即将发布）

**P.S.** 命令这个东西，一开始记不住没关系，先记住 `/init`、`/compact`、`/clear` 这三个，其他慢慢来。用多了自然就熟了！
