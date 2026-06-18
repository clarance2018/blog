---
title: Claude Code Subagents：让 AI 分身帮你干活
categories: AI探索
tags: [Claude Code,AI编程,Subagents,子代理,效率工具]
date: 2026-06-18 15:00:00
id: 0116
---

前六篇我们聊了 Claude Code 的安装配置、快捷键、命令、CLAUDE.md 配置、Skills 和 MCP。这篇来说说真正让我效率飙升的高级功能——Subagents。

说实话，用了一个月基础功能后，我觉得 Claude Code 也就那样——比 Cursor 好用，但没到"降维打击"的程度。

直到我发现了 Subagents 这个功能。

## 什么是 Subagents

Subagents 是处理特定类型任务的专门 AI 助手。当一个辅助任务会用搜索结果、日志或文件内容充斥您的主对话，而您不会再次引用这些内容时，请使用一个 subagent：该 subagent 在自己的上下文中完成这项工作，仅返回摘要。

**一句话理解**：如果说主对话是一个"项目经理"，那 Subagents 就是它的"程序员团队"。

## 为什么需要 Subagents

Subagents 帮助您：

* **保留上下文**，通过将探索和实现保持在主对话之外
* **强制执行约束**，通过限制 subagent 可以使用的工具
* **跨项目重用配置**，使用用户级 subagents
* **专门化行为**，为特定领域使用专注的系统提示
* **控制成本**，通过将任务路由到更快、更便宜的模型（如 Haiku）

## 内置 Subagents

Claude Code 包括几个内置 subagents，Claude 在适当时自动使用。

### Explore：代码探索

一个快速的、只读的代理，针对搜索和分析代码库进行了优化。

* **Model**：Haiku（快速、低延迟）
* **Tools**：只读工具（拒绝访问 Write 和 Edit 工具）
* **Purpose**：文件发现、代码搜索、代码库探索

当 Claude 需要搜索或理解代码库而不进行更改时，它会委托给 Explore。这样可以将探索结果保持在主对话上下文之外。

**使用场景**：

```text
用 Explore 子代理分析 src/ 目录的架构
```

### Plan：方案规划

一个研究代理，在 plan mode 期间使用，以在呈现计划之前收集上下文。

* **Model**：从主对话继承
* **Tools**：只读工具（拒绝访问 Write 和 Edit 工具）
* **Purpose**：用于规划的代码库研究

当您处于 plan mode 并且 Claude 需要理解您的代码库时，它会将研究委托给 Plan subagent，以便探索输出保持在单独的上下文窗口中，而主对话保持只读。

**使用场景**：

```text
用 Plan 子代理规划用户认证功能的实现方案
```

### General-purpose：通用代理

一个能够处理复杂、多步骤任务的代理，需要探索和操作。

* **Model**：从主对话继承
* **Tools**：所有工具
* **Purpose**：复杂研究、多步骤操作、代码修改

当任务需要探索和修改、复杂推理来解释结果或多个依赖步骤时，Claude 会委托给 general-purpose。

**使用场景**：

```text
用 general-purpose 子代理实现用户认证功能
```

### 其他内置代理

| Agent | Model | Claude 何时使用它 |
|-------|-------|------------------|
| statusline-setup | Sonnet | 当您运行 `/statusline` 来配置您的状态行时 |
| claude-code-guide | Haiku | 当您提出关于 Claude Code 功能的问题时 |

## 快速入门：创建您的第一个 Subagent

### 步骤1：打开 subagents 界面

在 Claude Code 中，运行：

```text
/agents
```

### 步骤2：选择一个位置

切换到 **Library** 选项卡，选择 **Create new agent**，然后选择 **Personal**。这会将 subagent 保存到 `~/.claude/agents/`，以便在所有项目中可用。

### 步骤3：使用 Claude 生成

选择 **Generate with Claude**。出现提示时，描述 subagent：

```text
A code improvement agent that scans files and suggests improvements
for readability, performance, and best practices. It should explain
each issue, show the current code, and provide an improved version.
```

