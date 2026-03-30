# Module: Sequential & Group-Sequential Testing
# 3 tabs: Sequential SPRT · Group-Sequential (alpha spending) · Always-Valid Tests

# ── UI ────────────────────────────────────────────────────────────────────────
sequential_testing_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Sequential Testing",
  icon = icon("forward"),
  navset_card_underline(

    # ── Tab 1: SPRT ───────────────────────────────────────────────────────────
    nav_panel(
      "SPRT",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$h6("Hypotheses"),
          sliderInput(ns("sprt_h0"), "H\u2080: \u03bc\u2080 (null mean)", -1, 1, 0, 0.1),
          sliderInput(ns("sprt_h1"), "H\u2081: \u03bc\u2081 (alternative mean)", 0, 3, 0.5, 0.1),
          sliderInput(ns("sprt_true_mu"), "True \u03bc (data-generating)", -1, 3, 0.5, 0.1),
          sliderInput(ns("sprt_sigma"), "Known SD \u03c3", 0.3, 3, 1, 0.1),
          tags$hr(),
          sliderInput(ns("sprt_alpha"), "Type I error \u03b1", 0.01, 0.2, 0.05, 0.01),
          sliderInput(ns("sprt_beta"), "Type II error \u03b2 (1\u2212power)", 0.01, 0.4, 0.2, 0.01),
          sliderInput(ns("sprt_n_max"), "Max observations", 50, 500, 200, 25),
          sliderInput(ns("sprt_n_sim"), "Simulations", 10, 100, 30, 5),
          actionButton(ns("sprt_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Sequential Probability Ratio Test (SPRT)"),
          tags$p("Wald's SPRT is a fully sequential test: after each observation, we decide
                  to accept H\u2080, reject in favour of H\u2081, or continue collecting data.
                  The likelihood ratio is accumulated observation by observation:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "\u039b\u2099 = \u220f\u1d62 [f(x\u1d62 | H\u2081) / f(x\u1d62 | H\u2080)]"),
          tags$p("The decision boundaries are:"),
          tags$ul(
            tags$li(tags$strong("Reject H\u2080"), " if \u039b\u2099 \u2265 (1\u2212\u03b2)/\u03b1 = B (upper bound)."),
            tags$li(tags$strong("Accept H\u2080"), " if \u039b\u2099 \u2264 \u03b2/(1\u2212\u03b1) = A (lower bound)."),
            tags$li(tags$strong("Continue"), " if A < \u039b\u2099 < B.")
          ),
          tags$p("SPRT offers guaranteed error control and typically requires fewer observations
                  than a fixed-sample test. It requires pre-specified point hypotheses (H\u2080 and H\u2081)."),
          guide = tags$ol(
            tags$li("Set H\u2080 and H\u2081 to define the hypotheses. Set the true \u03bc to control what actually generates data."),
            tags$li("With True \u03bc = H\u2081, most paths should hit the upper boundary (reject H\u2080)."),
            tags$li("With True \u03bc = H\u2080, most paths should hit the lower boundary (accept H\u2080)."),
            tags$li("Note: the average sample number (ASN) is far less than the fixed-n test would require.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("SPRT Paths (log-likelihood ratio vs. observations)"),
               plotlyOutput(ns("sprt_paths"), height = "340px")),
          layout_column_wrap(
            width = 1 / 3,
            card(card_header("Decision Distribution"), plotlyOutput(ns("sprt_decision"), height = "240px")),
            card(card_header("Sample Size Distribution"), plotlyOutput(ns("sprt_asn"), height = "240px")),
            card(card_header("Error Summary"), tableOutput(ns("sprt_errors")))
          )
        )
      )
    ),

    # ── Tab 2: Group-Sequential ────────────────────────────────────────────────
    nav_panel(
      "Group-Sequential",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gs_n_total"), "Total planned sample size N", 50, 1000, 400, 50),
          sliderInput(ns("gs_k_looks"), "Number of interim looks K", 2, 10, 4, 1),
          selectInput(ns("gs_design"), "Alpha-spending function",
            choices = c("O\u2019Brien-Fleming (conservative early)",
                        "Pocock (equal at each look)",
                        "Lan-DeMets OF (\u03b1-spending)"),
            selected = "O\u2019Brien-Fleming (conservative early)"),
          sliderInput(ns("gs_alpha"), "Overall \u03b1", 0.01, 0.1, 0.05, 0.01),
          sliderInput(ns("gs_true_d"), "True effect (Cohen's d)", -1, 1.5, 0.3, 0.05),
          sliderInput(ns("gs_n_sims"), "Simulations", 100, 1000, 300, 100),
          actionButton(ns("gs_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Group-Sequential Designs"),
          tags$p("Group-sequential tests allow pre-planned interim analyses during a trial.
                  At each look, we compute a test statistic and compare to a critical boundary
                  that preserves the overall Type I error rate."),
          tags$p("The key design choice is the alpha-spending function, which allocates
                  the Type I error budget across the K looks:"),
          tags$ul(
            tags$li(tags$strong("O\u2019Brien-Fleming"), " — very conservative early boundaries;
                    final boundary close to nominal \u03b1. The gold standard for clinical trials."),
            tags$li(tags$strong("Pocock"), " — equal boundaries at each look;
                    early stopping is easier but the final boundary is also smaller than \u03b1."),
            tags$li(tags$strong("Lan-DeMets"), " — continuous alpha-spending, allowing flexible
                    timing of looks. The spending function \u03b1(t) = 2[1 \u2212 \u03a6(z\u03b1/\u00b2/\u221at)]
                    mimics O\u2019Brien-Fleming.")
          ),
          tags$p("Futility stopping (beta-spending) can also be incorporated to stop early
                  when it becomes clear the trial will not detect an effect."),
          guide = tags$ol(
            tags$li("Set K interim looks. Boundaries are calculated to preserve overall \u03b1."),
            tags$li("Compare OBF vs. Pocock: early boundaries differ substantially."),
            tags$li("Increase true effect d to see how often early stopping occurs."),
            tags$li("The power curve shows actual power vs. planned.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Rejection Boundaries by Look"),
               plotlyOutput(ns("gs_boundaries"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Stopping Time Distribution"),
                 plotlyOutput(ns("gs_stop_dist"), height = "260px")),
            card(card_header("Error Rates & Average N"),
                 tableOutput(ns("gs_summary")))
          )
        )
      )
    ),

    # ── Tab 3: Always-Valid (anytime-valid) ────────────────────────────────────
    nav_panel(
      "Always-Valid Tests",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("av_n_max"), "Max observations per group", 50, 500, 200, 50),
          sliderInput(ns("av_true_d"), "True Cohen's d", -1, 1.5, 0.3, 0.1),
          sliderInput(ns("av_alpha"), "Target \u03b1 (e-value threshold)", 0.01, 0.2, 0.05, 0.01),
          sliderInput(ns("av_n_sims"), "Simulations", 50, 300, 100, 50),
          actionButton(ns("av_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Always-Valid / Anytime-Valid Tests"),
          tags$p("Traditional hypothesis tests are designed for a fixed sample size. Peeking
                  at the data and stopping when p < 0.05 inflates the Type I error dramatically.
                  ", tags$strong("Anytime-valid tests"), " maintain valid error control at any
                  stopping time."),
          tags$p("The e-value framework replaces p-values with e-values:"),
          tags$ul(
            tags$li(tags$strong("E-value E"), " satisfies E[E | H\u2080] \u2264 1 for any stopping rule.
                    E-values can be multiplied as data accumulate:
                    E\u2099 = E\u2081 \u00d7 E\u2082 \u00d7 \u2026 \u00d7 E\u2099."),
            tags$li("Reject H\u2080 when E\u2099 \u2265 1/\u03b1 (e.g., \u2265 20 for \u03b1 = 0.05)."),
            tags$li(tags$strong("Contrast with SPRT"), ": e-values are composite (work for any
                    alternative), whereas SPRT requires point hypotheses.")
          ),
          tags$p("For a one-sample normal test with known variance, the running e-value is the
                  Bayes factor against the null, using a well-chosen prior."),
          tags$p("E-values and Bayes factors are closely related but not identical. Both
                  involve a ratio of likelihoods, but Bayes factors require specifying a
                  prior over the alternative, and their optional-stopping validity depends
                  on the prior. E-values are defined to be anytime-valid by construction
                  for any stopping rule, without requiring a prior on the alternative \u2014
                  they are 'universal' in the sense of being valid under any composite
                  alternative. A Bayes factor is an e-value when the alternative prior
                  is proper (integrates to 1), making valid optional stopping a feature
                  of properly specified Bayesian testing."),
          tags$p("In A/B testing and online experimentation, always-valid tests (sometimes
                  called 'continuous monitoring' or 'anytime p-values') have gained
                  widespread adoption because they allow teams to stop experiments as
                  soon as a conclusive result is reached, without inflating false positive
                  rates. This contrasts with fixed-horizon tests, where peeking at results
                  before the planned sample size is reached dramatically increases Type I
                  error. Companies such as Optimizely and Netflix have published
                  deployments of always-valid sequential tests for this reason."),
          guide = tags$ol(
            tags$li("Simulate e-value paths. Paths crossing 1/\u03b1 = reject H\u2080."),
            tags$li("Under the null (d = 0): < \u03b1 of paths should cross the threshold."),
            tags$li("Compare to naive peeking (fixed \u03b1 at each step): inflation is clear."),
            tags$li("Increase d to see how quickly e-values reach the threshold.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("E-value Paths (log scale)"),
               plotlyOutput(ns("av_paths"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Type I Error: Naive Peeking vs. E-values"),
                 plotlyOutput(ns("av_t1_compare"), height = "250px")),
            card(card_header("Summary"), tableOutput(ns("av_table")))
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

sequential_testing_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: SPRT ────────────────────────────────────────────────────────────
  sprt_res <- reactiveVal(NULL)
  observeEvent(input$sprt_go, {
    withProgress(message = "Running SPRT simulation...", value = 0.1, {
    sprt_res({
    set.seed(sample(9999, 1))
    mu0 <- input$sprt_h0; mu1 <- input$sprt_h1
    mu  <- input$sprt_true_mu; sig <- input$sprt_sigma
    a   <- input$sprt_alpha; b_err <- input$sprt_beta
    N   <- input$sprt_n_max; nsim <- input$sprt_n_sim

    # Boundaries in log-LR
    log_A <- log(b_err / (1 - a))   # lower (accept H0)
    log_B <- log((1 - b_err) / a)   # upper (reject H0)

    # Simulate paths
    all_paths <- vector("list", nsim)
    decisions  <- character(nsim)
    stop_ns    <- integer(nsim)

    for (s in seq_len(nsim)) {
      xs    <- rnorm(N, mu, sig)
      log_lr <- cumsum(dnorm(xs, mu1, sig, log = TRUE) - dnorm(xs, mu0, sig, log = TRUE))
      # Find stopping time
      hit_upper <- which(log_lr >= log_B)
      hit_lower <- which(log_lr <= log_A)
      if (length(hit_upper) > 0 && (length(hit_lower) == 0 || hit_upper[1] < hit_lower[1])) {
        stop_n <- hit_upper[1]; dec <- "Reject H0"
      } else if (length(hit_lower) > 0) {
        stop_n <- hit_lower[1]; dec <- "Accept H0"
      } else {
        stop_n <- N; dec <- "Inconclusive"
      }
      all_paths[[s]] <- list(lr = log_lr[1:stop_n], n = stop_n, dec = dec)
      decisions[s]  <- dec
      stop_ns[s]    <- stop_n
    }
    list(paths = all_paths, decisions = decisions, stop_ns = stop_ns,
         log_A = log_A, log_B = log_B, mu = mu, mu0 = mu0, mu1 = mu1)
    })
    })
  })

  output$sprt_paths <- renderPlotly({
    req(sprt_res())
    r   <- sprt_res()
    col_map <- c("Reject H0" = "#dc322f", "Accept H0" = "#268bd2", "Inconclusive" = "#b58900")
    p   <- plot_ly()
    for (i in seq_along(r$paths)) {
      path <- r$paths[[i]]
      col  <- col_map[path$dec]
      p    <- p |> add_lines(x = seq_along(path$lr), y = path$lr,
                              line = list(color = col, width = 0.8, opacity = 0.5),
                              showlegend = FALSE)
    }
    p |>
      add_lines(x = c(1, input$sprt_n_max), y = c(r$log_B, r$log_B),
                name = "Reject boundary", line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      add_lines(x = c(1, input$sprt_n_max), y = c(r$log_A, r$log_A),
                name = "Accept boundary", line = list(color = "#268bd2", dash = "dash", width = 2)) |>
      add_lines(x = c(1, input$sprt_n_max), y = c(0, 0),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Observations"),
             yaxis = list(title = "log(\u039b\u2099)"),
             legend = list(orientation = "h"))
  })

  output$sprt_decision <- renderPlotly({
    req(sprt_res())
    r   <- sprt_res()
    tab <- table(r$decisions)
    plot_ly(x = names(tab), y = as.integer(tab), type = "bar",
            marker = list(color = c("#268bd2","#b58900","#dc322f")[seq_along(tab)])) |>
      layout(xaxis = list(title = ""), yaxis = list(title = "Count"))
  })

  output$sprt_asn <- renderPlotly({
    req(sprt_res())
    r <- sprt_res()
    plot_ly(x = r$stop_ns, type = "histogram",
            marker = list(color = "#2aa198"), nbinsx = 20) |>
      layout(xaxis = list(title = "Sample size at stopping"),
             yaxis = list(title = "Count"))
  })

  output$sprt_errors <- renderTable({
    req(sprt_res())
    r   <- sprt_res()
    dec <- r$decisions
    n   <- length(dec)
    is_null <- abs(r$mu - r$mu0) < abs(r$mu - r$mu1)
    data.frame(
      Metric = c("Reject H0 rate", "Accept H0 rate", "Inconclusive rate",
                 "Mean sample size"),
      Value  = round(c(mean(dec == "Reject H0"),
                       mean(dec == "Accept H0"),
                       mean(dec == "Inconclusive"),
                       mean(r$stop_ns)), 2)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 2: Group-Sequential ────────────────────────────────────────────────
  gs_res <- reactiveVal(NULL)
  observeEvent(input$gs_go, {
    withProgress(message = "Running group sequential design...", value = 0.1, {
    gs_res({
    set.seed(sample(9999, 1))
    N    <- input$gs_n_total; K <- input$gs_k_looks
    alph <- input$gs_alpha; d <- input$gs_true_d
    nsim <- input$gs_n_sims
    des  <- input$gs_design

    looks <- round(N * seq_len(K) / K)

    # Critical boundaries per design (approximate)
    t_vals <- seq_len(K) / K  # information fractions

    bounds <- switch(des,
      "O\u2019Brien-Fleming (conservative early)" = {
        z_final <- qnorm(1 - alph / 2)
        z_final / sqrt(t_vals)
      },
      "Pocock (equal at each look)" = {
        # Pocock constant (approximate tabulation)
        pocock_const <- c(NA, 2.178, 2.289, 2.361, 2.413, 2.453,
                          2.485, 2.512, 2.535, 2.555, 2.573)
        p_c <- if (K <= 10) pocock_const[K] else 2.6
        rep(p_c, K)
      },
      {
        # Lan-DeMets OF: alpha spending function
        alpha_spent <- 2 * (1 - pnorm(qnorm(1 - alph/2) / sqrt(t_vals)))
        incremental <- diff(c(0, alpha_spent))
        qnorm(1 - incremental / 2)
      }
    )

    # Simulate two-sample z-tests
    n_per  <- looks / 2
    rejected_at <- integer(nsim)
    stopped  <- logical(nsim)
    final_z  <- numeric(nsim)

    for (s in seq_len(nsim)) {
      x1 <- rnorm(N / 2, d, 1)
      x2 <- rnorm(N / 2, 0, 1)
      done <- FALSE
      for (k in seq_len(K)) {
        n_k <- looks[k]
        z_k <- (mean(x1[1:(n_k/2)]) - mean(x2[1:(n_k/2)])) / sqrt(2 / (n_k/2))
        if (abs(z_k) >= bounds[k]) {
          rejected_at[s] <- looks[k]
          stopped[s]     <- TRUE
          done           <- TRUE; break
        }
      }
      if (!done) {
        rejected_at[s] <- 0
        stopped[s]     <- FALSE
        final_z[s]     <- z_k
      }
    }

    list(bounds = bounds, looks = looks, K = K, alph = alph,
         rejected_at = rejected_at, stopped = stopped,
         power = mean(stopped), avg_n = mean(ifelse(stopped, rejected_at, N)),
         des = des)
    })
    })
  })

  output$gs_boundaries <- renderPlotly({
    req(gs_res())
    r <- gs_res()
    plot_ly() |>
      add_lines(x = r$looks, y = r$bounds, name = "Upper boundary",
                line = list(color = "#dc322f", width = 2)) |>
      add_lines(x = r$looks, y = -r$bounds, name = "Lower boundary",
                line = list(color = "#268bd2", width = 2)) |>
      add_markers(x = r$looks, y = r$bounds, marker = list(color = "#dc322f", size = 8)) |>
      add_markers(x = r$looks, y = -r$bounds, marker = list(color = "#268bd2", size = 8)) |>
      add_lines(x = c(0, max(r$looks)), y = c(0, 0),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Cumulative sample size"),
             yaxis = list(title = "Critical z-value"),
             legend = list(orientation = "h"),
             title = list(text = r$des, font = list(size = 12)))
  })

  output$gs_stop_dist <- renderPlotly({
    req(gs_res())
    r   <- gs_res()
    sn  <- r$rejected_at[r$stopped]
    req(length(sn) > 0)
    tab <- table(sn)
    plot_ly(x = as.integer(names(tab)), y = as.integer(tab),
            type = "bar", marker = list(color = "#268bd2")) |>
      layout(xaxis = list(title = "Sample size at stopping"),
             yaxis = list(title = "Count (of trials stopped early)"))
  })

  output$gs_summary <- renderTable({
    req(gs_res())
    r <- gs_res()
    data.frame(
      Metric = c("Simulated power", "Early stopping rate",
                 "Average sample size", "Planned N"),
      Value  = round(c(r$power, mean(r$stopped), r$avg_n, max(r$looks)), 2)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 3: Always-Valid ────────────────────────────────────────────────────
  av_res <- reactiveVal(NULL)
  observeEvent(input$av_go, {
    withProgress(message = "Running adaptive validation...", value = 0.1, {
    av_res({
    set.seed(sample(9999, 1))
    N    <- input$av_n_max; d <- input$av_true_d
    alph <- input$av_alpha; nsim <- input$av_n_sims

    threshold <- 1 / alph  # e-value threshold

    ev_paths   <- vector("list", nsim)
    ev_stop    <- integer(nsim)
    naive_stop <- integer(nsim)

    for (s in seq_len(nsim)) {
      x <- rnorm(N, d, 1)
      # Running e-value: sequential Bayes factor vs N(0,1) using N(d,1) alternative
      # Simple e-value: product of likelihood ratios with alternative = truth
      # For a robust/admissible e-value, use half-normal mixture prior
      ev_running <- numeric(N)
      log_ev     <- 0
      for (i in seq_len(N)) {
        # E-variable for N(0,1) vs two-sided N(d,1) using moment-based e-value
        # Kelly-optimal e-variable
        log_ev <- log_ev + (d * x[i] - d^2 / 2)  # log(f1/f0)
        ev_running[i] <- exp(log_ev)
      }
      ev_paths[[s]] <- ev_running

      # E-value stopping time
      hit <- which(ev_running >= threshold)
      ev_stop[s] <- if (length(hit) > 0) hit[1] else 0

      # Naive peeking: fixed alpha at each step
      pvals <- 2 * pnorm(-abs(cumsum(x) / sqrt(seq_len(N))))
      naive_hit <- which(pvals < alph)
      naive_stop[s] <- if (length(naive_hit) > 0) naive_hit[1] else 0
    }

    list(paths = ev_paths, ev_stop = ev_stop, naive_stop = naive_stop,
         threshold = threshold, alph = alph, d = d, N = N, nsim = nsim)
    })
    })
  })

  output$av_paths <- renderPlotly({
    req(av_res())
    r  <- av_res()
    p  <- plot_ly()
    for (i in seq_along(r$paths)) {
      ev  <- pmin(r$paths[[i]], r$threshold * 10)
      col <- if (r$ev_stop[i] > 0) "rgba(220,50,47,0.4)" else "rgba(38,139,210,0.3)"
      p   <- p |> add_lines(x = seq_along(ev), y = log10(ev),
                              line = list(color = col, width = 0.8),
                              showlegend = FALSE)
    }
    p |>
      add_lines(x = c(1, r$N), y = rep(log10(r$threshold), 2),
                name = sprintf("Threshold 1/\u03b1 = %.0f", r$threshold),
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      add_lines(x = c(1, r$N), y = c(0, 0),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Observations"),
             yaxis = list(title = "log\u2081\u2080(E-value)"),
             legend = list(orientation = "h"))
  })

  output$av_t1_compare <- renderPlotly({
    req(av_res())
    r  <- av_res()
    # Type I error = fraction of paths that stopped when d = 0; use ev_stop under null as approximation
    # Show rejection rates by look
    ev_rej  <- mean(r$ev_stop > 0)
    naive_rej <- mean(r$naive_stop > 0)
    plot_ly(
      x = c("E-value test", "Naive peeking"),
      y = c(ev_rej, naive_rej),
      type = "bar",
      marker = list(color = c("#268bd2", "#dc322f"))
    ) |>
      add_lines(x = c(-0.5, 1.5), y = c(r$alph, r$alph),
                line = list(color = "#859900", dash = "dot"),
                name = paste("Target \u03b1 =", r$alph)) |>
      layout(yaxis = list(title = "Rejection rate", range = c(0, 1)),
             xaxis = list(title = ""),
             title = list(text = if (r$d == 0) "Under H\u2080: rejection = Type I error"
                                 else "Under H\u2081: rejection = power",
                          font = list(size = 11)))
  })

  output$av_table <- renderTable({
    req(av_res())
    r <- av_res()
    data.frame(
      Metric = c("True effect d", "Threshold (1/\u03b1)",
                 "E-value rejection rate", "Naive peeking rejection rate",
                 "E-value avg. sample (when stopped)",
                 "Naive avg. sample (when stopped)"),
      Value  = round(c(r$d, r$threshold,
                       mean(r$ev_stop > 0),
                       mean(r$naive_stop > 0),
                       mean(r$ev_stop[r$ev_stop > 0]),
                       mean(r$naive_stop[r$naive_stop > 0])), 3)
    )
  }, bordered = TRUE, striped = TRUE)

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Sequential Testing", list(sprt_res, gs_res, av_res))
  })
}
