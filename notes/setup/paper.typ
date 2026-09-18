// 论文笔记库：bib 加载 + 通用字段 / 引用函数 + overview schema。
// 每个 main/{key}.typ 导入本文件后调用 overview(...)，再补 论文泛读 / 论文精读。

#import "@preview/citegeist:0.3.1": load-bibliography

#let bib-path = "../refs/tasks from mt.bib"
#let bib = load-bibliography(read(bib-path), source: bib-path)

// ---------- 通用字段 / 引用 ----------

#let field(e, name, default: "") = e.fields.at(name, default: default)

#let author-names(e) = {
  let names = e.parsed_names.at("author", default: ())
  names.map(n => {
    let given = n.at("given", default: "")
    let family = n.at("family", default: "")
    if given == "" { family } else { given + " " + family }
  })
}

#let source(e) = (
  article: field(e, "journal"),
  inproceedings: field(e, "booktitle"),
  incollection: field(e, "booktitle"),
  book: field(e, "publisher", default: field(e, "title")),
  phdthesis: field(e, "school", default: field(e, "institution")),
  mastersthesis: field(e, "school", default: field(e, "institution")),
  misc: field(e, "eprint", default: field(e, "title")),
).at(e.entry_type, default: field(e, "title"))

#let inline-citation(key, bib-path, csl-path: "./inline-ieee.csl") = [
  #show bibliography: none
  #cite(key, form: "full")
  #bibliography(bib-path, style: csl-path)
]

// ---------- schema ----------

// 论文标题 + 论文概述。
//   key:         bib 引用键。title / 作者 / 来源 / 引用格式 均自动从 bib 派生。
//   institution: 机构。读 PDF 作者单位确定；无法确认时填 "未知"。
//   category:    分类。推断；无法确认时填 "未知"。
//   repo:        自带项目 / 开源链接。读 PDF 确认存在才填，否则不传。

#let title(key) = field(bib.at(key), "title")

#let overview(
  key,
  institution: "未知",
  category: "未知",
  repo: none,
) = {
  let e = bib.at(key)
  let title = title(key)
  [
    论文：#title \
    作者：#author-names(e).join(", ")\
    机构：#institution \
    分类：#category \
    来源：#source(e) \
    引用格式：#inline-citation(label(key), bib-path)
    #if repo != none [ \ 开源：#repo ]

  ]
}


