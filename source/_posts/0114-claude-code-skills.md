---
title: Claude Code Skills：让 AI 记住你的工作流程
categories: AI探索
tags: [Claude Code,AI编程,效率工具,Skills,工作流]
date: 2026-06-18 13:00:00
id: 0114
---

前四篇我们聊了 Claude Code 的安装配置、快捷键、命令和 CLAUDE.md 配置。这篇来说说真正让我效率飙升的功能——Skills。

说实话，用了一周基础功能后，我觉得 Claude Code 也就那样——比 Cursor 好用，但没到"降维打击"的程度。

直到我发现了 Skills 这个功能。

## 什么是 Skills

Skills 扩展了 Claude 能做的事情。创建一个 `SKILL.md` 文件，其中包含说明，Claude 会将其添加到其工具包中。Claude 在相关时使用 skills，或者你可以使用 `/skill-name` 直接调用一个。

**一句话理解**：如果说 CLAUDE.md 是"入职指南"，那 Skills 就是"操作手册"。

**与 CLAUDE.md 的区别**：

与 CLAUDE.md 内容不同，skill 的正文仅在使用时加载，因此长参考资料在你需要它之前几乎不花费任何成本。

**什么时候该创建 Skill**：

当你不断将相同的说明、检查清单或多步骤程序粘贴到聊天中时，或者当 CLAUDE.md 的一部分已经演变成程序而不是事实时，创建一个 skill。

## 捆绑 Skills

Claude Code 包括一组捆绑 skills，在每个会话中都可用，除非通过 `disableBundledSkills` 设置禁用。

**主要捆绑 Skills**：

| Skill | 功能 |
|-------|------|
| `/code-review` | 审阅当前差异以查找正确性错误 |
| `/batch` | 在整个代码库中并行编排大规模更改 |
| `/debug` | 启用调试日志记录并排查问题 |
| `/loop` | 在会话保持打开状态时重复运行提示 |
| `/claude-api` | 为项目语言加载 Claude API 参考资料 |

**运行并验证应用的 Skills**：

| Skill | 功能 |
|-------|------|
| `/run` | 启动并驱动你的应用以查看更改是否有效 |
| `/verify` | 构建并运行你的应用以确认代码更改是否按预期工作 |
| `/run-skill-generator` | 教 `/run` 和 `/verify` 如何构建和启动你的项目 |

## 入门：创建你的第一个 Skill

### 步骤1：创建 skill 目录

在你的个人 skills 文件夹中为 skill 创建一个目录。个人 skills 在你的所有项目中都可用。

```bash
mkdir -p ~/.claude/skills/summarize-changes
```

### 步骤2：编写 SKILL.md

每个 skill 都需要一个 `SKILL.md` 文件，包含两部分：
- YAML frontmatter（在 `---` 标记之间）告诉 Claude 何时使用该 skill
- markdown 内容包含 Claude 在调用该 skill 时遵循的说明

将此保存到 `~/.claude/skills/summarize-changes/SKILL.md`：

```yaml
---
description: Summarizes uncommitted changes and flags anything risky. Use when the user asks what changed, wants a commit message, or asks to review their diff.
---

## Current changes

!`git diff HEAD`

## Instructions

Summarize the changes above in two or three bullet points, then list any risks you notice such as missing error handling, hardcoded values, or tests that need updating. If the diff is empty, say there are no uncommitted changes.
```

**说明**：
- `description`：告诉 Claude 何时使用该 skill
- `` !`git diff HEAD` ``：使用动态上下文注入，在 Claude 看到 skill 内容之前将该行替换为其输出

### 步骤3：测试 skill

打开一个 git 项目，对任何文件进行小的编辑，并通过运行 `claude` 启动 Claude Code。

**让 Claude 自动调用它**：

```text
What did I change?
```

**或直接使用 skill 名称调用它**：

```text
/summarize-changes
```

无论哪种方式，Claude 都应该用你的编辑的简短摘要和风险列表来响应。

## Skills 的位置

你存储 skill 的位置决定了谁可以使用它：

| 位置 | 路径 | 适用于 |
|------|------|--------|
| 企业 | 请参阅托管设置 | 你的组织中的所有用户 |
| 个人 | `~/.claude/skills/<skill-name>/SKILL.md` | 你的所有项目 |
| 项目 | `.claude/skills/<skill-name>/SKILL.md` | 仅此项目 |
| 插件 | `<plugin>/skills/<skill-name>/SKILL.md` | 启用插件的位置 |

