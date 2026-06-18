---
title: Claude Code MCP：连接外部世界的桥梁
categories: AI探索
tags: [Claude Code,AI编程,MCP,工具集成,效率工具]
date: 2026-06-18 14:00:00
id: 0115
---

前五篇我们聊了 Claude Code 的安装配置、快捷键、命令、CLAUDE.md 配置和 Skills。这篇来说说真正让 Claude "连接外部世界"的功能——MCP。

说实话，刚用 Claude Code 的时候，我只把它当成一个"本地的 AI 助手"。直到我发现了 MCP 这个功能，才明白为什么有人说它是"程序员的终极武器"——因为它真的能连接你的所有工具。

## 什么是 MCP

MCP（Model Context Protocol）是一个用于 AI 工具集成的开源标准。MCP 服务器为 Claude Code 提供对您的工具、数据库和 API 的访问权限。

**一句话理解**：如果说 Claude 是一个"AI 程序员"，那 MCP 就是它的"工具箱"。

## 使用 MCP 可以做什么

连接 MCP 服务器后，您可以要求 Claude Code：

**1. 从问题跟踪器实现功能**

```text
添加 JIRA 问题 ENG-4521 中描述的功能，并在 GitHub 上创建 PR。
```

**2. 分析监控数据**

```text
检查 Sentry 和 Statsig 以检查 ENG-4521 中描述的功能的使用情况。
```

**3. 查询数据库**

```text
根据我们的 PostgreSQL 数据库，查找使用功能 ENG-4521 的 10 个随机用户的电子邮件。
```

**4. 集成设计**

```text
根据在 Slack 中发布的新 Figma 设计更新我们的标准电子邮件模板
```

**5. 自动化工作流**

```text
创建 Gmail 草稿，邀请这 10 个用户参加关于新功能的反馈会议。
```

## 查找和构建 MCP 服务器

### 在 Anthropic Directory 中浏览

