#import "exports.typ": *

/// Default slide function for the presentation.
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more configurations, you can use `utils.merge-dicts` to merge them.
///
/// - repeat (int, auto): The number of subslides. Default is `auto`, which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
///
/// - setting (function): The setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - composer (function, array): The composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (content): The contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    place(center + top, dy: 0em,
      rect(
        width: 100%,
        height: 1.8em,
        fill: self.colors.primary,
        align(left + horizon, h(1.5em) + text(fill:white, utils.call-or-display(self, self.store.header)))
      )
    )
  }
  let footer(self) = {
    
    set align(bottom)
    set text(size: 0.8em)
    pad(1.0em, {
      place(left, block(text(fill: self.colors.primary.lighten(20%), utils.call-or-display(self, self.store.footer-left))))
      place(right, block(text(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-right))))
    })
    if self.store.footer-progress {
      place(bottom, block(height: 7pt, width: 100%, spacing: 0pt, utils.call-or-display(self, self.store.footer-progress-bar)))
    }
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: tompython-theme.with(
///   config-info(
///     title: [Title],
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle], extra: [Extra information])
/// ```
/// 
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more configurations, you can use `utils.merge-dicts` to merge them.
/// ```
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(
      background: utils.call-or-display(self, self.store.background),
      margin: (x: 0em, top: 30%, bottom: 0%),
    ),
  )
  let info = self.info + args.named()
  let body = {
    set align(center)
    stack(
      spacing: 3em,
      if info.title != none {
        text(size: 48pt, weight: "bold", fill: self.colors.primary, info.title)
      },
      if info.author != none {
        text(fill: self.colors.primary-light, size: 28pt, weight: "regular", info.author)
      },
      if info.date != none {
        text(
          fill: self.colors.primary-light,
          size: 20pt,
          weight: "regular",
          utils.display-info-date(self),
        )
      },
    )
  }
  touying-slide(self: self, body)
})


/// Outline slide for the presentation.
/// 
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more configurations, you can use `utils.merge-dicts` to merge them.
///
/// - leading (length): The leading of paragraphs in the outline. Default is `50pt`.
#let outline-slide(config: (:), leading: 50pt) = touying-slide-wrapper(self => {
  set text(size: 30pt, fill: self.colors.primary)
  set par(leading: leading)

  let body = {
    grid(
      columns: (1fr, 1fr),
      rows: (1fr),
      align(
        center + horizon,
        {
          set par(leading: 20pt)
          context {
            if text.lang == "zh" {
              text(
                size: 80pt,
                weight: "bold",
                [#text(size:36pt)[CONTENTS]\ 目录],
              )
            } else if text.lang == "ja" {
              text(
                size: 48pt, 
                weight: "bold",
                [#text(size:36pt)[CONTENTS]\ 目次]
              )
            } else  {
              text(
                size: 48pt, 
                weight: "bold",
                [CONTENTS]
              )
            }
          }
        },
      ),
      align(
        left + horizon,
        {
          set par(leading: leading)
          set text(weight: "bold")
          components.custom-progressive-outline(
            level: none,
            depth: 1,
            numbered: (true,),
          )
        },
      ),
    )
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      background: utils.call-or-display(self, self.store.background),
      margin: 0em,
    ),
  )
  touying-slide(self: self, config: config, body)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more configurations, you can use `utils.merge-dicts` to merge them.
/// 
/// - level (int): The level of the heading.
///
/// - body (content): The body of the section. It will be passed by touying automatically.
#let new-section-slide(config: (:), level: 1, body) = touying-slide-wrapper(self => {
  let slide-body = {
    stack(
      dir: ttb,
      spacing: 12%,
      align(
        center,
        text(
          fill: self.colors.primary,
          size: 166pt,
          utils.display-current-heading-number(level: level),
        ),
      ),
      align(
        center,
        text(
          fill: self.colors.primary,
          size: 60pt,
          weight: "bold",
          utils.display-current-heading(level: level, numbered: false),
        ),
      ),
    )
    body
  }
  self = utils.merge-dicts(
    self,
    config-page(
      margin: (left: 0%, right: 0%, top: 20%, bottom: 0%),
      background: utils.call-or-display(self, self.store.background),
    ),
  )
  touying-slide(self: self, config: config, slide-body)
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
/// 
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more configurations, you can use `utils.merge-dicts` to merge them.
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: self.colors.primary, margin: 2em),
  )
  set text(fill: self.colors.neutral-lightest, size: 2em, weight: "bold")
  touying-slide(self: self, config: config, align(horizon + center, body))
})


