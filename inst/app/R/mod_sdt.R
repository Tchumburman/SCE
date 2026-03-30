# Module: Signal Detection Theory (SDT)
# 4 tabs: SDT Basics · ROC Curve · Criterion & Response Bias · d' vs. Accuracy

# ── UI ────────────────────────────────────────────────────────────────────────
sdt_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Signal Detection Theory",
  icon = icon("satellite-dish"),
  navset_card_underline(

    # ── Tab 1: SDT Basics ─────────────────────────────────────────────────────
    nav_panel(
      "SDT Basics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sdt_dprime"), "Sensitivity d'", 0, 4, 1.5, 0.1),
          sliderInput(ns("sdt_c"), "Criterion c (0 = neutral)", -2, 2, 0, 0.1),
          sliderInput(ns("sdt_n_trials"), "Trials per condition", 100, 2000, 500, 100),
          actionButton(ns("sdt_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("sdt_show_beta"), "Show likelihood ratio \u03b2", value = TRUE)
        ),
        explanation_box(
          tags$strong("Signal Detection Theory"),
          tags$p("SDT separates sensitivity (how well a signal is distinguished from noise)
                  from response bias (how readily someone says 'yes'). A classic detection
                  task: the observer decides whether a stimulus contains a signal or is just noise."),
          tags$p("Two distributions:"),
          tags$ul(
            tags$li(tags$strong("Noise distribution"), " N(0, 1) — the internal evidence when no signal is present."),
            tags$li(tags$strong("Signal distribution"), " N(d', 1) — shifted by d' when a signal is present.")
          ),
          tags$p("The criterion c sets the decision boundary:"),
          tags$ul(
            tags$li(tags$strong("Hit rate H"), " = P(respond 'yes' | signal) = 1 \u2212 \u03a6(c)"),
            tags$li(tags$strong("False alarm rate F"), " = P(respond 'yes' | noise) = 1 \u2212 \u03a6(c + d')"),
            tags$li(tags$strong("d'"), " = z(H) \u2212 z(F) — independent of criterion."),
            tags$li(tags$strong("c"), " = \u2212[z(H) + z(F)] / 2 — positive = conservative; negative = liberal.")
          ),
          tags$p("SDT has applications far beyond psychophysics. In medicine, d' quantifies
                  a diagnostic test's ability to separate diseased from healthy patients \u2014
                  independently of the clinician's tendency to diagnose positively. In
                  eyewitness testimony research, d' measures memory accuracy separately
                  from response bias (willingness to make an identification), which is
                  crucial because lineup administration procedures that increase willingness
                  to respond do not actually improve memory. In neuroimaging, SDT models
                  metacognitive accuracy (how well confidence tracks accuracy) using
                  meta-d'."),
          tags$p("The criterion \u03b2 is the likelihood ratio at the decision boundary:
                  \u03b2 = f(c | noise) / f(c | signal). An optimal observer (under
                  equal costs of hits and false alarms) sets \u03b2 = 1. Biased observers
                  who over-respond have \u03b2 < 1 (liberal bias); cautious observers have
                  \u03b2 > 1 (conservative bias). The normalised criterion c, defined as
                  c = \u2212[z(H) + z(F)] / 2, is often preferred because it is
                  independent of d' and easier to interpret directionally."),
          guide = tags$ol(
            tags$li("Move d' to change sensitivity. d' = 0: no discrimination; d' = 4: near-perfect."),
            tags$li("Move criterion c: positive shifts to the right (conservative, fewer 'yes' responses)."),
            tags$li("Click 'Simulate' to see sampled hit and false-alarm rates."),
            tags$li("Enable \u03b2: the likelihood ratio at the criterion point.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Signal and Noise Distributions"),
               plotlyOutput(ns("sdt_dist_plot"), height = "340px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Detection Outcomes"), tableOutput(ns("sdt_outcomes"))),
            card(card_header("SDT Parameters"), uiOutput(ns("sdt_params")))
          )
        )
      )
    ),

    # ── Tab 2: ROC Curve ─────────────────────────────────────────────────────
    nav_panel(
      "ROC Curve",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sdt_roc_dprime"), "Sensitivity d'", 0, 4, 1.5, 0.1),
          checkboxGroupInput(ns("sdt_roc_compare"), "Compare d' values",
            choices = c("0 (chance)" = "0",
                        "0.5" = "0.5",
                        "1" = "1",
                        "2" = "2",
                        "3" = "3"),
            selected = c("0", "1", "2")),
          tags$hr(),
          checkboxInput(ns("sdt_roc_show_points"), "Show criterion locations", value = TRUE)
        ),
        explanation_box(
          tags$strong("ROC Curve in SDT"),
          tags$p("The Receiver Operating Characteristic (ROC) curve traces the (FA, Hit) pairs
                  as the criterion c sweeps from \u2212\u221e to +\u221e:"),
          tags$ul(
            tags$li("d' = 0: ROC lies on the diagonal (chance)."),
            tags$li("Higher d': curve bows further into the upper-left corner."),
            tags$li(tags$strong("AUC"), " (area under the curve) = \u03a6(d'/\u221a2).
                    AUC = 0.5 is chance; AUC = 1 is perfect."),
            tags$li("The SDT ROC is ",tags$strong("symmetric about the negative diagonal"),
                    " (this distinguishes it from ROC curves from other detection frameworks).")
          ),
          tags$p("The SDT ROC assumes equal-variance normal distributions. Real data sometimes
                  show asymmetric ROC curves, suggesting unequal variances (indexed by d_a)."),
          tags$p("When the signal and noise distributions have unequal variance, the ROC
                  curve is no longer symmetric about the negative diagonal. The unequal-variance
                  binormal model characterises this with two parameters: d_a (a
                  variance-weighted sensitivity index) and s (the ratio of signal to noise
                  standard deviations). If s < 1, the signal distribution is narrower than
                  the noise distribution \u2014 a common finding in recognition memory
                  research. The slope of the z-ROC (ROC plotted in z-score coordinates)
                  equals s; a slope of 1 confirms equal variance."),
          tags$p("Rating scale ROC designs collect confidence ratings (e.g., 1\u20136:
                  definitely old to definitely new) rather than simple yes/no responses.
                  Each rating criterion defines one point on the ROC curve, allowing the
                  full curve to be traced from a single test session without manipulating
                  payoffs. Rating ROC provides more information than a single (FA, Hit)
                  pair and is the standard design in recognition memory and medical
                  imaging studies where continuous confidence is available."),
          guide = tags$ol(
            tags$li("Select d' values to overlay multiple ROC curves."),
            tags$li("Enable 'Show criterion locations' to see how changing c traces the curve."),
            tags$li("AUC values are annotated on each curve.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("ROC Curve(s)"),
               plotlyOutput(ns("sdt_roc_plot"), height = "420px")),
          card(card_header("AUC Summary"),
               tableOutput(ns("sdt_roc_table")))
        )
      )
    ),

    # ── Tab 3: Response Bias ──────────────────────────────────────────────────
    nav_panel(
      "Response Bias",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sdt_bias_dprime"), "True d'", 0, 4, 1.5, 0.1),
          sliderInput(ns("sdt_bias_n"), "Trials n", 100, 2000, 500, 100),
          selectInput(ns("sdt_bias_scenario"), "Bias scenario",
            choices = c("Neutral (c = 0)",
                        "Conservative (c = 1)",
                        "Liberal (c = \u22121)",
                        "Payoff: hits rewarded (c = \u22120.5)",
                        "Payoff: FA penalised (c = 0.8)"),
            selected = "Neutral (c = 0)"),
          actionButton(ns("sdt_bias_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Response Bias in SDT"),
          tags$p("Bias measures how willing a participant is to respond 'signal detected',
                  independent of their sensitivity. Two common bias indices:"),
          tags$ul(
            tags$li(tags$strong("c"), " = \u2212\u00bd[z(H) + z(F)] — the criterion in standard deviation
                    units. c = 0 is neutral; c > 0 is conservative; c < 0 is liberal."),
            tags$li(tags$strong("\u03b2"), " = f_signal(c) / f_noise(c) — the likelihood ratio at the
                    criterion. \u03b2 = 1 is neutral; \u03b2 > 1 is conservative.")
          ),
          tags$p("Bias is driven by:"),
          tags$ul(
            tags$li(tags$strong("Base rates"), " — rare signals \u2192 conservative bias."),
            tags$li(tags$strong("Payoff matrices"), " — rewarding hits vs. penalising false alarms."),
            tags$li(tags$strong("Instructions"), " \u2014 'be careful' vs. 'don\u2019t miss any'.")
          ),
          guide = tags$ol(
            tags$li("Choose a bias scenario. d' remains fixed; only the criterion changes."),
            tags$li("Note how hit rate and false-alarm rate change without any change in sensitivity."),
            tags$li("Compare estimated d' across scenarios \u2014 it should recover the true d' in all cases.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Distributions with Criterion"),
               plotlyOutput(ns("sdt_bias_dist"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Hit & FA Rates"), plotlyOutput(ns("sdt_bias_rates"), height = "250px")),
            card(card_header("Bias Indices"), tableOutput(ns("sdt_bias_table")))
          )
        )
      )
    ),

    # ── Tab 4: d' vs. Percent Correct ─────────────────────────────────────────
    nav_panel(
      "d' vs. Percent Correct",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sdt_pc_n"), "Trials per condition", 50, 1000, 200, 50),
          sliderInput(ns("sdt_pc_nsim"), "Simulations", 50, 500, 200, 50),
          actionButton(ns("sdt_pc_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
            "Percent correct (PC) conflates sensitivity and bias.
             d' is criterion-free; PC depends on both d' and c.")
        ),
        explanation_box(
          tags$strong("Why d' is Preferred Over Percent Correct"),
          tags$p("Percent correct (PC) is the most intuitive measure of discrimination but
                  has a critical flaw: it confounds sensitivity and bias."),
          tags$p("Two observers with identical d' but different criteria will show different
                  PC values. An observer who says 'yes' to everything achieves high hit rate
                  but also high false-alarm rate — PC may appear high without any real discrimination."),
          tags$p("The relationship between PC and d' (for neutral criterion and equal prior):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "PC = \u03a6(d' / \u221a2)"),
          tags$p("For 2-AFC (two-alternative forced choice) tasks, PC is criterion-free
                  because the observer always picks the interval with the stronger response."),
          guide = tags$ol(
            tags$li("The scatter plot shows estimated d' vs. PC across many simulated observers."),
            tags$li("At neutral criterion, the relationship is monotone but nonlinear."),
            tags$li("Add response bias by changing criteria to see how PC varies without changing d'.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("d' vs. Percent Correct (varying criterion across observers)"),
               plotlyOutput(ns("sdt_pc_plot"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Theoretical Relationship (neutral criterion)"),
                 plotlyOutput(ns("sdt_pc_theory"), height = "250px")),
            card(card_header("d' vs. PC Summary"), tableOutput(ns("sdt_pc_table")))
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

sdt_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: SDT Basics ─────────────────────────────────────────────────────
  sdt_sim <- eventReactive(input$sdt_go, {
    set.seed(sample(9999, 1))
    dp <- input$sdt_dprime; c <- input$sdt_c; n <- input$sdt_n_trials
    # Noise trials: evidence ~ N(0, 1)
    ev_noise  <- rnorm(n)
    ev_signal <- rnorm(n, dp)
    # Response: 'yes' if evidence > c (threshold = c)
    # But criterion c in SDT is defined as: threshold = c + d'/2 on noise axis
    # Simple: say yes if evidence > cutoff
    cutoff <- qnorm(1 - pnorm(c)) - 0  # criterion in units: z = -c in noise
    # Actually: standard SDT: criterion k = c + d'/2 on the noise/signal axis
    # H = P(evidence > k | signal) = P(N(d',1) > k) = 1 - Φ(k - d')
    # FA = P(evidence > k | noise)  = P(N(0,1) > k) = 1 - Φ(k)
    # c = -[z(H) + z(F)]/2, so k = c + d'/2... or simpler:
    # With c defined relative to neutral: k = d'/2 + c
    k <- dp / 2 + c

    hits   <- sum(ev_signal > k)
    misses <- n - hits
    fas    <- sum(ev_noise > k)
    crs    <- n - fas

    h  <- hits / n; fa <- fas / n
    dp_est <- qnorm(h) - qnorm(fa)
    c_est  <- -(qnorm(h) + qnorm(fa)) / 2
    beta_v <- dnorm(k, dp_est) / dnorm(k, 0)  # likelihood ratio at criterion

    list(dp = dp, c = c, k = k, h = h, fa = fa,
         dp_est = dp_est, c_est = c_est, beta_v = beta_v,
         hits = hits, misses = misses, fas = fas, crs = crs)
  })

  output$sdt_dist_plot <- renderPlotly({
    dp <- input$sdt_dprime; c_val <- input$sdt_c
    k  <- dp / 2 + c_val
    xv <- seq(-4, dp + 4, length.out = 400)
    f_noise  <- dnorm(xv, 0, 1)
    f_signal <- dnorm(xv, dp, 1)
    h  <- 1 - pnorm(k, dp, 1)
    fa <- 1 - pnorm(k, 0, 1)

    p <- plot_ly() |>
      add_lines(x = xv, y = f_noise, name = "Noise N(0,1)",
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = xv, y = f_signal, name = paste0("Signal N(d'=", dp, ",1)"),
                line = list(color = "#dc322f", width = 2)) |>
      # Fill hit area (signal, above criterion)
      add_ribbons(x = xv[xv >= k], ymin = 0, ymax = dnorm(xv[xv >= k], dp, 1),
                  fillcolor = "rgba(220,50,47,0.25)", line = list(width = 0),
                  name = paste0("Hits: ", round(h, 3))) |>
      # Fill FA area (noise, above criterion)
      add_ribbons(x = xv[xv >= k], ymin = 0, ymax = dnorm(xv[xv >= k], 0, 1),
                  fillcolor = "rgba(38,139,210,0.25)", line = list(width = 0),
                  name = paste0("FA: ", round(fa, 3))) |>
      add_lines(x = c(k, k), y = c(0, max(f_noise, f_signal)),
                name = "Criterion k", line = list(color = "#073642", dash = "dash", width = 2))

    if (input$sdt_show_beta) {
      beta_v <- dnorm(k, dp) / dnorm(k, 0)
      p <- p |>
        add_annotations(x = k, y = dnorm(k, 0) + 0.02,
                        text = sprintf("\u03b2 = %.2f", beta_v), showarrow = FALSE,
                        font = list(size = 11, color = "#073642"))
    }
    p |> layout(xaxis = list(title = "Internal evidence"),
                yaxis = list(title = "Density"),
                legend = list(orientation = "h", y = -0.25))
  })

  output$sdt_outcomes <- renderTable({
    req(sdt_sim())
    d <- sdt_sim()
    data.frame(
      Outcome = c("Hit (signal \u2192 'yes')", "Miss (signal \u2192 'no')",
                  "False Alarm (noise \u2192 'yes')", "Correct Rejection (noise \u2192 'no')"),
      Count   = c(d$hits, d$misses, d$fas, d$crs),
      Rate    = round(c(d$h, 1 - d$h, d$fa, 1 - d$fa), 3)
    )
  }, bordered = TRUE, striped = TRUE)

  output$sdt_params <- renderUI({
    req(sdt_sim())
    d <- sdt_sim()
    mkrow <- function(l, v) tags$tr(tags$td(l), tags$td(tags$strong(v)))
    tags$table(class = "table table-sm",
      tags$tbody(
        mkrow("True d'", input$sdt_dprime),
        mkrow("Estimated d'", sprintf("%.3f", d$dp_est)),
        mkrow("True criterion c", input$sdt_c),
        mkrow("Estimated c", sprintf("%.3f", d$c_est)),
        mkrow("Likelihood ratio \u03b2", sprintf("%.3f", d$beta_v))
      )
    )
  })

  # ── Tab 2: ROC Curve ──────────────────────────────────────────────────────
  output$sdt_roc_plot <- renderPlotly({
    dp_main <- input$sdt_roc_dprime
    dp_compare <- as.numeric(input$sdt_roc_compare)
    all_dp <- unique(c(dp_main, dp_compare))

    c_seq <- seq(-3, 3, length.out = 200)
    pal <- colorRampPalette(c("#268bd2","#2aa198","#b58900","#dc322f","#d33682"))(length(all_dp))

    p <- plot_ly()
    # Diagonal
    p <- p |> add_lines(x = c(0, 1), y = c(0, 1),
                         line = list(color = "grey", dash = "dot"),
                         name = "Chance", showlegend = FALSE)

    for (i in seq_along(all_dp)) {
      dp <- all_dp[i]
      k_seq <- dp / 2 + c_seq
      h_seq  <- 1 - pnorm(k_seq - dp)
      fa_seq <- 1 - pnorm(k_seq)
      auc    <- pnorm(dp / sqrt(2))
      p <- p |>
        add_lines(x = fa_seq, y = h_seq,
                  name = sprintf("d'=%.1f (AUC=%.2f)", dp, auc),
                  line = list(color = pal[i], width = 2))
    }

    if (input$sdt_roc_show_points) {
      dp <- dp_main
      c_pts <- c(-2, -1, 0, 1, 2)
      k_pts <- dp / 2 + c_pts
      h_pts  <- 1 - pnorm(k_pts - dp)
      fa_pts <- 1 - pnorm(k_pts)
      p <- p |>
        add_markers(x = fa_pts, y = h_pts,
                    marker = list(color = "#073642", size = 9, symbol = "circle"),
                    name = "Criterion points (c = -2..2)",
                    text = paste0("c=", c_pts),
                    hovertemplate = "c=%{text}: FA=%{x:.3f}, H=%{y:.3f}<extra></extra>")
    }
    p |> layout(xaxis = list(title = "False Alarm Rate", range = c(0, 1)),
                yaxis = list(title = "Hit Rate", range = c(0, 1)),
                legend = list(orientation = "h", y = -0.2))
  })

  output$sdt_roc_table <- renderTable({
    dp_main <- input$sdt_roc_dprime
    dp_compare <- as.numeric(input$sdt_roc_compare)
    all_dp <- sort(unique(c(dp_main, dp_compare)))
    data.frame(
      d_prime = all_dp,
      AUC     = round(pnorm(all_dp / sqrt(2)), 4),
      Neutral_Hit = round(pnorm(all_dp / 2), 3),
      Neutral_FA  = round(1 - pnorm(all_dp / 2), 3)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 3: Response Bias ───────────────────────────────────────────────────
  sdt_bias_sim <- eventReactive(input$sdt_bias_go, {
    set.seed(sample(9999, 1))
    dp  <- input$sdt_bias_dprime
    n   <- input$sdt_bias_n
    sc  <- input$sdt_bias_scenario
    c_val <- switch(sc,
      "Neutral (c = 0)"               = 0,
      "Conservative (c = 1)"          = 1,
      "Liberal (c = \u22121)"          = -1,
      "Payoff: hits rewarded (c = \u22120.5)" = -0.5,
      "Payoff: FA penalised (c = 0.8)"     = 0.8
    )
    k <- dp / 2 + c_val
    ev_n <- rnorm(n); ev_s <- rnorm(n, dp)
    h  <- mean(ev_s > k); fa <- mean(ev_n > k)
    # Clamp to avoid Inf
    h_c <- pmax(pmin(h, 0.999), 0.001)
    fa_c <- pmax(pmin(fa, 0.999), 0.001)
    dp_est <- qnorm(h_c) - qnorm(fa_c)
    c_est  <- -(qnorm(h_c) + qnorm(fa_c)) / 2
    beta_v <- dnorm(k, dp) / dnorm(k, 0)
    list(dp = dp, c_val = c_val, k = k, h = h, fa = fa,
         dp_est = dp_est, c_est = c_est, beta_v = beta_v)
  })

  output$sdt_bias_dist <- renderPlotly({
    req(sdt_bias_sim())
    d  <- sdt_bias_sim()
    xv <- seq(-4, d$dp + 4, length.out = 400)
    plot_ly() |>
      add_lines(x = xv, y = dnorm(xv), name = "Noise",
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = xv, y = dnorm(xv, d$dp), name = "Signal",
                line = list(color = "#dc322f", width = 2)) |>
      add_lines(x = c(d$k, d$k), y = c(0, 0.45),
                name = "Criterion", line = list(color = "#073642", dash = "dash", width = 2)) |>
      layout(xaxis = list(title = "Internal evidence"),
             yaxis = list(title = "Density"),
             legend = list(orientation = "h"))
  })

  output$sdt_bias_rates <- renderPlotly({
    req(sdt_bias_sim())
    d <- sdt_bias_sim()
    plot_ly(
      x = c("Hit Rate (H)", "False Alarm Rate (FA)"),
      y = c(d$h, d$fa),
      type = "bar",
      marker = list(color = c("#dc322f", "#268bd2"))
    ) |>
      layout(yaxis = list(title = "Rate", range = c(0, 1)),
             xaxis = list(title = ""))
  })

  output$sdt_bias_table <- renderTable({
    req(sdt_bias_sim())
    d <- sdt_bias_sim()
    data.frame(
      Parameter = c("True d'", "Estimated d'", "True c", "Estimated c",
                    "Likelihood ratio \u03b2"),
      Value = round(c(d$dp, d$dp_est, d$c_val, d$c_est, d$beta_v), 4)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 4: d' vs. PC ─────────────────────────────────────────────────────
  sdt_pc_sim <- eventReactive(input$sdt_pc_go, {
    set.seed(sample(9999, 1))
    n    <- input$sdt_pc_n; nsim <- input$sdt_pc_nsim
    dp_vals <- runif(nsim, 0, 3.5)
    c_vals  <- rnorm(nsim, 0, 0.8)  # varied criteria

    results <- lapply(seq_len(nsim), function(i) {
      dp <- dp_vals[i]; c_v <- c_vals[i]
      k  <- dp / 2 + c_v
      ev_n <- rnorm(n); ev_s <- rnorm(n, dp)
      h  <- mean(ev_s > k); fa <- mean(ev_n > k)
      h_c <- pmax(pmin(h, 0.999), 0.001)
      fa_c <- pmax(pmin(fa, 0.999), 0.001)
      pc  <- (mean(ev_s > k) + mean(ev_n <= k)) / 2  # balanced accuracy
      dp_est <- qnorm(h_c) - qnorm(fa_c)
      data.frame(dp_true = dp, c_true = c_v, dp_est = dp_est, pc = pc)
    })
    do.call(rbind, results)
  })

  output$sdt_pc_plot <- renderPlotly({
    req(sdt_pc_sim())
    df <- sdt_pc_sim()
    plot_ly(df, x = ~dp_est, y = ~pc, color = ~c_true,
            colors = c("#268bd2", "#b58900", "#dc322f"),
            type = "scatter", mode = "markers",
            marker = list(size = 6, opacity = 0.7),
            hovertemplate = "d'=%{x:.2f}, PC=%{y:.3f}<extra></extra>") |>
      layout(xaxis = list(title = "Estimated d'"),
             yaxis = list(title = "Percent correct (balanced)", range = c(0.4, 1)),
             coloraxis = list(colorbar = list(title = "Criterion c")))
  })

  output$sdt_pc_theory <- renderPlotly({
    dp_seq <- seq(0, 4, 0.05)
    pc_seq <- pnorm(dp_seq / sqrt(2))  # theoretical for neutral criterion
    plot_ly() |>
      add_lines(x = dp_seq, y = pc_seq, line = list(color = "#268bd2", width = 2),
                hovertemplate = "d'=%{x:.2f}, PC=%{y:.3f}<extra></extra>") |>
      add_lines(x = c(0, 4), y = c(0.5, 0.5),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "d'"), yaxis = list(title = "PC (neutral criterion)"))
  })

  output$sdt_pc_table <- renderTable({
    req(sdt_pc_sim())
    df <- sdt_pc_sim()
    # Summarise
    cuts <- cut(df$dp_true, breaks = c(0, 1, 2, 3, Inf),
                labels = c("0-1","1-2","2-3",">3"))
    agg <- tapply(df$pc, cuts, mean, na.rm = TRUE)
    data.frame(
      d_prime_range = names(agg),
      Mean_PC = round(as.numeric(agg), 3),
      Predicted_PC = round(pnorm(c(0.5, 1.5, 2.5, 3.5) / sqrt(2)), 3)
    )
  }, bordered = TRUE, striped = TRUE)
  })
}
