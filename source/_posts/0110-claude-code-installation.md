---
title: Claude Code 入门：从安装到模型配置，以 DeepSeek 为例
categories: AI探索
tags: [Claude Code,AI编程,DeepSeek,模型配置,zcf,cc Switch]
date: 2026-06-18 09:00:00
id: 0110
---

上个月，我决定认真试试 Claude Code。

之前一直用 Cursor 写代码，但总觉得差点意思——每次都要在编辑器里切来切去，而且对于一些复杂的项目分析，Cursor 的理解能力总是不够深入。

直到有个朋友跟我说："你试试 Claude Code，用命令行的那个。"

我当时想，命令行？这不是倒退吗？结果用了一个月，我发现：**这根本不是倒退，这是降维打击。**

## 为什么我要从 Cursor 换到 Claude Code

先说说我之前的痛点：

1. **上下文理解不够深**：Cursor 只能理解当前打开的文件，对于整个项目的架构、依赖关系，它经常搞不清楚
2. **操作受限**：想让 AI 帮我运行测试、查看 git 状态，还得我自己复制粘贴结果
3. **多文件协作差**：让它重构一个跨 5 个文件的功能，经常改了这个忘了那个

Claude Code 解决了这些问题。它不是一个"编辑器里的助手"，而是一个**能直接操作你整个项目的 AI 程序员**。

## 安装：3 分钟搞定

前置要求很简单：
- Node.js 18+（必须）
- Git（必须）

然后一行命令：

```bash
npm install -g @anthropic-ai/claude-code
```

装完验证一下：

```bash
claude --version
```

能看到版本号就行。如果你用 macOS，也可以用 Homebrew：`brew install claude-code`。但我推荐 npm，因为能自动更新。

**其他安装方式**：

```bash
# Homebrew（macOS）
brew install claude-code

# WinGet（Windows）
winget install Anthropic.ClaudeCode
```

## 首次启动：先做这件事

进入你的项目目录，启动 Claude Code：

```bash
cd ~/your-project
claude
```

启动后，**第一件事不是提问，而是运行 `/init`**。

```
/init
```

这个命令会扫描你的代码库，自动生成一个 `CLAUDE.md` 文件——相当于给 Claude Code 写一份"项目说明书"。它会自动识别你的构建系统、测试框架、代码模式等信息。

**我第一次用的时候没做这步，结果 Claude 连我的项目用什么包管理器都搞错了。所以这一步真的不能省。**

## 模型配置：以 DeepSeek 为例

Claude Code 默认使用 Anthropic 的 Claude 模型，但你也可以配置其他模型，比如 DeepSeek。

### 默认 Claude 模型

Claude Code 支持以下模型：
- **Claude Opus 4.6**：最强推理能力，适合复杂任务
- **Claude Sonnet 4.6**：快速高效，适合日常开发
- **Claude Haiku 4.5**：最快速度，适合简单任务

你可以用 `/model` 命令切换模型。

### 环境变量配置

要使用第三方模型，你需要配置环境变量：

```bash
# 设置 API 基础 URL
export ANTHROPIC_BASE_URL="https://api.deepseek.com"

# 设置 API Key
export ANTHROPIC_API_KEY="your-deepseek-api-key"

# 启动 Claude Code
claude
```

### 以 DeepSeek 为例的配置

DeepSeek 是一个优秀的国产大模型，性价比很高。配置步骤如下：

**1. 获取 DeepSeek API Key**