/// Touying tompython theme.
///
/// Example:
///
/// ```typst
/// #show: tompython-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// Consider using:
///
/// ```typst
/// #set text(font: "Fira Sans", weight: "light", size: 20pt)`
/// #show math.equation: set text(font: "Fira Math")
/// #set strong(delta: 100)
/// #set par(justify: true)
/// ```
///
/// The default colors:
///
/// ```typst
/// config-colors(
///   primary: rgb("#003F88"),
///   primary-light: rgb("#2159A5"),
///   primary-lightest: rgb("#F2F4F8"),
///   neutral-lightest: rgb("#FFFFFF")
/// )
/// ```
///
/// - aspect-ratio (ratio): The aspect ratio of the slides. Default is `16-9`.
///
/// - header (content): The header of the slides. Default is `self => utils.display-current-heading(depth: self.slide-level)`.
///
/// - footer (content): The footer of the slides. Default is `context utils.slide-counter.display()`.
#let tompython-theme(
  aspect-ratio: "16-9",
  header: self => utils.display-current-heading(depth: self.slide-level ),
  footer: context utils.slide-counter.display(),
  footer-left: self => utils.display-current-heading(depth: 1 ),
  footer-right: context utils.slide-counter.display() + " / " + context utils.last-slide-number,
  footer-progress: true,
  ..args,
  body,
  bibliography-file: none,
) = {
  // 言語設定を最初に行う
  set text(size: 20pt)
  set heading(numbering: "1.1.1")
  // show heading.where(level: 1): set heading(numbering: "01")

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (x: 2em, top: 3.5em, bottom: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        show heading: set text(fill: self.colors.primary-light)

        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb("#3e3e3e"),
      primary-light: rgb("#2d3642"),
      primary-lightest: rgb("#F2F4F8"),
      neutral-lightest: rgb("#FFFFFF")
    ),
    // save the variables for later use
    config-store(
      align: align,
      header: header,
      footer-left: footer-left,
      footer-right: footer-right,
      footer-progress: footer-progress,
      footer-progress-bar: self => utils.touying-progress(ratio => {
    grid(
      columns: (ratio * 100%, 1fr),
      components.cell(fill: self.colors.primary-light),
      components.cell(fill: self.colors.primary-lightest)
    )
  }),
      background: self => {
        // the customed background
        let page-width = if self.page.paper == "presentation-16-9" { 841.89pt } else { 793.7pt }
        let r = if self.at("show-notes-on-second-screen", default: none) == none { 1.0 } else { 0.5 }
        let bias1 = - page-width * (1-r)
        let bias2 = - page-width * 2 * (1-r)
        let w_emu = 121920
        let h_emu = 68580
        place(left + top, dx: -15pt, dy: -26pt,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 5))
        place(left + top, dx: 65pt, dy: 12pt,
          polygon.regular(fill: self.colors.primary,size: 37pt, vertices: 3))
        place(left + top, dx: r * 3%, dy: 15%,
          polygon.regular(fill: self.colors.primary,size: 40pt, vertices: 4))
        place(left + top, dx: r * 2.5%, dy: 27%,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 5))
        place(left + top, dx: r * 7.5%, dy: 14%,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 7))
        place(left + top, dx: r * 12%, dy: 2%,
          polygon.regular(fill: self.colors.primary,size: 50pt, vertices: 5))
        place(left + top, dx: r * 18%, dy: -5%,
          polygon.regular(fill: self.colors.primary,size: 50pt, vertices: 6))
        place(left + top, dx: r * 0%, dy: 45%,
          polygon.regular(fill: self.colors.primary,size: 40pt, vertices: 5))
        place(right + bottom, dx: 15pt, dy: 26pt,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 5))
        place(right + bottom, dx: -65pt, dy: -12pt,
          polygon.regular(fill: self.colors.primary,size: 37pt, vertices: 3))
        place(right + bottom, dx: r * -3%, dy: -15%,
          polygon.regular(fill: self.colors.primary,size: 40pt, vertices: 4))
        place(right + bottom, dx: r * -2.5%, dy: -27%,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 5))
        place(right + bottom, dx: r * -7.5%, dy: -14%,
          polygon.regular(fill: self.colors.primary,size: 70pt, vertices: 7))
        place(right + bottom, dx: r * -12%, dy: -2%,
          polygon.regular(fill: self.colors.primary,size: 50pt, vertices: 5))
        place(right + bottom, dx: r * -18%, dy: 5%,
          polygon.regular(fill: self.colors.primary,size: 50pt, vertices: 6))
        place(right + bottom, dx: r * 0%, dy: -45%,
          polygon.regular(fill: self.colors.primary,size: 40pt, vertices: 5))
        place(dx: bias1 + 6951150%/w_emu, dy: 2563256%/h_emu, 
          rect(width: 670302%/w_emu, height: 2751112%/h_emu, fill: self.colors.primary-lightest))  
        place(dx: bias1 + 6835273%/w_emu, dy: 3209962%/h_emu,
          ellipse(fill: white, width: 175511%/w_emu, height: 1080034%/h_emu))
        place(dx: bias1 + 6884301%/w_emu, dy: 4258785%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 186269%/w_emu, height: 953067%/h_emu))
        place(dx: bias1 + 7505575%/w_emu, dy: 3237315%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 7459873%/w_emu, dy: 4143606%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 3208188%/w_emu, dy: 2285319%/h_emu,
          ellipse(fill: white, width: 1823877%/w_emu, height: 1151482%/h_emu))
        place(dx: bias1 + 2855659%/w_emu, dy: 2239321%/h_emu,
          ellipse(fill: white, width: 1506103%/w_emu, height: 1528220%/h_emu))
        place(dx: bias1 + 2683281%/w_emu, dy: 2058645%/h_emu,
          ellipse(fill: white, width: 1823877%/w_emu, height: 1151482%/h_emu))
        place(dx: bias1 + 2330752%/w_emu, dy: 2012647%/h_emu,
          ellipse(fill: white, width: 1506103%/w_emu, height: 1528220%/h_emu))
        place(dx: bias1 + 2547119%/w_emu, dy: 2238110%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1165230%/w_emu, height: 802416%/h_emu))
        place(dx: bias1 + 2547119%/w_emu, dy: 2058645%/h_emu,
          ellipse(fill: white, width: 1165230%/w_emu, height: 802416%/h_emu))
        place(dx: bias1 + 2547119%/w_emu, dy: 1920196%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1165230%/w_emu, height: 802416%/h_emu))
        place(dx: bias1 + 2547119%/w_emu, dy: 1740730%/h_emu,
          ellipse(fill: white, width: 1165230%/w_emu, height: 802416%/h_emu))
        place(dx: bias1 + 3265910%/w_emu, dy: 1237094%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1823877%/w_emu, height: 1151482%/h_emu))
        place(dx: bias1 + 4102646%/w_emu, dy: 1002535%/h_emu,
          ellipse(fill: white, width: 1506103%/w_emu, height: 1528220%/h_emu))
        place(dx: bias1 + 2771024%/w_emu, dy: 2174625%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1411988%/w_emu, height: 2182648%/h_emu))
        place(dx: bias1 + 3181102%/w_emu, dy: 2317481%/h_emu,
          ellipse(fill: white, width: 1062495%/w_emu, height: 1748171%/h_emu))
        place(dx: bias1 + 3790817%/w_emu, dy: 1463768%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1823877%/w_emu, height: 1151482%/h_emu))
        place(dx: bias1 + 4627553%/w_emu, dy: 1229209%/h_emu,
          ellipse(fill: white, width: 1506103%/w_emu, height: 1528220%/h_emu))
        place(dx: bias1 + 2960749%/w_emu, dy: 2006164%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1446168%/w_emu, height: 1305922%/h_emu))
        place(dx: bias1 + 4229424%/w_emu, dy: 2478926%/h_emu, 
          rect(width: 670302%/w_emu, height: 2751112%/h_emu, fill: self.colors.primary-lightest))
        place(dx: bias1 + 5068035%/w_emu, dy: 2743758%/h_emu, 
          rect(width: 670302%/w_emu, height: 2751112%/h_emu, fill: self.colors.primary-lightest))
        place(dx: bias1 + 4113547%/w_emu, dy: 3125632%/h_emu,
          ellipse(fill: white, width: 175511%/w_emu, height: 1080034%/h_emu))
        place(dx: bias1 + 4162575%/w_emu, dy: 4174454%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 186269%/w_emu, height: 953067%/h_emu))
        place(dx: bias1 + 4968341%/w_emu, dy: 3116601%/h_emu,
          ellipse(fill: white, width: 175511%/w_emu, height: 1080034%/h_emu))
        place(dx: bias1 + 4783849%/w_emu, dy: 3152985%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 4738148%/w_emu, dy: 4059275%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 4991012%/w_emu, dy: 4198641%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 3973017%/w_emu, dy: 1629881%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 4019776%/w_emu, height: 1305922%/h_emu)) 
        place(dx: bias1 + 4644795%/w_emu, dy: 2188963%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1079355%/w_emu, height: 1305922%/h_emu))
        place(dx: bias1 + 5613235%/w_emu, dy: 3473407%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 4721284%/w_emu, dy: 2729405%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 2484499%/w_emu, height: 1305922%/h_emu))
        place(dx: bias1 + 6035987%/w_emu, dy: 1894635%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 2780874%/w_emu, height: 2204396%/h_emu))
        place(dx: bias1 + 7726256%/w_emu, dy: 2743758%/h_emu, 
          rect(width: 670302%/w_emu, height: 2751112%/h_emu, fill: self.colors.primary-lightest))
        place(dx: bias1 + 7649232%/w_emu, dy: 4198641%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 8271456%/w_emu, dy: 3473407%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 197550%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 8254033%/w_emu, dy: 4357272%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 271660%/w_emu, height: 1021469%/h_emu))
        place(dx: bias1 + 8761802%/w_emu, dy: 2220968%/h_emu,
          ellipse(fill: self.colors.primary-lightest, width: 1079355%/w_emu, height: 2408144%/h_emu))
        place(dx: bias1 + 8795076%/w_emu, dy: 1657366%/h_emu,
          ellipse(fill: white, width: 1428578%/w_emu, height: 2837510%/h_emu))
      }
    ),
    ..args,
  )

  body
  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(12pt)
    bibliography("../"+{bibliography-file}, 
      title: context [
        #if text.lang in ("zh", "ja") { "参考文献" } else { "References" }
      ],
      style: "ieee")
  }
}
