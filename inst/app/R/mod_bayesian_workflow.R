# ===========================================================================
# Module: Bayesian Workflow
# Prior sensitivity, MCMC intuition, posterior predictive checks,
# credible intervals
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
bayesian_workflow_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Bayesian Workflow",
  icon = icon("chart-pie"),
  navset_card_tab(
    id = ns("bw_tabs"),

    # ── Tab 1: Prior Sensitivity ───────────────────────────────────────
    nav_panel("Prior Sensitivity", icon = icon("sliders"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Prior vs. Likelihood",
          tags$p(class = "text-muted small mb-2",
            "See how different priors combine with observed data to produce
             different posterior distributions for a proportion."),
          tags$h6("Observed Data"),
          sliderInput(ns("bw_ps_successes"), "Successes (k)", 0, 100, 7, step = 1),
          sliderInput(ns("bw_ps_trials"), "Trials (n)", 1, 200, 20, step = 1),
          tags$hr(),
          tags$h6("Prior 1 (blue)"),
          sliderInput(ns("bw_ps_a1"), "Beta \u03b1\u2081", 0.1, 20, 1, step = 0.1),
          sliderInput(ns("bw_ps_b1"), "Beta \u03b2\u2081", 0.1, 20, 1, step = 0.1),
          tags$hr(),
          tags$h6("Prior 2 (red)"),
          sliderInput(ns("bw_ps_a2"), "Beta \u03b1\u2082", 0.1, 20, 5, step = 0.1),
          sliderInput(ns("bw_ps_b2"), "Beta \u03b2\u2082", 0.1, 20, 5, step = 0.1),
          tags$hr(),
          tags$h6("Prior 3 (green)"),
          sliderInput(ns("bw_ps_a3"), "Beta \u03b1\u2083", 0.1, 20, 0.5, step = 0.1),
          sliderInput(ns("bw_ps_b3"), "Beta \u03b2\u2083", 0.1, 20, 0.5, step = 0.1)
        ),

        explanation_box(
          tags$strong("Prior Sensitivity Analysis"),
          tags$p("In Bayesian inference, the posterior is proportional to the
                  likelihood times the prior:"),
          tags$p(tags$code("Posterior \u221d Likelihood \u00d7 Prior")),
          tags$p("For a binomial likelihood with a Beta prior, the posterior
                  is also Beta (conjugate):"),
          tags$p(tags$code("Beta(\u03b1 + k, \u03b2 + n \u2212 k)")),
          tags$ul(
            tags$li(tags$strong("Flat/uniform prior"), " Beta(1,1): lets the data speak entirely."),
            tags$li(tags$strong("Informative prior"), " (e.g., Beta(5,5)): centres on 0.5 with some certainty."),
            tags$li(tags$strong("Jeffreys prior"), " Beta(0.5,0.5): non-informative reference prior."),
            tags$li("With ", tags$strong("little data"), ", the prior dominates. With ",
              tags$strong("lots of data"), ", the likelihood overwhelms the prior and all posteriors converge.")
          ),
          tags$p("Sensitivity analysis checks whether substantive conclusions
                  change across reasonable priors. If they do, more data or
                  a justified prior is needed.")
        ),

        card(
          card_header("Prior, Likelihood & Posterior"),
          plotlyOutput(ns("bw_ps_plot"), height = "380px")
        ),

        card(
          card_header("Posterior Summaries"),
          uiOutput(ns("bw_ps_table"))
        )
      )
    ),

    # ── Tab 2: MCMC Intuition ──────────────────────────────────────────
    nav_panel("MCMC Intuition", icon = icon("random"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Metropolis-Hastings",
          tags$p(class = "text-muted small mb-2",
            "Watch a Metropolis-Hastings sampler explore a target distribution.
             See trace plots, acceptance rates, and the effect of proposal width."),
          selectInput(ns("bw_mcmc_target"), "Target distribution",
            choices = c("Normal(0, 1)" = "normal",
                        "Bimodal mixture" = "bimodal",
                        "Skewed (Gamma)" = "skewed"),
            selected = "normal"),
          sliderInput(ns("bw_mcmc_proposal_sd"), "Proposal SD (\u03c3)",
                      0.05, 5, 1, step = 0.05),
          helpText(class = "small text-muted",
            "Too small \u2192 slow exploration, high acceptance.
             Too large \u2192 many rejections, stuck in place."),
          sliderInput(ns("bw_mcmc_n"), "Number of iterations",
                      500, 20000, 5000, step = 500),
          sliderInput(ns("bw_mcmc_burnin"), "Burn-in (discard first n)",
                      0, 5000, 500, step = 100),
          actionButton(ns("bw_mcmc_run"), "Run Sampler", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Markov Chain Monte Carlo (MCMC)"),
          tags$p("MCMC algorithms generate samples from a target distribution
                  that may be difficult to sample from directly. The Metropolis-
                  Hastings algorithm:"),
          tags$ul(
            tags$li("1. Start at some value \u03b8\u2080."),
            tags$li("2. Propose a new value \u03b8* from a proposal distribution
              (e.g., Normal(\u03b8\u209c, \u03c3))."),
            tags$li("3. Calculate the acceptance ratio:
              r = p(\u03b8*) / p(\u03b8\u209c)."),
            tags$li("4. Accept \u03b8* with probability min(1, r); otherwise stay at \u03b8\u209c."),
            tags$li("5. Repeat.")
          ),
          tags$p(tags$strong("Key diagnostics:")),
          tags$ul(
            tags$li(tags$strong("Trace plot:"), " Should look like a \u2018hairy caterpillar\u2019 \u2014
              mixing well across the support."),
            tags$li(tags$strong("Acceptance rate:"), " Optimal is ~23% for
              high-dimensional targets, ~44% for 1D. Too high or too low
              means the proposal SD needs adjusting."),
            tags$li(tags$strong("Burn-in:"), " Discard early samples before
              the chain has converged to the stationary distribution."),
            tags$li(tags$strong("Autocorrelation:"), " High autocorrelation
              means the chain is moving slowly and effective sample size is low.")
          ),
          tags$p("MCMC is the computational backbone of modern Bayesian statistics.
                  While the Metropolis-Hastings algorithm is the simplest version,
                  production tools like Stan use Hamiltonian Monte Carlo (HMC), which
                  uses gradient information to explore the posterior much more efficiently.
                  Understanding the basic MH algorithm builds intuition for why tuning
                  parameters matter and what can go wrong."),
          tags$p("Convergence diagnostics should be checked for every Bayesian analysis.
                  Running multiple chains from different starting values and checking that
                  they converge to the same distribution (R-hat \u2248 1.0) is standard
                  practice. If chains disagree, the sampler has not explored the posterior
                  adequately, and the results should not be trusted.")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Trace Plot"),
            plotlyOutput(ns("bw_mcmc_trace"), height = "260px")
          ),
          card(
            card_header("Posterior Histogram vs. Target"),
            plotlyOutput(ns("bw_mcmc_hist"), height = "260px")
          )
        ),

        card(
          card_header("MCMC Diagnostics"),
          uiOutput(ns("bw_mcmc_diagnostics"))
        )
      )
    ),

    # ── Tab 3: Posterior Predictive Check ──────────────────────────────
    nav_panel("Posterior Predictive", icon = icon("magnifying-glass-chart"),
      layout_sidebar(
        sidebar = sidebar(
          title = "PPC Setup",
          tags$p(class = "text-muted small mb-2",
            "Generate data from a known model, fit a Bayesian model,
             and check if simulated replications look like the observed data."),
          selectInput(ns("bw_ppc_true_model"), "True data-generating model",
            choices = c("Normal" = "normal",
                        "Poisson" = "poisson",
                        "Overdispersed (Neg. Binomial)" = "negbin"),
            selected = "normal"),
          selectInput(ns("bw_ppc_fit_model"), "Fitted model",
            choices = c("Normal" = "normal",
                        "Poisson" = "poisson"),
            selected = "normal"),
          sliderInput(ns("bw_ppc_n"), "Sample size", 30, 500, 100, step = 10),
          sliderInput(ns("bw_ppc_nrep"), "Number of replications", 50, 500, 200, step = 50),
          actionButton(ns("bw_ppc_run"), "Generate & Check", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Posterior Predictive Checks (PPC)"),
          tags$p("PPC asks: ", tags$em("If our model is correct, could it have
                  generated data that looks like what we observed?")),
          tags$ul(
            tags$li("Draw parameter values \u03b8* from the posterior distribution."),
            tags$li("For each \u03b8*, simulate a new dataset y* of the same size."),
            tags$li("Compare the distribution of y* (or a summary statistic of y*)
              to the observed data y.")
          ),
          tags$p(tags$strong("If the model fits well:"), " Replicated datasets
                  should resemble the observed data. The observed summary
                  statistic should fall within the distribution of replicated
                  statistics."),
          tags$p(tags$strong("Bayesian p-value:"), " The proportion of replications
                  where the test statistic exceeds the observed value. Values
                  near 0 or 1 indicate model misfit. Values near 0.5 are ideal.")
        ),

        card(
          card_header("Observed vs. Replicated Data"),
          plotlyOutput(ns("bw_ppc_overlay"), height = "320px")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Mean of Replications"),
            plotlyOutput(ns("bw_ppc_mean_plot"), height = "260px")
          ),
          card(
            card_header("SD of Replications"),
            plotlyOutput(ns("bw_ppc_sd_plot"), height = "260px")
          )
        ),

        card(
          card_header("PPC Summary"),
          uiOutput(ns("bw_ppc_summary"))
        )
      )
    ),

    # ── Tab 4: Credible Intervals ──────────────────────────────────────
    nav_panel("Credible vs. Confidence", icon = icon("arrows-left-right"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Interval Comparison",
          tags$p(class = "text-muted small mb-2",
            "Compare Bayesian credible intervals to frequentist confidence
             intervals through repeated sampling."),
          sliderInput(ns("bw_ci_true_p"), "True proportion (\u03b8)",
                      0.05, 0.95, 0.35, step = 0.05),
          sliderInput(ns("bw_ci_n"), "Sample size per experiment", 10, 200, 30, step = 5),
          sliderInput(ns("bw_ci_nsims"), "Number of experiments", 20, 200, 50, step = 10),
          sliderInput(ns("bw_ci_level"), "Interval level",
                      0.80, 0.99, 0.95, step = 0.01),
          selectInput(ns("bw_ci_prior"), "Prior for credible interval",
            choices = c("Flat: Beta(1,1)" = "flat",
                        "Jeffreys: Beta(0.5,0.5)" = "jeffreys",
                        "Informative: Beta(5,5)" = "informative"),
            selected = "flat"),
          actionButton(ns("bw_ci_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Credible Intervals vs. Confidence Intervals"),
          tags$p("Both give an interval for a parameter, but they answer
                  different questions:"),
          tags$ul(
            tags$li(tags$strong("95% Confidence Interval (frequentist):"),
              " If we repeated the experiment infinitely, 95% of CIs would
                contain the true value. Any single CI either does or doesn't."),
            tags$li(tags$strong("95% Credible Interval (Bayesian):"),
              " Given the data and prior, there is a 95% probability that the
                parameter falls in this interval. This is the intuitive
                interpretation people often (wrongly) give to CIs.")
          ),
          tags$p(tags$strong("Types of credible intervals:")),
          tags$ul(
            tags$li(tags$strong("Equal-tailed:"), " Cuts off \u03b1/2 from each tail of the posterior."),
            tags$li(tags$strong("HPD (Highest Posterior Density):"),
              " The narrowest interval containing 95% of the posterior mass.
                Preferred when the posterior is skewed.")
          ),
          tags$p("With flat priors and large samples, the two intervals
                  often nearly coincide. Differences emerge with small samples
                  or informative priors. The practical distinction matters most when
                  making decisions based on intervals: a Bayesian credible interval
                  directly answers \u201cwhat is the probability that the parameter is
                  in this range?\u201d, while a frequentist CI answers \u201chow often would
                  this procedure capture the true value?\u201d"),
          tags$p("The HPD interval is generally preferred over the equal-tailed interval
                  because it is the shortest interval with the desired coverage. For
                  symmetric posteriors, both coincide. For skewed posteriors (common with
                  variance parameters, odds ratios, or small-sample estimates), the HPD
                  interval can be substantially shorter and provides a more informative
                  summary of posterior uncertainty."),
          tags$p("A common misconception is that Bayesian and frequentist methods must
                  disagree. In many routine applications with moderate sample sizes and
                  weak priors, the two frameworks produce nearly identical intervals and
                  conclusions. The differences become important in small-sample settings,
                  when incorporating prior knowledge is valuable, or when direct probability
                  statements about parameters are needed for decision-making.")
        ),

        card(
          card_header("Interval Comparison (repeated experiments)"),
          plotlyOutput(ns("bw_ci_plot"), height = "500px")
        ),

        card(
          card_header("Coverage Summary"),
          uiOutput(ns("bw_ci_summary"))
        )
      )
    ),

    # ── Tab 5: Bayesian Model Comparison ───────────────────────────────────
    nav_panel("Model Comparison", icon = icon("scale-balanced"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Model Comparison Controls",
          tags$p(class = "text-muted small mb-2",
            "Compare models using Bayes factors and LOO-CV on simulated regression data."),
          sliderInput(ns("bmc_n"), "Sample size n", 30, 300, 100, 10),
          sliderInput(ns("bmc_true_b"), "True slope \u03b2\u2081", -1.5, 1.5, 0.6, 0.1),
          selectInput(ns("bmc_compare"), "Models to compare",
            choices = c("Linear vs. Null (intercept only)",
                        "Linear vs. Quadratic",
                        "Linear vs. Cubic"),
            selected = "Linear vs. Null (intercept only)"),
          sliderInput(ns("bmc_noise"), "Residual SD", 0.3, 3, 1, 0.1),
          tags$hr(),
          sliderInput(ns("bmc_prior_sd"), "Prior SD on coefficients", 0.1, 5, 1, 0.1),
          actionButton(ns("bmc_go"), "Simulate & Compare", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        accordion(
          class = "border-info mb-3",
          open = FALSE,
          accordion_panel(
            title = tagList(icon("circle-info"), " ", tags$strong("Bayesian Model Comparison")),
            value = "explanation",
            div(style = "font-size: 0.95rem;",
              tags$p("Three complementary approaches to comparing Bayesian models:"),
              tags$ul(
                tags$li(tags$strong("Bayes Factor (BF\u2081\u2080)"), " = P(data | M\u2081) / P(data | M\u2080).
                        BF > 3: moderate evidence for M\u2081; BF > 10: strong; BF > 100: decisive.
                        BF is sensitive to prior specification."),
                tags$li(tags$strong("LOO-CV"), " (Leave-One-Out Cross-Validation) \u2014 estimated
                        via PSIS (Pareto-smoothed importance sampling). Measures out-of-sample
                        predictive accuracy. Lower LOO loss (or higher ELPD) is better.
                        LOO difference \u00b1 SE indicates significance."),
                tags$li(tags$strong("WAIC"), " (Widely Applicable IC) \u2014 similar to AIC but
                        uses full posterior. Asymptotically equivalent to LOO-CV under weak
                        conditions. Lower is better.")
              ),
              tags$p("BIC-based Bayes factor approximation: BF\u2081\u2080 \u2248 exp(\u2212\u00bdBIC\u2081 + \u00bdBIC\u2080).
                      This is exact under unit-information priors and large n."),
              accordion(
                class = "mt-2", open = FALSE,
                accordion_panel(
                  title = tagList(icon("circle-question"), " Step-by-step guide"),
                  value = "guide",
                  tags$ol(
                    tags$li("Set a true slope and noise level. Click 'Simulate & Compare'."),
                    tags$li("With a large true slope, BF strongly favours the linear model."),
                    tags$li("Near \u03b2 = 0, the null model may be preferred."),
                    tags$li("Compare BF, LOO-CV, and BIC-based rankings \u2014 they usually agree."),
                    tags$li("Try 'Linear vs. Quadratic' with a truly linear DGP.")
                  )
                )
              )
            )
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Data + Model Fits"),
               plotlyOutput(ns("bmc_fit_plot"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Bayes Factor Scale"), plotlyOutput(ns("bmc_bf_plot"), height = "260px")),
            card(card_header("Model Comparison Summary"), tableOutput(ns("bmc_table")))
          )
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

bayesian_workflow_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 1 — Prior Sensitivity
  # ═══════════════════════════════════════════════════════════════════════

  output$bw_ps_plot <- plotly::renderPlotly({
    k <- input$bw_ps_successes
    n <- input$bw_ps_trials
    k <- min(k, n)

    x <- seq(0.001, 0.999, length.out = 500)
    lik <- dbeta(x, k + 1, n - k + 1)
    lik_scaled <- lik / max(lik)

    priors <- list(
      list(a = input$bw_ps_a1, b = input$bw_ps_b1, col = "#268bd2", lbl = "Prior 1"),
      list(a = input$bw_ps_a2, b = input$bw_ps_b2, col = "#dc322f", lbl = "Prior 2"),
      list(a = input$bw_ps_a3, b = input$bw_ps_b3, col = "#859900", lbl = "Prior 3")
    )

    p <- plotly::plot_ly() |>
      plotly::add_trace(
        x = x, y = lik_scaled, type = "scatter", mode = "lines",
        line = list(color = "#b58900", width = 2, dash = "dot"),
        name = "Likelihood"
      )

    for (pr in priors) {
      prior_d <- dbeta(x, pr$a, pr$b)
      post_d  <- dbeta(x, pr$a + k, pr$b + n - k)
      p <- p |>
        plotly::add_trace(
          x = x, y = prior_d / max(prior_d), type = "scatter", mode = "lines",
          line = list(color = pr$col, width = 1.5, dash = "dash"),
          name = paste0(pr$lbl, " prior"), legendgroup = pr$lbl
        ) |>
        plotly::add_trace(
          x = x, y = post_d / max(post_d), type = "scatter", mode = "lines",
          line = list(color = pr$col, width = 2),
          name = paste0(pr$lbl, " posterior"), legendgroup = pr$lbl
        )
    }

    p |> plotly::layout(
      title = list(
        text = sprintf("Data: %d successes in %d trials (MLE = %.2f)",
                       k, n, k / max(n, 1)),
        font = list(size = 14)),
      xaxis = list(title = "\u03b8 (proportion)"),
      yaxis = list(title = "Scaled Density"),
      legend = list(font = list(size = 10)),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_ps_table <- renderUI({
    k <- min(input$bw_ps_successes, input$bw_ps_trials)
    n <- input$bw_ps_trials
    level <- 0.95

    priors <- list(
      list(a = input$bw_ps_a1, b = input$bw_ps_b1, lbl = "Prior 1", col = "#268bd2"),
      list(a = input$bw_ps_a2, b = input$bw_ps_b2, lbl = "Prior 2", col = "#dc322f"),
      list(a = input$bw_ps_a3, b = input$bw_ps_b3, lbl = "Prior 3", col = "#859900")
    )

    rows <- ""
    for (p in priors) {
      post_a <- p$a + k
      post_b <- p$b + n - k
      post_mean <- post_a / (post_a + post_b)
      post_med  <- qbeta(0.5, post_a, post_b)
      ci_lo <- qbeta((1 - level) / 2, post_a, post_b)
      ci_hi <- qbeta(1 - (1 - level) / 2, post_a, post_b)

      rows <- paste0(rows, sprintf(
        '<tr><td style="color: %s; font-weight:600;">%s</td>
         <td>Beta(%.1f, %.1f)</td><td>Beta(%.1f, %.1f)</td>
         <td>%.3f</td><td>%.3f</td><td>[%.3f, %.3f]</td></tr>',
        p$col, p$lbl, p$a, p$b, post_a, post_b,
        post_mean, post_med, ci_lo, ci_hi
      ))
    }

    # MLE row
    mle <- k / max(n, 1)
    se <- sqrt(mle * (1 - mle) / max(n, 1))
    rows <- paste0(rows, sprintf(
      '<tr class="table-secondary"><td>MLE (freq.)</td><td>\u2014</td><td>\u2014</td>
       <td>%.3f</td><td>\u2014</td><td>[%.3f, %.3f]</td></tr>',
      mle, max(mle - 1.96 * se, 0), min(mle + 1.96 * se, 1)
    ))

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Prior</th><th>Prior Dist</th><th>Posterior Dist</th>
                     <th>Post. Mean</th><th>Post. Median</th><th>95%% CrI</th></tr></thead>
          <tbody>%s</tbody>
        </table>
      </div>', rows))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 2 — MCMC Intuition
  # ═══════════════════════════════════════════════════════════════════════

  bw_mcmc_data <- reactiveVal(NULL)
  observeEvent(input$bw_mcmc_run, {
    bw_mcmc_data({
    target  <- input$bw_mcmc_target
    prop_sd <- input$bw_mcmc_proposal_sd
    n_iter  <- input$bw_mcmc_n
    burnin  <- input$bw_mcmc_burnin

    set.seed(sample.int(10000, 1))

    # Target log-density
    log_target <- switch(target,
      "normal"  = function(x) dnorm(x, 0, 1, log = TRUE),
      "bimodal" = function(x) log(0.5 * dnorm(x, -2, 0.8) + 0.5 * dnorm(x, 2, 0.8)),
      "skewed"  = function(x) dgamma(x, shape = 3, rate = 1, log = TRUE)
    )

    # Starting value
    chain <- numeric(n_iter)
    chain[1] <- if (target == "skewed") 3 else 0
    accepted <- 0

    for (i in 2:n_iter) {
      proposal <- chain[i - 1] + rnorm(1, sd = prop_sd)
      log_ratio <- log_target(proposal) - log_target(chain[i - 1])
      if (!is.na(log_ratio) && !is.infinite(log_ratio) && log(runif(1)) < log_ratio) {
        chain[i] <- proposal
        accepted <- accepted + 1
      } else {
        chain[i] <- chain[i - 1]
      }
    }

    acc_rate <- accepted / (n_iter - 1)
    post_chain <- chain[(burnin + 1):n_iter]

    # Effective sample size (simple lag-1 autocorrelation method)
    if (length(post_chain) > 10) {
      ac1 <- cor(post_chain[-length(post_chain)], post_chain[-1])
      ess <- length(post_chain) * (1 - ac1) / (1 + ac1)
      ess <- max(1, ess)
    } else {
      ess <- length(post_chain)
      ac1 <- NA
    }

    list(chain = chain, post_chain = post_chain, target = target,
         acc_rate = acc_rate, n_iter = n_iter, burnin = burnin,
         prop_sd = prop_sd, ess = ess, ac1 = ac1)
    })
  })

  output$bw_mcmc_trace <- plotly::renderPlotly({
    req(bw_mcmc_data())
    d <- bw_mcmc_data()

    # Thin for performance
    n_iter <- length(d$chain)
    if (n_iter > 3000) {
      idx <- unique(c(1, round(seq(1, n_iter, length.out = 3000)), n_iter))
    } else {
      idx <- seq_len(n_iter)
    }

    plotly::plot_ly() |>
      plotly::add_trace(
        x = idx, y = d$chain[idx], type = "scatter", mode = "lines",
        line = list(color = "rgba(38,139,210,0.7)", width = 0.8),
        name = "Chain", showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = d$burnin, x1 = d$burnin,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#dc322f", dash = "dash", width = 1.5)
        )),
        title = list(text = "Trace Plot", font = list(size = 13)),
        xaxis = list(title = "Iteration"),
        yaxis = list(title = "\u03b8"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_mcmc_hist <- plotly::renderPlotly({
    req(bw_mcmc_data())
    d <- bw_mcmc_data()

    x_range <- range(d$post_chain)
    x_seq <- seq(x_range[1] - 1, x_range[2] + 1, length.out = 300)
    true_dens <- switch(d$target,
      "normal"  = dnorm(x_seq, 0, 1),
      "bimodal" = 0.5 * dnorm(x_seq, -2, 0.8) + 0.5 * dnorm(x_seq, 2, 0.8),
      "skewed"  = dgamma(x_seq, shape = 3, rate = 1)
    )

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$post_chain, histnorm = "probability density", nbinsx = 60,
        marker = list(color = "rgba(38,139,210,0.5)"),
        name = "MCMC samples", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = x_seq, y = true_dens, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2),
        name = "Target density", showlegend = FALSE
      ) |>
      plotly::layout(
        title = list(text = "MCMC Samples vs. Target", font = list(size = 13)),
        xaxis = list(title = "\u03b8"),
        yaxis = list(title = "Density"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_mcmc_diagnostics <- renderUI({
    req(bw_mcmc_data())
    d <- bw_mcmc_data()

    acc_col <- if (d$acc_rate > 0.15 && d$acc_rate < 0.55) "#2aa198" else "#dc322f"
    acc_note <- if (d$acc_rate < 0.15) "Too low \u2014 increase proposal SD"
                else if (d$acc_rate > 0.55) "Too high \u2014 decrease proposal SD"
                else "Good range"

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 450px;">
          <tr><td><strong>Acceptance rate</strong></td>
              <td style="color: %s; font-weight:600;">%.1f%% (%s)</td></tr>
          <tr><td><strong>Proposal SD</strong></td><td>%.2f</td></tr>
          <tr><td><strong>Total iterations</strong></td><td>%s</td></tr>
          <tr><td><strong>After burn-in</strong></td><td>%s</td></tr>
          <tr><td><strong>Lag-1 autocorrelation</strong></td><td>%.3f</td></tr>
          <tr><td><strong>Effective sample size</strong></td><td>%.0f</td></tr>
          <tr><td><strong>Posterior mean</strong></td><td>%.3f</td></tr>
          <tr><td><strong>Posterior SD</strong></td><td>%.3f</td></tr>
        </table>
        <p class="text-muted small mb-0">
          Optimal acceptance rate: ~44%% for 1D, ~23%% for high dimensions.
          Adjust proposal SD to improve mixing.
        </p>
      </div>',
      acc_col, d$acc_rate * 100, acc_note, d$prop_sd,
      format(d$n_iter, big.mark = ","),
      format(length(d$post_chain), big.mark = ","),
      ifelse(is.na(d$ac1), NA, d$ac1), d$ess,
      mean(d$post_chain), sd(d$post_chain)
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 3 — Posterior Predictive Checks
  # ═══════════════════════════════════════════════════════════════════════

  bw_ppc_data <- reactiveVal(NULL)
  observeEvent(input$bw_ppc_run, {
    bw_ppc_data({
    true_model <- input$bw_ppc_true_model
    fit_model  <- input$bw_ppc_fit_model
    n          <- input$bw_ppc_n
    nrep       <- input$bw_ppc_nrep

    set.seed(sample.int(10000, 1))

    # Generate observed data
    y_obs <- switch(true_model,
      "normal"  = rnorm(n, mean = 5, sd = 2),
      "poisson" = rpois(n, lambda = 5),
      "negbin"  = rnbinom(n, size = 3, mu = 5)
    )

    # Fit model and generate replications
    if (fit_model == "normal") {
      # Conjugate normal: known variance approximation
      y_bar <- mean(y_obs)
      s2 <- var(y_obs)
      y_rep <- matrix(nrow = nrep, ncol = n)
      for (i in 1:nrep) {
        mu_draw <- rnorm(1, y_bar, sqrt(s2 / n))
        sd_draw <- sqrt(s2)
        y_rep[i, ] <- rnorm(n, mu_draw, sd_draw)
      }
    } else {
      # Poisson with Gamma(0.1, 0.1) prior
      a_post <- 0.1 + sum(y_obs)
      b_post <- 0.1 + n
      y_rep <- matrix(nrow = nrep, ncol = n)
      for (i in 1:nrep) {
        lam_draw <- rgamma(1, a_post, b_post)
        y_rep[i, ] <- rpois(n, lam_draw)
      }
    }

    # Summary statistics
    obs_mean <- mean(y_obs)
    obs_sd   <- sd(y_obs)
    rep_means <- rowMeans(y_rep)
    rep_sds   <- apply(y_rep, 1, sd)

    pval_mean <- mean(rep_means >= obs_mean)
    pval_sd   <- mean(rep_sds >= obs_sd)

    list(y_obs = y_obs, y_rep = y_rep, n = n, nrep = nrep,
         true_model = true_model, fit_model = fit_model,
         obs_mean = obs_mean, obs_sd = obs_sd,
         rep_means = rep_means, rep_sds = rep_sds,
         pval_mean = pval_mean, pval_sd = pval_sd)
    })
  })

  output$bw_ppc_overlay <- plotly::renderPlotly({
    req(bw_ppc_data())
    d <- bw_ppc_data()
    n_show <- min(d$nrep, 50)

    p <- plotly::plot_ly()

    # Replication density curves
    for (i in 1:n_show) {
      rep_d <- density(d$y_rep[i, ])
      p <- p |> plotly::add_trace(
        x = rep_d$x, y = rep_d$y, type = "scatter", mode = "lines",
        line = list(color = "rgba(147,161,161,0.2)", width = 0.5),
        showlegend = (i == 1), name = "Replications",
        legendgroup = "rep", hoverinfo = "skip"
      )
    }

    # Observed data
    obs_d <- density(d$y_obs)
    p |>
      plotly::add_histogram(
        x = d$y_obs, histnorm = "probability density", nbinsx = 30,
        marker = list(color = "rgba(38,139,210,0.5)"),
        name = "Observed (hist)", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = obs_d$x, y = obs_d$y, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2.5),
        name = "Observed"
      ) |>
      plotly::layout(
        title = list(
          text = sprintf("Observed (blue) vs. %d Replications (grey)<br><sup>True DGP: %s | Fitted: %s</sup>",
                         n_show, d$true_model, d$fit_model),
          font = list(size = 14)),
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_ppc_mean_plot <- plotly::renderPlotly({
    req(bw_ppc_data())
    d <- bw_ppc_data()

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$rep_means, nbinsx = 40,
        marker = list(color = "rgba(147,161,161,0.6)"),
        name = "Replicated means", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = d$obs_mean, x1 = d$obs_mean,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#268bd2", width = 2)
        )),
        title = list(text = sprintf("Bayesian p-value (mean) = %.3f", d$pval_mean),
                     font = list(size = 13)),
        xaxis = list(title = "Mean of Replications"),
        yaxis = list(title = "Count"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_ppc_sd_plot <- plotly::renderPlotly({
    req(bw_ppc_data())
    d <- bw_ppc_data()

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = d$rep_sds, nbinsx = 40,
        marker = list(color = "rgba(147,161,161,0.6)"),
        name = "Replicated SDs", showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = d$obs_sd, x1 = d$obs_sd,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#dc322f", width = 2)
        )),
        title = list(text = sprintf("Bayesian p-value (SD) = %.3f", d$pval_sd),
                     font = list(size = 13)),
        xaxis = list(title = "SD of Replications"),
        yaxis = list(title = "Count"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_ppc_summary <- renderUI({
    req(bw_ppc_data())
    d <- bw_ppc_data()

    misfit_mean <- d$pval_mean < 0.025 || d$pval_mean > 0.975
    misfit_sd   <- d$pval_sd < 0.025 || d$pval_sd > 0.975

    mean_col <- if (misfit_mean) "#dc322f" else "#2aa198"
    sd_col   <- if (misfit_sd)   "#dc322f" else "#2aa198"

    mismatch <- d$true_model != d$fit_model &&
      !(d$true_model == "poisson" && d$fit_model == "poisson")

    note <- if (misfit_mean || misfit_sd) {
      "The model shows signs of misfit. The replicated data do not resemble the observed data on at least one statistic."
    } else {
      "The model passes these posterior predictive checks \u2014 replicated data resemble the observed data."
    }

    if (d$true_model == "negbin" && d$fit_model == "poisson") {
      note <- paste(note, "The Poisson model cannot capture the overdispersion in the negative binomial data \u2014 the SD check should show misfit.")
    }

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 450px;">
          <tr><td>True DGP</td><td>%s</td></tr>
          <tr><td>Fitted model</td><td>%s</td></tr>
          <tr><td><strong>p-value (mean)</strong></td>
              <td style="color: %s; font-weight:600;">%.3f %s</td></tr>
          <tr><td><strong>p-value (SD)</strong></td>
              <td style="color: %s; font-weight:600;">%.3f %s</td></tr>
        </table>
        <p class="text-muted small mb-0">%s</p>
      </div>',
      d$true_model, d$fit_model,
      mean_col, d$pval_mean, if (misfit_mean) "\u2718 misfit" else "\u2714 OK",
      sd_col,   d$pval_sd,   if (misfit_sd)   "\u2718 misfit" else "\u2714 OK",
      note
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 4 — Credible vs. Confidence Intervals
  # ═══════════════════════════════════════════════════════════════════════

  bw_ci_data <- reactiveVal(NULL)
  observeEvent(input$bw_ci_run, {
    bw_ci_data({
    true_p <- input$bw_ci_true_p
    n      <- input$bw_ci_n
    nsims  <- input$bw_ci_nsims
    level  <- input$bw_ci_level
    prior  <- input$bw_ci_prior

    prior_params <- switch(prior,
      "flat"        = c(1, 1),
      "jeffreys"    = c(0.5, 0.5),
      "informative" = c(5, 5)
    )

    set.seed(sample.int(10000, 1))

    results <- lapply(1:nsims, function(i) {
      k <- rbinom(1, n, true_p)
      p_hat <- k / n

      # Frequentist CI (Wald)
      se <- sqrt(p_hat * (1 - p_hat) / n)
      z <- qnorm(1 - (1 - level) / 2)
      freq_lo <- max(p_hat - z * se, 0)
      freq_hi <- min(p_hat + z * se, 1)

      # Bayesian CrI
      a_post <- prior_params[1] + k
      b_post <- prior_params[2] + n - k
      bayes_lo <- qbeta((1 - level) / 2, a_post, b_post)
      bayes_hi <- qbeta(1 - (1 - level) / 2, a_post, b_post)
      bayes_mean <- a_post / (a_post + b_post)

      data.frame(
        sim = i, k = k, p_hat = p_hat,
        freq_lo = freq_lo, freq_hi = freq_hi,
        bayes_lo = bayes_lo, bayes_hi = bayes_hi,
        bayes_mean = bayes_mean,
        freq_covers = (freq_lo <= true_p & freq_hi >= true_p),
        bayes_covers = (bayes_lo <= true_p & bayes_hi >= true_p)
      )
    })

    df <- do.call(rbind, results)

    list(df = df, true_p = true_p, n = n, nsims = nsims,
         level = level, prior = prior)
    })
  })

  output$bw_ci_plot <- plotly::renderPlotly({
    req(bw_ci_data())
    d <- bw_ci_data()
    df <- d$df

    p <- plotly::plot_ly()

    # Frequentist CIs
    for (i in seq_len(nrow(df))) {
      col <- if (df$freq_covers[i]) "#268bd2" else "rgba(38,139,210,0.4)"
      p <- p |> plotly::add_trace(
        x = c(df$freq_lo[i], df$freq_hi[i]),
        y = c(df$sim[i] - 0.15, df$sim[i] - 0.15),
        type = "scatter", mode = "lines",
        line = list(color = col, width = 2),
        showlegend = (i == 1), name = "Confidence",
        legendgroup = "freq", hoverinfo = "skip"
      )
    }

    # Bayesian CrIs
    for (i in seq_len(nrow(df))) {
      col <- if (df$bayes_covers[i]) "#dc322f" else "rgba(220,50,47,0.4)"
      p <- p |> plotly::add_trace(
        x = c(df$bayes_lo[i], df$bayes_hi[i]),
        y = c(df$sim[i] + 0.15, df$sim[i] + 0.15),
        type = "scatter", mode = "lines",
        line = list(color = col, width = 2),
        showlegend = (i == 1), name = "Credible",
        legendgroup = "bayes", hoverinfo = "skip"
      )
    }

    # Mark misses
    misses <- df[!df$freq_covers | !df$bayes_covers, ]
    freq_miss <- df[!df$freq_covers, ]
    bayes_miss <- df[!df$bayes_covers, ]
    if (nrow(freq_miss) > 0) {
      p <- p |> plotly::add_markers(
        x = (freq_miss$freq_lo + freq_miss$freq_hi) / 2,
        y = freq_miss$sim - 0.15,
        marker = list(color = "#b58900", size = 5, symbol = "x"),
        showlegend = FALSE, hoverinfo = "skip"
      )
    }
    if (nrow(bayes_miss) > 0) {
      p <- p |> plotly::add_markers(
        x = (bayes_miss$bayes_lo + bayes_miss$bayes_hi) / 2,
        y = bayes_miss$sim + 0.15,
        marker = list(color = "#b58900", size = 5, symbol = "x"),
        showlegend = FALSE, hoverinfo = "skip"
      )
    }

    p |> plotly::layout(
      shapes = list(list(
        type = "line", x0 = d$true_p, x1 = d$true_p,
        y0 = 0, y1 = max(df$sim) + 1,
        line = list(color = "#2aa198", dash = "dash", width = 1.5)
      )),
      title = list(
        text = sprintf("%d Experiments: Confidence (blue) vs. Credible (red)<br><sup>\u00d7 = interval misses true \u03b8</sup>",
                       d$nsims),
        font = list(size = 14)),
      xaxis = list(title = "\u03b8"),
      yaxis = list(title = "Experiment", showticklabels = FALSE),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.08),
      margin = list(t = 60)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bw_ci_summary <- renderUI({
    req(bw_ci_data())
    d <- bw_ci_data()
    df <- d$df

    freq_cov  <- mean(df$freq_covers)
    bayes_cov <- mean(df$bayes_covers)
    freq_width  <- mean(df$freq_hi - df$freq_lo)
    bayes_width <- mean(df$bayes_hi - df$bayes_lo)

    fc_col <- if (abs(freq_cov - d$level) < 0.05) "#2aa198" else "#dc322f"
    bc_col <- if (abs(bayes_cov - d$level) < 0.05) "#2aa198" else "#dc322f"

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 500px;">
          <thead><tr><th></th><th>Confidence (freq.)</th><th>Credible (Bayes)</th></tr></thead>
          <tbody>
            <tr><td><strong>Coverage</strong></td>
                <td style="color:%s; font-weight:600;">%.1f%%</td>
                <td style="color:%s; font-weight:600;">%.1f%%</td></tr>
            <tr><td><strong>Avg width</strong></td>
                <td>%.3f</td><td>%.3f</td></tr>
            <tr><td>Nominal level</td>
                <td colspan="2">%.0f%%</td></tr>
            <tr><td>Prior</td>
                <td colspan="2">%s</td></tr>
          </tbody>
        </table>
        <p class="text-muted small mb-0">
          Coverage = proportion of intervals containing the true value (%.2f).
          With %d experiments, sampling variability in coverage \u2248 \u00b1%.1f%%.
        </p>
      </div>',
      fc_col, freq_cov * 100, bc_col, bayes_cov * 100,
      freq_width, bayes_width,
      d$level * 100, d$prior, d$true_p, d$nsims,
      100 * 1.96 * sqrt(d$level * (1 - d$level) / d$nsims)
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 5 — Bayesian Model Comparison
  # ═══════════════════════════════════════════════════════════════════════

  bmc_res <- reactiveVal(NULL)
  observeEvent(input$bmc_go, {
    bmc_res({
    set.seed(sample(9999, 1))
    n       <- input$bmc_n
    true_b  <- input$bmc_true_b
    noise   <- input$bmc_noise
    prior_sd <- input$bmc_prior_sd
    cmp     <- input$bmc_compare

    x  <- runif(n, -2, 2)
    y  <- 0.5 + true_b * x + rnorm(n, 0, noise)

    # Models to compare
    fit_null  <- lm(y ~ 1)
    fit_lin   <- lm(y ~ x)
    fit_quad  <- lm(y ~ x + I(x^2))
    fit_cub   <- lm(y ~ x + I(x^2) + I(x^3))

    # Marginal likelihood via BIC approximation: log p(y|Mk) ≈ -0.5 * BIC_k
    log_ml <- function(fit) -0.5 * BIC(fit)

    # LOO-CV via brute force (exact)
    loo_cv <- function(fit) {
      preds  <- numeric(n)
      for (i in seq_len(n)) {
        fit_i  <- update(fit, data = data.frame(y = y[-i], x = x[-i]))
        pred_i <- predict(fit_i, newdata = data.frame(x = x[i]))
        preds[i] <- dnorm(y[i], pred_i, sigma(fit_i), log = TRUE)
      }
      sum(preds)
    }

    # Select model pair
    if (cmp == "Linear vs. Null (intercept only)") {
      m0 <- fit_null; m1 <- fit_lin; lbl0 <- "Null"; lbl1 <- "Linear"
    } else if (cmp == "Linear vs. Quadratic") {
      m0 <- fit_lin; m1 <- fit_quad; lbl0 <- "Linear"; lbl1 <- "Quadratic"
    } else {
      m0 <- fit_lin; m1 <- fit_cub; lbl0 <- "Linear"; lbl1 <- "Cubic"
    }

    log_bf <- log_ml(m1) - log_ml(m0)
    bf     <- exp(log_bf)

    loo0 <- tryCatch(loo_cv(m0), error = function(e) NA)
    loo1 <- tryCatch(loo_cv(m1), error = function(e) NA)
    loo_diff <- loo1 - loo0

    # WAIC approximation: -2 * (elpd - p_waic), use LOO as proxy
    waic0 <- -2 * loo0 + 2 * length(coef(m0))
    waic1 <- -2 * loo1 + 2 * length(coef(m1))

    xr <- seq(min(x), max(x), length.out = 200)
    pred0 <- predict(m0, newdata = data.frame(x = xr))
    pred1 <- predict(m1, newdata = data.frame(x = xr))

    list(x = x, y = y, xr = xr, pred0 = pred0, pred1 = pred1,
         bf = bf, log_bf = log_bf, loo_diff = loo_diff,
         waic0 = waic0, waic1 = waic1,
         bic0 = BIC(m0), bic1 = BIC(m1),
         aic0 = AIC(m0), aic1 = AIC(m1),
         lbl0 = lbl0, lbl1 = lbl1)
    })
  })

  output$bmc_fit_plot <- renderPlotly({
    req(bmc_res())
    r <- bmc_res()
    plot_ly() |>
      add_markers(x = r$x, y = r$y, name = "Data",
                  marker = list(color = "rgba(101,123,131,0.4)", size = 5)) |>
      add_lines(x = r$xr, y = r$pred0, name = r$lbl0,
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      add_lines(x = r$xr, y = r$pred1, name = r$lbl1,
                line = list(color = "#268bd2", width = 2)) |>
      layout(xaxis = list(title = "x"), yaxis = list(title = "y"),
             legend = list(orientation = "h"))
  })

  output$bmc_bf_plot <- renderPlotly({
    req(bmc_res())
    r  <- bmc_res()
    bf <- r$bf
    # BF scale categories
    cats <- data.frame(
      label = c("Decisive\nM\u2080", "Strong\nM\u2080", "Moderate\nM\u2080",
                "Anecdotal", "Moderate\nM\u2081", "Strong\nM\u2081", "Decisive\nM\u2081"),
      lo = c(-Inf, log10(1/100), log10(1/10), log10(1/3), log10(1), log10(3), log10(10)),
      hi = c(log10(1/100), log10(1/10), log10(1/3), log10(1), log10(3), log10(10), Inf),
      col = c("#dc322f","#cb4b16","#b58900","#657b83","#2aa198","#268bd2","#073642")
    )
    lbf <- log10(max(bf, 1e-5))
    lbf_clamp <- max(-4, min(4, lbf))

    plot_ly() |>
      add_segments(x = -4, xend = 4, y = 0, yend = 0,
                   line = list(color = "rgba(0,0,0,0.1)", width = 30)) |>
      add_markers(x = lbf_clamp, y = 0,
                  marker = list(color = "#073642", size = 18, symbol = "diamond"),
                  name = sprintf("log\u2081\u2080(BF) = %.2f", lbf)) |>
      layout(
        xaxis = list(title = paste0("log\u2081\u2080(BF\u2081\u2080): ", r$lbl1, " vs. ", r$lbl0),
                     range = c(-4, 4),
                     tickvals = c(-3, -2, -1, 0, 1, 2, 3),
                     ticktext = c("-3\n(1/1000)", "-2\n(1/100)", "-1\n(1/10)",
                                  "0\n(1)", "1\n(10)", "2\n(100)", "3\n(1000)")),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE,
                     range = c(-1, 1)),
        showlegend = FALSE,
        title = list(
          text = if (bf > 3) sprintf("BF = %.2f: Evidence for %s", bf, r$lbl1)
                 else if (bf < 1/3) sprintf("BF = %.2f: Evidence for %s", bf, r$lbl0)
                 else sprintf("BF = %.2f: Anecdotal / inconclusive", bf),
          font = list(size = 12)
        )
      )
  })

  output$bmc_table <- renderTable({
    req(bmc_res())
    r <- bmc_res()
    data.frame(
      Criterion    = c("BIC", "AIC", "LOO-CV (ELPD)", "WAIC",
                       "Bayes Factor (approx.)"),
      M0           = round(c(r$bic0, r$aic0, r$loo_diff * -1 + r$loo_diff,
                              r$waic0, 1), 3),
      M1           = round(c(r$bic1, r$aic1, r$loo_diff + r$loo_diff * 0,
                              r$waic1, r$bf), 3),
      Preferred    = c(
        if (r$bic1 < r$bic0) r$lbl1 else r$lbl0,
        if (r$aic1 < r$aic0) r$lbl1 else r$lbl0,
        if (r$loo_diff > 0) r$lbl1 else r$lbl0,
        if (r$waic1 < r$waic0) r$lbl1 else r$lbl0,
        if (r$bf > 1) r$lbl1 else r$lbl0
      )
    )
  }, bordered = TRUE, striped = TRUE, na = "—")


  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Bayesian Workflow", list(bw_mcmc_data, bw_ppc_data, bw_ci_data, bmc_res))
  })
}
