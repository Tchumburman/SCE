# Module: Mean Comparisons (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
mean_comparisons_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Mean Comparisons",
  icon = icon("not-equal"),
  navset_card_underline(
    nav_panel(
      "T-test",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      selectInput(ns("tt_type"), "Test type",
                  choices = c("Independent samples", "Paired samples")),
      sliderInput(ns("tt_n"), "Sample size per group", min = 5, max = 1000, value = 30),
      sliderInput(ns("tt_mu1"), "Group A mean", min = -100, max = 100, value = 5, step = 0.5),
      sliderInput(ns("tt_mu2"), "Group B mean", min = -100, max = 100, value = 7, step = 0.5),
      radioButtons(ns("tt_spread_type"), "Spread parameter",
                   choices = c("Standard Deviation" = "sd", "Standard Error" = "se"),
                   selected = "sd", inline = TRUE),
      sliderInput(ns("tt_sd"), "Std deviation (both groups)", min = 0.5, max = 8, value = 3, step = 0.25),
      actionButton(ns("tt_go"), "Generate & test", class = "btn-success w-100 mb-2"),
      actionButton(ns("tt_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    explanation_box(
      tags$strong("T-test: Comparing Two Means"),
      tags$p("The t-test evaluates whether two group means differ more than
              would be expected by chance. It compares the observed difference
              to the standard error of the difference. A large t-statistic
              (far from zero) indicates the means are unlikely to be equal."),
      tags$p("There are several variants of the t-test. The independent-samples (two-sample)
              t-test compares means from two separate groups. The paired-samples t-test compares
              means from the same participants measured under two conditions, which is more
              powerful because it controls for individual differences. Welch\u2019s t-test
              (the default in most software) does not assume equal variances and is recommended
              over the classic Student\u2019s t-test in most situations."),
      tags$p("The assumptions of the t-test are approximate normality of the sampling
              distribution of the mean (usually satisfied by the CLT for n > 30) and
              independence of observations. The test is quite robust to non-normality
              with moderate sample sizes, but severely skewed data or small samples
              may warrant a nonparametric alternative like the Wilcoxon rank-sum test."),
      tags$p("The bar chart shows group means with standard-error bars \u2014 non-overlapping
              bars suggest (but don\u2019t guarantee) a significant difference.
              The raw data plot shows the actual observations with the mean marked.
              Always inspect the raw data alongside summary statistics, as bar charts
              can hide important distributional features like outliers or bimodality."),
      guide = tags$ol(
        tags$li("Choose independent or paired samples."),
        tags$li("Set the group means and standard deviation — the further apart the means relative to SD, the easier to detect."),
        tags$li("Click 'Generate & test' to simulate data and run the test."),
        tags$li("Examine the bar chart (means \u00b1 SE) and raw data (jittered points)."),
        tags$li("Check the test result: t-statistic, p-value, confidence interval, and Cohen's d."),
        tags$li("Try making the means equal — you should see a non-significant result (most of the time).")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Group Comparison"),
           plotly::plotlyOutput(ns("tt_bar_plot"), height = "400px")),
      card(full_screen = TRUE, card_header("Raw Data"),
           plotly::plotlyOutput(ns("tt_raw_plot"), height = "400px"))
    ),
    card(card_header("Test Result"), uiOutput(ns("tt_result")))
  )
    ),

    nav_panel(
      "ANOVA",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("aov_k"), "Number of groups", min = 2, max = 6, value = 3),
      sliderInput(ns("aov_n"), "Sample size per group", min = 5, max = 1000, value = 25),
      radioButtons(ns("aov_spread_type"), "Spread parameter",
                   choices = c("Standard Deviation" = "sd", "Standard Error" = "se"),
                   selected = "sd", inline = TRUE),
      sliderInput(ns("aov_sd"), "Std deviation (all groups)", min = 0.5, max = 8, value = 3, step = 0.25),
      uiOutput(ns("aov_means_ui")),
      actionButton(ns("aov_go"), "Generate & test", class = "btn-success w-100 mb-2"),
      actionButton(ns("aov_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    explanation_box(
      tags$strong("ANOVA: Comparing Multiple Means"),
      tags$p("ANOVA (Analysis of Variance) tests whether at least one group mean
              differs from the others. It partitions total variability into two
              components: between-group variance (systematic differences among group
              means) and within-group variance (random variation within each group).
              The F-ratio is the quotient of these two; a large F suggests the groups
              truly differ beyond what chance alone would produce."),
      tags$p("ANOVA assumes normality within groups, homogeneity of variances (equal
              variance across groups), and independence of observations. Moderate
              violations of normality are tolerable with balanced designs and reasonable
              sample sizes, but unequal variances can seriously inflate the Type I error
              rate, especially with unbalanced groups. Welch\u2019s ANOVA or the
              Brown-Forsythe test are robust alternatives."),
      tags$p("A significant ANOVA tells you that ", tags$em("at least one"), " group differs but
              not which ones. Post-hoc tests such as Tukey\u2019s HSD identify specific
              pairwise differences while controlling the family-wise error rate.
              Planned contrasts are a more powerful alternative when specific hypotheses
              exist before data collection."),
      guide = tags$ol(
        tags$li("Set the number of groups and sample size per group."),
        tags$li("Adjust individual group means using the sliders \u2014 larger separation = larger F."),
        tags$li("Click 'Generate & test' to simulate data."),
        tags$li("Examine the bar chart (means \u00b1 SE) and raw data."),
        tags$li("Check the ANOVA table: look at the F-statistic and p-value."),
        tags$li("Scroll down to the Tukey HSD table to see which specific pairs differ."),
        tags$li("Try setting all means equal \u2014 you should get a non-significant F (most of the time).")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Group Comparison"),
           plotly::plotlyOutput(ns("aov_bar_plot"), height = "400px")),
      card(full_screen = TRUE, card_header("Raw Data"),
           plotly::plotlyOutput(ns("aov_raw_plot"), height = "400px"))
    ),
    card(card_header("ANOVA Table"),
         div(style = "font-size: 1.05rem;",
             tableOutput(ns("aov_table")))),
    card(card_header("Pairwise Comparisons (Tukey HSD)"),
         div(style = "font-size: 1.05rem;",
             tableOutput(ns("aov_tukey"))))
  )
    ),

    nav_panel(
      "Repeated Measures",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("rm_n"), "Subjects", min = 10, max = 100, value = 30, step = 5),
      sliderInput(ns("rm_k"), "Time points", min = 3, max = 6, value = 4, step = 1),
      sliderInput(ns("rm_effect"), "Effect size (trend)", min = 0, max = 2,
                  value = 0.5, step = 0.1),
      sliderInput(ns("rm_rho"), "Within-subject correlation (\u03c1)",
                  min = 0.1, max = 0.9, value = 0.5, step = 0.05),
      actionButton(ns("rm_go"), "Run analysis", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Repeated Measures ANOVA"),
      tags$p("When the same subjects are measured at multiple time points or under
              multiple conditions, observations are correlated within subjects.
              Repeated measures ANOVA accounts for this correlation by partitioning
              out between-subject variability, giving substantially more power than a
              between-subjects design for the same total number of observations."),
      tags$p("The within-subject correlation (\u03c1) controls how similar a subject\u2019s
              measurements are across conditions. Higher \u03c1 means less within-subject
              noise and greater power to detect within-subject effects. This is why
              within-subject designs are so efficient: much of the variability in the
              data is \u201caccounted for\u201d by individual differences."),
      tags$p("A critical assumption is ", tags$em("sphericity"), ": the variances of all pairwise
              differences between conditions must be equal. When sphericity is violated,
              the F-test becomes liberal (too many false positives). Mauchly\u2019s test
              checks this assumption, and corrections such as Greenhouse-Geisser or
              Huynh-Feldt adjust the degrees of freedom to compensate. Alternatively,
              mixed-effects models handle non-sphericity naturally and are increasingly
              preferred for longitudinal data."),
      guide = tags$ol(
        tags$li("Set the number of subjects, time points, effect size, and correlation."),
        tags$li("Click 'Run analysis' to generate correlated data and fit the model."),
        tags$li("The spaghetti plot shows individual subject trajectories."),
        tags$li("Compare the RM ANOVA (which removes between-subject variance) to a naive one-way ANOVA that ignores repeated structure.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Individual Trajectories"),
           plotlyOutput(ns("rm_spaghetti"), height = "400px")),
      layout_column_wrap(
        width = 1 / 2,
        card(card_header("Repeated Measures ANOVA"), tableOutput(ns("rm_table"))),
        card(card_header("Naive One-Way ANOVA (ignoring subjects)"), tableOutput(ns("rm_naive")))
      )
    )
  )
    ),

    nav_panel(
      "ANCOVA",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("anc_n"), "n per group", min = 15, max = 100, value = 30, step = 5),
      sliderInput(ns("anc_diff"), "Group difference (unadjusted)", min = 0, max = 3,
                  value = 1.0, step = 0.1),
      sliderInput(ns("anc_cov_r"), "Covariate-outcome correlation", min = 0, max = 0.9,
                  value = 0.6, step = 0.05),
      sliderInput(ns("anc_cov_imbal"), "Covariate imbalance between groups",
                  min = 0, max = 2, value = 0.5, step = 0.1),
      actionButton(ns("anc_go"), "Run analysis", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Analysis of Covariance (ANCOVA)"),
      tags$p("ANCOVA combines ANOVA with regression. It tests group differences
              on a dependent variable while statistically controlling for one or
              more continuous covariates. This serves two purposes: (1) it reduces
              error variance, boosting power, and (2) it adjusts group means for
              pre-existing differences on the covariate, providing a fairer comparison."),
      tags$p("ANCOVA assumes homogeneity of regression slopes: the relationship between
              the covariate and the DV should be the same across groups (parallel lines).
              If this assumption is violated (the lines are not parallel), the adjusted
              means depend on the covariate value chosen for comparison, and the ANCOVA
              results become misleading. In such cases, a model with an interaction
              between group and covariate is more appropriate."),
      tags$p("The scatter plot shows how ANCOVA \u201cadjusts\u201d by comparing groups at
              the same covariate level (parallel regression lines). When groups differ
              substantially on the covariate (covariate imbalance), ANCOVA can
              dramatically change conclusions compared to a simple ANOVA."),
      guide = tags$ol(
        tags$li("Set group size, raw group difference, covariate correlation, and covariate imbalance."),
        tags$li("Click 'Run analysis' to generate data and fit both ANOVA and ANCOVA."),
        tags$li("Compare p-values: ANCOVA is often more powerful because it removes covariate variance from the error."),
        tags$li("Increase covariate imbalance to see how ANCOVA adjusts group means.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Scatter Plot with Regression Lines"),
           plotlyOutput(ns("anc_scatter"), height = "400px")),
      layout_column_wrap(
        width = 1 / 2,
        card(card_header("ANOVA (no covariate)"), tableOutput(ns("anc_anova"))),
        card(card_header("ANCOVA (adjusted)"), tableOutput(ns("anc_ancova")))
      ),
      card(card_header("Adjusted vs Unadjusted Means"), tableOutput(ns("anc_means")))
    )
  )
    ),

    nav_panel(
      "MANOVA",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("manova_k"), "Number of groups", min = 2, max = 5, value = 3, step = 1),
      sliderInput(ns("manova_n"), "Observations per group", min = 20, max = 200, value = 50, step = 10),
      tags$hr(),
      tags$h6("Group separation"),
      sliderInput(ns("manova_eff_y1"), "Effect on Y1", min = 0, max = 3, value = 1, step = 0.25),
      sliderInput(ns("manova_eff_y2"), "Effect on Y2", min = 0, max = 3, value = 0.5, step = 0.25),
      sliderInput(ns("manova_cor"), "Correlation (Y1, Y2)", min = -0.9, max = 0.9, value = 0.3, step = 0.1),
      actionButton(ns("manova_go"), "Simulate & Test", class = "btn-success w-100 mb-2"),
      actionButton(ns("manova_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    fillable = FALSE,
      explanation_box(
        tags$strong("MANOVA — Multivariate Analysis of Variance"),
        tags$p("MANOVA extends ANOVA to simultaneously test group differences across
                multiple dependent variables. While running separate ANOVAs for each DV
                inflates Type I error, MANOVA accounts for the correlations between DVs
                and controls the overall error rate."),
        tags$p("MANOVA uses test statistics like Pillai\u2019s Trace, Wilks\u2019 Lambda, Hotelling-Lawley
                Trace, and Roy\u2019s Largest Root. Pillai\u2019s Trace is generally the most robust
                to violations of assumptions. A significant MANOVA is typically followed by
                univariate ANOVAs to identify which DVs differ across groups."),
        tags$p("The key assumptions of MANOVA include multivariate normality, homogeneity of
                variance-covariance matrices (Box\u2019s M test), and independence of observations.
                MANOVA is most powerful when the DVs are moderately correlated; if they are
                uncorrelated, separate ANOVAs with correction are equally valid, and if they
                are very highly correlated, the multiple DVs add little information."),
        tags$p("MANOVA is particularly useful in experimental psychology and neuroscience,
                where multiple outcome measures are collected simultaneously. It answers the
                question: do the groups differ on the combined set of outcomes? This is a
                fundamentally different question from whether they differ on each outcome
                individually."),
        guide = tags$ol(
          tags$li("Set the number of groups and observations per group."),
          tags$li("Adjust the effect sizes for each dependent variable (Y1 and Y2)."),
          tags$li("Set the correlation between Y1 and Y2."),
          tags$li("Click 'Simulate & Test' to generate data and run MANOVA."),
          tags$li("The scatter plot shows group separation in bivariate space."),
          tags$li("Review the MANOVA test statistics and follow-up univariate ANOVAs.")
        )
      ),
      layout_column_wrap(
        width = 1,
        card(
          full_screen = TRUE,
          card_header("Bivariate Group Plot"),
          plotly::plotlyOutput(ns("manova_plot"), height = "450px")
        ),
        card(card_header("MANOVA Results (Pillai's Trace)"),
             div(style = "font-size: 1.05rem;",
                 uiOutput(ns("manova_table")))),
        card(card_header("Follow-up Univariate ANOVAs"),
             div(style = "font-size: 1.05rem;",
                 tableOutput(ns("manova_univariate"))))
      )
  )
    ),

    # ── Parametric vs Nonparametric (side-by-side) ─────────────────────
    nav_panel(
      "Parametric vs Nonparametric",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("pvn_pop"), "Population shape",
        choices = c("Normal", "Skewed (Gamma)", "Heavy-tailed (t, df=3)",
                    "Bimodal", "Contaminated Normal"),
        selected = "Normal"),
      sliderInput(ns("pvn_n"), "Sample size per group", min = 5, max = 200, value = 20),
      sliderInput(ns("pvn_shift"), "True group difference", min = 0, max = 3, value = 0.5, step = 0.1),
      numericInput(ns("pvn_sims"), "Simulations", value = 1000, min = 100, max = 10000, step = 100),
      actionButton(ns("pvn_go"), "Run comparison", class = "btn-success w-100 mb-2"),
      actionButton(ns("pvn_single"), "Single sample", class = "btn-outline-success w-100"),
      tags$small(class = "text-muted d-block mt-2",
        "'Run comparison' simulates many datasets to compare power/Type I error.",
        "'Single sample' draws one dataset for visual inspection.")
    ),
    explanation_box(
      tags$strong("Parametric vs Nonparametric Tests"),
      tags$p("Parametric tests (e.g., t-test) assume a specific distribution (usually Normal)
              and use the mean as the measure of central tendency. Nonparametric tests
              (e.g., Wilcoxon rank-sum) make no distributional assumption and work with
              ranks instead of raw values."),
      tags$p("When assumptions hold, parametric tests are more powerful \u2014 they are better
              at detecting real differences. But when data are skewed, heavy-tailed, or contain
              outliers, nonparametric tests can be more powerful because they are less affected
              by extreme values."),
      tags$p("This comparison lets you see both tests applied to the same data. The simulation
              mode runs many repetitions to compare rejection rates (power when there is a real
              difference, or Type I error when there is none). This directly illustrates the
              trade-off between the two approaches."),
      guide = tags$ol(
        tags$li("Choose a population shape \u2014 try Normal first (where the t-test should win)."),
        tags$li("Set sample size, true group difference, and click 'Run comparison'."),
        tags$li("Compare rejection rates: which test detects the difference more often?"),
        tags$li("Now try 'Heavy-tailed' or 'Skewed' \u2014 the nonparametric test may catch up or even win."),
        tags$li("Set the shift to 0 to compare Type I error rates (both should be near 5%).")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Single Sample View"),
           plotlyOutput(ns("pvn_sample_plot"), height = "380px")),
      card(full_screen = TRUE, card_header("Simulation Results"),
           plotlyOutput(ns("pvn_power_plot"), height = "380px"))
    ),
    card(card_header("Single Sample Test Results"),
         uiOutput(ns("pvn_test_output")))
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mean_comparisons_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  tt_data <- reactiveVal(NULL)
  
  observeEvent(input$tt_reset, tt_data(NULL))
  
  # Update slider label based on spread type
  observeEvent(input$tt_spread_type, {
    lbl <- if (input$tt_spread_type == "se") "Std error (both groups)" else "Std deviation (both groups)"
    updateSliderInput(session, "tt_sd", label = lbl)
  })
  
  observeEvent(input$tt_go, {
    set.seed(sample(1:10000, 1))
    n <- input$tt_n
    # Derive SD from input: if user chose SE, convert SE -> SD
    sd_val <- if (input$tt_spread_type == "se") input$tt_sd * sqrt(n) else input$tt_sd
    if (input$tt_type == "Independent samples") {
      df <- data.frame(
        group = rep(c("A", "B"), each = n),
        value = c(rnorm(n, input$tt_mu1, sd_val),
                  rnorm(n, input$tt_mu2, sd_val))
      )
    } else {
      base <- rnorm(n, input$tt_mu1, sd_val)
      df <- data.frame(
        group = rep(c("A", "B"), each = n),
        value = c(base, base + (input$tt_mu2 - input$tt_mu1) +
                    rnorm(n, 0, sd_val * 0.3)),
        id = rep(seq_len(n), 2)
      )
    }
    tt_data(df)
  })
  
  output$tt_bar_plot <- plotly::renderPlotly({
    df <- tt_data()
    req(df)
    summ <- aggregate(value ~ group, data = df, FUN = function(x) {
      c(mean = mean(x), se = sd(x) / sqrt(length(x)))
    })
    summ <- cbind(summ[, "group", drop = FALSE],
                  as.data.frame(summ$value))
    colors <- c("A" = "#238b45", "B" = "#41ae76")

    plotly::plot_ly(summ, x = ~group, y = ~mean, type = "bar",
                    marker = list(color = colors[summ$group], opacity = 0.85),
                    error_y = list(type = "data", array = summ$se, color = "#333"),
                    showlegend = FALSE,
                    hovertemplate = "Group %{x}<br>Mean: %{y:.2f}<extra></extra>") |>
      plotly::layout(
        xaxis = list(title = "Group"),
        yaxis = list(title = "Mean \u00b1 SE"),
        margin = list(t = 20)
      )
  })
  
  output$tt_raw_plot <- plotly::renderPlotly({
    df <- tt_data()
    req(df)
    colors <- c("A" = "#238b45", "B" = "#41ae76")
    means <- tapply(df$value, df$group, mean)

    p <- plotly::plot_ly()
    for (g in c("A", "B")) {
      vals <- df$value[df$group == g]
      jittered_x <- as.numeric(factor(g, levels = c("A", "B"))) + runif(length(vals), -0.15, 0.15)
      p <- p |> plotly::add_markers(
        x = jittered_x, y = vals,
        marker = list(color = colors[g], opacity = 0.5, size = 5),
        name = g, showlegend = FALSE,
        hovertemplate = paste0("Group ", g, "<br>Value: %{y:.2f}<extra></extra>")
      )
    }
    # Add mean crossbars
    for (g in c("A", "B")) {
      gx <- as.numeric(factor(g, levels = c("A", "B")))
      p <- p |> plotly::add_trace(
        x = c(gx - 0.2, gx + 0.2), y = rep(means[g], 2),
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 3),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Mean: ", round(means[g], 2))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "Group", tickvals = c(1, 2), ticktext = c("A", "B")),
      yaxis = list(title = "Value"),
      margin = list(t = 20)
    )
  })
  
  output$tt_result <- renderUI({
    df <- tt_data()
    req(df)
    if (input$tt_type == "Independent samples") {
      res <- t.test(value ~ group, data = df)
    } else {
      a <- df$value[df$group == "A"]
      b <- df$value[df$group == "B"]
      res <- t.test(a, b, paired = TRUE)
    }
    d <- abs(diff(tapply(df$value, df$group, mean))) /
      sqrt(mean(tapply(df$value, df$group, stats::var)))
  
    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$p(tags$strong("Test: "),
             paste0(input$tt_type, " t-test")),
      tags$p(tags$strong("t = "), round(res$statistic, 3),
             tags$strong("  df = "), round(res$parameter, 1),
             tags$strong("  p = "), format.pval(res$p.value, digits = 4)),
      tags$p(tags$strong("95% CI for difference: "),
             paste0("[", round(res$conf.int[1], 2), ", ",
                    round(res$conf.int[2], 2), "]")),
      tags$p(tags$strong("Cohen's d = "), round(d, 3)),
      if (res$p.value < 0.05)
        tags$p(style = "color: #238b45; font-weight: bold;",
               "\u2713 Statistically significant")
      else
        tags$p(style = "color: #e31a1c; font-weight: bold;",
               "\u2717 Not statistically significant")
    )
  })
  

  # Update slider label based on spread type
  observeEvent(input$aov_spread_type, {
    lbl <- if (input$aov_spread_type == "se") "Std error (all groups)" else "Std deviation (all groups)"
    updateSliderInput(session, "aov_sd", label = lbl)
  })

  # Dynamic mean sliders
  output$aov_means_ui <- renderUI({
    k <- input$aov_k
    defaults <- c(5, 7, 6, 8, 4, 9)[seq_len(k)]
    tagList(
      tags$label("Group means:", class = "form-label fw-bold"),
      lapply(seq_len(k), function(i) {
        sliderInput(session$ns(paste0("aov_mu_", i)),
                    label = paste("Group", LETTERS[i]),
                    min = -100, max = 100, value = defaults[i], step = 0.5)
      })
    )
  })

  aov_data <- reactiveVal(NULL)

  observeEvent(input$aov_reset, aov_data(NULL))

  observeEvent(input$aov_go, {
    set.seed(sample(1:10000, 1))
    k <- input$aov_k; n <- input$aov_n
    # Derive SD: if user chose SE, convert SE -> SD
    sd_val <- if (input$aov_spread_type == "se") input$aov_sd * sqrt(n) else input$aov_sd
    rows <- lapply(seq_len(k), function(i) {
      mu <- input[[paste0("aov_mu_", i)]]
      if (is.null(mu)) mu <- 5
      data.frame(group = LETTERS[i], value = rnorm(n, mu, sd_val))
    })
    aov_data(do.call(rbind, rows))
  })

  output$aov_bar_plot <- plotly::renderPlotly({
    df <- aov_data()
    req(df)
    summ <- aggregate(value ~ group, data = df, FUN = function(x) {
      c(mean = mean(x), se = sd(x) / sqrt(length(x)))
    })
    summ <- cbind(summ[, "group", drop = FALSE],
                  as.data.frame(summ$value))

    greens <- colorRampPalette(c("#99d8c9", "#006d2c"))(nrow(summ))

    plotly::plot_ly(summ, x = ~group, y = ~mean, type = "bar",
                    marker = list(color = greens, opacity = 0.85),
                    error_y = list(type = "data", array = summ$se, color = "#333"),
                    showlegend = FALSE,
                    hovertemplate = "Group %{x}<br>Mean: %{y:.2f}<extra></extra>") |>
      plotly::layout(
        xaxis = list(title = "Group"),
        yaxis = list(title = "Mean \u00b1 SE"),
        margin = list(t = 20)
      )
  })

  output$aov_raw_plot <- plotly::renderPlotly({
    df <- aov_data()
    req(df)
    groups <- sort(unique(df$group))
    greens <- colorRampPalette(c("#99d8c9", "#006d2c"))(length(groups))
    means <- tapply(df$value, df$group, mean)

    p <- plotly::plot_ly()
    for (i in seq_along(groups)) {
      g <- groups[i]
      vals <- df$value[df$group == g]
      jittered_x <- i + runif(length(vals), -0.15, 0.15)
      p <- p |> plotly::add_markers(
        x = jittered_x, y = vals,
        marker = list(color = greens[i], opacity = 0.5, size = 5),
        name = g, showlegend = FALSE,
        hovertemplate = paste0("Group ", g, "<br>Value: %{y:.2f}<extra></extra>")
      )
      p <- p |> plotly::add_trace(
        x = c(i - 0.2, i + 0.2), y = rep(means[g], 2),
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 3),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Mean: ", round(means[g], 2))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "Group", tickvals = seq_along(groups), ticktext = groups),
      yaxis = list(title = "Value"),
      margin = list(t = 20)
    )
  })

  output$aov_table <- renderTable({
    df <- aov_data()
    req(df)
    fit <- aov(value ~ group, data = df)
    tidy <- as.data.frame(summary(fit)[[1]])
    tidy$Term <- c("Between groups", "Residuals")
    tidy <- tidy[, c("Term", "Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)")]
    names(tidy) <- c("Source", "df", "Sum of Sq", "Mean Sq", "F", "p-value")
    tidy$`p-value` <- format.pval(tidy$`p-value`, digits = 4)
    tidy
  }, hover = TRUE, spacing = "m")

  output$aov_tukey <- renderTable({
    df <- aov_data()
    req(df)
    fit <- aov(value ~ group, data = df)
    tk <- TukeyHSD(fit)$group
    res <- as.data.frame(tk)
    res$Comparison <- rownames(res)
    res <- res[, c("Comparison", "diff", "lwr", "upr", "p adj")]
    names(res) <- c("Comparison", "Difference", "Lower CI", "Upper CI", "p (adj)")
    res$`Difference` <- round(res$`Difference`, 3)
    res$`Lower CI` <- round(res$`Lower CI`, 3)
    res$`Upper CI` <- round(res$`Upper CI`, 3)
    res$`p (adj)` <- format.pval(res$`p (adj)`, digits = 4)
    res
  }, hover = TRUE, spacing = "m")


  rm_result <- reactiveVal(NULL)

  observeEvent(input$rm_go, {
    n <- input$rm_n; k <- input$rm_k
    eff <- input$rm_effect; rho <- input$rm_rho
    set.seed(sample.int(10000, 1))

    # Compound symmetry covariance
    Sigma <- matrix(rho, k, k)
    diag(Sigma) <- 1

    # Group means: linear trend
    time_means <- seq(0, eff * (k - 1), length.out = k)

    Y <- MASS::mvrnorm(n, mu = time_means, Sigma = Sigma)
    colnames(Y) <- paste0("T", seq_len(k))

    long <- data.frame(
      subject = rep(seq_len(n), each = k),
      time    = rep(paste0("T", seq_len(k)), times = n),
      value   = as.vector(t(Y))
    )
    long$time <- factor(long$time, levels = paste0("T", seq_len(k)))
    long$subject <- factor(long$subject)

    rm_result(list(wide = Y, long = long))
  })

  output$rm_spaghetti <- renderPlotly({
    res <- rm_result()
    req(res)
    long <- res$long
    k <- length(unique(long$time))
    subj_ids <- unique(long$subject)

    # Group means
    grp <- aggregate(value ~ time, data = long, FUN = mean)

    p <- plotly::plot_ly()
    for (s in subj_ids) {
      d <- long[long$subject == s, ]
      p <- p |> plotly::add_trace(
        x = as.numeric(d$time), y = d$value,
        type = "scatter", mode = "lines",
        line = list(color = "rgba(150,150,150,0.25)", width = 1),
        showlegend = FALSE, hoverinfo = "none"
      )
    }
    p <- p |>
      plotly::add_trace(
        x = seq_len(k), y = grp$value,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 3),
        marker = list(color = "#238b45", size = 8),
        name = "Group Mean",
        hoverinfo = "text",
        text = paste0(grp$time, "<br>Mean = ", round(grp$value, 3))
      ) |>
      plotly::layout(
        xaxis = list(title = "Time", tickvals = seq_len(k),
                     ticktext = levels(long$time)),
        yaxis = list(title = "Value"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
    p
  })

  output$rm_table <- renderTable({
    res <- rm_result()
    req(res)
    long <- res$long
    fit <- aov(value ~ time + Error(subject / time), data = long)
    sm <- summary(fit)
    wt <- sm[["Error: subject:time"]][[1]]
    data.frame(
      Source = rownames(wt),
      Df = wt$Df,
      `Sum Sq` = round(wt$`Sum Sq`, 3),
      `Mean Sq` = round(wt$`Mean Sq`, 3),
      `F value` = round(wt$`F value`, 3),
      `p value` = format.pval(wt$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$rm_naive <- renderTable({
    res <- rm_result()
    req(res)
    long <- res$long
    fit <- aov(value ~ time, data = long)
    sm <- summary(fit)[[1]]
    data.frame(
      Source = rownames(sm),
      Df = sm$Df,
      `Sum Sq` = round(sm$`Sum Sq`, 3),
      `Mean Sq` = round(sm$`Mean Sq`, 3),
      `F value` = round(sm$`F value`, 3),
      `p value` = format.pval(sm$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  anc_data <- reactiveVal(NULL)

  observeEvent(input$anc_go, {
    n <- input$anc_n; diff <- input$anc_diff
    cov_r <- input$anc_cov_r; imbal <- input$anc_cov_imbal
    set.seed(sample.int(10000, 1))

    # Covariate: group A has higher covariate by 'imbal'
    cov_a <- rnorm(n, mean = imbal / 2, sd = 1)
    cov_b <- rnorm(n, mean = -imbal / 2, sd = 1)
    covariate <- c(cov_a, cov_b)
    group <- factor(rep(c("A", "B"), each = n))

    # Outcome = group effect + covariate effect + noise
    noise_sd <- sqrt(1 - cov_r^2)
    y <- ifelse(group == "A", diff / 2, -diff / 2) + cov_r * covariate +
         rnorm(2 * n, 0, noise_sd)

    dat <- data.frame(group = group, covariate = covariate, y = y)
    anc_data(dat)
  })

  output$anc_scatter <- renderPlotly({
    dat <- anc_data()
    req(dat)
    cols <- c(A = "#3182bd", B = "#e31a1c")

    p <- plotly::plot_ly()
    for (g in c("A", "B")) {
      d <- dat[dat$group == g, ]
      fit <- lm(y ~ covariate, data = d)
      xr <- range(d$covariate)
      xline <- seq(xr[1], xr[2], length.out = 50)
      yline <- predict(fit, newdata = data.frame(covariate = xline))
      p <- p |>
        plotly::add_markers(x = d$covariate, y = d$y,
                            marker = list(color = cols[g], size = 5, opacity = 0.5),
                            name = paste("Group", g), showlegend = TRUE,
                            hoverinfo = "text",
                            text = paste0("Group ", g, "<br>Cov = ", round(d$covariate, 2),
                                          "<br>Y = ", round(d$y, 2))) |>
        plotly::add_trace(x = xline, y = as.numeric(yline),
                          type = "scatter", mode = "lines",
                          line = list(color = cols[g], width = 2),
                          showlegend = FALSE, hoverinfo = "skip")
    }
    p |> plotly::layout(
      xaxis = list(title = "Covariate"),
      yaxis = list(title = "Outcome (Y)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$anc_anova <- renderTable({
    dat <- anc_data(); req(dat)
    fit <- aov(y ~ group, data = dat)
    sm <- summary(fit)[[1]]
    data.frame(
      Source = rownames(sm), Df = sm$Df,
      `F value` = round(sm$`F value`, 3),
      `p value` = format.pval(sm$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$anc_ancova <- renderTable({
    dat <- anc_data(); req(dat)
    fit <- aov(y ~ covariate + group, data = dat)
    sm <- summary(fit)[[1]]
    data.frame(
      Source = rownames(sm), Df = sm$Df,
      `F value` = round(sm$`F value`, 3),
      `p value` = format.pval(sm$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$anc_means <- renderTable({
    dat <- anc_data(); req(dat)
    raw <- aggregate(y ~ group, data = dat, FUN = mean)
    fit <- lm(y ~ covariate + group, data = dat)
    grand_cov <- mean(dat$covariate)
    adj_a <- predict(fit, newdata = data.frame(group = "A", covariate = grand_cov))
    adj_b <- predict(fit, newdata = data.frame(group = "B", covariate = grand_cov))
    data.frame(
      Group = c("A", "B"),
      `Unadjusted Mean` = round(raw$y, 3),
      `Adjusted Mean` = round(c(adj_a, adj_b), 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  manova_result <- reactiveVal(NULL)
  
  observeEvent(input$manova_reset, {
    updateSliderInput(session, "manova_k", value = 3)
    updateSliderInput(session, "manova_n", value = 50)
    updateSliderInput(session, "manova_eff_y1", value = 1)
    updateSliderInput(session, "manova_eff_y2", value = 0.5)
    updateSliderInput(session, "manova_cor", value = 0.3)
    manova_result(NULL)
  })
  
  observeEvent(input$manova_go, {
    set.seed(sample(1:10000, 1))
    k <- input$manova_k
    n <- input$manova_n
    r <- input$manova_cor
    eff1 <- input$manova_eff_y1
    eff2 <- input$manova_eff_y2

    sigma <- matrix(c(1, r, r, 1), 2, 2)
    dfs <- lapply(seq_len(k), function(i) {
      mu <- c(eff1 * (i - 1), eff2 * (i - 1))
      vals <- MASS::mvrnorm(n, mu = mu, Sigma = sigma)
      data.frame(Y1 = vals[, 1], Y2 = vals[, 2],
                 Group = paste0("Group ", i))
    })
    df <- do.call(rbind, dfs)
    df$Group <- factor(df$Group)

    manova_result(df)
  })
  
  output$manova_plot <- plotly::renderPlotly({
    df <- manova_result()
    req(df)
    
    group_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e")
    groups <- levels(df$Group)
    
    p <- plotly::plot_ly()
    for (i in seq_along(groups)) {
      sub <- df[df$Group == groups[i], ]
      p <- p |> plotly::add_markers(
        x = sub$Y1, y = sub$Y2,
        marker = list(color = group_colors[i], size = 5, opacity = 0.6,
                      line = list(width = 0.5, color = "#FFFFFF")),
        name = groups[i],
        hoverinfo = "text",
        text = paste0(groups[i], "<br>Y1: ", round(sub$Y1, 2),
                      "<br>Y2: ", round(sub$Y2, 2))
      )
      
      # 68% confidence ellipse
      if (nrow(sub) > 3) {
        center <- colMeans(sub[, c("Y1", "Y2")])
        covmat <- cov(sub[, c("Y1", "Y2")])
        theta_seq <- seq(0, 2 * pi, length.out = 100)
        eig <- eigen(covmat)
        # chi-sq critical value for 68% with 2 df
        r_sq <- qchisq(0.68, df = 2)
        ell <- cbind(cos(theta_seq), sin(theta_seq)) %*%
          (sqrt(r_sq) * diag(sqrt(eig$values)) %*% t(eig$vectors))
        ell[, 1] <- ell[, 1] + center[1]
        ell[, 2] <- ell[, 2] + center[2]
        p <- p |> plotly::add_trace(
          x = ell[, 1], y = ell[, 2],
          type = "scatter", mode = "lines",
          line = list(color = group_colors[i], width = 1.5),
          showlegend = FALSE, hoverinfo = "none"
        )
      }
    }
    
    p |> plotly::layout(
      xaxis = list(title = "Y1"),
      yaxis = list(title = "Y2"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.12, yanchor = "top",
                    font = list(size = 11),
                    bgcolor = "rgba(255,255,255,0.8)",
                    bordercolor = "#cccccc", borderwidth = 1),
      margin = list(b = 70, t = 30)
    )
  })
  
  output$manova_table <- renderUI({
    df <- manova_result()
    req(df)
    fit <- manova(cbind(Y1, Y2) ~ Group, data = df)
    s <- summary(fit, test = "Pillai")
    st <- s$stats
    tbl <- data.frame(
      Source = rownames(st),
      df = as.integer(st[, "Df"]),
      `Pillai's Trace` = round(st[, "Pillai"], 4),
      `Approx F` = round(st[, "approx F"], 3),
      `num Df` = as.integer(st[, "num Df"]),
      `den Df` = as.integer(st[, "den Df"]),
      `p-value` = format.pval(st[, "Pr(>F)"], digits = 4),
      check.names = FALSE
    )
    sig <- !is.na(st[, "Pr(>F)"]) & st[, "Pr(>F)"] < 0.05
    sig_text <- if (any(sig[rownames(st) == "Group"])) {
      tags$p(style = "color: #238b45; font-weight: bold; margin-top: 0.5rem;",
             "\u2713 MANOVA is statistically significant (p < .05)")
    } else {
      tags$p(style = "color: #e31a1c; font-weight: bold; margin-top: 0.5rem;",
             "\u2717 MANOVA is not statistically significant")
    }
    tagList(
      tags$table(class = "table table-hover",
        tags$thead(tags$tr(lapply(names(tbl), function(nm) tags$th(nm)))),
        tags$tbody(
          lapply(seq_len(nrow(tbl)), function(i) {
            tags$tr(lapply(tbl[i, ], function(v) tags$td(as.character(v))))
          })
        )
      ),
      sig_text
    )
  })
  
  output$manova_univariate <- renderTable({
    df <- manova_result()
    req(df)
    fit <- manova(cbind(Y1, Y2) ~ Group, data = df)
    aovs <- summary.aov(fit)
    out <- do.call(rbind, lapply(names(aovs), function(dv) {
      s <- aovs[[dv]]
      data.frame(
        DV = c(dv, ""),
        Source = rownames(s),
        df = s$Df,
        `Sum of Sq` = round(s$`Sum Sq`, 2),
        `Mean Sq` = round(s$`Mean Sq`, 2),
        F = round(s$`F value`, 3),
        `p-value` = format.pval(s$`Pr(>F)`, digits = 4),
        check.names = FALSE
      )
    }))
    rownames(out) <- NULL
    out
  }, hover = TRUE, spacing = "m")

  # ── Parametric vs Nonparametric ─────────────────────────────────────

  # Helper: generate one group from selected population
  pvn_generate <- function(n, shift = 0, pop) {
    x <- switch(pop,
      "Normal" = rnorm(n),
      "Skewed (Gamma)" = rgamma(n, shape = 2, rate = 1) - 2,
      "Heavy-tailed (t, df=3)" = rt(n, df = 3),
      "Bimodal" = {
        k <- rbinom(n, 1, 0.5)
        k * rnorm(n, -1.5, 0.6) + (1 - k) * rnorm(n, 1.5, 0.6)
      },
      "Contaminated Normal" = {
        k <- rbinom(n, 1, 0.1)
        (1 - k) * rnorm(n) + k * rnorm(n, 0, 5)
      }
    )
    x + shift
  }

  pvn_single_data <- reactiveVal(NULL)
  pvn_sim_result <- reactiveVal(NULL)

  # Single sample
  observeEvent(input$pvn_single, {
    set.seed(sample.int(10000, 1))
    n <- input$pvn_n
    grp_a <- pvn_generate(n, 0, input$pvn_pop)
    grp_b <- pvn_generate(n, input$pvn_shift, input$pvn_pop)
    tt <- t.test(grp_a, grp_b)
    wt <- wilcox.test(grp_a, grp_b)
    pvn_single_data(list(a = grp_a, b = grp_b, t = tt, w = wt))
  })

  # Simulation
  observeEvent(input$pvn_go, {
    set.seed(sample.int(10000, 1))
    n <- input$pvn_n
    shift <- input$pvn_shift
    pop <- input$pvn_pop
    nsim <- input$pvn_sims

    t_pvals <- numeric(nsim)
    w_pvals <- numeric(nsim)

    for (i in seq_len(nsim)) {
      grp_a <- pvn_generate(n, 0, pop)
      grp_b <- pvn_generate(n, shift, pop)
      t_pvals[i] <- t.test(grp_a, grp_b)$p.value
      w_pvals[i] <- suppressWarnings(wilcox.test(grp_a, grp_b)$p.value)
    }

    pvn_sim_result(list(
      t_reject = mean(t_pvals < 0.05),
      w_reject = mean(w_pvals < 0.05),
      t_pvals = t_pvals,
      w_pvals = w_pvals,
      shift = shift,
      pop = pop,
      nsim = nsim
    ))

    # Also draw a single sample for the left panel
    grp_a <- pvn_generate(n, 0, pop)
    grp_b <- pvn_generate(n, shift, pop)
    tt <- t.test(grp_a, grp_b)
    wt <- suppressWarnings(wilcox.test(grp_a, grp_b))
    pvn_single_data(list(a = grp_a, b = grp_b, t = tt, w = wt))
  })

  output$pvn_sample_plot <- renderPlotly({
    d <- pvn_single_data()
    req(d)

    plotly::plot_ly(alpha = 0.6) |>
      plotly::add_histogram(x = d$a, name = "Group A",
        marker = list(color = "rgba(35,139,69,0.6)",
                      line = list(color = "white", width = 0.5)),
        hovertemplate = "Value: %{x}<br>Count: %{y}<extra>Group A</extra>") |>
      plotly::add_histogram(x = d$b, name = "Group B",
        marker = list(color = "rgba(38,139,210,0.6)",
                      line = list(color = "white", width = 0.5)),
        hovertemplate = "Value: %{x}<br>Count: %{y}<extra>Group B</extra>") |>
      plotly::layout(
        barmode = "overlay",
        xaxis = list(title = "Value"),
        yaxis = list(title = "Count"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = 1.05, yanchor = "bottom"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$pvn_test_output <- renderUI({
    d <- pvn_single_data()
    req(d)
    t_sig <- if (d$t$p.value < 0.05) "text-success" else "text-danger"
    w_sig <- if (d$w$p.value < 0.05) "text-success" else "text-danger"
    div(
      class = "d-flex gap-4 flex-wrap",
      div(
        style = "flex: 1; min-width: 250px;",
        tags$h6(icon("chart-bar"), " T-test (parametric)"),
        tags$p(
          "t = ", round(d$t$statistic, 3),
          " | df = ", round(d$t$parameter, 1),
          " | ",
          tags$span(class = t_sig, paste0("p = ", format.pval(d$t$p.value, digits = 4)))
        )
      ),
      div(
        style = "flex: 1; min-width: 250px;",
        tags$h6(icon("ranking-star"), " Wilcoxon rank-sum (nonparametric)"),
        tags$p(
          "W = ", round(d$w$statistic, 1),
          " | ",
          tags$span(class = w_sig, paste0("p = ", format.pval(d$w$p.value, digits = 4)))
        )
      )
    )
  })

  output$pvn_power_plot <- renderPlotly({
    res <- pvn_sim_result()
    req(res)

    label <- if (res$shift == 0) "Type I Error Rate" else "Power (rejection rate)"
    tests <- c("T-test", "Wilcoxon")
    rates <- c(res$t_reject, res$w_reject)
    cols <- c("#238b45", "#268bd2")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = tests, y = rates,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        text = paste0(round(rates * 100, 1), "%"),
        textposition = "none",
        hovertemplate = "%{x}: %{y:.1%}<extra></extra>",
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = -0.5, x1 = 1.5,
          y0 = 0.05, y1 = 0.05,
          line = list(color = "#e31a1c", width = 1.5, dash = "dash")
        )),
        annotations = list(
          list(x = 1.5, y = 0.05, text = "\u03b1 = .05", showarrow = FALSE,
               xanchor = "left", font = list(size = 11, color = "#e31a1c"))
        ),
        xaxis = list(title = ""),
        yaxis = list(title = label, tickformat = ".0%",
                     range = c(0, max(0.12, max(rates) * 1.2))),
        title = list(
          text = paste0(res$nsim, " sims | ", res$pop,
                        " | shift = ", res$shift),
          font = list(size = 12)
        ),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