**优先级**：当 skills 在各个级别共享相同的名称时，企业覆盖个人，个人覆盖项目。一个任何级别的 skill 也会覆盖具有相同名称的捆绑 skill。

**嵌套 Skills**：Skills 也从你的工作目录下方的嵌套 `.claude/skills/` 目录加载。当 Claude 读取或编辑子目录中的文件时，该子目录的 `.claude/skills/` 中的 skills 变得可用。

**实时变更检测**：Claude Code 监视 skill 目录的文件变更。在 `~/.claude/skills/`、项目 `.claude/skills/` 或 `--add-dir` 目录内的 `.claude/skills/` 中添加、编辑或删除 skill 会在当前会话中生效，无需重新启动。

## SKILL.md 文件格式

### 基本结构

每个 skill 都是一个以 `SKILL.md` 作为入口点的目录：

```text
my-skill/
├── SKILL.md           # 主要说明（必需）
├── template.md        # Claude 要填写的模板
├── examples/
│   └── sample.md      # 显示预期格式的示例输出
└── scripts/
    └── validate.sh    # Claude 可以执行的脚本
```

### Frontmatter 参考

除了 markdown 内容外，你可以使用 `SKILL.md` 文件顶部 `---` 标记之间的 YAML frontmatter 字段来配置 skill 行为：

```yaml
---
name: my-skill
description: What this skill does
disable-model-invocation: true
allowed-tools: Read Grep
---

Your skill instructions here...
```

**所有字段都是可选的**。建议使用 `description`，以便 Claude 知道何时使用该 skill。

| 字段 | 必需 | 描述 |
|------|------|------|
| `name` | 否 | Skill 列表中显示的显示名称。默认为目录名称。 |
| `description` | 推荐 | Skill 的功能以及何时使用它。Claude 使用它来决定何时应用该 skill。 |
| `when_to_use` | 否 | 关于 Claude 何时应该调用该 skill 的额外上下文。 |
| `argument-hint` | 否 | 自动完成期间显示的提示，指示预期的参数。 |
| `arguments` | 否 | 用于 skill 内容中 `$name` 替换的命名位置参数。 |
| `disable-model-invocation` | 否 | 设置为 `true` 以防止 Claude 自动加载此 skill。 |
| `user-invocable` | 否 | 设置为 `false` 以从 `/` 菜单中隐藏。 |
| `allowed-tools` | 否 | 当此 skill 处于活动状态时，Claude 可以使用而无需请求权限的工具。 |
| `disallowed-tools` | 否 | 当此 skill 处于活动状态时从 Claude 的可用工具池中移除的工具。 |
| `model` | 否 | 当此 skill 处于活动状态时要使用的模型。 |
| `effort` | 否 | 当此 skill 处于活动状态时的工作量级别。 |
| `context` | 否 | 设置为 `fork` 以在分叉的 subagent 上下文中运行。 |
| `agent` | 否 | 当设置 `context: fork` 时要使用的 subagent 类型。 |
| `hooks` | 否 | 限定于此 skill 生命周期的 hooks。 |
| `paths` | 否 | Glob 模式，限制何时激活此 skill。 |
| `shell` | 否 | 用于此 skill 中 `` !`command` `` 和 ` ```! ` 块的 shell。 |

### Skill 如何获得其命令名称

你输入的命令来自 skill 文件所在的位置。frontmatter `name` 字段设置在 skill 列表中显示的显示标签。

| Skill 位置 | 命令名称来源 | 示例 |
|------------|-------------|------|
| `~/.claude/skills/` 或 `.claude/skills/` 下的 Skill 目录 | 目录名称 | `.claude/skills/deploy-staging/SKILL.md` → `/deploy-staging` |
| 嵌套 `.claude/skills/` 目录 | 相对于工作目录的子目录路径 | `apps/web/.claude/skills/deploy/SKILL.md` → `/apps/web:deploy` |
| `.claude/commands/` 下的文件 | 文件名称（不含扩展名） | `.claude/commands/deploy.md` → `/deploy` |
| 插件 `skills/` 子目录 | 目录名称，由插件命名空间 | `my-plugin/skills/review/SKILL.md` → `/my-plugin:review` |

### 可用的字符串替换

Skills 支持 skill 内容中动态值的字符串替换：

| 变量 | 描述 |
|------|------|
| `$ARGUMENTS` | 调用 skill 时传递的所有参数。 |
| `$ARGUMENTS[N]` | 按 0 基索引访问特定参数。 |
| `$N` | `$ARGUMENTS[N]` 的简写。 |
| `$name` | 在 `arguments` frontmatter 列表中声明的命名参数。 |
| `${CLAUDE_SESSION_ID}` | 当前会话 ID。 |
| `${CLAUDE_EFFORT}` | 当前工作量级别。 |
| `${CLAUDE_SKILL_DIR}` | 包含 skill 的 `SKILL.md` 文件的目录。 |

**使用替换的示例**：

```yaml
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

