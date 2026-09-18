#import "@preview/ctheorems:1.1.3": *

#let tfont = (
  "New Computer Modern Math",
  (name: "New Computer Modern", covers: "latin-in-cjk"),
  "Adobe Kaiti Std R",
)

#let thm-name-fmt = name => [
  #text(font: tfont, rgb("#e60012"))[#h(0.1em) #name #h(-0.2em)]
]

#let thmbox = thmbox.with(
  namefmt: thm-name-fmt,
  base_level: 1,
  // titlefmt: t => text(size: 0.98em)[#strong[#t]],
  inset: 0em,
)

#let thmplain = thmplain.with(
  breakable: false,
  namefmt: thm-name-fmt,
  // titlefmt: t => text(size: 0.98em)[#emph[#t]],
  base_level: 1,
  inset: 0em,
)

#let annotation = thmplain(
  "annotation",
  "Annotation",
)

#let proposition = thmbox(
  "proposition",
  "Proposition",
)

#let definition = thmbox(
  "definition", // Definitions use their own counter
  "Definition",
)

#let theorem = thmbox(
  "theorem",
  "Theorem",
)

#let proof = thmproof(
  "proof",
  "Proof",
  titlefmt: t => text(size: 0.95em)[#emph[#t]],
  // inset: (left: 1em, right: 1em),
  base: "theorem",
)

#let lemma = thmbox(
  "theorem", // Lemmas use the same counter as Theorems
  "Lemma",
)

#let corollary = thmbox(
  "corollary",
  "Corollary",
  // base: "theorem", // Corollaries are 'attached' to Theorems
)

#let example = thmbox(
  "example",
  "Example",
  inset: 0em,
)

#let properties = thmplain(
  "properties",
  "Properties",
).with(numbering: none)

#let remark = thmplain(
  "remark",
  "Remark",
  inset: 0em,
).with(numbering: none)

#let exercise = thmbox(
  "exercise",
  "Exercise",
  inset: 1em,
  stroke: rgb("#ffaaaa") + 1pt,
  base: none, // Unattached: count globally
).with(numbering: "I") // Use Roman numerals

#let solution = thmplain(
  "solution",
  "Solution",
  base: "exercise",
  inset: 0em,
).with(numbering: none)