Claude 为您生成标识符、描述和系统提示。

### 步骤4：选择工具

对于只读审查者，取消选择除 **Read-only tools** 之外的所有内容。如果您保持所有工具被选中，subagent 会继承主对话可用的所有工具。

### 步骤5：选择模型

选择 subagent 使用的模型。对于此示例代理，选择 **Sonnet**，它在分析代码模式的能力和速度之间取得平衡。

### 步骤6：选择颜色

为 subagent 选择背景颜色。这有助于您在 UI 中识别哪个 subagent 正在运行。

### 步骤7：配置内存

选择 **User scope** 为 subagent 提供一个 persistent memory directory，位于 `~/.claude/agent-memory/`。Subagent 使用这个来在对话中积累见解，例如代码库模式和重复出现的问题。

### 步骤8：保存并尝试

查看配置摘要。按 `s` 或 `Enter` 保存，或按 `e` 在编辑器中保存并编辑文件。Subagent 立即可用。尝试它：

```text
Use the code-improver agent to suggest improvements in this project
```

Claude 委托给您的新 subagent，它扫描代码库并返回改进建议。

## 配置 Subagents

### 选择 Subagent 范围

Subagents 是带有 YAML frontmatter 的 Markdown 文件。根据范围将它们存储在不同的位置。

| Location | Scope | Priority | 如何创建 |
|----------|-------|----------|----------|
| 托管设置 | 组织范围 | 1（最高） | 通过 managed settings 部署 |
| `--agents` CLI 标志 | 当前会话 | 2 | 启动 Claude Code 时传递 JSON |
| `.claude/agents/` | 当前项目 | 3 | 交互式或手动 |
| `~/.claude/agents/` | 所有您的项目 | 4 | 交互式或手动 |
| Plugin 的 `agents/` 目录 | 启用 plugin 的位置 | 5（最低） | 与 plugins 一起安装 |

**项目 subagents**（`.claude/agents/`）非常适合特定于代码库的 subagents。将它们检入版本控制，以便您的团队可以协作使用和改进它们。

**用户 subagents**（`~/.claude/agents/`）是在所有项目中可用的个人 subagents。

### 编写 Subagent 文件

Subagent 文件使用 YAML frontmatter 进行配置，然后是 Markdown 中的系统提示：

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

Frontmatter 定义了 subagent 的元数据和配置。正文成为指导 subagent 行为的系统提示。

### 支持的 Frontmatter 字段

| Field | 必需 | Description |
|-------|------|-------------|
| `name` | 是 | 使用小写字母和连字符的唯一标识符 |
| `description` | 是 | Claude 何时应该委托给此 subagent |
| `tools` | 否 | subagent 可以使用的工具。如果省略，继承所有工具 |
| `disallowedTools` | 否 | 要拒绝的工具，从继承或指定的列表中删除 |
| `model` | 否 | 使用的模型：`sonnet`、`opus`、`haiku`、`fable`、完整模型 ID 或 `inherit` |
| `permissionMode` | 否 | 权限模式：`default`、`acceptEdits`、`auto`、`dontAsk`、`bypassPermissions` 或 `plan` |
| `maxTurns` | 否 | subagent 停止前的最大代理轮数 |
| `skills` | 否 | 在启动时加载到 subagent 的上下文中的技能 |
| `mcpServers` | 否 | 对此 subagent 可用的 MCP 服务器 |
| `hooks` | 否 | 限定于此 subagent 的生命周期 hooks |
| `memory` | 否 | 持久内存范围：`user`、`project` 或 `local` |
| `background` | 否 | 设置为 `true` 以始终将此 subagent 作为后台任务运行 |
| `effort` | 否 | 此 subagent 活跃时的努力级别 |
| `isolation` | 否 | 设置为 `worktree` 以在临时 git worktree 中运行 subagent |
| `color` | 否 | Subagent 在任务列表和转录中的显示颜色 |
| `initialPrompt` | 否 | 当此代理作为主会话代理运行时，自动提交为第一个用户轮次 |

### 选择模型

`model` 字段控制 subagent 使用的 AI model：