访问 [DeepSeek 官网](https://platform.deepseek.com/) 注册并获取 API Key。

**2. 配置环境变量**

```bash
# 临时配置（当前终端有效）
export ANTHROPIC_BASE_URL="https://api.deepseek.com"
export ANTHROPIC_API_KEY="sk-xxx"

# 永久配置（写入 shell 配置文件）
echo 'export ANTHROPIC_BASE_URL="https://api.deepseek.com"' >> ~/.bashrc
echo 'export ANTHROPIC_API_KEY="sk-xxx"' >> ~/.bashrc
source ~/.bashrc
```

**3. 验证配置**

```bash
claude --model deepseek-chat
```

如果能正常对话，说明配置成功。

### 使用 OpenRouter 中转

OpenRouter 是一个模型聚合平台，可以访问多种模型：

```bash
# 配置 OpenRouter
export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
export ANTHROPIC_API_KEY="your-openrouter-key"

# 使用 DeepSeek 模型
claude --model deepseek/deepseek-chat
```

**优势**：一个 Key 可以访问多种模型，包括 Claude、DeepSeek、GPT 等。

## zcf：一键配置 Claude Code 环境

zcf 是一个开源的 Claude Code 配置工具，可以帮你一键完成环境初始化，省去手动配置的麻烦。

> 官方文档：https://zcf.ufomiao.com/zh-CN/getting-started/

### zcf 是什么

zcf（Claude Code Configurator）将环境配置、工作流导入与工具链整合到一套 CLI 中。核心能力包括：

- **环境初始化**：针对 Claude Code 与 Codex 的完整初始化流程，覆盖 API、输出风格、记忆、模板、MCP、工作流与状态栏
- **配置管理**：支持增量管理、备份策略、多 API 配置、模板语言与 AI 输出语言分离
- **工作流体系**：预置六阶段工作流、Feat 工作流、BMad 敏捷、Spec 扩展与 Git 智能命令
- **集成生态**：涵盖 CCR、Context7、Open Web Search、DeepWiki、Playwright 等

### 安装与使用

zcf 不需要全局安装，直接用 `npx` 运行即可：

```bash
# 首次使用：完整初始化
npx zcf init

# 或直接运行交互式菜单
npx zcf
```

初始化流程会让你选择：
1. 代码工具类型（Claude Code 或 Codex）
2. 配置 API 密钥或使用 API 提供商预设
3. 选择需要安装的 MCP 服务
4. 选择工作流模板和输出风格

### 常用命令

```bash
# 打开交互式菜单，聚合所有功能
npx zcf

# 完整初始化
npx zcf init
# 或简写
npx zcf i

# 更新工作流与模板
npx zcf update
# 或简写
npx zcf u

# 在多套配置之间切换
npx zcf config-switch
# 或简写
npx zcf cs

# 管理 Claude Code Router 代理
npx zcf ccr

# Claude Code 使用分析与统计
npx zcf ccu

# 检查并升级工具链
npx zcf check-updates

# 卸载配置（可选择保留备份）
npx zcf uninstall
```

每个命令均支持 `--help` 查看详细参数。

### 我的使用场景

我主要用 zcf 做这几件事：

**1. 快速初始化新环境**

换了新电脑，一条命令搞定所有配置：

```bash
npx zcf init
```

**2. 切换不同配置**

工作项目用 Claude，个人项目用 DeepSeek：

```bash
npx zcf config-switch
```

**3. 更新工作流模板**

zcf 会持续更新工作流模板，一条命令就能同步：

```bash
npx zcf update
```

## cc Switch：多工具统一管理

如果你同时使用多个 AI 编程工具，cc Switch 是你的必备神器。

> 官方文档：https://www.ccswitch.io/zh/docs

### cc Switch 是什么

cc Switch 是一个 AI 编程 CLI 统一管理工具，可以同时管理：
- Claude Code
- Codex
- Gemini CLI
- OpenCode
- OpenClaw
- Hermes Agent

它能帮你统一管理这些工具的：
- **供应商配置**：API Key、Base URL 等
- **本地路由**：模型代理和转发
- **MCP 服务**：外部工具集成
- **Skills**：可复用技能包
- **会话管理**：跨工具的会话记录
- **用量统计**：Token 消耗和费用追踪

### 为什么需要 cc Switch

**痛点**：我同时用 Claude Code 和 Gemini CLI，每次切换都要改环境变量，很烦。

**解决**：cc Switch 帮你统一管理所有配置，一键切换。

### 核心功能

**1. 供应商配置管理**

集中管理所有工具的 API 配置：

```bash
# 添加供应商配置
cc switch add-provider deepseek --url https://api.deepseek.com --key sk-xxx

# 切换供应商
cc switch use-provider deepseek
```

**2. 多工具切换**

在不同 AI 编程工具之间快速切换：

```bash
# 切换到 Claude Code
cc switch use claude

# 切换到 Gemini CLI
cc switch use gemini
```

**3. MCP 统一管理**

集中管理所有工具的 MCP 服务：

```bash
# 查看已安装的 MCP
cc switch mcp list

# 添加 MCP 服务
cc switch mcp add github
```

**4. 用量统计**

追踪所有工具的 Token 消耗：

```bash
# 查看用量统计
cc switch usage

# 查看费用报告
cc switch cost
```

## zcf vs cc Switch：怎么选

这两个工具都很优秀，但定位不同：

| 特性 | zcf | cc Switch |
|------|-----|-----------|
| **定位** | Claude Code 专用配置工具 | 多工具统一管理平台 |
| **支持工具** | Claude Code、Codex | Claude Code、Codex、Gemini CLI 等 6 种 |
| **核心优势** | 工作流模板、集成生态 | 多工具统一管理、用量统计 |
| **适合人群** | 主要用 Claude Code 的开发者 | 同时使用多个 AI 编程工具的开发者 |
| **安装方式** | `npx zcf`（无需安装） | 需要安装 |

**我的建议**：

- 如果你只用 Claude Code：用 zcf 就够了
- 如果你同时用多个 AI 工具：用 cc Switch
- 两者可以配合使用：用 zcf 配置 Claude Code，用 cc Switch 管理多工具切换

## 验证配置是否成功

配置完成后，需要验证是否生效：

**1. 检查环境变量**

```bash
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_API_KEY
```

**2. 测试连接**

```bash
claude -p "你好，请告诉我你是什么模型"
```

**3. 查看模型信息**

```
/model
```

**4. 测试功能**

```
解释一下这个项目的架构
```

如果能正常回答，说明配置成功。

## 常见安装问题排查

### 问题1：npm 安装失败

**症状**：`npm install -g @anthropic-ai/claude-code` 报错

**解决**：

```bash
# 清除 npm 缓存
npm cache clean --force

# 使用国内镜像
npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com

# 或使用 yarn
yarn global add @anthropic-ai/claude-code
```

### 问题2：权限错误

**症状**：`EACCES` 权限错误

**解决**：

```bash
# macOS/Linux
sudo npm install -g @anthropic-ai/claude-code

# 或修改 npm 全局目录
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

### 问题3：Node.js 版本过低

**症状**：提示需要 Node.js 18+

**解决**：

```bash
# 使用 nvm 安装最新 Node.js
nvm install 18
nvm use 18

# 或直接下载安装
# https://nodejs.org/
```

### 问题4：API Key 无效

**症状**：提示认证失败

**解决**：

```bash
# 检查 API Key 是否正确
echo $ANTHROPIC_API_KEY

# 重新设置
export ANTHROPIC_API_KEY="your-correct-key"

# 或使用 zcf 重新配置
npx zcf init
```

### 问题5：网络连接问题

**症状**：无法连接到 API 服务器

**解决**：

```bash
# 检查网络连接
ping api.deepseek.com

# 使用代理
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"

# 或使用国内镜像
export ANTHROPIC_BASE_URL="https://api.deepseek.com"
```

## 我的配置习惯

经过一个月的使用，我形成了自己的配置习惯：

**1. 模型选择策略**

- **日常开发**：DeepSeek（性价比高）
- **复杂任务**：Claude Opus（推理能力强）
- **快速查询**：Claude Haiku（速度快）

**2. 配置管理**

使用 zcf 管理 Claude Code 配置：

```bash
# 初始化配置
npx zcf init

# 切换配置
npx zcf config-switch

# 更新工作流
npx zcf update
```

**3. 环境变量管理**

在 `~/.bashrc` 中设置默认配置：

```bash
# 默认使用 DeepSeek
export ANTHROPIC_BASE_URL="https://api.deepseek.com"
export ANTHROPIC_API_KEY="sk-xxx"
```

**4. 快捷切换**

使用 cc Switch 快速切换模型：

```
/model deepseek-chat      # 切换到 DeepSeek
/model claude-sonnet-4-6  # 切换到 Claude Sonnet
```

## 下一篇预告

这篇是入门篇，讲了安装、认证和模型配置。下一篇文章，我会详细介绍 Claude Code 的快捷键——这些快捷键能让你的操作效率翻倍。

---

**相关推荐：**
- [Claude Code 快捷键：这 10 个键让我效率翻倍](/archives/0111/)（即将发布）
- [每月$20还是$100？四大AI工具最新定价，我帮你算清楚了](/archives/0108/)

**P.S.** 如果你在配置过程中遇到什么问题，欢迎在评论区留言，我会尽量解答。模型配置这个事情，一开始我也头大，但配好之后真的香！
