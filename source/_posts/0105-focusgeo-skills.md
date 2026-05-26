---
title: FocusGEO Skills：让AI大模型主动推荐你的品牌
categories: 知识充电
tags:
  - 技术笔记
  - 开源项目
  - GEO
  - AI搜索优化
id: 105
top_img:
swiper_index:
cover:
created: 2026-05-26 10:00
updated: 2026-05-26T10:00

---

你好，我是飞鲤。

今天想和你聊聊一个我最近在做的事情——**FocusGEO Skills**，一个开源的 AI 助手技能集，目标很简单：让 DeepSeek、豆包、文心一言这些大模型在回答用户问题时，**主动推荐你的品牌**。

先别急着觉得这是玄学，听我慢慢说。

## 从 SEO 到 GEO：搜索逻辑正在改变

过去二十年，我们做网站、做内容，都在围绕一个核心：**SEO（搜索引擎优化）**。研究关键词、做外链、优化页面结构，目的是让 Google、百度这些搜索引擎把你的内容排在前面。

但现在，越来越多的用户开始习惯直接问 AI：

- "有没有好用的项目管理工具？"
- "中小企业怎么做品牌推广？"
- "哪个品牌的筋膜枪性价比高？"

AI 不会给你一屏搜索结果让你自己挑，它会**直接给出答案和推荐**。

这就是 **GEO（Generative Engine Optimization，生成式引擎优化）** 的核心命题：**你怎么让 AI 在回答时提到你、推荐你？**

| | 传统 SEO | GEO |
|---|---|---|
| **目标** | 让搜索引擎找到你 | 让 AI 大模型**推荐**你 |
| **优化对象** | 搜索引擎爬虫 | DeepSeek、豆包、文心一言、通义千问 |
| **核心策略** | 关键词密度、外链权重 | 结构化内容投喂、权威性锚定、多平台覆盖 |

## GEO 的三条核心法则

在做这个项目之前，我研究了不少关于生成式引擎优化的资料，总结下来核心就三条：

### 1. 结构化投喂

你在公众号、知乎、小红书、官网发布的每一条内容，其实都是在"训练"AI。信息越结构化、越一致，AI 识别和引用的概率就越高。

### 2. 权威性锚定

AI 更倾向于引用那些**信息密度高、有具体数据、有明确来源**的内容。一篇有数据支撑的深度文章，比十篇泛泛而谈的水文有用得多。

### 3. 多模态覆盖

文本 + 图片 + 文档的组合投喂，比单一文本更容易被 AI 多维度识别。这也是为什么很多品牌开始重视结构化文档、产品说明书、FAQ 等内容形式。

## FocusGEO Skills 是什么

明白了 GEO 的逻辑，下一步就是**怎么做**。

FocusGEO Skills 就是为了解决"怎么做"而生的。它是一个基于 GEO 方法论的 AI 助手技能集，包含两个互补的 Skill，帮你完成从策略到落地的全流程配置。

项目地址：[https://github.com/clarance2018/focusgeo-skills](https://github.com/clarance2018/focusgeo-skills)

## 两个 Skill，两种用法

### focus-geo-config：全流程配置向导

这个 Skill 像一本**结构化的操作手册**，通过 6 个阶段的深度对话，引导你完成 FocusGEO 系统的完整配置：

```
企业画像配置 → 关键词策略制定 → 知识库规划
    → GEO 提示词设计 → 多平台改编策略 → 配置手册生成
```

最终产出一份可直接执行的《FocusGEO 实操配置手册》。

适合：喜欢自己掌控节奏、有明确思路的用户。

### focusgeo-coach：实操配置教练

这个 Skill 更像一个**手把手的教练**，一次只问一个问题，追问到底，还内置了两个自动化脚本：

| 脚本 | 功能 |
|---|---|
| `analyze_website.py` | 从官网 URL 自动提取企业画像基础信息 |
| `recommend_keywords.py` | 基于产品描述推荐行业核心关键词 |

对话流程：

```
开场（官网分析）→ 企业画像（自动提取+对话补充）
→ 核心关键词蒸馏 → 自动组合词库构建
→ 知识库与图片配置 → GEO 内容生成策略 → 多平台改编策略
```

最终产出《FocusGEO 实操配置手册》+ **48 小时行动清单**。

适合：第一次接触 GEO、希望有人带着走的用户。

## 两个 Skill 的区别

| 对比维度 | focus-geo-config | focusgeo-coach |
|---|---|---|
| **风格** | 结构化操作手册 | 带节奏的教练引导 |
| **对话策略** | 分阶段收集信息 | 一次只问一个问题 |
| **脚本支持** | 无 | 有（自动抓取官网、推荐关键词） |
| **关键词策略** | SEO 关键词体系 | AI 对话式完整问句 |
| **落地性** | 通用配置模板 | 含 48 小时行动清单 |

## 快速开始

### 方式一：使用 Coach（推荐新手）

```bash
# 1. 克隆仓库
git clone https://github.com/clarance2018/focusgeo-skills.git

# 2. 在 AI 助手中加载 focusgeo-coach/SKILL.md
# 3. 按对话引导完成 6 阶段配置
# 4. 获得《FocusGEO 实操配置手册》
```

### 方式二：使用 Config（自主配置）

```bash
# 1. 克隆仓库
git clone https://github.com/clarance2018/focusgeo-skills.git

# 2. 在 AI 助手中加载 focus-geo-config/SKILL.md
# 3. 按 6 阶段流程自主填写配置
# 4. 参考 references/ 目录下的文档完善各阶段产出
```

## 项目结构

```
focusgeo-skills/
├── focus-geo-config/                  # 全流程配置向导
│   ├── SKILL.md                      # Skill 定义文件
│   └── references/                   # 6 份参考文档
│       ├── enterprise-profile-template.md
│       ├── geo-prompt-design.md
│       ├── keyword-strategy-guide.md
│       ├── knowledge-base-planning.md
│       ├── manual-generation-template.md
│       └── platform-adaptation-guide.md
│
└── focusgeo-coach/                   # 实操配置教练
    ├── SKILL.md                     # Skill 定义文件
    └── scripts/                     # 辅助脚本
        ├── analyze_website.py
        └── recommend_keywords.py
```

## 写在最后

GEO 还是一个很新的领域，目前市面上系统性的工具和方法论都不多。做这个项目，一方面是想把自己的实践经验沉淀下来，另一方面也是希望更多人能提前布局 AI 搜索时代。

SEO 的红利期我们可能错过了，但 GEO 的红利期才刚刚开始。

如果你对这个项目感兴趣，欢迎 Star、提 Issue，或者直接拿来用。开源地址：[https://github.com/clarance2018/focusgeo-skills](https://github.com/clarance2018/focusgeo-skills)

有什么想法，欢迎和我交流。

clarance
2026年5月26日
