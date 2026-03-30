# ===========================================================================
# Module: Time Series
# Autocorrelation, stationarity, decomposition, ARIMA, and forecasting
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
time_series_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Time Series",
  icon = icon("chart-line"),
  navset_card_tab(
    id = ns("ts_tabs"),

    # ── Tab 1: Autocorrelation & Stationarity ──────────────────────────
    nav_panel("Autocorrelation & Stationarity", icon = icon("wave-square"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Time Series Generator",
          tags$p(class = "text-muted small mb-2",
            "Generate different types of time series and examine their
             autocorrelation structure and stationarity."),
          selectInput(ns("ts_acf_type"), "Process Type",
            choices = c(
              "White noise"          = "white_noise",
              "Random walk"          = "random_walk",
              "AR(1)"               = "ar1",
              "AR(2)"               = "ar2",
              "MA(1)"               = "ma1",
              "Trend + noise"       = "trend",
              "Seasonal"            = "seasonal",
              "Trend + seasonal"    = "trend_seasonal"
            ),
            selected = "ar1"),
          sliderInput(ns("ts_acf_n"), "Series length", 100, 2000, 500, step = 100),
          conditionalPanel(ns = ns, 
            condition = "input.ts_acf_type == 'ar1'",
            sliderInput(ns("ts_acf_phi1"), "AR(1) coefficient (\u03c6\u2081)",
                        -0.95, 0.95, 0.7, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_acf_type == 'ar2'",
            sliderInput(ns("ts_acf_phi1_ar2"), "\u03c6\u2081", -1, 1, 0.5, step = 0.05),
            sliderInput(ns("ts_acf_phi2_ar2"), "\u03c6\u2082", -1, 1, -0.3, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_acf_type == 'ma1'",
            sliderInput(ns("ts_acf_theta"), "MA(1) coefficient (\u03b8\u2081)",
                        -0.95, 0.95, 0.6, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_acf_type == 'seasonal' || input.ts_acf_type == 'trend_seasonal'",
            sliderInput(ns("ts_acf_period"), "Seasonal period", 4, 52, 12, step = 1),
            sliderInput(ns("ts_acf_seas_amp"), "Seasonal amplitude", 0.5, 5, 2, step = 0.25)
          ),
          actionButton(ns("ts_acf_run"), "Generate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Autocorrelation & Stationarity"),
          tags$p(tags$strong("Autocorrelation"), " measures the correlation of
                  a time series with its own lagged values. It tells us how
                  much the current value depends on past values."),
          tags$ul(
            tags$li(tags$strong("ACF (Autocorrelation Function):"),
              " Correlation between Y\u209C and Y\u209C\u208B\u2096 for each lag k.
                Includes both direct and indirect effects."),
            tags$li(tags$strong("PACF (Partial Autocorrelation):"),
              " Correlation between Y\u209C and Y\u209C\u208B\u2096 after removing
                the linear effect of intermediate lags. Helps identify the
                order of AR processes.")
          ),
          tags$p(tags$strong("Stationarity"), " means the statistical properties
                  (mean, variance, autocorrelation) do not change over time.
                  Most time series models require stationarity."),
          tags$ul(
            tags$li(tags$strong("White noise:"), " Stationary. No autocorrelation at any lag."),
            tags$li(tags$strong("AR(1):"), " Stationary if |\u03c6| < 1. ACF decays exponentially; PACF cuts off after lag 1."),
            tags$li(tags$strong("MA(1):"), " Always stationary. ACF cuts off after lag 1; PACF decays."),
            tags$li(tags$strong("Random walk:"), " Non-stationary. Variance grows with time. Requires differencing."),
            tags$li(tags$strong("Trend:"), " Non-stationary in mean. Differencing or detrending needed."),
            tags$li(tags$strong("Seasonal:"), " May need seasonal differencing.")
          ),
          tags$p("The ", tags$strong("Augmented Dickey-Fuller (ADF) test"),
            " formally tests for stationarity. H\u2080: unit root exists
              (non-stationary). Small p-value \u2192 evidence of stationarity.")
        ),

        card(
          card_header("Time Series Plot"),
          plotOutput(ns("ts_acf_series_plot"), height = "280px")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("ACF"),
            plotOutput(ns("ts_acf_acf_plot"), height = "260px")
          ),
          card(
            card_header("PACF"),
            plotOutput(ns("ts_acf_pacf_plot"), height = "260px")
          )
        ),

        card(
          card_header("Stationarity Assessment"),
          uiOutput(ns("ts_acf_stationarity"))
        )
      )
    ),

    # ── Tab 2: Decomposition ───────────────────────────────────────────
    nav_panel("Decomposition", icon = icon("layer-group"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Decomposition Setup",
          tags$p(class = "text-muted small mb-2",
            "Build a time series from trend, seasonal, and random components,
             then decompose it to recover them."),
          sliderInput(ns("ts_dec_n"), "Number of periods", 48, 480, 120, step = 12),
          sliderInput(ns("ts_dec_freq"), "Seasonal frequency", 4, 52, 12, step = 1),
          helpText(class = "small text-muted", "12 = monthly, 4 = quarterly, 52 = weekly"),
          selectInput(ns("ts_dec_trend_type"), "Trend shape",
            choices = c("Linear" = "linear", "Quadratic" = "quadratic",
                        "None" = "none"),
            selected = "linear"),
          sliderInput(ns("ts_dec_trend_str"), "Trend strength", 0, 0.5, 0.1, step = 0.02),
          sliderInput(ns("ts_dec_seas_amp"), "Seasonal amplitude", 0, 5, 2, step = 0.25),
          sliderInput(ns("ts_dec_noise"), "Noise level", 0.5, 5, 1, step = 0.25),
          selectInput(ns("ts_dec_method"), "Decomposition type",
            choices = c("Additive (STL)" = "additive",
                        "Multiplicative (classical)" = "multiplicative"),
            selected = "additive"),
          actionButton(ns("ts_dec_run"), "Generate & Decompose", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Time Series Decomposition"),
          tags$p("Decomposition separates a time series into interpretable
                  components:"),
          tags$ul(
            tags$li(tags$strong("Trend (T):"), " Long-term increase or decrease."),
            tags$li(tags$strong("Seasonal (S):"), " Regular, repeating pattern with fixed period."),
            tags$li(tags$strong("Remainder (R):"), " What's left after removing trend and seasonality.")
          ),
          tags$p("Two common models:"),
          tags$ul(
            tags$li(tags$strong("Additive:"), " Y\u209C = T\u209C + S\u209C + R\u209C. Use when
              seasonal variation is roughly constant over time."),
            tags$li(tags$strong("Multiplicative:"), " Y\u209C = T\u209C \u00d7 S\u209C \u00d7 R\u209C.
              Use when seasonal variation scales with the level of the series.")
          ),
          tags$p(tags$strong("STL (Seasonal-Trend decomposition using LOESS)"),
            " is the preferred modern method. It handles additive decomposition
              with flexible, data-driven smoothing for trend and season.
              Classical decomposition uses simpler moving-average methods.")
        ),

        card(
          card_header("Original Series"),
          plotOutput(ns("ts_dec_original_plot"), height = "220px")
        ),

        card(
          card_header("Decomposition Components"),
          plotOutput(ns("ts_dec_components_plot"), height = "420px")
        ),

        card(
          card_header("Component Strength"),
          uiOutput(ns("ts_dec_strength"))
        )
      )
    ),

    # ── Tab 3: ARIMA Modeling ──────────────────────────────────────────
    nav_panel("ARIMA Modeling", icon = icon("gears"),
      layout_sidebar(
        sidebar = sidebar(
          title = "ARIMA Specification",
          tags$p(class = "text-muted small mb-2",
            "Simulate an ARIMA process with known parameters, then fit
             a model and compare estimated vs. true values."),
          tags$h6("True DGP Parameters"),
          sliderInput(ns("ts_arima_p"), "AR order (p)", 0, 3, 1, step = 1),
          sliderInput(ns("ts_arima_d"), "Differencing order (d)", 0, 2, 0, step = 1),
          sliderInput(ns("ts_arima_q"), "MA order (q)", 0, 3, 1, step = 1),
          sliderInput(ns("ts_arima_n"), "Series length", 100, 2000, 300, step = 100),
          conditionalPanel(ns = ns, 
            condition = "input.ts_arima_p >= 1",
            sliderInput(ns("ts_arima_ar1"), "AR\u2081 coefficient", -0.95, 0.95, 0.6, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_arima_p >= 2",
            sliderInput(ns("ts_arima_ar2"), "AR\u2082 coefficient", -0.95, 0.95, -0.2, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_arima_q >= 1",
            sliderInput(ns("ts_arima_ma1"), "MA\u2081 coefficient", -0.95, 0.95, 0.4, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            condition = "input.ts_arima_q >= 2",
            sliderInput(ns("ts_arima_ma2"), "MA\u2082 coefficient", -0.95, 0.95, -0.2, step = 0.05)
          ),
          actionButton(ns("ts_arima_run"), "Simulate & Fit", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("ARIMA(p, d, q) Models"),
          tags$p("ARIMA combines three components:"),
          tags$ul(
            tags$li(tags$strong("AR(p) \u2014 Autoregressive:"),
              " Current value depends on p past values.
                Y\u209C = \u03c6\u2081Y\u209C\u208B\u2081 + \u2026 + \u03c6\u209aY\u209C\u208B\u209a + \u03b5\u209C"),
            tags$li(tags$strong("I(d) \u2014 Integrated:"),
              " The series is differenced d times to achieve stationarity.
                d = 1 means we model the first differences."),
            tags$li(tags$strong("MA(q) \u2014 Moving Average:"),
              " Current value depends on q past forecast errors.
                Y\u209C = \u03b5\u209C + \u03b8\u2081\u03b5\u209C\u208B\u2081 + \u2026 + \u03b8\u2099\u03b5\u209C\u208B\u2099")
          ),
          tags$p(tags$strong("Identifying the order:")),
          tags$ul(
            tags$li("AR(p): ACF tails off, PACF cuts off after lag p."),
            tags$li("MA(q): ACF cuts off after lag q, PACF tails off."),
            tags$li("ARMA(p,q): Both ACF and PACF tail off."),
            tags$li("AIC / BIC can be used for automatic order selection.")
          ),
          tags$p("The ", tags$code("auto.arima()"),
            " function from the forecast package searches over (p,d,q) to
              minimise AIC. Here we let you set the true parameters, then
              see if the fitting procedure recovers them.")
        ),

        card(
          card_header("Simulated Series & Fitted Values"),
          plotOutput(ns("ts_arima_series_plot"), height = "280px")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("True vs. Estimated Parameters"),
            uiOutput(ns("ts_arima_params"))
          ),
          card(
            card_header("Residual Diagnostics"),
            plotOutput(ns("ts_arima_resid_plot"), height = "300px")
          )
        ),

        card(
          card_header("Model Selection (AIC Comparison)"),
          uiOutput(ns("ts_arima_aic"))
        )
      )
    ),

    # ── Tab 4: Forecasting ─────────────────────────────────────────────
    nav_panel("Forecasting", icon = icon("forward"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Forecast Setup",
          tags$p(class = "text-muted small mb-2",
            "Generate a series, hold out the last portion, forecast it,
             and evaluate accuracy."),
          selectInput(ns("ts_fc_series"), "Series Type",
            choices = c(
              "AR(1) + trend"       = "ar_trend",
              "Seasonal (additive)" = "seasonal",
              "Random walk + drift" = "rw_drift",
              "Nonlinear (regime switching)" = "nonlinear"
            ),
            selected = "seasonal"),
          sliderInput(ns("ts_fc_n"), "Total length", 100, 500, 200, step = 50),
          sliderInput(ns("ts_fc_horizon"), "Forecast horizon", 5, 50, 20, step = 5),
          sliderInput(ns("ts_fc_noise"), "Noise level", 0.5, 3, 1, step = 0.25),
          actionButton(ns("ts_fc_run"), "Generate & Forecast", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Forecasting & Evaluation"),
          tags$p("Forecasting extends a fitted time series model into the
                  future. The quality of a forecast depends on model fit, data quality,
                  and how far ahead the prediction extends. All forecasts carry
                  uncertainty, which generally increases with the forecast horizon.
                  Reliable forecasting requires both a well-specified model and honest
                  evaluation against held-out data."),
          tags$ul(
            tags$li(tags$strong("Train/test split:"), " Hold out the last h
              observations as a test set. Fit the model only on the training
              portion, then forecast h steps ahead."),
            tags$li(tags$strong("Prediction intervals:"), " Uncertainty grows
              with the forecast horizon. Intervals should widen over time.
              Narrow intervals far into the future are a warning sign of overconfidence."),
            tags$li(tags$strong("Forecast accuracy metrics:")),
            tags$ul(
              tags$li(tags$strong("MAE"), " (Mean Absolute Error): Average absolute forecast error. Same scale as Y."),
              tags$li(tags$strong("RMSE"), " (Root Mean Squared Error): Penalises large errors more than MAE."),
              tags$li(tags$strong("MAPE"), " (Mean Absolute Percentage Error): Scale-free, but undefined when Y = 0.")
            ),
            tags$li("Simple benchmarks (naive forecast = last observed value;
              seasonal naive = value from one season ago) should always be
              compared against more complex models.")
          ),
          tags$p("A model that cannot beat a naive benchmark is not adding value.
                  In practice, many sophisticated models fail to outperform simple
                  benchmarks, especially for short horizons or highly volatile series.
                  Always start with a baseline comparison before investing in complexity."),
          tags$p("Cross-validation for time series differs from standard cross-validation.
                  Because observations are ordered in time, you must use expanding-window
                  or rolling-window schemes that respect temporal order. Randomly shuffling
                  observations would introduce future information into the training set,
                  producing misleadingly optimistic accuracy estimates.")
        ),

        card(
          card_header("Forecast Plot"),
          plotOutput(ns("ts_fc_plot"), height = "350px")
        ),

        card(
          card_header("Forecast Accuracy"),
          uiOutput(ns("ts_fc_accuracy"))
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

time_series_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 1 — Autocorrelation & Stationarity
  # ═══════════════════════════════════════════════════════════════════════

  ts_acf_data <- eventReactive(input$ts_acf_run, {
    n    <- input$ts_acf_n
    type <- input$ts_acf_type

    set.seed(sample.int(10000, 1))
    e <- rnorm(n)

    y <- switch(type,
      "white_noise" = e,
      "random_walk" = cumsum(e),
      "ar1" = {
        phi <- input$ts_acf_phi1
        x <- numeric(n); x[1] <- e[1]
        for (t in 2:n) x[t] <- phi * x[t-1] + e[t]
        x
      },
      "ar2" = {
        phi1 <- input$ts_acf_phi1_ar2
        phi2 <- input$ts_acf_phi2_ar2
        x <- numeric(n); x[1] <- e[1]; x[2] <- phi1*x[1] + e[2]
        for (t in 3:n) x[t] <- phi1*x[t-1] + phi2*x[t-2] + e[t]
        x
      },
      "ma1" = {
        theta <- input$ts_acf_theta
        x <- numeric(n); x[1] <- e[1]
        for (t in 2:n) x[t] <- e[t] + theta * e[t-1]
        x
      },
      "trend" = 0.05 * (1:n) + e,
      "seasonal" = {
        p <- input$ts_acf_period
        a <- input$ts_acf_seas_amp
        a * sin(2 * pi * (1:n) / p) + e
      },
      "trend_seasonal" = {
        p <- input$ts_acf_period
        a <- input$ts_acf_seas_amp
        0.03 * (1:n) + a * sin(2 * pi * (1:n) / p) + e
      }
    )

    # ADF test (manual Dickey-Fuller regression to avoid tseries dependency)
    adf_p <- tryCatch({
      n_y <- length(y)
      dy  <- diff(y)
      y_lag <- y[-n_y]
      tt  <- seq_along(dy)
      fit <- lm(dy ~ y_lag + tt)
      coefs <- summary(fit)$coefficients
      t_stat <- coefs["y_lag", "t value"]
      # MacKinnon approximate p-value for ADF (tau3, with trend)
      # Using interpolation of critical values for large n
      if (t_stat < -3.96) 0.01 else if (t_stat < -3.41) 0.05
      else if (t_stat < -3.13) 0.10 else 0.50
    }, error = function(e) NA)

    list(y = y, type = type, n = n, adf_p = adf_p)
  })

  output$ts_acf_series_plot <- renderPlot(bg = "transparent", {
    req(ts_acf_data())
    d <- ts_acf_data()
    df <- data.frame(t = seq_along(d$y), y = d$y)
    ggplot(df, aes(t, y)) +
      geom_line(color = "#268bd2", linewidth = 0.4) +
      labs(x = "Time", y = "Value", title = paste("Series:", input$ts_acf_type))
  })

  output$ts_acf_acf_plot <- renderPlot(bg = "transparent", {
    req(ts_acf_data())
    a <- acf(ts_acf_data()$y, plot = FALSE)
    ci <- qnorm(0.975) / sqrt(ts_acf_data()$n)
    df_acf <- data.frame(lag = as.numeric(a$lag), acf = as.numeric(a$acf))
    ggplot(df_acf, aes(x = lag, y = acf)) +
      geom_hline(yintercept = 0, color = "grey50") +
      geom_hline(yintercept = c(-ci, ci), linetype = "dashed", color = "#2aa198") +
      geom_segment(aes(xend = lag, yend = 0), color = "#268bd2", linewidth = 0.8) +
      labs(title = "ACF", x = "Lag", y = "Autocorrelation")
  })

  output$ts_acf_pacf_plot <- renderPlot(bg = "transparent", {
    req(ts_acf_data())
    p <- pacf(ts_acf_data()$y, plot = FALSE)
    ci <- qnorm(0.975) / sqrt(ts_acf_data()$n)
    df_pacf <- data.frame(lag = as.numeric(p$lag), pacf = as.numeric(p$acf))
    ggplot(df_pacf, aes(x = lag, y = pacf)) +
      geom_hline(yintercept = 0, color = "grey50") +
      geom_hline(yintercept = c(-ci, ci), linetype = "dashed", color = "#2aa198") +
      geom_segment(aes(xend = lag, yend = 0), color = "#dc322f", linewidth = 0.8) +
      labs(title = "PACF", x = "Lag", y = "Partial Autocorrelation")
  })

  output$ts_acf_stationarity <- renderUI({
    req(ts_acf_data())
    d <- ts_acf_data()

    stationary_types <- c("white_noise", "ar1", "ar2", "ma1")
    is_stat <- d$type %in% stationary_types

    adf_txt <- if (!is.na(d$adf_p)) {
      sprintf("%.4f", d$adf_p)
    } else "N/A"

    adf_verdict <- if (!is.na(d$adf_p) && d$adf_p < 0.05) {
      '<span style="color: #2aa198; font-weight: 600;">Reject H\u2080 \u2192 evidence of stationarity</span>'
    } else {
      '<span style="color: #dc322f; font-weight: 600;">Fail to reject H\u2080 \u2192 likely non-stationary</span>'
    }

    note <- switch(d$type,
      "white_noise" = "White noise is stationary by definition: no autocorrelation at any lag.",
      "random_walk" = "A random walk is non-stationary \u2014 variance grows linearly with time. First differencing produces white noise.",
      "ar1" = sprintf("AR(1) is stationary when |\u03c6| < 1. ACF decays exponentially from \u03c6\u00b9; PACF cuts off after lag 1."),
      "ar2" = "AR(2) is stationary when roots of the characteristic polynomial lie outside the unit circle. PACF cuts off after lag 2.",
      "ma1" = "MA(1) is always stationary. ACF has one non-zero spike at lag 1; PACF decays.",
      "trend" = "A deterministic trend makes the series non-stationary in mean. Detrending or differencing can fix this.",
      "seasonal" = "Seasonal patterns create periodic spikes in the ACF at multiples of the seasonal period.",
      "trend_seasonal" = "Both trend and seasonality are present. Seasonal differencing + first differencing may be needed."
    )

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 500px;">
          <tr><td><strong>Process type</strong></td><td>%s</td></tr>
          <tr><td><strong>Theoretically stationary?</strong></td>
              <td>%s</td></tr>
          <tr><td><strong>ADF test p-value</strong></td>
              <td>%s</td></tr>
          <tr><td><strong>ADF conclusion</strong></td>
              <td>%s</td></tr>
        </table>
        <p class="text-muted small mb-0">%s</p>
      </div>',
      d$type,
      if (is_stat) '<span style="color:#2aa198;">Yes</span>' else '<span style="color:#dc322f;">No</span>',
      adf_txt, adf_verdict, note
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 2 — Decomposition
  # ═══════════════════════════════════════════════════════════════════════

  ts_dec_data <- eventReactive(input$ts_dec_run, {
    n      <- input$ts_dec_n
    freq   <- input$ts_dec_freq
    t_type <- input$ts_dec_trend_type
    t_str  <- input$ts_dec_trend_str
    s_amp  <- input$ts_dec_seas_amp
    noise  <- input$ts_dec_noise
    method <- input$ts_dec_method

    set.seed(sample.int(10000, 1))

    t_idx <- 1:n

    # Trend component
    trend <- switch(t_type,
      "none"      = rep(0, n),
      "linear"    = t_str * t_idx,
      "quadratic" = t_str * (t_idx / n)^2 * n
    )

    # Seasonal component
    seasonal <- s_amp * sin(2 * pi * t_idx / freq)

    # Random component
    remainder <- rnorm(n, sd = noise)

    if (method == "additive") {
      y <- 10 + trend + seasonal + remainder
    } else {
      # Multiplicative: ensure positive base
      base <- 10 + trend
      y <- base * (1 + seasonal / 10) * exp(remainder / 10)
    }

    y_ts <- ts(y, frequency = freq)

    # Decompose
    if (method == "additive" && n >= 2 * freq) {
      dec <- stl(y_ts, s.window = "periodic")
    } else if (n >= 2 * freq) {
      dec <- decompose(y_ts, type = "multiplicative")
    } else {
      dec <- NULL
    }

    list(y_ts = y_ts, dec = dec, method = method, freq = freq,
         true_trend = trend, true_seasonal = seasonal,
         true_remainder = remainder)
  })

  output$ts_dec_original_plot <- renderPlot(bg = "transparent", {
    req(ts_dec_data())
    d <- ts_dec_data()
    df <- data.frame(t = seq_along(d$y_ts), y = as.numeric(d$y_ts))
    ggplot(df, aes(t, y)) +
      geom_line(color = "#268bd2", linewidth = 0.4) +
      labs(x = "Time", y = "Value",
           title = sprintf("Original Series (freq = %d, %s)",
                           d$freq, d$method))
  })

  output$ts_dec_components_plot <- renderPlot(bg = "transparent", {
    req(ts_dec_data())
    d <- ts_dec_data()
    req(!is.null(d$dec))

    if (inherits(d$dec, "stl")) {
      # STL decomposition
      comps <- d$dec$time.series
      trend_est <- comps[, "trend"]
      seas_est  <- comps[, "seasonal"]
      rem_est   <- comps[, "remainder"]
    } else {
      trend_est <- d$dec$trend
      seas_est  <- d$dec$seasonal
      rem_est   <- d$dec$random
    }

    n <- length(d$y_ts)
    plot_df <- data.frame(
      t = rep(1:n, 4),
      value = c(as.numeric(d$y_ts), as.numeric(trend_est),
                as.numeric(seas_est), as.numeric(rem_est)),
      Component = factor(rep(c("Observed", "Trend", "Seasonal", "Remainder"),
                             each = n),
                         levels = c("Observed", "Trend", "Seasonal", "Remainder"))
    )

    ggplot(plot_df, aes(t, value)) +
      geom_line(color = "#268bd2", linewidth = 0.35) +
      facet_wrap(~ Component, ncol = 1, scales = "free_y") +
      labs(x = "Time", y = NULL, title = "Decomposition Components")
  })

  output$ts_dec_strength <- renderUI({
    req(ts_dec_data())
    d <- ts_dec_data()
    req(!is.null(d$dec))

    if (inherits(d$dec, "stl")) {
      comps <- d$dec$time.series
      rem <- comps[, "remainder"]
      trend_str <- max(0, 1 - var(rem) / var(comps[, "trend"] + rem))
      seas_str  <- max(0, 1 - var(rem) / var(comps[, "seasonal"] + rem))
    } else {
      rem <- as.numeric(na.omit(d$dec$random))
      tr  <- as.numeric(na.omit(d$dec$trend))
      se  <- as.numeric(na.omit(d$dec$seasonal))
      n_min <- min(length(rem), length(tr), length(se))
      rem <- rem[1:n_min]; tr <- tr[1:n_min]; se <- se[1:n_min]
      trend_str <- max(0, 1 - var(rem) / var(tr + rem))
      seas_str  <- max(0, 1 - var(rem) / var(se + rem))
    }

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 400px;">
          <tr><td><strong>Trend strength</strong></td>
              <td>%.3f</td>
              <td class="text-muted small">%s</td></tr>
          <tr><td><strong>Seasonal strength</strong></td>
              <td>%.3f</td>
              <td class="text-muted small">%s</td></tr>
        </table>
        <p class="text-muted small mb-0">
          Strength ranges from 0 (no component) to 1 (dominant component).
          Calculated as 1 \u2212 Var(remainder) / Var(component + remainder).
        </p>
      </div>',
      trend_str,
      if (trend_str > 0.6) "Strong" else if (trend_str > 0.3) "Moderate" else "Weak",
      seas_str,
      if (seas_str > 0.6) "Strong" else if (seas_str > 0.3) "Moderate" else "Weak"
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 3 — ARIMA Modeling
  # ═══════════════════════════════════════════════════════════════════════

  ts_arima_data <- eventReactive(input$ts_arima_run, {
    n <- input$ts_arima_n
    p <- input$ts_arima_p
    d <- input$ts_arima_d
    q <- input$ts_arima_q

    # Collect true AR coefficients
    ar_true <- numeric(0)
    if (p >= 1) ar_true <- c(ar_true, input$ts_arima_ar1)
    if (p >= 2) ar_true <- c(ar_true, input$ts_arima_ar2)
    if (p >= 3) ar_true <- c(ar_true, 0.1)

    # Collect true MA coefficients
    ma_true <- numeric(0)
    if (q >= 1) ma_true <- c(ma_true, input$ts_arima_ma1)
    if (q >= 2) ma_true <- c(ma_true, input$ts_arima_ma2)
    if (q >= 3) ma_true <- c(ma_true, 0.1)

    set.seed(sample.int(10000, 1))

    # Simulate ARMA part
    model_spec <- list(order = c(p, 0, q))
    if (p > 0) model_spec$ar <- ar_true
    if (q > 0) model_spec$ma <- ma_true

    y <- tryCatch({
      sim <- arima.sim(n = n, model = model_spec)
      # Apply differencing (integration)
      if (d > 0) {
        for (i in 1:d) sim <- cumsum(sim)
      }
      as.numeric(sim)
    }, error = function(e) rnorm(n))

    y_ts <- ts(y)

    # Fit with known order
    fit_known <- tryCatch(
      arima(y_ts, order = c(p, d, q)),
      error = function(e) NULL
    )

    # Auto ARIMA
    fit_auto <- tryCatch(
      forecast::auto.arima(y_ts, max.p = 5, max.q = 5, max.d = 2,
                           stepwise = TRUE, approximation = FALSE),
      error = function(e) NULL
    )

    list(y_ts = y_ts, p = p, d = d, q = q, n = n,
         ar_true = ar_true, ma_true = ma_true,
         fit_known = fit_known, fit_auto = fit_auto)
  })

  output$ts_arima_series_plot <- renderPlot(bg = "transparent", {
    req(ts_arima_data())
    dat <- ts_arima_data()
    df <- data.frame(t = seq_along(dat$y_ts), y = as.numeric(dat$y_ts))

    p <- ggplot(df, aes(t, y)) +
      geom_line(color = "#268bd2", linewidth = 0.4) +
      labs(x = "Time", y = "Value",
           title = sprintf("Simulated ARIMA(%d,%d,%d)", dat$p, dat$d, dat$q))

    if (!is.null(dat$fit_known)) {
      df$fitted <- as.numeric(dat$y_ts) - as.numeric(residuals(dat$fit_known))
      p <- p + geom_line(data = df, aes(t, fitted),
                         color = "#dc322f", linewidth = 0.4, alpha = 0.7)
    }
    p
  })

  output$ts_arima_params <- renderUI({
    req(ts_arima_data())
    dat <- ts_arima_data()

    rows <- ""

    # AR parameters
    if (dat$p > 0 && !is.null(dat$fit_known)) {
      est_ar <- coef(dat$fit_known)[paste0("ar", 1:dat$p)]
      for (i in seq_along(dat$ar_true)) {
        bias <- est_ar[i] - dat$ar_true[i]
        bc <- if (abs(bias) > 0.1) "#dc322f" else "#2aa198"
        rows <- paste0(rows, sprintf(
          '<tr><td>AR%d (\u03c6%d)</td><td>%.3f</td><td>%.3f</td>
           <td style="color:%s;">%.3f</td></tr>',
          i, i, dat$ar_true[i], est_ar[i], bc, bias
        ))
      }
    }

    # MA parameters
    if (dat$q > 0 && !is.null(dat$fit_known)) {
      est_ma <- coef(dat$fit_known)[paste0("ma", 1:dat$q)]
      for (i in seq_along(dat$ma_true)) {
        bias <- est_ma[i] - dat$ma_true[i]
        bc <- if (abs(bias) > 0.1) "#dc322f" else "#2aa198"
        rows <- paste0(rows, sprintf(
          '<tr><td>MA%d (\u03b8%d)</td><td>%.3f</td><td>%.3f</td>
           <td style="color:%s;">%.3f</td></tr>',
          i, i, dat$ma_true[i], est_ma[i], bc, bias
        ))
      }
    }

    if (nchar(rows) == 0) {
      rows <- '<tr><td colspan="4" class="text-muted">No AR/MA parameters to compare (pure differencing or fit failed).</td></tr>'
    }

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Parameter</th><th>True</th><th>Estimated</th><th>Bias</th></tr></thead>
          <tbody>%s</tbody>
        </table>
      </div>', rows))
  })

  output$ts_arima_resid_plot <- renderPlot(bg = "transparent", {
    req(ts_arima_data())
    dat <- ts_arima_data()
    req(!is.null(dat$fit_known))

    r <- as.numeric(residuals(dat$fit_known))
    n_r <- length(r)

    # Residuals over time
    p1 <- ggplot(data.frame(t = seq_along(r), r = r), aes(t, r)) +
      geom_line(color = "#268bd2", linewidth = 0.4) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
      labs(title = "Residuals over Time", x = "Time", y = "Residual")

    # Residual ACF
    a <- acf(r, plot = FALSE)
    ci <- qnorm(0.975) / sqrt(n_r)
    df_acf <- data.frame(lag = as.numeric(a$lag), acf = as.numeric(a$acf))
    p2 <- ggplot(df_acf, aes(x = lag, y = acf)) +
      geom_hline(yintercept = 0, color = "grey50") +
      geom_hline(yintercept = c(-ci, ci), linetype = "dashed", color = "#2aa198") +
      geom_segment(aes(xend = lag, yend = 0), color = "#dc322f", linewidth = 0.8) +
      labs(title = "Residual ACF", x = "Lag", y = "Autocorrelation")

    gridExtra::grid.arrange(p1, p2, ncol = 1)
  })

  output$ts_arima_aic <- renderUI({
    req(ts_arima_data())
    dat <- ts_arima_data()

    rows <- ""
    if (!is.null(dat$fit_known)) {
      aic_k <- AIC(dat$fit_known)
      bic_k <- BIC(dat$fit_known)
      rows <- paste0(rows, sprintf(
        '<tr style="background-color: rgba(42,161,152,0.08);">
         <td>Specified ARIMA(%d,%d,%d)</td><td>%.1f</td><td>%.1f</td></tr>',
        dat$p, dat$d, dat$q, aic_k, bic_k
      ))
    }

    if (!is.null(dat$fit_auto)) {
      ord <- dat$fit_auto$arma
      aic_a <- AIC(dat$fit_auto)
      bic_a <- BIC(dat$fit_auto)
      rows <- paste0(rows, sprintf(
        '<tr><td>auto.arima \u2192 ARIMA(%d,%d,%d)</td><td>%.1f</td><td>%.1f</td></tr>',
        ord[1], ord[6], ord[2], aic_a, bic_a
      ))
    }

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Model</th><th>AIC</th><th>BIC</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="text-muted small mb-0">Lower AIC/BIC = better fit (penalising complexity).</p>
      </div>', rows))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 4 — Forecasting
  # ═══════════════════════════════════════════════════════════════════════

  ts_fc_data <- eventReactive(input$ts_fc_run, {
    n       <- input$ts_fc_n
    h       <- input$ts_fc_horizon
    noise   <- input$ts_fc_noise
    s_type  <- input$ts_fc_series

    set.seed(sample.int(10000, 1))
    e <- rnorm(n, sd = noise)

    y <- switch(s_type,
      "ar_trend" = {
        x <- numeric(n); x[1] <- e[1]
        for (t in 2:n) x[t] <- 0.6 * x[t-1] + e[t]
        x + 0.05 * (1:n)
      },
      "seasonal" = {
        0.03 * (1:n) + 2 * sin(2 * pi * (1:n) / 12) + e
      },
      "rw_drift" = {
        cumsum(0.1 + e)
      },
      "nonlinear" = {
        x <- numeric(n); x[1] <- e[1]
        for (t in 2:n) {
          regime <- if (x[t-1] > 0) 0.5 else -0.3
          x[t] <- regime * x[t-1] + e[t]
        }
        x + 0.02 * (1:n)
      }
    )

    freq <- if (s_type == "seasonal") 12 else 1
    y_ts <- ts(y, frequency = freq)

    # Split
    n_train <- n - h
    train_ts <- ts(y[1:n_train], frequency = freq)
    test_y   <- y[(n_train + 1):n]

    # Fit & forecast (auto.arima)
    fit <- tryCatch(
      forecast::auto.arima(train_ts),
      error = function(e) NULL
    )

    if (!is.null(fit)) {
      fc <- forecast::forecast(fit, h = h)
      fc_mean <- as.numeric(fc$mean)
      fc_lo80 <- as.numeric(fc$lower[, 1])
      fc_hi80 <- as.numeric(fc$upper[, 1])
      fc_lo95 <- as.numeric(fc$lower[, 2])
      fc_hi95 <- as.numeric(fc$upper[, 2])
    } else {
      fc_mean <- rep(mean(train_ts), h)
      fc_lo80 <- fc_lo95 <- fc_mean - 2
      fc_hi80 <- fc_hi95 <- fc_mean + 2
    }

    # Naive forecast (last value)
    naive_fc <- rep(y[n_train], h)

    # Accuracy
    errors_arima <- test_y - fc_mean
    errors_naive <- test_y - naive_fc

    acc <- data.frame(
      Method = c("ARIMA", "Naive"),
      MAE  = c(mean(abs(errors_arima)), mean(abs(errors_naive))),
      RMSE = c(sqrt(mean(errors_arima^2)), sqrt(mean(errors_naive^2))),
      MAPE = c(mean(abs(errors_arima / test_y)) * 100,
               mean(abs(errors_naive / test_y)) * 100)
    )

    list(y = y, n = n, h = h, n_train = n_train,
         train_ts = train_ts, test_y = test_y,
         fc_mean = fc_mean, fc_lo80 = fc_lo80, fc_hi80 = fc_hi80,
         fc_lo95 = fc_lo95, fc_hi95 = fc_hi95,
         naive_fc = naive_fc, acc = acc, fit = fit)
  })

  output$ts_fc_plot <- renderPlot(bg = "transparent", {
    req(ts_fc_data())
    d <- ts_fc_data()

    train_df <- data.frame(t = 1:d$n_train, y = as.numeric(d$train_ts))
    test_df  <- data.frame(t = (d$n_train + 1):d$n, y = d$test_y)
    fc_df    <- data.frame(
      t = (d$n_train + 1):d$n,
      mean = d$fc_mean,
      lo80 = d$fc_lo80, hi80 = d$fc_hi80,
      lo95 = d$fc_lo95, hi95 = d$fc_hi95,
      naive = d$naive_fc
    )

    ggplot() +
      geom_line(data = train_df, aes(t, y), color = "#657b83", linewidth = 0.4) +
      geom_line(data = test_df, aes(t, y), color = "#073642", linewidth = 0.6) +
      geom_ribbon(data = fc_df, aes(x = t, ymin = lo95, ymax = hi95),
                  fill = "#268bd2", alpha = 0.12) +
      geom_ribbon(data = fc_df, aes(x = t, ymin = lo80, ymax = hi80),
                  fill = "#268bd2", alpha = 0.2) +
      geom_line(data = fc_df, aes(t, mean), color = "#268bd2", linewidth = 0.9) +
      geom_line(data = fc_df, aes(t, naive), color = "#b58900",
                linetype = "dashed", linewidth = 0.7) +
      geom_vline(xintercept = d$n_train + 0.5, linetype = "dotted", color = "grey50") +
      annotate("text", x = d$n_train - 5, y = max(d$y),
               label = "Train", hjust = 1, color = "#657b83", size = 3.5) +
      annotate("text", x = d$n_train + 5, y = max(d$y),
               label = "Test", hjust = 0, color = "#073642", size = 3.5) +
      labs(x = "Time", y = "Value",
           title = "Forecast vs. Actual",
           caption = "Blue = ARIMA forecast (80%/95% PI); dashed = naive")
  })

  output$ts_fc_accuracy <- renderUI({
    req(ts_fc_data())
    d <- ts_fc_data()
    acc <- d$acc

    rows <- ""
    for (i in 1:nrow(acc)) {
      hl <- if (i == 1) "background-color: rgba(42,161,152,0.08);" else ""
      rows <- paste0(rows, sprintf(
        '<tr style="%s"><td>%s</td><td>%.3f</td><td>%.3f</td><td>%.1f%%</td></tr>',
        hl, acc$Method[i], acc$MAE[i], acc$RMSE[i], acc$MAPE[i]
      ))
    }

    # Model summary
    mod_txt <- if (!is.null(d$fit)) {
      ord <- d$fit$arma
      sprintf("auto.arima selected: ARIMA(%d,%d,%d)", ord[1], ord[6], ord[2])
    } else "Model fitting failed; using mean forecast."

    winner <- if (acc$RMSE[1] < acc$RMSE[2]) "ARIMA" else "Naive"

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <p class="small mb-2">%s</p>
        <table class="table table-sm">
          <thead><tr><th>Method</th><th>MAE</th><th>RMSE</th><th>MAPE</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="small mb-0"><strong>%s</strong> has lower RMSE on the test set.
          %s</p>
      </div>',
      mod_txt, rows, winner,
      if (winner == "Naive") "The ARIMA model does not beat the naive benchmark \u2014 the series may be close to a random walk." else ""
    ))
  })

  })
}
