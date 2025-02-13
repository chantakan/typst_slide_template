#import "src/tompython-theme.typ": *

//言語設定
#set text(lang: "ja")

#show: tompython-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Typstによる\ スライドのテンプレート],
    subtitle: [Subtitle],
    author: [Tom Python],
    date: datetime.today(),
    institution: [Institution],
  ),
  bibliography-file: "ref.bib",
)



#title-slide()

#outline-slide()

= 始めに


== 始めに
#link("https://github.com/touying-typ/touying")[Touying]を参考にしてTypstによるスライドのテンプレートを作成した.@madje2022programmable
#speaker-note[
  + This is a speaker note.
  + You won't see it unless you use `config-common(show-notes-on-second-screen: right)`
]

#focus-slide[
  ```typst
  #focus-slide[
  これはフォーカススライド
]
  ```
]

= 使い方

== theoremの定義

#slide[

 _theorem environment_を定義したい場合は, #link("https://typst.app/universe/package/ctheorems/")[`ctheorem`]の`thmbox`関数を使うことができる.
 
まず, `main.typ`上部に
```typst
#show: thmrules
```
#show: thmrules

と書いて, 以下のように定義する.
```typst
#let theorem = thmbox(
  "theorem",              // identifier
  base_level: 1
  "Theorem",              // head
  fill: rgb("#e8e8f8")
)
```

#let theorem = thmbox(
  "theorem",
  "Theorem",
  base_level: 1,
  fill: rgb("#e8e8f8")
).with(numbering: "1.1")

#pagebreak()

そして, 定義したものを以下のように使うことができる.
```typst
#theorem("Euler")[
  $ e^(i pi) = -1 $
] <euler>
```

これは次のように表示される.
#theorem("Euler")[
  $ e^(i pi) = -1 $
] <euler>

]

== 図式の利用

#slide[
  #link("https://github.com/cetz-package/cetz")[`CeTz`]や#link("https://typst.app/universe/package/fletcher/")[`Fletcher`]を利用することで図式を描画することができる.

  ```typst
  #cetz.canvas({
    import cetz.draw: *
    
  circle((0, 0), fill: red, stroke: blue)


  line((0, 0), (1, 1), stroke: green)
  })
  ```

  #cetz.canvas({
    import cetz.draw: *
    
  circle((0, 0), fill: red, stroke: blue)


  line((0, 0), (1, 1), stroke: green)
  })

  #pagebreak()

  ```typst
  #diagram(
	spacing: (1em, 3em),
	$ & tau^* (bold(A B)^n R slash.double R^times) edge(->) & bold(B)^n R slash.double R^times \ X edge("ur", "-->") edge("=") & X edge(->, tau) edge("u", <-) & bold(B) R^times edge("u", <-) $, edge((2,1), "d,ll,u", "->>", text(blue, $Gamma^*_R$), stroke: blue, label-side: center)
  )
  ```
  #diagram(
	spacing: (1em, 3em),
	$ & tau^* (bold(A B)^n R slash.double R^times) edge(->) & bold(B)^n R slash.double R^times \
		X edge("ur", "-->") edge("=") & X edge(->, tau) edge("u", <-) & bold(B) R^times edge("u", <-) $,
	edge((2,1), "d,ll,u", "->>", text(blue, $Gamma^*_R$), stroke: blue, label-side: center)
)
  ]

== 最後に

#slide(self => [
  #align(center + horizon)[
    #set text(size: 3em, weight: "bold", fill: self.colors.primary)
    THANKS FOR ALL
  ]
])

