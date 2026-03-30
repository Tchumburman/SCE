# ===========================================================================
# Data Visualization Principles Module
# Topics: Chart chooser, perceptual ranking, misleading graphs, best practices
# ===========================================================================

dataviz_ui <- function(id) {
  ns <- NS(id)
  nav_panel(

  title = "Visualization Principles",
  icon  = icon("palette"),
  layout_sidebar(
    sidebar = sidebar(
      title = "Visualization Settings",
      width = 310,

      # ── Tab 1: Chart Chooser ──
      conditionalPanel(ns = ns, 
        "input.dataviz_tabs == 'Chart Chooser'",
        selectInput(ns("dv_outcome"), "What are you showing?",
                    c("Distribution of one variable",
                      "Relationship between two variables",
                      "Comparison across groups",
                      "Composition / parts of a whole",
                      "Change over time")),
        selectInput(ns("dv_dtype"), "Data type(s)",
                    c("Continuous", "Categorical", "Mixed (continuous + categorical)")),
        sliderInput(ns("dv_n_groups"), "Number of groups / categories", 2, 20, 5),
        actionButton(ns("dv_recommend"), "Show Recommendations", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 2: Perceptual Ranking ──
      conditionalPanel(ns = ns, 
        "input.dataviz_tabs == 'Perceptual Ranking'",
        tags$p(class = "text-muted", style = "font-size: 0.85rem;",
          "Compare how accurately people decode different visual encodings.
           Adjust the values below and see if you can spot the difference."),
        sliderInput(ns("dv_perc_val1"), "Value A", 10, 90, 40),
        sliderInput(ns("dv_perc_val2"), "Value B", 10, 90, 55),
        actionButton(ns("dv_perc_go"), "Update Comparisons", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 3: Misleading Graphs ──
      conditionalPanel(ns = ns, 
        "input.dataviz_tabs == 'Misleading Graphs'",
        selectInput(ns("dv_mislead"), "Misleading technique",
                    c("Truncated Y-axis",
                      "Dual Y-axes",
                      "Area vs. length",
                      "3D pie chart distortion",
                      "Cherry-picked time range")),
        actionButton(ns("dv_mislead_go"), "Show Example", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 4: Best Practices ──
      conditionalPanel(ns = ns, 
        "input.dataviz_tabs == 'Best Practices'",
        selectInput(ns("dv_bp_topic"), "Topic",
                    c("Colour-blind safe palettes",
                      "Data-ink ratio",
                      "Small multiples vs. overplotting",
                      "Annotation & labelling")),
        actionButton(ns("dv_bp_go"), "Show Demo", class = "btn-success w-100 mt-2")
      )
    ),

    navset_card_tab(
      id = ns("dataviz_tabs"),

      # ── Tab 1 ──
      nav_panel("Chart Chooser",
        explanation_box(
          tags$strong("Choosing the Right Chart"),
          tags$p("The most common visualisation mistake is not choosing a bad
                  colour scheme — it is choosing the wrong chart type entirely.
                  The right chart depends on what you want the reader to see:
                  a distribution, a comparison, a relationship, a composition,
                  or a trend. Each of these tasks maps naturally to a small set
                  of effective chart types."),
          tags$p("Bar charts are excellent for comparing discrete categories;
                  histograms and density plots show continuous distributions;
                  scatter plots reveal relationships between two continuous
                  variables; line charts track change over ordered sequences
                  (usually time). Pie charts and stacked area charts can show
                  composition, but they are difficult to read accurately
                  because humans judge angles and areas poorly compared to
                  aligned lengths."),
          tags$p("The recommendations below follow established guidelines from
                  Cleveland and McGill (1984), Few (2012), and Wilke (2019).
                  When in doubt, prefer simpler encodings: position along a
                  common scale is the most accurately perceived visual property,
                  followed by length and slope. Colour hue is effective for
                  categorical distinctions but poor for quantitative comparisons.")
        ),
        card(card_header("Recommended Chart Types"), card_body(uiOutput(ns("dv_recommend_out"))))
      ),

      # ── Tab 2 ──
      nav_panel("Perceptual Ranking",
        explanation_box(
          tags$strong("Perceptual Accuracy of Visual Encodings"),
          tags$p("Cleveland and McGill (1984) established an empirical ranking
                  of how accurately people extract quantitative information from
                  different visual encodings. Position along a common scale is
                  the most accurate; then length, angle/slope, area, volume,
                  and finally colour saturation/density. This hierarchy should
                  guide which aesthetics you map to which variables."),
          tags$p("The demonstration below encodes the same two values using
                  six different visual channels. Notice how easy it is to
                  compare the values when shown as aligned bars (position),
                  and how much harder it becomes for area or colour. This is
                  why scatter plots and bar charts are workhorses of data
                  visualisation, while bubble charts and heatmaps should be
                  used more cautiously."),
          tags$p("In practice, this ranking means: put your most important
                  comparison on the x- or y-axis (position), use length for
                  secondary comparisons, and reserve colour for categorical
                  grouping or as a redundant encoding to reinforce a spatial
                  pattern.")
        ),
        layout_column_wrap(width = 1 / 3,
          card(card_header("Position (bar)"), card_body(plotOutput(ns("dv_perc_bar"), height = "200px"))),
          card(card_header("Length (separate)"), card_body(plotOutput(ns("dv_perc_length"), height = "200px"))),
          card(card_header("Angle (pie)"), card_body(plotOutput(ns("dv_perc_pie"), height = "200px")))
        ),
        layout_column_wrap(width = 1 / 3,
          card(card_header("Area (bubble)"), card_body(plotOutput(ns("dv_perc_area"), height = "200px"))),
          card(card_header("Colour saturation"), card_body(plotOutput(ns("dv_perc_colour"), height = "200px"))),
          card(card_header("Slope"), card_body(plotOutput(ns("dv_perc_slope"), height = "200px")))
        )
      ),

      # ── Tab 3 ──
      nav_panel("Misleading Graphs",
        explanation_box(
          tags$strong("Common Misleading Visualisation Techniques"),
          tags$p("Even correct data can be presented dishonestly through visual
                  manipulation. The most common trick is truncating the y-axis
                  so that small differences appear dramatic. A 1% change
                  can look like a 50% change if the axis starts at 99 instead
                  of 0. While starting at zero is not always necessary (it
                  depends on context), deliberately truncating to exaggerate
                  is misleading."),
          tags$p("Dual y-axes allow the creator to scale two series
                  independently, making spurious correlations appear strong.
                  The reader has no way to judge whether the apparent
                  relationship is real or an artefact of axis scaling. Using
                  area or volume to represent a linear quantity (e.g., making
                  an icon twice as tall AND twice as wide to represent 2×)
                  exaggerates the perceived ratio because area grows
                  quadratically."),
          tags$p("3D effects on pie charts distort the apparent proportions
                  because slices closer to the viewer look larger. Cherry-picked
                  time ranges can make a trend look positive or negative
                  depending on which start and end dates are chosen. Critical
                  readers should always ask: what does the full picture look
                  like?")
        ),
        layout_column_wrap(width = 1 / 2,
          card(card_header("Misleading Version"), card_body(plotOutput(ns("dv_mislead_bad"), height = "340px"))),
          card(card_header("Honest Version"), card_body(plotOutput(ns("dv_mislead_good"), height = "340px")))
        ),
        card(card_header("What's Wrong?"), card_body(uiOutput(ns("dv_mislead_explain"))))
      ),

      # ── Tab 4 ──
      nav_panel("Best Practices",
        explanation_box(
          tags$strong("Visualisation Best Practices"),
          tags$p("Good data visualisation is about clear communication, not
                  decoration. Tufte's 'data-ink ratio' principle suggests
                  maximising the proportion of ink devoted to data and
                  minimising non-data ink (grid lines, borders, backgrounds).
                  In practice, this means removing chart junk, using subtle
                  gridlines, and letting the data speak."),
          tags$p("Colour is one of the most powerful visual tools, but roughly
                  8% of men and 0.5% of women have some form of colour vision
                  deficiency. Using palettes that remain distinguishable under
                  the most common types of colour blindness (protanopia and
                  deuteranopia) is essential. The viridis, Okabe-Ito, and
                  ColorBrewer palettes are designed with this in mind."),
          tags$p("Small multiples (faceting) are almost always preferable to
                  plotting many groups on a single panel. They avoid
                  overplotting, make each group independently readable, and
                  preserve a common scale for fair comparison. Effective
                  annotation — titles, subtitles, direct labels, and reference
                  lines — reduces the reader's cognitive load by making the
                  message explicit rather than requiring mental arithmetic.")
        ),
        card(card_header("Demonstration"), card_body(plotOutput(ns("dv_bp_demo"), height = "420px"))),
        card(card_header("Explanation"), card_body(uiOutput(ns("dv_bp_explain"))))
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

dataviz_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ════════════════════════════════════════════════════════════
  # Tab 1 — Chart Chooser
  # ════════════════════════════════════════════════════════════
  output$dv_recommend_out <- renderUI({
    input$dv_recommend

    outcome <- isolate(input$dv_outcome)
    dtype   <- isolate(input$dv_dtype)
    n_grp   <- isolate(input$dv_n_groups)

    recs <- list()

    if (outcome == "Distribution of one variable") {
      if (dtype == "Continuous") {
        recs <- list(
          list(chart = "Histogram", icon = "chart-bar", why = "Shows shape, center, and spread. Choose bin width carefully."),
          list(chart = "Density plot", icon = "chart-area", why = "Smoothed version of histogram. Good for comparing multiple distributions."),
          list(chart = "Box plot", icon = "square", why = "Highlights median, quartiles, and outliers. Best for group comparisons."),
          list(chart = "Violin plot", icon = "guitar", why = "Combines density and box plot. Reveals multimodality.")
        )
      } else {
        recs <- list(
          list(chart = "Bar chart", icon = "chart-bar", why = "Best for counts/proportions of categories. Use horizontal bars if labels are long."),
          list(chart = "Dot plot (Cleveland)", icon = "braille", why = "Cleaner than bar chart when comparing many categories.")
        )
      }
    } else if (outcome == "Relationship between two variables") {
      recs <- list(
        list(chart = "Scatter plot", icon = "braille", why = "The default for two continuous variables. Add a trend line if testing association."),
        list(chart = "Hex bin / 2D density", icon = "table-cells", why = "When n > ~5000, individual points overlap. Bin or contour instead."),
        list(chart = "Bubble chart", icon = "circle", why = "Adds a third variable via size. Use sparingly — area perception is imprecise.")
      )
    } else if (outcome == "Comparison across groups") {
      if (n_grp <= 7) {
        recs <- list(
          list(chart = "Grouped bar chart", icon = "chart-bar", why = "Clear for a small number of groups. Ensure a common baseline."),
          list(chart = "Box / violin plot", icon = "square", why = "Good for comparing distributions, not just means."),
          list(chart = "Dot plot + error bars", icon = "braille", why = "Cleaner than bars for point estimates with uncertainty.")
        )
      } else {
        recs <- list(
          list(chart = "Cleveland dot plot", icon = "braille", why = "Handles many categories better than bar charts."),
          list(chart = "Heatmap", icon = "table-cells", why = "For crossing two categorical variables (e.g., group × metric)."),
          list(chart = "Small multiples", icon = "th", why = "Facet by group when there are too many to overlay.")
        )
      }
    } else if (outcome == "Composition / parts of a whole") {
      recs <- list(
        list(chart = "Stacked bar chart", icon = "chart-bar", why = "Best for composition. Use 100% stacked bars for proportions."),
        list(chart = "Waffle chart", icon = "th", why = "A grid-based alternative to pie charts. Good for small counts."),
        list(chart = "Treemap", icon = "table-cells", why = "Effective for hierarchical composition data.")
      )
      if (n_grp <= 4) {
        recs <- c(recs, list(
          list(chart = "Pie chart (≤4 slices only)", icon = "chart-pie",
               why = "Acceptable only with very few categories and clear labels. Bar chart is usually better.")))
      }
    } else {
      recs <- list(
        list(chart = "Line chart", icon = "chart-line", why = "The default for time series. Connects ordered observations."),
        list(chart = "Area chart", icon = "chart-area", why = "Emphasises volume under the curve. Use for single series or stacked composition."),
        list(chart = "Slope chart", icon = "arrow-trend-up", why = "Good for before/after comparisons across two time points.")
      )
    }

    cards <- lapply(recs, function(r) {
      tags$div(class = "d-flex align-items-start gap-3 mb-3 p-2 border rounded",
        tags$div(icon(r$icon, class = "fa-2x text-primary mt-1")),
        tags$div(
          tags$h6(class = "mb-1 fw-bold", r$chart),
          tags$p(class = "mb-0 text-muted", style = "font-size: 0.9rem;", r$why)
        )
      )
    })

    tagList(
      tags$p(class = "fw-bold mb-3",
        paste0("For '", outcome, "' with ", dtype, " data:")),
      tagList(cards)
    )
  })

  # ════════════════════════════════════════════════════════════
  # Tab 2 — Perceptual Ranking
  # ════════════════════════════════════════════════════════════
  perc_vals <- eventReactive(input$dv_perc_go, {
    list(a = input$dv_perc_val1, b = input$dv_perc_val2)
  })

  output$dv_perc_bar <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(group = c("A", "B"), value = c(v$a, v$b))
    ggplot(df, aes(x = group, y = value, fill = group)) +
      geom_col(width = 0.6, show.legend = FALSE) +
      scale_fill_manual(values = c("#268bd2", "#2aa198")) +
      labs(x = NULL, y = "Value") +
      coord_cartesian(ylim = c(0, 100))
  }, bg = "transparent")

  output$dv_perc_length <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(group = c("A", "B"), value = c(v$a, v$b),
                     ypos = c(2, 1))
    ggplot(df, aes(xmin = 0, xmax = value, y = ypos, fill = group)) +
      geom_rect(aes(ymin = ypos - 0.3, ymax = ypos + 0.3), show.legend = FALSE) +
      scale_fill_manual(values = c("#268bd2", "#2aa198")) +
      scale_y_continuous(breaks = c(1, 2), labels = c("B", "A")) +
      labs(x = "Value", y = NULL) +
      coord_cartesian(xlim = c(0, 100))
  }, bg = "transparent")

  output$dv_perc_pie <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(group = c("A", "B", "Other"),
                     value = c(v$a, v$b, max(0, 100 - v$a - v$b)))
    df$value[df$value < 0] <- 0
    ggplot(df, aes(x = "", y = value, fill = group)) +
      geom_col(width = 1) +
      coord_polar(theta = "y") +
      scale_fill_manual(values = c("#268bd2", "#2aa198", "#93a1a1")) +
      labs(x = NULL, y = NULL, fill = NULL) +
      theme(axis.text = element_blank(), axis.ticks = element_blank(),
            panel.grid = element_blank())
  }, bg = "transparent")

  output$dv_perc_area <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(group = c("A", "B"), value = c(v$a, v$b),
                     x = c(1, 3), y = c(1.5, 1.5))
    ggplot(df, aes(x = x, y = y)) +
      geom_point(aes(size = value, colour = group), show.legend = FALSE) +
      scale_size_area(max_size = 30, limits = c(0, 100)) +
      scale_colour_manual(values = c("#268bd2", "#2aa198")) +
      geom_text(aes(label = group), size = 5, vjust = -2.5) +
      coord_cartesian(xlim = c(-0.5, 4.5), ylim = c(0, 3)) +
      labs(x = NULL, y = NULL) +
      theme(axis.text = element_blank(), axis.ticks = element_blank(),
            panel.grid = element_blank())
  }, bg = "transparent")

  output$dv_perc_colour <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(group = c("A", "B"), value = c(v$a, v$b))
    ggplot(df, aes(x = group, y = 1, fill = value)) +
      geom_tile(width = 0.8, height = 0.8) +
      scale_fill_gradient(low = "#fdf6e3", high = "#268bd2", limits = c(0, 100)) +
      geom_text(aes(label = group), size = 7, colour = "white") +
      labs(x = NULL, y = NULL, fill = "Value") +
      theme(axis.text = element_blank(), axis.ticks = element_blank(),
            panel.grid = element_blank())
  }, bg = "transparent")

  output$dv_perc_slope <- renderPlot({
    v <- perc_vals(); req(v)
    df <- data.frame(x = c(1, 1, 2, 2), y = c(0, v$a, 0, v$b),
                     group = c("A", "A", "B", "B"))
    df2 <- data.frame(x = c(1, 2), y = c(v$a, v$b), group = c("A", "B"))
    ggplot() +
      geom_segment(data = df2, aes(x = 0.8, xend = 1, y = 0, yend = y, colour = group),
                   linewidth = 2, show.legend = FALSE) +
      scale_colour_manual(values = c("#268bd2", "#2aa198")) +
      geom_text(data = df2, aes(x = c(0.75, 0.75), y = y / 2, label = group), size = 5) +
      coord_cartesian(ylim = c(0, 100), xlim = c(0.5, 1.2)) +
      labs(x = NULL, y = "Value") +
      theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
  }, bg = "transparent")

  # ════════════════════════════════════════════════════════════
  # Tab 3 — Misleading Graphs
  # ════════════════════════════════════════════════════════════
  mislead_data <- eventReactive(input$dv_mislead_go, {
    input$dv_mislead
  })

  output$dv_mislead_bad <- renderPlot({
    technique <- mislead_data(); req(technique)

    if (technique == "Truncated Y-axis") {
      df <- data.frame(year = 2020:2025,
                       value = c(98.2, 98.5, 98.8, 99.1, 99.3, 99.6))
      ggplot(df, aes(x = factor(year), y = value)) +
        geom_col(fill = "#dc322f", width = 0.6) +
        coord_cartesian(ylim = c(97.5, 100)) +
        labs(x = "Year", y = "Approval %", title = "Dramatic Rise in Approval!")

    } else if (technique == "Dual Y-axes") {
      set.seed(4821)
      df <- data.frame(year = 2015:2025,
                       cheese = cumsum(rnorm(11, 2, 1)) + 30,
                       phd = cumsum(rnorm(11, 1.5, 0.8)) + 10)
      sc <- max(df$cheese) / max(df$phd)
      ggplot(df, aes(x = year)) +
        geom_line(aes(y = cheese), colour = "#b58900", linewidth = 1.5) +
        geom_line(aes(y = phd * sc), colour = "#268bd2", linewidth = 1.5) +
        scale_y_continuous(
          name = "Cheese consumption (kg)",
          sec.axis = sec_axis(~ . / sc, name = "PhD graduations (thousands)")
        ) +
        labs(title = "Cheese Consumption Predicts PhD Graduations!") +
        theme(axis.title.y.left = element_text(colour = "#b58900"),
              axis.title.y.right = element_text(colour = "#268bd2"))

    } else if (technique == "Area vs. length") {
      df <- data.frame(label = c("2020", "2025"),
                       value = c(100, 200),
                       x = c(1, 3), y = c(1.5, 1.5))
      ggplot(df, aes(x = x, y = y)) +
        geom_point(aes(size = value), colour = "#268bd2", show.legend = FALSE) +
        scale_size_area(max_size = 40) +
        geom_text(aes(label = paste0(label, "\n", value, " units")), vjust = -2) +
        coord_cartesian(xlim = c(-0.5, 4.5), ylim = c(0, 3)) +
        labs(title = "Sales Exploded! (2x value = 4x area)") +
        theme(axis.text = element_blank(), axis.ticks = element_blank(),
              axis.title = element_blank(), panel.grid = element_blank())

    } else if (technique == "3D pie chart distortion") {
      df <- data.frame(category = c("Product A", "Product B", "Product C", "Product D"),
                       value = c(35, 25, 22, 18))
      ggplot(df, aes(x = "", y = value, fill = category)) +
        geom_col(width = 1) +
        coord_polar(theta = "y") +
        scale_fill_manual(values = c("#268bd2", "#2aa198", "#b58900", "#dc322f")) +
        labs(title = "Market Share (hard to read angles)",
             fill = "Product") +
        theme(axis.text = element_blank(), axis.ticks = element_blank(),
              axis.title = element_blank(), panel.grid = element_blank())

    } else {
      set.seed(7214)
      full <- data.frame(month = seq.Date(as.Date("2020-01-01"), as.Date("2025-12-01"), by = "month"))
      full$value <- 100 + cumsum(rnorm(nrow(full), 0.3, 3))
      cherry <- full[full$month >= as.Date("2024-06-01") & full$month <= as.Date("2025-12-01"), ]
      ggplot(cherry, aes(x = month, y = value)) +
        geom_line(colour = "#2aa198", linewidth = 1.2) +
        labs(x = "Month", y = "Index", title = "Remarkable Growth Since Mid-2024!") +
        scale_x_date(date_labels = "%b %Y")
    }
  }, bg = "transparent")

  output$dv_mislead_good <- renderPlot({
    technique <- mislead_data(); req(technique)

    if (technique == "Truncated Y-axis") {
      df <- data.frame(year = 2020:2025,
                       value = c(98.2, 98.5, 98.8, 99.1, 99.3, 99.6))
      ggplot(df, aes(x = factor(year), y = value)) +
        geom_col(fill = "#2aa198", width = 0.6) +
        coord_cartesian(ylim = c(0, 100)) +
        labs(x = "Year", y = "Approval %", title = "Same Data, Full Scale")

    } else if (technique == "Dual Y-axes") {
      set.seed(4821)
      df <- data.frame(year = 2015:2025,
                       cheese = cumsum(rnorm(11, 2, 1)) + 30,
                       phd = cumsum(rnorm(11, 1.5, 0.8)) + 10)
      df_long <- data.frame(
        year = rep(df$year, 2),
        value = c(scale(df$cheese), scale(df$phd)),
        series = rep(c("Cheese consumption", "PhD graduations"), each = 11)
      )
      ggplot(df_long, aes(x = year, y = value, colour = series)) +
        geom_line(linewidth = 1.2) +
        scale_colour_manual(values = c("#b58900", "#268bd2")) +
        labs(x = "Year", y = "Standardised value", colour = NULL,
             title = "Separate z-scores: different scales, no causal link")

    } else if (technique == "Area vs. length") {
      df <- data.frame(label = c("2020", "2025"), value = c(100, 200))
      ggplot(df, aes(x = label, y = value)) +
        geom_col(fill = "#2aa198", width = 0.5) +
        labs(x = NULL, y = "Units", title = "Same Data: Bar Chart (length encoding)")

    } else if (technique == "3D pie chart distortion") {
      df <- data.frame(category = c("Product A", "Product B", "Product C", "Product D"),
                       value = c(35, 25, 22, 18))
      ggplot(df, aes(y = reorder(category, value), x = value, fill = category)) +
        geom_col(show.legend = FALSE, width = 0.6) +
        scale_fill_manual(values = c("#268bd2", "#2aa198", "#b58900", "#dc322f")) +
        labs(x = "Market Share (%)", y = NULL,
             title = "Same Data: Horizontal Bar (position encoding)")

    } else {
      set.seed(7214)
      full <- data.frame(month = seq.Date(as.Date("2020-01-01"), as.Date("2025-12-01"), by = "month"))
      full$value <- 100 + cumsum(rnorm(nrow(full), 0.3, 3))
      cherry_start <- as.Date("2024-06-01")
      ggplot(full, aes(x = month, y = value)) +
        geom_line(colour = "#2aa198", linewidth = 0.8) +
        geom_vline(xintercept = as.numeric(cherry_start),
                   linetype = "dashed", colour = "#dc322f") +
        annotate("text", x = cherry_start, y = max(full$value),
                 label = "Cherry-picked\nstart", hjust = 1.1,
                 colour = "#dc322f", size = 3.5) +
        labs(x = "Month", y = "Index", title = "Full Time Range: Context Matters") +
        scale_x_date(date_labels = "%b %Y")
    }
  }, bg = "transparent")

  output$dv_mislead_explain <- renderUI({
    technique <- mislead_data(); req(technique)
    msg <- switch(technique,
      "Truncated Y-axis" = "Truncating the y-axis from 0 exaggerates small differences. The left chart makes a 1.4 percentage-point change look enormous; the right chart shows the same data in full context.",
      "Dual Y-axes" = "Dual y-axes let the creator independently scale two series to create the appearance of correlation. The 'honest' version standardises both series, revealing they are unrelated.",
      "Area vs. length" = "Doubling a value but encoding it as circle area makes the increase look like 4× (area scales as the square). A bar chart uses length, which is proportional and accurately perceived.",
      "3D pie chart distortion" = "Pie charts encode values as angles, which humans judge poorly. 3D perspective further distorts perceived proportions. A horizontal bar chart uses position, the most accurately perceived encoding.",
      "Cherry-picked time range" = "Choosing a start date at a local minimum creates an illusion of strong growth. Showing the full time range reveals that the 'remarkable growth' is just normal fluctuation."
    )
    tags$p(class = "text-muted", style = "font-size: 0.95rem;", msg)
  })

  # ════════════════════════════════════════════════════════════
  # Tab 4 — Best Practices
  # ════════════════════════════════════════════════════════════
  bp_data <- eventReactive(input$dv_bp_go, {
    input$dv_bp_topic
  })

  output$dv_bp_demo <- renderPlot({
    topic <- bp_data(); req(topic)
    set.seed(5123)

    if (topic == "Colour-blind safe palettes") {
      df <- data.frame(
        x = rep(1:5, 3),
        y = c(rnorm(5, 10, 2), rnorm(5, 15, 2), rnorm(5, 12, 2)),
        group = rep(c("Group A", "Group B", "Group C"), each = 5)
      )
      # Okabe-Ito palette
      ggplot(df, aes(x = x, y = y, colour = group, shape = group)) +
        geom_point(size = 4) +
        geom_line(linewidth = 0.8) +
        scale_colour_manual(values = c("#E69F00", "#56B4E9", "#009E73")) +
        labs(x = "Time", y = "Value", colour = NULL, shape = NULL,
             title = "Okabe-Ito palette: safe for colour vision deficiency",
             subtitle = "Shape provides a redundant encoding for accessibility")

    } else if (topic == "Data-ink ratio") {
      df <- data.frame(category = LETTERS[1:6],
                       value = c(23, 45, 31, 67, 52, 38))

      ggplot(df, aes(y = reorder(category, value), x = value)) +
        geom_point(size = 3, colour = "#268bd2") +
        geom_segment(aes(yend = reorder(category, value), x = 0, xend = value),
                     colour = "#268bd2", linewidth = 0.7) +
        labs(x = "Value", y = NULL,
             title = "High data-ink ratio: lollipop chart",
             subtitle = "Minimal non-data ink; every mark encodes information") +
        theme(panel.grid.major.y = element_blank())

    } else if (topic == "Small multiples vs. overplotting") {
      df <- data.frame(
        x = rep(seq(0, 10, length.out = 50), 4),
        y = c(sin(seq(0, 10, length.out = 50)) + rnorm(50, 0, 0.3),
              cos(seq(0, 10, length.out = 50)) + rnorm(50, 0, 0.3),
              0.5 * seq(0, 10, length.out = 50) / 10 + rnorm(50, 0, 0.3),
              -0.3 * seq(0, 10, length.out = 50) / 10 + 1 + rnorm(50, 0, 0.3)),
        group = rep(c("Series A", "Series B", "Series C", "Series D"), each = 50)
      )
      ggplot(df, aes(x = x, y = y, colour = group)) +
        geom_line(linewidth = 0.8) +
        facet_wrap(~group, scales = "free_y") +
        scale_colour_manual(values = c("#268bd2", "#2aa198", "#b58900", "#dc322f")) +
        labs(x = "Time", y = "Value",
             title = "Small multiples: each series is independently readable") +
        theme(legend.position = "none")

    } else {
      df <- data.frame(
        year = 2018:2025,
        revenue = c(12, 15, 14, 18, 22, 25, 28, 32)
      )
      ggplot(df, aes(x = year, y = revenue)) +
        geom_line(colour = "#268bd2", linewidth = 1.2) +
        geom_point(colour = "#268bd2", size = 2.5) +
        annotate("text", x = 2021, y = 18,
                 label = "COVID\nrecovery", hjust = -0.2,
                 colour = "#657b83", size = 3.5) +
        annotate("segment", x = 2021, xend = 2021,
                 y = 16.5, yend = 17.5,
                 arrow = arrow(length = unit(0.15, "cm")),
                 colour = "#657b83") +
        geom_hline(yintercept = 20, linetype = "dashed",
                   colour = "#dc322f", linewidth = 0.5) +
        annotate("text", x = 2018.2, y = 20.8,
                 label = "Target: $20M", colour = "#dc322f", size = 3.5,
                 hjust = 0) +
        labs(x = "Year", y = "Revenue ($M)",
             title = "Direct annotation reduces legend lookups",
             subtitle = "Reference lines and labels make the message explicit")
    }
  }, bg = "transparent")

  output$dv_bp_explain <- renderUI({
    topic <- bp_data(); req(topic)
    msg <- switch(topic,
      "Colour-blind safe palettes" = "The Okabe-Ito palette uses colours that remain distinguishable under the most common forms of colour vision deficiency. Adding shape as a redundant encoding ensures accessibility even in greyscale.",
      "Data-ink ratio" = "The lollipop chart conveys the same information as a bar chart with less visual weight. Removing heavy bars, unnecessary gridlines, and borders maximises the data-ink ratio.",
      "Small multiples vs. overplotting" = "Four overlapping lines on one panel are hard to trace. Small multiples (facets) separate each series into its own panel with a shared scale, making individual patterns clear.",
      "Annotation & labelling" = "Direct labels, reference lines, and annotations reduce the need for legends and mental arithmetic. The reader immediately sees the key message rather than decoding the chart."
    )
    tags$p(class = "text-muted", style = "font-size: 0.95rem;", msg)
  })
  })
}
