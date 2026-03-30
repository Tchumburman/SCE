# Module: Replication & Open Science
# 4 tabs: Replication Crisis · Pre-registration · Publication Bias · R-Index & Diagnostics

# ── UI ────────────────────────────────────────────────────────────────────────
open_science_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Replication & Open Science",
  icon = icon("unlock"),
  navset_card_underline(

    # ── Tab 1: Replication Crisis ──────────────────────────────────────────────
    nav_panel(
      "Replication Crisis",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("os_rc_true_d"), "True effect size d", 0, 1.5, 0, 0.05),
          sliderInput(ns("os_rc_n"), "Sample size per study", 10, 200, 40, 5),
          sliderInput(ns("os_rc_alpha"), "Significance threshold \u03b1", 0.01, 0.1, 0.05, 0.01),
          sliderInput(ns("os_rc_n_studies"), "Number of original studies", 10, 500, 100, 10),
          sliderInput(ns("os_rc_n_rep"), "Number of replications", 10, 200, 50, 10),
          actionButton(ns("os_rc_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.84rem;",
            "Set d = 0 to simulate null effects. The 'replication rate' shows
             how often replications confirm the original significant finding.")
        ),
        explanation_box(
          tags$strong("The Replication Crisis"),
          tags$p("Beginning with Open Science Collaboration (2015), large-scale replication
                  projects revealed that many published findings do not replicate. The
                  replication crisis has several interlocking causes:"),
          tags$ul(
            tags$li(tags$strong("Low prior probability"), " — many tested hypotheses are false.
                    With low base rates, most 'significant' findings are false positives."),
            tags$li(tags$strong("Low power"), " — underpowered studies have low true positive rate
                    and exaggerated effect sizes when they do find significance (the winner's curse)."),
            tags$li(tags$strong("Flexible analyses"), " — p-hacking, QRPs, and HARKing inflate
                    false-positive rates beyond nominal \u03b1."),
            tags$li(tags$strong("Publication bias"), " — selective reporting of significant results
                    means the literature overrepresents false positives.")
          ),
          tags$p("The PPV (positive predictive value) of a significant finding:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "PPV = (\u03c0 \u00d7 power) / (\u03c0 \u00d7 power + (1\u2212\u03c0) \u00d7 \u03b1)"),
          guide = tags$ol(
            tags$li("Set d = 0: all original significant results are false positives. Replications rarely confirm them."),
            tags$li("Set d = 0.3 with n = 40: low power means effect sizes are exaggerated in significant studies."),
            tags$li("Increase n to see how replication rates recover with better-powered studies.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Original vs. Replication Effect Sizes"),
               plotlyOutput(ns("os_rc_plot"), height = "320px")),
          layout_column_wrap(
            width = 1 / 3,
            card(card_header("Replication Rate"), uiOutput(ns("os_rc_rate"))),
            card(card_header("Positive Predictive Value"), uiOutput(ns("os_rc_ppv"))),
            card(card_header("Winner's Curse"), uiOutput(ns("os_rc_curse")))
          )
        )
      )
    ),

    # ── Tab 2: Pre-Registration ────────────────────────────────────────────────
    nav_panel(
      "Pre-Registration",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("os_pr_alpha_prespec"), "Pre-specified \u03b1", 0.01, 0.1, 0.05, 0.01),
          sliderInput(ns("os_pr_n_analytic"), "Number of analytic degrees of freedom", 1, 20, 5, 1),
          sliderInput(ns("os_pr_n_outcome"), "Number of outcomes", 1, 10, 3, 1),
          sliderInput(ns("os_pr_d_true"), "True effect d", 0, 1, 0, 0.05),
          sliderInput(ns("os_pr_n_sim"), "Simulations", 500, 5000, 2000, 500),
          actionButton(ns("os_pr_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Pre-Registration and HARKing"),
          tags$p("Pre-registration locks in the analysis plan (hypotheses, outcomes, sample size,
                  analysis method) before data collection. It separates ", tags$em("confirmatory"),
                  " from ", tags$em("exploratory"), " analyses, restoring the nominal \u03b1 level."),
          tags$p("Without pre-registration, researchers often engage in:"),
          tags$ul(
            tags$li(tags$strong("HARKing"), " (Hypothesising After Results are Known) —
                    presenting exploratory findings as confirmatory."),
            tags$li(tags$strong("Outcome switching"), " — reporting the significant outcome
                    from a set of measured outcomes."),
            tags$li(tags$strong("Flexible stopping"), " — continuing data collection until p < \u03b1.")
          ),
          tags$p("The effective alpha after k analytic choices and j outcomes:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "\u03b1_eff \u2248 1 \u2212 (1\u2212\u03b1)^(k\u00d7j)"),
          guide = tags$ol(
            tags$li("Set d = 0. The effective \u03b1 inflates rapidly with analytic flexibility."),
            tags$li("Increase 'analytic degrees of freedom' to see false positive rate."),
            tags$li("The registered analysis preserves \u03b1; unregistered analysis inflates it.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("False Positive Rate: Registered vs. Unregistered"),
               plotlyOutput(ns("os_pr_fpr"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Effective \u03b1 vs. Analytic Flexibility"),
                 plotlyOutput(ns("os_pr_alpha_curve"), height = "250px")),
            card(card_header("Summary"), tableOutput(ns("os_pr_table")))
          )
        )
      )
    ),

    # ── Tab 3: Publication Bias ───────────────────────────────────────────────
    nav_panel(
      "Publication Bias",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("os_pb_d_true"), "True effect d", 0, 1, 0.3, 0.05),
          sliderInput(ns("os_pb_n_studies"), "Studies conducted", 20, 200, 80, 10),
          sliderInput(ns("os_pb_n_per"), "n per study", 20, 200, 40, 10),
          sliderInput(ns("os_pb_pub_prob"), "P(publish | non-significant)", 0, 1, 0.1, 0.05),
          actionButton(ns("os_pb_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("os_pb_show_funnel"), "Show funnel plot", value = TRUE),
          checkboxInput(ns("os_pb_show_trim"), "Show Trim-and-Fill adjustment", value = TRUE)
        ),
        explanation_box(
          tags$strong("Publication Bias & Funnel Plots"),
          tags$p("Publication bias occurs when studies are more likely to be published if
                  their results are statistically significant. This selectively removes null
                  results from the literature, inflating the meta-analytic estimate."),
          tags$p("Diagnostic tools:"),
          tags$ul(
            tags$li(tags$strong("Funnel plot"), " — plots effect size vs. SE (precision).
                    Under no bias, a symmetric funnel centred on the true effect.
                    Asymmetry suggests small-study effects or publication bias."),
            tags$li(tags$strong("Egger's test"), " — tests for funnel plot asymmetry using
                    a regression of standardised effect on precision."),
            tags$li(tags$strong("Trim-and-fill"), " — imputes the 'missing' studies on the
                    opposite side of the funnel and recalculates the meta-analytic estimate."),
            tags$li(tags$strong("p-curve"), " (see p-Hacking module) — analyses the
                    distribution of significant p-values to detect p-hacking or no true effect.")
          ),
          tags$p("Trim-and-fill is widely used but has serious limitations: it assumes
                  that asymmetry is entirely due to suppressed small studies, ignores
                  true heterogeneity as a source of asymmetry, and can over-correct
                  when the largest studies are biased. Alternative methods include
                  PET-PEESE (precision-effect tests that regress effect size on
                  standard error), Robust Bayesian Meta-Analysis (RoBMA), and
                  selection models (Vevea & Hedges) that explicitly model the
                  publication process. No single method is universally superior."),
          tags$p("Publication bias is not the only form of reporting distortion.
                  Time-lag bias occurs when positive results are published faster
                  than negative ones, inflating cumulative meta-analytic estimates
                  early in a literature. Outcome reporting bias (selectively
                  reporting significant outcomes within a study) is arguably more
                  pervasive than between-study publication bias and harder to detect.
                  The ORBIT tool and comparison with trial registries can identify
                  outcome reporting bias at the study level."),
          guide = tags$ol(
            tags$li("Set 'P(publish | non-significant)' near 0 for strong bias."),
            tags$li("The funnel plot shows asymmetry in the published studies."),
            tags$li("Trim-and-fill corrects the estimate (dashed) but may over- or under-correct.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Funnel Plot (published studies)"),
               plotlyOutput(ns("os_pb_funnel"), height = "360px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Published vs. True Distribution"),
                 plotlyOutput(ns("os_pb_dist"), height = "250px")),
            card(card_header("Meta-Analytic Estimates"),
                 tableOutput(ns("os_pb_table")))
          )
        )
      )
    ),

    # ── Tab 4: R-Index & Diagnostics ──────────────────────────────────────────
    nav_panel(
      "R-Index & Diagnostics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("os_ri_n_studies"), "Studies", 5, 50, 20, 5),
          sliderInput(ns("os_ri_d_true"), "True effect d", 0, 1.5, 0.3, 0.05),
          sliderInput(ns("os_ri_n_per"), "n per study", 10, 200, 40, 10),
          selectInput(ns("os_ri_scenario"), "Scenario",
            choices = c("Normal (honest reporting)",
                        "p-hacked (optional stopping)",
                        "Inflated (many studies, biased)",
                        "Null effect (all H0 true)"),
            selected = "Normal (honest reporting)"),
          actionButton(ns("os_ri_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("R-Index, Excess Significance & GRIM"),
          tags$p("Several diagnostics detect evidence that results are too good to be true:"),
          tags$ul(
            tags$li(tags$strong("R-Index"), " (Schimmack) = mean power of significant studies
                    minus inflation rate. High R-Index (\u2265 0.5) suggests an honest literature;
                    low R-Index (\u2264 0) indicates excessive bias."),
            tags$li(tags$strong("Excess significance test"), " (Ioannidis & Trikalinos) —
                    compares observed number of significant results to expected number given
                    estimated mean power. Significant chi-square = more significant results
                    than expected."),
            tags$li(tags$strong("GRIM test"), " — Granularity-Related Inconsistency of Means.
                    Checks whether a reported mean is arithmetically possible given n and item scale.
                    Not simulated here but explained."),
            tags$li(tags$strong("SPRITE"), " — Set of Possible Rounded Integer TEsts; identifies
                    impossible patterns in Likert-scale data.")
          ),
          tags$p("These diagnostics operate as statistical forensics rather than
                  proof of misconduct. A low R-Index or significant excess significance
                  test does not mean individual researchers fabricated data \u2014 it
                  can also arise from underpowered studies with selective reporting of
                  the significant subset. The goal is to identify literatures where
                  the published record is unlikely to be a representative sample of
                  all studies conducted, which is a methodological problem regardless
                  of intent."),
          tags$p("GRIM (Granularity-Related Inconsistency of Means) is a purely
                  arithmetic check: given the reported sample size n and a Likert-scale
                  range, only a finite number of means are possible. A reported mean
                  that is not arithmetically achievable indicates a reporting error.
                  SPRITE (Set of Possible Rounded Integer TEsts) extends this to
                  checking whether any integer-valued dataset of n participants could
                  produce the reported summary statistics. Both can be applied to
                  published tables without raw data and have identified numerous
                  reporting errors in the psychological literature."),
          guide = tags$ol(
            tags$li("Choose 'p-hacked': observe inflated success rate and low R-Index."),
            tags$li("Choose 'Null effect': the p-value distribution should be uniform \u2014 high success rate signals bias."),
            tags$li("'Normal' scenario: R-Index should be moderate; success rate \u2248 planned power.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("p-value Distribution"),
               plotlyOutput(ns("os_ri_pvals"), height = "280px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("R-Index & Power"), uiOutput(ns("os_ri_rindex"))),
            card(card_header("Excess Significance"), tableOutput(ns("os_ri_es_table")))
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

open_science_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: Replication Crisis ──────────────────────────────────────────────
  rc_sim <- eventReactive(input$os_rc_go, {
    set.seed(sample(9999, 1))
    d    <- input$os_rc_true_d; n <- input$os_rc_n
    alph <- input$os_rc_alpha
    n_orig <- input$os_rc_n_studies; n_rep <- input$os_rc_n_rep

    # Simulate original studies; keep only significant ones
    es_orig <- numeric(0)
    count   <- 0; total <- 0
    repeat {
      total <- total + 1
      d_obs <- rnorm(1, d, sqrt(2/n))
      p_obs <- 2 * pnorm(-abs(d_obs / sqrt(2/n)))
      if (p_obs < alph) {
        es_orig <- c(es_orig, d_obs)
        count <- count + 1
      }
      if (count >= n_orig || total >= n_orig * 50) break
    }

    # Replicate with same n
    n_use <- min(length(es_orig), n_rep)
    d_orig_sig <- head(es_orig, n_use)
    d_rep <- rnorm(n_use, d, sqrt(2/n))
    p_rep <- 2 * pnorm(-abs(d_rep / sqrt(2/n)))
    rep_rate <- mean(p_rep < alph)

    # PPV calculation
    power_est <- pnorm(d / sqrt(2/n) - qnorm(1-alph/2)) +
                 pnorm(-d / sqrt(2/n) - qnorm(1-alph/2))
    pi_prior <- 0.5  # assume 50% prior
    ppv <- (pi_prior * power_est) / (pi_prior * power_est + (1-pi_prior) * alph)

    # Winner's curse
    mean_orig <- mean(d_orig_sig)
    mean_rep  <- mean(d_rep)

    list(d_orig = d_orig_sig, d_rep = d_rep, rep_rate = rep_rate,
         ppv = ppv, power = power_est, mean_orig = mean_orig, mean_rep = mean_rep,
         d_true = d)
  })

  output$os_rc_plot <- renderPlotly({
    req(rc_sim())
    r <- rc_sim()
    plot_ly() |>
      add_histogram(x = r$d_orig, name = "Original (significant)",
                    histnorm = "probability density", nbinsx = 20,
                    marker = list(color = "rgba(220,50,47,0.5)")) |>
      add_histogram(x = r$d_rep, name = "Replication attempts",
                    histnorm = "probability density", nbinsx = 20,
                    marker = list(color = "rgba(38,139,210,0.5)")) |>
      add_lines(x = c(r$d_true, r$d_true), y = c(0, 4),
                name = "True d", line = list(color = "#859900", dash = "dot", width = 2)) |>
      layout(barmode = "overlay",
             xaxis = list(title = "Effect size d"),
             yaxis = list(title = "Density"),
             legend = list(orientation = "h"))
  })

  output$os_rc_rate <- renderUI({
    req(rc_sim())
    r <- rc_sim()
    col <- if (r$rep_rate > 0.7) "#859900" else if (r$rep_rate > 0.4) "#b58900" else "#dc322f"
    tags$div(class = "text-center mt-2",
      tags$h2(sprintf("%.0f%%", r$rep_rate * 100),
              style = paste0("font-size: 2.5rem; color:", col, ";")),
      tags$p(class = "text-muted", "Replication rate"),
      tags$p(style = "font-size: 0.82rem;",
        if (r$rep_rate > 0.7) "\u2705 High" else if (r$rep_rate > 0.4) "\u26a0\ufe0f Moderate" else "\u274c Low"))
  })

  output$os_rc_ppv <- renderUI({
    req(rc_sim())
    r <- rc_sim()
    col <- if (r$ppv > 0.7) "#859900" else if (r$ppv > 0.4) "#b58900" else "#dc322f"
    tags$div(class = "text-center mt-2",
      tags$h2(sprintf("%.0f%%", r$ppv * 100),
              style = paste0("font-size: 2.5rem; color:", col, ";")),
      tags$p(class = "text-muted", "PPV of significant finding"),
      tags$p(style = "font-size: 0.82rem;",
        sprintf("Power = %.0f%% | Prior = 50%%", r$power * 100))
    )
  })

  output$os_rc_curse <- renderUI({
    req(rc_sim())
    r <- rc_sim()
    inflation <- r$mean_orig - r$d_true
    col <- if (abs(inflation) < 0.1) "#859900" else if (abs(inflation) < 0.3) "#b58900" else "#dc322f"
    tags$div(class = "text-center mt-2",
      tags$h2(sprintf("+%.2f", inflation),
              style = paste0("font-size: 2.5rem; color:", col, ";")),
      tags$p(class = "text-muted", "Winner's curse inflation"),
      tags$p(style = "font-size: 0.82rem;",
        sprintf("Mean published d = %.2f | True d = %.2f", r$mean_orig, r$d_true))
    )
  })

  # ── Tab 2: Pre-Registration ────────────────────────────────────────────────
  pr_sim <- eventReactive(input$os_pr_go, {
    set.seed(sample(9999, 1))
    alph <- input$os_pr_alpha_prespec; k <- input$os_pr_n_analytic
    j    <- input$os_pr_n_outcome; d <- input$os_pr_d_true
    nsim <- input$os_pr_n_sim
    n    <- 50

    # Registered: single pre-specified test
    p_reg <- sapply(seq_len(nsim), function(s) {
      x <- rnorm(n, d); y <- rnorm(n)
      2 * pnorm(-abs((mean(x) - mean(y)) / sqrt(2/n)))
    })
    fpr_reg <- mean(p_reg < alph)

    # Unregistered: take min p over k*j analyses
    p_unreg <- sapply(seq_len(nsim), function(s) {
      min(replicate(k * j, {
        x <- rnorm(n, d); y <- rnorm(n, rnorm(1, 0, 0.1))
        2 * pnorm(-abs((mean(x) - mean(y)) / sqrt(2/n)))
      }))
    })
    fpr_unreg <- mean(p_unreg < alph)

    alpha_eff <- 1 - (1 - alph)^(k * j)

    list(p_reg = p_reg, p_unreg = p_unreg, fpr_reg = fpr_reg,
         fpr_unreg = fpr_unreg, alpha_eff = alpha_eff,
         alph = alph, k = k, j = j)
  })

  output$os_pr_fpr <- renderPlotly({
    req(pr_sim())
    r <- pr_sim()
    plot_ly() |>
      add_histogram(x = r$p_reg, name = "Registered",
                    histnorm = "probability density", nbinsx = 30,
                    marker = list(color = "rgba(133,153,0,0.6)")) |>
      add_histogram(x = r$p_unreg, name = "Unregistered (best of k\u00d7j)",
                    histnorm = "probability density", nbinsx = 30,
                    marker = list(color = "rgba(220,50,47,0.5)")) |>
      add_lines(x = c(r$alph, r$alph), y = c(0, 15),
                name = paste0("\u03b1 = ", r$alph),
                line = list(color = "#073642", dash = "dot", width = 2)) |>
      layout(barmode = "overlay",
             xaxis = list(title = "p-value", range = c(0, 1)),
             yaxis = list(title = "Density"),
             legend = list(orientation = "h"))
  })

  output$os_pr_alpha_curve <- renderPlotly({
    r    <- pr_sim()
    req(r)
    k_seq <- seq(1, 20, 1)
    a_eff <- 1 - (1 - r$alph)^k_seq
    plot_ly(x = k_seq, y = a_eff, type = "scatter", mode = "lines+markers",
            line = list(color = "#dc322f", width = 2),
            marker = list(color = "#dc322f", size = 6)) |>
      add_lines(x = c(1, 20), y = c(r$alph, r$alph),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Analytic degrees of freedom (k\u00d7j)"),
             yaxis = list(title = "Effective \u03b1", range = c(0, 1)))
  })

  output$os_pr_table <- renderTable({
    req(pr_sim())
    r <- pr_sim()
    data.frame(
      Analysis   = c("Registered (single test)", "Unregistered (best of k\u00d7j)"),
      False_Pos  = round(c(r$fpr_reg, r$fpr_unreg), 4),
      Alpha_eff  = round(c(r$alph, r$alpha_eff), 4)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 3: Publication Bias ────────────────────────────────────────────────
  pb_sim <- eventReactive(input$os_pb_go, {
    set.seed(sample(9999, 1))
    d   <- input$os_pb_d_true; k <- input$os_pb_n_studies
    n   <- input$os_pb_n_per; pp <- input$os_pb_pub_prob
    alph <- 0.05

    es  <- rnorm(k, d, sqrt(2/n))
    se  <- rep(sqrt(2/n), k)
    p   <- 2 * pnorm(-abs(es / se))
    sig <- p < alph

    # Publish based on significance
    pub <- sig | (rbinom(k, 1, pp) == 1)
    es_pub <- es[pub]; se_pub <- se[pub]; sig_pub <- sig[pub]

    # Meta-analytic estimate
    w_all <- 1 / se^2; d_all <- sum(w_all * es) / sum(w_all)
    w_pub <- 1 / se_pub^2; d_pub <- sum(w_pub * es_pub) / sum(w_pub)

    # Trim-and-fill adjustment
    # Simplified: add mirror image of studies in smaller half
    median_es <- median(es_pub)
    side_small <- which(es_pub < median_es)
    side_large <- which(es_pub >= median_es)
    n_trim <- max(0, length(side_large) - length(side_small))
    es_fill <- median_es - (es_pub[head(order(es_pub, decreasing = TRUE), n_trim)] - median_es)
    se_fill <- se_pub[head(order(es_pub, decreasing = TRUE), n_trim)]
    es_tf <- c(es_pub, es_fill); se_tf <- c(se_pub, se_fill)
    w_tf  <- 1 / se_tf^2; d_tf <- sum(w_tf * es_tf) / sum(w_tf)

    list(es_pub = es_pub, se_pub = se_pub, sig_pub = sig_pub,
         d_true = d, d_all = d_all, d_pub = d_pub, d_tf = d_tf,
         n_fill = n_trim, k_pub = sum(pub))
  })

  output$os_pb_funnel <- renderPlotly({
    req(pb_sim())
    d <- pb_sim()
    cols <- ifelse(d$sig_pub, "#dc322f", "#268bd2")
    p <- plot_ly() |>
      add_markers(x = d$es_pub, y = -d$se_pub,
                  marker = list(color = cols, size = 7, opacity = 0.7),
                  text = ifelse(d$sig_pub, "Significant", "Non-significant"),
                  hovertemplate = "d=%{x:.3f}, SE=%{y:.3f} (%{text})<extra></extra>") |>
      add_lines(x = c(d$d_pub, d$d_pub), y = c(-max(d$se_pub)*1.1, 0),
                name = "Biased MA estimate", line = list(color = "#dc322f", dash = "dash"))

    if (input$os_pb_show_trim) {
      p <- p |> add_lines(x = c(d$d_tf, d$d_tf), y = c(-max(d$se_pub)*1.1, 0),
                           name = "Trim-and-fill",
                           line = list(color = "#2aa198", dash = "dot", width = 2))
    }
    p <- p |> add_lines(x = c(d$d_true, d$d_true), y = c(-max(d$se_pub)*1.1, 0),
                         name = "True d", line = list(color = "#859900", dash = "longdash"))
    p |> layout(xaxis = list(title = "Effect size d"),
                yaxis = list(title = "\u2212SE (precision)", zeroline = FALSE),
                legend = list(orientation = "h"))
  })

  output$os_pb_dist <- renderPlotly({
    req(pb_sim())
    d <- pb_sim()
    plot_ly() |>
      add_histogram(x = d$es_pub, name = "Published",
                    histnorm = "probability density", nbinsx = 20,
                    marker = list(color = "rgba(220,50,47,0.5)")) |>
      add_lines(x = c(d$d_true, d$d_true), y = c(0, 4),
                name = "True d", line = list(color = "#859900", dash = "dot", width = 2)) |>
      layout(barmode = "overlay",
             xaxis = list(title = "d"), yaxis = list(title = "Density"),
             legend = list(orientation = "h"))
  })

  output$os_pb_table <- renderTable({
    req(pb_sim())
    d <- pb_sim()
    data.frame(
      Estimate = c("True d", "All studies MA (oracle)",
                   "Published studies MA (biased)",
                   "Trim-and-fill corrected"),
      d    = round(c(d$d_true, d$d_all, d$d_pub, d$d_tf), 4),
      Bias = round(c(0, d$d_all - d$d_true, d$d_pub - d$d_true, d$d_tf - d$d_true), 4),
      k    = c(NA, length(d$es_pub) + 10, d$k_pub, d$k_pub + d$n_fill)
    )
  }, bordered = TRUE, striped = TRUE, na = "—")

  # ── Tab 4: R-Index & Diagnostics ──────────────────────────────────────────
  ri_sim <- eventReactive(input$os_ri_go, {
    set.seed(sample(9999, 1))
    k  <- input$os_ri_n_studies; d <- input$os_ri_d_true
    n  <- input$os_ri_n_per; sc <- input$os_ri_scenario
    alph <- 0.05

    gen_p <- function(d_use, phack = FALSE) {
      sapply(seq_len(k * 3), function(s) {
        if (phack) {
          # Optional stopping: peek at n, n+5, n+10, n+15
          p_min <- Inf
          for (nn in seq(n, n + 15, 5)) {
            x <- rnorm(nn, d_use); y <- rnorm(nn)
            p_min <- min(p_min, 2 * pnorm(-abs((mean(x)-mean(y)) / sqrt(2/nn))))
          }
          p_min
        } else {
          x <- rnorm(n, d_use); y <- rnorm(n)
          2 * pnorm(-abs((mean(x)-mean(y)) / sqrt(2/n)))
        }
      })
    }

    pvals <- switch(sc,
      "Normal (honest reporting)"   = gen_p(d)[1:k],
      "p-hacked (optional stopping)"= gen_p(d, phack = TRUE)[1:k],
      "Inflated (many studies, biased)" = {
        ps <- gen_p(d)
        sig <- ps[ps < 0.05]; nonsig <- ps[ps >= 0.05]
        c(head(sig, k * 0.9), head(nonsig, k * 0.1))[1:k]
      },
      "Null effect (all H0 true)"   = gen_p(0)[1:k]
    )
    pvals <- pvals[!is.na(pvals)]

    sig_rate  <- mean(pvals < alph)
    # R-Index
    # Estimate power from median significant p
    sig_p     <- pvals[pvals < alph]
    med_power <- if (length(sig_p) > 0) {
      # Convert median significant p to estimated power (approximate)
      z_med <- qnorm(1 - median(sig_p) / 2)
      pnorm(z_med - qnorm(0.975))
    } else 0
    inflation  <- sig_rate - med_power
    r_index    <- med_power - inflation

    # Expected significant given power
    exp_sig    <- k * med_power
    obs_sig    <- sum(pvals < alph)
    chi2_es    <- if (exp_sig > 0) (obs_sig - exp_sig)^2 / (exp_sig * (1 - alph)) else NA
    p_es       <- if (!is.na(chi2_es)) pchisq(chi2_es, 1, lower.tail = FALSE) else NA

    list(pvals = pvals, sig_rate = sig_rate, r_index = r_index,
         med_power = med_power, inflation = inflation,
         obs_sig = obs_sig, exp_sig = round(exp_sig, 1),
         chi2_es = chi2_es, p_es = p_es, sc = sc)
  })

  output$os_ri_pvals <- renderPlotly({
    req(ri_sim())
    r <- ri_sim()
    cols <- ifelse(r$pvals < 0.05, "#dc322f", "#268bd2")
    plot_ly(x = r$pvals, type = "histogram", nbinsx = 20,
            marker = list(color = cols)) |>
      add_lines(x = c(0.05, 0.05), y = c(0, length(r$pvals) * 0.3),
                line = list(color = "#073642", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "p-value", range = c(0, 1)),
             yaxis = list(title = "Count"),
             title = list(text = paste(r$sc, "\u2014 red = p < .05"), font = list(size = 11)))
  })

  output$os_ri_rindex <- renderUI({
    req(ri_sim())
    r <- ri_sim()
    col <- if (r$r_index > 0.5) "#859900" else if (r$r_index > 0) "#b58900" else "#dc322f"
    tags$div(class = "text-center mt-2",
      tags$h2(sprintf("%.2f", r$r_index),
              style = paste0("font-size: 2.5rem; color:", col, ";")),
      tags$p(class = "text-muted", "R-Index"),
      tags$p(style = "font-size: 0.82rem;",
        sprintf("Success rate: %.0f%% | Est. power: %.0f%% | Inflation: %.0f%%",
                r$sig_rate*100, r$med_power*100, r$inflation*100)),
      tags$p(class = "text-muted", style = "font-size: 0.8rem;",
        if (r$r_index > 0.5) "\u2705 Robust"
        else if (r$r_index > 0) "\u26a0\ufe0f Some concerns"
        else "\u274c High bias")
    )
  })

  output$os_ri_es_table <- renderTable({
    req(ri_sim())
    r <- ri_sim()
    data.frame(
      Metric      = c("Observed significant", "Expected (given power)",
                      "Excess \u03c7\u00b2", "p-value (excess sig.)"),
      Value       = c(r$obs_sig, r$exp_sig,
                      round(r$chi2_es, 3),
                      if (!is.na(r$p_es)) round(r$p_es, 4) else NA)
    )
  }, bordered = TRUE, striped = TRUE, na = "—")
  })
}
