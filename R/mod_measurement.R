# Module: Measurement Fundamentals
# Covers measurement scales (nominal/ordinal/interval/ratio) and
# types of validity and reliability.

# ── UI ──────────────────────────────────────────────────────────────────
measurement_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    "Measurement Fundamentals",
    icon = icon("ruler-horizontal"),
    navset_card_underline(

      # ── Tab 1: Measurement Scales ─────────────────────────────────────
      nav_panel(
        "Measurement Scales",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("scale_type"), "Scale type",
              choices = c("Nominal", "Ordinal", "Interval", "Ratio"),
              selected = "Nominal"
            ),
            sliderInput(ns("scale_n"), "Sample size", min = 20, max = 500,
                        value = 100, step = 10),
            actionButton(ns("scale_gen"), "Generate sample",
                         class = "btn-success w-100 mt-2"),
            tags$hr(),
            tags$h6("Guess the Scale"),
            uiOutput(ns("quiz_variable")),
            radioButtons(ns("quiz_answer"), NULL,
              choices = c("Nominal", "Ordinal", "Interval", "Ratio"),
              inline = TRUE
            ),
            actionButton(ns("quiz_check"), "Check", class = "btn-primary w-100"),
            uiOutput(ns("quiz_feedback"))
          ),
          explanation_box(
            tags$strong("Measurement Scales"),
            tags$p("Stevens (1946) proposed four levels of measurement that determine
                    which mathematical operations and statistical methods are
                    appropriate for a variable. Understanding the scale of your
                    data is one of the most fundamental steps in any analysis."),
            tags$ul(
              tags$li(tags$strong("Nominal:"), " Categories with no inherent order
                      (e.g., blood type, eye colour, country). The only meaningful
                      operation is counting frequencies. Appropriate statistics:
                      mode, chi-square test."),
              tags$li(tags$strong("Ordinal:"), " Categories with a meaningful rank
                      order but unequal or unknown intervals (e.g., Likert scales,
                      education level, race positions). Median and percentiles are
                      appropriate; arithmetic mean is debatable."),
              tags$li(tags$strong("Interval:"), " Numeric scale with equal intervals
                      but no true zero (e.g., temperature in \u00b0C/\u00b0F,
                      calendar year, IQ scores). Addition and subtraction are
                      meaningful; ratios are not (20\u00b0C is not 'twice as hot'
                      as 10\u00b0C)."),
              tags$li(tags$strong("Ratio:"), " Numeric scale with equal intervals and
                      a true zero point (e.g., height, weight, reaction time,
                      income). All arithmetic operations are meaningful, including
                      ratios (200 cm is twice 100 cm).")
            ),
            tags$p("A common mistake is treating ordinal data as interval \u2014 for
                    example, computing the mean of Likert items. While widely
                    practised, this assumes equal spacing between categories, which
                    may not hold. The consequences of violating this assumption
                    depend on the degree of non-linearity in the true spacing."),
            guide = tags$ol(
              tags$li("Select a measurement scale to see example data and an appropriate plot."),
              tags$li("Review the 'Allowed Operations' table below the plot."),
              tags$li("Use the 'Guess the Scale' sidebar game to test your understanding."),
              tags$li("Try all four scales and compare what changes.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE,
                 card_header("Example Data & Appropriate Visualisation"),
                 plotlyOutput(ns("scale_plot"), height = "380px")),
            card(card_header("Allowed Operations by Scale"),
                 tableOutput(ns("scale_ops_table"))),
            card(card_header("Sample Data Preview"),
                 tableOutput(ns("scale_data_preview")))
          )
        )
      ),

      # ── Tab 2: Types of Validity ──────────────────────────────────────
      nav_panel(
        "Types of Validity",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("validity_type"), "Validity type",
              choices = c("Content Validity" = "content",
                          "Criterion: Concurrent" = "concurrent",
                          "Criterion: Predictive" = "predictive",
                          "Construct: Convergent & Discriminant" = "construct",
                          "Face Validity" = "face",
                          "Ecological Validity" = "ecological"),
              selected = "content"
            ),
            conditionalPanel(
              condition = sprintf("input['%s'] == 'concurrent' || input['%s'] == 'predictive'",
                                  ns("validity_type"), ns("validity_type")),
              sliderInput(ns("val_r"), "True correlation (r)", min = 0, max = 0.99,
                          value = 0.65, step = 0.05),
              sliderInput(ns("val_n"), "Sample size", min = 30, max = 500,
                          value = 100, step = 10)
            ),
            conditionalPanel(
              condition = sprintf("input['%s'] == 'construct'", ns("validity_type")),
              sliderInput(ns("val_conv_r"), "Convergent r (same construct)", min = 0, max = 0.99,
                          value = 0.75, step = 0.05),
              sliderInput(ns("val_disc_r"), "Discriminant r (different construct)", min = 0, max = 0.99,
                          value = 0.20, step = 0.05)
            ),
            conditionalPanel(
              condition = sprintf("input['%s'] == 'content'", ns("validity_type")),
              sliderInput(ns("val_n_experts"), "Number of experts", min = 3, max = 15,
                          value = 6, step = 1),
              sliderInput(ns("val_n_items"), "Number of items", min = 5, max = 30,
                          value = 12, step = 1)
            ),
            actionButton(ns("val_gen"), "Generate / Refresh",
                         class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Types of Validity"),
            tags$p("Validity refers to the degree to which a test or instrument
                    measures what it claims to measure. Modern validity theory
                    (Messick, 1989) views validity as a unitary concept supported
                    by multiple sources of evidence, but the traditional categories
                    remain useful for organising that evidence."),
            tags$ul(
              tags$li(tags$strong("Content validity:"), " The extent to which test
                      items representatively sample the domain of interest. Assessed
                      by expert judgement, often quantified via the Content Validity
                      Index (CVI) \u2014 the proportion of experts rating an item
                      as essential or relevant."),
              tags$li(tags$strong("Criterion validity:"), " How well the test
                      predicts or correlates with an external criterion.",
                tags$ul(
                  tags$li(tags$em("Concurrent:"), " Test and criterion measured at
                          the same time (e.g., new depression scale vs. established
                          BDI-II)."),
                  tags$li(tags$em("Predictive:"), " Test measured now, criterion
                          measured in the future (e.g., SAT scores predicting
                          first-year GPA).")
                )
              ),
              tags$li(tags$strong("Construct validity:"), " Whether the test measures
                      the theoretical construct it targets.",
                tags$ul(
                  tags$li(tags$em("Convergent:"), " High correlation with measures
                          of the same or similar constructs."),
                  tags$li(tags$em("Discriminant:"), " Low correlation with measures
                          of unrelated constructs.")
                )
              ),
              tags$li(tags$strong("Face validity:"), " Whether the test appears to
                      measure what it claims, from the test-taker\u2019s perspective.
                      Not a formal psychometric property, but important for acceptance
                      and motivation."),
              tags$li(tags$strong("Ecological validity:"), " The extent to which
                      findings generalise to real-world settings. A lab measure with
                      high internal validity may have low ecological validity if
                      the testing context is artificial.")
            ),
            guide = tags$ol(
              tags$li("Select a validity type from the dropdown."),
              tags$li("For criterion validity, adjust the correlation and sample size to see how evidence strength changes."),
              tags$li("For construct validity, compare convergent and discriminant correlations."),
              tags$li("For content validity, examine the expert rating heatmap and CVI scores.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE,
                 card_header(textOutput(ns("val_title"))),
                 plotlyOutput(ns("val_plot"), height = "420px")),
            card(card_header("Interpretation"),
                 uiOutput(ns("val_interpretation")))
          )
        )
      ),

      # ── Tab 3: Types of Reliability ───────────────────────────────────
      nav_panel(
        "Types of Reliability",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("rel_type"), "Reliability type",
              choices = c("Test-Retest" = "retest",
                          "Internal Consistency (\u03b1)" = "alpha",
                          "Inter-Rater" = "interrater",
                          "Parallel Forms" = "parallel"),
              selected = "retest"
            ),
            sliderInput(ns("rel_true_r"), "True reliability", min = 0.10, max = 0.99,
                        value = 0.85, step = 0.05),
            sliderInput(ns("rel_n"), "Sample size", min = 30, max = 500,
                        value = 100, step = 10),
            conditionalPanel(
              condition = sprintf("input['%s'] == 'alpha'", ns("rel_type")),
              sliderInput(ns("rel_n_items"), "Number of items", min = 3, max = 30,
                          value = 10, step = 1)
            ),
            conditionalPanel(
              condition = sprintf("input['%s'] == 'interrater'", ns("rel_type")),
              sliderInput(ns("rel_n_raters"), "Number of raters", min = 2, max = 6,
                          value = 2, step = 1),
              sliderInput(ns("rel_n_categories"), "Rating categories", min = 2, max = 7,
                          value = 4, step = 1)
            ),
            actionButton(ns("rel_gen"), "Generate / Refresh",
                         class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Types of Reliability"),
            tags$p("Reliability is the consistency or stability of measurement. A
                    reliable instrument produces similar results under consistent
                    conditions. Classical Test Theory decomposes an observed score
                    into true score plus error: X = T + E. Reliability is the
                    proportion of observed score variance that is true score
                    variance: \u03C1 = \u03C3\u00b2(T) / \u03C3\u00b2(X)."),
            tags$ul(
              tags$li(tags$strong("Test-retest:"), " Administer the same test to the
                      same people at two time points. The correlation (or ICC)
                      between occasions estimates temporal stability. The interval
                      matters: too short risks memory effects, too long allows real
                      change."),
              tags$li(tags$strong("Internal consistency:"), " Cronbach\u2019s \u03b1
                      estimates how well items on a single test correlate with each
                      other. It increases with more items and higher average inter-item
                      correlation. \u03b1 \u2265 0.70 is a common (but context-dependent)
                      threshold. McDonald\u2019s \u03c9 is preferred when items are
                      not tau-equivalent."),
              tags$li(tags$strong("Inter-rater:"), " Agreement between two or more
                      raters scoring the same targets. Cohen\u2019s \u03ba corrects
                      for chance agreement (two raters); Fleiss\u2019 \u03ba or ICC
                      extends to multiple raters."),
              tags$li(tags$strong("Parallel forms:"), " Two equivalent forms of the
                      same test administered to the same people. The correlation
                      between forms estimates reliability while avoiding memory/
                      practice effects inherent in test-retest designs.")
            ),
            tags$p("The Spearman-Brown prophecy formula shows that reliability
                    increases with test length: \u03C1_k = k\u03C1 / (1 + (k-1)\u03C1),
                    where k is the factor by which the test is lengthened. This
                    is why longer tests tend to be more reliable, all else equal."),
            guide = tags$ol(
              tags$li("Choose a reliability type and set the true reliability level."),
              tags$li("Click 'Generate / Refresh' to simulate data."),
              tags$li("Observe how the scatter/heatmap changes with different reliability levels."),
              tags$li("Compare the estimated reliability to the true value you set."),
              tags$li("Try different sample sizes to see how estimation precision changes.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE,
                 card_header(textOutput(ns("rel_title"))),
                 plotlyOutput(ns("rel_plot"), height = "420px")),
            card(card_header("Reliability Estimate"),
                 uiOutput(ns("rel_summary")))
          )
        )
      )
    )
  )
}

# ── Plotly layout helper (transparent bg + Solarized font) ──────────
.meas_layout <- function(p, ...) {
  p |> plotly::layout(
    paper_bgcolor = "transparent",
    plot_bgcolor  = "transparent",
    font = list(color = "#657b83"),
    ...
  ) |> plotly::config(displayModeBar = FALSE)
}

# ── Server ──────────────────────────────────────────────────────────────
measurement_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # ====================================================================
    # Tab 1: Measurement Scales
    # ====================================================================

    scale_data <- reactiveVal(NULL)

    generate_scale_data <- function() {
      n <- input$scale_n
      set.seed(sample.int(10000, 1))

      switch(input$scale_type,
        "Nominal" = {
          data.frame(
            ID = seq_len(n),
            Blood_Type = sample(c("A", "B", "AB", "O"), n, replace = TRUE,
                                prob = c(0.36, 0.28, 0.20, 0.16)),
            stringsAsFactors = FALSE
          )
        },
        "Ordinal" = {
          data.frame(
            ID = seq_len(n),
            Satisfaction = factor(
              sample(c("Very Dissatisfied", "Dissatisfied", "Neutral",
                       "Satisfied", "Very Satisfied"), n, replace = TRUE,
                     prob = c(0.05, 0.15, 0.30, 0.35, 0.15)),
              levels = c("Very Dissatisfied", "Dissatisfied", "Neutral",
                         "Satisfied", "Very Satisfied"),
              ordered = TRUE
            )
          )
        },
        "Interval" = {
          data.frame(
            ID = seq_len(n),
            Temperature_C = round(rnorm(n, mean = 20, sd = 8), 1)
          )
        },
        "Ratio" = {
          data.frame(
            ID = seq_len(n),
            Reaction_Time_ms = round(rgamma(n, shape = 4, rate = 0.01), 0)
          )
        }
      )
    }

    # Regenerate on button press or scale type change
    observeEvent(input$scale_gen, scale_data(generate_scale_data()), ignoreNULL = FALSE)
    observeEvent(input$scale_type, scale_data(generate_scale_data()))

    # Trigger initial generation
    observe({
      if (is.null(scale_data())) {
        scale_data(data.frame(
          ID = seq_len(100),
          Blood_Type = sample(c("A", "B", "AB", "O"), 100, replace = TRUE,
                              prob = c(0.36, 0.28, 0.20, 0.16)),
          stringsAsFactors = FALSE
        ))
      }
    }) |> bindEvent(TRUE, once = TRUE)

    output$scale_plot <- renderPlotly({
      req(scale_data())
      df <- scale_data()

      switch(input$scale_type,
        "Nominal" = {
          freqs <- as.data.frame(table(df$Blood_Type))
          names(freqs) <- c("Category", "Count")
          plotly::plot_ly(freqs, x = ~Category, y = ~Count, type = "bar",
                          marker = list(color = "#268bd2")) |>
            .meas_layout(
              xaxis = list(title = "Blood Type"),
              yaxis = list(title = "Count"),
              margin = list(t = 40),
              annotations = list(list(
                x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                text = "Nominal: Blood Type (bar chart of frequencies)",
                showarrow = FALSE, font = list(size = 14)
              ))
            )
        },
        "Ordinal" = {
          freqs <- as.data.frame(table(df$Satisfaction))
          names(freqs) <- c("Level", "Count")
          freqs$Level <- factor(freqs$Level,
            levels = c("Very Dissatisfied", "Dissatisfied", "Neutral",
                       "Satisfied", "Very Satisfied"))
          plotly::plot_ly(freqs, x = ~Level, y = ~Count, type = "bar",
                          marker = list(color = "#2aa198")) |>
            .meas_layout(
              xaxis = list(title = "Satisfaction"),
              yaxis = list(title = "Count"),
              margin = list(t = 40),
              annotations = list(list(
                x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                text = "Ordinal: Satisfaction level (ordered bar chart)",
                showarrow = FALSE, font = list(size = 14)
              ))
            )
        },
        "Interval" = {
          plotly::plot_ly(x = df$Temperature_C, type = "histogram",
                          marker = list(color = "rgba(181,137,0,0.7)",
                                        line = list(color = "#b58900", width = 1)),
                          showlegend = FALSE,
                          hovertemplate = "Bin: %{x}<br>Count: %{y}<extra></extra>") |>
            .meas_layout(
              xaxis = list(title = "Temperature (\u00b0C)"),
              yaxis = list(title = "Count"),
              margin = list(t = 40),
              annotations = list(list(
                x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                text = "Interval: Temperature in \u00b0C (histogram)",
                showarrow = FALSE, font = list(size = 14)
              ))
            )
        },
        "Ratio" = {
          plotly::plot_ly(x = df$Reaction_Time_ms, type = "histogram",
                          marker = list(color = "rgba(203,75,22,0.7)",
                                        line = list(color = "#cb4b16", width = 1)),
                          showlegend = FALSE,
                          hovertemplate = "Bin: %{x}<br>Count: %{y}<extra></extra>") |>
            .meas_layout(
              xaxis = list(title = "Reaction Time (ms)"),
              yaxis = list(title = "Count"),
              margin = list(t = 40),
              shapes = list(list(
                type = "line", x0 = 0, x1 = 0, y0 = 0, y1 = 1,
                yref = "paper", line = list(color = "#839496", width = 1.5, dash = "dash")
              )),
              annotations = list(
                list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                     text = "Ratio: Reaction time in ms (histogram with true zero)",
                     showarrow = FALSE, font = list(size = 14)),
                list(x = 5, y = 0.95, yref = "paper",
                     text = "True zero \u2192", showarrow = FALSE,
                     font = list(size = 11, color = "#839496"))
              )
            )
        }
      )
    })

    output$scale_ops_table <- renderTable({
      data.frame(
        Operation = c("Frequency / Mode", "Median / Rank",
                       "Mean / Add & Subtract", "Ratios / Multiply & Divide"),
        Nominal = c("\u2713", "\u2717", "\u2717", "\u2717"),
        Ordinal = c("\u2713", "\u2713", "\u2717*", "\u2717"),
        Interval = c("\u2713", "\u2713", "\u2713", "\u2717"),
        Ratio   = c("\u2713", "\u2713", "\u2713", "\u2713"),
        check.names = FALSE
      )
    }, striped = TRUE, hover = TRUE, spacing = "m", align = "lcccc",
      caption = "* Mean of ordinal data is debatable \u2014 assumes equal spacing between categories.",
      caption.placement = "bottom")

    output$scale_data_preview <- renderTable({
      req(scale_data())
      head(scale_data(), 10)
    }, striped = TRUE, hover = TRUE, spacing = "s")

    # -- Quiz --
    quiz_items <- list(
      list(var = "Eye colour (blue, brown, green, hazel)", answer = "Nominal"),
      list(var = "Olympic medal (gold, silver, bronze)", answer = "Ordinal"),
      list(var = "Temperature in Fahrenheit", answer = "Interval"),
      list(var = "Weight in kilograms", answer = "Ratio"),
      list(var = "Jersey number in sports", answer = "Nominal"),
      list(var = "Pain level (none, mild, moderate, severe)", answer = "Ordinal"),
      list(var = "Year of birth (e.g., 1990)", answer = "Interval"),
      list(var = "Distance in metres", answer = "Ratio"),
      list(var = "Zip / postal code", answer = "Nominal"),
      list(var = "Likert rating (1-5 agree)", answer = "Ordinal"),
      list(var = "IQ score", answer = "Interval"),
      list(var = "Number of children", answer = "Ratio"),
      list(var = "Military rank", answer = "Ordinal"),
      list(var = "pH level", answer = "Interval"),
      list(var = "Annual income in dollars", answer = "Ratio"),
      list(var = "Favourite music genre", answer = "Nominal")
    )

    current_quiz <- reactiveVal(NULL)

    observe({
      current_quiz(quiz_items[[sample.int(length(quiz_items), 1)]])
    }) |> bindEvent(TRUE, once = TRUE)

    output$quiz_variable <- renderUI({
      req(current_quiz())
      tags$p(tags$strong("Variable: "), current_quiz()$var,
             style = "font-size: 0.95rem; margin-top: 0.5rem;")
    })

    observeEvent(input$quiz_check, {
      req(current_quiz())
      correct <- current_quiz()$answer
      chosen  <- input$quiz_answer

      if (chosen == correct) {
        output$quiz_feedback <- renderUI(
          tags$div(class = "alert alert-success mt-2 py-2",
                   icon("check"), " Correct! It\u2019s ", tags$strong(correct), ".")
        )
      } else {
        output$quiz_feedback <- renderUI(
          tags$div(class = "alert alert-danger mt-2 py-2",
                   icon("xmark"), " Not quite. The answer is ",
                   tags$strong(correct), ".")
        )
      }
      # Load next question
      current_quiz(quiz_items[[sample.int(length(quiz_items), 1)]])
    })

    # ====================================================================
    # Tab 2: Types of Validity
    # ====================================================================

    val_data <- reactiveVal(NULL)

    observeEvent(input$val_gen, {
      set.seed(sample.int(10000, 1))
      vtype <- input$validity_type

      result <- switch(vtype,
        "content" = {
          n_exp   <- input$val_n_experts
          n_items <- input$val_n_items
          ratings <- matrix(sample(1:4, n_exp * n_items, replace = TRUE,
                                   prob = c(0.10, 0.15, 0.35, 0.40)),
                            nrow = n_items, ncol = n_exp)
          colnames(ratings) <- paste0("Expert_", seq_len(n_exp))
          rownames(ratings) <- paste0("Item_", seq_len(n_items))
          item_cvi <- rowMeans(ratings >= 3)
          list(type = "content", ratings = ratings, item_cvi = item_cvi,
               scale_cvi = mean(item_cvi))
        },
        "concurrent" = , "predictive" = {
          n <- input$val_n
          r <- input$val_r
          x <- rnorm(n)
          y <- r * x + sqrt(1 - r^2) * rnorm(n)
          obs_r <- cor(x, y)
          list(type = vtype, x = x, y = y, n = n, true_r = r, obs_r = obs_r)
        },
        "construct" = {
          conv_r <- input$val_conv_r
          disc_r <- input$val_disc_r
          labels <- c("Trait1_Method1", "Trait1_Method2",
                      "Trait2_Method1", "Trait2_Method2")
          R_mat <- diag(4)
          R_mat[1, 2] <- R_mat[2, 1] <- conv_r
          R_mat[3, 4] <- R_mat[4, 3] <- conv_r
          R_mat[1, 3] <- R_mat[3, 1] <- disc_r
          R_mat[2, 4] <- R_mat[4, 2] <- disc_r
          R_mat[1, 4] <- R_mat[4, 1] <- disc_r * 0.5
          R_mat[2, 3] <- R_mat[3, 2] <- disc_r * 0.5
          rownames(R_mat) <- colnames(R_mat) <- labels
          list(type = "construct", R_mat = R_mat, conv_r = conv_r, disc_r = disc_r)
        },
        "face" = list(type = "face"),
        "ecological" = list(type = "ecological")
      )
      val_data(result)
    }, ignoreNULL = FALSE)

    output$val_title <- renderText({
      vtype <- input$validity_type
      switch(vtype,
        "content"    = "Content Validity: Expert Rating Heatmap",
        "concurrent" = "Concurrent Validity: Test vs. Criterion",
        "predictive" = "Predictive Validity: Test vs. Future Outcome",
        "construct"  = "Construct Validity: MTMM Correlation Matrix",
        "face"       = "Face Validity",
        "ecological" = "Ecological Validity"
      )
    })

    output$val_plot <- renderPlotly({
      req(val_data())
      d <- val_data()

      if (d$type == "content") {
        ratings_df <- as.data.frame(as.table(d$ratings))
        names(ratings_df) <- c("Item", "Expert", "Rating")
        ratings_df$Rating <- as.numeric(as.character(ratings_df$Rating))
        rating_labels <- c("1: Not relevant", "2: Somewhat", "3: Relevant", "4: Highly relevant")
        ratings_df$Label <- rating_labels[ratings_df$Rating]

        plotly::plot_ly(
          data = ratings_df,
          x = ~Expert, y = ~Item, z = ~Rating,
          type = "heatmap", xgap = 2, ygap = 2,
          colorscale = list(
            list(0, "#dc322f"), list(0.33, "#cb4b16"),
            list(0.66, "#b58900"), list(1, "#2aa198")
          ),
          zmin = 1, zmax = 4,
          text = ~Label, hovertemplate = "%{y}, %{x}<br>%{text}<extra></extra>",
          colorbar = list(
            title = "Rating", tickvals = 1:4,
            ticktext = c("1: Not rel.", "2: Somewhat", "3: Relevant", "4: Highly rel.")
          )
        ) |>
          .meas_layout(
            xaxis = list(title = ""),
            yaxis = list(title = "", autorange = "reversed"),
            margin = list(t = 50, l = 80),
            annotations = list(list(
              x = 0.5, y = 1.06, xref = "paper", yref = "paper",
              text = sprintf("Content Validity Index (S-CVI = %.2f)", d$scale_cvi),
              showarrow = FALSE, font = list(size = 14)
            ))
          )

      } else if (d$type %in% c("concurrent", "predictive")) {
        label <- if (d$type == "concurrent") "Established Criterion" else "Future Outcome"
        df_plot <- data.frame(Test = d$x, Criterion = d$y)
        fit <- lm(Criterion ~ Test, data = df_plot)
        x_seq <- seq(min(df_plot$Test), max(df_plot$Test), length.out = 100)
        pred  <- predict(fit, newdata = data.frame(Test = x_seq), interval = "confidence")

        plotly::plot_ly() |>
          plotly::add_trace(
            data = df_plot, x = ~Test, y = ~Criterion,
            type = "scatter", mode = "markers",
            marker = list(color = "rgba(38,139,210,0.5)", size = 7),
            name = "Observations",
            hovertemplate = "Test: %{x:.2f}<br>Criterion: %{y:.2f}<extra></extra>"
          ) |>
          plotly::add_trace(
            x = x_seq, y = pred[, "fit"],
            type = "scatter", mode = "lines",
            line = list(color = "#dc322f", width = 2),
            name = "Regression line", hoverinfo = "skip"
          ) |>
          plotly::add_ribbons(
            x = x_seq, ymin = pred[, "lwr"], ymax = pred[, "upr"],
            fillcolor = "rgba(220,50,47,0.15)",
            line = list(color = "transparent"),
            name = "95% CI", hoverinfo = "skip"
          ) |>
          .meas_layout(
            xaxis = list(title = "Test Score (standardised)"),
            yaxis = list(title = label),
            margin = list(t = 50),
            showlegend = FALSE,
            annotations = list(list(
              x = 0.5, y = 1.06, xref = "paper", yref = "paper",
              text = sprintf("r = %.3f  (true r = %.2f, n = %d)", d$obs_r, d$true_r, d$n),
              showarrow = FALSE, font = list(size = 14)
            ))
          )

      } else if (d$type == "construct") {
        labels <- rownames(d$R_mat)
        plotly::plot_ly(
          x = labels, y = labels, z = d$R_mat,
          type = "heatmap", xgap = 2, ygap = 2,
          colorscale = list(
            list(0, "#268bd2"), list(0.5, "#fdf6e3"), list(1, "#dc322f")
          ),
          zmin = 0, zmax = 1,
          hovertemplate = "%{y} \u00d7 %{x}<br>r = %{z:.2f}<extra></extra>",
          colorbar = list(title = "r")
        ) |>
          .meas_layout(
            xaxis = list(title = "", tickangle = -35),
            yaxis = list(title = "", autorange = "reversed"),
            margin = list(t = 60, l = 120, b = 100),
            annotations = list(list(
              x = 0.5, y = 1.10, xref = "paper", yref = "paper",
              text = sprintf("MTMM Matrix  |  Convergent r = %.2f  |  Discriminant r = %.2f",
                             d$conv_r, d$disc_r),
              showarrow = FALSE, font = list(size = 13)
            ))
          )

      } else {
        # Face / Ecological — informational text
        msg <- if (d$type == "face") {
          "Face validity is assessed qualitatively.\nDoes the test look like it measures what it claims?\n\nNo numerical simulation \u2014\nit depends on subjective judgement."
        } else {
          "Ecological validity concerns generalisability\nto real-world settings.\n\nDoes performance on this lab task\npredict behaviour in everyday life?"
        }
        plotly::plot_ly() |>
          plotly::add_annotations(
            x = 0.5, y = 0.5, text = msg,
            showarrow = FALSE, xref = "paper", yref = "paper",
            font = list(size = 16, color = "#657b83")
          ) |>
          .meas_layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            margin = list(t = 20, b = 20)
          )
      }
    })

    output$val_interpretation <- renderUI({
      req(val_data())
      d <- val_data()

      if (d$type == "content") {
        poor_items <- names(d$item_cvi[d$item_cvi < 0.78])
        tags$div(
          tags$p(sprintf("Scale-level CVI (S-CVI/Ave) = %.2f. A threshold of 0.90 is commonly used.", d$scale_cvi)),
          tags$p(sprintf("Item-level CVI (I-CVI) threshold: 0.78 (Lynn, 1986).")),
          if (length(poor_items) > 0)
            tags$p(class = "text-warning",
                   sprintf("Items below 0.78: %s. Consider revising or removing.", paste(poor_items, collapse = ", ")))
          else
            tags$p(class = "text-success", "All items meet the 0.78 I-CVI threshold.")
        )
      } else if (d$type %in% c("concurrent", "predictive")) {
        label <- if (d$type == "concurrent") "concurrent" else "predictive"
        strength <- if (abs(d$obs_r) >= 0.7) "strong" else if (abs(d$obs_r) >= 0.4) "moderate" else "weak"
        tags$div(
          tags$p(sprintf("Observed r = %.3f indicates %s %s validity evidence.", d$obs_r, strength, label)),
          tags$p(sprintf("Shared variance (r\u00b2) = %.1f%% of criterion variance explained by the test.",
                         d$obs_r^2 * 100)),
          tags$p("Note: criterion validity coefficients are attenuated by unreliability in both measures. Correction for attenuation may be appropriate.")
        )
      } else if (d$type == "construct") {
        good <- d$conv_r > d$disc_r
        tags$div(
          tags$p(sprintf("Convergent r = %.2f, Discriminant r = %.2f.", d$conv_r, d$disc_r)),
          if (good)
            tags$p(class = "text-success",
                   "Convergent > Discriminant: This pattern supports construct validity (same-trait correlations exceed different-trait correlations).")
          else
            tags$p(class = "text-danger",
                   "Warning: Discriminant r \u2265 Convergent r. This pattern does NOT support construct validity \u2014 different constructs correlate as strongly as (or more than) the same construct across methods.")
        )
      } else if (d$type == "face") {
        tags$div(
          tags$p("Face validity is the ", tags$em("apparent"), " relevance of a test to its intended purpose."),
          tags$p("Strengths: Increases respondent motivation and buy-in."),
          tags$p("Limitations: Not a formal psychometric property. A test can have high face validity but measure the wrong thing (or vice versa).")
        )
      } else {
        tags$div(
          tags$p("Ecological validity asks: do findings from this measurement context transfer to the real world?"),
          tags$p("Example: A memory test in a quiet lab may not predict memory performance in a noisy classroom."),
          tags$p("Maximised through representative design, naturalistic stimuli, and field studies.")
        )
      }
    })

    # ====================================================================
    # Tab 3: Types of Reliability
    # ====================================================================

    rel_data <- reactiveVal(NULL)

    observeEvent(input$rel_gen, {
      set.seed(sample.int(10000, 1))
      rtype <- input$rel_type
      n     <- input$rel_n
      rho   <- input$rel_true_r

      result <- switch(rtype,
        "retest" = {
          true_scores <- rnorm(n)
          error_sd <- sqrt((1 - rho) / rho)
          t1 <- true_scores + rnorm(n, sd = error_sd)
          t2 <- true_scores + rnorm(n, sd = error_sd)
          obs_r <- cor(t1, t2)
          list(type = "retest", t1 = t1, t2 = t2, obs_r = obs_r, true_r = rho, n = n)
        },
        "alpha" = {
          k <- input$rel_n_items
          r_bar <- rho / (k - rho * (k - 1))
          r_bar <- max(min(r_bar, 0.99), 0.01)
          Sigma <- matrix(r_bar, k, k)
          diag(Sigma) <- 1
          items <- MASS::mvrnorm(n, mu = rep(0, k), Sigma = Sigma)
          alpha_hat <- k / (k - 1) * (1 - sum(apply(items, 2, var)) / var(rowSums(items)))
          avg_r <- mean(cor(items)[lower.tri(cor(items))])
          list(type = "alpha", items = items, alpha_hat = alpha_hat,
               avg_r = avg_r, k = k, true_alpha = rho, n = n)
        },
        "interrater" = {
          n_raters <- input$rel_n_raters
          n_cats   <- input$rel_n_categories
          true_cats <- sample(seq_len(n_cats), n, replace = TRUE)
          ratings <- matrix(NA, n, n_raters)
          for (j in seq_len(n_raters)) {
            agree <- rbinom(n, 1, prob = rho)
            random_cats <- sample(seq_len(n_cats), n, replace = TRUE)
            ratings[, j] <- ifelse(agree, true_cats, random_cats)
          }
          colnames(ratings) <- paste0("Rater_", seq_len(n_raters))
          tbl <- table(factor(ratings[, 1], levels = seq_len(n_cats)),
                       factor(ratings[, 2], levels = seq_len(n_cats)))
          po <- sum(diag(tbl)) / sum(tbl)
          pe <- sum(rowSums(tbl) * colSums(tbl)) / sum(tbl)^2
          kappa <- (po - pe) / (1 - pe)
          list(type = "interrater", ratings = ratings, kappa = kappa,
               po = po, pe = pe, true_r = rho, n = n, n_raters = n_raters,
               n_cats = n_cats)
        },
        "parallel" = {
          true_scores <- rnorm(n)
          error_sd <- sqrt((1 - rho) / rho)
          form_a <- true_scores + rnorm(n, sd = error_sd)
          form_b <- true_scores + rnorm(n, sd = error_sd)
          obs_r <- cor(form_a, form_b)
          list(type = "parallel", form_a = form_a, form_b = form_b,
               obs_r = obs_r, true_r = rho, n = n)
        }
      )
      rel_data(result)
    }, ignoreNULL = FALSE)

    output$rel_title <- renderText({
      switch(input$rel_type,
        "retest"     = "Test-Retest Reliability",
        "alpha"      = "Internal Consistency (Cronbach's \u03b1)",
        "interrater" = "Inter-Rater Reliability",
        "parallel"   = "Parallel Forms Reliability"
      )
    })

    output$rel_plot <- renderPlotly({
      req(rel_data())
      d <- rel_data()

      if (d$type == "retest") {
        df_plot <- data.frame(Time1 = d$t1, Time2 = d$t2)
        rng <- range(c(d$t1, d$t2))

        plotly::plot_ly() |>
          plotly::add_trace(
            data = df_plot, x = ~Time1, y = ~Time2,
            type = "scatter", mode = "markers",
            marker = list(color = "rgba(38,139,210,0.5)", size = 7),
            name = "Observations",
            hovertemplate = "T1: %{x:.2f}<br>T2: %{y:.2f}<extra></extra>"
          ) |>
          plotly::add_trace(
            x = rng, y = rng,
            type = "scatter", mode = "lines",
            line = list(color = "#839496", width = 1, dash = "dash"),
            name = "Perfect agreement", hoverinfo = "skip"
          ) |>
          .meas_layout(
            xaxis = list(title = "Time 1 Score"),
            yaxis = list(title = "Time 2 Score",
                         scaleanchor = "x", scaleratio = 1),
            showlegend = FALSE,
            margin = list(t = 50),
            annotations = list(list(
              x = 0.5, y = 1.06, xref = "paper", yref = "paper",
              text = sprintf("Test-Retest: r = %.3f  (true \u03C1 = %.2f)", d$obs_r, d$true_r),
              showarrow = FALSE, font = list(size = 14)
            ))
          )

      } else if (d$type == "alpha") {
        cor_mat <- cor(d$items)
        item_labels <- paste0("Item", seq_len(ncol(d$items)))
        colnames(cor_mat) <- rownames(cor_mat) <- item_labels

        plotly::plot_ly(
          x = item_labels, y = item_labels, z = cor_mat,
          type = "heatmap", xgap = 2, ygap = 2,
          colorscale = list(
            list(0, "#268bd2"), list(0.5, "#fdf6e3"), list(1, "#dc322f")
          ),
          zmin = -1, zmax = 1,
          hovertemplate = "%{y} \u00d7 %{x}<br>r = %{z:.2f}<extra></extra>",
          colorbar = list(title = "r")
        ) |>
          .meas_layout(
            xaxis = list(title = ""),
            yaxis = list(title = "", autorange = "reversed"),
            margin = list(t = 60, l = 60, b = 60),
            annotations = list(list(
              x = 0.5, y = 1.10, xref = "paper", yref = "paper",
              text = sprintf("\u03b1 = %.3f  (target = %.2f)  |  Avg inter-item r = %.3f",
                             d$alpha_hat, d$true_alpha, d$avg_r),
              showarrow = FALSE, font = list(size = 14)
            ))
          )

      } else if (d$type == "interrater") {
        n_cats <- d$n_cats
        tbl <- table(factor(d$ratings[, 1], levels = seq_len(n_cats)),
                     factor(d$ratings[, 2], levels = seq_len(n_cats)))
        tbl_mat <- as.matrix(tbl)
        cat_labels <- as.character(seq_len(n_cats))

        plotly::plot_ly(
          x = cat_labels, y = cat_labels, z = tbl_mat,
          type = "heatmap", xgap = 2, ygap = 2,
          colorscale = list(list(0, "#fdf6e3"), list(1, "#2aa198")),
          hovertemplate = "Rater 1: %{y}<br>Rater 2: %{x}<br>Count: %{z}<extra></extra>",
          colorbar = list(title = "Count")
        ) |>
          .meas_layout(
            xaxis = list(title = "Rater 2"),
            yaxis = list(title = "Rater 1", autorange = "reversed"),
            margin = list(t = 50),
            annotations = list(list(
              x = 0.5, y = 1.06, xref = "paper", yref = "paper",
              text = sprintf("Rater Agreement: \u03ba = %.3f", d$kappa),
              showarrow = FALSE, font = list(size = 14)
            ))
          )

      } else if (d$type == "parallel") {
        df_plot <- data.frame(FormA = d$form_a, FormB = d$form_b)
        rng <- range(c(d$form_a, d$form_b))

        plotly::plot_ly() |>
          plotly::add_trace(
            data = df_plot, x = ~FormA, y = ~FormB,
            type = "scatter", mode = "markers",
            marker = list(color = "rgba(108,113,196,0.5)", size = 7),
            name = "Observations",
            hovertemplate = "Form A: %{x:.2f}<br>Form B: %{y:.2f}<extra></extra>"
          ) |>
          plotly::add_trace(
            x = rng, y = rng,
            type = "scatter", mode = "lines",
            line = list(color = "#839496", width = 1, dash = "dash"),
            name = "Perfect agreement", hoverinfo = "skip"
          ) |>
          .meas_layout(
            xaxis = list(title = "Form A Score"),
            yaxis = list(title = "Form B Score",
                         scaleanchor = "x", scaleratio = 1),
            showlegend = FALSE,
            margin = list(t = 50),
            annotations = list(list(
              x = 0.5, y = 1.06, xref = "paper", yref = "paper",
              text = sprintf("Parallel Forms: r = %.3f  (true \u03C1 = %.2f)", d$obs_r, d$true_r),
              showarrow = FALSE, font = list(size = 14)
            ))
          )
      }
    })

    output$rel_summary <- renderUI({
      req(rel_data())
      d <- rel_data()

      if (d$type == "retest") {
        tags$div(
          tags$p(sprintf("Observed test-retest r = %.3f (true \u03C1 = %.2f, n = %d).",
                         d$obs_r, d$true_r, d$n)),
          tags$p("The dashed line shows perfect agreement (slope = 1). Deviation from this line reflects measurement error."),
          tags$p(sprintf("Standard Error of Measurement (SEM) \u2248 SD \u00d7 \u221a(1 \u2013 r) = %.3f",
                         sd(d$t1) * sqrt(1 - d$obs_r)))
        )
      } else if (d$type == "alpha") {
        tags$div(
          tags$p(sprintf("Cronbach's \u03b1 = %.3f (target = %.2f) based on %d items, n = %d.",
                         d$alpha_hat, d$true_alpha, d$k, d$n)),
          tags$p(sprintf("Average inter-item correlation = %.3f.", d$avg_r)),
          if (d$alpha_hat < 0.70)
            tags$p(class = "text-warning", "Below the conventional 0.70 threshold. Consider adding items or revising low-correlation items.")
          else if (d$alpha_hat > 0.95)
            tags$p(class = "text-info", "Very high \u03b1 may indicate item redundancy. Consider whether fewer items could suffice.")
          else
            tags$p(class = "text-success", "Acceptable internal consistency.")
        )
      } else if (d$type == "interrater") {
        strength <- if (d$kappa >= 0.81) "almost perfect"
                    else if (d$kappa >= 0.61) "substantial"
                    else if (d$kappa >= 0.41) "moderate"
                    else if (d$kappa >= 0.21) "fair"
                    else "slight"
        tags$div(
          tags$p(sprintf("Cohen's \u03ba = %.3f (%s agreement; Landis & Koch, 1977).", d$kappa, strength)),
          tags$p(sprintf("Observed agreement (P\u2092) = %.1f%%, Expected by chance (P\u2091) = %.1f%%.",
                         d$po * 100, d$pe * 100)),
          tags$p("See the Interrater Reliability module for weighted \u03ba and the prevalence paradox.",
                 style = "font-size: 0.85rem; color: #657b83;")
        )
      } else if (d$type == "parallel") {
        tags$div(
          tags$p(sprintf("Parallel forms r = %.3f (true \u03C1 = %.2f, n = %d).",
                         d$obs_r, d$true_r, d$n)),
          tags$p("Parallel forms reliability avoids memory/practice effects that can inflate test-retest estimates."),
          tags$p("The cost: developing two truly equivalent forms is labour-intensive and requires careful item matching.")
        )
      }
    })

  })
}
