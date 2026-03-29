# Module: Generalized Additive Models (GAMs)
# 4 tabs: Smooth Terms · Basis Functions · GAM vs. Linear · Interactions & Tensor

# ── UI ────────────────────────────────────────────────────────────────────────
gam_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "GAMs",
  icon = icon("wave-square"),
  navset_card_underline(

    # ── Tab 1: Smooth Terms ───────────────────────────────────────────────────
    nav_panel(
      "Smooth Terms",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gam_n"), "Sample size n", 50, 500, 200, 50),
          selectInput(ns("gam_true_fn"), "True relationship f(x)",
            choices = c("Linear", "Quadratic", "Sine wave", "Step + linear",
                        "Strongly nonlinear"),
            selected = "Sine wave"),
          sliderInput(ns("gam_noise"), "Noise \u03c3", 0.1, 3, 0.8, 0.1),
          tags$hr(),
          sliderInput(ns("gam_k"), "Basis dimension k (wiggliness budget)", 3, 20, 10, 1),
          sliderInput(ns("gam_sp"), "Smoothing penalty (log scale)",
                      -4, 4, 0, 0.5),
          actionButton(ns("gam_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("gam_show_truth"), "Show true function", value = TRUE),
          checkboxInput(ns("gam_show_ci"), "Show 95% confidence band", value = TRUE)
        ),
        explanation_box(
          tags$strong("Generalized Additive Models — Smooth Terms"),
          tags$p("A GAM extends a GLM by replacing linear terms with smooth functions:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "g(\u03bc\u1d62) = \u03b1 + f\u2081(x\u2081\u1d62) + f\u2082(x\u2082\u1d62) + ..."),
          tags$p("Each f\u2096 is a ", tags$strong("penalised regression spline"),
                  " — a linear combination of basis functions with an added roughness penalty:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "f(x) = \u03a3 \u03b2\u2c7c B\u2c7c(x)   subject to \u03bb \u222b f''(x)\u00b2 dx being small"),
          tags$p("The smoothing parameter \u03bb controls the bias-variance tradeoff:"),
          tags$ul(
            tags$li(tags$strong("\u03bb \u2192 0"), " — wiggly interpolation; overfitting."),
            tags$li(tags$strong("\u03bb \u2192 \u221e"), " — linear regression; underfitting."),
            tags$li("In practice, \u03bb is selected by GCV (generalised cross-validation) or REML.")
          ),
          guide = tags$ol(
            tags$li("Pick a nonlinear true function and add noise."),
            tags$li("Move the smoothing penalty slider: low penalty = wiggly fit; high = linear."),
            tags$li("Increase k to allow more complex shapes. If k is too small, the spline is underfitted."),
            tags$li("Enable confidence bands to see uncertainty.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Data + GAM Smooth Fit"),
               plotlyOutput(ns("gam_fit_plot"), height = "360px")),
          layout_column_wrap(
            width = 1 / 3,
            card(card_header("Effective Degrees of Freedom"), uiOutput(ns("gam_edf"))),
            card(card_header("GCV / REML Score"), uiOutput(ns("gam_gcv"))),
            card(card_header("Residual SE"), uiOutput(ns("gam_rse")))
          )
        )
      )
    ),

    # ── Tab 2: Basis Functions ─────────────────────────────────────────────────
    nav_panel(
      "Basis Functions",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("gam_basis_type"), "Basis type",
            choices = c("Thin-plate spline", "Cubic regression spline",
                        "B-spline", "Cubic spline (natural)"),
            selected = "Cubic regression spline"),
          sliderInput(ns("gam_basis_k"), "Basis dimension k", 3, 15, 7, 1),
          sliderInput(ns("gam_basis_sp_log"), "Smoothing penalty (log scale)", -4, 4, 0, 0.5),
          actionButton(ns("gam_basis_go"), "Update", icon = icon("refresh"),
                       class = "btn-outline-primary w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Spline Basis Functions"),
          tags$p("A smooth is built from k basis functions. Each basis function B\u2c7c(x) is a
                  simple, local shape. The fitted smooth is a weighted combination:
                  f(x) = \u03a3 \u03b2\u2c7c B\u2c7c(x)."),
          tags$p("Common basis types:"),
          tags$ul(
            tags$li(tags$strong("Cubic regression splines"), " — piecewise cubics joined at knots; widely used."),
            tags$li(tags$strong("Thin-plate splines"), " — radially symmetric; no knot placement needed; default in mgcv."),
            tags$li(tags$strong("B-splines"), " — numerically stable; local support; good for extrapolation."),
            tags$li(tags$strong("Natural cubic splines"), " — cubic splines constrained to be linear beyond the boundary knots.")
          ),
          tags$p("The penalty matrix S is chosen so that \u03b2\u1d40 S \u03b2 measures roughness. The penalised
                  least-squares solution shrinks towards a straight line as \u03bb \u2192 \u221e."),
          guide = tags$ol(
            tags$li("Select a basis type and k. Each coloured curve is one basis function."),
            tags$li("Increase k to add more flexibility. Observe how basis functions tile the x-axis."),
            tags$li("Move the smoothing penalty to see how the weighted combination (black) changes.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Individual Basis Functions"),
               plotlyOutput(ns("gam_basis_indiv"), height = "300px")),
          card(full_screen = TRUE,
               card_header("Weighted Sum (Penalised Smooth)"),
               plotlyOutput(ns("gam_basis_sum"), height = "250px"))
        )
      )
    ),

    # ── Tab 3: GAM vs. Linear ─────────────────────────────────────────────────
    nav_panel(
      "GAM vs. Linear",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gvl_n"), "Sample size n", 50, 500, 150, 50),
          selectInput(ns("gvl_fn"), "True relationship",
            choices = c("Linear", "Quadratic", "Sine wave", "J-shaped",
                        "Threshold effect"),
            selected = "Sine wave"),
          sliderInput(ns("gvl_noise"), "Noise \u03c3", 0.1, 3, 1, 0.1),
          actionButton(ns("gvl_go"), "Simulate & Compare", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("When Does a GAM Beat Linear Regression?"),
          tags$p("Linear regression assumes f(x) = \u03b2x. When the true relationship is nonlinear,
                  linear regression is biased and the residuals show systematic patterns.
                  A GAM can adapt to the shape, reducing bias at the cost of some variance."),
          tags$p("The ANOVA test for linearity compares the penalised smooth to its linear component.
                  A significant p-value suggests the linear model is inadequate. However:"),
          tags$ul(
            tags$li("With small n, GAMs have high variance — linear may still predict better."),
            tags$li("A GAM with a smooth that converges to a line confirms the linear model is adequate."),
            tags$li("AIC/BIC and test-set RMSE are more reliable than p-values for model selection.")
          ),
          guide = tags$ol(
            tags$li("Select a nonlinear true function and click 'Simulate & Compare'."),
            tags$li("The plot overlays the linear (red) and GAM (blue) fits."),
            tags$li("The residual panel shows where the linear model fails."),
            tags$li("Try 'Threshold effect' to see where GAM is most beneficial.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Linear vs. GAM Fit"),
               plotlyOutput(ns("gvl_plot"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Residuals: Linear"),
                 plotlyOutput(ns("gvl_resid_lm"), height = "250px")),
            card(card_header("Residuals: GAM"),
                 plotlyOutput(ns("gvl_resid_gam"), height = "250px"))
          ),
          card(card_header("Model Comparison"),
               tableOutput(ns("gvl_table")))
        )
      )
    ),

    # ── Tab 4: Multiple Smooths ───────────────────────────────────────────────
    nav_panel(
      "Multiple Smooths",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gms_n"), "Sample size n", 100, 600, 300, 50),
          sliderInput(ns("gms_noise"), "Noise \u03c3", 0.1, 2, 0.6, 0.1),
          checkboxInput(ns("gms_interaction"), "Add interaction term (te)", value = FALSE),
          actionButton(ns("gms_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("GAMs with Multiple Smooth Predictors"),
          tags$p("GAMs with multiple predictors model additive contributions:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "y = f\u2081(x\u2081) + f\u2082(x\u2082) + \u03b5"),
          tags$p("The ", tags$strong("additivity"), " assumption means the effect of x\u2081 is the same at
                  every level of x\u2082. If the two variables interact, a ", tags$strong("tensor product smooth"),
                  " te(x\u2081, x\u2082) can capture the joint nonlinear surface, at the cost of more parameters."),
          tags$p("Partial residual plots for each smooth term visualise the marginal contribution
                  of each predictor, holding others constant. The effective degrees of freedom (EDF)
                  per term indicates how nonlinear each effect is — EDF near 1 suggests linearity."),
          tags$p("Concurvity is the GAM analogue of multicollinearity in linear regression:
                  when one smooth term can be well approximated by a combination of the other
                  smooth terms, coefficient estimates become unstable and confidence intervals
                  widen. The concurvity measure (analogous to the variance inflation factor)
                  ranges from 0 to 1; values above 0.8 suggest potential problems. Unlike
                  linear multicollinearity, concurvity is not detectable from pairwise
                  correlations of the raw predictors \u2014 it depends on the nonlinear
                  functions estimated from the data."),
          tags$p("Model selection in GAMs can be performed automatically using the double
                  penalty approach (extra penalty on the null space of each smooth), which
                  allows terms to be shrunk entirely to zero during fitting \u2014 effectively
                  performing variable selection within the GAM. Setting select = TRUE in
                  mgcv achieves this. Alternatively, comparing models with different terms
                  using AIC or approximate p-values from the summary() output provides a
                  more traditional selection workflow."),
          guide = tags$ol(
            tags$li("Simulate data with two smooth predictors."),
            tags$li("Partial effect plots show f\u2081(x\u2081) and f\u2082(x\u2082) separately."),
            tags$li("Enable 'interaction term' to see the difference in fit quality."),
            tags$li("Compare EDFs per term in the model summary.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Partial Effect: f(x\u2081)"),
                 plotlyOutput(ns("gms_p1"), height = "280px")),
            card(full_screen = TRUE,
                 card_header("Partial Effect: f(x\u2082)"),
                 plotlyOutput(ns("gms_p2"), height = "280px"))
          ),
          card(card_header("Model Summary"), uiOutput(ns("gms_summary")))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

gam_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: true function ────────────────────────────────────────────────
  true_fn <- function(x, fn_name) {
    switch(fn_name,
      "Linear"             = 2 * x,
      "Quadratic"          = 3 * x^2 - 2,
      "Sine wave"          = 3 * sin(2 * pi * x),
      "Step + linear"      = ifelse(x < 0, -1.5, 1.5) + x,
      "Strongly nonlinear" = 4 * sin(4 * x) * exp(-0.5 * x^2),
      "J-shaped"           = exp(2 * x) - 2,
      "Threshold effect"   = ifelse(x < 0, -0.5, 2 * x)
    )
  }

  # ── Utility: fit penalised spline (manual, no mgcv) ───────────────────────


  # Penalised least squares via ridge-like penalty on spline coefficients
  pen_spline_fit <- function(x, y, k = 10, log_sp = 0) {
    sp    <- 10^log_sp
    knots <- seq(min(x), max(x), length.out = k)
    B     <- splines::bs(x, knots = knots[-c(1, length(knots))],
                         Boundary.knots = c(min(x), max(x)), degree = 3)
    # Add intercept column
    B2    <- cbind(1, B)
    p     <- ncol(B2)
    # Penalty on non-intercept coefficients (difference penalty)
    D     <- diff(diag(p - 1), differences = 2)
    P     <- sp * t(D) %*% D
    P2    <- rbind(cbind(0, matrix(0, 1, p - 1)),
                   cbind(matrix(0, p - 1, 1), P))
    coefs <- solve(t(B2) %*% B2 + P2, t(B2) %*% y)
    fitted <- as.vector(B2 %*% coefs)
    hat   <- B2 %*% solve(t(B2) %*% B2 + P2) %*% t(B2)
    edf   <- sum(diag(hat))
    resid <- y - fitted
    rse   <- sqrt(sum(resid^2) / (length(y) - edf))
    # GCV
    gcv   <- mean((resid / (1 - diag(hat)))^2)
    # Predict function
    pred_fn <- function(xnew) {
      Bnew <- cbind(1, splines::bs(xnew, knots = knots[-c(1, length(knots))],
                                   Boundary.knots = c(min(x), max(x)), degree = 3))
      as.vector(Bnew %*% coefs)
    }
    # SE of fitted
    se_fit <- sqrt(rowSums((B2 %*% solve(t(B2) %*% B2 + P2))^2) * rse^2)
    list(fitted = fitted, coefs = coefs, edf = edf, rse = rse,
         gcv = gcv, resid = resid, se_fit = se_fit, pred_fn = pred_fn,
         B = B2, k = k, knots = knots)
  }

  # ── Tab 1: Smooth Terms ────────────────────────────────────────────────────
  gam_data <- eventReactive(input$gam_go, {
    set.seed(sample(9999, 1))
    n      <- input$gam_n
    fn     <- input$gam_true_fn
    noise  <- input$gam_noise
    k      <- input$gam_k
    log_sp <- input$gam_sp

    x  <- runif(n, -2, 2)
    fx <- true_fn(x, fn)
    y  <- fx + rnorm(n, 0, noise)
    fit <- pen_spline_fit(x, y, k = k, log_sp = log_sp)
    list(x = x, y = y, fx = fx, fit = fit, fn = fn, k = k, log_sp = log_sp)
  })

  output$gam_fit_plot <- renderPlotly({
    req(gam_data())
    d  <- gam_data()
    f  <- d$fit
    xr <- seq(min(d$x), max(d$x), length.out = 200)
    yp <- f$pred_fn(xr)

    # SE from interpolation of fitted SEs
    se_interp <- approx(d$x[order(d$x)], f$se_fit[order(d$x)], xout = xr,
                        rule = 2)$y

    p <- plot_ly() |>
      add_markers(x = d$x, y = d$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.4)", size = 5)) |>
      add_lines(x = xr, y = yp, name = "GAM smooth",
                line = list(color = "#268bd2", width = 2.5))

    if (input$gam_show_ci) {
      p <- p |>
        add_ribbons(x = xr, ymin = yp - 2 * se_interp,
                    ymax = yp + 2 * se_interp,
                    fillcolor = "rgba(38,139,210,0.15)",
                    line = list(width = 0), name = "95% CI")
    }
    if (input$gam_show_truth) {
      p <- p |>
        add_lines(x = xr, y = true_fn(xr, d$fn), name = "True f(x)",
                  line = list(color = "#859900", dash = "dash", width = 1.5))
    }
    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "y"),
                legend = list(orientation = "h", y = -0.2))
  })

  output$gam_edf <- renderUI({
    req(gam_data())
    tags$div(class = "text-center mt-3",
      tags$h3(sprintf("%.2f", gam_data()$fit$edf),
              style = "color: #268bd2; font-size: 2rem;"),
      tags$p(class = "text-muted", "Effective d.f."),
      tags$p(style = "font-size: 0.82rem;",
        "EDF \u2248 1: nearly linear. Higher EDF = wigglier smooth."))
  })

  output$gam_gcv <- renderUI({
    req(gam_data())
    tags$div(class = "text-center mt-3",
      tags$h3(sprintf("%.4f", gam_data()$fit$gcv),
              style = "color: #2aa198; font-size: 2rem;"),
      tags$p(class = "text-muted", "GCV score"),
      tags$p(style = "font-size: 0.82rem;", "Lower = better cross-validated fit."))
  })

  output$gam_rse <- renderUI({
    req(gam_data())
    tags$div(class = "text-center mt-3",
      tags$h3(sprintf("%.4f", gam_data()$fit$rse),
              style = "color: #cb4b16; font-size: 2rem;"),
      tags$p(class = "text-muted", "Residual SE"),
      tags$p(style = "font-size: 0.82rem;", "Estimated noise \u03c3."))
  })

  # ── Tab 2: Basis Functions ─────────────────────────────────────────────────
  basis_data <- eventReactive(input$gam_basis_go, {
    k       <- input$gam_basis_k
    sp      <- 10^input$gam_basis_sp_log
    btype   <- input$gam_basis_type
    xv      <- seq(-2, 2, length.out = 200)

    # Build basis matrix
    B <- switch(btype,
      "Cubic regression spline" = {
        knots <- seq(-2, 2, length.out = k)
        splines::bs(xv, knots = knots[-c(1, length(knots))],
                    Boundary.knots = c(-2, 2), degree = 3)
      },
      "B-spline" = {
        splines::bs(xv, df = k, degree = 3)
      },
      "Cubic spline (natural)" = {
        splines::ns(xv, df = k)
      },
      "Thin-plate spline" = {
        # Approximate: use natural splines for display
        splines::ns(xv, df = k)
      }
    )

    # Dummy fit: y = sin(2πx) to get meaningful weights
    y    <- sin(2 * pi * xv) + rnorm(200, 0, 0.3)
    B2   <- cbind(1, B)
    p    <- ncol(B2)
    D    <- diff(diag(p - 1), differences = 2)
    P    <- sp * t(D) %*% D
    P2   <- rbind(cbind(0, matrix(0, 1, p - 1)),
                  cbind(matrix(0, p - 1, 1), P))
    coefs <- tryCatch(solve(t(B2) %*% B2 + P2, t(B2) %*% y), error = function(e) rep(0, p))
    fitted <- as.vector(B2 %*% coefs)

    list(xv = xv, B = B, B2 = B2, coefs = coefs, fitted = fitted, k = k)
  })

  output$gam_basis_indiv <- renderPlotly({
    req(basis_data())
    d  <- basis_data()
    B  <- d$B
    p  <- plot_ly()
    pal <- colorRampPalette(c("#268bd2","#2aa198","#b58900","#dc322f","#d33682"))(ncol(B))
    for (j in seq_len(min(ncol(B), 12))) {
      p <- p |> add_lines(x = d$xv, y = B[, j],
                           line = list(color = pal[j], width = 1.5),
                           showlegend = FALSE,
                           hovertemplate = paste0("Basis ", j, ": %{y:.3f}<extra></extra>"))
    }
    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "Basis function value"))
  })

  output$gam_basis_sum <- renderPlotly({
    req(basis_data())
    d <- basis_data()
    plot_ly() |>
      add_lines(x = d$xv, y = sin(2 * pi * d$xv),
                name = "True f(x) = sin(2\u03c0x)",
                line = list(color = "#859900", dash = "dash")) |>
      add_lines(x = d$xv, y = d$fitted,
                name = "Penalised smooth",
                line = list(color = "#073642", width = 2.5)) |>
      layout(xaxis = list(title = "x"),
             yaxis = list(title = "f(x)"),
             legend = list(orientation = "h"))
  })

  # ── Tab 3: GAM vs. Linear ──────────────────────────────────────────────────
  gvl_data <- eventReactive(input$gvl_go, {
    set.seed(sample(9999, 1))
    n     <- input$gvl_n
    fn    <- input$gvl_fn
    noise <- input$gvl_noise

    x  <- runif(n, -2, 2)
    fx <- true_fn(x, fn)
    y  <- fx + rnorm(n, 0, noise)

    fit_lm  <- lm(y ~ x)
    fit_gam <- pen_spline_fit(x, y, k = 10, log_sp = 0)

    r2_lm  <- 1 - sum(residuals(fit_lm)^2) / sum((y - mean(y))^2)
    r2_gam <- 1 - sum(fit_gam$resid^2) / sum((y - mean(y))^2)

    list(x = x, y = y, fx = fx, fn = fn,
         fit_lm = fit_lm, fit_gam = fit_gam,
         r2_lm = r2_lm, r2_gam = r2_gam)
  })

  output$gvl_plot <- renderPlotly({
    req(gvl_data())
    d   <- gvl_data()
    xr  <- seq(min(d$x), max(d$x), length.out = 200)
    ylm <- predict(d$fit_lm, newdata = data.frame(x = xr))
    ygm <- d$fit_gam$pred_fn(xr)

    plot_ly() |>
      add_markers(x = d$x, y = d$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.35)", size = 5)) |>
      add_lines(x = xr, y = true_fn(xr, d$fn), name = "True f(x)",
                line = list(color = "#859900", dash = "dot", width = 1.5)) |>
      add_lines(x = xr, y = ylm, name = "Linear",
                line = list(color = "#dc322f", width = 2)) |>
      add_lines(x = xr, y = ygm, name = "GAM smooth",
                line = list(color = "#268bd2", width = 2)) |>
      layout(xaxis = list(title = "x"), yaxis = list(title = "y"),
             legend = list(orientation = "h", y = -0.2))
  })

  output$gvl_resid_lm <- renderPlotly({
    req(gvl_data())
    d <- gvl_data()
    plot_ly(x = d$x, y = residuals(d$fit_lm), type = "scatter", mode = "markers",
            marker = list(color = "#dc322f", size = 4, opacity = 0.6)) |>
      add_lines(x = c(min(d$x), max(d$x)), y = c(0, 0),
                line = list(color = "grey", dash = "dash")) |>
      layout(xaxis = list(title = "x"), yaxis = list(title = "Residual"))
  })

  output$gvl_resid_gam <- renderPlotly({
    req(gvl_data())
    d <- gvl_data()
    plot_ly(x = d$x, y = d$fit_gam$resid, type = "scatter", mode = "markers",
            marker = list(color = "#268bd2", size = 4, opacity = 0.6)) |>
      add_lines(x = c(min(d$x), max(d$x)), y = c(0, 0),
                line = list(color = "grey", dash = "dash")) |>
      layout(xaxis = list(title = "x"), yaxis = list(title = "Residual"))
  })

  output$gvl_table <- renderTable({
    req(gvl_data())
    d <- gvl_data()
    data.frame(
      Model   = c("Linear regression", "GAM (penalised spline)"),
      R2      = round(c(d$r2_lm, d$r2_gam), 4),
      Resid_SE = round(c(summary(d$fit_lm)$sigma, d$fit_gam$rse), 4),
      EDF     = c(2, round(d$fit_gam$edf, 2))
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 4: Multiple Smooths ────────────────────────────────────────────────
  gms_data <- eventReactive(input$gms_go, {
    set.seed(sample(9999, 1))
    n     <- input$gms_n
    noise <- input$gms_noise

    x1 <- runif(n, -2, 2)
    x2 <- runif(n, -2, 2)
    f1 <- 2 * sin(pi * x1)
    f2 <- x2^2 - 1
    y  <- f1 + f2 + rnorm(n, 0, noise)

    fit1 <- pen_spline_fit(x1, y - f2 + rnorm(n, 0, 0.05), k = 10, log_sp = 0)
    fit2 <- pen_spline_fit(x2, y - f1 + rnorm(n, 0, 0.05), k = 10, log_sp = 0)

    list(x1 = x1, x2 = x2, f1 = f1, f2 = f2, y = y,
         fit1 = fit1, fit2 = fit2, n = n)
  })

  output$gms_p1 <- renderPlotly({
    req(gms_data())
    d  <- gms_data()
    xr <- seq(min(d$x1), max(d$x1), length.out = 200)
    yp <- d$fit1$pred_fn(xr)
    se <- approx(d$x1[order(d$x1)], d$fit1$se_fit[order(d$x1)], xout = xr, rule = 2)$y
    plot_ly() |>
      add_ribbons(x = xr, ymin = yp - 2 * se, ymax = yp + 2 * se,
                  fillcolor = "rgba(38,139,210,0.15)", line = list(width = 0), showlegend = FALSE) |>
      add_lines(x = xr, y = yp, name = "f(x\u2081)", line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = xr, y = 2 * sin(pi * xr), name = "True f\u2081",
                line = list(color = "#859900", dash = "dash")) |>
      layout(xaxis = list(title = "x\u2081"), yaxis = list(title = "f(x\u2081)"),
             legend = list(orientation = "h"))
  })

  output$gms_p2 <- renderPlotly({
    req(gms_data())
    d  <- gms_data()
    xr <- seq(min(d$x2), max(d$x2), length.out = 200)
    yp <- d$fit2$pred_fn(xr)
    se <- approx(d$x2[order(d$x2)], d$fit2$se_fit[order(d$x2)], xout = xr, rule = 2)$y
    plot_ly() |>
      add_ribbons(x = xr, ymin = yp - 2 * se, ymax = yp + 2 * se,
                  fillcolor = "rgba(203,75,22,0.15)", line = list(width = 0), showlegend = FALSE) |>
      add_lines(x = xr, y = yp, name = "f(x\u2082)", line = list(color = "#cb4b16", width = 2)) |>
      add_lines(x = xr, y = xr^2 - 1, name = "True f\u2082",
                line = list(color = "#859900", dash = "dash")) |>
      layout(xaxis = list(title = "x\u2082"), yaxis = list(title = "f(x\u2082)"),
             legend = list(orientation = "h"))
  })

  output$gms_summary <- renderUI({
    req(gms_data())
    d <- gms_data()
    mkrow <- function(l, v) tags$tr(tags$td(l), tags$td(tags$strong(v)))
    tags$div(
      tags$table(class = "table table-sm",
        tags$tbody(
          mkrow("n", d$n),
          mkrow("EDF for f(x\u2081)", sprintf("%.2f", d$fit1$edf)),
          mkrow("EDF for f(x\u2082)", sprintf("%.2f", d$fit2$edf)),
          mkrow("RSE for x\u2081 model", sprintf("%.3f", d$fit1$rse)),
          mkrow("RSE for x\u2082 model", sprintf("%.3f", d$fit2$rse))
        )
      ),
      tags$p(class = "text-muted", style = "font-size: 0.85rem;",
        "Note: partial models shown. A full additive GAM would fit both terms jointly.")
    )
  })
  })
}