## Skill 内容的类型

Skill 文件可以包含任何说明，但思考你想如何调用它们有助于指导要包含的内容：

### 参考内容

添加 Claude 应用于你当前工作的知识。约定、模式、风格指南、领域知识。此内容内联运行，以便 Claude 可以将其与你的对话上下文一起使用。

```yaml
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
- Include request validation
```

### 任务内容

为 Claude 提供特定操作的分步说明，如部署、提交或代码生成。这些通常是你想使用 `/skill-name` 直接调用的操作，而不是让 Claude 决定何时运行它们。

```yaml
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

**建议**：保持主体本身简洁。一旦 skill 加载，其内容在整个会话中保持在上下文中，因此每一行都是一个重复的令牌成本。

## 控制谁调用 Skill

默认情况下，你和 Claude 都可以调用任何 skill。你可以输入 `/skill-name` 直接调用它，Claude 可以在与你的对话相关时自动加载它。

### disable-model-invocation：只有你可以调用

设置为 `true` 以防止 Claude 自动加载此 skill。用于你想使用 `/name` 手动触发的工作流。

```yaml
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:
1. Run the test suite
2. Build the application
3. Push to the deployment target
4. Verify the deployment succeeded
```

### user-invocable：只有 Claude 可以调用

设置为 `false` 以从 `/` 菜单中隐藏。用于用户不应直接调用的背景知识。

```yaml
---
name: legacy-system-context
description: Explains how the legacy system works
user-invocable: false
---

This skill explains the legacy system architecture...
```

### 调用和上下文加载对照表

| Frontmatter | 你可以调用 | Claude 可以调用 | 何时加载到上下文中 |
|-------------|----------|---------------|----------------|
| （默认） | 是 | 是 | 描述始终在上下文中，调用时加载完整 skill |
| `disable-model-invocation: true` | 是 | 否 | 描述不在上下文中，你调用时加载完整 skill |
| `user-invocable: false` | 否 | 是 | 描述始终在上下文中，调用时加载完整 skill |

## 为 Skill 预先批准工具

`allowed-tools` 字段在 skill 处于活动状态时授予对列出的工具的权限，因此 Claude 可以使用它们而无需提示你获得批准。

此 skill 让 Claude 在你调用它时运行 git 命令而无需每次使用批准：

```yaml
---
name: commit
description: Stage and commit the current changes
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

**工具权限语法**：
- `Bash(npm:*)`：允许所有 npm 命令
- `Bash(git:*)`：允许所有 git 命令
- `Read`：读取文件
- `Write`：写入文件
- `Edit`：编辑文件
- `Grep`：搜索内容
- `Glob`：搜索文件

## 将参数传递给 Skills

你和 Claude 都可以在调用 skill 时传递参数。参数可通过 `$ARGUMENTS` 占位符获得。

### 基本参数

此 skill 按编号修复 GitHub 问题：

```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Read the issue description
2. Understand the requirements
3. Implement the fix
4. Write tests
5. Create a commit
```

当你运行 `/fix-issue 123` 时，Claude 收到"Fix GitHub issue 123 following our coding standards..."

### 按位置访问参数

使用 `$ARGUMENTS[N]` 或较短的 `$N`：

```yaml
---
name: migrate-component
description: Migrate a component from one framework to another
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

运行 `/migrate-component SearchBar React Vue` 会将 `$0` 替换为 `SearchBar`，`$1` 替换为 `React`，`$2` 替换为 `Vue`。

### 命名参数

使用 `arguments` frontmatter 列表声明命名参数：

```yaml
---
name: create-issue
description: Create a GitHub issue
arguments: [title, body]
---