* **Model alias**：使用可用的别名之一：`sonnet`、`opus`、`haiku` 或 `fable`
* **Full model ID**：使用完整的模型 ID，如 `claude-opus-4-8` 或 `claude-sonnet-4-6`
* **inherit**：使用与主对话相同的模型
* **Omitted**：如果未指定，默认为 `inherit`

### 控制 Subagent 能力

#### 可用工具

Subagents 默认继承主对话中可用的内部工具和 MCP 工具。

要限制工具，使用 `tools` 字段（允许列表）或 `disallowedTools` 字段（拒绝列表）。

**示例1：使用 tools 允许列表**

```yaml
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
---
```

**示例2：使用 disallowedTools 拒绝列表**

```yaml
---
name: no-writes
description: Inherits every tool except file writes
disallowedTools: Write, Edit
---
```

#### 权限模式

`permissionMode` 字段控制 subagent 如何处理权限提示。

| Mode | Behavior |
|------|----------|
| `default` | 标准权限检查，带有提示 |
| `acceptEdits` | 自动接受文件编辑 |
| `auto` | Auto mode：后台分类器审查命令 |
| `dontAsk` | 自动拒绝权限提示 |
| `bypassPermissions` | 跳过权限提示 |
| `plan` | Plan mode（只读探索） |

#### 预加载技能

使用 `skills` 字段在启动时将技能内容注入到 subagent 的上下文中。

```yaml
---
name: api-developer
description: Implement API endpoints following team conventions
skills:
  - api-conventions
  - error-handling-patterns
---

Implement API endpoints. Follow the conventions and patterns from the preloaded skills.
```

#### 启用持久内存

`memory` 字段为 subagent 提供一个在对话中幸存的持久目录。

```yaml
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---

You are a code reviewer. As you review code, update your agent memory with
patterns, conventions, and recurring issues you discover.
```

根据内存应该应用的广泛程度选择范围：

| Scope | Location | 使用时机 |
|-------|----------|----------|
| `user` | `~/.claude/agent-memory/<name>/` | subagent 应该在所有项目中记住学习 |
| `project` | `.claude/agent-memory/<name>/` | subagent 的知识是特定于项目的并可通过版本控制共享 |
| `local` | `.claude/agent-memory-local/<name>/` | subagent 的知识是特定于项目的但不应检入版本控制 |

#### 使用 Hooks 的条件规则

为了更动态地控制工具使用，使用 `PreToolUse` hooks 在执行前验证操作。

```yaml
---
name: db-reader
description: Execute read-only database queries
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

## 使用 Subagents

### 理解自动委托

Claude 根据您请求中的任务描述、subagent 配置中的 `description` 字段和当前上下文自动委托任务。要鼓励主动委托，在您的 subagent 的 description 字段中包含"use proactively"之类的短语。

### 显式调用 Subagents

当自动委托不够时，您可以自己请求 subagent。

**自然语言**：在提示中命名 subagent；Claude 决定是否委托

```text
Use the test-runner subagent to fix failing tests
Have the code-reviewer subagent look at my recent changes
```

**@-mention subagent**：保证 subagent 为一个任务运行

```text
@"code-reviewer (agent)" look at the auth changes
```

**将整个会话作为 subagent 运行**：传递 `--agent <name>` 以启动一个会话，其中主线程本身采用该 subagent 的系统提示、工具限制和模型

```bash
claude --agent code-reviewer
```

### 在前台或后台运行 Subagents

Subagents 可以在前台（阻塞）或后台（并发）运行：

* **前台 subagents** 阻塞主对话直到完成。权限提示会在出现时传递给您。
* **后台 subagents** 在您继续工作时并发运行。它们使用会话中已授予的权限运行，并自动拒绝任何会提示的工具调用。

要禁用所有后台任务功能，请将 `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` 环境变量设置为 `1`。

### 常见模式

#### 隔离高容量操作

subagents 最有效的用途之一是隔离产生大量输出的操作。

```text
Use a subagent to run the test suite and report only the failing tests with their error messages
```

#### 运行并行研究

对于独立的调查，生成多个 subagents 以同时工作：

```text
Research the authentication, database, and API modules in parallel using separate subagents
```

#### 链接 Subagents

对于多步骤工作流，要求 Claude 按顺序使用 subagents：

```text
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

