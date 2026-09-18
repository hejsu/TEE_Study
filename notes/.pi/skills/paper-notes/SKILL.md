---
name: paper-notes
description: 在当前项目自主维护与同步 Typst 论文笔记。比对 BibTeX 元数据、解析 PDF 补充机构、分类及开源项目，生成基于 setup/paper.typ 的 schema 笔记并执行 make 编译校验。当需要新增论文笔记、同步 BibTeX 或整理文献时使用。
---

# 论文笔记维护技能

帮我在当前目录下维护论文笔记。请按顺序自主执行，遇到无法解决的阻塞时再询问。

## 数据源

1. `refs/tasks from mt.bib`（在仓库根目录下为 `refs/tasks from mt.bib`，在外层父目录下为 `notes/refs/tasks from mt.bib`）是唯一的论文书目元数据来源。
2. BibTeX 中已有的通用字段通过 `setup/paper.typ` 自动解析，包括标题、作者、发表来源（期刊 / 会议 / 出版社等）以及 IEEE 格式行内引用。
3. 补充字段（机构、分类、开源代码等）由 `setup/paper.typ` 提供的 `overview` schema 函数以参数形式在单篇笔记中维护。
4. 如需确认论文内容或提取机构、分类、开源项目等信息，读取 BibTeX 的 `file` 字段指向的 PDF。PDF 无法读取时记录错误；无法确认的内容标记为 `未知`，并在最终报告中说明。

## Schema 与模板规范

论文笔记概述部分已实现 Schema 化，由 `setup/paper.typ` 统一管理。单篇笔记文件保存在 `main/{key}.typ`，标准模板如下：

```typst
#import "../setup/paper.typ": *
#import "../setup/conf.typ": *

#show: project

= #title("<key>")

== 论文概述
#overview(
  "<key>",
  institution: "<机构>",
  category: "<分类>",
  // repo: "<开源项目链接>", // 选填：读 PDF 确认存在时填入，无则不传
)

== 论文泛读

== 论文精读
```

### Schema 字段说明

- 一级标题必须为 `= #title("<key>")`，由 `paper.typ` 动态根据 key 从 BibTeX 读取标题。
- `overview` 函数参数：
  - `key`（位置参数，字符串）：论文的 BibTeX key，必须与 BibTeX entry key 严格一致。
  - `institution`（命名参数，默认 `"未知"`）：作者机构。根据 PDF 首页作者单位核对；多所机构使用分号（`;`）分隔；无法确认填 `"未知"`。
  - `category`（命名参数，默认 `"未知"`）：论文分类或研究方向（例如 `"机密计算 / Intel TDX 架构"`、`"可信执行环境（TEE）设计 / SoK"`）。根据论文主题推断；无法确认填 `"未知"`。
  - `repo`（可选命名参数，默认 `none`）：开源项目 / 仓库链接。读 PDF 确认存在开源项目时才传入，不存在则省略不传。
- 自动提取字段：论文标题（`title`）、作者列表（`author-names`）、来源期刊/会议（`source`）、行内引用（`inline-citation`）均由 `overview` 自动从 BibTeX 派生展示，无需手动编写。

## 执行流程与报告

1. **检查 key 同步状态**：读取 BibTeX 文件，获取所有 entry key，比对 `main/` 目录下是否已存在 `{key}.typ`。
2. **读取 PDF 提取元数据**：对缺失笔记或信息待补充的论文，从 BibTeX 的 `file` 字段读取 PDF，提取作者机构（`institution`）、分类（`category`）以及开源项目链接（`repo`）。
3. **新建笔记文件**：在 `main/{key}.typ` 创建笔记，严格遵循上述模板规范调用 `#title(...)` 和 `#overview(...)`，并保留泛读与精读章节。
4. **汇入汇总文档**：检查 `main/main.typ`，在对应的主题章节下通过 `#include "{key}.typ"` 引入新笔记。
5. **编译验证**：在 `notes/` 目录下执行 `make` 编译（或通过 Typst 编译），确保无语法报错或引用缺失。
6. **输出报告**：执行完毕后给出简短报告，涵盖：
   - 新增或更新了哪些论文笔记（key）
   - 哪些字段自动来自 BibTeX（标题、作者、来源等）
   - 哪些字段通过 PDF 确定或推断（机构、分类、repo）
   - 是否存在 PDF 无法读取、缺少字段或标记为“未知”的项
   - Typst 编译结果状态
