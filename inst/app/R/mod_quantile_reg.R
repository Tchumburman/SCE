# Module: Quantile Regression
# 3 tabs: Quantile Regression Basics · Heterogeneous Effects · Multiple Quantiles

# ── UI ────────────────────────────────────────────────────────────────────────
quantile_reg_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Quantile Regression",
  icon = icon("chart-bar"),
  navset_card_underline(

    # ── Tab 1: Basics ─────────────────────────────────────────────────────────
    nav_panel(
      "Basics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("qr_n"), "Sample size n", 50, 500, 200, 50),
          selectInput(ns("qr_dgp"), "Data-generating process",
            choices = c("Homoscedastic (OLS applies)",
                        "Heteroscedastic (variance grows with x)",
                        "Skewed residuals",
                        "Heavy-tailed (t\u2082 errors)",
                        "Threshold variance"),
            selected = "Heteroscedastic (variance grows with x)"),
          sliderInput(ns("qr_tau"), "Quantile \u03c4 to fit", 0.05, 0.95, 0.5, 0.05),
          actionButton(ns("qr_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("qr_show_ols"), "Show OLS fit", value = TRUE),
          checkboxInput(ns("qr_show_median"), "Show QR at \u03c4 = 0.5 (median)", value = TRUE)
        ),
        explanation_box(
          tags$strong("Quantile Regression"),
          tags$p("Ordinary least squares estimates the ", tags$strong("conditional mean"), " E[Y|X].
                  Quantile regression estimates the conditional quantile Q\u03c4(Y|X):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "Q\u03c4(y|x) = x\u1d40\u03b2(\u03c4)"),
          tags$p("The regression coefficients \u03b2(\u03c4) are estimated by minimising the ", tags$strong("check function"),
                  " (pinball loss):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "\u03c1\u03c4(u) = u(\u03c4 \u2212 I(u < 0))"),
          tags$p("This asymmetric absolute-value loss penalises positive residuals with weight \u03c4 and
                  negative residuals with weight 1 \u2212 \u03c4."),
          tags$p("Key advantages:"),
          tags$ul(
            tags$li(tags$strong("Robust to outliers"), " — especially the median regression (\u03c4 = 0.5)."),
            tags$li(tags$strong("No distributional assumption"), " about the error term."),
            tags$li(tags$strong("Captures heterogeneous effects"), " — how predictors affect the distribution,
                    not just the mean.")
          ),
          guide = tags$ol(
            tags$li("Select 'Heteroscedastic' data: note how the variance fan widens with x."),
            tags$li("Move \u03c4 to 0.1 or 0.9 — the line shifts to the tails of the scatter cloud."),
            tags$li("Compare OLS (mean) to quantile regression at \u03c4 = 0.5 (median) with skewed residuals.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Data + Quantile Regression Fit"),
               plotlyOutput(ns("qr_fit_plot"), height = "360px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Check Function (Pinball Loss)"),
                 plotlyOutput(ns("qr_loss_plot"), height = "250px")),
            card(card_header("Coefficient Comparison"),
                 tableOutput(ns("qr_coef_table")))
          )
        )
      )
    ),

    # ── Tab 2: Heterogeneous Effects ──────────────────────────────────────────
    nav_panel(
      "Heterogeneous Effects",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("qrh_n"), "Sample size n", 100, 600, 300, 100),
          selectInput(ns("qrh_scenario"), "Scenario",
            choices = c("Fan spread (increasing variance)",
                        "Location shift only (parallel quantiles)",
                        "Scale shift (widening gap)",
                        "Tail asymmetry"),
            selected = "Fan spread (increasing variance)"),
          sliderInput(ns("qrh_noise"), "Base noise level", 0.2, 2, 0.8, 0.1),
          actionButton(ns("qrh_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Heterogeneous Effects Across the Distribution"),
          tags$p("When slopes \u03b2(\u03c4) differ across \u03c4, a predictor has a ", tags$strong("heterogeneous effect"),
                  ": it shifts some parts of the outcome distribution more than others."),
          tags$ul(
            tags$li(tags$strong("Parallel quantile lines"), " indicate a pure location shift — the effect is
                    the same at every quantile (constant \u03b2 across \u03c4). OLS adequately captures this."),
            tags$li(tags$strong("Fan spread"), " — lines diverge with x. The predictor increases both the
                    mean and the variance. OLS misses this entirely."),
            tags$li(tags$strong("Scale shift"), " — the gap between quantile lines grows. High-ability groups
                    benefit more than low-ability groups from an intervention.")
          ),
          tags$p("Quantile regression is the standard tool for detecting and quantifying these
                  heterogeneous effects, which are invisible to mean regression."),
          guide = tags$ol(
            tags$li("Choose 'Fan spread': all quantile lines have different slopes, diverging from left to right."),
            tags$li("Choose 'Location shift only': all lines are parallel \u2014 OLS is sufficient."),
            tags$li("'Scale shift' shows a realistic education/inequality scenario.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Multiple Quantile Lines (0.1, 0.25, 0.5, 0.75, 0.9)"),
               plotlyOutput(ns("qrh_plot"), height = "360px")),
          card(card_header("Slope Estimates by Quantile"),
               plotlyOutput(ns("qrh_slopes"), height = "260px"))
        )
      )
    ),

    # ── Tab 3: Multiple Quantiles ─────────────────────────────────────────────
    nav_panel(
      "Quantile Process",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("qrp_n"), "Sample size n", 100, 600, 250, 50),
          selectInput(ns("qrp_dgp"), "Data scenario",
            choices = c("Homoscedastic", "Heteroscedastic",
                        "Skewed", "Bimodal"),
            selected = "Heteroscedastic"),
          sliderInput(ns("qrp_x0"), "Evaluate at x = ", -2, 2, 0, 0.25),
          actionButton(ns("qrp_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("The Quantile Process"),
          tags$p("Fitting quantile regression across a fine grid of \u03c4 values (e.g., 0.05 to 0.95)
                  traces out the entire conditional distribution of Y given X = x."),
          tags$p("This 'quantile process' plot reveals:"),
          tags$ul(
            tags$li("The shape of the conditional distribution."),
            tags$li("Whether slopes are constant (parallel) or vary systematically."),
            tags$li("How the location, spread, and shape of the distribution change with X.")
          ),
          tags$p("Comparing the quantile process at different values of x shows directly how
                  the predictor reshapes the outcome distribution, not just its mean."),
          tags$p("When the quantile process plot shows a flat \u03b2(\u03c4) across \u03c4,
                  the predictor shifts the entire distribution by the same amount \u2014
                  equivalent to the OLS result. When \u03b2(\u03c4) increases with \u03c4,
                  the predictor has a stronger effect on higher quantiles than lower ones
                  (the rich get richer effect in economics). When \u03b2(\u03c4) decreases,
                  the predictor compresses the upper tail (a floor/ceiling effect or
                  variance-reducing treatment). Non-monotone patterns suggest more complex
                  heterogeneous effects that OLS completely obscures."),
          tags$p("Formal tests for heterogeneity across quantiles can be performed using
                  the Wald test on the null hypothesis H\u2080: \u03b2(\u03c4\u2081) =
                  \u03b2(\u03c4\u2082) for any pair of quantiles. The quantreg package
                  in R provides the anova() method for this. Rejecting this test is
                  evidence that OLS, which estimates a single average effect, is missing
                  important variation in how the predictor operates across the outcome
                  distribution \u2014 a finding with substantive implications for policy
                  or treatment targeting."),
          guide = tags$ol(
            tags$li("Click 'Simulate'. The plot shows the slope estimate \u03b2(\u03c4) for each \u03c4."),
            tags$li("For homoscedastic data, \u03b2(\u03c4) is approximately flat."),
            tags$li("For heteroscedastic data, \u03b2(\u03c4) rises (or falls) across \u03c4."),
            tags$li("Adjust 'Evaluate at x' to see the conditional quantile distribution at that x.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Quantile Process: Slope \u03b2(\u03c4) across \u03c4"),
               plotlyOutput(ns("qrp_process"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Conditional Distribution at x\u2080"),
                 plotlyOutput(ns("qrp_cond_dist"), height = "250px")),
            card(card_header("All Quantile Lines"),
                 plotlyOutput(ns("qrp_all_lines"), height = "250px"))
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

quantile_reg_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: QR via linear programming (Barrodale-Roberts style via quantreg-free) ─
  # Simple iterative reweighted least squares for quantile regression
  qr_fit <- function(x, y, tau, intercept = TRUE) {
    n <- length(y)
    X <- if (intercept) cbind(1, x) else matrix(x, ncol = 1)
    # Use R's optim with L-BFGS-B for small problems, or rq if available
    check_fn <- function(u, tau) sum(u * (tau - (u < 0)))
    loss <- function(b) check_fn(y - X %*% b, tau)
    b0 <- lm.fit(X, y)$coefficients
    opt <- optim(b0, loss, method = "Nelder-Mead",
                 control = list(maxit = 2000, reltol = 1e-8))
    opt$par
  }

  # ── Tab 1: Basics ──────────────────────────────────────────────────────────
  qr_data <- eventReactive(input$qr_go, {
    set.seed(sample(9999, 1))
    n   <- input$qr_n
    tau <- input$qr_tau
    dgp <- input$qr_dgp

    x <- seq(-2, 2, length.out = n)
    y <- switch(dgp,
      "Homoscedastic (OLS applies)"          = 2 + 1.5 * x + rnorm(n, 0, 1),
      "Heteroscedastic (variance grows with x)" = 2 + 1.5 * x + rnorm(n, 0, 0.3 + 0.6 * (x + 2)),
      "Skewed residuals"                     = 2 + 1.5 * x + rexp(n, 1) - 1,
      "Heavy-tailed (t\u2082 errors)"         = 2 + 1.5 * x + rt(n, df = 2),
      "Threshold variance"                   = 2 + 1.5 * x + rnorm(n, 0, ifelse(x < 0, 0.3, 1.5))
    )

    b_qr   <- qr_fit(x, y, tau)
    b_ols  <- coef(lm(y ~ x))
    b_med  <- if (abs(tau - 0.5) > 0.01) qr_fit(x, y, 0.5) else b_qr

    list(x = x, y = y, b_qr = b_qr, b_ols = b_ols, b_med = b_med,
         tau = tau, dgp = dgp)
  })

  output$qr_fit_plot <- renderPlotly({
    req(qr_data())
    d  <- qr_data()
    xr <- seq(min(d$x), max(d$x), length.out = 200)

    p <- plot_ly() |>
      add_markers(x = d$x, y = d$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.35)", size = 5)) |>
      add_lines(x = xr,
                y = d$b_qr[1] + d$b_qr[2] * xr,
                name = sprintf("QR \u03c4=%.2f", d$tau),
                line = list(color = "#268bd2", width = 2.5))

    if (input$qr_show_ols)
      p <- p |> add_lines(x = xr, y = d$b_ols[1] + d$b_ols[2] * xr,
                           name = "OLS (mean)",
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))

    if (input$qr_show_median && abs(d$tau - 0.5) > 0.01)
      p <- p |> add_lines(x = xr, y = d$b_med[1] + d$b_med[2] * xr,
                           name = "QR \u03c4=0.5 (median)",
                           line = list(color = "#2aa198", dash = "dot", width = 1.5))

    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "y"),
                legend = list(orientation = "h", y = -0.2))
  })

  output$qr_loss_plot <- renderPlotly({
    tau <- input$qr_tau
    u   <- seq(-3, 3, length.out = 300)
    loss_qr  <- u * (tau - as.integer(u < 0))
    loss_ols <- 0.5 * u^2 / max(0.5 * u^2) * max(abs(loss_qr))  # scale for comparison

    plot_ly() |>
      add_lines(x = u, y = loss_qr,
                name = sprintf("Check fn \u03c4=%.2f", tau),
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = u, y = loss_ols,
                name = "OLS (scaled)",
                line = list(color = "#dc322f", dash = "dash")) |>
      add_lines(x = c(0, 0), y = c(min(loss_qr), max(loss_qr)),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Residual u"),
             yaxis = list(title = "Loss"),
             legend = list(orientation = "h"))
  })

  output$qr_coef_table <- renderTable({
    req(qr_data())
    d <- qr_data()
    data.frame(
      Method = c("OLS (mean)", sprintf("QR \u03c4=%.2f", d$tau), "QR \u03c4=0.5 (median)"),
      Intercept = round(c(d$b_ols[1], d$b_qr[1], d$b_med[1]), 4),
      Slope     = round(c(d$b_ols[2], d$b_qr[2], d$b_med[2]), 4)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 2: Heterogeneous Effects ───────────────────────────────────────────
  qrh_data <- eventReactive(input$qrh_go, {
    set.seed(sample(9999, 1))
    n       <- input$qrh_n
    sc      <- input$qrh_scenario
    noise   <- input$qrh_noise
    x       <- runif(n, 0, 4)

    y <- switch(sc,
      "Fan spread (increasing variance)" =
        1 + 0.8 * x + rnorm(n, 0, noise * (0.5 + 0.5 * x)),
      "Location shift only (parallel quantiles)" =
        1 + 1.2 * x + rnorm(n, 0, noise),
      "Scale shift (widening gap)" =
        1 + 0.5 * x + rnorm(n, 0, noise + 0.3 * x),
      "Tail asymmetry" =
        1 + x + rexp(n, 1 / (0.5 + 0.5 * x)) - (0.5 + 0.5 * x)
    )

    taus <- c(0.1, 0.25, 0.5, 0.75, 0.9)
    fits <- lapply(taus, function(tau) qr_fit(x, y, tau))
    list(x = x, y = y, taus = taus, fits = fits, sc = sc)
  })

  output$qrh_plot <- renderPlotly({
    req(qrh_data())
    d   <- qrh_data()
    xr  <- seq(0, 4, length.out = 200)
    pal <- c("#dc322f","#cb4b16","#268bd2","#2aa198","#859900")

    p <- plot_ly() |>
      add_markers(x = d$x, y = d$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.25)", size = 4))
    for (i in seq_along(d$taus)) {
      b  <- d$fits[[i]]
      yp <- b[1] + b[2] * xr
      p  <- p |> add_lines(x = xr, y = yp,
                             name = sprintf("\u03c4=%.2f", d$taus[i]),
                             line = list(color = pal[i], width = 2))
    }
    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "y"),
                legend = list(orientation = "h", y = -0.25))
  })

  output$qrh_slopes <- renderPlotly({
    req(qrh_data())
    d      <- qrh_data()
    slopes <- sapply(d$fits, function(b) b[2])
    b_ols  <- coef(lm(d$y ~ d$x))[2]

    plot_ly() |>
      add_lines(x = d$taus, y = slopes,
                line = list(color = "#268bd2", width = 2)) |>
      add_markers(x = d$taus, y = slopes,
                  marker = list(color = "#268bd2", size = 8)) |>
      add_lines(x = c(0, 1), y = c(b_ols, b_ols),
                name = "OLS slope",
                line = list(color = "#dc322f", dash = "dash")) |>
      layout(xaxis = list(title = "Quantile \u03c4", range = c(0, 1)),
             yaxis = list(title = "Slope \u03b2(\u03c4)"),
             showlegend = FALSE)
  })

  # ── Tab 3: Quantile Process ────────────────────────────────────────────────
  qrp_data <- eventReactive(input$qrp_go, {
    set.seed(sample(9999, 1))
    n   <- input$qrp_n
    dgp <- input$qrp_dgp
    x   <- runif(n, -2, 2)

    y <- switch(dgp,
      "Homoscedastic"   = 1.5 * x + rnorm(n, 0, 1),
      "Heteroscedastic" = 1.5 * x + rnorm(n, 0, 0.4 + 0.5 * abs(x)),
      "Skewed"          = 1.5 * x + rexp(n, 0.8) - 1.25,
      "Bimodal"         = 1.5 * x + ifelse(rbinom(n, 1, 0.5) == 1,
                                            rnorm(n, -1.5, 0.4), rnorm(n, 1.5, 0.4))
    )

    taus_fine <- seq(0.05, 0.95, by = 0.05)
    fits_fine <- lapply(taus_fine, function(tau) qr_fit(x, y, tau))
    slopes     <- sapply(fits_fine, function(b) b[2])
    intercepts <- sapply(fits_fine, function(b) b[1])

    list(x = x, y = y, taus = taus_fine, slopes = slopes,
         intercepts = intercepts, dgp = dgp)
  })

  output$qrp_process <- renderPlotly({
    req(qrp_data())
    d     <- qrp_data()
    b_ols <- coef(lm(d$y ~ d$x))[2]

    plot_ly() |>
      add_lines(x = d$taus, y = d$slopes,
                line = list(color = "#268bd2", width = 2)) |>
      add_markers(x = d$taus, y = d$slopes,
                  marker = list(color = "#268bd2", size = 6)) |>
      add_lines(x = c(0, 1), y = c(b_ols, b_ols),
                name = "OLS slope",
                line = list(color = "#dc322f", dash = "dash")) |>
      layout(xaxis = list(title = "Quantile \u03c4", range = c(0, 1)),
             yaxis = list(title = "Slope \u03b2(\u03c4)"),
             title = list(text = "Quantile process plot", font = list(size = 12)),
             showlegend = FALSE)
  })

  output$qrp_cond_dist <- renderPlotly({
    req(qrp_data())
    d  <- qrp_data()
    x0 <- input$qrp_x0
    # Conditional quantiles at x0
    q_vals <- d$intercepts + d$slopes * x0

    plot_ly(x = d$taus, y = q_vals, type = "scatter", mode = "lines+markers",
            line = list(color = "#2aa198", width = 2),
            marker = list(color = "#2aa198", size = 5),
            hovertemplate = "\u03c4=%{x:.2f}, Q=%{y:.3f}<extra></extra>") |>
      layout(xaxis = list(title = "Quantile \u03c4", range = c(0, 1)),
             yaxis = list(title = sprintf("Conditional quantile at x\u2080 = %.2f", x0)),
             title = list(text = "Conditional CDF (inverse)", font = list(size = 12)))
  })

  output$qrp_all_lines <- renderPlotly({
    req(qrp_data())
    d   <- qrp_data()
    xr  <- seq(min(d$x), max(d$x), length.out = 100)
    pal <- colorRampPalette(c("#268bd2","#b58900","#dc322f"))(length(d$taus))

    p <- plot_ly() |>
      add_markers(x = d$x, y = d$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.2)", size = 3),
                  showlegend = FALSE)
    for (i in seq_along(d$taus)) {
      yp <- d$intercepts[i] + d$slopes[i] * xr
      p  <- p |> add_lines(x = xr, y = yp,
                             line = list(color = pal[i], width = 1),
                             showlegend = FALSE)
    }
    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "y"))
  })
  })
}
