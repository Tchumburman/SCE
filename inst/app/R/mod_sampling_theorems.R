# Module: Sampling Theorems (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
sampling_theorems_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Sampling Theorems",
  icon = icon("layer-group"),
  navset_card_underline(
    nav_panel(
      "Central Limit Theorem",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      selectInput(ns("clt_pop"), "Population Distribution",
                  choices = c("Normal", "Uniform", "Exponential", "Right-skewed (Gamma)")),
      sliderInput(ns("clt_n"), "Sample size (n)", min = 2, max = 1000, value = 30),
      numericInput(ns("clt_k"), "Samples per batch", value = 100, min = 1, max = 5000),
      actionButton(ns("clt_draw"), "Draw samples", class = "btn-success w-100 mb-2"),
      actionButton(ns("clt_autoplay"), "\u25b6 Auto-play", class = "btn-outline-success w-100 mb-2"),
      actionButton(ns("clt_reset"), "Reset", class = "btn-outline-secondary w-100"),
      tags$small(class = "text-muted d-block mt-2",
                 "Auto-play draws batches every 0.6s until 5,000 means accumulate.")
    ),
    explanation_box(
      tags$strong("Central Limit Theorem"),
      tags$p("The Central Limit Theorem (CLT) is one of the most powerful results in
              statistics: the distribution of the sample mean (\u0304x) approaches a Normal
              distribution as sample size increases, regardless of the population's shape.
              This is why Normal-based inference (t-tests, confidence intervals) works
              even when the underlying data isn't Normal \u2014 as long as n is large enough."),
      tags$p("The sampling distribution of \u0304x has mean = \u03bc (population mean) and
              standard error = \u03c3/\u221an. As n increases, the standard error shrinks,
              making the sampling distribution tighter around \u03bc. The rate of convergence
              depends on the population shape: symmetric distributions converge quickly
              (even n = 10 may suffice), while heavily skewed populations require larger
              samples (n = 30 or more) before the Normal approximation is adequate."),
      tags$p("A crucial subtlety: the CLT applies to the distribution of the ", tags$em("sample
              mean"), " (or sum), not to the distribution of individual observations. Raw data
              from an Exponential population will remain right-skewed no matter how large n
              is \u2014 but the ", tags$em("average"), " of those observations will be approximately
              Normal. This distinction is frequently misunderstood."),
      tags$p("The CLT also underpins the construction of confidence intervals and many
              hypothesis tests. When we say a 95% CI is \u0304x \u00b1 1.96 \u00d7 SE, we are
              implicitly invoking the CLT to justify using Normal quantiles. For small
              samples, the t-distribution corrects for the additional uncertainty in
              estimating the standard error, which is why t-intervals are preferred
              when \u03c3 is unknown."),
      guide = tags$ol(
        tags$li("Select a population distribution \u2014 try a skewed one like Exponential or Gamma."),
        tags$li("Set the sample size (n). Start small (e.g., 5) to see a non-Normal sampling distribution."),
        tags$li("Click 'Draw samples' to add batches of sample means to the histogram."),
        tags$li("Click '\u25b6 Auto-play' to watch the sampling distribution build up automatically."),
        tags$li("Increase n (e.g., 30, 100) and click 'Reset', then draw again \u2014 notice the sampling distribution becomes more Normal."),
        tags$li("The red curve overlaid is a Normal fit \u2014 see how well it matches as you add more samples.")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Population Distribution"),
           plotlyOutput(ns("clt_pop_plot"), height = "350px")),
      card(full_screen = TRUE, card_header("Sampling Distribution of the Mean"),
           plotlyOutput(ns("clt_sampling_plot"), height = "350px"))
    )
  )
    ),

    nav_panel(
      "Law of Large Numbers",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("lln_dist"), "Distribution",
        choices = c("Fair coin (p = 0.5)" = "coin",
                    "Biased coin (p = 0.3)" = "biased",
                    "Die roll (1\u20136)" = "die",
                    "Exponential (\u03bb = 1)" = "exp",
                    "Normal (\u03bc = 5)" = "norm"),
        selected = "coin"
      ),
      sliderInput(ns("lln_max_n"), "Maximum n", min = 100, max = 10000,
                  value = 1000, step = 100),
      actionButton(ns("lln_go"), "Simulate", class = "btn-success w-100 mt-2"),
      actionButton(ns("lln_animate"), "\u25b6 Animate", class = "btn-outline-success w-100 mt-2"),
      tags$small(class = "text-muted d-block mt-2",
                 "Animate reveals the convergence line progressively.")
    ),
    explanation_box(
      tags$strong("Law of Large Numbers"),
      tags$p("The Law of Large Numbers (LLN) states that as the sample size
              increases, the sample mean converges to the population mean.
              Unlike the Central Limit Theorem (which describes the shape
              of the sampling distribution), the LLN is about convergence of
              a single running average toward the true expected value."),
      tags$p("There are two forms of the LLN. The ", tags$em("weak"), " law states that the
              sample mean converges in probability: for any tolerance \u03b5 > 0,
              the probability that \u0304x differs from \u03bc by more than \u03b5
              goes to zero. The ", tags$em("strong"), " law states almost-sure convergence:
              with probability 1, the sequence of running averages eventually stays
              arbitrarily close to \u03bc. In practice, both versions say the same thing
              \u2014 larger samples give more accurate estimates \u2014 but the strong law
              is the more rigorous statement."),
      tags$p("The LLN is the theoretical justification for using sample statistics
              to estimate population parameters. It also explains why casinos and
              insurance companies are profitable in the long run: although individual
              outcomes are unpredictable, the average outcome over many trials converges
              reliably to the expected value."),
      tags$p("The plot shows how the running average stabilises around the true
              mean as n grows. Early fluctuations are large; they shrink as
              more observations accumulate. Notice that convergence is not monotonic
              \u2014 the average may drift away from \u03bc temporarily before settling back."),
      guide = tags$ol(
        tags$li("Choose a distribution and maximum sample size."),
        tags$li("Click 'Simulate' to show the full convergence line instantly."),
        tags$li("Click '\u25b6 Animate' to watch the running average build up step-by-step."),
        tags$li("Watch the running average (green) approach the true mean (dashed red)."),
        tags$li("Compare different distributions to see that convergence always happens, regardless of the distribution shape.")
      )
    ),
    card(full_screen = TRUE, card_header("Running Average"),
         plotlyOutput(ns("lln_plot"), height = "450px"))
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

sampling_theorems_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── CLT ─────────────────────────────────────────────────────────────
  clt_means <- reactiveVal(numeric(0))
  clt_playing <- reactiveVal(FALSE)

  observeEvent(input$clt_reset, {
    clt_means(numeric(0))
    clt_playing(FALSE)
    updateActionButton(session, "clt_autoplay", label = "\u25b6 Auto-play")
  })

  observeEvent(input$clt_draw, {
    new_means <- replicate(input$clt_k, mean(rpop(input$clt_n, input$clt_pop)))
    clt_means(c(clt_means(), new_means))
  })

  # Auto-play toggle
  observeEvent(input$clt_autoplay, {
    if (clt_playing()) {
      clt_playing(FALSE)
      updateActionButton(session, "clt_autoplay", label = "\u25b6 Auto-play")
    } else {
      clt_playing(TRUE)
      updateActionButton(session, "clt_autoplay", label = "\u23f8 Pause")
    }
  })

  # Timer: draw batches while playing
  observe({
    if (clt_playing()) {
      invalidateLater(600)
      isolate({
        current <- clt_means()
        if (length(current) >= 5000) {
          clt_playing(FALSE)
          updateActionButton(session, "clt_autoplay", label = "\u25b6 Auto-play")
        } else {
          batch_size <- min(input$clt_k, 5000 - length(current))
          new_means <- replicate(batch_size, mean(rpop(input$clt_n, input$clt_pop)))
          clt_means(c(current, new_means))
        }
      })
    }
  })

  output$clt_pop_plot <- renderPlotly({
    pop_data <- rpop(10000, input$clt_pop)
    brks <- seq(min(pop_data), max(pop_data), length.out = 61)
    h <- hist(pop_data, breaks = brks, plot = FALSE)
    dens <- h$density

    hover_txt <- paste0("Bin: [", round(h$breaks[-length(h$breaks)], 2), ", ",
                        round(h$breaks[-1], 2), ")",
                        "<br>Density: ", round(dens, 4))

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = h$mids, y = dens,
        marker = list(color = "#99d8c9", line = list(color = "white", width = 0.5)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE, width = diff(brks)[1]
      ) |>
      plotly::layout(
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        annotations = list(
          list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
               text = input$clt_pop, showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40), bargap = 0.02
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$clt_sampling_plot <- renderPlotly({
    means <- clt_means()
    req(length(means) > 0)
    {
      brks <- seq(min(means), max(means), length.out = 51)
      h <- hist(means, breaks = brks, plot = FALSE)
      dens <- h$density

      hover_txt <- paste0("Bin: [", round(h$breaks[-length(h$breaks)], 3), ", ",
                          round(h$breaks[-1], 3), ")",
                          "<br>Density: ", round(dens, 4))

      # Normal overlay
      x_norm <- seq(min(means), max(means), length.out = 200)
      y_norm <- dnorm(x_norm, mean(means), sd(means))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = h$mids, y = dens,
          marker = list(color = "#238b45", opacity = 0.8,
                        line = list(color = "white", width = 0.5)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE, width = diff(brks)[1]
        ) |>
        plotly::add_trace(
          x = x_norm, y = y_norm,
          type = "scatter", mode = "lines",
          line = list(color = "#e31a1c", width = 2),
          name = "Normal fit", showlegend = FALSE,
          hoverinfo = "skip"
        ) |>
        plotly::layout(
          xaxis = list(title = "Sample Mean"),
          yaxis = list(title = "Density"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = paste0(length(means), " sample means  |  n = ", input$clt_n),
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40), bargap = 0.02
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  # ── LLN ─────────────────────────────────────────────────────────────
  lln_full <- reactiveVal(NULL)
  lln_visible_n <- reactiveVal(0)
  lln_animating <- reactiveVal(FALSE)

  # Full simulation (instant)
  observeEvent(input$lln_go, {
    lln_animating(FALSE)
    updateActionButton(session, "lln_animate", label = "\u25b6 Animate")

    n <- input$lln_max_n
    set.seed(sample.int(10000, 1))
    dist <- input$lln_dist

    x <- switch(dist,
      "coin"   = rbinom(n, 1, 0.5),
      "biased" = rbinom(n, 1, 0.3),
      "die"    = sample(1:6, n, replace = TRUE),
      "exp"    = rexp(n, 1),
      "norm"   = rnorm(n, 5, 2)
    )
    true_mean <- switch(dist,
      "coin" = 0.5, "biased" = 0.3, "die" = 3.5, "exp" = 1, "norm" = 5
    )
    running_avg <- cumsum(x) / seq_along(x)
    lln_full(list(running_avg = running_avg, true_mean = true_mean, n = n))
    lln_visible_n(n)
  })

  # Animate toggle
  observeEvent(input$lln_animate, {
    if (lln_animating()) {
      lln_animating(FALSE)
      updateActionButton(session, "lln_animate", label = "\u25b6 Animate")
    } else {
      # Generate fresh data if none exists
      n <- input$lln_max_n
      set.seed(sample.int(10000, 1))
      dist <- input$lln_dist

      x <- switch(dist,
        "coin"   = rbinom(n, 1, 0.5),
        "biased" = rbinom(n, 1, 0.3),
        "die"    = sample(1:6, n, replace = TRUE),
        "exp"    = rexp(n, 1),
        "norm"   = rnorm(n, 5, 2)
      )
      true_mean <- switch(dist,
        "coin" = 0.5, "biased" = 0.3, "die" = 3.5, "exp" = 1, "norm" = 5
      )
      running_avg <- cumsum(x) / seq_along(x)
      lln_full(list(running_avg = running_avg, true_mean = true_mean, n = n))
      lln_visible_n(1)
      lln_animating(TRUE)
      updateActionButton(session, "lln_animate", label = "\u23f8 Pause")
    }
  })

  # Timer: progressively reveal line
  observe({
    if (lln_animating()) {
      invalidateLater(250)
      isolate({
        res <- lln_full()
        if (is.null(res)) {
          lln_animating(FALSE)
          return()
        }
        current_n <- lln_visible_n()
        # Reveal in accelerating steps: small at start, bigger later
        step <- max(1, floor(current_n * 0.12))
        new_n <- min(current_n + step, res$n)
        lln_visible_n(new_n)
        if (new_n >= res$n) {
          lln_animating(FALSE)
          updateActionButton(session, "lln_animate", label = "\u25b6 Animate")
        }
      })
    }
  })

  output$lln_plot <- renderPlotly({
    res <- lln_full()
    vis_n <- lln_visible_n()

    req(res, vis_n > 0)

    # Show only up to vis_n points
    show_n <- min(vis_n, res$n)
    idx <- seq_len(show_n)
    avg_show <- res$running_avg[idx]

    # Use full data range for consistent axis limits
    y_range <- range(res$running_avg)
    y_pad <- diff(y_range) * 0.1
    y_lim <- c(y_range[1] - y_pad, y_range[2] + y_pad)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = idx, y = avg_show,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 1.5),
        name = "Running average",
        hoverinfo = "text",
        text = paste0("n = ", idx, "<br>Avg = ", round(avg_show, 4))
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = 1, x1 = res$n,
          y0 = res$true_mean, y1 = res$true_mean,
          line = list(color = "#e31a1c", width = 2, dash = "dash")
        )),
        xaxis = list(title = "Number of observations (n)", range = c(0, res$n)),
        yaxis = list(title = "Running average", range = y_lim),
        annotations = list(
          list(x = res$n, y = res$true_mean, text = paste0("True \u03bc = ", res$true_mean),
               showarrow = TRUE, arrowhead = 2, ax = -50, ay = -25,
               font = list(size = 12, color = "#e31a1c")),
          list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
               text = paste0("n = ", show_n, " of ", res$n),
               showarrow = FALSE, font = list(size = 12, color = "grey50"))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Sampling Theorems", list(clt_means, lln_full, lln_visible_n))
  })
}
