# Module: Extended Models (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
extended_models_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Extended Models",
  icon = icon("layer-group"),
  navset_card_underline(
    nav_panel(
      "Mixed Models",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("mix_n_groups"), "Number of groups (clusters)", min = 3, max = 30, value = 10, step = 1),
      sliderInput(ns("mix_n_per"), "Observations per group", min = 5, max = 50, value = 15, step = 5),
      sliderInput(ns("mix_fixed_slope"), "Fixed slope (\u03b2\u2081)", min = -2, max = 2, value = 0.8, step = 0.1),
      sliderInput(ns("mix_re_intercept_sd"), "Random intercept SD (\u03c4\u2080)", min = 0, max = 3, value = 1, step = 0.1),
      sliderInput(ns("mix_re_slope_sd"), "Random slope SD (\u03c4\u2081)", min = 0, max = 1.5, value = 0.3, step = 0.05),
      sliderInput(ns("mix_resid_sd"), "Residual SD (\u03c3)", min = 0.5, max = 3, value = 1, step = 0.1),
      actionButton(ns("mix_gen"), "Generate & fit", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Multilevel / Mixed-Effects Models"),
      tags$p("When data is clustered (students within schools, patients within clinics),
              observations within the same group are not independent. Mixed-effects models
              handle this by adding random effects: group-specific deviations from
              the overall (fixed) effect. The term \u201cmixed\u201d refers to the combination
              of fixed effects (population-level parameters) and random effects
              (group-level deviations)."),
      tags$p("This module illustrates three approaches to clustered data:"),
      tags$ul(
        tags$li(tags$strong("Complete pooling"), " \u2014 ignores groups entirely, fitting a single OLS line.
                This is appropriate only if group membership is irrelevant (ICC \u2248 0)."),
        tags$li(tags$strong("No pooling"), " \u2014 fits a separate line per group. This uses only within-group
                information and produces noisy estimates for small groups."),
        tags$li(tags$strong("Partial pooling (mixed model)"), " \u2014 shrinks group estimates toward the
                overall mean. Groups with few observations are shrunk more heavily, borrowing
                strength from the full data set. This is the key advantage of mixed models.")
      ),
      tags$p("The shrinkage plot is particularly instructive: it shows how each group\u2019s
              intercept or slope moves from the no-pooling estimate toward the grand mean.
              Groups with smaller samples experience more shrinkage. This adaptive
              regularisation is a hallmark of multilevel modelling."),
      guide = tags$ol(
        tags$li("Generate data with random intercepts and slopes."),
        tags$li("Compare the three panels: partial pooling lines are 'shrunk' toward the grand mean."),
        tags$li("Increase \u03c4\u2080 (intercept SD) to see more spread between groups."),
        tags$li("Decrease n per group: partial pooling shrinks more when data is sparse.")
      )
    ),

    layout_column_wrap(
      width = 1 / 3,
      card(full_screen = TRUE, card_header("Complete Pooling (OLS)"), plotlyOutput(ns("mix_pooled"), height = "380px")),
      card(full_screen = TRUE, card_header("No Pooling (per-group OLS)"), plotlyOutput(ns("mix_nopool"), height = "380px")),
      card(full_screen = TRUE, card_header("Partial Pooling (Mixed Model)"), plotlyOutput(ns("mix_partial"), height = "380px"))
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(card_header("Shrinkage: No-pooling vs. Partial-pooling Intercepts"),
           plotlyOutput(ns("mix_shrinkage"), height = "320px")),
      card(card_header("Model Summary"),
           uiOutput(ns("mix_summary")))
    )
  )
    ),

    nav_panel(
      "Robust Regression",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("rob_n"), "Sample size", min = 30, max = 300, value = 80, step = 10),
      sliderInput(ns("rob_outlier_pct"), "Outlier percentage (%)", min = 0, max = 25,
                  value = 10, step = 5),
      sliderInput(ns("rob_outlier_shift"), "Outlier Y-shift", min = 5, max = 20,
                  value = 10, step = 1),
      actionButton(ns("rob_go"), "Fit models", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Robust Regression"),
      tags$p("Ordinary least squares (OLS) is sensitive to outliers because it
              minimises squared residuals \u2014 a single extreme observation can
              dramatically pull the fitted line. Robust methods downweight or
              ignore outlying observations, producing estimates that are resistant
              to contamination."),
      tags$ul(
        tags$li(tags$strong("Huber M-estimator:"), " Uses a loss function that is quadratic near zero
                but linear beyond a threshold (the tuning constant k, typically 1.345). This
                limits the influence of large residuals while retaining 95% efficiency under
                normality."),
        tags$li(tags$strong("MM-estimator:"), " Combines a high breakdown point (can tolerate up to
                50% contamination) with high efficiency (95% under normality). This is
                generally the recommended choice for routine robust regression."),
        tags$li(tags$strong("Median regression (LAD):"), " Minimises absolute deviations (L1 loss)
                rather than squared deviations. This is the regression analogue of the median
                \u2014 inherently resistant to outliers. It estimates conditional medians rather
                than conditional means.")
      ),
      tags$p("Robust regression is valuable not only for handling known outliers but also as
              a diagnostic tool. Comparing OLS and robust fits reveals whether the OLS results
              are driven by a few unusual observations. Large discrepancies between the two
              warrant closer investigation of those influential data points."),
      tags$p("In practice, robust methods are most useful when you suspect contamination but
              cannot identify outliers a priori, or when automated analysis pipelines must
              handle messy data without manual inspection. In clean data, robust and OLS
              estimates converge, so there is little downside to running robust methods
              as a routine sensitivity check."),
      guide = tags$ol(
        tags$li("Set sample size, outlier percentage, and shift magnitude."),
        tags$li("Click 'Fit models' to compare OLS vs. robust fits."),
        tags$li("Notice how outliers pull the OLS line but barely affect robust estimates."),
        tags$li("Increase the outlier percentage to see the breakdown of OLS.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Regression Lines"),
           plotlyOutput(ns("rob_plot"), height = "420px")),
      card(card_header("Coefficient Comparison"), tableOutput(ns("rob_table")))
    )
  )
    ),

    nav_panel(
      "Multinomial Regression",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("multi_type"), "Model type",
        choices = c("Multinomial (unordered)" = "multinomial",
                    "Ordinal (proportional odds)" = "ordinal"),
        selected = "multinomial"
      ),
      sliderInput(ns("multi_n"), "Sample size", min = 100, max = 1000,
                  value = 300, step = 50),
      sliderInput(ns("multi_b1"), "Effect of X on category 2 (vs 1)",
                  min = -2, max = 2, value = 0.8, step = 0.1),
      sliderInput(ns("multi_b2"), "Effect of X on category 3 (vs 1)",
                  min = -2, max = 2, value = 1.5, step = 0.1),
      actionButton(ns("multi_go"), "Fit model", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Multinomial & Ordinal Regression"),
      tags$p("When the outcome has more than two categories, standard logistic regression
              is insufficient. Multinomial and ordinal models extend the binary framework
              to handle multi-category outcomes while properly modelling the probability
              structure."),
      tags$ul(
        tags$li(tags$strong("Multinomial logistic:"), " Models the log-odds of each category relative
                to a reference category. Each predictor has a separate coefficient for each
                non-reference category, so the model has (K \u2212 1) \u00d7 p parameters
                for K categories and p predictors."),
        tags$li(tags$strong("Ordinal (proportional odds):"), " Models cumulative probabilities
                P(Y \u2264 j) using shared slope coefficients across all thresholds. The
                proportional odds assumption means each predictor shifts the cumulative log-odds
                by the same amount regardless of the threshold \u2014 this is both the model\u2019s
                strength (parsimony) and its key assumption to check.")
      ),
      tags$p("The proportional odds assumption can be tested with a Brant test or by comparing
              the ordinal model to separate binary logistic regressions at each threshold.
              If violated, alternatives include the partial proportional odds model (relaxing
              the assumption for specific predictors) or the multinomial model (though this
              discards the ordering information)."),
      tags$p("Multinomial models are commonly used in social sciences (e.g., predicting
              voting choice among multiple parties) and marketing (brand preference). Ordinal
              models are natural for Likert-scale responses, educational grades, or any outcome
              with a meaningful ordering. The choice between them should be driven by whether
              the ordering of categories carries information that the model should exploit."),
      guide = tags$ol(
        tags$li("Choose model type and set effect sizes."),
        tags$li("Click 'Fit model' to generate data and fit the model."),
        tags$li("The probability plot shows predicted probabilities across X values."),
        tags$li("Compare multinomial (different slopes per category) vs. ordinal (shared slope).")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Predicted Probabilities"),
           plotlyOutput(ns("multi_probs"), height = "400px")),
      card(card_header("Model Coefficients"), tableOutput(ns("multi_coefs")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

extended_models_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  sim <- reactiveVal(NULL)

  observeEvent(input$mix_gen, {
    req(requireNamespace("lme4", quietly = TRUE))
    set.seed(sample.int(10000, 1))

    J   <- input$mix_n_groups
    n_j <- input$mix_n_per
    b1  <- input$mix_fixed_slope
    tau0 <- input$mix_re_intercept_sd
    tau1 <- input$mix_re_slope_sd
    sig  <- input$mix_resid_sd

    u0 <- rnorm(J, 0, tau0)
    u1 <- rnorm(J, 0, tau1)

    df_list <- lapply(seq_len(J), function(j) {
      x <- runif(n_j, -2, 2)
      y <- (3 + u0[j]) + (b1 + u1[j]) * x + rnorm(n_j, 0, sig)
      data.frame(x = x, y = y, group = factor(j))
    })
    df <- do.call(rbind, df_list)

    m_pooled  <- lm(y ~ x, data = df)
    m_partial <- lme4::lmer(y ~ x + (1 + x | group), data = df)

    np_coefs <- do.call(rbind, lapply(levels(df$group), function(g) {
      sub <- df[df$group == g, ]
      m <- lm(y ~ x, data = sub)
      data.frame(group = g, intercept = coef(m)[1], slope = coef(m)[2])
    }))

    pp_coefs <- as.data.frame(coef(m_partial)$group)
    names(pp_coefs) <- c("intercept", "slope")
    pp_coefs$group <- rownames(pp_coefs)

    sim(list(df = df, m_pooled = m_pooled, m_partial = m_partial,
             np_coefs = np_coefs, pp_coefs = pp_coefs,
             fixed_int = lme4::fixef(m_partial)[1],
             fixed_slope = lme4::fixef(m_partial)[2]))
  })

  group_colors <- reactive({
    req(sim())
    J <- nlevels(sim()$df$group)
    if (J <= 8) RColorBrewer::brewer.pal(max(3, J), "Dark2")[seq_len(J)]
    else grDevices::hcl.colors(J, "Set2")
  })

  # Helper: build a native plotly scatter of data points by group
  build_base_scatter <- function(df, cols) {
    p <- plotly::plot_ly()
    for (g in levels(df$group)) {
      gd <- df[df$group == g, ]
      hover_txt <- paste0("Group: ", g,
                          "<br>x = ", round(gd$x, 3),
                          "<br>y = ", round(gd$y, 3))
      p <- p |>
        plotly::add_markers(
          x = gd$x, y = gd$y,
          marker = list(color = cols[as.integer(g)], size = 4, opacity = 0.45,
                        line = list(width = 0.5, color = "#FFFFFF")),
          hoverinfo = "text", text = hover_txt,
          name = paste0("Group ", g), showlegend = FALSE
        )
    }
    p
  }

  output$mix_pooled <- renderPlotly({
    req(sim())
    df <- sim()$df; cols <- group_colors()
    cf <- coef(sim()$m_pooled)
    xr <- range(df$x)

    build_base_scatter(df, cols) |>
      plotly::add_trace(
        x = xr, y = cf[1] + cf[2] * xr,
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 3),
        hoverinfo = "text",
        text = paste0("Pooled OLS<br>Intercept = ", round(cf[1], 3),
                      "<br>Slope = ", round(cf[2], 3)),
        name = "OLS", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "x"), yaxis = list(title = "y"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mix_nopool <- renderPlotly({
    req(sim())
    df <- sim()$df; cols <- group_colors(); np <- sim()$np_coefs
    xr <- range(df$x)

    p <- build_base_scatter(df, cols)
    for (i in seq_len(nrow(np))) {
      hover_txt <- paste0("Group ", np$group[i],
                          "<br>Intercept = ", round(np$intercept[i], 3),
                          "<br>Slope = ", round(np$slope[i], 3))
      p <- p |>
        plotly::add_trace(
          x = xr, y = np$intercept[i] + np$slope[i] * xr,
          type = "scatter", mode = "lines",
          line = list(color = cols[i], width = 1.5),
          hoverinfo = "text", text = hover_txt,
          name = paste0("Grp ", np$group[i]), showlegend = FALSE
        )
    }
    p |> plotly::layout(
      xaxis = list(title = "x"), yaxis = list(title = "y"),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mix_partial <- renderPlotly({
    req(sim())
    df <- sim()$df; cols <- group_colors(); pp <- sim()$pp_coefs
    xr <- range(df$x)

    p <- build_base_scatter(df, cols)
    for (i in seq_len(nrow(pp))) {
      hover_txt <- paste0("Group ", pp$group[i],
                          "<br>Intercept = ", round(pp$intercept[i], 3),
                          "<br>Slope = ", round(pp$slope[i], 3),
                          "<br>(partial pooling)")
      p <- p |>
        plotly::add_trace(
          x = xr, y = pp$intercept[i] + pp$slope[i] * xr,
          type = "scatter", mode = "lines",
          line = list(color = cols[i], width = 1.5),
          hoverinfo = "text", text = hover_txt,
          name = paste0("Grp ", pp$group[i]), showlegend = FALSE
        )
    }
    # Grand mean line
    fi <- sim()$fixed_int; fs <- sim()$fixed_slope
    p |>
      plotly::add_trace(
        x = xr, y = fi + fs * xr,
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 3, dash = "dash"),
        hoverinfo = "text",
        text = paste0("Grand mean<br>Intercept = ", round(fi, 3),
                      "<br>Slope = ", round(fs, 3)),
        name = "Grand mean", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "x"), yaxis = list(title = "y"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mix_shrinkage <- renderPlotly({
    req(sim())
    np <- sim()$np_coefs; pp <- sim()$pp_coefs
    df_shrink <- data.frame(
      group = np$group,
      np_int = np$intercept,
      pp_int = pp$intercept[match(np$group, pp$group)]
    )
    grand <- sim()$fixed_int

    p <- plotly::plot_ly()
    for (i in seq_len(nrow(df_shrink))) {
      # Arrow segment (no-pooling -> partial-pooling)
      p <- p |>
        plotly::add_annotations(
          x = df_shrink$pp_int[i], y = df_shrink$group[i],
          ax = df_shrink$np_int[i], ay = df_shrink$group[i],
          xref = "x", yref = "y", axref = "x", ayref = "y",
          showarrow = TRUE, arrowhead = 3, arrowsize = 0.8,
          arrowcolor = "grey50", text = ""
        )
    }

    hover_np <- paste0("Group ", df_shrink$group,
                       "<br>No-pooling intercept = ", round(df_shrink$np_int, 3))
    hover_pp <- paste0("Group ", df_shrink$group,
                       "<br>Partial-pooling intercept = ", round(df_shrink$pp_int, 3),
                       "<br>Shrinkage = ", round(df_shrink$np_int - df_shrink$pp_int, 3))

    p |>
      plotly::add_markers(
        x = df_shrink$np_int, y = df_shrink$group,
        marker = list(color = "#e31a1c", size = 8,
                      line = list(width = 1, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_np,
        name = "No pooling", showlegend = TRUE
      ) |>
      plotly::add_markers(
        x = df_shrink$pp_int, y = df_shrink$group,
        marker = list(color = "#238b45", size = 8,
                      line = list(width = 1, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_pp,
        name = "Partial pooling", showlegend = TRUE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = grand, x1 = grand,
               y0 = -0.5, y1 = nrow(df_shrink) + 0.5,
               line = list(color = "#00441b", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Intercept estimate"),
        yaxis = list(title = "Group", type = "category"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        annotations = list(
          list(x = grand, y = -0.3, text = "Grand mean",
               showarrow = FALSE, font = list(size = 11, color = "#00441b"))
        ),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mix_summary <- renderUI({
    req(sim())
    HTML(fmt_lmer_html(sim()$m_partial))
  })

  rob_data <- reactiveVal(NULL)

  observeEvent(input$rob_go, {
    n <- input$rob_n; pct <- input$rob_outlier_pct / 100
    shift <- input$rob_outlier_shift
    set.seed(sample.int(10000, 1))

    n_out <- round(n * pct); n_clean <- n - n_out
    x <- rnorm(n)
    y_clean <- 2 + 1.5 * x[seq_len(n_clean)] + rnorm(n_clean)
    y_out <- if (n_out > 0) {
      2 + 1.5 * x[(n_clean + 1):n] + shift + rnorm(n_out)
    } else numeric(0)
    y <- c(y_clean, y_out)
    is_outlier <- c(rep(FALSE, n_clean), rep(TRUE, n_out))
    dat <- data.frame(x = x, y = y, outlier = is_outlier)

    ols <- lm(y ~ x, data = dat)
    huber <- MASS::rlm(y ~ x, data = dat, method = "M")
    mm <- MASS::rlm(y ~ x, data = dat, method = "MM")

    rob_data(list(dat = dat, ols = ols, huber = huber, mm = mm))
  })

  output$rob_plot <- renderPlotly({
    res <- rob_data()
    req(res)
    dat <- res$dat
    xr <- range(dat$x)
    xseq <- seq(xr[1], xr[2], length.out = 100)
    pred_ols <- predict(res$ols, newdata = data.frame(x = xseq))
    pred_hub <- predict(res$huber, newdata = data.frame(x = xseq))
    pred_mm  <- predict(res$mm, newdata = data.frame(x = xseq))

    col_pts <- ifelse(dat$outlier, "#e31a1c", "rgba(150,150,150,0.5)")

    plotly::plot_ly() |>
      plotly::add_markers(
        x = dat$x, y = dat$y,
        marker = list(color = col_pts, size = 5),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("x = ", round(dat$x, 2), "<br>y = ", round(dat$y, 2),
                       if (any(dat$outlier)) paste0("<br>Outlier: ", dat$outlier) else "")
      ) |>
      plotly::add_trace(x = xseq, y = pred_ols, type = "scatter", mode = "lines",
                        line = list(color = "#fd8d3c", width = 2),
                        name = "OLS") |>
      plotly::add_trace(x = xseq, y = pred_hub, type = "scatter", mode = "lines",
                        line = list(color = "#238b45", width = 2),
                        name = "Huber M") |>
      plotly::add_trace(x = xseq, y = pred_mm, type = "scatter", mode = "lines",
                        line = list(color = "#3182bd", width = 2),
                        name = "MM") |>
      plotly::layout(
        xaxis = list(title = "X"), yaxis = list(title = "Y"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        annotations = list(list(
          x = 0.5, y = 1.05, xref = "paper", yref = "paper",
          text = paste0("True: \u03b2\u2080 = 2, \u03b2\u2081 = 1.5"),
          showarrow = FALSE, font = list(size = 12)
        )),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rob_table <- renderTable({
    res <- rob_data(); req(res)
    data.frame(
      Method = c("True", "OLS", "Huber M", "MM"),
      Intercept = round(c(2, coef(res$ols)[1], coef(res$huber)[1], coef(res$mm)[1]), 3),
      Slope = round(c(1.5, coef(res$ols)[2], coef(res$huber)[2], coef(res$mm)[2]), 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  multi_data <- reactiveVal(NULL)

  observeEvent(input$multi_go, {
    n <- input$multi_n; b1 <- input$multi_b1; b2 <- input$multi_b2
    type <- input$multi_type
    set.seed(sample.int(10000, 1))

    x <- rnorm(n)

    if (type == "multinomial") {
      # Multinomial logit: log(P(Y=j)/P(Y=1)) = b_j * x
      lp2 <- b1 * x; lp3 <- b2 * x
      denom <- 1 + exp(lp2) + exp(lp3)
      p1 <- 1 / denom; p2 <- exp(lp2) / denom; p3 <- exp(lp3) / denom
      y <- sapply(seq_len(n), function(i) sample(1:3, 1, prob = c(p1[i], p2[i], p3[i])))
      y <- factor(y)
      dat <- data.frame(x = x, y = y)
      fit <- nnet::multinom(y ~ x, data = dat, trace = FALSE)
      coef_df <- data.frame(
        Category = rep(c("2 vs 1", "3 vs 1"), each = 2),
        Term = rep(c("Intercept", "x"), 2),
        Estimate = round(as.vector(t(coef(fit))), 3)
      )
    } else {
      # Ordinal: proportional odds
      # P(Y <= j) = logit^{-1}(alpha_j - beta * x)
      beta <- (b1 + b2) / 2
      alpha <- c(0, 1.5)
      lp <- outer(alpha, beta * x, FUN = "-")
      cum_p <- plogis(lp)
      p1 <- cum_p[1, ]
      p2 <- cum_p[2, ] - cum_p[1, ]
      p3 <- 1 - cum_p[2, ]
      p1 <- pmax(p1, 0.001); p2 <- pmax(p2, 0.001); p3 <- pmax(p3, 0.001)
      y <- sapply(seq_len(n), function(i) sample(1:3, 1, prob = c(p1[i], p2[i], p3[i])))
      y <- ordered(y)
      dat <- data.frame(x = x, y = y)
      fit <- MASS::polr(y ~ x, data = dat)
      s <- summary(fit)
      coef_df <- data.frame(
        Term = rownames(s$coefficients),
        Estimate = round(s$coefficients[, "Value"], 3),
        `Std Error` = round(s$coefficients[, "Std. Error"], 3),
        check.names = FALSE
      )
    }

    multi_data(list(dat = dat, fit = fit, coefs = coef_df, type = type))
  })

  output$multi_probs <- renderPlotly({
    res <- multi_data()
    req(res)
    xseq <- seq(-3, 3, length.out = 200)
    newdat <- data.frame(x = xseq)

    if (res$type == "multinomial") {
      probs <- predict(res$fit, newdata = newdat, type = "probs")
    } else {
      probs <- predict(res$fit, newdata = newdat, type = "probs")
    }
    if (is.null(dim(probs))) probs <- matrix(probs, ncol = 3)

    cols <- c("#3182bd", "#238b45", "#e31a1c")
    p <- plotly::plot_ly()
    for (j in seq_len(ncol(probs))) {
      p <- p |> plotly::add_trace(
        x = xseq, y = probs[, j],
        type = "scatter", mode = "lines",
        line = list(color = cols[j], width = 2),
        name = paste("Category", j),
        hoverinfo = "text",
        text = paste0("x = ", round(xseq, 2), "<br>P(Y=", j, ") = ", round(probs[, j], 3))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "X"), yaxis = list(title = "Probability", range = c(0, 1)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$multi_coefs <- renderTable({
    res <- multi_data(); req(res)
    res$coefs
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
