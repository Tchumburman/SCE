# Module: Confidence & Resampling (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
ci_resampling_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Confidence & Resampling",
  icon = icon("arrows-left-right"),
  navset_card_underline(
    nav_panel(
      "CI Coverage",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      sliderInput(ns("ci_level"), "Confidence Level", min = 0.80, max = 0.99,
                  value = 0.95, step = 0.01),
      sliderInput(ns("ci_n"), "Sample size (n)", min = 5, max = 1000, value = 30),
      sliderInput(ns("ci_k"), "Number of intervals", min = 10, max = 200, value = 50, step = 10),
      actionButton(ns("ci_go"), "Generate intervals", class = "btn-success w-100 mb-2"),
      actionButton(ns("ci_animate"), "\u25b6 Animate", class = "btn-outline-success w-100"),
      tags$small(class = "text-muted d-block mt-2",
                 "Animate reveals intervals one-by-one with a running coverage counter.")
    ),
    explanation_box(
      tags$strong("Confidence Interval Coverage"),
      tags$p("A confidence interval gives a range of plausible values for a population
              parameter. The confidence level (e.g., 95%) is a long-run property:
              if we repeated the study many times, about 95% of the intervals would
              contain the true parameter. It does NOT mean there's a 95% chance the
              true value is in any single interval \u2014 the true value is fixed, and any
              given interval either contains it or it doesn't."),
      tags$p("The width of each confidence interval depends on the sample size,
              the variability in the data, and the chosen confidence level. Larger
              samples produce narrower intervals (more precise estimates), while
              higher confidence levels produce wider intervals (trading precision
              for greater assurance of capturing the true value)."),
      tags$p("Confidence intervals are often misinterpreted. A 95% CI does not mean
              there is a 95% probability that the parameter lies within that specific
              interval. Rather, 95% refers to the long-run coverage rate: across many
              hypothetical repetitions of the experiment, 95% of such intervals would
              capture the true value. Red intervals in the plot are the ones that miss,
              giving a visceral demonstration of this frequentist logic."),
      tags$p("In applied work, CI width is often more informative than the p-value.
              A narrow CI centered away from zero provides strong evidence of an effect,
              while a wide CI that includes zero reveals insufficient precision rather
              than evidence of no effect."),
      guide = tags$ol(
        tags$li("Set the confidence level (e.g., 0.95), sample size, and number of intervals."),
        tags$li("Click 'Generate intervals' to show all at once, or '\u25b6 Animate' to reveal them one-by-one."),
        tags$li("Green intervals contain the true \u03bc (dashed line); red ones miss it."),
        tags$li("Watch the coverage % update as each new interval appears."),
        tags$li("Try reducing the confidence level (e.g., 0.80) to see more red intervals."),
        tags$li("Try increasing sample size to see narrower intervals.")
      )
    ),
    card(full_screen = TRUE, card_header("Confidence Intervals"),
         plotly::plotlyOutput(ns("ci_plot"), height = "500px"))
  )
    ),

    nav_panel(
      "Bootstrapping",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      sliderInput(ns("boot_n"), "Original sample size", min = 10, max = 1000, value = 30),
      selectInput(ns("boot_stat"), "Statistic",
                  choices = c("Mean", "Median", "Standard Deviation")),
      sliderInput(ns("boot_B"), "Bootstrap resamples", min = 100, max = 10000,
                  value = 1000, step = 100),
      actionButton(ns("boot_go"), "Run bootstrap", class = "btn-success w-100")
    ),
    explanation_box(
      tags$strong("The Bootstrap"),
      tags$p("Bootstrapping is a resampling method that estimates the sampling
              distribution of a statistic without relying on distributional assumptions.
              The idea: if our sample is a good representation of the population, then
              resampling from it (with replacement) mimics drawing new samples from
              the population. The spread of bootstrap statistics estimates the standard
              error; percentiles of the bootstrap distribution yield a confidence interval."),
      tags$p("This is especially useful when the statistic does not have a simple
              formula for its standard error (e.g., medians, ratios, regression
              coefficients from complex models). The bootstrap is also valuable when
              the sampling distribution is non-Normal, as the percentile CI naturally
              captures asymmetry without requiring transformations."),
      tags$p("There are several bootstrap CI methods. The ", tags$em("percentile"), " method uses
              quantiles of the bootstrap distribution directly. The ", tags$em("basic"), " (or
              reverse percentile) method reflects the distribution around the observed
              statistic. The ", tags$em("BCa"), " (bias-corrected and accelerated) method adjusts
              for both bias and skewness and generally provides the best coverage, but
              requires more computation."),
      tags$p("A common misconception is that the bootstrap \u201ccreates data\u201d or
              overcomes small-sample problems. In reality, it only approximates what
              would happen with new samples from the same population. If the original
              sample is small or unrepresentative, the bootstrap distribution will
              reflect those limitations. The bootstrap works best when the sample is
              large enough to capture the population structure."),
      guide = tags$ol(
        tags$li("Set the original sample size and choose a statistic (mean, median, or SD)."),
        tags$li("Set the number of bootstrap resamples (more = smoother distribution, 1000+ recommended)."),
        tags$li("Click 'Run bootstrap' \u2014 the left panel shows the original sample, the right shows the bootstrap distribution."),
        tags$li("The red dashed line is the observed statistic; orange dotted lines mark the 95% bootstrap CI."),
        tags$li("Try the median \u2014 notice how the bootstrap distribution can be asymmetric, unlike the Normal approximation for means.")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Original Sample"),
           plotly::plotlyOutput(ns("boot_sample_plot"), height = "350px")),
      card(full_screen = TRUE, card_header("Bootstrap Distribution"),
           plotly::plotlyOutput(ns("boot_dist_plot"), height = "350px"))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

ci_resampling_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # Full CI data (all k intervals)
  ci_all <- reactiveVal(NULL)
  # How many intervals to show (for animation)
  ci_show_n <- reactiveVal(0)
  ci_animating <- reactiveVal(FALSE)

  # Helper to generate all intervals
  generate_cis <- function() {
    n <- input$ci_n; k <- input$ci_k; level <- input$ci_level
    true_mu <- 10; true_sigma <- 3
    tcrit <- qt(1 - (1 - level) / 2, df = n - 1)

    results <- lapply(seq_len(k), function(i) {
      samp <- rnorm(n, true_mu, true_sigma)
      xbar <- mean(samp)
      se <- sd(samp) / sqrt(n)
      data.frame(
        id = i, xbar = xbar,
        lower = xbar - tcrit * se, upper = xbar + tcrit * se,
        covers = (xbar - tcrit * se <= true_mu) & (xbar + tcrit * se >= true_mu)
      )
    })
    do.call(rbind, results)
  }

  # Instant generation (show all)
  observeEvent(input$ci_go, {
    withProgress(message = "Generating confidence intervals...", value = 0.1, {
    ci_animating(FALSE)
    updateActionButton(session, "ci_animate", label = "\u25b6 Animate")
    df <- generate_cis()
    ci_all(df)
    ci_show_n(nrow(df))
    })
  })

  # Animate toggle
  observeEvent(input$ci_animate, {
    if (ci_animating()) {
      ci_animating(FALSE)
      updateActionButton(session, "ci_animate", label = "\u25b6 Animate")
    } else {
      df <- generate_cis()
      ci_all(df)
      ci_show_n(0)
      ci_animating(TRUE)
      updateActionButton(session, "ci_animate", label = "\u23f8 Pause")
    }
  })

  # Timer: reveal one interval at a time
  observe({
    if (ci_animating()) {
      invalidateLater(120)
      isolate({
        df <- ci_all()
        if (is.null(df)) {
          ci_animating(FALSE)
          return()
        }
        current <- ci_show_n()
        new_n <- current + 1
        ci_show_n(new_n)
        if (new_n >= nrow(df)) {
          ci_animating(FALSE)
          updateActionButton(session, "ci_animate", label = "\u25b6 Animate")
        }
      })
    }
  })

  output$ci_plot <- plotly::renderPlotly({
    df <- ci_all()
    show_n <- ci_show_n()

    req(df, show_n > 0)
    true_mu <- 10
      # Subset to visible intervals
      vis <- df[seq_len(min(show_n, nrow(df))), ]
      coverage <- round(mean(vis$covers) * 100, 1)
      colors <- ifelse(vis$covers, "#238b45", "#e31a1c")

      p <- plotly::plot_ly()
      for (i in seq_len(nrow(vis))) {
        p <- p |> plotly::add_trace(
          x = c(vis$lower[i], vis$upper[i]), y = c(vis$id[i], vis$id[i]),
          type = "scatter", mode = "lines",
          line = list(color = colors[i], width = 2),
          showlegend = FALSE, hoverinfo = "text",
          text = paste0("Interval ", vis$id[i], "<br>[",
                        round(vis$lower[i], 2), ", ", round(vis$upper[i], 2), "]",
                        "<br>", ifelse(vis$covers[i], "Covers \u03bc", "Misses \u03bc"))
        )
      }
      if (any(vis$covers)) {
        p <- p |>
          plotly::add_markers(
            x = vis$xbar[vis$covers], y = vis$id[vis$covers],
            marker = list(color = "#238b45", size = 3),
            name = "Covers \u03bc", hoverinfo = "none"
          )
      }
      if (any(!vis$covers)) {
        p <- p |>
          plotly::add_markers(
            x = vis$xbar[!vis$covers], y = vis$id[!vis$covers],
            marker = list(color = "#e31a1c", size = 3),
            name = "Misses \u03bc", hoverinfo = "none"
          )
      }

      # Use full data range for stable axes
      x_range <- c(min(df$lower) - 0.5, max(df$upper) + 0.5)

      p <- p |>
        plotly::layout(
          shapes = list(list(
            type = "line", x0 = true_mu, x1 = true_mu,
            y0 = 0, y1 = max(df$id) + 1,
            line = list(color = "grey40", width = 1.5, dash = "dash")
          )),
          xaxis = list(title = "Value", range = x_range),
          yaxis = list(title = "Interval", range = c(0, max(df$id) + 1)),
          title = list(
            text = paste0("Coverage: ", coverage, "%  (",
                          nrow(vis), " of ", nrow(df), " intervals)  |  nominal ",
                          input$ci_level * 100, "%  |  \u03bc = ", true_mu),
            font = list(size = 13)
          ),
          legend = list(orientation = "h", x = 0.5, xanchor = "center",
                        y = -0.1, yanchor = "top", font = list(size = 11)),
          margin = list(b = 60, t = 40)
        )
      p
  })


  boot_result <- reactiveVal(NULL)

  observeEvent(input$boot_go, {
    withProgress(message = "Running bootstrap resampling...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    original <- rgamma(input$boot_n, shape = 3, rate = 0.5)

    stat_fn <- switch(input$boot_stat,
      "Mean"               = mean,
      "Median"             = median,
      "Standard Deviation" = sd
    )

    boot_stats <- replicate(input$boot_B, {
      resample <- sample(original, replace = TRUE)
      stat_fn(resample)
    })

    boot_result(list(
      original = original,
      stats    = boot_stats,
      observed = stat_fn(original),
      ci       = quantile(boot_stats, c(0.025, 0.975))
    ))
    })
  })

  output$boot_sample_plot <- plotly::renderPlotly({
    res <- boot_result()
    req(res)
    plotly::plot_ly(x = res$original, type = "histogram",
                      nbinsx = 25,
                      marker = list(color = "#99d8c9", line = list(color = "white", width = 1)),
                      showlegend = FALSE, hovertemplate = "Value: %{x}<br>Count: %{y}<extra></extra>") |>
        plotly::layout(
          shapes = list(list(
            type = "line", x0 = res$observed, x1 = res$observed,
            y0 = 0, y1 = 1, yref = "paper",
            line = list(color = "#e31a1c", width = 2, dash = "dash")
          )),
          xaxis = list(title = "Value"),
          yaxis = list(title = "Count"),
          title = list(
            text = paste0("n = ", length(res$original),
                          "  |  Observed ", input$boot_stat, " = ",
                          round(res$observed, 2)),
            font = list(size = 13)
          ),
          margin = list(t = 40)
        )
  })

  output$boot_dist_plot <- plotly::renderPlotly({
    res <- boot_result()
    req(res)
    plotly::plot_ly(x = res$stats, type = "histogram",
                      histnorm = "probability density", nbinsx = 60,
                      marker = list(color = "rgba(35,139,69,0.8)",
                                    line = list(color = "white", width = 0.5)),
                      showlegend = FALSE,
                      hovertemplate = "Value: %{x}<br>Density: %{y:.4f}<extra></extra>") |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = res$observed, x1 = res$observed,
                 y0 = 0, y1 = 1, yref = "paper",
                 line = list(color = "#e31a1c", width = 2, dash = "dash")),
            list(type = "line", x0 = res$ci[1], x1 = res$ci[1],
                 y0 = 0, y1 = 1, yref = "paper",
                 line = list(color = "#006d2c", width = 1.5, dash = "dot")),
            list(type = "line", x0 = res$ci[2], x1 = res$ci[2],
                 y0 = 0, y1 = 1, yref = "paper",
                 line = list(color = "#006d2c", width = 1.5, dash = "dot"))
          ),
          annotations = list(
            list(x = res$ci[1], y = 0.02, yref = "paper", text = paste0("2.5%: ", round(res$ci[1], 2)),
                 showarrow = FALSE, xanchor = "right", font = list(size = 11, color = "#006d2c"),
                 bgcolor = "#e5f5f9"),
            list(x = res$ci[2], y = 0.02, yref = "paper", text = paste0("97.5%: ", round(res$ci[2], 2)),
                 showarrow = FALSE, xanchor = "left", font = list(size = 11, color = "#006d2c"),
                 bgcolor = "#e5f5f9")
          ),
          xaxis = list(title = paste("Bootstrap", input$boot_stat)),
          yaxis = list(title = "Density"),
          title = list(
            text = paste0(input$boot_B, " resamples  |  95% CI: [",
                          round(res$ci[1], 2), ", ", round(res$ci[2], 2), "]"),
            font = list(size = 13)
          ),
          margin = list(t = 40)
        )
  })
  # Auto-run simulations on first load


  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Confidence & Resampling", list(ci_all, ci_show_n, boot_result))
  })
}
