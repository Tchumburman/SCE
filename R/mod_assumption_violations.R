# ===========================================================================
# Module: Assumption Violation Simulator
# Teaches how violating statistical assumptions affects test validity
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
assumption_violations_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Assumption Violations",
  icon = icon("triangle-exclamation"),
  navset_card_tab(
    id = ns("av_tabs"),

    # ── Tab 1: Normality ──────────────────────────────────────────────────
    nav_panel("Normality", icon = icon("chart-area"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Normality Violation",
          selectInput(ns("av_norm_shape"), "Population Shape",
            choices = c("Normal", "Skewed (Gamma)", "Heavy-tailed (t, df=3)",
                        "Bimodal", "Uniform", "Exponential"),
            selected = "Skewed (Gamma)"),
          sliderInput(ns("av_norm_n"), "Sample Size (per group)", 5, 200, 30, step = 5),
          sliderInput(ns("av_norm_effect"), "True Effect (group difference)", 0, 2, 0.5, step = 0.1),
          sliderInput(ns("av_norm_sims"), "Number of Simulations", 500, 5000, 2000, step = 500),
          actionButton(ns("av_norm_run"), "Run Simulation", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Compares t-test (parametric) and Wilcoxon (nonparametric) under
             different population shapes. With no effect (= 0), tracks Type I error;
             with effect > 0, tracks power.")
        ),
        explanation_box(
          tags$strong("How Normality Violations Affect Tests"),
          tags$p("The t-test assumes that sample means are approximately normally distributed.
                  By the Central Limit Theorem, this is often satisfied with moderate sample sizes
                  even when the underlying population is non-normal. However, with small samples
                  or severely skewed/heavy-tailed distributions, the assumption can be meaningfully violated."),
          tags$p(tags$strong("What to watch for:"),
            tags$ul(
              tags$li("With large n, the t-test is robust to non-normality — Type I error stays near the nominal level."),
              tags$li("With small n and skewed data, the t-test may have inflated or deflated Type I error."),
              tags$li("Heavy-tailed distributions can reduce power of the t-test relative to rank-based alternatives."),
              tags$li("The Wilcoxon test is more robust to heavy tails but tests a slightly different hypothesis (stochastic dominance, not mean difference).")
            )),
          tags$p("This simulation runs many repetitions of both tests under identical conditions,
                  letting you see the empirical rejection rate compared to the nominal alpha = 0.05.")
        ),
        card(
          card_header("Population Shape"),
          plotlyOutput(ns("av_norm_pop_plot"), height = "200px")
        ),
        card(
          card_header("Simulation Results"),
          plotlyOutput(ns("av_norm_results_plot"), height = "350px")
        ),
        card(
          card_header("Rejection Rate Summary"),
          tableOutput(ns("av_norm_table"))
        )
      )
    ),

    # ── Tab 2: Homogeneity of Variance ─────────────────────────────────────
    nav_panel("Equal Variance", icon = icon("arrows-left-right"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Variance Heterogeneity",
          sliderInput(ns("av_var_ratio"), "Variance Ratio (Group 2 / Group 1)",
            1, 10, 1, step = 0.5),
          sliderInput(ns("av_var_n1"), "Group 1 Sample Size", 10, 200, 30, step = 5),
          sliderInput(ns("av_var_n2"), "Group 2 Sample Size", 10, 200, 30, step = 5),
          sliderInput(ns("av_var_effect"), "True Effect (mean difference)", 0, 2, 0, step = 0.1),
          sliderInput(ns("av_var_sims"), "Number of Simulations", 500, 5000, 2000, step = 500),
          actionButton(ns("av_var_run"), "Run Simulation", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Compares Student's t-test (assumes equal variance) vs Welch's t-test
             (does not assume equal variance). Increase the variance ratio to see how
             the classic t-test breaks down.")
        ),
        explanation_box(
          tags$strong("How Unequal Variances Affect the t-Test"),
          tags$p("Student's t-test assumes that both groups have the same population variance.
                  When this assumption is violated (heteroscedasticity), the pooled variance estimate
                  is biased, and the t-statistic's null distribution deviates from the theoretical t-distribution."),
          tags$p(tags$strong("The Behrens-Fisher problem:"),
            "When variances are unequal AND sample sizes are unequal, the Type I error of
             Student's t-test can be substantially inflated or deflated, depending on which
             group (larger or smaller variance) has the larger sample size."),
          tags$p(tags$strong("Welch's correction:"),
            "Welch's t-test adjusts the degrees of freedom to account for unequal variances.
             It is generally recommended as the default because it performs well whether or not
             variances are equal."),
          tags$p(tags$strong("What to watch for:"),
            tags$ul(
              tags$li("Equal n: Student's t-test is fairly robust even with unequal variances."),
              tags$li("Unequal n + unequal variance: Type I error can be seriously distorted with Student's t."),
              tags$li("Welch's test maintains nominal Type I error rate across conditions."),
              tags$li("When the larger group has the larger variance, Student's t becomes conservative (low Type I error, less power).")
            ))
        ),
        card(
          card_header("Group Distributions"),
          plotlyOutput(ns("av_var_pop_plot"), height = "200px")
        ),
        card(
          card_header("Simulation Results"),
          plotlyOutput(ns("av_var_results_plot"), height = "350px")
        ),
        card(
          card_header("Rejection Rate Summary"),
          tableOutput(ns("av_var_table"))
        )
      )
    ),

    # ── Tab 3: Independence ───────────────────────────────────────────────
    nav_panel("Independence", icon = icon("link"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Independence Violation",
          sliderInput(ns("av_ind_icc"), "Intraclass Correlation (ICC)",
            0, 0.5, 0, step = 0.05),
          sliderInput(ns("av_ind_clusters"), "Number of Clusters", 5, 50, 20, step = 5),
          sliderInput(ns("av_ind_cluster_size"), "Observations per Cluster", 2, 30, 10, step = 1),
          sliderInput(ns("av_ind_sims"), "Number of Simulations", 500, 5000, 2000, step = 500),
          actionButton(ns("av_ind_run"), "Run Simulation", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Simulates clustered data (e.g., students in classrooms) where observations
             within a cluster are correlated. Shows how ignoring clustering inflates
             Type I error of an ordinary t-test.")
        ),
        explanation_box(
          tags$strong("How Violating Independence Inflates Type I Error"),
          tags$p("Independence is often the most important assumption in statistical testing.
                  When observations are clustered (students in classrooms, patients in hospitals,
                  repeated measurements on the same person), ignoring this structure leads to
                  underestimated standard errors and inflated Type I error rates."),
          tags$p(tags$strong("The mechanism:"),
            "With clustered data, the effective sample size is smaller than the nominal sample
             size. A standard t-test treats every observation as independent information, which
             overestimates the precision of the mean estimate."),
          tags$p(tags$strong("The ICC controls severity:"),
            tags$ul(
              tags$li("ICC = 0: No clustering effect — observations are truly independent."),
              tags$li("ICC = 0.05: Modest clustering — common in educational research. Even this can substantially inflate Type I error with many observations per cluster."),
              tags$li("ICC = 0.2+: Strong clustering — ignoring it can push Type I error to 30-50% or more."),
              tags$li("The design effect = 1 + (cluster size - 1) * ICC, and the effective N ≈ N / design effect.")
            )),
          tags$p("The correct approach is to use multilevel models (random effects) or
                  cluster-robust standard errors that account for the dependence structure.")
        ),
        card(
          card_header("Effective Sample Size"),
          uiOutput(ns("av_ind_deff_info"))
        ),
        card(
          card_header("Simulation Results: Type I Error"),
          plotlyOutput(ns("av_ind_results_plot"), height = "350px")
        ),
        card(
          card_header("Rejection Rate Summary"),
          tableOutput(ns("av_ind_table"))
        )
      )
    ),

    # ── Tab 4: Linearity ─────────────────────────────────────────────────
    nav_panel("Linearity", icon = icon("chart-line"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Linearity Violation",
          selectInput(ns("av_lin_true_shape"), "True Relationship",
            choices = c("Linear", "Quadratic", "Logarithmic",
                        "Threshold (step)", "Sinusoidal"),
            selected = "Quadratic"),
          sliderInput(ns("av_lin_n"), "Sample Size", 30, 500, 100, step = 10),
          sliderInput(ns("av_lin_noise"), "Noise Level (SD)", 0.5, 5, 2, step = 0.5),
          sliderInput(ns("av_lin_strength"), "Relationship Strength", 0.5, 5, 2, step = 0.5),
          actionButton(ns("av_lin_run"), "Generate Data", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Generates data from a non-linear relationship and fits a linear model.
             Shows how residual plots reveal the violation and how predictions diverge.")
        ),
        explanation_box(
          tags$strong("What Happens When the True Relationship Isn't Linear"),
          tags$p("Linear regression assumes the conditional mean of Y given X is a linear function.
                  When the true relationship is curved, the linear model is misspecified:
                  it captures part of the relationship but systematically misses the rest."),
          tags$p(tags$strong("Consequences of non-linearity:"),
            tags$ul(
              tags$li("Biased predictions — the model over-predicts in some regions and under-predicts in others."),
              tags$li("Biased slope coefficient — it represents a linear approximation of a non-linear function."),
              tags$li("Residual patterns — residuals show systematic curvature instead of random scatter."),
              tags$li("Misleading R² — may appear decent even though the model is fundamentally wrong."),
              tags$li("Invalid inference — confidence intervals and p-values for the slope are based on wrong assumptions.")
            )),
          tags$p(tags$strong("Diagnosis:"),
            "Residual vs. fitted plots are the primary diagnostic. A well-fitting linear model
             shows random scatter; curvature or patterns indicate non-linearity. The 'true vs. fitted'
             overlay plot also reveals where the linear model diverges from reality.")
        ),
        card(
          card_header("Scatter Plot with Linear Fit vs. True Curve"),
          plotlyOutput(ns("av_lin_scatter"), height = "350px")
        ),
        layout_column_wrap(width = 1/2,
          card(
            card_header("Residuals vs. Fitted"),
            plotlyOutput(ns("av_lin_resid"), height = "280px")
          ),
          card(
            card_header("Q-Q Plot of Residuals"),
            plotlyOutput(ns("av_lin_qq"), height = "280px")
          )
        ),
        card(
          card_header("Model Summary"),
          uiOutput(ns("av_lin_summary"))
        )
      )
    ),

    # ── Tab 5: Outlier Impact ─────────────────────────────────────────────
    nav_panel("Outlier Impact", icon = icon("burst"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Outlier Effects",
          sliderInput(ns("av_out_n"), "Sample Size", 20, 200, 50, step = 10),
          sliderInput(ns("av_out_n_outliers"), "Number of Outliers", 0, 10, 2, step = 1),
          sliderInput(ns("av_out_magnitude"), "Outlier Magnitude (SDs from mean)",
            2, 10, 5, step = 0.5),
          selectInput(ns("av_out_analysis"), "Analysis Type",
            choices = c("Mean vs. Median", "Correlation (Pearson vs. Spearman)",
                        "Regression (OLS vs. Robust)"),
            selected = "Correlation (Pearson vs. Spearman)"),
          actionButton(ns("av_out_run"), "Generate Data", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Generates clean data then adds outliers. Shows how different
             analyses are affected and how robust alternatives compare.")
        ),
        explanation_box(
          tags$strong("How Outliers Distort Statistical Analyses"),
          tags$p("Outliers are observations that lie far from the bulk of the data. Their effect
                  depends on the analysis: some methods (OLS regression, Pearson correlation, the mean)
                  are highly sensitive to extreme values, while robust alternatives (median, Spearman,
                  M-estimators) down-weight or ignore them."),
          tags$p(tags$strong("Why outliers matter:"),
            tags$ul(
              tags$li("The mean is pulled toward outliers; the median is not (breakdown point of 50% vs 0%)."),
              tags$li("Pearson correlation can be dramatically inflated or deflated by a single outlier."),
              tags$li("OLS regression minimizes squared residuals, giving extreme leverage to outliers."),
              tags$li("A single influential point can reverse the sign of a regression slope.")
            )),
          tags$p(tags$strong("Robust alternatives:"),
            tags$ul(
              tags$li("Median and trimmed mean for location."),
              tags$li("Spearman rank correlation instead of Pearson."),
              tags$li("Robust regression (M-estimation, MM-estimation) instead of OLS."),
              tags$li("Always inspect your data visually — residual plots and scatter plots reveal what summary statistics hide.")
            ))
        ),
        card(
          card_header("Data Visualization"),
          plotlyOutput(ns("av_out_plot"), height = "350px")
        ),
        card(
          card_header("Comparison: Standard vs. Robust"),
          tableOutput(ns("av_out_table"))
        ),
        card(
          card_header("Impact Summary"),
          uiOutput(ns("av_out_summary"))
        )
      )
    )
  )
)


# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

assumption_violations_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Helper: generate population samples ──────────────────────────────
  gen_pop <- function(n, shape) {
    switch(shape,
      "Normal" = rnorm(n),
      "Skewed (Gamma)" = {
        x <- rgamma(n, shape = 2, rate = 1)
        (x - mean(x)) / sd(x)
      },
      "Heavy-tailed (t, df=3)" = {
        x <- rt(n, df = 3)
        (x - mean(x)) / sd(x)
      },
      "Bimodal" = {
        x <- c(rnorm(floor(n/2), -2, 1), rnorm(ceiling(n/2), 2, 1))
        sample((x - mean(x)) / sd(x))
      },
      "Uniform" = {
        x <- runif(n, -1, 1)
        (x - mean(x)) / sd(x)
      },
      "Exponential" = {
        x <- rexp(n, 1)
        (x - mean(x)) / sd(x)
      },
      rnorm(n)
    )
  }

  # ── Helper: rejection rate bar chart (reused in 3 tabs) ──────────────
  .av_rate_bar <- function(rates, title, subtitle) {
    cols <- c("#268bd2", "#2aa198")
    if (nrow(rates) == 1) cols <- cols[1]
    plotly::plot_ly(
      x = rates$Test, y = rates$Rejection_Rate,
      type = "bar", marker = list(color = cols, opacity = 0.85),
      text = sprintf("%.1f%%", rates$Rejection_Rate * 100),
      textposition = "outside",
      hoverinfo = "text",
      hovertext = sprintf("%s<br>Rejection rate: %.2f%%",
                          rates$Test, rates$Rejection_Rate * 100),
      showlegend = FALSE
    ) |>
      plotly::layout(
        title = list(text = paste0(title, "<br><sup>", subtitle, "</sup>"),
                     font = list(size = 14)),
        shapes = list(list(
          type = "line", x0 = -0.5, x1 = nrow(rates) - 0.5,
          y0 = 0.05, y1 = 0.05,
          line = list(color = "#dc322f", dash = "dash", width = 1.5)
        )),
        annotations = list(list(
          x = nrow(rates) - 0.5, y = 0.05,
          text = "\u03b1 = .05", showarrow = FALSE,
          xanchor = "left", yanchor = "bottom",
          font = list(color = "#dc322f", size = 11)
        )),
        xaxis = list(title = ""),
        yaxis = list(title = "Rejection Rate",
                     tickformat = ".0%",
                     range = c(0, max(0.15, max(rates$Rejection_Rate) * 1.3))),
        margin = list(t = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  }

  # ══════════════════════════════════════════════════════════════════════
  # Tab 1: Normality
  # ══════════════════════════════════════════════════════════════════════
  output$av_norm_pop_plot <- plotly::renderPlotly({
    x <- gen_pop(10000, input$av_norm_shape)
    d <- density(x)
    plotly::plot_ly() |>
      plotly::add_histogram(
        x = x, histnorm = "probability density",
        marker = list(color = "rgba(42,161,152,0.6)",
                      line = list(color = "rgba(42,161,152,0.8)", width = 0.5)),
        nbinsx = 60, name = "Histogram", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = d$x, y = d$y, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2),
        name = "Density", showlegend = FALSE
      ) |>
      plotly::layout(
        title = list(text = paste("Population:", input$av_norm_shape),
                     font = list(size = 13)),
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  av_norm_results <- eventReactive(input$av_norm_run, {
    n <- input$av_norm_n
    eff <- input$av_norm_effect
    nsim <- input$av_norm_sims
    shape <- input$av_norm_shape

    p_t <- p_w <- numeric(nsim)
    for (i in seq_len(nsim)) {
      g1 <- gen_pop(n, shape)
      g2 <- gen_pop(n, shape) + eff
      p_t[i] <- t.test(g1, g2)$p.value
      p_w[i] <- suppressWarnings(wilcox.test(g1, g2)$p.value)
    }
    data.frame(
      Test = rep(c("t-test", "Wilcoxon"), each = nsim),
      p_value = c(p_t, p_w)
    )
  })

  output$av_norm_results_plot <- plotly::renderPlotly({
    req(av_norm_results())
    df <- av_norm_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection_Rate"

    sub <- if (input$av_norm_effect == 0)
      "No true effect \u2014 should be near 5% (Type I error)"
    else
      paste0("True effect = ", input$av_norm_effect, " SD \u2014 measures power")

    .av_rate_bar(
      rates,
      title = sprintf("Rejection Rate (%d simulations, n=%d)",
                      input$av_norm_sims, input$av_norm_n),
      subtitle = sub
    )
  })

  output$av_norm_table <- renderTable({
    req(av_norm_results())
    df <- av_norm_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection Rate"
    rates$`Rejection Rate` <- sprintf("%.1f%%", rates$`Rejection Rate` * 100)
    rates$`Nominal Alpha` <- "5.0%"
    rates$Condition <- paste0(input$av_norm_shape, ", n=", input$av_norm_n,
                              ", effect=", input$av_norm_effect)
    rates
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 2: Equal Variance
  # ══════════════════════════════════════════════════════════════════════
  output$av_var_pop_plot <- plotly::renderPlotly({
    sd1 <- 1
    sd2 <- sqrt(input$av_var_ratio)
    x1 <- rnorm(5000, 0, sd1)
    x2 <- rnorm(5000, input$av_var_effect, sd2)
    d1 <- density(x1)
    d2 <- density(x2)
    plotly::plot_ly() |>
      plotly::add_trace(
        x = d1$x, y = d1$y, type = "scatter", mode = "lines",
        fill = "tozeroy",
        fillcolor = "rgba(38,139,210,0.25)",
        line = list(color = "#268bd2", width = 1.5),
        name = "Group 1"
      ) |>
      plotly::add_trace(
        x = d2$x, y = d2$y, type = "scatter", mode = "lines",
        fill = "tozeroy",
        fillcolor = "rgba(42,161,152,0.25)",
        line = list(color = "#2aa198", width = 1.5),
        name = "Group 2"
      ) |>
      plotly::layout(
        title = list(
          text = sprintf("Group 1: SD=1 | Group 2: SD=%.1f (ratio=%.1f)",
                         sd2, input$av_var_ratio),
          font = list(size = 13)),
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        margin = list(t = 40),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  av_var_results <- eventReactive(input$av_var_run, {
    n1 <- input$av_var_n1
    n2 <- input$av_var_n2
    sd2 <- sqrt(input$av_var_ratio)
    eff <- input$av_var_effect
    nsim <- input$av_var_sims

    p_student <- p_welch <- numeric(nsim)
    for (i in seq_len(nsim)) {
      g1 <- rnorm(n1, 0, 1)
      g2 <- rnorm(n2, eff, sd2)
      p_student[i] <- t.test(g1, g2, var.equal = TRUE)$p.value
      p_welch[i] <- t.test(g1, g2, var.equal = FALSE)$p.value
    }
    data.frame(
      Test = rep(c("Student's t", "Welch's t"), each = nsim),
      p_value = c(p_student, p_welch)
    )
  })

  output$av_var_results_plot <- plotly::renderPlotly({
    req(av_var_results())
    df <- av_var_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection_Rate"

    sub <- if (input$av_var_effect == 0) "No true effect \u2014 should be near 5%"
           else paste0("True effect = ", input$av_var_effect)

    .av_rate_bar(
      rates,
      title = sprintf("Rejection Rate (n1=%d, n2=%d, var ratio=%.1f)",
                      input$av_var_n1, input$av_var_n2, input$av_var_ratio),
      subtitle = sub
    )
  })

  output$av_var_table <- renderTable({
    req(av_var_results())
    df <- av_var_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection Rate"
    rates$`Rejection Rate` <- sprintf("%.1f%%", rates$`Rejection Rate` * 100)
    rates$`Variance Ratio` <- input$av_var_ratio
    rates$`n1 / n2` <- paste0(input$av_var_n1, " / ", input$av_var_n2)
    rates
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 3: Independence
  # ══════════════════════════════════════════════════════════════════════
  output$av_ind_deff_info <- renderUI({
    icc <- input$av_ind_icc
    m <- input$av_ind_cluster_size
    k <- input$av_ind_clusters
    total_n <- k * m
    deff <- 1 + (m - 1) * icc
    eff_n <- total_n / deff

    tags$div(class = "p-3",
      tags$p(tags$strong("Total N: "), total_n,
             " (", k, " clusters \u00d7 ", m, " per cluster)"),
      tags$p(tags$strong("Design Effect: "), sprintf("%.2f", deff),
             "  = 1 + (", m, " - 1) \u00d7 ", icc),
      tags$p(tags$strong("Effective N: "), sprintf("%.1f", eff_n),
             if (deff > 1.5) tags$span(class = "text-danger",
               sprintf(" \u2014 only %.0f%% of nominal N!", 100 * eff_n / total_n)))
    )
  })

  av_ind_results <- eventReactive(input$av_ind_run, {
    icc <- input$av_ind_icc
    k <- input$av_ind_clusters
    m <- input$av_ind_cluster_size
    nsim <- input$av_ind_sims

    p_naive <- p_mixed <- numeric(nsim)
    sigma_b <- sqrt(icc)
    sigma_w <- sqrt(1 - icc)

    for (i in seq_len(nsim)) {
      cluster_eff <- rnorm(k, 0, sigma_b)
      group <- rep(c(0, 1), each = k / 2)
      y <- unlist(lapply(seq_len(k), function(j) {
        cluster_eff[j] + rnorm(m, 0, sigma_w)
      }))
      grp <- rep(group, each = m)
      cluster_id <- rep(seq_len(k), each = m)

      p_naive[i] <- t.test(y ~ grp)$p.value

      cluster_means <- tapply(y, cluster_id, mean)
      cluster_grp <- rep(c(0, 1), each = k / 2)
      p_mixed[i] <- t.test(cluster_means ~ cluster_grp)$p.value
    }
    data.frame(
      Test = rep(c("Naive t-test (ignores clusters)",
                    "Cluster-means t-test"), each = nsim),
      p_value = c(p_naive, p_mixed)
    )
  })

  output$av_ind_results_plot <- plotly::renderPlotly({
    req(av_ind_results())
    df <- av_ind_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection_Rate"

    .av_rate_bar(
      rates,
      title = sprintf("Type I Error (ICC=%.2f, %d clusters, %d per cluster)",
                      input$av_ind_icc, input$av_ind_clusters, input$av_ind_cluster_size),
      subtitle = "No true effect \u2014 both should be near 5%"
    )
  })

  output$av_ind_table <- renderTable({
    req(av_ind_results())
    df <- av_ind_results()
    rates <- aggregate(p_value ~ Test, df, function(p) mean(p < 0.05))
    names(rates)[2] <- "Rejection Rate"
    rates$`Rejection Rate` <- sprintf("%.1f%%", rates$`Rejection Rate` * 100)
    rates$ICC <- input$av_ind_icc
    deff <- 1 + (input$av_ind_cluster_size - 1) * input$av_ind_icc
    rates$`Design Effect` <- sprintf("%.2f", deff)
    rates
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 4: Linearity
  # ══════════════════════════════════════════════════════════════════════
  av_lin_data <- eventReactive(input$av_lin_run, {
    n <- input$av_lin_n
    noise <- input$av_lin_noise
    strength <- input$av_lin_strength
    shape <- input$av_lin_true_shape

    x <- seq(-3, 3, length.out = n) + rnorm(n, 0, 0.1)

    y_true <- switch(shape,
      "Linear" = strength * x,
      "Quadratic" = strength * x^2,
      "Logarithmic" = strength * log(x - min(x) + 1),
      "Threshold (step)" = strength * ifelse(x > 0, 1, 0),
      "Sinusoidal" = strength * sin(x * pi / 2),
      strength * x
    )
    y <- y_true + rnorm(n, 0, noise)

    data.frame(x = x, y = y, y_true = y_true)
  })

  output$av_lin_scatter <- plotly::renderPlotly({
    req(av_lin_data())
    df <- av_lin_data()
    fit <- lm(y ~ x, data = df)
    df$fitted <- fitted(fit)
    ord <- order(df$x)
    dfo <- df[ord, ]

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$x, y = df$y,
        marker = list(color = "#657b83", opacity = 0.4, size = 5),
        name = "Data", showlegend = TRUE,
        hoverinfo = "text",
        hovertext = sprintf("x: %.2f<br>y: %.2f", df$x, df$y)
      ) |>
      plotly::add_trace(
        x = dfo$x, y = dfo$y_true, type = "scatter", mode = "lines",
        line = list(color = "#2aa198", width = 2.5),
        name = "True curve"
      ) |>
      plotly::add_trace(
        x = dfo$x, y = dfo$fitted, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2, dash = "dash"),
        name = "Linear fit"
      ) |>
      plotly::layout(
        title = list(text = paste("True relationship:", input$av_lin_true_shape),
                     font = list(size = 14)),
        xaxis = list(title = "X"),
        yaxis = list(title = "Y"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$av_lin_resid <- plotly::renderPlotly({
    req(av_lin_data())
    df <- av_lin_data()
    fit <- lm(y ~ x, data = df)
    fv <- fitted(fit)
    res <- residuals(fit)

    # Loess smooth for residuals
    lo <- loess(res ~ fv)
    ord <- order(fv)
    lo_pred <- predict(lo, newdata = data.frame(fv = fv[ord]))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = fv, y = res,
        marker = list(color = "#268bd2", opacity = 0.4, size = 5),
        name = "Residuals", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("Fitted: %.2f<br>Residual: %.2f", fv, res)
      ) |>
      plotly::add_trace(
        x = fv[ord], y = lo_pred, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2),
        name = "Loess", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = min(fv), x1 = max(fv), y0 = 0, y1 = 0,
          line = list(color = "#586e75", dash = "dash", width = 1)
        )),
        title = list(text = "Residuals vs. Fitted", font = list(size = 13)),
        xaxis = list(title = "Fitted Values"),
        yaxis = list(title = "Residuals"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$av_lin_qq <- plotly::renderPlotly({
    req(av_lin_data())
    df <- av_lin_data()
    fit <- lm(y ~ x, data = df)
    r <- residuals(fit)

    # QQ coordinates
    qq <- qqnorm(r, plot.it = FALSE)
    # Reference line through Q1/Q3
    probs <- c(0.25, 0.75)
    qx <- qnorm(probs)
    qy <- quantile(r, probs)
    slope <- diff(qy) / diff(qx)
    int <- qy[1] - slope * qx[1]
    xl <- range(qq$x)

    plotly::plot_ly() |>
      plotly::add_markers(
        x = qq$x, y = qq$y,
        marker = list(color = "#268bd2", opacity = 0.4, size = 5),
        name = "Residuals", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("Theoretical: %.2f<br>Sample: %.2f", qq$x, qq$y)
      ) |>
      plotly::add_trace(
        x = xl, y = int + slope * xl,
        type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2),
        name = "Reference", showlegend = FALSE
      ) |>
      plotly::layout(
        title = list(text = "Q-Q Plot of Residuals", font = list(size = 13)),
        xaxis = list(title = "Theoretical Quantiles"),
        yaxis = list(title = "Sample Quantiles"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$av_lin_summary <- renderUI({
    req(av_lin_data())
    df <- av_lin_data()
    fit <- lm(y ~ x, data = df)
    s <- summary(fit)
    cc <- s$coefficients

    coef_rows <- vapply(seq_len(nrow(cc)), function(i) {
      pv <- cc[i, "Pr(>|t|)"]
      p_str <- if (pv < 0.001) "< .001" else sprintf("%.4f", pv)
      sprintf("<tr><td>%s</td><td>%.3f</td><td>%.3f</td><td>%.2f</td><td>%s</td></tr>",
              rownames(cc)[i], cc[i, 1], cc[i, 2], cc[i, 3], p_str)
    }, character(1))

    ss_total <- sum((df$y - mean(df$y))^2)
    ss_resid_true <- sum((df$y - df$y_true)^2)
    r2_true <- max(0, 1 - ss_resid_true / ss_total)
    gap <- r2_true - s$r.squared

    HTML(sprintf('
      <div style="padding: 0.5rem;">
        <div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">
          Linear Model: y ~ x
        </div>
        <table class="table table-sm table-striped mb-3" style="font-size: 0.9rem;">
          <thead><tr><th>Term</th><th>Estimate</th><th>SE</th><th>t</th><th>p</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <table class="table table-sm mb-2" style="font-size: 0.9rem; max-width: 420px;">
          <tr><td><strong>R\u00b2 (linear fit)</strong></td><td>%.3f</td></tr>
          <tr><td><strong>R\u00b2 (true model)</strong></td><td>%.3f</td></tr>
          <tr><td><strong>Gap</strong></td><td>%.3f</td></tr>
        </table>
        <small class="text-muted">
          Gap = information lost due to model misspecification.
          Residual SE = %.3f on %d df.
        </small>
      </div>',
      paste(coef_rows, collapse = ""),
      s$r.squared, r2_true, gap,
      s$sigma, s$df[2]
    ))
  })

  # ══════════════════════════════════════════════════════════════════════
  # Tab 5: Outlier Impact
  # ══════════════════════════════════════════════════════════════════════
  av_out_data <- eventReactive(input$av_out_run, {
    set.seed(sample(1:10000, 1))
    n <- input$av_out_n
    n_out <- input$av_out_n_outliers
    mag <- input$av_out_magnitude

    x <- rnorm(n)
    y <- 0.6 * x + rnorm(n, 0, 0.8)
    outlier <- rep(FALSE, n)

    if (n_out > 0) {
      idx <- sample(n, min(n_out, n))
      x[idx] <- mag * sample(c(-1, 1), length(idx), replace = TRUE)
      y[idx] <- -0.6 * x[idx] + rnorm(length(idx), 0, 0.3)
      outlier[idx] <- TRUE
    }

    data.frame(x = x, y = y, outlier = outlier)
  })

  output$av_out_plot <- plotly::renderPlotly({
    req(av_out_data())
    df <- av_out_data()
    analysis <- input$av_out_analysis

    if (analysis == "Mean vs. Median") {
      m_val <- mean(df$y)
      med_val <- median(df$y)
      plotly::plot_ly() |>
        plotly::add_histogram(
          x = df$y, nbinsx = 30,
          marker = list(color = "rgba(38,139,210,0.6)",
                        line = list(color = "rgba(38,139,210,0.8)", width = 0.5)),
          name = "Y", showlegend = FALSE
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = m_val, x1 = m_val,
                 y0 = 0, y1 = 1, yref = "paper",
                 line = list(color = "#dc322f", dash = "dash", width = 2)),
            list(type = "line", x0 = med_val, x1 = med_val,
                 y0 = 0, y1 = 1, yref = "paper",
                 line = list(color = "#2aa198", width = 2))
          ),
          annotations = list(
            list(x = m_val, y = 1, yref = "paper",
                 text = sprintf("Mean = %.2f", m_val),
                 showarrow = FALSE, xanchor = "left", yanchor = "top",
                 font = list(color = "#dc322f", size = 12)),
            list(x = med_val, y = 0.85, yref = "paper",
                 text = sprintf("Median = %.2f", med_val),
                 showarrow = FALSE, xanchor = "left", yanchor = "top",
                 font = list(color = "#2aa198", size = 12))
          ),
          title = list(text = "Distribution of Y", font = list(size = 14)),
          xaxis = list(title = "Y"),
          yaxis = list(title = "Count"),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

    } else {
      # Scatter plot for correlation and regression analyses
      clean_df <- df[!df$outlier, ]
      out_df <- df[df$outlier, ]

      p <- plotly::plot_ly() |>
        plotly::add_markers(
          x = clean_df$x, y = clean_df$y,
          marker = list(color = "#268bd2", opacity = 0.7, size = 7),
          name = "Clean",
          hoverinfo = "text",
          hovertext = sprintf("x: %.2f<br>y: %.2f", clean_df$x, clean_df$y)
        )
      if (nrow(out_df) > 0) {
        p <- p |> plotly::add_markers(
          x = out_df$x, y = out_df$y,
          marker = list(color = "#dc322f", opacity = 0.7, size = 8,
                        symbol = "diamond"),
          name = "Outlier",
          hoverinfo = "text",
          hovertext = sprintf("x: %.2f<br>y: %.2f (outlier)", out_df$x, out_df$y)
        )
      }

      # Regression lines
      ord <- order(df$x)
      xsort <- df$x[ord]

      if (analysis == "Correlation (Pearson vs. Spearman)") {
        fit_all <- lm(y ~ x, data = df)
        fit_clean <- lm(y ~ x, data = clean_df)
        p <- p |>
          plotly::add_trace(
            x = xsort, y = predict(fit_all, newdata = data.frame(x = xsort)),
            type = "scatter", mode = "lines",
            line = list(color = "#dc322f", width = 2, dash = "dash"),
            name = "With outliers"
          ) |>
          plotly::add_trace(
            x = xsort, y = predict(fit_clean, newdata = data.frame(x = xsort)),
            type = "scatter", mode = "lines",
            line = list(color = "#2aa198", width = 2),
            name = "Without outliers"
          )
      } else {
        fit_ols <- lm(y ~ x, data = df)
        fit_rob <- MASS::rlm(y ~ x, data = df)
        p <- p |>
          plotly::add_trace(
            x = xsort, y = predict(fit_ols, newdata = data.frame(x = xsort)),
            type = "scatter", mode = "lines",
            line = list(color = "#dc322f", width = 2, dash = "dash"),
            name = "OLS"
          ) |>
          plotly::add_trace(
            x = xsort, y = predict(fit_rob, newdata = data.frame(x = xsort)),
            type = "scatter", mode = "lines",
            line = list(color = "#2aa198", width = 2),
            name = "Robust"
          )
      }

      p |> plotly::layout(
        title = list(text = if (analysis == "Correlation (Pearson vs. Spearman)")
          "Red dashed = with outliers | Green = without outliers"
          else "Red dashed = OLS | Green = Robust regression",
          font = list(size = 13)),
        xaxis = list(title = "X"),
        yaxis = list(title = "Y"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$av_out_table <- renderTable({
    req(av_out_data())
    df <- av_out_data()
    analysis <- input$av_out_analysis

    if (analysis == "Mean vs. Median") {
      clean <- df$y[!df$outlier]
      data.frame(
        Statistic = c("Mean", "Median", "Trimmed Mean (10%)", "SD", "MAD"),
        `With Outliers` = c(sprintf("%.3f", mean(df$y)),
                            sprintf("%.3f", median(df$y)),
                            sprintf("%.3f", mean(df$y, trim = 0.1)),
                            sprintf("%.3f", sd(df$y)),
                            sprintf("%.3f", mad(df$y))),
        `Clean Data Only` = c(sprintf("%.3f", mean(clean)),
                              sprintf("%.3f", median(clean)),
                              sprintf("%.3f", mean(clean, trim = 0.1)),
                              sprintf("%.3f", sd(clean)),
                              sprintf("%.3f", mad(clean))),
        check.names = FALSE
      )
    } else if (analysis == "Correlation (Pearson vs. Spearman)") {
      clean <- df[!df$outlier, ]
      data.frame(
        Method = c("Pearson", "Spearman"),
        `With Outliers` = c(sprintf("%.3f", cor(df$x, df$y)),
                            sprintf("%.3f", cor(df$x, df$y, method = "spearman"))),
        `Without Outliers` = c(sprintf("%.3f", cor(clean$x, clean$y)),
                               sprintf("%.3f", cor(clean$x, clean$y, method = "spearman"))),
        check.names = FALSE
      )
    } else {
      fit_ols <- lm(y ~ x, data = df)
      fit_rob <- MASS::rlm(y ~ x, data = df)
      fit_clean <- lm(y ~ x, data = df[!df$outlier, ])

      data.frame(
        Method = c("OLS", "Robust (M-est)", "OLS (clean only)"),
        Intercept = sprintf("%.3f", c(coef(fit_ols)[1], coef(fit_rob)[1], coef(fit_clean)[1])),
        Slope = sprintf("%.3f", c(coef(fit_ols)[2], coef(fit_rob)[2], coef(fit_clean)[2])),
        check.names = FALSE
      )
    }
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$av_out_summary <- renderUI({
    req(av_out_data())
    df <- av_out_data()
    n_out <- sum(df$outlier)
    n_total <- nrow(df)
    pct <- 100 * n_out / n_total

    if (n_out == 0) {
      tags$div(class = "alert alert-info",
        icon("info-circle"), " No outliers present. This is the baseline \u2014 add outliers to see their effect.")
    } else {
      analysis <- input$av_out_analysis
      msg <- if (analysis == "Correlation (Pearson vs. Spearman)") {
        r_all <- cor(df$x, df$y)
        r_clean <- cor(df$x[!df$outlier], df$y[!df$outlier])
        sprintf("Pearson r changed from %.3f (clean) to %.3f (with outliers) \u2014 a shift of %.3f. Spearman is more resistant.",
                r_clean, r_all, abs(r_all - r_clean))
      } else if (analysis == "Mean vs. Median") {
        sprintf("Mean shifted by %.3f from the clean-data mean; median shifted by only %.3f.",
                abs(mean(df$y) - mean(df$y[!df$outlier])),
                abs(median(df$y) - median(df$y[!df$outlier])))
      } else {
        b_ols <- coef(lm(y ~ x, data = df))[2]
        b_clean <- coef(lm(y ~ x, data = df[!df$outlier, ]))[2]
        sprintf("OLS slope changed from %.3f (clean) to %.3f (with outliers). Robust regression is more resistant.",
                b_clean, b_ols)
      }

      tags$div(class = "alert alert-warning",
        icon("triangle-exclamation"),
        sprintf(" %d outlier(s) (%.1f%% of data). ", n_out, pct),
        msg
      )
    }
  })
  })
}
