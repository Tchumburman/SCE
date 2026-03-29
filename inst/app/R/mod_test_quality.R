# Module: Test & Item Quality (consolidated)
# Tabs: Item Analysis | Reliability | Dimensionality | Scale Development

# ── UI ──────────────────────────────────────────────────────────────────
test_quality_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Test & Item Quality",
  icon = icon("microscope"),
  navset_card_underline(

    # ── Tab 1: Item Analysis ──────────────────────────────────────────
    nav_panel(
      "Item Analysis",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ia_items"), "Number of items", min = 5, max = 40, value = 15, step = 1),
          sliderInput(ns("ia_n"), "Number of examinees", min = 50, max = 2000, value = 500, step = 50),
          sliderInput(ns("ia_options"), "Answer options per item", min = 3, max = 5, value = 4, step = 1),
          sliderInput(ns("ia_ability_mean"), "Mean ability", min = -2, max = 2, value = 0, step = 0.25),
          actionButton(ns("ia_go"), "Generate Test Data", class = "btn-success w-100 mb-2"),
          actionButton(ns("ia_reset"), "Reset", class = "btn-outline-secondary w-100")
        ),
        explanation_box(
          tags$strong("Item Analysis"),
          tags$p("Item analysis evaluates the quality of individual test items using
                  classical test theory statistics. Key metrics include: item difficulty
                  (p-value: proportion correct), item discrimination (point-biserial
                  correlation between item score and total), and distractor analysis
                  (how often each incorrect option is chosen by low vs. high scorers)."),
          tags$p("Good items have moderate difficulty (p \u2248 0.30\u20130.70 for maximum
                  discrimination) and high point-biserial correlations (r_pb > 0.30). Items
                  with negative r_pb are problematic \u2014 they are answered correctly more
                  often by low-ability examinees, suggesting keying errors, ambiguity, or
                  flawed content."),
          tags$p("Distractor analysis reveals whether incorrect options are functioning as
                  intended. Effective distractors are chosen more frequently by low-scoring
                  examinees; non-functional distractors (chosen by nobody, or equally across
                  ability levels) should be revised to improve the item\u2019s discrimination."),
          tags$p("Good items have moderate difficulty (0.3\u20130.7), high discrimination
                  (\u2265 0.30), and distractors that are chosen by low-ability examinees
                  rather than high-ability ones."),
          guide = tags$ol(
            tags$li("Set the number of items, examinees, and answer options."),
            tags$li("Click 'Generate Test Data' to simulate a multiple-choice test."),
            tags$li("Review the item statistics table for difficulty and discrimination."),
            tags$li("The scatter plot maps difficulty vs. discrimination — ideal items are in the upper-middle."),
            tags$li("Select an item from the dropdown to see its distractor analysis.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Item Statistics"), tableOutput(ns("ia_stats_table"))),
            card(full_screen = TRUE, card_header("Difficulty vs. Discrimination"),
                 plotlyOutput(ns("ia_scatter"), height = "350px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(
              card_header("Distractor Analysis"),
              selectInput(ns("ia_item_select"), "Select item", choices = NULL),
              plotlyOutput(ns("ia_distractor_plot"), height = "300px")
            ),
            card(full_screen = TRUE, card_header("Score Distribution"),
                 plotlyOutput(ns("ia_score_hist"), height = "300px"))
          )
        )
      )
    ),

    # ── Tab 2: Reliability ────────────────────────────────────────────
    nav_panel(
      "Reliability",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("rel_items"), "Number of items", min = 3, max = 30, value = 10, step = 1),
          sliderInput(ns("rel_n"), "Sample size", min = 50, max = 1000, value = 300, step = 50),
          sliderInput(ns("rel_avg_r"), "Average inter-item correlation", min = 0.05, max = 0.9,
                      value = 0.35, step = 0.05),
          sliderInput(ns("rel_loading_var"), "Loading variability", min = 0, max = 0.3,
                      value = 0.1, step = 0.05),
          actionButton(ns("rel_go"), "Simulate & Compute", class = "btn-success w-100 mb-2"),
          actionButton(ns("rel_reset"), "Reset", class = "btn-outline-secondary w-100")
        ),
        explanation_box(
          tags$strong("Reliability Estimation"),
          tags$p("Reliability measures the consistency of a test. Different methods
                  make different assumptions: Cronbach's \u03b1 assumes essentially
                  tau-equivalent items (equal loadings); McDonald's \u03c9 uses a
                  factor model and handles unequal loadings correctly; split-half
                  depends on which halves are chosen; and Spearman-Brown predicts
                  how reliability changes with test length."),
          tags$p("When loadings are equal, \u03b1 \u2248 \u03c9. When loadings vary,
                  \u03b1 underestimates reliability and \u03c9 is preferred. This is
                  important because most real-world tests have items with varying
                  discrimination, making \u03c9 the more accurate estimate in practice."),
          tags$p("Reliability should always be interpreted in context. A reliability of 0.70
                  may be acceptable for group-level research (comparing group means) but
                  inadequate for individual-level decisions (clinical diagnosis, selection).
                  For high-stakes individual decisions, reliabilities of 0.90 or above are
                  typically expected. The Spearman-Brown formula shows that reliability can
                  be improved by increasing test length, though with diminishing returns."),
          tags$p("It is also important to distinguish between internal consistency (\u03b1, \u03c9),
                  test-retest reliability (stability over time), and inter-rater reliability
                  (agreement between raters). These address different sources of measurement
                  error and may yield different values for the same test."),
          guide = tags$ol(
            tags$li("Set the number of items and average inter-item correlation."),
            tags$li("Increase 'Loading variability' to make item loadings unequal."),
            tags$li("Click 'Simulate & Compute' to generate item-level data and estimate all reliability indices."),
            tags$li("Compare \u03b1 vs. \u03c9 — they diverge when loading variability is high."),
            tags$li("The Spearman-Brown plot shows how adding or removing items would affect reliability.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Reliability Estimates"), uiOutput(ns("rel_table"))),
            card(full_screen = TRUE, card_header("Inter-Item Correlation Matrix"),
                 plotlyOutput(ns("rel_heatmap"), height = "350px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Spearman-Brown Prophecy"),
                 plotlyOutput(ns("rel_sb_plot"), height = "340px")),
            card(full_screen = TRUE, card_header("Item Loadings"),
                 plotlyOutput(ns("rel_loadings_plot"), height = "340px"))
          )
        )
      )
    ),

    # ── Tab 3: Dimensionality ─────────────────────────────────────────
    nav_panel(
      "Dimensionality",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("dim_n"), "Sample size", min = 100, max = 1000,
                      value = 500, step = 100),
          sliderInput(ns("dim_items"), "Number of items", min = 10, max = 40,
                      value = 20, step = 5),
          sliderInput(ns("dim_true"), "True dimensions", min = 1, max = 5,
                      value = 3, step = 1),
          sliderInput(ns("dim_loading"), "Average loading", min = 0.3, max = 0.9,
                      value = 0.6, step = 0.05),
          actionButton(ns("dim_go"), "Analyze", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Dimensionality Assessment"),
          tags$p("Before fitting IRT or factor models, it is essential to determine
                  how many dimensions the data support. Unidimensional models applied to
                  multidimensional data can produce biased parameter estimates and misleading
                  scores."),
          tags$p("Parallel analysis is generally the most reliable method for determining
                  the number of factors. It compares observed eigenvalues to those obtained
                  from random data with the same dimensions, retaining only factors whose
                  eigenvalues exceed the random baseline. MAP (Minimum Average Partial)
                  and BIC-based criteria provide additional perspectives. When methods
                  disagree, consider theoretical expectations and interpretability."),
          tags$ul(
            tags$li(tags$strong("Parallel analysis:"), " Compares observed eigenvalues to those from random data with the same dimensions. Retains factors with eigenvalues above the random threshold."),
            tags$li(tags$strong("MAP (Minimum Average Partial):"), " Extracts components sequentially; stops when average squared partial correlation is minimized."),
            tags$li(tags$strong("Scree plot + Kaiser rule:"), " Retain factors with eigenvalues > 1. Often over-extracts.")
          ),
          tags$p("Dimensionality assessment is not just a preliminary step \u2014 it has
                  substantive implications. If a test that was designed to be unidimensional
                  turns out to have multiple dimensions, this may indicate that it measures
                  distinct constructs that should be scored separately. Conversely, if a
                  multidimensional instrument shows a strong general factor, a total score
                  may be justified alongside subscale scores."),
          guide = tags$ol(
            tags$li("Set sample size, items, and true dimensions."),
            tags$li("Click 'Analyze' to run parallel analysis and MAP."),
            tags$li("Compare the suggested number of dimensions from each method."),
            tags$li("Parallel analysis (red dashed) is generally the most accurate.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Parallel Analysis Scree Plot"),
               plotlyOutput(ns("dim_scree"), height = "380px")),
          card(card_header("Dimensionality Estimates"), tableOutput(ns("dim_table")))
        )
      )
    ),

    # ── Tab 4: Scale Development ──────────────────────────────────────
    nav_panel(
      "Scale Development",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sd_n"), "Sample size", min = 100, max = 1000, value = 300, step = 100),
          sliderInput(ns("sd_items"), "Initial item pool", min = 15, max = 40, value = 20, step = 5),
          sliderInput(ns("sd_factors"), "True factors", min = 1, max = 4, value = 3, step = 1),
          sliderInput(ns("sd_loading"), "Average loading", min = 0.4, max = 0.9, value = 0.7, step = 0.05),
          actionButton(ns("sd_go"), "Run workflow", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Scale Development Workflow"),
          tags$p("Building a psychometric scale follows a systematic process that
                  iterates between theoretical specification and empirical evaluation.
                  Rigorous scale development typically requires multiple samples and rounds
                  of revision."),
          tags$p("A critical principle is that items should be developed and validated on
                  separate samples. Capitalisation on chance \u2014 selecting items that happen
                  to perform well in one sample \u2014 produces optimistic estimates of reliability
                  and validity that fail to replicate. Cross-validation is essential."),
          tags$ol(
            tags$li("Generate an item pool."),
            tags$li("Compute item-total correlations; drop weak items."),
            tags$li("Run EFA to discover factor structure."),
            tags$li("Check reliability (\u03b1) for each subscale."),
            tags$li("Report final scale properties.")
          ),
          tags$p("This module simulates the full workflow end-to-end.")
        ),
        navset_card_underline(
          nav_panel("Item Analysis",
            tableOutput(ns("sd_item_stats"))
          ),
          nav_panel("EFA",
            plotlyOutput(ns("sd_scree"), height = "300px"),
            tableOutput(ns("sd_loadings"))
          ),
          nav_panel("Reliability",
            tableOutput(ns("sd_reliability"))
          ),
          nav_panel("Final Scale",
            tableOutput(ns("sd_final"))
          )
        )
      )
    ),

    # ── Tab 5: Test-Retest & Alternate-Forms Reliability ────────────────
    nav_panel(
      "Test-Retest",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("rrt_n"), "Sample size", min = 50, max = 500, value = 200, step = 50),
          sliderInput(ns("rrt_items"), "Items per form", min = 5, max = 30, value = 10, step = 1),
          sliderInput(ns("rrt_true_r"), "True score correlation", min = 0.50, max = 1.0,
                      value = 0.90, step = 0.05),
          sliderInput(ns("rrt_error_sd"), "Error SD (per occasion)", min = 0.5, max = 3,
                      value = 1.5, step = 0.25),
          selectInput(ns("rrt_design"), "Design",
                      choices = c("Test-Retest (same form)" = "retest",
                                  "Alternate Forms" = "altform")),
          conditionalPanel(ns = ns, 
            "input.rrt_design === 'altform'",
            sliderInput(ns("rrt_form_diff"), "Form difficulty shift", min = -1, max = 1,
                        value = 0.0, step = 0.1)
          ),
          actionButton(ns("rrt_go"), "Simulate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Test-Retest & Alternate-Forms Reliability"),
          tags$p("Internal consistency (\u03b1, \u03c9) captures only one source of
                  measurement error. Test-retest reliability assesses stability over
                  time by administering the same test twice. Alternate-forms reliability
                  assesses equivalence by giving two parallel versions."),
          tags$p("The correlation between occasions estimates reliability, but it conflates
                  true stability with measurement error. If the construct genuinely changes
                  between occasions, the test-retest correlation underestimates reliability.
                  A Bland-Altman plot helps distinguish systematic bias (mean shift) from
                  random error (spread of differences)."),
          tags$p("For alternate forms, a difficulty shift between forms introduces systematic
                  error that lowers the correlation. The SEM (Standard Error of Measurement)
                  derived from reliability provides a confidence band around any individual
                  score: SEM = SD \u00d7 \u221a(1 \u2212 r)."),
          tags$p("It is important to distinguish between two sources of variance that reduce
                  temporal reliability: transient error (random fluctuation from moment to
                  moment, such as fatigue or distraction on the day of testing) and specific
                  factor variance (stable but construct-irrelevant characteristics of the
                  person, such as familiarity with a particular item format). Test-retest
                  correlations confound both with true score variance, which is why increasing
                  the retest interval generally lowers the observed correlation \u2014 the
                  true construct may genuinely change over time."),
          tags$p("The Bland-Altman plot is a more informative diagnostic than a simple
                  scatter plot for assessing agreement between two measurement occasions.
                  It shows whether systematic bias exists (a non-zero mean difference,
                  indicating one occasion consistently yields higher scores than the other)
                  and whether the spread of differences is constant across the score range
                  (heteroscedasticity would appear as a fan shape). The 95% limits of
                  agreement (\u00b1 1.96 \u00d7 SD of differences) define the range within
                  which 95% of individual differences are expected to fall."),
          guide = tags$ol(
            tags$li("Set sample size, items, and the true score correlation."),
            tags$li("Choose Test-Retest or Alternate Forms."),
            tags$li("Click 'Simulate' to generate two administrations."),
            tags$li("The scatter plot shows the two scores; the Bland-Altman plot reveals bias and error spread."),
            tags$li("Try increasing error SD or adding a form difficulty shift to see the impact.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Score Scatter (Time 1 vs Time 2)"),
                 plotlyOutput(ns("rrt_scatter"), height = "380px")),
            card(full_screen = TRUE, card_header("Bland-Altman Plot"),
                 plotlyOutput(ns("rrt_bland_altman"), height = "380px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Reliability Summary"), tableOutput(ns("rrt_summary"))),
            card(full_screen = TRUE, card_header("Measurement Error Distribution"),
                 plotlyOutput(ns("rrt_error_hist"), height = "300px"))
          )
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

test_quality_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Item Analysis ───────────────────────────────────────────────────
  ia_data <- reactiveVal(NULL)

  observeEvent(input$ia_reset, {
    updateSliderInput(session, "ia_items", value = 15)
    updateSliderInput(session, "ia_n", value = 500)
    updateSliderInput(session, "ia_options", value = 4)
    updateSliderInput(session, "ia_ability_mean", value = 0)
    ia_data(NULL)
  })

  observeEvent(input$ia_go, {
    set.seed(sample(1:10000, 1))
    k <- input$ia_items; n <- input$ia_n; opts <- input$ia_options
    theta <- rnorm(n, input$ia_ability_mean, 1)

    b <- sort(runif(k, -2, 2))
    a <- runif(k, 0.6, 2.0)

    scored <- matrix(0L, n, k)
    responses <- matrix(NA_character_, n, k)
    option_labels <- LETTERS[seq_len(opts)]

    for (j in seq_len(k)) {
      p <- 1 / (1 + exp(-a[j] * (theta - b[j])))
      correct <- rbinom(n, 1, p)
      scored[, j] <- correct
      key <- option_labels[((j - 1) %% opts) + 1]
      responses[correct == 1, j] <- key
      wrong_idx <- which(correct == 0)
      distractors <- setdiff(option_labels, key)
      for (idx in wrong_idx) {
        d_probs <- exp(-(seq_along(distractors)) * 0.3 * (theta[idx] + 2))
        d_probs <- d_probs / sum(d_probs)
        responses[idx, j] <- sample(distractors, 1, prob = d_probs)
      }
    }
    colnames(scored) <- colnames(responses) <- paste0("Item", seq_len(k))

    total <- rowSums(scored)
    difficulty <- colMeans(scored)
    rit <- sapply(seq_len(k), function(j) cor(scored[, j], total))
    rir <- sapply(seq_len(k), function(j) cor(scored[, j], total - scored[, j]))

    stats_df <- data.frame(
      Item = paste0("Item", seq_len(k)),
      Difficulty = round(difficulty, 3),
      r_it = round(rit, 3),
      r_ir = round(rir, 3),
      stringsAsFactors = FALSE
    )

    ia_data(list(
      scored = scored, responses = responses, stats = stats_df,
      total = total, theta = theta, k = k, opts = opts,
      option_labels = option_labels
    ))
    updateSelectInput(session, "ia_item_select", choices = paste0("Item", seq_len(k)),
                      selected = "Item1")
  })

  output$ia_stats_table <- renderTable({
    res <- ia_data(); req(res); res$stats
  }, hover = TRUE, spacing = "s", digits = 3)

  output$ia_scatter <- renderPlotly({
    res <- ia_data(); req(res)
    df <- res$stats
    df$Quality <- ifelse(df$r_ir >= 0.3 & df$Difficulty >= 0.2 & df$Difficulty <= 0.8,
                          "Good", "Review")
    y_max <- max(1, max(df$r_ir) + 0.05)
    y_min <- min(0, min(df$r_ir) - 0.05)

    good <- df$Quality == "Good"
    mk_hover <- function(d) paste0(d$Item, "<br>p=", d$Difficulty, " r_ir=", d$r_ir)

    p <- plot_ly()
    if (any(good)) {
      p <- p |> add_trace(x = df$Difficulty[good], y = df$r_ir[good],
                type = "scatter", mode = "markers", name = "Good",
                marker = list(color = "#238b45", size = 9),
                hoverinfo = "text", text = mk_hover(df[good, ]))
    }
    if (any(!good)) {
      p <- p |> add_trace(x = df$Difficulty[!good], y = df$r_ir[!good],
                type = "scatter", mode = "markers", name = "Review",
                marker = list(color = "#e31a1c", size = 9),
                hoverinfo = "text", text = mk_hover(df[!good, ]))
    }
    p |>
      layout(
        xaxis = list(title = "Difficulty (p)", range = c(0, 1)),
        yaxis = list(title = "Discrimination (r_ir)", range = c(y_min, y_max)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05),
        shapes = list(
          list(type = "rect", x0 = 0.2, x1 = 0.8, y0 = 0.3, y1 = y_max,
               fillcolor = "rgba(35, 139, 69, 0.05)",
               line = list(width = 0)),
          list(type = "line", x0 = 0, x1 = 1, y0 = 0.3, y1 = 0.3,
               line = list(color = "rgba(0,0,0,0.4)", dash = "dash", width = 1)),
          list(type = "line", x0 = 0.2, x1 = 0.2, y0 = y_min, y1 = y_max,
               line = list(color = "rgba(0,0,0,0.4)", dash = "dash", width = 1)),
          list(type = "line", x0 = 0.8, x1 = 0.8, y0 = y_min, y1 = y_max,
               line = list(color = "rgba(0,0,0,0.4)", dash = "dash", width = 1))
        ),
        annotations = list(
          list(x = 0.02, xref = "paper", y = 0.3, text = "r_ir = 0.30",
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "grey50")),
          list(x = 0.2, y = 0.02, yref = "paper", text = "p=0.2",
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "grey50")),
          list(x = 0.8, y = 0.02, yref = "paper", text = "p=0.8",
               showarrow = FALSE, xanchor = "right", yanchor = "bottom",
               font = list(size = 9, color = "grey50"))
        )
      )
  })

  output$ia_distractor_plot <- renderPlotly({
    res <- ia_data(); req(res, input$ia_item_select)
    j <- which(colnames(res$responses) == input$ia_item_select)
    req(length(j) == 1)

    thirds <- cut(res$total, breaks = quantile(res$total, c(0, 1/3, 2/3, 1), na.rm = TRUE),
                  labels = c("Low", "Middle", "High"), include.lowest = TRUE)

    resp_j <- res$responses[, j]
    df_d <- data.frame(Response = resp_j, Group = thirds, stringsAsFactors = FALSE)
    df_d <- df_d[!is.na(df_d$Response) & !is.na(df_d$Group), ]

    tab <- as.data.frame(prop.table(table(df_d$Group, df_d$Response), margin = 1))
    names(tab) <- c("Group", "Option", "Proportion")
    tab$Group <- factor(tab$Group, levels = c("Low", "Middle", "High"))

    key <- res$option_labels[((j - 1) %% res$opts) + 1]
    tab$IsKey <- ifelse(tab$Option == key, "Correct", "Distractor")

    set2_colors <- RColorBrewer::brewer.pal(max(3, length(unique(tab$Option))), "Set2")
    opts <- unique(tab$Option)

    p <- plot_ly()
    for (i in seq_along(opts)) {
      d <- tab[tab$Option == opts[i], ]
      opac <- ifelse(d$IsKey[1] == "Correct", 1, 0.55)
      hover <- paste0("Option ", opts[i],
                       ifelse(d$IsKey[1] == "Correct", " (Key)", ""),
                       "<br>Group: ", d$Group,
                       "<br>Proportion: ", round(d$Proportion, 3))
      p <- p |> add_bars(x = d$Group, y = d$Proportion, name = as.character(opts[i]),
                          text = hover, textposition = "none", hoverinfo = "text",
                          marker = list(color = set2_colors[i], opacity = opac))
    }
    p |> layout(
      barmode = "group", bargap = 0.3,
      xaxis = list(title = "Ability Group"),
      yaxis = list(title = "Proportion Choosing"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.08),
      annotations = list(
        list(x = 0.5, y = 1.14, xref = "paper", yref = "paper",
             text = paste0(input$ia_item_select, "  (Key = ", key, ")"),
             showarrow = FALSE, font = list(size = 12))
      ),
      margin = list(t = 50)
    )
  })

  output$ia_score_hist <- renderPlotly({
    res <- ia_data(); req(res)
    score_mean <- mean(res$total)
    bw <- max(1, round(res$k / 15))
    brks <- seq(min(res$total), max(res$total) + bw, by = bw)
    h <- hist(res$total, breaks = brks, plot = FALSE)
    hover <- paste0("Score \u2248 ", round(h$mids, 1), "<br>Count: ", h$counts)

    plot_ly() |>
      add_bars(x = h$mids, y = h$counts, text = hover, textposition = "none",
               hoverinfo = "text", width = bw,
               marker = list(color = "#238b45", opacity = 0.7,
                             line = list(color = "white", width = 0.5)),
               showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Total Score"),
        yaxis = list(title = "Count"),
        bargap = 0.02,
        shapes = list(
          list(type = "line", x0 = score_mean, x1 = score_mean, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Mean = ", round(score_mean, 1),
                              ", SD = ", round(sd(res$total), 1)),
               showarrow = FALSE, font = list(size = 12)),
          list(x = score_mean, y = 1.02, yref = "paper",
               text = paste0("Mean = ", round(score_mean, 1)),
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      )
  })

  # ── Reliability ─────────────────────────────────────────────────────
  rel_data <- reactiveVal(NULL)

  observeEvent(input$rel_reset, {
    updateSliderInput(session, "rel_items", value = 10)
    updateSliderInput(session, "rel_n", value = 300)
    updateSliderInput(session, "rel_avg_r", value = 0.35)
    updateSliderInput(session, "rel_loading_var", value = 0.1)
    rel_data(NULL)
  })

  observeEvent(input$rel_go, {
    set.seed(sample(1:10000, 1))
    k <- input$rel_items; n <- input$rel_n
    avg_r <- input$rel_avg_r; lv <- input$rel_loading_var

    base_load <- sqrt(avg_r)
    loadings <- pmin(pmax(rnorm(k, base_load, lv), 0.15), 0.95)
    Lambda <- matrix(loadings, ncol = 1)
    Sigma <- Lambda %*% t(Lambda)
    diag(Sigma) <- 1

    eig <- eigen(Sigma, symmetric = TRUE)
    eig$values <- pmax(eig$values, 0.01)
    Sigma <- eig$vectors %*% diag(eig$values) %*% t(eig$vectors)
    D <- diag(1 / sqrt(diag(Sigma)))
    Sigma <- D %*% Sigma %*% D

    dat <- MASS::mvrnorm(n, mu = rep(0, k), Sigma = Sigma)
    colnames(dat) <- paste0("Item", seq_len(k))

    item_vars <- apply(dat, 2, var)
    total_var <- var(rowSums(dat))
    alpha <- (k / (k - 1)) * (1 - sum(item_vars) / total_var)

    R <- cor(dat)
    fa_fit <- tryCatch({
      f1 <- factanal(dat, factors = 1, scores = "none")
      lds <- f1$loadings[, 1]
      list(loadings = lds, success = TRUE)
    }, error = function(e) {
      list(loadings = loadings, success = FALSE)
    })
    lds <- fa_fit$loadings
    omega <- sum(lds)^2 / (sum(lds)^2 + sum(1 - lds^2))

    odd <- rowSums(dat[, seq(1, k, 2), drop = FALSE])
    even <- rowSums(dat[, seq(2, k, 2), drop = FALSE])
    r_half <- cor(odd, even)
    split_half <- 2 * r_half / (1 + r_half)

    rel_data(list(dat = dat, R = R, alpha = alpha, omega = omega,
                  split_half = split_half, loadings = lds, k = k))
  })

  output$rel_table <- renderUI({
    res <- rel_data(); req(res)
    div(style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$tr(tags$td(tags$strong("Cronbach's \u03b1")), tags$td(round(res$alpha, 4))),
        tags$tr(tags$td(tags$strong("McDonald's \u03c9")), tags$td(round(res$omega, 4))),
        tags$tr(tags$td(tags$strong("Split-half (Spearman-Brown)")), tags$td(round(res$split_half, 4))),
        tags$tr(tags$td(tags$strong("Number of items")), tags$td(res$k)),
        tags$tr(tags$td(tags$strong("\u03b1 \u2212 \u03c9 difference")),
                tags$td(style = if (abs(res$alpha - res$omega) > 0.02) "color:#e31a1c;font-weight:bold;" else "",
                        round(res$alpha - res$omega, 4)))
      ),
      if (abs(res$alpha - res$omega) > 0.02)
        tags$p(class = "text-muted", "\u03b1 underestimates reliability when loadings are unequal. Prefer \u03c9.")
    )
  })

  output$rel_heatmap <- renderPlotly({
    res <- rel_data(); req(res)
    R <- res$R; nms <- colnames(R); k <- length(nms)
    z_mat <- R[rev(seq_len(k)), ]
    text_mat <- matrix(sprintf("%.2f", as.vector(z_mat)), nrow = k)
    hover_mat <- matrix(
      paste0(rep(rev(nms), k), " × ", rep(nms, each = k),
             "<br>r = ", sprintf("%.3f", as.vector(z_mat))),
      nrow = k)
    plotly::plot_ly(
      z = z_mat, x = nms, y = rev(nms),
      type = "heatmap",
      colorscale = list(c(0, "#dc322f"), c(0.5, "#fdf6e3"), c(1, "#268bd2")),
      zmin = -1, zmax = 1,
      colorbar = list(title = "r"),
      hoverinfo = "text", text = hover_mat
    ) |>
      plotly::add_annotations(
        x = rep(nms, each = k), y = rep(rev(nms), k),
        text = as.vector(text_mat),
        showarrow = FALSE,
        font = list(size = 10, color = ifelse(abs(as.vector(z_mat)) > 0.5, "white", "#657b83"))
      ) |>
      plotly::layout(
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        margin = list(t = 20, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rel_sb_plot <- renderPlotly({
    res <- rel_data(); req(res)
    k0 <- res$k; r0 <- res$alpha
    k_seq <- seq(1, k0 * 4, 1)
    sb <- (k_seq / k0) * r0 / (1 + ((k_seq / k0) - 1) * r0)
    hover <- paste0("Items: ", k_seq, "<br>Reliability: ", round(sb, 4))

    plot_ly() |>
      add_trace(x = k_seq, y = sb, type = "scatter", mode = "lines",
                line = list(color = "#238b45", width = 2),
                hoverinfo = "text", text = hover, showlegend = FALSE) |>
      add_trace(x = k0, y = r0, type = "scatter", mode = "markers",
                marker = list(color = "#e31a1c", size = 8),
                hoverinfo = "text",
                text = paste0("Current: ", k0, " items<br>\u03b1 = ", round(r0, 3)),
                showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Number of items"),
        yaxis = list(title = "Predicted reliability", range = c(0, 1)),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.7, y1 = 0.7,
               line = list(color = "grey70", dash = "dash", width = 1)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.8, y1 = 0.8,
               line = list(color = "grey70", dash = "dash", width = 1)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.9, y1 = 0.9,
               line = list(color = "grey70", dash = "dash", width = 1))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = 0.7, text = "0.70",
               showarrow = FALSE, xanchor = "left", font = list(size = 9, color = "grey50")),
          list(x = 1.02, xref = "paper", y = 0.8, text = "0.80",
               showarrow = FALSE, xanchor = "left", font = list(size = 9, color = "grey50")),
          list(x = 1.02, xref = "paper", y = 0.9, text = "0.90",
               showarrow = FALSE, xanchor = "left", font = list(size = 9, color = "grey50"))
        )
      )
  })

  output$rel_loadings_plot <- renderPlotly({
    res <- rel_data(); req(res)
    items <- paste0("Item", seq_along(res$loadings))
    mean_ld <- mean(res$loadings)
    hover <- paste0(items, "<br>Loading: ", round(res$loadings, 3))

    plot_ly() |>
      add_bars(x = items, y = res$loadings, text = hover, textposition = "none",
               hoverinfo = "text",
               marker = list(color = "#238b45", opacity = 0.8),
               showlegend = FALSE) |>
      layout(
        xaxis = list(title = "", tickangle = -45,
                     categoryorder = "array", categoryarray = items),
        yaxis = list(title = "Factor Loading", range = c(0, 1)),
        bargap = 0.3,
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = mean_ld, y1 = mean_ld,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = mean_ld,
               text = paste0("Mean = ", round(mean_ld, 2)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        )
      )
  })

  # ── Dimensionality ──────────────────────────────────────────────────
  dim_data <- reactiveVal(NULL)

  observeEvent(input$dim_go, {
    n <- input$dim_n; J <- input$dim_items; nf <- input$dim_true
    avg_load <- input$dim_loading
    set.seed(sample.int(10000, 1))

    items_per <- ceiling(J / nf)
    Lambda <- matrix(0, J, nf)
    for (f in seq_len(nf)) {
      rows <- ((f - 1) * items_per + 1):min(f * items_per, J)
      Lambda[rows, f] <- runif(length(rows), avg_load - 0.1, avg_load + 0.1)
    }
    Psi <- diag(pmax(0.1, 1 - rowSums(Lambda^2)))
    Sigma <- Lambda %*% t(Lambda) + Psi
    X <- MASS::mvrnorm(n, mu = rep(0, J), Sigma = Sigma)

    obs_eig <- eigen(cor(X))$values

    n_rep <- 50
    rand_eigs <- matrix(0, n_rep, J)
    for (r in seq_len(n_rep)) {
      Xr <- matrix(rnorm(n * J), n, J)
      rand_eigs[r, ] <- eigen(cor(Xr))$values
    }
    pa_eig <- colMeans(rand_eigs)
    pa_95 <- apply(rand_eigs, 2, quantile, 0.95)

    n_pa <- sum(obs_eig > pa_95)
    n_kaiser <- sum(obs_eig > 1)

    R <- cor(X)
    map_vals <- numeric(J - 1)
    for (m in seq_len(min(10, J - 1))) {
      pca <- eigen(R)
      comp <- pca$vectors[, seq_len(m), drop = FALSE]
      resid <- R - comp %*% diag(pca$values[seq_len(m)], m, m) %*% t(comp)
      diag(resid) <- 0
      map_vals[m] <- mean(resid^2)
    }
    n_map <- which.min(map_vals[seq_len(min(10, J - 1))])

    dim_data(list(obs_eig = obs_eig, pa_eig = pa_eig, pa_95 = pa_95,
                  n_pa = n_pa, n_kaiser = n_kaiser, n_map = n_map,
                  true = nf, J = J))
  })

  output$dim_scree <- renderPlotly({
    res <- dim_data()
    req(res)
    ndisplay <- min(15, res$J)
    idx <- seq_len(ndisplay)

    plotly::plot_ly() |>
      plotly::add_trace(x = idx, y = res$obs_eig[idx],
                        type = "scatter", mode = "lines+markers",
                        line = list(color = "#238b45", width = 2),
                        marker = list(color = "#238b45", size = 8),
                        name = "Observed",
                        hoverinfo = "text",
                        text = paste0("Component ", idx,
                                       "<br>Eigenvalue = ", round(res$obs_eig[idx], 3))) |>
      plotly::add_trace(x = idx, y = res$pa_95[idx],
                        type = "scatter", mode = "lines+markers",
                        line = list(color = "#e31a1c", width = 2, dash = "dash"),
                        marker = list(color = "#e31a1c", size = 6),
                        name = "PA 95th percentile",
                        hoverinfo = "text",
                        text = paste0("PA threshold ", idx, " = ",
                                       round(res$pa_95[idx], 3))) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = 0.5, x1 = ndisplay + 0.5,
                           y0 = 1, y1 = 1,
                           line = list(color = "grey60", dash = "dot", width = 1))),
        xaxis = list(title = "Component", dtick = 1),
        yaxis = list(title = "Eigenvalue"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$dim_table <- renderTable({
    res <- dim_data(); req(res)
    data.frame(
      Method = c("True dimensions", "Parallel analysis (95%)",
                  "Kaiser rule (eigenvalue > 1)", "MAP"),
      `Suggested dimensions` = c(res$true, res$n_pa, res$n_kaiser, res$n_map),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Scale Development ───────────────────────────────────────────────
  sd_result <- reactiveVal(NULL)

  observeEvent(input$sd_go, {
    n <- input$sd_n; J <- input$sd_items; nf <- input$sd_factors
    avg_load <- input$sd_loading
    set.seed(sample.int(10000, 1))

    items_per <- ceiling(J / nf)
    Lambda <- matrix(0, J, nf)
    for (f in seq_len(nf)) {
      rows <- ((f - 1) * items_per + 1):min(f * items_per, J)
      Lambda[rows, f] <- runif(length(rows), avg_load - 0.15, avg_load + 0.15)
    }
    Lambda <- Lambda + matrix(runif(J * nf, 0, 0.1), J, nf)

    Psi <- diag(pmax(0.1, 1 - rowSums(Lambda^2)))
    Sigma <- Lambda %*% t(Lambda) + Psi
    X <- MASS::mvrnorm(n, mu = rep(0, J), Sigma = Sigma)
    colnames(X) <- paste0("Item", seq_len(J))

    total <- rowSums(X)
    itc <- sapply(seq_len(J), function(j) cor(X[, j], total - X[, j]))

    eigenvals <- eigen(cor(X))$values
    fa_fit <- tryCatch(
      factanal(X, factors = nf, rotation = "varimax"),
      error = function(e) NULL
    )

    alpha_vals <- numeric(nf)
    for (f in seq_len(nf)) {
      rows <- ((f - 1) * items_per + 1):min(f * items_per, J)
      if (length(rows) >= 2) {
        Cx <- cov(X[, rows])
        k <- ncol(Cx)
        alpha_vals[f] <- (k / (k - 1)) * (1 - sum(diag(Cx)) / sum(Cx))
      }
    }

    sd_result(list(X = X, itc = itc, eigenvals = eigenvals, fa = fa_fit,
                   alpha = alpha_vals, J = J, nf = nf, items_per = items_per,
                   Lambda = Lambda))
  })

  output$sd_item_stats <- renderTable({
    res <- sd_result(); req(res)
    data.frame(
      Item = paste0("Item", seq_len(res$J)),
      Mean = round(colMeans(res$X), 3),
      SD = round(apply(res$X, 2, sd), 3),
      `Item-Total r` = round(res$itc, 3),
      Flag = ifelse(res$itc < 0.3, "\u2717 Low", "\u2713"),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$sd_scree <- renderPlotly({
    res <- sd_result(); req(res)
    ev <- res$eigenvals[seq_len(min(10, length(res$eigenvals)))]
    plotly::plot_ly(x = seq_along(ev), y = ev,
                    type = "scatter", mode = "lines+markers",
                    line = list(color = "#238b45", width = 2),
                    marker = list(color = "#238b45", size = 8),
                    hoverinfo = "text",
                    text = paste0("Component ", seq_along(ev),
                                   "<br>Eigenvalue = ", round(ev, 3))) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = 0, x1 = length(ev) + 1,
                           y0 = 1, y1 = 1,
                           line = list(color = "#e31a1c", dash = "dash", width = 1))),
        xaxis = list(title = "Component", dtick = 1),
        yaxis = list(title = "Eigenvalue"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$sd_loadings <- renderTable({
    res <- sd_result(); req(res)
    if (is.null(res$fa)) return(data.frame(Note = "factanal failed"))
    ld <- round(unclass(res$fa$loadings), 3)
    df <- as.data.frame(ld)
    df$Item <- rownames(ld)
    df <- df[, c(ncol(df), seq_len(ncol(df) - 1))]
    df
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$sd_reliability <- renderTable({
    res <- sd_result(); req(res)
    data.frame(
      Factor = paste0("Factor ", seq_len(res$nf)),
      Items = sapply(seq_len(res$nf), function(f) {
        rows <- ((f - 1) * res$items_per + 1):min(f * res$items_per, res$J)
        paste(rows, collapse = ", ")
      }),
      Alpha = round(res$alpha, 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$sd_final <- renderTable({
    res <- sd_result(); req(res)
    good_items <- which(res$itc >= 0.3)
    data.frame(
      Metric = c("Total items", "Retained items (ITC \u2265 0.3)",
                  "Dropped items", "Factors extracted", "Mean \u03b1"),
      Value = c(res$J, length(good_items), res$J - length(good_items),
                res$nf, round(mean(res$alpha), 3))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 5: Test-Retest & Alternate-Forms server ──────────────────────

  rrt_data <- reactiveVal(NULL)

  observeEvent(input$rrt_go, {
    set.seed(sample(1:10000, 1))
    N <- input$rrt_n; K <- input$rrt_items
    rho <- input$rrt_true_r; err_sd <- input$rrt_error_sd
    design <- input$rrt_design

    # True scores
    true_score <- rnorm(N, 50, 10)

    # Time-1 observed score: sum of K items with error
    item_error_1 <- matrix(rnorm(N * K, 0, err_sd), N, K)
    item_scores_1 <- outer(true_score / K, rep(1, K)) + item_error_1
    score_1 <- rowSums(item_scores_1)

    # Correlated true scores for occasion 2 (drop matrix dims from scale)
    z <- as.numeric(scale(true_score))
    true_score_2 <- rho * z * 10 + 50 + sqrt(1 - rho^2) * rnorm(N, 0, 10)

    item_error_2 <- matrix(rnorm(N * K, 0, err_sd), N, K)
    item_scores_2 <- outer(true_score_2 / K, rep(1, K)) + item_error_2
    score_2 <- rowSums(item_scores_2)

    if (design == "altform") {
      score_2 <- score_2 + input$rrt_form_diff * K
    }

    obs_r <- cor(score_1, score_2)
    diff <- score_1 - score_2
    mean_score <- (score_1 + score_2) / 2
    sd_pooled <- sd(c(score_1, score_2))
    sem <- sd_pooled * sqrt(1 - obs_r)

    rrt_data(list(
      score_1 = score_1, score_2 = score_2,
      diff = diff, mean_score = mean_score,
      obs_r = obs_r, sem = sem,
      mean_diff = mean(diff), sd_diff = sd(diff),
      N = N, design = design
    ))
  })

  output$rrt_scatter <- renderPlotly({
    d <- rrt_data(); req(d)
    lab2 <- if (d$design == "retest") "Time 2" else "Form B"

    plot_ly(x = d$score_1, y = d$score_2, type = "scatter", mode = "markers",
            marker = list(color = "#268bd2", opacity = 0.5, size = 6)) |>
      add_trace(x = range(d$score_1), y = range(d$score_1), type = "scatter",
                mode = "lines", line = list(color = "#dc322f", dash = "dash", width = 1.5),
                name = "Identity", showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Time 1 / Form A"),
        yaxis = list(title = lab2),
        title = list(text = sprintf("r = %.3f", d$obs_r), font = list(size = 14)),
        showlegend = FALSE, margin = list(t = 40)
      ) |> config(displayModeBar = FALSE)
  })

  output$rrt_bland_altman <- renderPlotly({
    d <- rrt_data(); req(d)
    upper <- d$mean_diff + 1.96 * d$sd_diff
    lower <- d$mean_diff - 1.96 * d$sd_diff

    plot_ly(x = d$mean_score, y = d$diff, type = "scatter", mode = "markers",
            marker = list(color = "#268bd2", opacity = 0.5, size = 6)) |>
      layout(
        xaxis = list(title = "Mean of Two Scores"),
        yaxis = list(title = "Difference (T1 \u2212 T2)"),
        title = list(text = "Bland-Altman", font = list(size = 14)),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = d$mean_diff, y1 = d$mean_diff,
               line = list(color = "#dc322f", width = 2)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = upper, y1 = upper,
               line = list(color = "#859900", width = 1.5, dash = "dash")),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = lower, y1 = lower,
               line = list(color = "#859900", width = 1.5, dash = "dash"))
        ),
        showlegend = FALSE, margin = list(t = 40)
      ) |> config(displayModeBar = FALSE)
  })

  output$rrt_summary <- renderTable({
    d <- rrt_data(); req(d)
    design_lab <- if (d$design == "retest") "Test-Retest" else "Alternate Forms"
    data.frame(
      Metric = c("Design", "N", "Pearson r", "SEM",
                  "Mean difference", "SD of differences",
                  "95% LoA (lower)", "95% LoA (upper)"),
      Value = c(design_lab, d$N,
                sprintf("%.3f", d$obs_r), sprintf("%.2f", d$sem),
                sprintf("%.2f", d$mean_diff), sprintf("%.2f", d$sd_diff),
                sprintf("%.2f", d$mean_diff - 1.96 * d$sd_diff),
                sprintf("%.2f", d$mean_diff + 1.96 * d$sd_diff))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$rrt_error_hist <- renderPlotly({
    d <- rrt_data(); req(d)
    plot_ly(x = d$diff, type = "histogram", nbinsx = 30,
            marker = list(color = "#268bd2", line = list(color = "white", width = 0.5))) |>
      layout(
        xaxis = list(title = "Score Difference (T1 \u2212 T2)"),
        yaxis = list(title = "Count"),
        title = list(text = sprintf("Mean = %.2f, SD = %.2f", d$mean_diff, d$sd_diff),
                     font = list(size = 13)),
        shapes = list(
          list(type = "line", x0 = d$mean_diff, x1 = d$mean_diff,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#dc322f", width = 2, dash = "dash"))
        ),
        margin = list(t = 40)
      ) |> config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