### 分叉当前对话

分叉是一个 subagent，它继承到目前为止的整个对话，而不是从头开始。

要启动分叉，使用 `/fork` 后跟指令：

```text
/fork draft unit tests for the parser changes so far
```

分叉出现在提示下方的面板中，并在您继续工作时在后台运行。

## 示例 Subagents

### 代码审查者

一个只读 subagent，审查代码而不修改它。

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### 调试器

一个可以分析和修复问题的 subagent。

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### 数据科学家

一个用于数据分析工作的特定领域 subagent。

```markdown
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:
- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:
- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

### 数据库查询验证器

一个允许 Bash 访问但验证命令以仅允许只读 SQL 查询的 subagent。

```markdown
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries to answer questions about the data.

When asked to analyze data:
1. Identify which tables contain the relevant data
2. Write efficient SELECT queries with appropriate filters
3. Present results clearly with context

You cannot modify data. If asked to INSERT, UPDATE, DELETE, or modify schema, explain that you only have read access.
```

## 我的 Subagents 使用习惯

经过一个月的使用，我形成了自己的 Subagents 习惯：

**1. 常用子代理**

- `code-reviewer`：代码审查
- `debugger`：调试问题
- `test-generator`：测试生成

**2. 子代理管理**

- 把子代理配置放在项目仓库中
- 团队共享同一套子代理
- 定期更新和维护

**3. 子代理调用**

- 大量代码阅读：用 Explore 子代理
- 方案规划：用 Plan 子代理
- 代码验证：用 Verify 子代理

**4. 性能优化**

- 使用子代理隔离上下文
- 定期清理不需要的子代理
- 选择合适的模型

## 实际工作流

### 场景1：重构一个模块

**任务**：重构一个认证模块，涉及 20 多个文件

**工作流**：
1. 用 `Explore` 子代理分析现有代码
2. 用 `Plan` 子代理规划重构方案
3. 主对话执行重构
4. 用 `Verify` 子代理验证重构结果

**效果**：整个过程，主对话的上下文始终保持在 30% 以下，Claude 的表现一直很稳定。

### 场景2：分析大型代码库

**任务**：分析一个有 1000 个文件的代码库

**工作流**：
1. 用 `Explore` 子代理分析代码库
2. 子代理返回架构报告
3. 主对话继续讨论

**效果**：主对话的上下文完全不受影响。

### 场景3：并行处理多个任务

**任务**：同时处理 3 个不同的任务

**工作流**：
1. 启动 3 个后台子代理
2. 每个子代理处理一个任务
3. 主对话继续做其他事情

**效果**：效率提升 3 倍。

## 下一篇预告

这篇讲了 Subagents 子代理。下一篇文章，我会详细介绍 Claude Code 的踩坑经验——这些经验能帮你避免常见的问题。

---

**相关推荐：**
- [Claude Code 入门：从安装到模型配置，以 DeepSeek 为例](/archives/0110/)
- [Claude Code 快捷键：这 15 个键让我效率翻倍](/archives/0111/)
- [Claude Code 命令大全：这 20 个命令你必须掌握](/archives/0112/)
- [Claude Code 配置：CLAUDE.md 与上下文管理的艺术](/archives/0113/)
- [Claude Code Skills：让 AI 记住你的工作流程](/archives/0114/)
- [Claude Code MCP：连接外部世界的桥梁](/archives/0115/)
- [Claude Code 踩坑经验：这些教训你一定要知道](/archives/0117/)（即将发布）

**P.S.** Subagents 这个功能，真的改变了我对 AI 编程的认知。以前我觉得 AI 只能帮我写写代码，现在它能帮我分析、规划、验证，几乎能参与整个开发流程。如果你有需要并行处理的场景，一定要试试 Subagents！
