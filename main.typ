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


== Slide Title
Typstによるスライドのテンプレートを作成した.@madje2022programmable
#speaker-note[
  + This is a speaker note.
  + You won't see it unless you use `config-common(show-notes-on-second-screen: right)`
]
#focus-slide[
  これはフォーカススライド
]


== 最後に

#slide(self => [
  #align(center + horizon)[
    #set text(size: 3em, weight: "bold", fill: self.colors.primary)
    THANKS FOR ALL
  ]
])