Create a GitHub issue with:
- Title: $title
- Body: $body
```

## 添加支持文件

Skills 可以在其目录中包含多个文件。这使 `SKILL.md` 专注于要点，同时让 Claude 仅在需要时访问详细的参考资料。

```text
my-skill/
├── SKILL.md (required - overview and navigation)
├── reference.md (detailed API docs - loaded when needed)
├── examples.md (usage examples - loaded when needed)
└── scripts/
    └── helper.py (utility script - executed, not loaded)
```

从 `SKILL.md` 中引用支持文件，以便 Claude 知道每个文件包含什么以及何时加载它：

```markdown
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

**建议**：将 `SKILL.md` 保持在 500 行以下。将详细的参考资料移到单独的文件中。

## 实战案例1：部署博客 Skill

### 完整的 SKILL.md 示例

```yaml
---
description: "部署博客到远程服务器"
allowed-tools: Bash(npm:*), Bash(git:*), Bash(./gitpush.sh:*), Read
disable-model-invocation: true
---

# 博客部署 Skill

## 步骤
1. 运行 `npm run clean` 清理旧文件
2. 运行 `npm run build` 生成静态文件
3. 运行 `./gitpush.sh "部署说明"` 部署到远程服务器
4. 验证部署是否成功

## 注意事项
- 部署前确保所有更改已提交
- 部署脚本会自动推送到 GitHub 并同步到远程服务器
- 如果部署失败，检查 SSH 密钥是否有效

## 验证方法
- 检查 GitHub 仓库是否有新的提交
- 访问 https://6mal.com 确认部署成功
- 检查远程服务器的文件是否更新
```

### 调用方式

**显式调用**：

```
/deploy
```

**自动识别**：

我说"帮我部署博客"，Claude 会自动识别这个 Skill，然后按照步骤执行。

## 实战案例2：代码审查 Skill

### 完整的 SKILL.md 示例

```yaml
---
description: "审查代码变更，找出潜在问题"
allowed-tools: Bash(git:*), Read, Grep, Glob
---

# 代码审查 Skill

## 步骤
1. 运行 `git diff` 获取变更内容
2. 分析变更，找出潜在问题
3. 生成审查报告

## 审查维度
- 代码质量：命名、格式、注释
- 潜在 Bug：逻辑错误、边界条件
- 安全问题：注入、认证、数据泄露
- 性能问题：算法复杂度、资源消耗

## 输出格式
### 问题列表
- [ ] 问题1：xxx
- [ ] 问题2：xxx

### 建议
- 建议1：xxx
- 建议2：xxx
```

## 实战案例3：数据库迁移 Skill

### 完整的 SKILL.md 示例

```yaml
---
description: "执行数据库迁移"
allowed-tools: Bash(npm:*), Bash(npx:*), Read, Write
disable-model-invocation: true
---

# 数据库迁移 Skill

## 步骤
1. 检查当前数据库版本
2. 生成迁移文件
3. 执行迁移
4. 验证迁移结果

## 注意事项
- 迁移前备份数据库
- 迁移失败时回滚
- 验证数据完整性

## 常用命令
```bash
# 检查当前版本
npx prisma migrate status

# 生成迁移文件
npx prisma migrate dev --name xxx

# 执行迁移
npx prisma migrate deploy

# 回滚迁移
npx prisma migrate resolve --rolled-back xxx
```
```

## 高级模式：注入动态上下文

`` !`<command>` `` 语法在将 skill 内容发送给 Claude 之前运行 shell 命令。命令输出替换占位符，因此 Claude 接收实际数据，而不是命令本身。

此 skill 通过使用 GitHub CLI 获取实时 PR 数据来总结拉取请求：

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

当此 skill 运行时：
1. 每个 `` !`<command>` `` 立即执行（在 Claude 看到任何内容之前）
2. 输出替换 skill 内容中的占位符
3. Claude 接收带有实际 PR 数据的完全呈现的提示

