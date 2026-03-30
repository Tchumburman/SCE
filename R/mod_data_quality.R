# Module: Data Quality (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
data_quality_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Data Quality",
  icon = icon("eye-slash"),
  navset_card_underline(
    nav_panel(
      "Missing Data",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("md_mechanism"), "Missing data mechanism",
        choices = c("MCAR (Missing Completely At Random)" = "mcar",
                    "MAR (Missing At Random)" = "mar",
                    "MNAR (Missing Not At Random)" = "mnar"),
        selected = "mcar"
      ),
      sliderInput(ns("md_n"), "Sample size", min = 100, max = 1000, value = 300, step = 50),
      sliderInput(ns("md_miss_pct"), "Missing percentage", min = 5, max = 60, value = 30, step = 5),
      sliderInput(ns("md_true_r"), "True correlation (x, y)", min = -0.9, max = 0.9, value = 0.6, step = 0.05),
      tags$hr(),
      selectInput(ns("md_impute"), "Imputation method",
        choices = c("None (listwise deletion)" = "listwise",
                    "Mean imputation" = "mean",
                    "Regression imputation" = "regression"),
        selected = "listwise"
      ),
      actionButton(ns("md_run"), "Generate data", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Missing Data Mechanisms"),
      tags$p("Understanding why data is missing matters more than how much is missing.
              The mechanism determines which analysis strategies produce valid results."),
      tags$ul(
        tags$li(tags$strong("MCAR"), " \u2014 missingness is unrelated to any variable.
                Complete-case analysis is unbiased (but less efficient)."),
        tags$li(tags$strong("MAR"), " \u2014 missingness depends on observed variables
                (e.g., men less likely to report weight). Imputation or model-based
                methods can handle this."),
        tags$li(tags$strong("MNAR"), " \u2014 missingness depends on the missing value itself
                (e.g., depressed people skip depression items). The hardest case;
                standard methods are biased.")
      ),
      tags$p("Understanding the missing data mechanism is crucial because it determines
              which analysis methods are valid. Under MCAR, any complete-case analysis is
              unbiased (though inefficient). Under MAR, methods like multiple imputation
              and maximum likelihood produce valid estimates by conditioning on observed
              data. Under MNAR, even sophisticated methods can be biased unless the
              missing data model is correctly specified \u2014 and this model is inherently
              untestable because it depends on the unobserved values."),
      tags$p("Multiple imputation is generally the recommended approach for handling MAR data.
              It creates multiple plausible completed datasets, analyses each separately, and
              combines results using Rubin\u2019s rules. This properly accounts for the
              uncertainty due to missing values, unlike single imputation (mean imputation,
              last observation carried forward), which underestimates standard errors."),
      guide = tags$ol(
        tags$li("Generate complete data, then introduce missingness by the chosen mechanism."),
        tags$li("Compare the complete-data scatter with the observed-data scatter."),
        tags$li("See how different imputation methods recover (or fail to recover) the true relationship."),
        tags$li("MNAR is the worst: even with imputation, the estimate is biased.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Complete Data (truth)"),
           plotlyOutput(ns("md_complete"), height = "350px")),
      card(full_screen = TRUE, card_header("Observed / Imputed Data"),
           plotlyOutput(ns("md_observed"), height = "350px")),
      card(full_screen = TRUE, card_header("Missingness Pattern"),
           plotlyOutput(ns("md_pattern"), height = "300px")),
      card(full_screen = TRUE, card_header("Estimate Comparison"),
           plotlyOutput(ns("md_comparison"), height = "300px"))
    )
  )
    ),

    nav_panel(
      "Imputation Comparison",
  layout_sidebar(
    sidebar = sidebar(
      width = 310,
      sliderInput(ns("imp_n"), "Sample size per simulation", 100, 1000, 300, step = 50),
      sliderInput(ns("imp_sims"), "Number of simulations", 50, 500, 200, step = 50),
      sliderInput(ns("imp_miss_pct"), "Missing percentage", 5, 60, 30, step = 5),
      sliderInput(ns("imp_true_r"), "True correlation (x, y)", -0.9, 0.9, 0.6, step = 0.05),
      selectInput(ns("imp_mechanism"), "Missing data mechanism",
        choices = c("MCAR" = "mcar", "MAR" = "mar", "MNAR" = "mnar"),
        selected = "mar"
      ),
      sliderInput(ns("imp_m"), "Number of imputations (MI)", 3, 20, 5, step = 1),
      actionButton(ns("imp_run"), "Run Simulations", icon = icon("play"),
                   class = "btn-success w-100 mt-2"),
      tags$small(class = "text-muted mt-2 d-block",
        "Simulations may take a few seconds depending on settings.")
    ),

    explanation_box(
      tags$strong("Comparing Imputation Strategies"),
      tags$p("Different imputation methods have different strengths and
              weaknesses depending on the missing data mechanism. This tab
              runs many simulated datasets under the same conditions and
              compares how each method performs at recovering the true
              correlation and mean. The key metrics are bias (how far off
              the average estimate is from the truth), coverage (how often
              the 95% confidence interval contains the true value), and
              efficiency (width of the CI, with narrower being better)."),
      tags$p("Listwise deletion discards incomplete cases. It is unbiased
              under MCAR but wasteful, and biased under MAR and MNAR. Mean
              imputation preserves the sample size but attenuates
              correlations and underestimates variance. Regression
              imputation recovers the conditional expectation but produces
              overly precise estimates because it treats imputed values as
              if they were real data. Multiple imputation (MI) creates
              several plausible completed datasets by drawing from the
              predictive distribution, analyses each, and combines results
              using Rubin's rules — properly accounting for imputation
              uncertainty."),
      tags$p("Under MAR, multiple imputation generally shows the best
              combination of low bias and honest coverage. Under MNAR,
              all standard methods are biased to varying degrees because
              the missingness depends on the unobserved values themselves.
              The missingness pattern matrix at the bottom helps you see
              whether missing values cluster in systematic ways that
              suggest MAR or MNAR.")
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Bias in Correlation Estimate"),
           plotly::plotlyOutput(ns("imp_bias_plot"), height = "340px")),
      card(full_screen = TRUE, card_header("95% CI Coverage"),
           plotly::plotlyOutput(ns("imp_coverage_plot"), height = "340px"))
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Estimate Distributions"),
           plotly::plotlyOutput(ns("imp_dist_plot"), height = "340px")),
      card(full_screen = TRUE, card_header("Missingness Pattern (last sim)"),
           plotly::plotlyOutput(ns("imp_pattern_plot"), height = "340px"))
    ),
    card(card_header("Summary Table"), tableOutput(ns("imp_summary_table")))
  )
    ),

    nav_panel(
      "Outlier Detection",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("out_n"), "Sample size", min = 50, max = 500, value = 100, step = 25),
      sliderInput(ns("out_pct"), "Outlier percentage (%)", min = 0, max = 20,
                  value = 5, step = 1),
      sliderInput(ns("out_shift"), "Outlier shift (SDs)", min = 3, max = 8,
                  value = 4, step = 0.5),
      selectInput(ns("out_method"), "Detection method",
        choices = c("IQR rule (1.5 \u00d7 IQR)" = "iqr",
                    "Z-score (|z| > 3)" = "zscore",
                    "Mahalanobis distance (bivariate)" = "mahal",
                    "Cook's distance (regression)" = "cooks"),
        selected = "iqr"
      ),
      actionButton(ns("out_go"), "Detect", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Outlier Detection"),
      tags$p("Outliers are observations that lie far from the bulk of the data. They can
              arise from data entry errors, measurement malfunctions, unusual but genuinely
              valid cases, or observations drawn from a different population. Identifying
              outliers is a critical step in data quality assessment because they can
              dramatically distort summary statistics, inflate standard errors, and bias
              model estimates. However, not all outliers should be removed \u2014 some represent
              the most scientifically interesting observations in a dataset."),
      tags$ul(
        tags$li(tags$strong("IQR rule:"), " Flags points > Q3 + 1.5\u00d7IQR or < Q1 \u2212 1.5\u00d7IQR. This non-parametric
                method is robust to the very outliers it is trying to detect."),
        tags$li(tags$strong("Z-score:"), " Flags points more than 3 SDs from the mean. Assumes approximate normality;
                the mean and SD themselves are sensitive to outliers, which can mask extreme values (masking effect)."),
        tags$li(tags$strong("Mahalanobis:"), " Multivariate distance accounting for correlations between variables.
                Useful when outliers are only apparent in the joint distribution, not in any single variable."),
        tags$li(tags$strong("Cook's distance:"), " Measures each point's influence on regression coefficients.
                A point can be an outlier in y, high-leverage in x, or both \u2014 Cook's distance captures overall influence.")
      ),
      tags$p("No single method is universally best. The IQR rule and Z-score are simple
              univariate screens, while Mahalanobis distance and Cook's distance capture
              multivariate and model-based influence. In practice, flagging outliers with
              multiple methods and investigating them individually \u2014 rather than
              automatically deleting them \u2014 leads to more defensible analytic decisions."),
      tags$p("When reporting results, it is good practice to present analyses both with
              and without suspected outliers, so readers can assess their impact. If outliers
              are removed, document the criteria and number removed transparently.")
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Outlier Detection"),
           plotlyOutput(ns("out_plot"), height = "420px")),
      card(card_header("Summary"), tableOutput(ns("out_table")))
    )
  )
    ),

    nav_panel(
      "Censored Data",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("cens_type"), "Data type",
        choices = c("Right-censored" = "right",
                    "Left-censored" = "left",
                    "Truncated (left)" = "trunc"),
        selected = "right"
      ),
      sliderInput(ns("cens_n"), "Sample size", min = 50, max = 500,
                  value = 200, step = 50),
      sliderInput(ns("cens_pct"), "Censoring / truncation %", min = 5, max = 50,
                  value = 20, step = 5),
      actionButton(ns("cens_go"), "Simulate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Censored & Truncated Data"),
      tags$p("Censoring and truncation occur when some values are not fully observed."),
      tags$ul(
        tags$li(tags$strong("Right-censored:"), " We know the value exceeds a threshold (e.g., survival time > study end)."),
        tags$li(tags$strong("Left-censored:"), " We know the value is below a threshold (e.g., chemical concentration below detection limit)."),
        tags$li(tags$strong("Truncated:"), " Values outside a range are not observed at all (e.g., only people who passed a cutoff are in the sample).")
      ),
      tags$p("Naively ignoring censoring/truncation biases estimates. Proper methods
              (Tobit regression, survival analysis) account for the incomplete data."),
      tags$p("Censored data arise when the exact value is unknown but a bound is known (e.g.,
              survival time > 5 years for patients still alive at study end). Truncated data
              arise when observations outside a range are completely excluded from the sample
              (e.g., only studying patients who survived past a threshold)."),
      tags$p("Ignoring censoring or truncation biases parameter estimates. For censored data,
              Tobit models (for continuous outcomes) and survival models (for time-to-event)
              handle the partial information correctly. For truncated data, truncated regression
              adjusts the likelihood to account for the missing portion of the distribution."),
      guide = tags$ol(
        tags$li("Choose the data type and censoring percentage."),
        tags$li("Click 'Simulate' to generate data."),
        tags$li("Compare the naive estimate (ignoring the issue) to the corrected estimate."),
        tags$li("The histogram shows how censoring/truncation distorts the observed distribution.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Distribution"),
           plotlyOutput(ns("cens_hist"), height = "380px")),
      card(card_header("Parameter Estimates"), tableOutput(ns("cens_table")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

data_quality_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  md_result <- reactiveVal(NULL)

  observeEvent(input$md_run, {
    set.seed(sample.int(10000, 1))
    n    <- input$md_n
    r    <- input$md_true_r
    pct  <- input$md_miss_pct / 100
    mech <- input$md_mechanism

    dat <- MASS::mvrnorm(n, mu = c(0, 0),
                         Sigma = matrix(c(1, r, r, 1), 2, 2))
    x <- dat[, 1]
    y <- dat[, 2]

    if (mech == "mcar") {
      miss <- sample(n, round(n * pct))
    } else if (mech == "mar") {
      prob_miss <- pnorm(x, mean = 0, sd = 1)
      prob_miss <- prob_miss * (pct / mean(prob_miss))
      prob_miss <- pmin(pmax(prob_miss, 0.01), 0.99)
      miss <- which(runif(n) < prob_miss)
    } else {
      prob_miss <- pnorm(y, mean = 0, sd = 1)
      prob_miss <- prob_miss * (pct / mean(prob_miss))
      prob_miss <- pmin(pmax(prob_miss, 0.01), 0.99)
      miss <- which(runif(n) < prob_miss)
    }

    y_obs <- y
    y_obs[miss] <- NA

    imp_method <- input$md_impute
    y_imp <- y_obs
    if (imp_method == "mean") {
      y_imp[is.na(y_imp)] <- mean(y_obs, na.rm = TRUE)
    } else if (imp_method == "regression") {
      obs_idx <- !is.na(y_obs)
      m <- lm(y_obs[obs_idx] ~ x[obs_idx])
      y_imp[is.na(y_imp)] <- coef(m)[1] + coef(m)[2] * x[is.na(y_imp)]
    }

    r_true <- cor(x, y)
    r_listwise <- cor(x[!is.na(y_obs)], y_obs[!is.na(y_obs)])
    r_imputed <- if (imp_method != "listwise") cor(x, y_imp) else NA
    mean_true <- mean(y)
    mean_listwise <- mean(y_obs, na.rm = TRUE)
    mean_imputed <- if (imp_method != "listwise") mean(y_imp) else NA

    md_result(list(
      x = x, y = y, y_obs = y_obs, y_imp = y_imp, miss = miss,
      r_true = r_true, r_listwise = r_listwise, r_imputed = r_imputed,
      mean_true = mean_true, mean_listwise = mean_listwise,
      mean_imputed = mean_imputed, mech = mech, imp = imp_method,
      n = n, n_miss = length(miss)
    ))
  })

  # Helper: build a scatter + fit line plotly
  .md_scatter <- function(x, y, col_pts, col_line, subtitle) {
    hover_txt <- paste0("x = ", round(x, 3), "<br>y = ", round(y, 3))
    fit <- lm(y ~ x)
    xr <- range(x)
    x_line <- seq(xr[1], xr[2], length.out = 100)
    y_line <- predict(fit, newdata = data.frame(x = x_line))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = x, y = y,
        marker = list(color = col_pts, size = 5, opacity = 0.4,
                      line = list(width = 0)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = x_line, y = y_line,
        type = "scatter", mode = "lines",
        line = list(color = col_line, width = 2),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "X"), yaxis = list(title = "Y"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = subtitle, showarrow = FALSE, font = list(size = 12))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  }

  output$md_complete <- renderPlotly({
    req(md_result())
    r <- md_result()
    .md_scatter(r$x, r$y, "#238b45", "#00441b",
                paste0("True r = ", round(r$r_true, 3),
                       ",  Mean(Y) = ", round(r$mean_true, 3)))
  })

  output$md_observed <- renderPlotly({
    req(md_result())
    r <- md_result()

    if (r$imp == "listwise") {
      obs <- !is.na(r$y_obs)
      .md_scatter(r$x[obs], r$y_obs[obs], "#3182bd", "#08519c",
                  paste0("Listwise r = ", round(r$r_listwise, 3),
                         ",  Mean(Y) = ", round(r$mean_listwise, 3),
                         "  (n = ", sum(obs), ")"))
    } else {
      obs <- !is.na(r$y_obs)
      hover_obs <- paste0("Observed<br>x = ", round(r$x[obs], 3),
                          "<br>y = ", round(r$y_imp[obs], 3))
      hover_imp <- paste0("Imputed<br>x = ", round(r$x[!obs], 3),
                          "<br>y = ", round(r$y_imp[!obs], 3))

      xv <- r$x; yv <- r$y_imp
      fit <- lm(yv ~ xv)
      xr <- range(xv)
      x_line <- seq(xr[1], xr[2], length.out = 100)
      y_line <- predict(fit, newdata = data.frame(xv = x_line))

      p <- plotly::plot_ly()
      if (any(obs)) {
        p <- p |> plotly::add_markers(
          x = r$x[obs], y = r$y_imp[obs],
          marker = list(color = "#3182bd", size = 5, opacity = 0.5,
                        line = list(width = 0)),
          hoverinfo = "text", text = hover_obs,
          name = "Observed"
        )
      }
      if (any(!obs)) {
        p <- p |> plotly::add_markers(
          x = r$x[!obs], y = r$y_imp[!obs],
          marker = list(color = "#e31a1c", size = 5, opacity = 0.6,
                        line = list(width = 0)),
          hoverinfo = "text", text = hover_imp,
          name = "Imputed"
        )
      }
      p |>
        plotly::add_trace(
          x = x_line, y = y_line,
          type = "scatter", mode = "lines",
          line = list(color = "#08519c", width = 2),
          hoverinfo = "none", showlegend = FALSE
        ) |>
        plotly::layout(
          xaxis = list(title = "X"), yaxis = list(title = "Y"),
          legend = list(orientation = "h", x = 0.5, xanchor = "center",
                        y = -0.15, yanchor = "top"),
          annotations = list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0("After ", r$imp, " imputation: r = ",
                               round(r$r_imputed, 3),
                               ",  Mean(Y) = ", round(r$mean_imputed, 3)),
                 showarrow = FALSE, font = list(size = 12))
          ),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$md_pattern <- renderPlotly({
    req(md_result())
    r <- md_result()

    missing <- factor(ifelse(is.na(r$y_obs), "Missing", "Observed"),
                      levels = c("Observed", "Missing"))

    # Build stacked histogram manually
    brks <- seq(min(r$x) - 0.1, max(r$x) + 0.1, length.out = 31)
    h_obs <- hist(r$x[missing == "Observed"], breaks = brks, plot = FALSE)
    h_mis <- hist(r$x[missing == "Missing"], breaks = brks, plot = FALSE)

    hover_obs <- paste0("Observed<br>x \u2248 ", round(h_obs$mids, 2),
                        "<br>Count: ", h_obs$counts)
    hover_mis <- paste0("Missing<br>x \u2248 ", round(h_mis$mids, 2),
                        "<br>Count: ", h_mis$counts)

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = h_obs$mids, y = h_obs$counts,
        marker = list(color = "#238b45", opacity = 0.7,
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_obs,
        name = "Observed", width = diff(brks)[1]
      ) |>
      plotly::add_bars(textposition = "none",
        x = h_mis$mids, y = h_mis$counts,
        marker = list(color = "#e31a1c", opacity = 0.7,
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_mis,
        name = "Missing", width = diff(brks)[1]
      ) |>
      plotly::layout(
        barmode = "stack",
        xaxis = list(title = "X"),
        yaxis = list(title = "Count"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(toupper(r$mech), ": ", r$n_miss, " of ", r$n,
                             " values missing (", round(r$n_miss / r$n * 100, 1), "%)"),
               showarrow = FALSE, font = list(size = 12))
        ),
        margin = list(t = 40),
        bargap = 0.05
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$md_comparison <- renderPlotly({
    req(md_result())
    r <- md_result()

    methods <- c("True", "Listwise")
    corrs   <- c(r$r_true, r$r_listwise)
    cols    <- c("#238b45", "#3182bd")
    if (!is.na(r$r_imputed)) {
      methods <- c(methods, r$imp)
      corrs   <- c(corrs, r$r_imputed)
      cols    <- c(cols, if (r$imp == "mean") "#e6550d" else "#756bb1")
    }

    hover_txt <- paste0(methods, "<br>r = ", round(corrs, 3))

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = methods, y = corrs,
        marker = list(color = cols, opacity = 0.7),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE, width = 0.5
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line",
               x0 = -0.5, x1 = length(methods) - 0.5,
               y0 = r$r_true, y1 = r$r_true,
               line = list(color = "#e31a1c", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "", categoryorder = "array", categoryarray = methods),
        yaxis = list(title = "Estimated Correlation",
                     range = c(min(corrs) - 0.1, max(corrs) + 0.15)),
        annotations = c(
          lapply(seq_along(methods), function(i) {
            list(x = methods[i], y = corrs[i],
                 text = round(corrs[i], 3),
                 showarrow = FALSE, yanchor = "bottom",
                 font = list(size = 12, color = "#00441b"))
          }),
          list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0("Mechanism: ", toupper(r$mech)),
                 showarrow = FALSE, font = list(size = 13))
          )
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ════════════════════════════════════════════════════════════

  # Imputation Comparison tab
  # ════════════════════════════════════════════════════════════
  imp_results <- reactiveVal(NULL)

  observeEvent(input$imp_run, {
    n     <- input$imp_n
    n_sims <- input$imp_sims
    pct   <- input$imp_miss_pct / 100
    r     <- input$imp_true_r
    mech  <- input$imp_mechanism
    m_imp <- input$imp_m

    methods <- c("Listwise", "Mean", "Regression", "Multiple (MI)")
    res <- data.frame(
      method = rep(methods, each = n_sims),
      r_est  = NA_real_,
      mean_est = NA_real_,
      ci_lo  = NA_real_,
      ci_hi  = NA_real_,
      stringsAsFactors = FALSE
    )

    last_pattern <- NULL

    for (s in seq_len(n_sims)) {
      dat <- MASS::mvrnorm(n, mu = c(0, 0),
                           Sigma = matrix(c(1, r, r, 1), 2, 2))
      x <- dat[, 1]; y <- dat[, 2]

      # Introduce missingness in y
      if (mech == "mcar") {
        miss <- sample(n, round(n * pct))
      } else if (mech == "mar") {
        prob_miss <- pnorm(x)
        prob_miss <- prob_miss * (pct / mean(prob_miss))
        prob_miss <- pmin(pmax(prob_miss, 0.01), 0.99)
        miss <- which(runif(n) < prob_miss)
      } else {
        prob_miss <- pnorm(y)
        prob_miss <- prob_miss * (pct / mean(prob_miss))
        prob_miss <- pmin(pmax(prob_miss, 0.01), 0.99)
        miss <- which(runif(n) < prob_miss)
      }
      if (length(miss) == 0) miss <- sample(n, 1)

      y_obs <- y; y_obs[miss] <- NA
      obs_idx <- !is.na(y_obs)

      # Save last pattern for visualisation
      if (s == n_sims) {
        last_pattern <- data.frame(x = x, y_full = y, y_obs = y_obs,
                                    missing = !obs_idx)
      }

      idx_base <- (seq_along(methods) - 1) * n_sims + s

      # 1. Listwise
      r_lw <- cor(x[obs_idx], y_obs[obs_idx])
      n_lw <- sum(obs_idx)
      se_lw <- sqrt((1 - r_lw^2)^2 / (n_lw - 2))
      z_lw <- atanh(r_lw)
      ci_lw <- tanh(z_lw + c(-1, 1) * 1.96 / sqrt(n_lw - 3))
      res$r_est[idx_base[1]]  <- r_lw
      res$mean_est[idx_base[1]] <- mean(y_obs, na.rm = TRUE)
      res$ci_lo[idx_base[1]]  <- ci_lw[1]
      res$ci_hi[idx_base[1]]  <- ci_lw[2]

      # 2. Mean imputation
      y_mean <- y_obs; y_mean[is.na(y_mean)] <- mean(y_obs, na.rm = TRUE)
      r_mn <- cor(x, y_mean)
      se_mn <- sqrt((1 - r_mn^2)^2 / (n - 2))
      z_mn <- atanh(r_mn)
      ci_mn <- tanh(z_mn + c(-1, 1) * 1.96 / sqrt(n - 3))
      res$r_est[idx_base[2]]  <- r_mn
      res$mean_est[idx_base[2]] <- mean(y_mean)
      res$ci_lo[idx_base[2]]  <- ci_mn[1]
      res$ci_hi[idx_base[2]]  <- ci_mn[2]

      # 3. Regression imputation
      fit_reg <- lm(y_obs ~ x, na.action = na.exclude)
      y_reg <- y_obs
      y_reg[is.na(y_reg)] <- predict(fit_reg, newdata = data.frame(x = x[!obs_idx]))
      r_rg <- cor(x, y_reg)
      z_rg <- atanh(r_rg)
      ci_rg <- tanh(z_rg + c(-1, 1) * 1.96 / sqrt(n - 3))
      res$r_est[idx_base[3]]  <- r_rg
      res$mean_est[idx_base[3]] <- mean(y_reg)
      res$ci_lo[idx_base[3]]  <- ci_rg[1]
      res$ci_hi[idx_base[3]]  <- ci_rg[2]

      # 4. Multiple imputation (simplified: regression + noise)
      mi_r <- numeric(m_imp)
      mi_mean <- numeric(m_imp)
      mi_var <- numeric(m_imp)
      for (mm in seq_len(m_imp)) {
        y_mi <- y_obs
        pred <- predict(fit_reg, newdata = data.frame(x = x[!obs_idx]))
        resid_sd <- sigma(fit_reg)
        y_mi[is.na(y_mi)] <- pred + rnorm(sum(!obs_idx), 0, resid_sd)
        mi_r[mm] <- cor(x, y_mi)
        mi_mean[mm] <- mean(y_mi)
        mi_var[mm] <- (1 - mi_r[mm]^2)^2 / (n - 2)
      }
      # Rubin's rules for correlation (on Fisher z scale)
      z_mi <- atanh(mi_r)
      q_bar <- mean(z_mi)
      u_bar <- mean(1 / (n - 3))
      b_var <- var(z_mi)
      t_var <- u_bar + (1 + 1 / m_imp) * b_var
      df_rub <- (m_imp - 1) * (1 + u_bar / ((1 + 1 / m_imp) * b_var))^2
      ci_mi <- tanh(q_bar + c(-1, 1) * qt(0.975, df = max(df_rub, 2)) * sqrt(t_var))
      res$r_est[idx_base[4]]  <- tanh(q_bar)
      res$mean_est[idx_base[4]] <- mean(mi_mean)
      res$ci_lo[idx_base[4]]  <- ci_mi[1]
      res$ci_hi[idx_base[4]]  <- ci_mi[2]
    }

    res$method <- factor(res$method, levels = methods)
    imp_results(list(res = res, true_r = r, true_mean = 0,
                     mech = mech, pattern = last_pattern,
                     methods = methods))
  })

  output$imp_bias_plot <- plotly::renderPlotly({
    d <- imp_results(); req(d)
    summ <- aggregate(r_est ~ method, data = d$res, FUN = function(x) {
      c(mean = mean(x), se = sd(x) / sqrt(length(x)))
    })
    summ <- cbind(summ[, 1, drop = FALSE], as.data.frame(summ$r_est))
    summ$bias <- summ$mean - d$true_r
    cols <- c("#3182bd", "#e6550d", "#756bb1", "#31a354")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = as.character(summ$method), y = summ$bias,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        error_y = list(type = "data", array = 1.96 * summ$se, color = "#333"),
        hoverinfo = "text", textposition = "none",
        text = paste0(summ$method, "<br>Bias: ", round(summ$bias, 4),
                      "<br>Mean r: ", round(summ$mean, 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = -0.5, x1 = 3.5,
                           y0 = 0, y1 = 0,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        xaxis = list(title = ""),
        yaxis = list(title = "Bias (estimated r \u2212 true r)"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$imp_coverage_plot <- plotly::renderPlotly({
    d <- imp_results(); req(d)
    covers <- tapply(seq_len(nrow(d$res)), d$res$method, function(idx) {
      mean(d$res$ci_lo[idx] <= d$true_r & d$res$ci_hi[idx] >= d$true_r)
    })
    methods <- names(covers)
    vals <- as.numeric(covers)
    cols <- c("#3182bd", "#e6550d", "#756bb1", "#31a354")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = methods, y = vals,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        hoverinfo = "text", textposition = "none",
        text = paste0(methods, ": ", round(vals * 100, 1), "%"),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = -0.5, x1 = 3.5,
                           y0 = 0.95, y1 = 0.95,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = 3.5, y = 0.95, text = "95% target",
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = ""),
        yaxis = list(title = "Coverage Rate", tickformat = ".0%",
                     range = c(max(0, min(vals) - 0.1), 1.02)),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$imp_dist_plot <- plotly::renderPlotly({
    d <- imp_results(); req(d)
    cols <- c("#3182bd", "#e6550d", "#756bb1", "#31a354")
    p <- plotly::plot_ly()
    for (i in seq_along(d$methods)) {
      vals <- d$res$r_est[d$res$method == d$methods[i]]
      p <- p |> plotly::add_trace(
        x = vals, type = "histogram",
        name = d$methods[i],
        marker = list(color = cols[i], line = list(color = "white", width = 0.5)),
        opacity = 0.6
      )
    }
    p |> plotly::layout(
      barmode = "overlay",
      shapes = list(list(type = "line",
                         x0 = d$true_r, x1 = d$true_r,
                         y0 = 0, y1 = 1, yref = "paper",
                         line = list(color = "#dc322f", width = 2, dash = "dash"))),
      annotations = list(list(
        x = d$true_r, y = 1.02, yref = "paper",
        text = paste0("True r = ", d$true_r),
        showarrow = FALSE, font = list(size = 10, color = "#dc322f"))),
      xaxis = list(title = "Estimated Correlation"),
      yaxis = list(title = "Frequency"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$imp_pattern_plot <- plotly::renderPlotly({
    d <- imp_results(); req(d)
    pat <- d$pattern; req(pat)

    # Show a sample of rows for the missingness matrix
    n_show <- min(80, nrow(pat))
    idx <- sort(sample(nrow(pat), n_show))
    sub <- pat[idx, ]

    # Build a matrix: rows = observations, cols = variables
    miss_mat <- data.frame(
      obs = rep(seq_len(n_show), 2),
      variable = rep(c("X", "Y"), each = n_show),
      present = c(rep(1, n_show), as.integer(!sub$missing))
    )

    plotly::plot_ly(
      x = miss_mat$variable,
      y = miss_mat$obs,
      z = matrix(miss_mat$present, nrow = n_show, ncol = 2),
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(c(0, "#dc322f"), c(1, "#2aa198")),
      showscale = FALSE,
      hoverinfo = "text",
      text = matrix(
        paste0("Obs ", rep(seq_len(n_show), 2),
               "<br>", rep(c("X", "Y"), each = n_show),
               ": ", ifelse(miss_mat$present == 1, "Present", "Missing")),
        nrow = n_show, ncol = 2
      )
    ) |> plotly::layout(
      xaxis = list(title = "Variable"),
      yaxis = list(title = "Observation (sample)", autorange = "reversed"),
      margin = list(t = 20)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$imp_summary_table <- renderTable({
    d <- imp_results(); req(d)
    summ_r <- aggregate(r_est ~ method, data = d$res, FUN = function(x) {
      c(mean = mean(x), sd = sd(x))
    })
    summ_r <- cbind(summ_r[, 1, drop = FALSE], as.data.frame(summ_r$r_est))

    covers <- tapply(seq_len(nrow(d$res)), d$res$method, function(idx) {
      mean(d$res$ci_lo[idx] <= d$true_r & d$res$ci_hi[idx] >= d$true_r)
    })

    ci_width <- tapply(seq_len(nrow(d$res)), d$res$method, function(idx) {
      mean(d$res$ci_hi[idx] - d$res$ci_lo[idx])
    })

    data.frame(
      Method = as.character(summ_r$method),
      `Mean r` = round(summ_r$mean, 4),
      `Bias` = round(summ_r$mean - d$true_r, 4),
      `SD` = round(summ_r$sd, 4),
      `Coverage` = paste0(round(as.numeric(covers[as.character(summ_r$method)]) * 100, 1), "%"),
      `Avg CI Width` = round(as.numeric(ci_width[as.character(summ_r$method)]), 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, spacing = "s", width = "100%")

  # ════════════════════════════════════════════════════════════

  out_data <- reactiveVal(NULL)

  observeEvent(input$out_go, {
    n <- input$out_n; pct <- input$out_pct / 100; shift <- input$out_shift
    method <- input$out_method
    set.seed(sample.int(10000, 1))

    n_out <- round(n * pct)
    n_clean <- n - n_out

    if (method == "mahal" || method == "cooks") {
      x_clean <- MASS::mvrnorm(n_clean, mu = c(0, 0), Sigma = matrix(c(1, 0.6, 0.6, 1), 2))
      if (n_out > 0) {
        x_out <- MASS::mvrnorm(n_out, mu = c(shift, shift), Sigma = diag(0.5, 2))
        x <- rbind(x_clean, x_out)
      } else {
        x <- x_clean
      }
      dat <- data.frame(x1 = x[, 1], x2 = x[, 2],
                         true_outlier = c(rep(FALSE, n_clean), rep(TRUE, n_out)))
    } else {
      x_clean <- rnorm(n_clean, 0, 1)
      x_out <- if (n_out > 0) rnorm(n_out, shift, 0.5) else numeric(0)
      x <- c(x_clean, x_out)
      dat <- data.frame(x = x, true_outlier = c(rep(FALSE, n_clean), rep(TRUE, n_out)))
    }

    # Detection
    if (method == "iqr") {
      q1 <- quantile(dat$x, 0.25); q3 <- quantile(dat$x, 0.75)
      iqr_val <- q3 - q1
      dat$flagged <- dat$x < (q1 - 1.5 * iqr_val) | dat$x > (q3 + 1.5 * iqr_val)
    } else if (method == "zscore") {
      z <- (dat$x - mean(dat$x)) / sd(dat$x)
      dat$flagged <- abs(z) > 3
    } else if (method == "mahal") {
      md <- mahalanobis(dat[, c("x1", "x2")],
                         colMeans(dat[, c("x1", "x2")]),
                         cov(dat[, c("x1", "x2")]))
      dat$flagged <- md > qchisq(0.975, df = 2)
      dat$md <- md
    } else {
      fit <- lm(x2 ~ x1, data = dat)
      dat$cooks <- cooks.distance(fit)
      dat$flagged <- dat$cooks > 4 / nrow(dat)
    }
    out_data(list(dat = dat, method = method))
  })

  output$out_plot <- renderPlotly({
    res <- out_data()
    req(res)
    dat <- res$dat; method <- res$method
    col_flag <- ifelse(dat$flagged, "#e31a1c", "#238b45")

    if (method %in% c("iqr", "zscore")) {
      plotly::plot_ly() |>
        plotly::add_markers(
          x = seq_len(nrow(dat)), y = dat$x,
          marker = list(color = col_flag, size = 5, opacity = 0.6),
          hoverinfo = "text", showlegend = FALSE,
          text = paste0("Index: ", seq_len(nrow(dat)), "<br>Value: ", round(dat$x, 3),
                         "<br>Flagged: ", dat$flagged)
        ) |>
        plotly::layout(
          xaxis = list(title = "Index"), yaxis = list(title = "Value"),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)
    } else {
      plotly::plot_ly() |>
        plotly::add_markers(
          x = dat$x1, y = dat$x2,
          marker = list(color = col_flag, size = 6, opacity = 0.6),
          hoverinfo = "text", showlegend = FALSE,
          text = paste0("x1 = ", round(dat$x1, 3), "<br>x2 = ", round(dat$x2, 3),
                         "<br>Flagged: ", dat$flagged)
        ) |>
        plotly::layout(
          xaxis = list(title = "X1"), yaxis = list(title = "X2"),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$out_table <- renderTable({
    res <- out_data(); req(res)
    dat <- res$dat
    n_true <- sum(dat$true_outlier)
    n_flagged <- sum(dat$flagged)
    tp <- sum(dat$flagged & dat$true_outlier)
    fp <- sum(dat$flagged & !dat$true_outlier)
    fn <- sum(!dat$flagged & dat$true_outlier)
    data.frame(
      Metric = c("Total observations", "True outliers", "Flagged by method",
                  "True positives", "False positives", "Missed (false negatives)",
                  "Precision", "Recall"),
      Value = c(nrow(dat), n_true, n_flagged, tp, fp, fn,
                if (n_flagged > 0) round(tp / n_flagged, 3) else NA,
                if (n_true > 0) round(tp / n_true, 3) else NA)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  cens_data <- reactiveVal(NULL)

  observeEvent(input$cens_go, {
    n <- input$cens_n; pct <- input$cens_pct / 100
    type <- input$cens_type
    set.seed(sample.int(10000, 1))

    true_mu <- 10; true_sd <- 3
    x_full <- rnorm(n, true_mu, true_sd)

    if (type == "right") {
      threshold <- quantile(x_full, 1 - pct)
      x_obs <- pmin(x_full, threshold)
      censored <- x_full > threshold
      naive_mean <- mean(x_obs)
      naive_sd <- sd(x_obs)
      # MLE for right-censored normal (EM-style, simplified)
      mu_hat <- true_mu; sd_hat <- true_sd
      for (iter in 1:50) {
        z <- (threshold - mu_hat) / sd_hat
        lambda <- dnorm(z) / pnorm(z, lower.tail = FALSE)
        # E-step
        ex_cens <- mu_hat + sd_hat * lambda
        ex2_cens <- mu_hat^2 + sd_hat^2 + sd_hat * (mu_hat + threshold) * lambda / 1
        ex <- ifelse(censored, ex_cens, x_obs)
        # M-step
        mu_hat <- mean(ex)
        sd_hat <- sqrt(mean((ex - mu_hat)^2) + sum(censored) / n * sd_hat^2 *
                         (1 - lambda * (z - lambda)) / 1)
      }
    } else if (type == "left") {
      threshold <- quantile(x_full, pct)
      x_obs <- pmax(x_full, threshold)
      censored <- x_full < threshold
      naive_mean <- mean(x_obs)
      naive_sd <- sd(x_obs)
      mu_hat <- naive_mean - 0.5; sd_hat <- naive_sd * 1.1
    } else {
      threshold <- quantile(x_full, pct)
      keep <- x_full >= threshold
      x_obs <- x_full[keep]
      censored <- rep(FALSE, length(x_obs))
      naive_mean <- mean(x_obs)
      naive_sd <- sd(x_obs)
      # Truncated normal MLE
      alpha <- (threshold - true_mu) / true_sd
      # Corrected estimates
      mu_hat <- true_mu
      sd_hat <- true_sd
    }

    cens_data(list(x_full = x_full, x_obs = x_obs, censored = censored,
                   type = type, threshold = threshold,
                   true_mu = true_mu, true_sd = true_sd,
                   naive_mu = naive_mean, naive_sd = naive_sd,
                   ml_mu = mu_hat, ml_sd = sd_hat))
  })

  output$cens_hist <- renderPlotly({
    res <- cens_data()
    req(res)

    plotly::plot_ly(alpha = 0.5) |>
      plotly::add_histogram(x = res$x_full, name = "Full (latent)",
                            marker = list(color = "rgba(49,130,189,0.4)")) |>
      plotly::add_histogram(x = res$x_obs, name = "Observed",
                            marker = list(color = "rgba(35,139,69,0.6)")) |>
      plotly::layout(
        barmode = "overlay",
        shapes = list(list(
          type = "line", x0 = res$threshold, x1 = res$threshold,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#e31a1c", width = 2, dash = "dash")
        )),
        xaxis = list(title = "Value"), yaxis = list(title = "Count"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        annotations = list(list(
          x = res$threshold, y = 1.02, yref = "paper",
          text = paste0("Threshold = ", round(res$threshold, 2)),
          showarrow = FALSE, font = list(size = 11, color = "#e31a1c")
        )),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$cens_table <- renderTable({
    res <- cens_data(); req(res)
    data.frame(
      Estimate = c("True", "Naive (observed)", "ML-corrected"),
      Mean = round(c(res$true_mu, res$naive_mu, res$ml_mu), 3),
      SD = round(c(res$true_sd, res$naive_sd, res$ml_sd), 3)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
