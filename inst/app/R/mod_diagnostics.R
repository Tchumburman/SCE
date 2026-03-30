# Module: Model Diagnostics (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
diagnostics_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Model Diagnostics",
  icon = icon("stethoscope"),
  navset_card_underline(
    nav_panel(
      "Assumptions",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("assum_scenario"), "Scenario",
        choices = c("All assumptions met",
                    "Non-linearity",
                    "Heteroscedasticity",
                    "Non-normal errors",
                    "Multicollinearity",
                    "Outliers / High leverage"),
        selected = "All assumptions met"
      ),
      sliderInput(ns("assum_n"), "Sample size", min = 30, max = 500, value = 100, step = 10),
      sliderInput(ns("assum_noise"), "Noise level", min = 0.5, max = 5, value = 1, step = 0.25),
      actionButton(ns("assum_gen"), "Generate data", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Regression Assumptions"),
      tags$p("OLS regression rests on four key assumptions: (1) ", tags$em("linearity"), " \u2014 the
              relationship between predictors and response is linear in the parameters;
              (2) ", tags$em("independence"), " \u2014 errors are uncorrelated across observations;
              (3) ", tags$em("homoscedasticity"), " \u2014 the error variance is constant across all
              levels of the predictor; and (4) ", tags$em("normality"), " \u2014 errors follow a
              Normal distribution (needed primarily for inference, not estimation)."),
      tags$p("Non-linearity and omitted variables can bias coefficient estimates.
              Heteroscedasticity does not bias coefficients but makes standard errors
              (and thus p-values and CIs) unreliable. Autocorrelated errors (common in
              time series) similarly distort standard errors. Non-normality mainly
              affects inference for small samples; the CLT protects large-sample inference."),
      tags$p("Diagnostic plots are the primary tool for detecting violations. The
              residuals-vs-fitted plot reveals non-linearity (curvature) and
              heteroscedasticity (fanning). The Normal QQ plot of residuals checks
              normality. The scale-location plot is another view of heteroscedasticity.
              This module lets you generate data under each violation to build pattern
              recognition for these diagnostics."),
      guide = tags$ol(
        tags$li("Start with 'All assumptions met' to see healthy diagnostics."),
        tags$li("Switch to each violation and compare the four diagnostic plots."),
        tags$li("Non-linearity: residuals vs. fitted shows a curve."),
        tags$li("Heteroscedasticity: residuals fan out (cone shape)."),
        tags$li("Non-normal errors: QQ plot deviates from the line."),
        tags$li("Multicollinearity: VIF values become large; estimates are unstable.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Scatter + Fit"), plotlyOutput(ns("assum_scatter"), height = "350px")),
      card(full_screen = TRUE, card_header("Residuals vs. Fitted"), plotlyOutput(ns("assum_resid_fit"), height = "350px")),
      card(full_screen = TRUE, card_header("QQ Plot of Residuals"), plotlyOutput(ns("assum_qq"), height = "350px")),
      card(full_screen = TRUE, card_header("Scale-Location"), plotlyOutput(ns("assum_scale_loc"), height = "350px"))
    ),
    conditionalPanel(ns = ns, "input.assum_scenario == 'Multicollinearity'",
      card(card_header("Variance Inflation Factors"), tableOutput(ns("assum_vif_table")))
    )
  )
    ),

    nav_panel(
      "Regularization",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("reg_n"), "Sample size", min = 30, max = 300, value = 100, step = 10),
      sliderInput(ns("reg_p"), "Number of predictors", min = 3, max = 20, value = 8, step = 1),
      sliderInput(ns("reg_relevant"), "Truly relevant predictors", min = 1, max = 10, value = 3, step = 1),
      sliderInput(ns("reg_noise"), "Noise level (\u03c3)", min = 0.5, max = 5, value = 1, step = 0.25),
      tags$hr(),
      sliderInput(ns("reg_alpha_en"), "Elastic Net mixing (\u03b1)",
                  min = 0, max = 1, value = 1, step = 0.1),
      tags$small(class = "text-muted",
        "\u03b1 = 0: Ridge, \u03b1 = 1: Lasso, between: Elastic Net"),
      tags$hr(),
      actionButton(ns("reg_run"), "Generate & fit", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Regularised Regression"),
      tags$p("When there are many predictors (especially irrelevant ones), OLS can
              overfit: it captures noise in the training data, producing coefficients that
              do not generalise well. Regularisation adds a penalty to the loss function,
              shrinking coefficients toward zero and trading a small increase in bias for a
              large reduction in variance."),
      tags$ul(
        tags$li(tags$strong("Ridge (\u03b1 = 0)"), " \u2014 adds an L2 penalty (\u03bb\u2211\u03b2\u00b2).
                Shrinks all coefficients but never to exactly zero. Best when many predictors
                each have a small effect (dense signal). Also stabilises estimation when
                predictors are highly correlated (multicollinearity)."),
        tags$li(tags$strong("Lasso (\u03b1 = 1)"), " \u2014 adds an L1 penalty (\u03bb\u2211|\u03b2|).
                Can shrink coefficients to exactly zero, performing automatic feature selection.
                Best when only a few predictors truly matter (sparse signal). May be unstable
                when predictors are correlated, arbitrarily selecting one from a correlated group."),
        tags$li(tags$strong("Elastic Net (0 < \u03b1 < 1)"), " \u2014 combines L1 and L2 penalties.
                Inherits Lasso\u2019s sparsity while handling correlated predictors more
                gracefully than pure Lasso. The mixing parameter \u03b1 controls the balance.")
      ),
      tags$p("The penalty strength \u03bb is chosen via cross-validation: the value that
              minimises prediction error on held-out data. The coefficient path plot shows
              how each coefficient changes as \u03bb increases from zero (OLS) to large values
              (all coefficients shrunk toward zero). This visualisation reveals which
              predictors are most robust to penalisation."),
      tags$p("Regularisation is especially important in high-dimensional settings (many
              predictors relative to observations), where OLS either cannot be computed
              (p > n) or is severely overfit. In genomics, text analysis, and other fields
              with thousands of features, regularised methods are the default approach.
              Even in traditional settings with modest numbers of predictors, Ridge
              regression can improve prediction by stabilising coefficient estimates."),
      guide = tags$ol(
        tags$li("Generate data with some truly relevant and some irrelevant predictors."),
        tags$li("The coefficient path plot shows how coefficients shrink as \u03bb increases."),
        tags$li("The cross-validation plot shows the optimal \u03bb."),
        tags$li("Compare Ridge vs. Lasso by changing \u03b1.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Coefficient Path (vs. log \u03bb)"),
           plotlyOutput(ns("reg_path"), height = "380px")),
      card(full_screen = TRUE, card_header("Cross-Validation Error"),
           plotlyOutput(ns("reg_cv"), height = "380px"))
    ),
    card(card_header("Coefficient Estimates at Optimal \u03bb"),
         tableOutput(ns("reg_coef_table")))
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

diagnostics_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  sim_data <- reactiveVal(NULL)

  # Regenerate data on button click OR when the scenario changes
  observeEvent(list(input$assum_gen, input$assum_scenario), {
    req(input$assum_n, input$assum_noise, input$assum_scenario)
    set.seed(sample.int(10000, 1))
    n   <- input$assum_n
    sig <- input$assum_noise
    scn <- input$assum_scenario

    x <- runif(n, 0, 10)

    if (scn == "All assumptions met") {
      y <- 2 + 1.5 * x + rnorm(n, 0, sig)
      df <- data.frame(x = x, y = y)

    } else if (scn == "Non-linearity") {
      y <- 2 + 0.3 * x^2 - 0.5 * x + rnorm(n, 0, sig)
      df <- data.frame(x = x, y = y)

    } else if (scn == "Heteroscedasticity") {
      y <- 2 + 1.5 * x + rnorm(n, 0, sig * (0.3 + 0.3 * x))
      df <- data.frame(x = x, y = y)

    } else if (scn == "Non-normal errors") {
      y <- 2 + 1.5 * x + rt(n, df = 3) * sig
      df <- data.frame(x = x, y = y)

    } else if (scn == "Multicollinearity") {
      x2 <- x + rnorm(n, 0, 0.3)
      x3 <- runif(n, 0, 10)
      y <- 2 + 1.5 * x + 0.8 * x2 + 0.5 * x3 + rnorm(n, 0, sig)
      df <- data.frame(x = x, x2 = x2, x3 = x3, y = y)

    } else {
      y <- 2 + 1.5 * x + rnorm(n, 0, sig)
      idx <- sample(n, 5)
      y[idx] <- y[idx] + sample(c(-1, 1), 5, replace = TRUE) * runif(5, 8, 15)
      x <- c(x, 20)
      y <- c(y, 2 + 1.5 * 5 + rnorm(1, 0, sig))
      df <- data.frame(x = x, y = y)
    }

    sim_data(df)
  })

  fitted_model <- reactive({
    req(sim_data())
    df <- sim_data()
    if (input$assum_scenario == "Multicollinearity") {
      lm(y ~ x + x2 + x3, data = df)
    } else {
      lm(y ~ x, data = df)
    }
  })

  output$assum_scatter <- renderPlotly({
    req(sim_data())
    df <- sim_data()
    m  <- fitted_model()

    fit_line <- data.frame(x = sort(df$x), yhat = fitted(m)[order(df$x)])
    hover_pts <- paste0("x = ", round(df$x, 3),
                        "<br>y = ", round(df$y, 3),
                        "<br>Fitted = ", round(fitted(m), 3),
                        "<br>Residual = ", round(residuals(m), 3))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$x, y = df$y,
        marker = list(color = "#238b45", size = 5, opacity = 0.5,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_pts,
        name = "Data", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = fit_line$x, y = fit_line$yhat,
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 2),
        hoverinfo = "none", name = "OLS Fit", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "x"),
        yaxis = list(title = "y"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = input$assum_scenario,
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$assum_resid_fit <- renderPlotly({
    req(sim_data())
    m <- fitted_model()
    fv <- fitted(m)
    res <- residuals(m)

    # Loess smooth for trend
    lo <- loess(res ~ fv)
    lo_x <- sort(fv)
    lo_y <- predict(lo, newdata = data.frame(fv = lo_x))

    hover_txt <- paste0("Fitted = ", round(fv, 3),
                        "<br>Residual = ", round(res, 3),
                        "<br>Std. Residual = ", round(rstandard(m), 3))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = fv, y = res,
        marker = list(color = "#238b45", size = 5, opacity = 0.5,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = lo_x, y = lo_y,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = min(fv), x1 = max(fv), y0 = 0, y1 = 0,
               line = list(color = "#e31a1c", width = 1, dash = "dash"))
        ),
        xaxis = list(title = "Fitted values"),
        yaxis = list(title = "Residuals"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$assum_qq <- renderPlotly({
    req(sim_data())
    m <- fitted_model()
    res <- sort(rstandard(m))
    n <- length(res)
    p <- (seq_len(n) - 0.5) / n
    theo <- qnorm(p)

    # QQ line
    q_s <- quantile(res, c(0.25, 0.75))
    q_t <- qnorm(c(0.25, 0.75))
    slope <- diff(q_s) / diff(q_t)
    intercept <- q_s[1] - slope * q_t[1]
    line_y <- intercept + slope * theo

    hover_txt <- paste0("Theoretical: ", round(theo, 3),
                        "<br>Std. Residual: ", round(res, 3),
                        "<br>Deviation: ", round(res - line_y, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = theo, y = line_y, type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2, dash = "dash"),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = theo, y = res,
        marker = list(color = "#238b45", size = 5, opacity = 0.6,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Theoretical Quantiles"),
        yaxis = list(title = "Standardized Residuals"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$assum_scale_loc <- renderPlotly({
    req(sim_data())
    m <- fitted_model()
    fv <- fitted(m)
    srl <- sqrt(abs(rstandard(m)))

    lo <- loess(srl ~ fv)
    lo_x <- sort(fv)
    lo_y <- predict(lo, newdata = data.frame(fv = lo_x))

    hover_txt <- paste0("Fitted = ", round(fv, 3),
                        "<br>\u221a|Std. Residual| = ", round(srl, 3))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = fv, y = srl,
        marker = list(color = "#238b45", size = 5, opacity = 0.5,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = lo_x, y = lo_y,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Fitted values"),
        yaxis = list(title = "\u221a|Standardized Residuals|"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$assum_vif_table <- renderTable({
    req(sim_data(), input$assum_scenario == "Multicollinearity")
    m <- fitted_model()
    p <- length(coef(m)) - 1
    vif_vals <- sapply(2:(p + 1), function(j) {
      xmat <- model.matrix(m)
      r2 <- summary(lm(xmat[, j] ~ xmat[, -c(1, j)]))$r.squared
      1 / (1 - r2)
    })
    data.frame(
      Predictor = names(coef(m))[-1],
      VIF = round(vif_vals, 2),
      Concern = ifelse(vif_vals > 10, "HIGH", ifelse(vif_vals > 5, "Moderate", "OK"))
    )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)


  fit_result <- reactiveVal(NULL)

  observeEvent(input$reg_run, {
    req(requireNamespace("glmnet", quietly = TRUE))
    set.seed(sample.int(10000, 1))

    n   <- input$reg_n
    p   <- input$reg_p
    k   <- min(input$reg_relevant, p)
    sig <- input$reg_noise
    alpha <- input$reg_alpha_en

    true_beta <- c(runif(k, 1, 3) * sample(c(-1, 1), k, replace = TRUE),
                   rep(0, p - k))
    X <- matrix(rnorm(n * p), n, p)
    colnames(X) <- paste0("X", seq_len(p))
    y <- X %*% true_beta + rnorm(n, 0, sig)

    cv_fit <- glmnet::cv.glmnet(X, y, alpha = alpha, nfolds = 10)
    fit    <- glmnet::glmnet(X, y, alpha = alpha)

    fit_result(list(cv_fit = cv_fit, fit = fit, true_beta = true_beta,
                    X = X, y = y, alpha = alpha, p = p, k = k))
  })

  output$reg_path <- renderPlotly({
    req(fit_result())
    fr <- fit_result()
    coef_mat <- as.matrix(fr$fit$beta)
    lambda   <- fr$fit$lambda
    log_lam  <- log(lambda)

    palette <- if (fr$p <= 10) {
      scales::hue_pal()(fr$p)
    } else {
      grDevices::colorRampPalette(c("#238b45","#3182bd","#e31a1c","#ff7f00","#6a3d9a"))(fr$p)
    }

    p <- plotly::plot_ly()
    for (i in seq_len(nrow(coef_mat))) {
      vname <- rownames(coef_mat)[i]
      relevant <- i <= fr$k
      hover_txt <- paste0("Predictor: ", vname,
                          "<br>log(\u03bb) = ", round(log_lam, 2),
                          "<br>Coef = ", round(coef_mat[i, ], 3),
                          "<br>True \u03b2 = ", round(fr$true_beta[i], 3),
                          "<br>", if (relevant) "Relevant" else "Irrelevant")
      p <- p |>
        plotly::add_trace(
          x = log_lam, y = coef_mat[i, ],
          type = "scatter", mode = "lines",
          line = list(color = palette[i], width = if (relevant) 2.5 else 1.2,
                      dash = if (relevant) "solid" else "dash"),
          hoverinfo = "text", text = hover_txt,
          name = paste0(vname, if (relevant) " *" else ""),
          showlegend = TRUE
        )
    }

    p |> plotly::layout(
      shapes = list(
        list(type = "line", x0 = min(log_lam), x1 = max(log_lam), y0 = 0, y1 = 0,
             line = list(color = "grey60", width = 1, dash = "dot")),
        list(type = "line", x0 = log(fr$cv_fit$lambda.min), x1 = log(fr$cv_fit$lambda.min),
             y0 = min(coef_mat), y1 = max(coef_mat),
             line = list(color = "#e31a1c", width = 1.5, dash = "dash"))
      ),
      xaxis = list(title = "log(\u03bb)"),
      yaxis = list(title = "Coefficient"),
      annotations = list(
        list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
             text = paste0("\u03b1 = ", fr$alpha,
                           if (fr$alpha == 0) " (Ridge)"
                           else if (fr$alpha == 1) " (Lasso)"
                           else " (Elastic Net)"),
             showarrow = FALSE, font = list(size = 13))
      ),
      legend = list(orientation = "v", x = 1.02, y = 0.5, font = list(size = 10)),
      margin = list(t = 40, r = 100)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$reg_cv <- renderPlotly({
    req(fit_result())
    fr <- fit_result()
    cv <- fr$cv_fit
    log_lam <- log(cv$lambda)

    hover_txt <- paste0("log(\u03bb) = ", round(log_lam, 3),
                        "<br>MSE = ", round(cv$cvm, 3),
                        "<br>SE = ", round(cv$cvsd, 3),
                        "<br>Nonzero: ", cv$nzero)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = log_lam, y = cv$cvup, type = "scatter", mode = "lines",
        line = list(color = "transparent"), showlegend = FALSE, hoverinfo = "none"
      ) |>
      plotly::add_trace(
        x = log_lam, y = cv$cvlo, type = "scatter", mode = "lines",
        line = list(color = "transparent"), fill = "tonexty",
        fillcolor = "rgba(199,233,192,0.5)",
        showlegend = FALSE, hoverinfo = "none"
      ) |>
      plotly::add_trace(
        x = log_lam, y = cv$cvm, type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 4),
        hoverinfo = "text", text = hover_txt,
        name = "CV MSE", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = log(cv$lambda.min), x1 = log(cv$lambda.min),
               y0 = min(cv$cvlo), y1 = max(cv$cvup),
               line = list(color = "#e31a1c", width = 1.5, dash = "dash")),
          list(type = "line", x0 = log(cv$lambda.1se), x1 = log(cv$lambda.1se),
               y0 = min(cv$cvlo), y1 = max(cv$cvup),
               line = list(color = "#3182bd", width = 1.5, dash = "dot"))
        ),
        annotations = list(
          list(x = log(cv$lambda.min), y = max(cv$cvup),
               text = "\u03bb.min", showarrow = FALSE,
               font = list(color = "#e31a1c", size = 12), yshift = 12),
          list(x = log(cv$lambda.1se), y = max(cv$cvup),
               text = "\u03bb.1se", showarrow = FALSE,
               font = list(color = "#3182bd", size = 12), yshift = 12)
        ),
        xaxis = list(title = "log(\u03bb)"),
        yaxis = list(title = "Mean Squared Error (CV)"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$reg_coef_table <- renderTable({
    req(fit_result())
    fr <- fit_result()
    coefs <- as.vector(coef(fr$cv_fit, s = "lambda.min"))[-1]
    data.frame(
      Predictor = paste0("X", seq_len(fr$p)),
      True = round(fr$true_beta, 3),
      Estimated = round(coefs, 3),
      Selected = ifelse(abs(coefs) > 1e-6, "\u2713", "")
    )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  # Auto-run simulations on first load
  })
}
