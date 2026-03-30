# Module: Corrections & Robustness (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
corrections_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Corrections & Robustness",
  icon = icon("clone"),
  navset_card_underline(
    nav_panel(
      "Multiple Comparisons",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("mc_n_tests"), "Number of tests", min = 1, max = 100, value = 20, step = 1),
      sliderInput(ns("mc_alpha"), "\u03b1 per test", min = 0.01, max = 0.20, value = 0.05, step = 0.01),
      sliderInput(ns("mc_n_sims"), "Simulations", min = 100, max = 5000, value = 1000, step = 100),
      selectInput(ns("mc_correction"), "Correction method",
        choices = c("None (uncorrected)" = "none",
                    "Bonferroni" = "bonferroni",
                    "Holm" = "holm",
                    "Benjamini-Hochberg (FDR)" = "BH"),
        selected = "none"
      ),
      actionButton(ns("mc_run"), "Run simulation", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("The Multiple Comparisons Problem"),
      tags$p("When you run many hypothesis tests, each at level \u03b1, the chance
              of at least one false positive grows rapidly. With 20 independent tests
              at \u03b1 = 0.05, the family-wise error rate is
              1 \u2212 (1 \u2212 0.05)\u00b2\u2070 \u2248 64%. This means that even when
              no real effects exist, you are more likely than not to find at least one
              \u201csignificant\u201d result \u2014 a recipe for false discoveries."),
      tags$p("Correction methods control this inflation. ", tags$em("Bonferroni"), " is the
              simplest: multiply each p-value by the number of tests (or equivalently,
              use \u03b1/m as the threshold). It is conservative, especially when tests
              are correlated. ", tags$em("Holm"), " is a step-down improvement that is uniformly
              more powerful while still controlling the family-wise error rate. ",
              tags$em("Benjamini-Hochberg (FDR)"), " controls the expected proportion of false
              discoveries among rejected hypotheses, rather than the probability of any
              false positive \u2014 it is less conservative and often more appropriate in
              exploratory settings with many tests."),
      tags$p("The choice of correction depends on context. In confirmatory clinical trials,
              strict FWER control (Bonferroni/Holm) is standard. In genomics or neuroimaging,
              where thousands of tests are routine, FDR control is more practical. In
              exploratory analysis, even FDR may be unnecessary if the goal is generating
              hypotheses rather than confirming them \u2014 but the multiplicity issue should
              always be acknowledged."),
      guide = tags$ol(
        tags$li("All simulated data come from H\u2080 (no real effects)."),
        tags$li("Increase the number of tests and see how many false positives appear."),
        tags$li("Apply a correction method and observe the reduction in false discoveries."),
        tags$li("The bottom plot shows the family-wise error rate as a function of the number of tests.")
      )
    ),

    layout_column_wrap(
      width = 1,
      layout_column_wrap(
        width = 1 / 2,
        card(
          full_screen = TRUE,
          card_header("P-value Distribution (one simulation)"),
          plotlyOutput(ns("mc_pvals"), height = "360px")
        ),
        card(
          full_screen = TRUE,
          card_header("False Positive Rate Across Simulations"),
          plotlyOutput(ns("mc_fpr"), height = "360px")
        )
      ),
      card(
        full_screen = TRUE,
        card_header("Family-wise Error Rate vs. Number of Tests"),
        plotlyOutput(ns("mc_fwer_curve"), height = "320px")
      )
    )
  )
    ),

    nav_panel(
      "Nonparametric Tests",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("np_test"), "Test comparison",
        choices = c("Wilcoxon vs. t-test (2 groups)",
                    "Kruskal-Wallis vs. ANOVA (3 groups)",
                    "Permutation test (2 groups)"),
        selected = "Wilcoxon vs. t-test (2 groups)"
      ),
      selectInput(ns("np_dist"), "Data distribution",
        choices = c("Normal", "Right-skewed (Gamma)", "Heavy-tailed (t, df=3)",
                    "Uniform", "Contaminated Normal"),
        selected = "Normal"
      ),
      sliderInput(ns("np_n"), "n per group", min = 10, max = 200, value = 30, step = 5),
      sliderInput(ns("np_effect"), "Effect size (shift)", min = 0, max = 2, value = 0.5, step = 0.1),
      conditionalPanel(ns = ns, "input.np_test == 'Permutation test (2 groups)'",
        sliderInput(ns("np_n_perm"), "Permutations", min = 500, max = 10000, value = 2000, step = 500)
      ),
      actionButton(ns("np_run"), "Generate data", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Nonparametric Tests"),
      tags$p("Nonparametric tests make fewer assumptions about the data distribution.
              They use ranks instead of raw values, making them robust to skewness,
              outliers, and heavy tails. The trade-off: they are slightly less powerful
              than their parametric counterparts when distributional assumptions are met.
              Typically, the efficiency loss is modest (around 5% for large samples
              under normality)."),
      tags$ul(
        tags$li(tags$strong("Wilcoxon rank-sum (Mann-Whitney U)"), " \u2014 nonparametric alternative
                to the independent-samples t-test. Tests whether one group tends to have
                higher ranks than the other."),
        tags$li(tags$strong("Kruskal-Wallis"), " \u2014 nonparametric alternative to one-way ANOVA.
                Tests whether the distributions of ranks differ across groups. If significant,
                pairwise Dunn\u2019s tests can identify which groups differ."),
        tags$li(tags$strong("Permutation test"), " \u2014 shuffles group labels to build a null
                distribution directly from the data. Makes no distributional assumptions
                at all and is exact for any sample size. Increasingly popular due to
                computational advances.")
      ),
      tags$p("A common misconception is that nonparametric tests compare medians. Strictly,
              the Wilcoxon rank-sum tests whether one distribution is stochastically larger
              than the other. It only tests medians under the additional assumption that the
              distributions have the same shape (differing only in location). When shapes
              differ, interpretation requires more care."),
      tags$p("Permutation tests deserve special attention because they are exact and
              assumption-free. By repeatedly shuffling group labels and recomputing the
              test statistic, they construct the null distribution empirically. The p-value
              is simply the proportion of permuted statistics as extreme as the observed
              one. With modern computing, permutation tests are practical for most sample
              sizes and are increasingly preferred in fields where distributional assumptions
              are questionable."),
      guide = tags$ol(
        tags$li("Choose a test and data distribution."),
        tags$li("With Normal data, both tests give similar p-values."),
        tags$li("Switch to skewed or heavy-tailed data to see when nonparametric tests outperform."),
        tags$li("The permutation test builds its null from the data itself — no distributional assumptions needed.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(
        full_screen = TRUE,
        card_header("Data"),
        plotlyOutput(ns("np_data_plot"), height = "360px")
      ),
      card(
        full_screen = TRUE,
        card_header("Test Results"),
        plotlyOutput(ns("np_result_plot"), height = "360px")
      )
    ),
    card(
      card_header("Comparison Table"),
      tableOutput(ns("np_table"))
    )
  )
    ),

    nav_panel(
      "Effect Sizes",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("es_metric"), "Effect size metric",
        choices = c("Cohen's d (two groups)" = "d",
                    "Pearson r (correlation)" = "r",
                    "\u03b7\u00b2 (ANOVA)" = "eta2",
                    "Odds Ratio (2\u00d72 table)" = "or"),
        selected = "d"
      ),
      conditionalPanel(ns = ns, "input.es_metric == 'd'",
        sliderInput(ns("es_d_val"), "Cohen's d", min = 0, max = 3, value = 0.5, step = 0.1),
        sliderInput(ns("es_d_n"), "n per group", min = 20, max = 200, value = 50, step = 10)
      ),
      conditionalPanel(ns = ns, "input.es_metric == 'r'",
        sliderInput(ns("es_r_val"), "Correlation (r)", min = -1, max = 1, value = 0.3, step = 0.05),
        sliderInput(ns("es_r_n"), "Sample size", min = 20, max = 500, value = 100, step = 10)
      ),
      conditionalPanel(ns = ns, "input.es_metric == 'eta2'",
        sliderInput(ns("es_eta2_val"), "\u03b7\u00b2", min = 0, max = 0.5, value = 0.06, step = 0.01),
        sliderInput(ns("es_eta2_k"), "Number of groups", min = 2, max = 6, value = 3, step = 1),
        sliderInput(ns("es_eta2_n"), "n per group", min = 15, max = 100, value = 30, step = 5)
      ),
      conditionalPanel(ns = ns, "input.es_metric == 'or'",
        sliderInput(ns("es_or_val"), "Odds Ratio", min = 0.2, max = 10, value = 2, step = 0.1),
        sliderInput(ns("es_or_base"), "Baseline probability", min = 0.05, max = 0.50, value = 0.20, step = 0.05),
        sliderInput(ns("es_or_n"), "n per group", min = 30, max = 300, value = 100, step = 10)
      ),
      actionButton(ns("es_gen"), "Visualize", icon = icon("eye"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("What Does This Effect Size Look Like?"),
      tags$p("Effect sizes quantify the magnitude of a relationship or difference.
              While p-values indicate whether an effect is statistically distinguishable
              from zero, effect sizes indicate how large and practically meaningful the
              effect is. This distinction is crucial: a tiny, unimportant effect can
              produce a highly significant p-value given a large enough sample."),
      tags$ul(
        tags$li(tags$strong("Cohen\u2019s d"), " \u2014 standardised mean difference: small \u2248 0.2,
                medium \u2248 0.5, large \u2248 0.8. A d of 0.5 means the groups differ by
                half a standard deviation."),
        tags$li(tags$strong("r (correlation)"), " \u2014 small \u2248 0.1, medium \u2248 0.3,
                large \u2248 0.5. The squared correlation (r\u00b2) gives the proportion
                of variance explained."),
        tags$li(tags$strong("\u03b7\u00b2 (eta-squared)"), " \u2014 proportion of total variance explained
                by the grouping factor: small \u2248 0.01, medium \u2248 0.06, large \u2248 0.14.
                Partial \u03b7\u00b2 is preferred in designs with multiple factors."),
        tags$li(tags$strong("Odds Ratio (OR)"), " \u2014 1 = no association, 1.5 = small, 2.5 = medium,
                4+ = large. ORs are multiplicative, so they are often reported on a log scale
                where the neutral value is 0.")
      ),
      tags$p("Cohen\u2019s benchmarks (small/medium/large) are useful starting points but should
              be interpreted in context. In clinical research, a \u201csmall\u201d effect may
              represent meaningful improvement; in educational interventions, a \u201clarge\u201d
              effect may be unrealistic. Always interpret effect sizes relative to the
              specific domain and practical consequences."),
      tags$p("Reporting effect sizes alongside p-values is now required or strongly
              encouraged by most major journals and the APA. Effect sizes facilitate
              meta-analysis (combining results across studies) and help readers judge
              practical significance. A confidence interval around the effect size is
              even more informative than the point estimate alone, as it conveys both
              the magnitude and the precision of the estimate.")
    ),

    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header(textOutput(ns("es_plot_title"))),
           plotlyOutput(ns("es_main_plot"), height = "420px")),
      card(card_header("Interpretation"), uiOutput(ns("es_interpretation")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

corrections_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  sim_results <- reactiveVal(NULL)

  observeEvent(input$mc_run, {
    set.seed(sample.int(10000, 1))
    n_tests <- input$mc_n_tests
    n_sims  <- input$mc_n_sims
    alpha   <- input$mc_alpha
    corr    <- input$mc_correction

    results <- replicate(n_sims, {
      raw_p <- replicate(n_tests, {
        t.test(rnorm(30), rnorm(30))$p.value
      })
      adj_p <- if (corr == "none") raw_p else p.adjust(raw_p, method = corr)
      c(n_sig_raw  = sum(raw_p < alpha),
        n_sig_adj  = sum(adj_p < alpha),
        any_sig    = as.numeric(any(adj_p < alpha)))
    })

    example_p <- replicate(n_tests, t.test(rnorm(30), rnorm(30))$p.value)
    example_adj <- if (corr == "none") example_p else p.adjust(example_p, method = corr)

    sim_results(list(
      results   = results,
      example_p = example_p,
      example_adj = example_adj,
      n_tests   = n_tests,
      alpha     = alpha,
      corr      = corr,
      n_sims    = n_sims
    ))
  })

  output$mc_pvals <- renderPlotly({
    req(sim_results())
    sr <- sim_results()

    df <- data.frame(
      test = seq_along(sr$example_adj),
      p    = sr$example_adj,
      p_raw = sr$example_p,
      sig  = sr$example_adj < sr$alpha
    )

    colors <- ifelse(df$sig, "#e31a1c", "#238b45")
    hover_txt <- paste0("Test #", df$test,
                        "<br>Raw p = ", round(df$p_raw, 4),
                        "<br>Adj p = ", round(df$p, 4),
                        "<br>Significant: ", ifelse(df$sig, "Yes", "No"),
                        "<br>Method: ", if (sr$corr == "none") "none" else sr$corr)

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = df$test, y = df$p,
        marker = list(color = colors, line = list(color = "white", width = 0.5)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0.5, x1 = nrow(df) + 0.5,
               y0 = sr$alpha, y1 = sr$alpha,
               line = list(color = "#e31a1c", width = 1.5, dash = "dash"))
        ),
        xaxis = list(title = "Test Number"),
        yaxis = list(title = "p-value (adjusted)", range = c(0, 1)),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(sum(df$sig), " of ", nrow(df),
                             " tests significant (",
                             if (sr$corr == "none") "no correction" else sr$corr, ")"),
               showarrow = FALSE, font = list(size = 13)),
          list(x = nrow(df), y = sr$alpha + 0.03,
               text = paste0("\u03b1 = ", sr$alpha),
               showarrow = FALSE, font = list(size = 11, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_fpr <- renderPlotly({
    req(sim_results())
    sr <- sim_results()
    fp_counts <- sr$results["n_sig_adj", ]
    fwer <- mean(sr$results["any_sig", ])
    mean_fp <- mean(fp_counts)

    # Tabulate for bar chart
    tab <- as.data.frame(table(fp = factor(fp_counts, levels = 0:max(fp_counts))))
    tab$fp_num <- as.numeric(as.character(tab$fp))

    hover_txt <- paste0("False positives = ", tab$fp_num,
                        "<br>Count = ", tab$Freq,
                        "<br>Proportion = ", round(tab$Freq / sr$n_sims, 3))

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = tab$fp_num, y = tab$Freq,
        marker = list(color = "rgba(35,139,69,0.7)",
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = mean_fp, x1 = mean_fp,
               y0 = 0, y1 = max(tab$Freq) * 1.05,
               line = list(color = "#e31a1c", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Number of False Positives per Simulation"),
        yaxis = list(title = "Count"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Mean FP = ", round(mean_fp, 2),
                             ",  FWER = ", round(fwer * 100, 1), "%"),
               showarrow = FALSE, font = list(size = 13))
        ),
        bargap = 0.1,
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_fwer_curve <- renderPlotly({
    alpha <- input$mc_alpha
    k <- 1:100
    fwer <- 1 - (1 - alpha)^k

    cur_k <- input$mc_n_tests
    cur_fwer <- 1 - (1 - alpha)^cur_k

    hover_txt <- paste0("Tests = ", k,
                        "<br>FWER = ", round(fwer * 100, 1), "%",
                        "<br>\u03b1 = ", alpha)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = k, y = fwer, type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        name = "FWER", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cur_k, y = cur_fwer,
        marker = list(color = "#e31a1c", size = 10,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Current: ", cur_k, " tests",
                      "<br>FWER = ", round(cur_fwer * 100, 1), "%"),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 1, x1 = 100,
               y0 = alpha, y1 = alpha,
               line = list(color = "grey50", width = 1, dash = "dot"))
        ),
        xaxis = list(title = "Number of Independent Tests"),
        yaxis = list(title = "Family-wise Error Rate", range = c(0, 1.05)),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("\u03b1 = ", alpha, " per test (assuming independence)"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })


  gen_sample <- function(n, dist) {
    switch(dist,
      "Normal"                 = rnorm(n),
      "Right-skewed (Gamma)"   = rgamma(n, shape = 2, rate = 1),
      "Heavy-tailed (t, df=3)" = rt(n, df = 3),
      "Uniform"                = runif(n, -2, 2),
      "Contaminated Normal"    = {
        k <- rbinom(n, 1, 0.1)
        ifelse(k == 1, rnorm(n, 0, 5), rnorm(n, 0, 1))
      },
      rnorm(n)
    )
  }

  dat <- reactiveVal(NULL)

  observeEvent(input$np_run, {
    set.seed(sample.int(10000, 1))
    n <- input$np_n
    eff <- input$np_effect

    if (input$np_test == "Kruskal-Wallis vs. ANOVA (3 groups)") {
      g1 <- gen_sample(n, input$np_dist)
      g2 <- gen_sample(n, input$np_dist) + eff
      g3 <- gen_sample(n, input$np_dist) + eff * 2
      df <- data.frame(
        value = c(g1, g2, g3),
        group = rep(c("A", "B", "C"), each = n)
      )
    } else {
      g1 <- gen_sample(n, input$np_dist)
      g2 <- gen_sample(n, input$np_dist) + eff
      df <- data.frame(
        value = c(g1, g2),
        group = rep(c("A", "B"), each = n)
      )
    }
    dat(df)
  })

  output$np_data_plot <- renderPlotly({
    req(dat())
    df <- dat()
    groups <- unique(df$group)
    colors <- c(A = "#238b45", B = "#e31a1c", C = "#3182bd")

    p <- plotly::plot_ly()
    for (g in groups) {
      gd <- df[df$group == g, ]
      jitter_x <- as.numeric(factor(g, levels = groups)) + runif(nrow(gd), -0.15, 0.15)

      hover_txt <- paste0("Group: ", g,
                          "<br>Value: ", round(gd$value, 3),
                          "<br>Rank: ", rank(df$value)[df$group == g])

      p <- p |>
        plotly::add_trace(
          y = gd$value, x = rep(g, nrow(gd)),
          type = "box", name = g,
          marker = list(color = colors[g]),
          line = list(color = colors[g]),
          fillcolor = paste0(colors[g], "40"),
          boxpoints = FALSE, showlegend = FALSE,
          hoverinfo = "y", hoveron = "boxes"
        ) |>
        plotly::add_markers(
          x = jitter_x, y = gd$value,
          marker = list(color = colors[g], size = 4, opacity = 0.5),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE, xaxis = "x"
        )
    }

    p |> plotly::layout(
      xaxis = list(title = "Group",
                   tickvals = seq_along(groups),
                   ticktext = groups),
      yaxis = list(title = "Value"),
      annotations = list(
        list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
             text = paste0(input$np_dist, ",  n = ", input$np_n,
                           ",  shift = ", input$np_effect),
             showarrow = FALSE, font = list(size = 13))
      ),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$np_result_plot <- renderPlotly({
    req(dat())
    df <- dat()
    test_type <- input$np_test

    if (test_type == "Permutation test (2 groups)") {
      obs_diff <- mean(df$value[df$group == "B"]) - mean(df$value[df$group == "A"])
      n_perm <- input$np_n_perm
      perm_diffs <- replicate(n_perm, {
        shuffled <- sample(df$value)
        n_a <- sum(df$group == "A")
        mean(shuffled[(n_a + 1):length(shuffled)]) - mean(shuffled[1:n_a])
      })
      perm_p <- mean(abs(perm_diffs) >= abs(obs_diff))

      brks <- seq(min(perm_diffs), max(perm_diffs), length.out = 51)
      h <- hist(perm_diffs, breaks = brks, plot = FALSE)

      bar_colors <- ifelse(abs(h$mids) >= abs(obs_diff),
                           "rgba(227,26,28,0.6)", "rgba(35,139,69,0.6)")

      hover_txt <- paste0("Diff: [", round(h$breaks[-length(h$breaks)], 3), ", ",
                          round(h$breaks[-1], 3), ")",
                          "<br>Count: ", h$counts)

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = h$mids, y = h$counts, width = diff(h$breaks)[1],
          marker = list(color = bar_colors,
                        line = list(color = "white", width = 0.5)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = obs_diff, x1 = obs_diff,
                 y0 = 0, y1 = max(h$counts) * 1.05,
                 line = list(color = "#e31a1c", width = 2, dash = "dash")),
            list(type = "line", x0 = -obs_diff, x1 = -obs_diff,
                 y0 = 0, y1 = max(h$counts) * 1.05,
                 line = list(color = "#e31a1c", width = 2, dash = "dash"))
          ),
          xaxis = list(title = "Permuted Difference in Means"),
          yaxis = list(title = "Count"),
          annotations = list(
            list(x = obs_diff, y = max(h$counts) * 1.05,
                 text = paste0("Obs = ", round(obs_diff, 3), "<br>p = ", round(perm_p, 4)),
                 showarrow = TRUE, arrowhead = 2, ax = 40, ay = -30,
                 font = list(color = "#e31a1c", size = 12)),
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0(n_perm, " permutations"),
                 showarrow = FALSE, font = list(size = 13))
          ),
          bargap = 0.05,
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    } else {
      # For non-permutation tests, show a simple comparison visual
      if (test_type == "Wilcoxon vs. t-test (2 groups)") {
        tt <- t.test(value ~ group, data = df)
        wt <- wilcox.test(value ~ group, data = df)
        tests <- c("t-test", "Wilcoxon")
        pvals <- c(tt$p.value, wt$p.value)
        stats <- c(tt$statistic, wt$statistic)
      } else {
        av <- summary(aov(value ~ group, data = df))[[1]]
        kw <- kruskal.test(value ~ group, data = df)
        tests <- c("ANOVA (F)", "Kruskal-Wallis (H)")
        pvals <- c(av[["Pr(>F)"]][1], kw$p.value)
        stats <- c(av[["F value"]][1], kw$statistic)
      }

      colors <- ifelse(pvals < 0.05, "#e31a1c", "#238b45")
      hover_txt <- paste0("Test: ", tests,
                          "<br>Statistic: ", round(stats, 3),
                          "<br>p-value: ", format.pval(pvals, digits = 4),
                          "<br>Significant: ", ifelse(pvals < 0.05, "Yes", "No"))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = tests, y = -log10(pvals),
          marker = list(color = colors,
                        line = list(color = "white", width = 1)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = -0.5, x1 = 1.5,
                 y0 = -log10(0.05), y1 = -log10(0.05),
                 line = list(color = "grey50", width = 1.5, dash = "dash"))
          ),
          xaxis = list(title = ""),
          yaxis = list(title = "-log10(p-value)"),
          annotations = list(
            list(x = 1.5, y = -log10(0.05) + 0.1,
                 text = "\u03b1 = 0.05", showarrow = FALSE,
                 font = list(size = 11, color = "grey50")),
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = "Test comparison (-log10 scale)",
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$np_table <- renderTable({
    req(dat())
    df <- dat()
    test_type <- input$np_test

    if (test_type == "Wilcoxon vs. t-test (2 groups)") {
      tt <- t.test(value ~ group, data = df)
      wt <- wilcox.test(value ~ group, data = df)
      data.frame(
        Test = c("Independent t-test", "Wilcoxon rank-sum"),
        Statistic = c(round(tt$statistic, 3), round(wt$statistic, 1)),
        `p-value` = c(format.pval(tt$p.value, digits = 4),
                      format.pval(wt$p.value, digits = 4)),
        check.names = FALSE
      )
    } else if (test_type == "Kruskal-Wallis vs. ANOVA (3 groups)") {
      av <- summary(aov(value ~ group, data = df))[[1]]
      kw <- kruskal.test(value ~ group, data = df)
      data.frame(
        Test = c("One-way ANOVA (F)", "Kruskal-Wallis (H)"),
        Statistic = c(round(av[["F value"]][1], 3), round(kw$statistic, 3)),
        `p-value` = c(format.pval(av[["Pr(>F)"]][1], digits = 4),
                      format.pval(kw$p.value, digits = 4)),
        check.names = FALSE
      )
    } else {
      obs_diff <- mean(df$value[df$group == "B"]) - mean(df$value[df$group == "A"])
      tt <- t.test(value ~ group, data = df)
      perm_diffs <- replicate(input$np_n_perm, {
        shuffled <- sample(df$value)
        n_a <- sum(df$group == "A")
        mean(shuffled[(n_a + 1):length(shuffled)]) - mean(shuffled[1:n_a])
      })
      perm_p <- mean(abs(perm_diffs) >= abs(obs_diff))
      data.frame(
        Test = c("Independent t-test", "Permutation test"),
        Statistic = c(round(tt$statistic, 3), round(obs_diff, 3)),
        `p-value` = c(format.pval(tt$p.value, digits = 4),
                      round(perm_p, 4)),
        check.names = FALSE
      )
    }
  }, striped = TRUE, hover = TRUE, bordered = TRUE)


  output$es_plot_title <- renderText({
    switch(input$es_metric,
      "d"    = paste0("Cohen's d = ", input$es_d_val),
      "r"    = paste0("r = ", input$es_r_val),
      "eta2" = paste0("\u03b7\u00b2 = ", input$es_eta2_val),
      "or"   = paste0("Odds Ratio = ", input$es_or_val)
    )
  })

  output$es_main_plot <- renderPlotly({
    input$es_gen

    isolate({
      metric <- input$es_metric

      if (metric == "d") {
        d <- input$es_d_val
        n <- input$es_d_n
        set.seed(sample.int(10000, 1))

        x_seq <- seq(-4, d + 4, length.out = 300)
        y1 <- dnorm(x_seq, 0, 1)
        y2 <- dnorm(x_seq, d, 1)
        overlap <- round(2 * pnorm(-abs(d) / 2) * 100, 1)

        plotly::plot_ly() |>
          plotly::add_trace(
            x = x_seq, y = y1, type = "scatter", mode = "lines",
            fill = "tozeroy", fillcolor = "rgba(49,130,189,0.3)",
            line = list(color = "#3182bd", width = 2),
            name = "Control", hoverinfo = "skip"
          ) |>
          plotly::add_trace(
            x = x_seq, y = y2, type = "scatter", mode = "lines",
            fill = "tozeroy", fillcolor = "rgba(227,26,28,0.3)",
            line = list(color = "#e31a1c", width = 2),
            name = "Treatment", hoverinfo = "skip"
          ) |>
          plotly::layout(
            xaxis = list(title = "Value"), yaxis = list(title = "Density"),
            legend = list(orientation = "h", x = 0.5, xanchor = "center",
                          y = -0.12, yanchor = "top"),
            annotations = list(
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = paste0("d = ", d, "  |  Overlap \u2248 ", overlap, "%"),
                   showarrow = FALSE, font = list(size = 13))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)

      } else if (metric == "r") {
        r_val <- input$es_r_val
        n <- input$es_r_n
        set.seed(sample.int(10000, 1))
        dat <- MASS::mvrnorm(n, mu = c(0, 0),
                             Sigma = matrix(c(1, r_val, r_val, 1), 2, 2))

        hover_txt <- paste0("x = ", round(dat[, 1], 3),
                            "<br>y = ", round(dat[, 2], 3))

        fit <- lm(dat[, 2] ~ dat[, 1])
        xr <- range(dat[, 1])
        x_line <- seq(xr[1], xr[2], length.out = 100)
        y_line <- predict(fit, newdata = data.frame("dat[, 1]" = x_line))

        plotly::plot_ly() |>
          plotly::add_markers(
            x = dat[, 1], y = dat[, 2],
            marker = list(color = "#238b45", size = 5, opacity = 0.4,
                          line = list(width = 0)),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE
          ) |>
          plotly::add_trace(
            x = x_line, y = as.numeric(y_line),
            type = "scatter", mode = "lines",
            line = list(color = "#e31a1c", width = 2),
            hoverinfo = "skip", showlegend = FALSE
          ) |>
          plotly::layout(
            xaxis = list(title = "X"), yaxis = list(title = "Y"),
            annotations = list(
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = paste0("r = ", r_val, "  (n = ", n, ")"),
                   showarrow = FALSE, font = list(size = 13))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)

      } else if (metric == "eta2") {
        eta2 <- input$es_eta2_val
        k    <- input$es_eta2_k
        n    <- input$es_eta2_n
        set.seed(sample.int(10000, 1))

        sigma_b <- sqrt(eta2 / (1 - eta2))
        mus <- seq(-sigma_b, sigma_b, length.out = k)

        cols <- if (k <= 8) {
          RColorBrewer::brewer.pal(max(3, k), "Set2")[seq_len(k)]
        } else {
          grDevices::hcl.colors(k, "Set2")
        }

        p <- plotly::plot_ly()
        for (j in seq_len(k)) {
          vals <- rnorm(n, mus[j], 1)
          grp <- paste0("Group ", j)
          hover_txt <- paste0(grp, "<br>Value = ", round(vals, 3))
          p <- p |>
            plotly::add_boxplot(
              y = vals, name = grp,
              marker = list(color = cols[j]),
              line = list(color = cols[j]),
              fillcolor = scales::alpha(cols[j], 0.4),
              hoverinfo = "y",
              boxpoints = "all", jitter = 0.3, pointpos = -1.5,
              showlegend = FALSE
            )
        }
        p |> plotly::layout(
          xaxis = list(title = "Group"), yaxis = list(title = "Value"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = paste0("\u03b7\u00b2 = ", eta2, "  (", k, " groups)"),
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

      } else {
        or_val <- input$es_or_val
        base_p <- input$es_or_base
        n <- input$es_or_n
        set.seed(sample.int(10000, 1))

        odds_base <- base_p / (1 - base_p)
        odds_treat <- odds_base * or_val
        treat_p <- odds_treat / (1 + odds_treat)

        y_ctrl  <- rbinom(n, 1, base_p)
        y_treat <- rbinom(n, 1, treat_p)

        props <- c(mean(y_ctrl), mean(y_treat))
        grps <- c("Control", "Treatment")
        cols <- c("#3182bd", "#e31a1c")
        hover_txt <- paste0(grps, "<br>Proportion: ", round(props * 100, 1), "%")

        plotly::plot_ly() |>
          plotly::add_bars(textposition = "none",
            x = grps, y = props,
            marker = list(color = cols, opacity = 0.7),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE, width = 0.5
          ) |>
          plotly::layout(
            xaxis = list(title = ""),
            yaxis = list(title = "Proportion 'Yes'",
                         range = c(0, min(1, max(props) * 1.3)),
                         tickformat = ".0%"),
            annotations = list(
              # Value labels on bars
              list(x = grps[1], y = props[1],
                   text = paste0(round(props[1] * 100, 1), "%"),
                   showarrow = FALSE, yanchor = "bottom",
                   font = list(size = 14, color = "#00441b")),
              list(x = grps[2], y = props[2],
                   text = paste0(round(props[2] * 100, 1), "%"),
                   showarrow = FALSE, yanchor = "bottom",
                   font = list(size = 14, color = "#00441b")),
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = paste0("OR = ", or_val, "  |  Base rate = ", base_p,
                                 ",  Treatment rate \u2248 ", round(treat_p, 3)),
                   showarrow = FALSE, font = list(size = 12))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)
      }
    })
  })

  output$es_interpretation <- renderUI({
    metric <- input$es_metric
    if (metric == "d") {
      d <- input$es_d_val
      lbl <- if (abs(d) < 0.2) "negligible" else if (abs(d) < 0.5) "small" else if (abs(d) < 0.8) "medium" else "large"
      tags$p("Cohen's d = ", d, " is conventionally considered a ", tags$strong(lbl),
             " effect. This means the two group means are ", d,
             " standard deviations apart.")
    } else if (metric == "r") {
      r_val <- input$es_r_val
      lbl <- if (abs(r_val) < 0.1) "negligible" else if (abs(r_val) < 0.3) "small" else if (abs(r_val) < 0.5) "medium" else "large"
      tags$p("r = ", r_val, " is conventionally considered a ", tags$strong(lbl),
             " effect. The shared variance (r\u00b2) is ",
             round(r_val^2 * 100, 1), "%.")
    } else if (metric == "eta2") {
      eta2 <- input$es_eta2_val
      lbl <- if (eta2 < 0.01) "negligible" else if (eta2 < 0.06) "small" else if (eta2 < 0.14) "medium" else "large"
      tags$p("\u03b7\u00b2 = ", eta2, " is conventionally considered a ", tags$strong(lbl),
             " effect. This means ", round(eta2 * 100, 1),
             "% of the variance in the outcome is accounted for by group membership.")
    } else {
      or_val <- input$es_or_val
      lbl <- if (or_val < 1.5 & or_val > 1/1.5) "small" else if (or_val < 2.5 & or_val > 1/2.5) "medium" else "large"
      tags$p("OR = ", or_val, " is conventionally considered a ", tags$strong(lbl),
             " effect. The odds of the outcome in the treatment group are ",
             round(or_val, 2), " times those of the control group.")
    }
  })
  # Auto-run simulations on first load
  })
}