在 [Anthropic Directory](https://claude.ai/directory) 中浏览已审核的连接器。Directory 连接器使用与 Claude Code 相同的 MCP 基础设施，因此您可以使用 `claude mcp add` 添加列出的任何远程服务器。

### 使用 mcp-server-dev plugin 构建

您也可以使用官方的 `mcp-server-dev` plugin 让 Claude 为您搭建服务器。

**步骤1：安装 plugin**

```text
/plugin install mcp-server-dev@claude-plugins-official
```

**步骤2：运行构建 skill**

```text
/mcp-server-dev:build-mcp-server
```

Claude 会询问您的用例，并搭建一个远程 HTTP 或本地 stdio 服务器。

## 安装 MCP 服务器

MCP 服务器可以根据您的需求以多种方式进行配置：

### 选项 1：添加远程 HTTP 服务器（推荐）

HTTP 服务器是连接到远程 MCP 服务器的推荐选项。这是云服务最广泛支持的传输方式。

```bash
# 基本语法
claude mcp add --transport http <name> <url>

# 真实示例：连接到 Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# 带有 Bearer 令牌的示例
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### 选项 2：添加远程 SSE 服务器（已弃用）

SSE (Server-Sent Events) 传输已弃用。请在可用的地方使用 HTTP 服务器。

```bash
# 基本语法
claude mcp add --transport sse <name> <url>

# 真实示例：连接到 Asana
claude mcp add --transport sse asana https://mcp.asana.com/sse

# 带有身份验证标头的示例
claude mcp add --transport sse private-api https://api.company.com/sse \
  --header "X-API-Key: your-key-here"
```

### 选项 3：添加本地 stdio 服务器

Stdio 服务器作为您机器上的本地进程运行。它们非常适合需要直接系统访问或自定义脚本的工具。

```bash
# 基本语法
claude mcp add [options] <name> -- <command> [args...]

# 真实示例：添加 Airtable 服务器
claude mcp add --env AIRTABLE_API_KEY=YOUR_KEY --transport stdio airtable \
  -- npx -y airtable-mcp-server
```

**重要：使用 `--` 分隔服务器参数**

对于 stdio 服务器，`--`（双破折号）将 Claude 自己的选项（如 `--transport`、`--env` 和 `--scope`）与运行服务器的命令和参数分开。

### 选项 4：添加远程 WebSocket 服务器

WebSocket 服务器保持持久的双向连接，适合于向 Claude 主动推送事件的远程 MCP 服务器。

```bash
claude mcp add-json events-server \
  '{"type":"ws","url":"wss://mcp.example.com/socket","headers":{"Authorization":"Bearer YOUR_TOKEN"}}'
```

## 管理您的服务器

配置后，您可以使用这些命令管理您的 MCP 服务器：

```bash
# 列出所有配置的服务器
claude mcp list

# 获取特定服务器的详细信息
claude mcp get github

# 删除服务器
claude mcp remove github

# （在 Claude Code 中）检查服务器状态
/mcp
```

## MCP 安装范围

MCP 服务器可以在三个不同的范围级别进行配置：

| 范围 | 加载位置 | 与团队共享 | 存储位置 |
|------|----------|------------|----------|
| 本地（默认） | 仅当前项目 | 否 | `~/.claude.json` |
| 项目 | 仅当前项目 | 是，通过版本控制 | 项目根目录中的 `.mcp.json` |
| 用户 | 您的所有项目 | 否 | `~/.claude.json` |

### 本地范围

本地范围是默认范围。本地范围的服务器仅在您添加它的项目中加载，并对您保持私密。

```bash
# 添加本地范围的服务器（默认）
claude mcp add --transport http stripe https://mcp.stripe.com

# 显式指定本地范围
claude mcp add --transport http stripe --scope local https://mcp.stripe.com
```

### 项目范围

项目范围的服务器通过在项目根目录中存储配置在 `.mcp.json` 文件中来启用团队协作。

```bash
# 添加项目范围的服务器
claude mcp add --transport http paypal --scope project https://mcp.paypal.com/mcp
```

### 用户范围

用户范围的服务器存储在 `~/.claude.json` 中，并提供跨项目可访问性。

```bash
# 添加用户服务器
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

## 实际示例

### 示例1：使用 Sentry 监控错误

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

使用您的 Sentry 帐户进行身份验证：

```text
/mcp
```

然后调试生产问题：

```text
过去 24 小时内最常见的错误是什么？
```

```text
显示我错误 ID abc123 的堆栈跟踪
```

```text
哪个部署引入了这些新错误？
```

### 示例2：连接到 GitHub 进行代码审查

GitHub 的远程 MCP 服务器使用作为标头传递的 GitHub 个人访问令牌进行身份验证。

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

然后使用 GitHub：

```text
审查 PR #456 并建议改进
```

```text
为我们刚发现的错误创建新问题
```

```text
显示分配给我的所有开放 PR
```

### 示例3：查询您的 PostgreSQL 数据库

```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"
```

然后自然地查询您的数据库：

```text
本月我们的总收入是多少？
```

```text
显示订单表的架构
```

```text
查找 90 天内未进行购买的客户
```

## 推荐的 MCP 服务器

### 1. GitHub MCP

**功能**：Issue、PR、评论、代码审查

**安装**：

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

**使用场景**：
- 审查 PR
- 创建 Issue
- 查看分配给我的 PR
- 自动修复 CI 失败

### 2. Sentry MCP

**功能**：错误监控、性能监控

**安装**：

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

**使用场景**：
- 查看最近的错误
- 分析错误堆栈
- 追踪哪个部署引入了错误

### 3. PostgreSQL MCP

**功能**：数据库查询

**安装**：

```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"
```

**使用场景**：
- 查询数据
- 查看表结构
- 分析数据趋势

### 4. Notion MCP

**功能**：文档管理

**安装**：

```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

**使用场景**：
- 读取文档
- 创建文档
- 搜索文档

### 5. Slack MCP

**功能**：团队沟通

**安装**：

```bash
claude mcp add --transport http slack https://mcp.slack.com/mcp
```

**使用场景**：
- 发送消息
- 搜索消息
- 创建频道

## 使用远程 MCP 服务器进行身份验证

许多基于云的 MCP 服务器需要身份验证。Claude Code 支持 OAuth 2.0 以实现安全连接。

### 基本身份验证

当服务器响应 `401 Unauthorized` 或 `403 Forbidden` 时，Claude Code 将远程服务器标记为需要身份验证。

**步骤1：添加需要身份验证的服务器**

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

**步骤2：在 Claude Code 中使用 /mcp 命令**

```text
/mcp
```

然后按照浏览器中的步骤登录。

### 使用预配置的 OAuth 凭据

某些 MCP 服务器不支持通过动态客户端注册进行自动 OAuth 设置。

**步骤1：使用服务器注册 OAuth 应用**

通过服务器的开发者门户创建应用，并记下您的客户端 ID 和客户端密钥。

**步骤2：使用您的凭据添加服务器**

```bash
claude mcp add --transport http \
  --client-id your-client-id --client-secret --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```

**步骤3：在 Claude Code 中进行身份验证**

```text
/mcp
```

### 使用动态标头进行自定义身份验证

如果您的 MCP 服务器使用 OAuth 以外的身份验证方案（例如 Kerberos、短期令牌或内部 SSO），请使用 `headersHelper` 在连接时生成请求标头。

```json
{
  "mcpServers": {
    "internal-api": {
      "type": "http",
      "url": "https://mcp.internal.example.com",
      "headersHelper": "/opt/bin/get-mcp-auth-headers.sh"
    }
  }
}
```

## MCP 上下文消耗

MCP 服务器会在每次请求中添加工具定义，消耗大量上下文。

### 查看上下文消耗

使用 `/mcp` 查看每个服务器的上下文消耗：

```text
/mcp
```

### 优化建议

1. **只添加必要的 MCP**：不要添加太多 MCP 服务器
2. **使用工具搜索**：默认启用，延迟工具定义直到 Claude 需要它们
3. **设置 `alwaysLoad`**：对于常用工具，设置 `alwaysLoad: true`

### 工具搜索配置

工具搜索通过延迟工具定义直到 Claude 需要它们来保持 MCP 上下文使用低。

```bash
# 使用自定义 5% 阈值
ENABLE_TOOL_SEARCH=auto:5 claude

# 完全禁用工具搜索
ENABLE_TOOL_SEARCH=false claude
```

## MCP 输出限制和警告

当 MCP 工具产生大量输出时，Claude Code 可帮助管理令牌使用情况：

* **输出警告阈值**：当任何 MCP 工具输出超过 10,000 个令牌时，Claude Code 显示警告
* **可配置限制**：您可以使用 `MAX_MCP_OUTPUT_TOKENS` 环境变量调整最大允许的 MCP 输出令牌
* **默认限制**：默认最大值为 25,000 个令牌

要为产生大量输出的工具增加限制：

```bash
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

## MCP 提示

MCP 服务器可以公开在 Claude Code 中作为命令可用的提示。

### 执行 MCP 提示

**步骤1：发现可用的提示**

键入 `/` 以查看所有可用的命令，包括来自 MCP 服务器的命令。MCP 提示以 `/mcp__servername__promptname` 的格式出现。

**步骤2：执行不带参数的提示**

```text
/mcp__github__list_prs
```

**步骤3：执行带参数的提示**

```text
/mcp__github__pr_review 456
```

```text
/mcp__jira__create_issue "Bug in login flow" high
```

## 使用 MCP 资源

MCP 服务器可以公开资源，您可以使用 @ 提及来引用，类似于您引用文件的方式。

### 引用 MCP 资源

**步骤1：列出可用资源**

在您的提示中键入 `@` 以查看来自所有连接的 MCP 服务器的可用资源。

**步骤2：引用特定资源**

```text
Can you analyze @github:issue://123 and suggest a fix?
```

```text
Please review the API documentation at @docs:file://api/authentication
```

## 从 JSON 配置添加 MCP 服务器

如果您有 MCP 服务器的 JSON 配置，您可以直接添加它：

```bash
# 基本语法
claude mcp add-json <name> '<json>'

# 示例：添加带有 JSON 配置的 HTTP 服务器
claude mcp add-json weather-api '{"type":"http","url":"https://api.weather.com/mcp","headers":{"Authorization":"Bearer token"}}'

# 示例：添加带有 JSON 配置的 stdio 服务器
claude mcp add-json local-weather '{"type":"stdio","command":"/path/to/weather-cli","args":["--api-key","abc123"],"env":{"CACHE_DIR":"/tmp"}}'
```

## 从 Claude Desktop 导入 MCP 服务器

如果您已在 Claude Desktop 中配置了 MCP 服务器，您可以导入它们：

```bash
# 基本语法
claude mcp add-from-claude-desktop
```

运行命令后，您将看到一个交互式对话框，允许您选择要导入的服务器。

## 将 Claude Code 用作 MCP 服务器

您可以将 Claude Code 本身用作 MCP 服务器，其他应用程序可以连接到它：

```bash
# 启动 Claude 作为 stdio MCP 服务器
claude mcp serve
```

您可以通过将此配置添加到 claude_desktop_config.json 在 Claude Desktop 中使用它：

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

## MCP 安全注意事项

**重要**：在连接每个服务器之前，请验证您信任该服务器。获取外部内容的服务器可能会使您面临提示注入风险。

**安全建议**：
1. 只连接您信任的 MCP 服务器
2. 使用最小权限原则
3. 定期审查已连接的 MCP 服务器
4. 使用 OAuth 而不是 API Key（如果可能）

## 我的 MCP 使用习惯

经过一个月的使用，我形成了自己的 MCP 习惯：

**1. 常用 MCP 服务器**

- GitHub：代码审查、Issue 管理
- Sentry：错误监控
- PostgreSQL：数据库查询

**2. MCP 管理**

- 只添加必要的 MCP 服务器
- 定期检查 MCP 状态
- 上下文消耗过大时关闭不必要的 MCP

**3. MCP 调用**

- 简单任务：直接描述
- 复杂任务：使用 MCP 提示
- 自动识别：Claude 根据上下文自动调用

**4. 安全管理**

- 只连接信任的 MCP 服务器
- 使用 OAuth 而不是 API Key
- 定期审查已连接的 MCP 服务器

## 下一篇预告

这篇讲了 MCP 外部工具集成。下一篇文章，我会详细介绍 Claude Code 的 Subagents 子代理——这些子代理能让 Claude 并行处理多个任务。

---

**相关推荐：**
- [Claude Code 入门：从安装到模型配置，以 DeepSeek 为例](/archives/0110/)
- [Claude Code 快捷键：这 15 个键让我效率翻倍](/archives/0111/)
- [Claude Code 命令大全：这 20 个命令你必须掌握](/archives/0112/)
- [Claude Code 配置：CLAUDE.md 与上下文管理的艺术](/archives/0113/)
- [Claude Code Skills：让 AI 记住你的工作流程](/archives/0114/)
- [Claude Code Subagents：让 AI 分身帮你干活](/archives/0116/)（即将发布）

**P.S.** MCP 这个功能，真的改变了我对 AI 编程的认知。以前我觉得 AI 只能帮我写写代码，现在它能帮我连接所有工具，实现真正的自动化。如果你有需要连接外部工具的场景，一定要试试 MCP！
