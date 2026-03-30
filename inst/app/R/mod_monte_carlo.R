# ===========================================================================
# Module: Monte Carlo & Simulation
# Permutation tests, p-value estimation, simulation-based inference,
# and "what-if" scenarios
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
monte_carlo_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Monte Carlo & Simulation",
  icon = icon("dice"),
  navset_card_tab(
    id = ns("mc_tabs"),

    # ── Tab 1: Permutation Tests ───────────────────────────────────────
    nav_panel("Permutation Tests", icon = icon("shuffle"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Permutation Test",
          tags$p(class = "text-muted small mb-2",
            "Compare a parametric t-test to a permutation test.
             Permutation tests make no distributional assumptions."),
          sliderInput(ns("mc_perm_n1"), "Group 1 n", 10, 200, 30, step = 5),
          sliderInput(ns("mc_perm_n2"), "Group 2 n", 10, 200, 30, step = 5),
          sliderInput(ns("mc_perm_diff"), "True mean difference", 0, 2, 0.5, step = 0.1),
          selectInput(ns("mc_perm_dist"), "Population distribution",
            choices = c("Normal" = "normal",
                        "Skewed (exponential)" = "skewed",
                        "Heavy-tailed (t, df=3)" = "heavy",
                        "Bimodal" = "bimodal"),
            selected = "normal"),
          sliderInput(ns("mc_perm_nperms"), "Number of permutations",
                      500, 10000, 2000, step = 500),
          actionButton(ns("mc_perm_run"), "Run Test", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Permutation (Randomisation) Tests"),
          tags$p("A permutation test asks: ", tags$em("If there were truly no
                  difference between groups, how likely is a test statistic
                  as extreme as what we observed?")),
          tags$ul(
            tags$li("Shuffle group labels randomly many times."),
            tags$li("Compute the test statistic for each shuffle."),
            tags$li("The p-value = proportion of permuted statistics \u2265 observed statistic.")
          ),
          tags$p(tags$strong("Advantages:")),
          tags$ul(
            tags$li("No distributional assumptions (valid even for skewed, heavy-tailed, or small-sample data)."),
            tags$li("Exact test when all permutations are enumerated; approximate with Monte Carlo sampling."),
            tags$li("Directly tests the sharp null hypothesis of no treatment effect.")
          ),
          tags$p(tags$strong("Limitations:")),
          tags$ul(
            tags$li("Tests exchangeability under H\u2080, not a specific parametric model."),
            tags$li("Computationally intensive for large samples (but Monte Carlo approximation helps)."),
            tags$li("Does not directly give confidence intervals (though inversion is possible).")
          )
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Observed Data"),
            plotlyOutput(ns("mc_perm_data_plot"), height = "260px")
          ),
          card(
            card_header("Permutation Distribution"),
            plotlyOutput(ns("mc_perm_null_plot"), height = "260px")
          )
        ),

        card(
          card_header("Results: Parametric vs. Permutation"),
          uiOutput(ns("mc_perm_results"))
        )
      )
    ),

    # ── Tab 2: p-Value Simulation ──────────────────────────────────────
    nav_panel("p-Value Behaviour", icon = icon("chart-bar"),
      layout_sidebar(
        sidebar = sidebar(
          title = "p-Value Simulator",
          tags$p(class = "text-muted small mb-2",
            "Repeat an experiment many times and see how p-values
             distribute under the null and alternative hypotheses."),
          sliderInput(ns("mc_pval_n"), "Sample size per group", 10, 200, 30, step = 5),
          sliderInput(ns("mc_pval_effect"), "True effect size (d)", 0, 1.5, 0, step = 0.1),
          helpText(class = "small text-muted",
            "Set d = 0 for null hypothesis (should give uniform p-values)."),
          sliderInput(ns("mc_pval_nsims"), "Number of experiments", 500, 10000, 2000, step = 500),
          sliderInput(ns("mc_pval_alpha"), "\u03b1 level", 0.01, 0.10, 0.05, step = 0.01),
          actionButton(ns("mc_pval_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("How p-Values Behave"),
          tags$p("Understanding p-value distributions is crucial for interpreting
                  statistical tests:"),
          tags$ul(
            tags$li(tags$strong("Under H\u2080 (no effect):"),
              " p-values follow a Uniform(0, 1) distribution. Exactly \u03b1% of
                p-values fall below \u03b1 by chance \u2014 this IS the Type I
                error rate."),
            tags$li(tags$strong("Under H\u2081 (real effect):"),
              " p-values pile up near zero. The proportion below \u03b1 is the
                ", tags$strong("power"), " of the test."),
            tags$li(tags$strong("Bigger effect or bigger n"),
              " \u2192 more p-values near zero \u2192 higher power."),
            tags$li(tags$strong("Common misconception:"),
              " A p-value of 0.04 does NOT mean there is a 4% chance the null
                is true. It means: if H\u2080 were true, there's a 4% chance
                of data this extreme or more.")
          )
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("p-Value Distribution"),
            plotlyOutput(ns("mc_pval_hist"), height = "300px")
          ),
          card(
            card_header("Cumulative Significance"),
            plotlyOutput(ns("mc_pval_cumul"), height = "300px")
          )
        ),

        card(
          card_header("Summary"),
          uiOutput(ns("mc_pval_summary"))
        )
      )
    ),

    # ── Tab 3: Monte Carlo Integration ─────────────────────────────────
    nav_panel("MC Estimation", icon = icon("bullseye"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Monte Carlo Estimation",
          tags$p(class = "text-muted small mb-2",
            "Estimate \u03c0 and other quantities by random sampling.
             Watch the estimate converge as sample size grows."),
          selectInput(ns("mc_est_target"), "What to estimate",
            choices = c("Estimate \u03c0 (circle in square)" = "pi",
                        "Estimate an integral" = "integral",
                        "Estimate a probability" = "probability"),
            selected = "pi"),
          conditionalPanel(ns = ns, 
            condition = "input.mc_est_target == 'integral'",
            selectInput(ns("mc_est_func"), "Function to integrate (0 to 1)",
              choices = c("sin(\u03c0x)" = "sin",
                          "x\u00b2" = "x2",
                          "exp(-x\u00b2)" = "gauss",
                          "\u221a(1 \u2212 x\u00b2)" = "circle"),
              selected = "sin")
          ),
          conditionalPanel(ns = ns, 
            condition = "input.mc_est_target == 'probability'",
            tags$p(class = "text-muted small",
              "P(max of 3 standard normals > 2)"),
          ),
          sliderInput(ns("mc_est_n"), "Number of random points",
                      100, 100000, 5000, step = 500),
          actionButton(ns("mc_est_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Monte Carlo Estimation"),
          tags$p("Monte Carlo methods use random sampling to estimate
                  quantities that may be difficult to compute analytically."),
          tags$ul(
            tags$li(tags$strong("Estimating \u03c0:"),
              " Drop random points in a unit square. The fraction landing
                inside the inscribed quarter-circle \u2248 \u03c0/4."),
            tags$li(tags$strong("Integrating functions:"),
              " To estimate \u222b\u2080\u00b9 f(x)dx, sample x\u2081, ..., x\u2099
                uniformly from [0,1] and compute the average f(x\u1d62).
                By the Law of Large Numbers, this converges to the true integral."),
            tags$li(tags$strong("Estimating probabilities:"),
              " Simulate the random process many times and count how often
                the event of interest occurs.")
          ),
          tags$p(tags$strong("Convergence rate:"), " MC error shrinks as
                  1/\u221an \u2014 quadrupling the sample halves the error.
                  This is slower than many numerical methods, but MC works
                  in high dimensions where grid methods fail.")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Simulation Visualisation"),
            plotlyOutput(ns("mc_est_plot"), height = "340px")
          ),
          card(
            card_header("Convergence"),
            plotlyOutput(ns("mc_est_conv_plot"), height = "340px")
          )
        ),

        card(
          card_header("Estimate"),
          uiOutput(ns("mc_est_result"))
        )
      )
    ),

    # ── Tab 4: Power by Simulation ─────────────────────────────────────
    nav_panel("Power Simulation", icon = icon("bolt"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Simulate Power",
          tags$p(class = "text-muted small mb-2",
            "Estimate statistical power by repeating an experiment
             thousands of times and counting significant results."),
          selectInput(ns("mc_pow_test"), "Test type",
            choices = c("Two-sample t-test" = "ttest",
                        "Paired t-test" = "paired",
                        "Chi-squared (2\u00d72)" = "chisq"),
            selected = "ttest"),
          sliderInput(ns("mc_pow_effect"), "Effect size (d or w)",
                      0, 1.5, 0.5, step = 0.05),
          sliderInput(ns("mc_pow_alpha"), "\u03b1 level",
                      0.01, 0.10, 0.05, step = 0.01),
          sliderInput(ns("mc_pow_nsims"), "Simulations per n",
                      500, 5000, 1000, step = 500),
          sliderInput(ns("mc_pow_nrange"), "Sample size range",
                      10, 500, c(10, 200), step = 10),
          actionButton(ns("mc_pow_run"), "Run Power Curve",
                       class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Power Analysis by Simulation"),
          tags$p("Analytic power formulas exist for simple tests, but
                  simulation-based power is more flexible:"),
          tags$ul(
            tags$li("Works for ", tags$strong("any test"), " \u2014 even complex ones
              without closed-form power solutions."),
            tags$li("Handles non-normal data, unequal variances, missing data,
              or multi-stage designs."),
            tags$li("For each sample size: simulate data with the assumed
              effect, run the test, record if p < \u03b1. Power = proportion
              of significant results.")
          ),
          tags$p("The power curve shows how power increases with sample size.
                  The conventional target is 80% power, meaning you expect to
                  detect the effect 80% of the time if it exists."),
          tags$p("Simulation-based power analysis is especially valuable for complex
                  designs where analytic formulas do not exist or require assumptions
                  that may not hold. Examples include multilevel models, non-parametric
                  tests, mediation analyses, and designs with missing data. By simulating
                  the actual data-generating process, you obtain power estimates that
                  reflect the true complexity of your planned analysis."),
          tags$p("When conducting simulation-based power analysis, it is important to run
                  enough replications (typically 1,000\u201310,000) to ensure stable estimates.
                  The resulting power curve also reveals the sensitivity of power to sample
                  size: steep sections indicate that small increases in n yield large power
                  gains, while flat sections indicate diminishing returns.")
        ),

        card(
          card_header("Simulated Power Curve"),
          plotlyOutput(ns("mc_pow_plot"), height = "360px")
        ),

        card(
          card_header("Sample Size Recommendation"),
          uiOutput(ns("mc_pow_recommendation"))
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

monte_carlo_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 1 — Permutation Tests
  # ═══════════════════════════════════════════════════════════════════════

  mc_perm_data <- reactiveVal(NULL)
  observeEvent(input$mc_perm_run, {
    withProgress(message = "Running permutation test...", value = 0.1, {
    mc_perm_data({
    n1   <- input$mc_perm_n1
    n2   <- input$mc_perm_n2
    diff <- input$mc_perm_diff
    dist <- input$mc_perm_dist
    nperms <- input$mc_perm_nperms

    set.seed(sample.int(10000, 1))

    gen <- function(n, shift = 0) {
      switch(dist,
        "normal"  = rnorm(n, mean = shift),
        "skewed"  = rexp(n, rate = 1) - 1 + shift,
        "heavy"   = rt(n, df = 3) + shift,
        "bimodal" = {
          k <- rbinom(n, 1, 0.5)
          ifelse(k == 1, rnorm(n, -1.5, 0.7), rnorm(n, 1.5, 0.7)) + shift
        }
      )
    }

    g1 <- gen(n1, shift = 0)
    g2 <- gen(n2, shift = diff)

    obs_stat <- mean(g2) - mean(g1)

    # Parametric t-test
    ttest <- t.test(g2, g1)

    # Permutation test
    combined <- c(g1, g2)
    n_total <- n1 + n2
    perm_stats <- replicate(nperms, {
      idx <- sample(n_total)
      mean(combined[idx[1:n2]]) - mean(combined[idx[(n2+1):n_total]])
    })

    perm_p <- mean(abs(perm_stats) >= abs(obs_stat))

    setProgress(1)
    list(g1 = g1, g2 = g2, obs_stat = obs_stat,
         ttest = ttest, perm_stats = perm_stats, perm_p = perm_p,
         nperms = nperms, dist = dist)
    })
    })
  })

  output$mc_perm_data_plot <- plotly::renderPlotly({
    req(mc_perm_data())
    d <- mc_perm_data()
    d1 <- density(d$g1)
    d2 <- density(d$g2)

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$g1, histnorm = "probability density", nbinsx = 30,
        marker = list(color = "rgba(38,139,210,0.45)"),
        name = "Group 1", legendgroup = "g1"
      ) |>
      plotly::add_histogram(
        x = d$g2, histnorm = "probability density", nbinsx = 30,
        marker = list(color = "rgba(220,50,47,0.45)"),
        name = "Group 2", legendgroup = "g2"
      ) |>
      plotly::add_trace(
        x = d1$x, y = d1$y, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 1.5),
        showlegend = FALSE, legendgroup = "g1"
      ) |>
      plotly::add_trace(
        x = d2$x, y = d2$y, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 1.5),
        showlegend = FALSE, legendgroup = "g2"
      ) |>
      plotly::layout(
        barmode = "overlay",
        title = list(text = "Sample Distributions", font = list(size = 13)),
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_perm_null_plot <- plotly::renderPlotly({
    req(mc_perm_data())
    d <- mc_perm_data()

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$perm_stats, nbinsx = 50,
        marker = list(color = "rgba(147,161,161,0.6)"),
        name = "Permuted", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = d$obs_stat, x1 = d$obs_stat,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#dc322f", width = 2)),
          list(type = "line", x0 = -d$obs_stat, x1 = -d$obs_stat,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#dc322f", width = 2, dash = "dash"))
        ),
        annotations = list(list(
          x = d$obs_stat, y = 1, yref = "paper",
          text = sprintf("<b>obs = %.3f</b>", d$obs_stat),
          showarrow = FALSE, xanchor = "left", xshift = 5, yanchor = "top",
          font = list(color = "#dc322f", size = 11)
        )),
        title = list(text = "Null Distribution (permutations)", font = list(size = 13)),
        xaxis = list(title = "Permuted Mean Difference"),
        yaxis = list(title = "Count"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_perm_results <- renderUI({
    req(mc_perm_data())
    d <- mc_perm_data()

    t_p <- d$ttest$p.value
    agree <- if ((t_p < 0.05) == (d$perm_p < 0.05)) {
      '<span style="color: #2aa198;">Both tests agree on significance.</span>'
    } else {
      '<span style="color: #b58900;">Tests disagree \u2014 the non-normal distribution may affect the t-test.</span>'
    }

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm" style="max-width: 500px;">
          <thead><tr><th>Method</th><th>Statistic</th><th>p-value</th></tr></thead>
          <tbody>
            <tr><td>Welch t-test</td><td>t = %.3f</td><td>%s</td></tr>
            <tr style="background-color: rgba(42,161,152,0.08);">
                <td>Permutation test (%s perms)</td>
                <td>obs diff = %.3f</td><td>%s</td></tr>
          </tbody>
        </table>
        <p class="small mb-0">%s</p>
      </div>',
      d$ttest$statistic, format.pval(t_p, digits = 3),
      format(d$nperms, big.mark = ","), d$obs_stat,
      format.pval(d$perm_p, digits = 3), agree
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 2 — p-Value Behaviour
  # ═══════════════════════════════════════════════════════════════════════

  mc_pval_data <- reactiveVal(NULL)
  observeEvent(input$mc_pval_run, {
    withProgress(message = "Simulating p-values...", value = 0.1, {
    mc_pval_data({
    n      <- input$mc_pval_n
    effect <- input$mc_pval_effect
    nsims  <- input$mc_pval_nsims
    alpha  <- input$mc_pval_alpha

    set.seed(sample.int(10000, 1))

    pvals <- replicate(nsims, {
      g1 <- rnorm(n)
      g2 <- rnorm(n, mean = effect)
      t.test(g2, g1)$p.value
    })

    setProgress(1)
    list(pvals = pvals, effect = effect, n = n, nsims = nsims, alpha = alpha)
    })
    })
  })

  output$mc_pval_hist <- plotly::renderPlotly({
    req(mc_pval_data())
    d <- mc_pval_data()

    ttl <- if (d$effect == 0) "p-Values Under H\u2080 (no effect)"
           else sprintf("p-Values Under H\u2081 (d = %.1f)", d$effect)

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$pvals,
        xbins = list(start = 0, end = 1, size = 0.05),
        marker = list(color = "rgba(38,139,210,0.7)",
                      line = list(color = "white", width = 0.5)),
        name = "p-values", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = d$alpha, x1 = d$alpha,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#dc322f", dash = "dash", width = 2)
        )),
        annotations = list(list(
          x = d$alpha, y = 1, yref = "paper",
          text = sprintf("<b>\u03b1 = %.2f</b>", d$alpha),
          showarrow = FALSE, xanchor = "left", xshift = 5, yanchor = "top",
          font = list(color = "#dc322f", size = 11)
        )),
        title = list(text = ttl, font = list(size = 13)),
        xaxis = list(title = "p-value", dtick = 0.1, range = c(0, 1)),
        yaxis = list(title = "Count"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_pval_cumul <- plotly::renderPlotly({
    req(mc_pval_data())
    d <- mc_pval_data()

    alphas <- seq(0.001, 0.20, by = 0.001)
    prop_sig <- sapply(alphas, function(a) mean(d$pvals < a))
    cur_prop <- mean(d$pvals < d$alpha)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = c(0, 0.20), y = c(0, 0.20), type = "scatter", mode = "lines",
        line = list(color = "#93a1a1", dash = "dash", width = 1),
        name = "Expected (H\u2080)", showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::add_trace(
        x = alphas, y = prop_sig, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2),
        name = "Observed", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("\u03b1: %.3f<br>Rejection rate: %.1f%%", alphas, prop_sig * 100)
      ) |>
      plotly::add_markers(
        x = d$alpha, y = cur_prop,
        marker = list(color = "#dc322f", size = 9),
        name = "Current \u03b1", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("\u03b1 = %.2f<br>Rejection rate: %.1f%%", d$alpha, cur_prop * 100)
      ) |>
      plotly::layout(
        title = list(text = "Rejection Rate vs. \u03b1", font = list(size = 13)),
        xaxis = list(title = "\u03b1 threshold", range = c(0, 0.20)),
        yaxis = list(title = "Proportion significant", range = c(0, 1)),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_pval_summary <- renderUI({
    req(mc_pval_data())
    d <- mc_pval_data()

    prop_sig <- mean(d$pvals < d$alpha)
    is_null <- d$effect == 0

    label <- if (is_null) "Type I Error Rate" else "Estimated Power"
    col <- if (is_null && prop_sig > d$alpha + 0.02) "#dc322f"
           else if (!is_null && prop_sig < 0.80) "#b58900"
           else "#2aa198"

    note <- if (is_null) {
      sprintf("Under H\u2080, %.1f%% of p-values fell below \u03b1 = %.2f (expected: %.1f%%).",
              prop_sig * 100, d$alpha, d$alpha * 100)
    } else {
      sprintf("With d = %.1f and n = %d per group, %.1f%% of experiments detected the effect at \u03b1 = %.2f.",
              d$effect, d$n, prop_sig * 100, d$alpha)
    }

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 400px;">
          <tr><td><strong>%s</strong></td>
              <td style="font-size: 1.2em; font-weight: 700; color: %s;">%.1f%%</td></tr>
          <tr><td>Median p-value</td><td>%.4f</td></tr>
          <tr><td>Simulations</td><td>%s</td></tr>
        </table>
        <p class="text-muted small mb-0">%s</p>
      </div>',
      label, col, prop_sig * 100, median(d$pvals),
      format(d$nsims, big.mark = ","), note
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 3 — Monte Carlo Estimation
  # ═══════════════════════════════════════════════════════════════════════

  mc_est_data <- reactiveVal(NULL)
  observeEvent(input$mc_est_run, {
    withProgress(message = "Running Monte Carlo estimation...", value = 0.1, {
    mc_est_data({
    n      <- input$mc_est_n
    target <- input$mc_est_target

    set.seed(sample.int(10000, 1))

    if (target == "pi") {
      x <- runif(n)
      y <- runif(n)
      inside <- (x^2 + y^2) <= 1
      estimate <- 4 * mean(inside)
      truth <- pi
      # Convergence
      cum_est <- 4 * cumsum(inside) / seq_along(inside)

      list(target = target, x = x, y = y, inside = inside,
           estimate = estimate, truth = truth, cum_est = cum_est, n = n)

    } else if (target == "integral") {
      func <- input$mc_est_func
      x <- runif(n)
      fx <- switch(func,
        "sin"    = sin(pi * x),
        "x2"     = x^2,
        "gauss"  = exp(-x^2),
        "circle" = sqrt(1 - x^2)
      )
      estimate <- mean(fx)
      truth <- switch(func,
        "sin"    = 2 / pi,
        "x2"     = 1/3,
        "gauss"  = 0.7468241,
        "circle" = pi / 4
      )
      cum_est <- cumsum(fx) / seq_along(fx)

      list(target = target, x = x, fx = fx, func = func,
           estimate = estimate, truth = truth, cum_est = cum_est, n = n)

    } else {
      # P(max of 3 normals > 2)
      sims <- matrix(rnorm(n * 3), ncol = 3)
      maxes <- apply(sims, 1, max)
      hits <- maxes > 2
      estimate <- mean(hits)
      truth <- 1 - pnorm(2)^3
      cum_est <- cumsum(hits) / seq_along(hits)

      list(target = target, maxes = maxes, hits = hits,
           estimate = estimate, truth = truth, cum_est = cum_est, n = n)
    }
    })
    })
  })

  output$mc_est_plot <- plotly::renderPlotly({
    req(mc_est_data())
    d <- mc_est_data()

    if (d$target == "pi") {
      show_n <- min(d$n, 5000)
      cols <- ifelse(d$inside[1:show_n], "rgba(38,139,210,0.5)", "rgba(220,50,47,0.5)")
      theta <- seq(0, pi/2, length.out = 200)

      plotly::plot_ly() |>
        plotly::add_markers(
          x = d$x[1:show_n], y = d$y[1:show_n],
          marker = list(color = cols, size = 2),
          showlegend = FALSE, hoverinfo = "skip"
        ) |>
        plotly::add_trace(
          x = cos(theta), y = sin(theta), type = "scatter", mode = "lines",
          line = list(color = "#2aa198", width = 2),
          showlegend = FALSE, hoverinfo = "skip"
        ) |>
        plotly::layout(
          title = list(text = sprintf("\u03c0 \u2248 %.4f (true = %.4f)", d$estimate, d$truth),
                       font = list(size = 13)),
          xaxis = list(scaleanchor = "y", title = ""),
          yaxis = list(title = ""),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

    } else if (d$target == "integral") {
      show_n <- min(d$n, 2000)
      x_curve <- seq(0, 1, length.out = 300)
      fx_curve <- switch(d$func,
        "sin" = sin(pi * x_curve), "x2" = x_curve^2,
        "gauss" = exp(-x_curve^2), "circle" = sqrt(1 - x_curve^2)
      )

      plotly::plot_ly() |>
        plotly::add_trace(
          x = x_curve, y = fx_curve, type = "scatter", mode = "none",
          fill = "tozeroy", fillcolor = "rgba(38,139,210,0.15)",
          showlegend = FALSE, hoverinfo = "skip"
        ) |>
        plotly::add_trace(
          x = x_curve, y = fx_curve, type = "scatter", mode = "lines",
          line = list(color = "#268bd2", width = 2),
          name = "f(x)", showlegend = FALSE
        ) |>
        plotly::add_markers(
          x = d$x[1:show_n], y = d$fx[1:show_n],
          marker = list(color = "#dc322f", opacity = 0.3, size = 3),
          showlegend = FALSE, hoverinfo = "skip"
        ) |>
        plotly::layout(
          shapes = list(list(
            type = "line", x0 = 0, x1 = 1,
            y0 = d$estimate, y1 = d$estimate,
            line = list(color = "#2aa198", dash = "dash", width = 1.5)
          )),
          title = list(text = sprintf("Integral \u2248 %.5f (true = %.5f)", d$estimate, d$truth),
                       font = list(size = 13)),
          xaxis = list(title = "x"),
          yaxis = list(title = "f(x)"),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

    } else {
      hit_vals <- d$maxes[d$hits]
      miss_vals <- d$maxes[!d$hits]

      plotly::plot_ly() |>
        plotly::add_histogram(
          x = miss_vals, nbinsx = 50,
          marker = list(color = "rgba(147,161,161,0.7)"),
          name = "\u2264 2"
        ) |>
        plotly::add_histogram(
          x = hit_vals, nbinsx = 50,
          marker = list(color = "rgba(42,161,152,0.7)"),
          name = "> 2"
        ) |>
        plotly::layout(
          barmode = "stack",
          shapes = list(list(
            type = "line", x0 = 2, x1 = 2,
            y0 = 0, y1 = 1, yref = "paper",
            line = list(color = "#dc322f", dash = "dash", width = 2)
          )),
          title = list(text = sprintf("P(max > 2) \u2248 %.4f (true = %.4f)",
                                      d$estimate, d$truth),
                       font = list(size = 13)),
          xaxis = list(title = "Max of 3 Normals"),
          yaxis = list(title = "Count"),
          legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$mc_est_conv_plot <- plotly::renderPlotly({
    req(mc_est_data())
    d <- mc_est_data()

    idx <- unique(c(1, round(seq(1, d$n, length.out = min(d$n, 2000))), d$n))
    ns <- idx
    ests <- d$cum_est[idx]

    plotly::plot_ly() |>
      plotly::add_trace(
        x = ns, y = ests, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 1.5),
        name = "Estimate", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("n: %s<br>Estimate: %.5f", format(ns, big.mark = ","), ests)
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = 1, x1 = d$n,
          y0 = d$truth, y1 = d$truth,
          line = list(color = "#2aa198", dash = "dash", width = 1.5)
        )),
        annotations = list(list(
          x = d$n * 0.7, y = d$truth,
          text = sprintf("true = %.4f", d$truth),
          showarrow = FALSE, yanchor = "bottom", yshift = 5,
          font = list(color = "#2aa198", size = 11)
        )),
        title = list(text = "Convergence to True Value", font = list(size = 13)),
        xaxis = list(title = "Number of Samples"),
        yaxis = list(title = "Running Estimate"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_est_result <- renderUI({
    req(mc_est_data())
    d <- mc_est_data()

    error <- abs(d$estimate - d$truth)
    se <- error / sqrt(d$n)

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 400px;">
          <tr><td><strong>MC Estimate</strong></td>
              <td style="font-weight: 700; color: #268bd2;">%.5f</td></tr>
          <tr><td><strong>True Value</strong></td><td>%.5f</td></tr>
          <tr><td><strong>Absolute Error</strong></td><td>%.5f</td></tr>
          <tr><td><strong>Samples Used</strong></td><td>%s</td></tr>
        </table>
        <p class="text-muted small mb-0">
          MC error shrinks as 1/\u221an. To halve the error, quadruple the samples.
        </p>
      </div>',
      d$estimate, d$truth, error, format(d$n, big.mark = ",")))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 4 — Power Simulation
  # ═══════════════════════════════════════════════════════════════════════

  mc_pow_data <- reactiveVal(NULL)
  observeEvent(input$mc_pow_run, {
    withProgress(message = "Simulating power curves...", value = 0.1, {
    mc_pow_data({
    effect <- input$mc_pow_effect
    alpha  <- input$mc_pow_alpha
    nsims  <- input$mc_pow_nsims
    n_lo   <- input$mc_pow_nrange[1]
    n_hi   <- input$mc_pow_nrange[2]
    test   <- input$mc_pow_test

    set.seed(sample.int(10000, 1))

    n_vals <- seq(n_lo, n_hi, by = max(5, round((n_hi - n_lo) / 20)))

    results <- lapply(n_vals, function(n) {
      sig <- replicate(nsims, {
        if (test == "ttest") {
          g1 <- rnorm(n)
          g2 <- rnorm(n, mean = effect)
          t.test(g2, g1)$p.value < alpha
        } else if (test == "paired") {
          d_scores <- rnorm(n, mean = effect)
          t.test(d_scores)$p.value < alpha
        } else {
          # Chi-squared 2x2 with effect size w
          p1 <- 0.5 + effect / 2
          p2 <- 0.5 - effect / 2
          p1 <- max(0.01, min(0.99, p1))
          p2 <- max(0.01, min(0.99, p2))
          x <- matrix(c(
            rbinom(1, n, p1), n - rbinom(1, n, p1),
            rbinom(1, n, p2), n - rbinom(1, n, p2)
          ), nrow = 2)
          tryCatch(chisq.test(x)$p.value < alpha, error = function(e) FALSE)
        }
      })
      data.frame(n = n, power = mean(sig), se = sqrt(mean(sig) * (1 - mean(sig)) / nsims))
    })

    pow_df <- do.call(rbind, results)

    # Find n for 80% power (interpolate)
    above_80 <- pow_df$n[pow_df$power >= 0.80]
    n_80 <- if (length(above_80) > 0) min(above_80) else NA

    setProgress(1)
    list(pow_df = pow_df, effect = effect, alpha = alpha, test = test,
         nsims = nsims, n_80 = n_80)
    })
    })
  })

  output$mc_pow_plot <- plotly::renderPlotly({
    req(mc_pow_data())
    d <- mc_pow_data()
    df <- d$pow_df
    lo <- pmax(df$power - 1.96 * df$se, 0)
    hi <- pmin(df$power + 1.96 * df$se, 1)

    shapes <- list(list(
      type = "line", x0 = min(df$n), x1 = max(df$n),
      y0 = 0.80, y1 = 0.80,
      line = list(color = "#b58900", dash = "dash", width = 1.5)
    ))
    annotations <- list(list(
      x = min(df$n), y = 0.82,
      text = "80% power", showarrow = FALSE, xanchor = "left",
      font = list(color = "#b58900", size = 11)
    ))
    if (!is.na(d$n_80)) {
      shapes <- c(shapes, list(list(
        type = "line", x0 = d$n_80, x1 = d$n_80, y0 = 0, y1 = 1,
        line = list(color = "#2aa198", dash = "dot", width = 1.5)
      )))
    }

    plotly::plot_ly() |>
      plotly::add_trace(
        x = c(df$n, rev(df$n)), y = c(hi, rev(lo)),
        type = "scatter", mode = "none",
        fill = "toself", fillcolor = "rgba(38,139,210,0.15)",
        showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::add_trace(
        x = df$n, y = df$power, type = "scatter", mode = "lines+markers",
        line = list(color = "#268bd2", width = 2),
        marker = list(color = "#268bd2", size = 5),
        name = "Power", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("n = %d<br>Power: %.1f%%<br>95%% CI: [%.1f%%, %.1f%%]",
                            df$n, df$power * 100, lo * 100, hi * 100)
      ) |>
      plotly::layout(
        shapes = shapes,
        annotations = annotations,
        title = list(
          text = sprintf("Simulated Power Curve (d = %.2f, \u03b1 = %.2f)<br><sup>Based on %s simulations per sample size</sup>",
                         d$effect, d$alpha, format(d$nsims, big.mark = ",")),
          font = list(size = 14)),
        xaxis = list(title = "Sample Size (per group)"),
        yaxis = list(title = "Power", tickformat = ".0%", range = c(0, 1)),
        margin = list(t = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mc_pow_recommendation <- renderUI({
    req(mc_pow_data())
    d <- mc_pow_data()

    test_label <- switch(d$test,
      "ttest" = "two-sample t-test",
      "paired" = "paired t-test",
      "chisq" = "chi-squared test (2\u00d72)"
    )

    if (!is.na(d$n_80)) {
      msg <- sprintf("To achieve 80%% power for a %s with effect size = %.2f
                      at \u03b1 = %.2f, you need approximately <strong
                      style='color: #2aa198; font-size: 1.1em;'>n = %d per group</strong>.",
                     test_label, d$effect, d$alpha, d$n_80)
    } else {
      msg <- sprintf("80%% power was not reached in the tested range. Try a
                      larger sample size range or a larger effect size.")
    }

    # Power at edges
    pow_lo <- d$pow_df$power[1]
    pow_hi <- d$pow_df$power[nrow(d$pow_df)]

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <p>%s</p>
        <table class="table table-sm mb-2" style="max-width: 400px;">
          <tr><td>Power at n = %d</td><td>%.1f%%</td></tr>
          <tr><td>Power at n = %d</td><td>%.1f%%</td></tr>
        </table>
        <p class="text-muted small mb-0">These estimates are based on simulation
          and may vary slightly between runs.</p>
      </div>',
      msg, d$pow_df$n[1], pow_lo * 100,
      d$pow_df$n[nrow(d$pow_df)], pow_hi * 100
    ))
  })


  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Monte Carlo & Simulation", list(mc_perm_data, mc_pval_data, mc_est_data, mc_pow_data))
  })
}
