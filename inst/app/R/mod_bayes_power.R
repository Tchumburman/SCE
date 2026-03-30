# Module: Bayesian & Power (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
bayes_power_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Bayesian & Power",
  icon = icon("chart-pie"),
  navset_card_underline(
    nav_panel(
      "Bayesian Inference",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      tags$h6("Prior Distribution (Beta)"),
      sliderInput(ns("bayes_prior_a"), "Prior \u03b1 (successes)", min = 0.5, max = 50, value = 2, step = 0.5),
      sliderInput(ns("bayes_prior_b"), "Prior \u03b2 (failures)", min = 0.5, max = 50, value = 5, step = 0.5),
      tags$hr(),
      tags$h6("Observed Data"),
      sliderInput(ns("bayes_obs_n"), "Number of trials", min = 1, max = 500, value = 20),
      sliderInput(ns("bayes_obs_k"), "Number of successes", min = 0, max = 500, value = 8),
      tags$hr(),
      checkboxInput(ns("bayes_show_likelihood"), "Show likelihood", value = TRUE),
      checkboxInput(ns("bayes_show_ci"), "Show 95% credible interval", value = FALSE),
      actionButton(ns("bayes_reset"), "Reset to defaults", class = "btn-outline-secondary w-100")
    ),
    explanation_box(
      tags$strong("Bayesian Inference"),
      tags$p("Bayesian inference updates prior beliefs with observed data to produce a posterior
              distribution. For estimating a proportion, we use a Beta prior. After observing
              data (successes and failures), the posterior is also Beta with updated parameters:
              \u03b1_post = \u03b1_prior + k, \u03b2_post = \u03b2_prior + (n \u2212 k)."),
      tags$p("The posterior combines prior knowledge with data. A flat prior (\u03b1 = \u03b2 = 1)
              lets the data dominate; a strong prior (large \u03b1 and \u03b2) resists change.
              As sample size grows, the likelihood overwhelms the prior — the Bayesian
              and frequentist estimates converge."),
      guide = tags$ol(
        tags$li("Set your prior belief about the proportion using \u03b1 and \u03b2 sliders."),
        tags$li("Enter observed data: number of trials and successes."),
        tags$li("Compare how the posterior (green) shifts from the prior (dashed) toward the data."),
        tags$li("Toggle the likelihood curve to see the data's contribution."),
        tags$li("Enable the 95% credible interval to see the range of plausible values."),
        tags$li("Try a flat prior (\u03b1 = \u03b2 = 1) vs. a strong prior to see the prior's influence.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(
        full_screen = TRUE,
        card_header("Prior, Likelihood & Posterior"),
        plotly::plotlyOutput(ns("bayes_plot"), height = "400px")
      ),
      card(
        card_header("Summary"),
        uiOutput(ns("bayes_summary"))
      )
    )
  )
    ),

    nav_panel(
      "Power Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      tags$strong("Two-sample t-test scenario"),
      sliderInput(ns("pwr_n"), "Sample size per group (n)", min = 5, max = 200, value = 30, step = 5),
      sliderInput(ns("pwr_d"), "Effect size (Cohen's d)", min = 0, max = 2, value = 0.5, step = 0.05),
      sliderInput(ns("pwr_alpha"), "\u03b1 (significance level)", min = 0.001, max = 0.20, value = 0.05, step = 0.005),
      tags$hr(),
      tags$strong("Power curve"),
      sliderInput(ns("pwr_curve_d"), "Effect size for curve", min = 0.1, max = 1.5, value = 0.5, step = 0.05)
    ),

    explanation_box(
      tags$strong("Statistical Power"),
      tags$p("Power is the probability of correctly rejecting H\u2080 when it is false
              (i.e., detecting a real effect). It depends on sample size, effect size,
              significance level \u03b1, and the specific test being used."),
      tags$p("The top plot shows the null and alternative distributions for a two-sample
              t-test. The shaded red area is \u03b1 (Type I error \u2014 rejecting H\u2080
              when it is true), and the shaded green area is power (1 \u2212 \u03b2,
              correctly rejecting H\u2080 when it is false). The unshaded area under
              the alternative distribution represents \u03b2 (Type II error \u2014 failing
              to detect a real effect)."),
      tags$p("The relationship between power and sample size is nonlinear. The biggest
              gains come at moderate sample sizes; once power exceeds about 90%, further
              increases in n yield diminishing improvements. This is why the conventional
              target of 80% power is considered a practical minimum \u2014 it balances
              the risk of missing a real effect against the cost of data collection."),
      tags$p("The bottom plot shows how power varies with sample size. Notice that smaller
              effect sizes require dramatically larger samples. Detecting a small effect
              (d = 0.2) with 80% power requires roughly 400 participants per group,
              whereas a large effect (d = 0.8) needs only about 26."),
      guide = tags$ol(
        tags$li("Increase n to see the alternative distribution get narrower and power grow."),
        tags$li("Increase Cohen's d to move the alternative distribution further right."),
        tags$li("Notice: with a small effect and small n, power can be very low."),
        tags$li("The power curve shows the relationship for a range of sample sizes.")
      )
    ),

    layout_column_wrap(
      width = 1,
      card(
        full_screen = TRUE,
        card_header("Null vs. Alternative Distributions"),
        plotlyOutput(ns("pwr_distributions"), height = "380px")
      ),
      card(
        full_screen = TRUE,
        card_header("Power Curve (Power vs. Sample Size)"),
        plotlyOutput(ns("pwr_curve"), height = "340px")
      )
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

bayes_power_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  # Keep successes slider <= trials slider
  observeEvent(input$bayes_obs_n, {
    if (!is.null(input$bayes_obs_k) && input$bayes_obs_k > input$bayes_obs_n)
      updateSliderInput(session, "bayes_obs_k", value = input$bayes_obs_n,
                        max = input$bayes_obs_n)
    else
      updateSliderInput(session, "bayes_obs_k", max = input$bayes_obs_n)
  })

  observeEvent(input$bayes_reset, {
    updateSliderInput(session, "bayes_prior_a", value = 2)
    updateSliderInput(session, "bayes_prior_b", value = 5)
    updateSliderInput(session, "bayes_obs_n", value = 20)
    updateSliderInput(session, "bayes_obs_k", value = 8)
  })
  
  output$bayes_plot <- plotly::renderPlotly({
    a0 <- input$bayes_prior_a
    b0 <- input$bayes_prior_b
    k  <- min(input$bayes_obs_k, input$bayes_obs_n)
    n  <- input$bayes_obs_n

    a1 <- a0 + k
    b1 <- b0 + (n - k)

    theta <- seq(0, 1, length.out = 500)
    prior <- dbeta(theta, a0, b0)
    posterior <- dbeta(theta, a1, b1)
    lik_raw <- dbeta(theta, k + 1, n - k + 1)
    lik_scaled <- lik_raw * max(posterior) / max(lik_raw)

    y_max <- max(c(prior, posterior)) * 1.15

    p <- plotly::plot_ly() |>
      plotly::add_lines(x = theta, y = prior,
        line = list(color = "#999999", width = 2, dash = "dash"),
        name = "Prior") |>
      plotly::add_lines(x = theta, y = posterior,
        line = list(color = "#238b45", width = 2),
        name = "Posterior")

    if (input$bayes_show_likelihood) {
      p <- p |> plotly::add_lines(
        x = theta, y = lik_scaled,
        line = list(color = "#e31a1c", width = 1.5, dash = "dot"),
        name = "Likelihood (scaled)"
      )
    }

    shapes <- list()
    annotations <- list()

    if (input$bayes_show_ci) {
      ci <- qbeta(c(0.025, 0.975), a1, b1)
      shade_idx <- theta >= ci[1] & theta <= ci[2]
      if (any(shade_idx)) {
        p <- p |> plotly::add_trace(
          x = theta[shade_idx], y = posterior[shade_idx],
          type = "scatter", mode = "none",
          fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
          showlegend = FALSE, hoverinfo = "none"
        )
      }
      shapes <- list(
        list(type = "line", x0 = ci[1], x1 = ci[1], y0 = 0, y1 = y_max,
             line = list(color = "#006d2c", width = 1, dash = "dash")),
        list(type = "line", x0 = ci[2], x1 = ci[2], y0 = 0, y1 = y_max,
             line = list(color = "#006d2c", width = 1, dash = "dash"))
      )
      annotations <- list(list(
        x = mean(ci), y = y_max * 0.9,
        text = paste0("95% CrI: [", round(ci[1], 3), ", ", round(ci[2], 3), "]"),
        showarrow = FALSE, font = list(color = "#006d2c", size = 12),
        bgcolor = "#e5f5f9"
      ))
    }

    p |> plotly::layout(
      xaxis = list(title = "\u03b8 (proportion)"),
      yaxis = list(title = "Density", range = c(0, y_max)),
      shapes = shapes,
      annotations = annotations,
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.12, yanchor = "top", font = list(size = 11)),
      margin = list(b = 60, t = 20)
    )
  })
  
  output$bayes_summary <- renderUI({
    a0 <- input$bayes_prior_a
    b0 <- input$bayes_prior_b
    k  <- min(input$bayes_obs_k, input$bayes_obs_n)
    n  <- input$bayes_obs_n
    a1 <- a0 + k
    b1 <- b0 + (n - k)
  
    prior_mean <- a0 / (a0 + b0)
    post_mean  <- a1 / (a1 + b1)
    post_mode  <- if (a1 > 1 && b1 > 1) (a1 - 1) / (a1 + b1 - 2) else NA
    mle        <- k / n
    ci <- qbeta(c(0.025, 0.975), a1, b1)
  
    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$tr(tags$td(tags$strong("Prior")),
                tags$td(paste0("Beta(", a0, ", ", b0, ") — mean = ", round(prior_mean, 3)))),
        tags$tr(tags$td(tags$strong("Data")),
                tags$td(paste0(k, " successes / ", n, " trials — MLE = ", round(mle, 3)))),
        tags$tr(tags$td(tags$strong("Posterior")),
                tags$td(paste0("Beta(", a1, ", ", b1, ") — mean = ", round(post_mean, 3),
                               if (!is.na(post_mode)) paste0(", mode = ", round(post_mode, 3)) else ""))),
        tags$tr(tags$td(tags$strong("95% Credible Interval")),
                tags$td(paste0("[", round(ci[1], 3), ",  ", round(ci[2], 3), "]")))
      )
    )
  })
  


  output$pwr_distributions <- renderPlotly({
    n     <- input$pwr_n
    d     <- input$pwr_d
    alpha <- input$pwr_alpha

    se <- sqrt(2 / n)
    delta <- d
    crit <- qnorm(1 - alpha / 2) * se

    x <- seq(-4 * se, delta + 4 * se, length.out = 600)
    y_null <- dnorm(x, 0, se)
    y_alt  <- dnorm(x, delta, se)

    power_val <- pnorm(crit, delta, se, lower.tail = FALSE) +
                 pnorm(-crit, delta, se, lower.tail = TRUE)

    # Shaded regions
    rej_x <- x[x >= crit]
    rej_null_y <- dnorm(rej_x, 0, se)
    rej_alt_y  <- dnorm(rej_x, delta, se)

    hover_null <- paste0("x = ", round(x, 3),
                         "<br>H\u2080 density: ", round(y_null, 4),
                         "<br>SE = ", round(se, 3))
    hover_alt  <- paste0("x = ", round(x, 3),
                         "<br>H\u2081 density: ", round(y_alt, 4),
                         "<br>\u03b4 = ", round(delta, 3))

    plotly::plot_ly() |>
      # Null distribution
      plotly::add_trace(
        x = x, y = y_null, type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2.5),
        hoverinfo = "text", text = hover_null,
        name = "H\u2080 (Null)", showlegend = TRUE
      ) |>
      # Alternative distribution
      plotly::add_trace(
        x = x, y = y_alt, type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_alt,
        name = "H\u2081 (Alternative)", showlegend = TRUE
      ) |>
      # Alpha shading (Type I error)
      plotly::add_trace(
        x = c(crit, rej_x, max(rej_x)), y = c(0, rej_null_y, 0),
        type = "scatter", mode = "lines", fill = "toself",
        fillcolor = "rgba(227,26,28,0.2)",
        line = list(color = "transparent"),
        hoverinfo = "text",
        text = paste0("\u03b1 region<br>Type I Error = ", round(alpha, 3)),
        name = paste0("\u03b1 = ", alpha), showlegend = TRUE
      ) |>
      # Power shading
      plotly::add_trace(
        x = c(crit, rej_x, max(rej_x)), y = c(0, rej_alt_y, 0),
        type = "scatter", mode = "lines", fill = "toself",
        fillcolor = "rgba(35,139,69,0.2)",
        line = list(color = "transparent"),
        hoverinfo = "text",
        text = paste0("Power region<br>Power = ", round(power_val, 3)),
        name = paste0("Power = ", round(power_val, 3)), showlegend = TRUE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = crit, x1 = crit, y0 = 0, y1 = max(y_null) * 1.05,
               line = list(color = "grey40", width = 1.5, dash = "dash"))
        ),
        xaxis = list(title = "Difference in Means"),
        yaxis = list(title = "Density"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("n = ", n, " per group,  d = ", d, ",  \u03b1 = ", alpha),
               showarrow = FALSE, font = list(size = 13))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # Power curve
  output$pwr_curve <- renderPlotly({
    d     <- input$pwr_curve_d
    alpha <- input$pwr_alpha

    ns <- seq(5, 300, by = 1)
    se_vec <- sqrt(2 / ns)
    crit_vec <- qnorm(1 - alpha / 2) * se_vec
    power_vec <- pnorm(crit_vec, d, se_vec, lower.tail = FALSE) +
                 pnorm(-crit_vec, d, se_vec, lower.tail = TRUE)

    # Current n marker
    cur_se   <- sqrt(2 / input$pwr_n)
    cur_crit <- qnorm(1 - alpha / 2) * cur_se
    cur_pwr  <- pnorm(cur_crit, d, cur_se, lower.tail = FALSE) +
                pnorm(-cur_crit, d, cur_se, lower.tail = TRUE)

    # Find n for 80% power
    n80 <- ns[which(power_vec >= 0.80)[1]]

    hover_curve <- paste0("n = ", ns,
                          "<br>Power = ", round(power_vec, 3),
                          "<br>d = ", d, ", \u03b1 = ", alpha)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = ns, y = power_vec, type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_curve,
        name = "Power curve", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = input$pwr_n, y = cur_pwr,
        marker = list(color = "#e31a1c", size = 10,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Current: n = ", input$pwr_n,
                      "<br>Power = ", round(cur_pwr, 3)),
        name = "Current n", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 5, x1 = 300, y0 = 0.8, y1 = 0.8,
               line = list(color = "grey50", width = 1.5, dash = "dash"))
        ),
        annotations = list(
          list(x = 290, y = 0.83, text = "80% power",
               showarrow = FALSE, font = list(size = 11, color = "grey40")),
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("d = ", d, ",  \u03b1 = ", alpha,
                             if (!is.na(n80)) paste0("  |  n \u2265 ", n80, " for 80% power") else ""),
               showarrow = FALSE, font = list(size = 13))
        ),
        xaxis = list(title = "Sample Size per Group", range = c(0, 310)),
        yaxis = list(title = "Power", range = c(0, 1.05)),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  })
}