**多行命令**：使用以 ` ```! ` 开头的围栏代码块：

```markdown
## Environment
```!
node --version
npm --version
git status --short
```
```

## 高级模式：在 Subagent 中运行 Skills

当你想让 skill 在隔离中运行时，在你的 frontmatter 中添加 `context: fork`。skill 内容变成驱动 subagent 的提示。它将无法访问你的对话历史。

### 示例：使用 Explore 代理的研究 skill

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

当此 skill 运行时：
1. 创建一个新的隔离上下文
2. Subagent 接收 skill 内容作为其提示
3. `agent` 字段确定执行环境（模型、工具和权限）
4. 结果被总结并返回到你的主对话

**`agent` 字段选项**：
- `Explore`：针对代码库探索优化的只读工具
- `Plan`：规划实现方案
- `general-purpose`：通用代理
- 自定义 subagent：来自 `.claude/agents/` 的任何自定义 subagent

## 共享 Skills

Skills 可以根据你的受众在不同范围内分发：

### 项目 Skills

将 `.claude/skills/` 提交到版本控制：

```bash
git add .claude/skills/
git commit -m "feat: add deploy skill"
```

### 插件

在你的插件中创建 `skills/` 目录。

### 托管

通过托管设置部署组织范围内。

## 故障排除

### Skill 未触发

如果 Claude 在预期时不使用你的 skill：

1. 检查描述是否包含用户会自然说的关键字
2. 验证 skill 是否出现在 `What skills are available?` 中
3. 尝试重新表述你的请求以更接近描述
4. 如果 skill 是用户可调用的，使用 `/skill-name` 直接调用它

### Skill 触发过于频繁

如果 Claude 在你不想要时使用你的 skill：

1. 使描述更具体
2. 如果你只想手动调用，添加 `disable-model-invocation: true`

### Skill 描述被截断

Skill 描述被加载到上下文中，以便 Claude 知道什么可用。所有 skill 名称始终包括，但如果你有许多 skills，描述会被缩短以适应字符预算。

**解决方案**：
- 运行 `/doctor` 以查看有多少 skill 描述被缩短或删除
- 设置 `skillListingBudgetFraction` 设置以提高预算
- 在 `skillOverrides` 中将低优先级条目设置为 `"name-only"`
- 修剪 `description` 和 `when_to_use` 文本

## Skills vs Slash Commands

| 特性 | Slash Commands | Skills |
|------|---------------|--------|
| 文件位置 | `.claude/commands/name.md` | `.claude/skills/name/SKILL.md` |
| 调用方式 | `/name` 手动调用 | 自动或 `/name` |
| 支持文件 | 单文件 | 可包含目录 |
| 上下文加载 | 调用时加载 | 描述始终可见，内容按需 |

**使用场景区别**：
- **Slash Commands**：简单的、单文件的命令
- **Skills**：复杂的、多文件的工作流

**我的建议**：
- 简单的命令用 Slash Commands
- 复杂的工作流用 Skills

## 我的 Skills 使用习惯

经过一个月的使用，我形成了自己的 Skills 习惯：

**1. 常用 Skills**

- `deploy-blog`：部署博客
- `code-review`：代码审查
- `db-migrate`：数据库迁移
- `run-tests`：运行测试

**2. Skills 管理**

- 把 Skills 放在项目仓库中
- 团队共享同一套 Skills
- 定期更新和维护

**3. Skills 创建**

- 重复性的任务做成 Skills
- 复杂的工作流做成 Skills
- 团队规范做成 Skills

**4. Skills 调用**

- 简单任务：直接描述
- 复杂任务：显式调用 `/skill-name`
- 自动识别：Claude 根据上下文自动调用

## 下一篇预告

这篇讲了 Skills 技能包。下一篇文章，我会详细介绍 Claude Code 的 MCP 外部工具集成——这些 MCP 能让 Claude 连接外部世界。

---

**相关推荐：**
- [Claude Code 入门：从安装到模型配置，以 DeepSeek 为例](/archives/0110/)
- [Claude Code 快捷键：这 15 个键让我效率翻倍](/archives/0111/)
- [Claude Code 命令大全：这 20 个命令你必须掌握](/archives/0112/)
- [Claude Code 配置：CLAUDE.md 与上下文管理的艺术](/archives/0113/)
- [Claude Code MCP：连接外部世界的桥梁](/archives/0115/)（即将发布）

**P.S.** Skills 这个功能，真的改变了我对 AI 编程的认知。以前我觉得 AI 只能帮我写写代码，现在它能帮我执行整个工作流程。如果你有重复性的任务，一定要做成 Skills！
