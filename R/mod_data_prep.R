# Module: Data Preparation (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
data_prep_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Data Preparation",
  icon = icon("wand-magic-sparkles"),
  navset_card_underline(
    nav_panel(
      "Data Transformations",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("trans_source"), "Source distribution",
        choices = c("Right-skewed (Gamma)" = "gamma",
                    "Right-skewed (Exponential)" = "exp",
                    "Left-skewed" = "left",
                    "Heavy-tailed" = "heavy"),
        selected = "gamma"
      ),
      sliderInput(ns("trans_n"), "Sample size", min = 100, max = 2000,
                  value = 500, step = 100),
      selectInput(ns("trans_method"), "Transformation",
        choices = c("Log" = "log", "Square root" = "sqrt",
                    "Reciprocal (1/x)" = "recip",
                    "Box-Cox (auto)" = "boxcox"),
        selected = "log"
      ),
      actionButton(ns("trans_go"), "Apply", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Data Transformations"),
      tags$p("Many statistical methods assume approximately normal data.
              Transformations can make skewed distributions more symmetric."),
      tags$ul(
        tags$li(tags$strong("Log:"), " Best for right-skewed data, especially when the spread increases with the mean."),
        tags$li(tags$strong("Square root:"), " Milder than log; good for count data."),
        tags$li(tags$strong("Reciprocal:"), " Strongest transformation; reverses order."),
        tags$li(tags$strong("Box-Cox:"), " Finds the optimal power transformation (\u03bb) automatically.")
      ),
      tags$p("Transformations serve several purposes: reducing skewness to meet normality
              assumptions, stabilising variance (addressing heteroscedasticity), and
              linearising relationships. The log transformation is most common for right-skewed
              data with a natural zero (e.g., income, reaction times). The square root
              transformation is milder. Box-Cox automatically finds the optimal power
              transformation by maximising the log-likelihood."),
      tags$p("An important caveat: transformations change the scale of interpretation.
              A difference of 1 on the log scale corresponds to a multiplicative factor
              on the original scale. Regression coefficients and confidence intervals must
              be back-transformed for meaningful reporting. When the goal is prediction
              rather than inference, transformations of the response may be unnecessary if
              the model fits well on the original scale."),
      guide = tags$ol(
        tags$li("Choose a skewed distribution and transformation."),
        tags$li("Click 'Apply' to see histograms before and after."),
        tags$li("Compare skewness values to see how well the transformation worked."),
        tags$li("Try Box-Cox to find the optimal \u03bb.")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Original"),
           plotlyOutput(ns("trans_orig"), height = "350px")),
      card(full_screen = TRUE, card_header("Transformed"),
           plotlyOutput(ns("trans_new"), height = "350px"))
    ),
    card(card_header("Comparison"), tableOutput(ns("trans_table")))
  )
    ),

    nav_panel(
      "Time Series",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("ts_n"), "Number of observations", min = 50, max = 500,
                  value = 200, step = 50),
      sliderInput(ns("ts_trend"), "Trend slope", min = -0.5, max = 0.5,
                  value = 0.1, step = 0.05),
      sliderInput(ns("ts_seasonal_amp"), "Seasonal amplitude", min = 0, max = 5,
                  value = 2, step = 0.5),
      sliderInput(ns("ts_seasonal_period"), "Seasonal period", min = 5, max = 50,
                  value = 12, step = 1),
      sliderInput(ns("ts_noise"), "Noise level", min = 0.5, max = 5,
                  value = 1, step = 0.5),
      sliderInput(ns("ts_ar"), "AR(1) coefficient", min = -0.9, max = 0.9,
                  value = 0.5, step = 0.1),
      actionButton(ns("ts_go"), "Generate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Time Series Basics"),
      tags$p("A time series can be decomposed into trend, seasonal, and residual
              components. Understanding these components is essential for forecasting
              and detecting patterns."),
      tags$ul(
        tags$li(tags$strong("Trend:"), " Long-term increase or decrease."),
        tags$li(tags$strong("Seasonality:"), " Regular periodic pattern."),
        tags$li(tags$strong("Autocorrelation:"), " Correlation between observations at different lags. The ACF plot reveals this structure.")
      ),
      tags$p("Time series data violate the independence assumption of standard statistical
              methods. Observations close in time tend to be similar (autocorrelation), and
              many series exhibit trends and seasonal patterns. Decomposition separates a
              series into trend (long-term direction), seasonal (repeating pattern), and
              remainder (random fluctuation) components."),
      tags$p("Understanding these components is essential before modelling. The ACF
              (autocorrelation function) reveals the correlation structure: slowly decaying
              ACF suggests a trend; periodic spikes suggest seasonality. Stationarity
              (constant mean and variance over time) is typically required for ARIMA-type
              models and can be achieved through differencing."),
      guide = tags$ol(
        tags$li("Adjust the trend, seasonality, noise, and AR coefficient."),
        tags$li("Click 'Generate' to create a time series."),
        tags$li("Examine the decomposition to see trend, seasonal, and residual parts."),
        tags$li("Check the ACF plot to see autocorrelation structure.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Time Series"),
           plotlyOutput(ns("ts_plot"), height = "300px")),
      card(full_screen = TRUE, card_header("Decomposition"),
           plotlyOutput(ns("ts_decomp"), height = "400px")),
      card(full_screen = TRUE, card_header("Autocorrelation Function (ACF)"),
           plotlyOutput(ns("ts_acf"), height = "250px"))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

data_prep_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  trans_data <- reactiveVal(NULL)

  observeEvent(input$trans_go, {
    n <- input$trans_n
    set.seed(sample.int(10000, 1))
    x <- switch(input$trans_source,
      "gamma" = rgamma(n, shape = 2, rate = 0.5),
      "exp"   = rexp(n, rate = 0.5),
      "left"  = max(rgamma(n, shape = 2, rate = 0.5)) - rgamma(n, shape = 2, rate = 0.5) + 1,
      "heavy" = abs(rt(n, df = 2)) + 1
    )

    method <- input$trans_method
    y <- switch(method,
      "log"   = log(x),
      "sqrt"  = sqrt(x),
      "recip" = 1 / x,
      "boxcox" = {
        # Find optimal lambda via profile log-likelihood
        lambdas <- seq(-2, 2, by = 0.1)
        ll <- sapply(lambdas, function(lam) {
          if (abs(lam) < 0.01) yt <- log(x) else yt <- (x^lam - 1) / lam
          n * (-0.5 * log(var(yt))) + (lam - 1) * sum(log(x))
        })
        best_lam <- lambdas[which.max(ll)]
        if (abs(best_lam) < 0.01) log(x) else (x^best_lam - 1) / best_lam
      }
    )

    lam_label <- if (method == "boxcox") {
      lambdas <- seq(-2, 2, by = 0.1)
      ll <- sapply(lambdas, function(lam) {
        if (abs(lam) < 0.01) yt <- log(x) else yt <- (x^lam - 1) / lam
        n * (-0.5 * log(var(yt))) + (lam - 1) * sum(log(x))
      })
      paste0("Box-Cox (\u03bb = ", lambdas[which.max(ll)], ")")
    } else method

    trans_data(list(original = x, transformed = y, method = lam_label))
  })

  make_hist <- function(x, color, title) {
    plotly::plot_ly(x = x, type = "histogram",
                    marker = list(color = paste0(color, "99"),
                                  line = list(color = color, width = 1)),
                    showlegend = FALSE) |>
      plotly::layout(
        xaxis = list(title = "Value"),
        yaxis = list(title = "Count"),
        margin = list(t = 30),
        annotations = list(list(
          x = 0.5, y = 1.05, xref = "paper", yref = "paper",
          text = title, showarrow = FALSE, font = list(size = 12)
        ))
      ) |> plotly::config(displayModeBar = FALSE)
  }

  output$trans_orig <- renderPlotly({
    res <- trans_data()
    req(res)
    skew_val <- {
      x <- res$original; m <- mean(x); n <- length(x)
      (sum((x - m)^3) / n) / (sum((x - m)^2) / n)^1.5
    }
    make_hist(res$original, "#3182bd", paste0("Skewness = ", round(skew_val, 3)))
  })

  output$trans_new <- renderPlotly({
    res <- trans_data(); req(res)
    y <- res$transformed
    y <- y[is.finite(y)]
    skew_val <- {
      m <- mean(y); n <- length(y)
      (sum((y - m)^3) / n) / (sum((y - m)^2) / n)^1.5
    }
    make_hist(y, "#238b45", paste0("Skewness = ", round(skew_val, 3)))
  })

  output$trans_table <- renderTable({
    res <- trans_data(); req(res)
    x <- res$original; y <- res$transformed[is.finite(res$transformed)]
    calc <- function(v) {
      m <- mean(v); n <- length(v)
      c(mean = m, sd = sd(v),
        skewness = (sum((v - m)^3) / n) / (sum((v - m)^2) / n)^1.5,
        kurtosis = (sum((v - m)^4) / n) / (sum((v - m)^2) / n)^2 - 3)
    }
    o <- calc(x); t <- calc(y)
    data.frame(
      Statistic = c("Mean", "SD", "Skewness", "Excess Kurtosis"),
      Original = round(o, 3),
      Transformed = round(t, 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  ts_data <- reactiveVal(NULL)

  observeEvent(input$ts_go, {
    n <- input$ts_n; trend <- input$ts_trend
    amp <- input$ts_seasonal_amp; period <- input$ts_seasonal_period
    noise <- input$ts_noise; ar <- input$ts_ar
    set.seed(sample.int(10000, 1))

    t <- seq_len(n)
    # AR(1) noise
    e <- numeric(n)
    e[1] <- rnorm(1, 0, noise)
    for (i in 2:n) e[i] <- ar * e[i - 1] + rnorm(1, 0, noise)

    y <- trend * t + amp * sin(2 * pi * t / period) + e
    ts_obj <- ts(y, frequency = max(2, round(period)))
    ts_data(ts_obj)
  })

  output$ts_plot <- renderPlotly({
    tsobj <- ts_data()
    req(tsobj)
    y <- as.numeric(tsobj)
    plotly::plot_ly(x = seq_along(y), y = y,
                    type = "scatter", mode = "lines",
                    line = list(color = "#238b45", width = 1.5),
                    hoverinfo = "text",
                    text = paste0("t = ", seq_along(y), "<br>y = ", round(y, 3))) |>
      plotly::layout(
        xaxis = list(title = "Time"), yaxis = list(title = "Value"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ts_decomp <- renderPlotly({
    tsobj <- ts_data(); req(tsobj)
    freq <- frequency(tsobj)
    if (freq >= 2 && length(tsobj) >= 2 * freq) {
      decomp <- decompose(tsobj)
      n <- length(tsobj)
      t_idx <- seq_len(n)

      make_line <- function(y_vals, title) {
        plot_ly() |>
          add_trace(x = t_idx, y = as.numeric(y_vals), type = "scatter", mode = "lines",
                    line = list(color = "#238b45", width = 1),
                    hoverinfo = "text",
                    text = paste0("t = ", t_idx, "<br>", title, " = ",
                                   round(as.numeric(y_vals), 3)),
                    showlegend = FALSE) |>
          layout(yaxis = list(title = title),
                 xaxis = list(title = ""))
      }
      p1 <- make_line(tsobj, "Observed")
      p2 <- make_line(decomp$trend, "Trend")
      p3 <- make_line(decomp$seasonal, "Seasonal")
      p4 <- make_line(decomp$random, "Random")

      subplot(p1, p2, p3, p4, nrows = 4, shareX = TRUE, titleY = TRUE) |>
        layout(xaxis4 = list(title = "Time"), margin = list(t = 10)) |>
        config(displayModeBar = FALSE)
    } else {
      plotly::plot_ly() |>
        plotly::layout(
          annotations = list(list(
            text = "Need at least 2 full periods for decomposition",
            showarrow = FALSE, x = 0.5, y = 0.5,
            xref = "paper", yref = "paper",
            font = list(size = 14, color = "grey50"))),
          xaxis = list(visible = FALSE), yaxis = list(visible = FALSE))
    }
  })

  output$ts_acf <- renderPlotly({
    tsobj <- ts_data(); req(tsobj)
    ac <- acf(tsobj, plot = FALSE, lag.max = min(40, length(tsobj) - 1))
    lags <- as.numeric(ac$lag)
    acf_vals <- as.numeric(ac$acf)
    n <- length(tsobj)
    ci <- qnorm(0.975) / sqrt(n)

    plotly::plot_ly() |>
      plotly::add_bars(x = lags, y = acf_vals,
                       marker = list(color = "#238b45"),
                       showlegend = FALSE,
                       hoverinfo = "text",
                       text = paste0("Lag ", lags, "<br>ACF = ", round(acf_vals, 3))) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = min(lags), x1 = max(lags),
               y0 = ci, y1 = ci, line = list(color = "#3182bd", dash = "dash", width = 1)),
          list(type = "line", x0 = min(lags), x1 = max(lags),
               y0 = -ci, y1 = -ci, line = list(color = "#3182bd", dash = "dash", width = 1))
        ),
        xaxis = list(title = "Lag"), yaxis = list(title = "ACF"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
