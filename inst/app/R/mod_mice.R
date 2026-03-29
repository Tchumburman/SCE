# Module: Multiple Imputation (MICE)
# 4 tabs: Missing Mechanisms · MICE Process · Pooling (Rubin's Rules) · Diagnostics

# ── UI ────────────────────────────────────────────────────────────────────────
mice_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Multiple Imputation",
  icon = icon("fill-drip"),
  navset_card_underline(

    # ── Tab 1: Missing Mechanisms ─────────────────────────────────────────────
    nav_panel(
      "Missing Mechanisms",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mi_n"), "Sample size n", 100, 500, 300, 50),
          sliderInput(ns("mi_pct_miss"), "Missingness rate (%)", 5, 60, 30, 5),
          selectInput(ns("mi_mech"), "Missing mechanism",
            choices = c("MCAR (completely at random)",
                        "MAR (at random — depends on X)",
                        "MNAR (not at random — depends on Y)"),
            selected = "MAR (at random — depends on X)"),
          sliderInput(ns("mi_b"), "True effect \u03b2 (X \u2192 Y)", -2, 2, 1, 0.1),
          actionButton(ns("mi_mech_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Missing Data Mechanisms"),
          tags$p("The mechanism that causes missingness determines which methods produce
                  unbiased results:"),
          tags$ul(
            tags$li(tags$strong("MCAR"), " (Missing Completely At Random) — the probability of
                    missingness is independent of any data, observed or unobserved.
                    Complete-case analysis is unbiased, just inefficient."),
            tags$li(tags$strong("MAR"), " (Missing At Random) — missingness depends only on
                    observed variables (e.g., older subjects more likely to drop out, but
                    conditional on age, dropout is random). Multiple imputation is valid under MAR."),
            tags$li(tags$strong("MNAR"), " (Missing Not At Random) — missingness depends on the
                    unobserved value itself (e.g., sick patients more likely to miss appointments).
                    No standard method handles MNAR without additional assumptions.")
          ),
          tags$p("MI produces unbiased estimates under MCAR and MAR. Under MNAR, bias remains
                  unless the missing-data model is correctly specified."),
          guide = tags$ol(
            tags$li("Simulate data. The scatter plot shows complete (blue) vs. missing (red) cases."),
            tags$li("Compare the observed mean of Y to the true population mean."),
            tags$li("Switch mechanisms to see how the distribution of missing values changes."),
            tags$li("MNAR: the missing cases are systematically different — bias persists even with MI.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Observed vs. Missing Data"),
               plotlyOutput(ns("mi_scatter"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Distribution: Complete vs. Observed"),
                 plotlyOutput(ns("mi_dist"), height = "250px")),
            card(card_header("Bias Summary"),
                 tableOutput(ns("mi_bias_table")))
          )
        )
      )
    ),

    # ── Tab 2: MICE Process ───────────────────────────────────────────────────
    nav_panel(
      "MICE Process",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mice_n"), "Sample size n", 100, 400, 200, 50),
          sliderInput(ns("mice_pct"), "Missingness (%)", 10, 50, 25, 5),
          sliderInput(ns("mice_m"), "Number of imputations m", 2, 20, 5, 1),
          sliderInput(ns("mice_iter"), "MICE iterations", 1, 20, 5, 1),
          actionButton(ns("mice_go"), "Run MICE", icon = icon("play"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
            "MICE = Multivariate Imputation by Chained Equations. Each variable
             is imputed in turn using all other variables as predictors.")
        ),
        explanation_box(
          tags$strong("MICE — Multivariate Imputation by Chained Equations"),
          tags$p("MICE (also called Fully Conditional Specification) imputes each variable
                  with missing values using a separate regression model, cycling through
                  all incomplete variables iteratively:"),
          tags$ol(
            tags$li("Initialise: fill missing values with simple draws (e.g., from observed distribution)."),
            tags$li("For each incomplete variable X\u2c7c, fit a model using all other variables as predictors."),
            tags$li("Draw new imputed values from the predictive distribution."),
            tags$li("Repeat for all variables (= 1 iteration). Cycle for multiple iterations until convergence."),
            tags$li("Repeat the whole process m times to get m completed datasets.")
          ),
          tags$p("After imputation, each complete dataset is analysed separately, and results are
                  pooled using Rubin's Rules (see next tab)."),
          tags$p("Convergence check: the mean and variance of imputed values should stabilise
                  across iterations — no trending pattern."),
          guide = tags$ol(
            tags$li("Click 'Run MICE'. The convergence plot shows iteration-by-iteration stability."),
            tags$li("The overlay plot shows all m imputed datasets and the original."),
            tags$li("More iterations (> 10) generally ensure convergence. m \u2265 5 is typical.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("MICE Convergence: Imputed Mean per Iteration"),
               plotlyOutput(ns("mice_conv"), height = "300px")),
          card(full_screen = TRUE,
               card_header("Imputed Datasets Overlay"),
               plotlyOutput(ns("mice_overlay"), height = "280px"))
        )
      )
    ),

    # ── Tab 3: Pooling (Rubin's Rules) ────────────────────────────────────────
    nav_panel(
      "Rubin's Rules",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("rub_n"), "Sample size n", 100, 400, 200, 50),
          sliderInput(ns("rub_pct"), "Missingness (%)", 10, 60, 30, 5),
          sliderInput(ns("rub_m"), "Imputations m", 2, 20, 10, 1),
          sliderInput(ns("rub_b"), "True effect \u03b2", -2, 2, 1, 0.1),
          selectInput(ns("rub_mech"), "Mechanism",
            choices = c("MCAR", "MAR"),
            selected = "MAR"),
          actionButton(ns("rub_go"), "Simulate & Pool", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Rubin's Rules for Pooling Results"),
          tags$p("After fitting the analysis model to each of m imputed datasets, Rubin's (1987)
                  rules combine results:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "\u03b2\u0305 = (1/m) \u03a3 \u03b2\u1d65\n\nT = W\u0305 + (1 + 1/m)B"),
          tags$p("where ", tags$strong("W\u0305"), " = average within-imputation variance,
                  ", tags$strong("B"), " = between-imputation variance."),
          tags$p("The fraction of information missing due to missingness (FMI):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "FMI \u2248 (B + B/m) / T"),
          tags$p("Large FMI means the imputation model is adding substantial uncertainty.
                  Increasing m reduces the simulation error but not the FMI itself."),
          guide = tags$ol(
            tags$li("Click 'Simulate & Pool'. Estimates from each imputed dataset are shown."),
            tags$li("The pooled estimate (Rubin's Rules) is shown with its CI."),
            tags$li("Compare to complete-case and oracle (full-data) estimates."),
            tags$li("Increase m to see how more imputations reduce simulation variability.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Estimates per Imputed Dataset + Pooled"),
               plotlyOutput(ns("rub_forest"), height = "360px")),
          card(card_header("Pooling Summary"),
               tableOutput(ns("rub_table")))
        )
      )
    ),

    # ── Tab 4: Imputation Quality ─────────────────────────────────────────────
    nav_panel(
      "Imputation Quality",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("iq_n"), "Sample size n", 100, 400, 200, 50),
          sliderInput(ns("iq_pct"), "Missingness (%)", 10, 60, 30, 5),
          sliderInput(ns("iq_rho"), "Predictor correlation with Y",
                      0, 0.95, 0.6, 0.05),
          sliderInput(ns("iq_m"), "Imputations m", 2, 15, 5, 1),
          actionButton(ns("iq_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("What Makes a Good Imputation?"),
          tags$p("Imputation quality depends critically on the imputation model. Key principles:"),
          tags$ul(
            tags$li(tags$strong("Include auxiliary variables"), " — variables correlated with the
                    incomplete variable improve precision. Even a variable only related to the
                    missingness indicator helps."),
            tags$li(tags$strong("Predictive mean matching (PMM)"), " — imputes from actual observed
                    values closest to the predicted mean. Preserves the distribution better than
                    parametric imputation."),
            tags$li(tags$strong("More predictors = less FMI"), " — the imputation model's R\u00b2
                    directly reduces the fraction of information missing."),
            tags$li(tags$strong("Over-imputation"), " — imputing a variable and then using it to
                    predict itself causes circularity; exclude the outcome from predicting itself.")
          ),
          tags$p("The strip plot of imputed vs. observed values is a quick visual check:
                  imputed distributions should roughly match the observed distribution
                  (under MAR)."),
          tags$p("MICE convergence should be assessed using trace plots of the imputed
                  means and standard deviations across iterations for each incomplete
                  variable. Well-converged chains mix freely \u2014 the trace should
                  look like white noise without trends, drifts, or periodic patterns.
                  Typically 5\u201310 iterations are sufficient for convergence, but
                  problematic variables (e.g., those with many predictors or
                  multicollinearity) may need more. Rubin's rules pool only across
                  completed datasets, not across iterations; the final iteration of
                  each chain provides one imputed dataset."),
          tags$p("How many imputations (m) are needed? The traditional recommendation
                  of m = 5 was derived for moderate missingness (\u2248 20\u201330%).
                  A better guideline is to set m to at least the percentage of
                  incomplete cases: with 40% missing, use m \u2265 40. More imputations
                  reduce simulation noise in the pooled estimate and are especially
                  important when computing power or confidence interval coverage,
                  since variability in Rubin\u2019s pooled variance can inflate
                  standard errors with small m. Modern hardware makes m = 50\u2013100
                  computationally trivial for most datasets."),
          guide = tags$ol(
            tags$li("Move the 'Predictor correlation' slider. Higher \u03c1 = better auxiliary variable."),
            tags$li("The FMI decreases as the imputation predictor becomes more informative."),
            tags$li("The density comparison shows observed (solid) vs. imputed (dashed) distributions.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Observed vs. Imputed Distribution"),
                 plotlyOutput(ns("iq_density"), height = "280px")),
            card(card_header("FMI vs. Predictor Correlation"),
                 plotlyOutput(ns("iq_fmi_curve"), height = "280px"))
          ),
          card(card_header("Quality Summary"), tableOutput(ns("iq_table")))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

mice_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: generate missing data ────────────────────────────────────────
  gen_miss_data <- function(n, pct, mech, b = 1, seed = NULL) {
    if (!is.null(seed)) set.seed(seed)
    x  <- rnorm(n)
    y  <- b * x + rnorm(n)
    pi_miss <- switch(mech,
      "MCAR (completely at random)"          = rep(pct / 100, n),
      "MAR (at random — depends on X)"       = plogis(-1 + 2 * (x > 0)) * pct / 50,
      "MNAR (not at random — depends on Y)"  = plogis(-1 + 2 * (y > 0)) * pct / 50
    )
    pi_miss <- pmin(pi_miss, 0.95)
    miss_y  <- rbinom(n, 1, pi_miss) == 1
    list(x = x, y = y, miss_y = miss_y, mech = mech)
  }

  # ── Utility: simple MICE (2 variables x, y with y partially missing) ────
  mice_impute <- function(x, y_obs, miss_idx, m = 5, n_iter = 5) {
    n  <- length(x)
    y_full <- y_obs  # start with observed only

    imp_list <- vector("list", m)
    for (imp in seq_len(m)) {
      # Initialise with mean imputation
      y_imp <- y_obs
      y_imp[miss_idx] <- mean(y_obs[!miss_idx]) + rnorm(sum(miss_idx), 0, sd(y_obs[!miss_idx]))

      # Iterate
      iter_means <- numeric(n_iter)
      for (iter in seq_len(n_iter)) {
        # Regress y_imp ~ x using observed values + current imputed
        fit   <- lm(y_imp ~ x)
        sigma <- summary(fit)$sigma
        # Draw new imputed values
        y_pred_miss <- predict(fit, newdata = data.frame(x = x[miss_idx]))
        y_imp[miss_idx] <- y_pred_miss + rnorm(sum(miss_idx), 0, sigma)
        iter_means[iter] <- mean(y_imp[miss_idx])
      }
      imp_list[[imp]] <- list(y = y_imp, iter_means = iter_means)
    }
    imp_list
  }

  # ── Tab 1 ──────────────────────────────────────────────────────────────────
  miss_data <- reactiveVal(NULL)
  observeEvent(input$mi_mech_go, {
    withProgress(message = "Simulating missing data...", value = 0.1, {
    miss_data({
    set.seed(sample(9999, 1))
    gen_miss_data(input$mi_n, input$mi_pct_miss, input$mi_mech, input$mi_b)
    })
    })
  })

  output$mi_scatter <- renderPlotly({
    req(miss_data())
    d <- miss_data()
    plot_ly() |>
      add_markers(x = d$x[!d$miss_y], y = d$y[!d$miss_y],
                  name = "Observed", marker = list(color = "#268bd2", size = 5, opacity = 0.6)) |>
      add_markers(x = d$x[d$miss_y], y = d$y[d$miss_y],
                  name = "Missing (Y hidden)", marker = list(color = "#dc322f", size = 5,
                                                              opacity = 0.6, symbol = "x")) |>
      layout(xaxis = list(title = "X (fully observed)"),
             yaxis = list(title = "Y (partially missing)"),
             legend = list(orientation = "h"))
  })

  output$mi_dist <- renderPlotly({
    req(miss_data())
    d  <- miss_data()
    y_obs  <- d$y[!d$miss_y]
    y_full <- d$y
    plot_ly() |>
      add_histogram(x = y_full, name = "Full data",
                    histnorm = "probability density", nbinsx = 25,
                    marker = list(color = "rgba(133,153,0,0.4)")) |>
      add_histogram(x = y_obs, name = "Observed only",
                    histnorm = "probability density", nbinsx = 25,
                    marker = list(color = "rgba(38,139,210,0.6)")) |>
      layout(barmode = "overlay",
             xaxis = list(title = "Y"), yaxis = list(title = "Density"))
  })

  output$mi_bias_table <- renderTable({
    req(miss_data())
    d  <- miss_data()
    y_obs  <- d$y[!d$miss_y]
    data.frame(
      Sample      = c("Full data (oracle)", "Complete cases (observed Y only)"),
      Mean_Y      = round(c(mean(d$y), mean(y_obs)), 4),
      N           = c(length(d$y), sum(!d$miss_y)),
      Pct_Missing = c(0, round(mean(d$miss_y) * 100, 1))
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 2: MICE Process ────────────────────────────────────────────────────
  mice_res <- reactiveVal(NULL)
  observeEvent(input$mice_go, {
    withProgress(message = "Running multiple imputation...", value = 0.1, {
    mice_res({
    set.seed(sample(9999, 1))
    n    <- input$mice_n; pct <- input$mice_pct
    m    <- input$mice_m; ni  <- input$mice_iter
    d    <- gen_miss_data(n, pct, "MAR (at random — depends on X)")
    imps <- mice_impute(d$x, ifelse(d$miss_y, NA_real_, d$y), d$miss_y, m = m, n_iter = ni)
    list(d = d, imps = imps, m = m, ni = ni)
    })
    })
  })

  output$mice_conv <- renderPlotly({
    req(mice_res())
    res  <- mice_res()
    p    <- plot_ly()
    cols <- colorRampPalette(c("#268bd2","#2aa198","#b58900","#dc322f","#d33682"))(res$m)
    for (i in seq_len(res$m)) {
      p <- p |> add_lines(x = seq_len(res$ni),
                           y = res$imps[[i]]$iter_means,
                           name = paste0("Imp ", i),
                           line = list(color = cols[i], width = 1.5))
    }
    p |> layout(xaxis = list(title = "Iteration", dtick = 1),
                yaxis = list(title = "Mean of imputed Y"),
                title = list(text = "Convergence: lines should stabilise quickly",
                             font = list(size = 12)))
  })

  output$mice_overlay <- renderPlotly({
    req(mice_res())
    res  <- mice_res()
    d    <- res$d
    cols <- colorRampPalette(c("#268bd2", "#cb4b16", "#2aa198"))(res$m)
    p <- plot_ly() |>
      add_histogram(x = d$y[!d$miss_y], name = "Observed",
                    histnorm = "probability density", nbinsx = 20,
                    marker = list(color = "rgba(101,123,131,0.5)"))
    for (i in seq_len(res$m)) {
      y_imp <- res$imps[[i]]$y
      p <- p |> add_lines(
        x = density(y_imp)$x, y = density(y_imp)$y,
        name = paste0("Imp ", i),
        line = list(color = cols[i], width = 1.5))
    }
    p |> layout(barmode = "overlay",
                xaxis = list(title = "Y"), yaxis = list(title = "Density"))
  })

  # ── Tab 3: Rubin's Rules ───────────────────────────────────────────────────
  rub_res <- reactiveVal(NULL)
  observeEvent(input$rub_go, {
    withProgress(message = "Applying Rubin's rules...", value = 0.1, {
    rub_res({
    set.seed(sample(9999, 1))
    n   <- input$rub_n; pct <- input$rub_pct
    m   <- input$rub_m; b   <- input$rub_b
    mch <- paste0(input$rub_mech, if (input$rub_mech == "MCAR")
                  " (completely at random)" else " (at random — depends on X)")
    d    <- gen_miss_data(n, pct, mch, b)
    imps <- mice_impute(d$x, ifelse(d$miss_y, NA_real_, d$y), d$miss_y, m = m, n_iter = 10)

    # Analyse each imputed dataset
    ests <- sapply(imps, function(imp) coef(lm(imp$y ~ d$x))["d$x"])
    ses  <- sapply(imps, function(imp) summary(lm(imp$y ~ d$x))$coefficients["d$x", "Std. Error"])

    # Pool (Rubin's Rules)
    q_bar <- mean(ests)
    W_bar <- mean(ses^2)
    B     <- var(ests)
    T_var <- W_bar + (1 + 1 / m) * B
    fmi   <- (B + B / m) / T_var
    pooled_se <- sqrt(T_var)
    df_rub    <- (m - 1) * (1 + W_bar / ((1 + 1 / m) * B))^2

    # Complete case
    cc_fit <- lm(d$y[!d$miss_y] ~ d$x[!d$miss_y])
    b_cc   <- coef(cc_fit)["d$x[!d$miss_y]"]
    se_cc  <- summary(cc_fit)$coefficients["d$x[!d$miss_y]", "Std. Error"]

    # Oracle
    oracle_fit <- lm(d$y ~ d$x)
    b_or  <- coef(oracle_fit)["d$x"]
    se_or <- summary(oracle_fit)$coefficients["d$x", "Std. Error"]

    list(ests = ests, ses = ses, q_bar = q_bar, pooled_se = pooled_se,
         fmi = fmi, b_cc = b_cc, se_cc = se_cc, b_or = b_or, se_or = se_or,
         true_b = b, m = m)
    })
    })
  })

  output$rub_forest <- renderPlotly({
    req(rub_res())
    r <- rub_res()
    labs <- c(paste0("Imp ", seq_len(r$m)), "Pooled", "Complete Case", "Oracle")
    ests <- c(r$ests, r$q_bar, r$b_cc, r$b_or)
    ses  <- c(r$ses, r$pooled_se, r$se_cc, r$se_or)
    cols <- c(rep("rgba(38,139,210,0.6)", r$m),
              "#dc322f", "#2aa198", "#859900")
    sizes <- c(rep(6, r$m), 12, 10, 10)

    plot_ly() |>
      add_markers(x = ests, y = labs,
                  error_x = list(array = 1.96 * ses),
                  marker = list(color = cols, size = sizes),
                  hovertemplate = paste0(labs, ": %{x:.3f}<extra></extra>")) |>
      add_lines(x = c(r$true_b, r$true_b), y = c(0.5, length(labs) + 0.5),
                line = list(color = "#b58900", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Regression coefficient (\u03b2)"),
             yaxis = list(title = "", autorange = "reversed"),
             title = list(text = paste("True \u03b2 =", r$true_b, "| Yellow dashed = true value"),
                          font = list(size = 11)))
  })

  output$rub_table <- renderTable({
    req(rub_res())
    r <- rub_res()
    ci_pool <- r$q_bar + c(-1, 1) * qt(0.975, df = max(r$m - 1, 1)) * r$pooled_se
    ci_cc   <- r$b_cc + c(-1, 1) * 1.96 * r$se_cc
    ci_or   <- r$b_or + c(-1, 1) * 1.96 * r$se_or
    data.frame(
      Method   = c("Oracle (full data)", "Complete case", "MI Pooled"),
      Estimate = round(c(r$b_or, r$b_cc, r$q_bar), 4),
      SE       = round(c(r$se_or, r$se_cc, r$pooled_se), 4),
      CI_lower = round(c(ci_or[1], ci_cc[1], ci_pool[1]), 4),
      CI_upper = round(c(ci_or[2], ci_cc[2], ci_pool[2]), 4),
      FMI      = c(NA, NA, round(r$fmi, 3))
    )
  }, bordered = TRUE, striped = TRUE, na = "—")

  # ── Tab 4: Imputation Quality ──────────────────────────────────────────────
  iq_res <- reactiveVal(NULL)
  observeEvent(input$iq_go, {
    withProgress(message = "Assessing imputation quality...", value = 0.1, {
    iq_res({
    set.seed(sample(9999, 1))
    n   <- input$iq_n; pct <- input$iq_pct
    rho <- input$iq_rho; m <- input$iq_m

    # Bivariate normal: x1 (predictor), x2 (auxiliary), y (outcome)
    Sigma <- matrix(c(1, rho, 0.6,
                      rho, 1, 0.4,
                      0.6, 0.4, 1), 3, 3)
    dat   <- MASS::mvrnorm(n, mu = rep(0, 3), Sigma = Sigma)
    x1 <- dat[, 1]; x2 <- dat[, 2]; y <- dat[, 3]
    miss_y <- rbinom(n, 1, plogis(-0.5 + 1.2 * (x1 > 0))) == 1

    # Impute y using x1 only
    imps <- mice_impute(x1, ifelse(miss_y, NA_real_, y), miss_y, m = m, n_iter = 10)

    # FMI approximation
    ests <- sapply(imps, function(imp) coef(lm(imp$y ~ x1))["x1"])
    ses  <- sapply(imps, function(imp)
      summary(lm(imp$y ~ x1))$coefficients["x1", "Std. Error"])
    B    <- var(ests); W <- mean(ses^2)
    T_v  <- W + (1 + 1/m) * B
    fmi  <- max(0, min(1, (B + B / m) / T_v))

    # FMI as function of rho (theoretical approximation)
    rho_seq <- seq(0, 0.95, 0.05)
    fmi_seq <- 1 - rho_seq^2  # approx fraction of variance unexplained

    list(y = y, miss_y = miss_y, imps = imps, fmi = fmi,
         rho = rho, rho_seq = rho_seq, fmi_seq = fmi_seq)
    })
    })
  })

  output$iq_density <- renderPlotly({
    req(iq_res())
    r   <- iq_res()
    y_obs <- r$y[!r$miss_y]
    y_imp_all <- unlist(lapply(r$imps, function(imp) imp$y[r$miss_y]))
    plot_ly() |>
      add_histogram(x = y_obs, name = "Observed Y",
                    histnorm = "probability density", nbinsx = 20,
                    marker = list(color = "rgba(38,139,210,0.5)")) |>
      add_lines(x = density(y_imp_all)$x, y = density(y_imp_all)$y,
                name = "Imputed Y (all m)", line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      layout(barmode = "overlay",
             xaxis = list(title = "Y"), yaxis = list(title = "Density"))
  })

  output$iq_fmi_curve <- renderPlotly({
    req(iq_res())
    r <- iq_res()
    plot_ly() |>
      add_lines(x = r$rho_seq, y = r$fmi_seq, name = "Theoretical FMI",
                line = list(color = "#2aa198", width = 2)) |>
      add_markers(x = r$rho, y = r$fmi, name = "Current FMI",
                  marker = list(color = "#dc322f", size = 12),
                  hovertemplate = sprintf("\u03c1=%.2f, FMI=%.3f", r$rho, r$fmi)) |>
      layout(xaxis = list(title = "Predictor correlation \u03c1 with Y", range = c(0, 1)),
             yaxis = list(title = "FMI (fraction of info missing)", range = c(0, 1)),
             showlegend = FALSE)
  })

  output$iq_table <- renderTable({
    req(iq_res())
    r <- iq_res()
    data.frame(
      Metric = c("Sample n", "% missing", "Predictor \u03c1",
                 "Estimated FMI", "Imputations m"),
      Value  = c(input$iq_n, input$iq_pct, round(r$rho, 2),
                 round(r$fmi, 3), input$iq_m)
    )
  }, bordered = TRUE, striped = TRUE)

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Multiple Imputation", list(miss_data, mice_res, rub_res, iq_res))
  })
}
