# Module: Fairness & Bias (consolidated)
# Tabs: DIF Detection | Test Fairness | Person Fit | Item Parameter Drift

# ── UI ──────────────────────────────────────────────────────────────────
mod_fairness_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Fairness & Bias",
  icon = icon("scale-balanced"),
  navset_card_underline(

    # ── Tab 1: DIF Detection ─────────────────────────────────────
    nav_panel(
      "DIF Detection",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("dif_items"), "Number of items", min = 10, max = 40, value = 20, step = 5),
            sliderInput(ns("dif_n"), "N per group", min = 100, max = 1000, value = 300, step = 50),
            sliderInput(ns("dif_n_dif"), "Number of DIF items", min = 0, max = 10, value = 3, step = 1),
            sliderInput(ns("dif_magnitude"), "DIF magnitude (b shift)", min = 0, max = 2, value = 0.8, step = 0.1),
            selectInput(ns("dif_type"), "DIF type",
                        choices = c("Uniform (difficulty shift)" = "uniform",
                                    "Non-uniform (discrimination shift)" = "nonuniform")),
            actionButton(ns("dif_go"), "Simulate & Detect", class = "btn-success w-100 mb-2"),
            actionButton(ns("dif_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          explanation_box(
            tags$strong("Differential Item Functioning (DIF)"),
            tags$p("DIF occurs when examinees from different groups (e.g., gender, language)
                    with the same ability have different probabilities of answering an item
                    correctly. Uniform DIF means one group is consistently advantaged;
                    non-uniform DIF means the advantage depends on ability level."),
            tags$p("Detection methods include the Mantel-Haenszel statistic (for uniform DIF)
                    and IRT-based comparison of item parameters across groups. Items flagged
                    for DIF require content review \u2014 statistical DIF does not always mean bias."),
            tags$p("Uniform DIF is simpler to detect and interpret: one group has a consistently
                    higher or lower probability of success at every ability level. Non-uniform DIF
                    is more complex because the group advantage reverses at different ability levels,
                    requiring interaction terms in the detection model. The Mantel-Haenszel
                    procedure is effective for uniform DIF, while logistic regression and IRT
                    likelihood-ratio tests can detect both types."),
            tags$p("DIF analysis is a routine step in test development for high-stakes assessments.
                    Items flagged for DIF undergo expert content review to determine whether the
                    statistical signal reflects true bias (e.g., culturally unfair content) or
                    benign group differences in the construct being measured. Only items judged
                    to be unfair after content review are removed or revised."),
            guide = tags$ol(
              tags$li("Set the number of items and sample size per group."),
              tags$li("Choose how many items have DIF and the magnitude of the shift."),
              tags$li("Select uniform vs. non-uniform DIF."),
              tags$li("Click 'Simulate & Detect' to generate data and run DIF analysis."),
              tags$li("The flag table shows which items were detected as DIF."),
              tags$li("ICC comparison plots show the item curves for each group side by side.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(card_header("DIF Detection Results"), uiOutput(ns("dif_table"))),
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("ICC Comparison (DIF Items)"),
                   plotlyOutput(ns("dif_icc_plot"), height = "380px")),
              card(full_screen = TRUE, card_header("DIF Effect Size Plot"),
                   plotlyOutput(ns("dif_effect_plot"), height = "380px"))
            )
          )
        )
    ),

    # ── Tab 2: Test Fairness ─────────────────────────────────────
    nav_panel(
      "Test Fairness",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("fair_n"), "n per group", min = 50, max = 500,
                        value = 200, step = 50),
            sliderInput(ns("fair_mean_diff"), "True ability difference",
                        min = -1, max = 1, value = 0, step = 0.1),
            sliderInput(ns("fair_intercept_bias"), "Intercept bias",
                        min = -2, max = 2, value = 0, step = 0.25),
            sliderInput(ns("fair_slope_bias"), "Slope bias",
                        min = -0.5, max = 0.5, value = 0, step = 0.05),
            actionButton(ns("fair_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Test Fairness & Prediction Bias"),
            tags$p("A test is fair (unbiased) in prediction if the same regression equation
                    predicts outcomes equally well for all groups. This is known as the Cleary
                    model of test fairness, which focuses on prediction accuracy rather than
                    selection outcomes. A test can have group mean differences and still be
                    fair under this definition, as long as the prediction equation works
                    equally well for both groups. Bias can manifest in two main forms:"),
            tags$ul(
              tags$li(tags$strong("Intercept bias:"), " The test systematically over- or under-predicts for
                      one group at every score level. For example, using the same regression to
                      predict GPA from test scores might over-predict for one group and under-predict
                      for another."),
              tags$li(tags$strong("Slope bias:"), " The test is more predictive for one group than another
                      (a group \u00d7 predictor interaction). The test measures the criterion better
                      for one group."),
              tags$li(tags$strong("No bias:"), " A single regression line fits both groups equally well \u2014
                      the test predicts with equal accuracy regardless of group membership.")
            ),
            tags$p("The Cleary model of test fairness is one of several frameworks. Others include
                    Thorndike\u2019s model (equal selection ratios), Cole/Darlington model (equal
                    probability of selection given qualification), and decision-theoretic approaches.
                    These frameworks can lead to different conclusions about what constitutes
                    \u201cfair\u201d use, reflecting the fundamentally value-laden nature of fairness."),
            tags$p("In practice, prediction bias is assessed by fitting separate regression models
                    for each group and testing whether the intercepts and slopes differ significantly.
                    If the pooled model predicts equally well for both groups, using separate models
                    is unnecessary and wastes degrees of freedom. If bias is detected, separate
                    prediction equations or score adjustments may be warranted."),
            guide = tags$ol(
              tags$li("Set ability difference (real difference vs. test bias)."),
              tags$li("Add intercept or slope bias to see their effects."),
              tags$li("Click 'Simulate' \u2014 compare separate regression lines to the pooled line."),
              tags$li("A statistical test for bias compares models with and without group interaction terms.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Prediction Bias Plot"),
                 plotlyOutput(ns("fair_scatter"), height = "420px")),
            card(card_header("Bias Test (Cleary Model)"), tableOutput(ns("fair_test")))
          )
        )
    ),

    # ── Tab 3: Person Fit ────────────────────────────────────────
    nav_panel(
      "Person Fit",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("pf_n"), "Number of examinees", min = 100, max = 1000,
                        value = 300, step = 100),
            sliderInput(ns("pf_items"), "Number of items", min = 10, max = 40,
                        value = 20, step = 5),
            sliderInput(ns("pf_aberrant_pct"), "Aberrant responders (%)", min = 0, max = 20,
                        value = 10, step = 5),
            selectInput(ns("pf_aberrant_type"), "Aberrant pattern type",
              choices = c("Random guessing" = "guess",
                          "Cheating (easy wrong, hard right)" = "cheat",
                          "Creative (unusual pattern)" = "creative"),
              selected = "guess"
            ),
            actionButton(ns("pf_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Person Fit Statistics"),
            tags$p("Person fit statistics detect aberrant response patterns \u2014
                    people whose answers don't match the expected IRT model."),
            tags$ul(
              tags$li(tags$strong("l\u1d63 (standardised log-likelihood):"), " Compares the observed response
                      pattern to the model-predicted pattern. Values below \u22122 suggest the
                      pattern is implausible given the estimated ability."),
              tags$li(tags$strong("Infit/Outfit:"), " Weighted and unweighted mean square residuals.
                      Values > 1.5 indicate too much unpredictability; values < 0.5 indicate
                      too little variation (Guttman-like patterns). Outfit is more sensitive
                      to isolated unexpected responses."),
              tags$li(tags$strong("Guttman errors:"), " Count of items where a harder item is answered
                      correctly but an easier item is wrong. High counts suggest random responding,
                      guessing, or item-level cheating.")
            ),
            tags$p("Person fit analysis is important for data quality. Aberrant patterns can
                    arise from guessing, cheating, unmotivated responding, item compromise, or
                    misunderstanding test instructions. Flagging and reviewing misfitting response
                    patterns improves the validity of score interpretations, especially in
                    high-stakes contexts."),
            tags$p("The choice of person fit statistic depends on the type of aberrance expected.
                    The l\u1d63 statistic is a general-purpose measure, while infit is more
                    sensitive to unexpected responses on items near the person\u2019s ability
                    level, and outfit is more sensitive to isolated aberrant responses on very
                    easy or very hard items. Using multiple statistics provides a more complete
                    picture of response pattern quality."),
            tags$p("In large-scale testing programmes, person fit analysis is typically automated,
                    with flagged examinees receiving additional review. The threshold for flagging
                    involves a trade-off between sensitivity (catching true aberrance) and
                    specificity (avoiding false flags on legitimate respondents)."),
            guide = tags$ol(
              tags$li("Set the number of examinees, items, and percentage of aberrant responders."),
              tags$li("Choose an aberrant pattern type."),
              tags$li("Click 'Simulate' to generate data and compute person fit."),
              tags$li("Red points in the plot are truly aberrant responders. Check how well the statistic flags them.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Person Fit Statistic vs Ability"),
                 plotlyOutput(ns("pf_plot"), height = "400px")),
            card(card_header("Detection Performance"), tableOutput(ns("pf_perf")))
          )
        )
    ),

    # ── Tab 4: Item Parameter Drift ──────────────────────────────
    nav_panel(
      "Item Parameter Drift",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("ipd_items"), "Number of items", min = 10, max = 30,
                        value = 15, step = 5),
            sliderInput(ns("ipd_n"), "n per time point", min = 200, max = 1000,
                        value = 500, step = 100),
            sliderInput(ns("ipd_drift_pct"), "Items with drift (%)", min = 0, max = 40,
                        value = 20, step = 5),
            sliderInput(ns("ipd_drift_size"), "Drift magnitude (b shift)", min = 0.3, max = 2,
                        value = 0.7, step = 0.1),
            actionButton(ns("ipd_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Item Parameter Drift (IPD)"),
            tags$p("Over time, item parameters may change \u2014 this is item parameter drift.
                    Causes include curriculum changes, item exposure, cultural shifts, or
                    changes in the examinee population."),
            tags$ul(
              tags$li(tags$strong("Detection:"), " Compare item parameters estimated at two time points."),
              tags$li(tags$strong("Anchor items:"), " Items without drift that maintain the scale."),
              tags$li(tags$strong("Impact:"), " Undetected drift can bias ability estimates and equating.")
            ),
            tags$p("This module simulates data at two time points and identifies items
                    showing drift by comparing calibrations."),
            tags$p("IPD monitoring is a routine part of operational testing programmes. Items
                    with significant drift are typically removed from the operational pool or
                    re-calibrated. The challenge is distinguishing true drift from statistical
                    noise \u2014 multiple methods (e.g., comparing difficulty estimates, DIF-style
                    analyses between time points) and replication across administrations increase
                    confidence in drift detection."),
            guide = tags$ol(
              tags$li("Set the number of items, drift percentage, and magnitude."),
              tags$li("Click 'Simulate' to generate data at two time points."),
              tags$li("The plot compares Time 1 vs Time 2 difficulty estimates."),
              tags$li("Drifting items (red) fall away from the identity line.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Item Difficulty: Time 1 vs Time 2"),
                 plotlyOutput(ns("ipd_scatter"), height = "400px")),
            card(card_header("Drift Detection"), tableOutput(ns("ipd_table")))
          )
        )
    ),

    # ── Tab 5: Differential Test Functioning (DTF) ───────────────────
    nav_panel(
      "DTF",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("dtf_n"),    "Examinees per group", min = 100, max = 1000, value = 500, step = 100),
          sliderInput(ns("dtf_k"),    "Items",               min = 5,   max = 30,   value = 20,  step = 1),
          sliderInput(ns("dtf_dif_pct"), "% items with DIF", min = 0,   max = 60,   value = 20,  step = 5),
          sliderInput(ns("dtf_dif_d"),   "DIF magnitude (d)", min = 0.1, max = 1.5,  value = 0.5, step = 0.1),
          selectInput(ns("dtf_dif_dir"), "DIF direction",
                      choices = c("Unidirectional (all favour reference)" = "uni",
                                  "Balanced (cancelling DIF)"              = "bal")),
          sliderInput(ns("dtf_mean_diff"), "True group mean difference (\u0394\u03b8)",
                      min = -1.5, max = 1.5, value = 0, step = 0.25),
          actionButton(ns("dtf_go"), "Simulate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Differential Test Functioning (DTF)"),
          tags$p("DIF occurs at the item level \u2014 a single item favours one group after
                  matching on ability. DTF is the cumulative consequence at the test level:
                  when DIF items are summed into a total score, how much does the test
                  systematically over- or under-estimate one group's ability?"),
          tags$p("Crucially, DIF items can cancel each other out. If half the DIF items
                  favour the reference group and half favour the focal group (balanced DIF),
                  the total score may show little or no DTF even though individual items
                  are biased. Unidirectional DIF (all items favouring the same group)
                  produces maximum DTF."),
          tags$p("The Expected Score Curves (ESC) show the expected total score as a
                  function of \u03b8 for each group. DTF is the area between these curves,
                  quantified by the signed (sDTF) and unsigned (uDTF) area statistics."),
          tags$p("Signed DTF (sDTF) captures the net direction of bias: a positive value
                  means the reference group is systematically advantaged across the ability
                  scale. Unsigned DTF (uDTF) measures total test-level bias regardless of
                  direction, and will be large even when DIF is balanced (items cancelling
                  each other out). Proposed practical significance thresholds are uDTF
                  \u2265 0.10 scale-score units as a minimum for concern, and uDTF \u2265
                  0.20 as a strong indicator of bias requiring action."),
          tags$p("DTF is distinct from simple group mean differences on the total score.
                  A group difference in mean scores reflects both true ability differences
                  and any test bias \u2014 DTF analysis attempts to separate the two by
                  holding ability constant via the \u03b8 scale. A test can show a large
                  observed score gap between groups while having zero DTF (the difference
                  is due to genuine ability differences), or near-zero observed score gaps
                  while having substantial DTF (biases that happen to cancel in the observed
                  distribution)."),
          guide = tags$ol(
            tags$li("Set the percentage and magnitude of DIF items."),
            tags$li("Toggle between unidirectional and balanced DIF."),
            tags$li("Set a true group mean difference to separate ability from bias."),
            tags$li("Click 'Simulate' and compare the Expected Score Curves."),
            tags$li("Note: balanced DIF produces near-zero sDTF despite item-level bias.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Expected Score Curves by Group"),
                 plotlyOutput(ns("dtf_esc_plot"), height = "380px")),
            card(full_screen = TRUE, card_header("Item-Level DIF Contributions"),
                 plotlyOutput(ns("dtf_item_plot"), height = "380px"))
          ),
          card(card_header("DTF Summary"), tableOutput(ns("dtf_table")))
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_fairness_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── DIF Detection ──────────────────────────────────────────
  dif_data <- reactiveVal(NULL)
  
  observeEvent(input$dif_reset, {
    updateSliderInput(session, "dif_items", value = 20)
    updateSliderInput(session, "dif_n", value = 300)
    updateSliderInput(session, "dif_n_dif", value = 3)
    updateSliderInput(session, "dif_magnitude", value = 0.8)
    dif_data(NULL)
  })
  
  observeEvent(input$dif_go, {
    set.seed(sample(1:10000, 1))
    k <- input$dif_items; n <- input$dif_n
    n_dif <- min(input$dif_n_dif, k)
    mag <- input$dif_magnitude
    dif_type <- input$dif_type
  
    theta_r <- rnorm(n, 0, 1)
    theta_f <- rnorm(n, 0, 1)
  
    b <- seq(-2, 2, length.out = k)
    a <- rep(1.2, k)
    dif_items <- if (n_dif > 0) sample(seq_len(k), n_dif) else integer(0)
  
    # Reference group responses
    scored_r <- matrix(0L, n, k)
    for (j in seq_len(k)) {
      p <- 1 / (1 + exp(-a[j] * (theta_r - b[j])))
      scored_r[, j] <- rbinom(n, 1, p)
    }
  
    # Focal group responses (with DIF on selected items)
    b_f <- b; a_f <- a
    if (n_dif > 0) {
      if (dif_type == "uniform") {
        b_f[dif_items] <- b[dif_items] + mag
      } else {
        a_f[dif_items] <- a[dif_items] * (1 - mag * 0.5)
        b_f[dif_items] <- b[dif_items] + mag * 0.5
      }
    }
  
    scored_f <- matrix(0L, n, k)
    for (j in seq_len(k)) {
      p <- 1 / (1 + exp(-a_f[j] * (theta_f - b_f[j])))
      scored_f[, j] <- rbinom(n, 1, p)
    }
  
    colnames(scored_r) <- colnames(scored_f) <- paste0("Item", seq_len(k))
  
    # Mantel-Haenszel DIF test (simplified)
    total_r <- rowSums(scored_r)
    total_f <- rowSums(scored_f)
    all_scores <- c(total_r, total_f)
    group <- rep(c("Reference", "Focal"), each = n)
    score_bins <- cut(all_scores, breaks = quantile(all_scores, seq(0, 1, 0.2)),
                      include.lowest = TRUE)
  
    mh_results <- data.frame(Item = paste0("Item", seq_len(k)),
                              MH_OR = NA_real_, MH_chisq = NA_real_,
                              p_value = NA_real_, DIF_flag = "", True_DIF = "",
                              stringsAsFactors = FALSE)
  
    all_resp <- rbind(scored_r, scored_f)
    for (j in seq_len(k)) {
      # Stratified MH
      alpha_num <- 0; alpha_den <- 0; chisq_num <- 0; chisq_den <- 0
      for (lev in levels(score_bins)) {
        idx <- which(score_bins == lev)
        g <- group[idx]; resp <- all_resp[idx, j]
        n_r1 <- sum(resp[g == "Reference"] == 1)
        n_r0 <- sum(resp[g == "Reference"] == 0)
        n_f1 <- sum(resp[g == "Focal"] == 1)
        n_f0 <- sum(resp[g == "Focal"] == 0)
        t_n <- length(idx)
        if (t_n < 2) next
        alpha_num <- alpha_num + n_r1 * n_f0 / t_n
        alpha_den <- alpha_den + n_r0 * n_f1 / t_n
      }
      mh_or <- if (alpha_den > 0) alpha_num / alpha_den else NA
      # Simplified chi-square: use log(OR) ~ N(0, SE)
      if (!is.na(mh_or) && mh_or > 0) {
        log_or <- log(mh_or)
        # Use absolute value of Delta-MH
        delta_mh <- -2.35 * log_or
        mh_chisq <- log_or^2 / (1 / max(alpha_num, 0.5) + 1 / max(alpha_den, 0.5))
        p_val <- pchisq(abs(mh_chisq), 1, lower.tail = FALSE)
      } else {
        delta_mh <- NA; mh_chisq <- NA; p_val <- NA
      }
      mh_results$MH_OR[j] <- mh_or
      mh_results$MH_chisq[j] <- mh_chisq
      mh_results$p_value[j] <- p_val
      mh_results$DIF_flag[j] <- if (!is.na(p_val) && p_val < 0.05) "\u2717 DIF" else "\u2713 OK"
      mh_results$True_DIF[j] <- if (j %in% dif_items) "Yes" else "No"
    }
  
    dif_data(list(
      results = mh_results, dif_items = dif_items, k = k,
      b_r = b, b_f = b_f, a_r = a, a_f = a_f, dif_type = dif_type
    ))
  })
  
  output$dif_table <- renderUI({
    res <- dif_data(); req(res)
    df <- res$results
  
    header <- tags$tr(
      tags$th("Item"), tags$th("MH OR"), tags$th("\u03c7\u00b2"),
      tags$th("p-value"), tags$th("Flag"), tags$th("True DIF")
    )
  
    rows <- lapply(seq_len(nrow(df)), function(i) {
      flag_style <- if (df$DIF_flag[i] == "\u2717 DIF") "color:#e31a1c;font-weight:bold;" else "color:#238b45;"
      true_style <- if (df$True_DIF[i] == "Yes") "font-weight:bold;" else ""
      tags$tr(
        tags$td(df$Item[i]),
        tags$td(if (is.na(df$MH_OR[i])) "—" else round(df$MH_OR[i], 3)),
        tags$td(if (is.na(df$MH_chisq[i])) "—" else round(df$MH_chisq[i], 2)),
        tags$td(if (is.na(df$p_value[i])) "—" else format.pval(df$p_value[i], 3)),
        tags$td(style = flag_style, df$DIF_flag[i]),
        tags$td(style = true_style, df$True_DIF[i])
      )
    })
  
    div(style = "padding: 10px; max-height: 400px; overflow-y: auto;",
      tags$table(class = "table table-sm",
        tags$thead(header), tags$tbody(rows)
      )
    )
  })
  
  output$dif_icc_plot <- renderPlotly({
    res <- dif_data(); req(res, length(res$dif_items) > 0)
    theta <- seq(-4, 4, length.out = 300)
    show_items <- res$dif_items[seq_len(min(4, length(res$dif_items)))]

    dfs <- do.call(rbind, lapply(show_items, function(j) {
      p_r <- 1 / (1 + exp(-res$a_r[j] * (theta - res$b_r[j])))
      p_f <- 1 / (1 + exp(-res$a_f[j] * (theta - res$b_f[j])))
      data.frame(theta = rep(theta, 2), P = c(p_r, p_f),
                 Group = rep(c("Reference", "Focal"), each = length(theta)),
                 Item = paste0("Item", j),
                 text = paste0("Item", j, " (", rep(c("Reference", "Focal"), each = length(theta)), ")",
                               "<br>\u03b8 = ", round(rep(theta, 2), 2),
                               "<br>P(correct) = ", round(c(p_r, p_f), 3)))
    }))

    items <- unique(dfs$Item)
    subplots <- lapply(items, function(itm) {
      d <- dfs[dfs$Item == itm, ]
      d_r <- d[d$Group == "Reference", ]
      d_f <- d[d$Group == "Focal", ]
      plot_ly() |>
        add_trace(x = d_r$theta, y = d_r$P, type = "scatter", mode = "lines",
                  name = "Reference", line = list(color = "#238b45", width = 2),
                  hoverinfo = "text", text = d_r$text,
                  legendgroup = "Reference", showlegend = (itm == items[1])) |>
        add_trace(x = d_f$theta, y = d_f$P, type = "scatter", mode = "lines",
                  name = "Focal", line = list(color = "#e31a1c", width = 2, dash = "dash"),
                  hoverinfo = "text", text = d_f$text,
                  legendgroup = "Focal", showlegend = (itm == items[1])) |>
        layout(
          xaxis = list(title = "\u03b8"),
          yaxis = list(title = "P(correct)", range = c(0, 1)),
          annotations = list(
            list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
                 text = itm, showarrow = FALSE, font = list(size = 11))
          )
        )
    })
    subplot(subplots, nrows = 1, shareY = TRUE, titleX = TRUE) |>
      layout(legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.08))
  })

  output$dif_effect_plot <- renderPlotly({
    res <- dif_data(); req(res)
    df <- res$results
    df$log_or <- log(pmax(df$MH_OR, 0.01))
    df$True_DIF <- factor(df$True_DIF, levels = c("No", "Yes"))
    df$Item <- factor(df$Item, levels = df$Item)

    threshold <- round(log(1.5), 2)
    df$text <- paste0(df$Item,
                      "<br>log(MH OR) = ", round(df$log_or, 3),
                      "<br>True DIF: ", df$True_DIF,
                      "<br>Threshold: \u00b1", threshold)
    no_dif <- df$True_DIF == "No"
    items_chr <- as.character(df$Item)

    plot_ly() |>
      add_bars(x = items_chr[no_dif], y = df$log_or[no_dif], name = "No",
               text = df$text[no_dif], textposition = "none", hoverinfo = "text",
               marker = list(color = "#238b45", opacity = 0.8)) |>
      add_bars(x = items_chr[!no_dif], y = df$log_or[!no_dif], name = "Yes",
               text = df$text[!no_dif], textposition = "none", hoverinfo = "text",
               marker = list(color = "#e31a1c", opacity = 0.8)) |>
      layout(
        xaxis = list(title = "", tickangle = -45,
                     categoryorder = "array", categoryarray = items_chr),
        yaxis = list(title = "log(MH Odds Ratio)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05,
                      title = list(text = "True DIF")),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = log(1.5), y1 = log(1.5),
               line = list(color = "#e31a1c", dash = "dash", width = 1, opacity = 0.5)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = -log(1.5), y1 = -log(1.5),
               line = list(color = "#e31a1c", dash = "dash", width = 1, opacity = 0.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = log(1.5),
               text = paste0("DIF threshold (\u00b1", threshold, ")"),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c")),
          list(x = 1.02, xref = "paper", y = -log(1.5),
               text = paste0("-", threshold),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        )
      )
  })
  

  # ── Test Fairness ──────────────────────────────────────────
  fair_data <- reactiveVal(NULL)

  observeEvent(input$fair_go, {
    n <- input$fair_n; d <- input$fair_mean_diff
    int_bias <- input$fair_intercept_bias; slope_bias <- input$fair_slope_bias
    set.seed(sample.int(10000, 1))

    # Group A: reference group
    ability_a <- rnorm(n, 0, 1)
    test_a <- 1.5 * ability_a + rnorm(n, 0, 1)
    criterion_a <- 2 + 1.0 * test_a + rnorm(n, 0, 1)

    # Group B: potentially biased
    ability_b <- rnorm(n, d, 1)
    test_b <- 1.5 * ability_b + int_bias + rnorm(n, 0, 1)
    criterion_b <- 2 + (1.0 + slope_bias) * test_b + rnorm(n, 0, 1)

    dat <- data.frame(
      test = c(test_a, test_b),
      criterion = c(criterion_a, criterion_b),
      group = factor(rep(c("Reference", "Focal"), each = n))
    )
    fair_data(dat)
  })

  output$fair_scatter <- renderPlotly({
    dat <- fair_data()
    req(dat)
    xseq <- seq(min(dat$test), max(dat$test), length.out = 100)
    cols <- c(Reference = "#3182bd", Focal = "#e31a1c")

    p <- plotly::plot_ly()
    for (g in c("Reference", "Focal")) {
      d <- dat[dat$group == g, ]
      fit <- lm(criterion ~ test, data = d)
      yhat <- predict(fit, newdata = data.frame(test = xseq))
      p <- p |>
        plotly::add_markers(x = d$test, y = d$criterion,
                            marker = list(color = cols[g], size = 4, opacity = 0.3),
                            name = g, showlegend = TRUE, hoverinfo = "skip") |>
        plotly::add_trace(x = xseq, y = as.numeric(yhat),
                          type = "scatter", mode = "lines",
                          line = list(color = cols[g], width = 2),
                          showlegend = FALSE, hoverinfo = "skip")
    }
    # Pooled line
    fit_pool <- lm(criterion ~ test, data = dat)
    yhat_pool <- predict(fit_pool, newdata = data.frame(test = xseq))
    p <- p |>
      plotly::add_trace(x = xseq, y = as.numeric(yhat_pool),
                        type = "scatter", mode = "lines",
                        line = list(color = "#333", width = 2, dash = "dash"),
                        name = "Pooled", hoverinfo = "skip")

    p |> plotly::layout(
      xaxis = list(title = "Test Score"), yaxis = list(title = "Criterion"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$fair_test <- renderTable({
    dat <- fair_data(); req(dat)
    # Model comparison: no bias vs intercept bias vs slope bias
    m0 <- lm(criterion ~ test, data = dat)
    m1 <- lm(criterion ~ test + group, data = dat)
    m2 <- lm(criterion ~ test * group, data = dat)

    a1 <- anova(m0, m1)
    a2 <- anova(m1, m2)

    data.frame(
      Comparison = c("Intercept bias (M0 vs M1)", "Slope bias (M1 vs M2)"),
      `F statistic` = round(c(a1$F[2], a2$F[2]), 3),
      `p value` = c(format.pval(a1$`Pr(>F)`[2], digits = 4),
                     format.pval(a2$`Pr(>F)`[2], digits = 4)),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Person Fit ─────────────────────────────────────────────
  pf_data <- reactiveVal(NULL)

  observeEvent(input$pf_go, {
    n <- input$pf_n; J <- input$pf_items
    ab_pct <- input$pf_aberrant_pct / 100
    ab_type <- input$pf_aberrant_type
    set.seed(sample.int(10000, 1))

    n_ab <- round(n * ab_pct); n_norm <- n - n_ab

    # Item parameters (2PL)
    a <- runif(J, 0.5, 2.5)
    b <- sort(runif(J, -2, 2))

    # Normal examinees
    theta_norm <- rnorm(n_norm, 0, 1)
    X_norm <- matrix(0, n_norm, J)
    for (i in seq_len(n_norm)) {
      p <- 1 / (1 + exp(-a * (theta_norm[i] - b)))
      X_norm[i, ] <- rbinom(J, 1, p)
    }

    # Aberrant examinees
    if (n_ab > 0) {
      theta_ab <- rnorm(n_ab, 0, 1)
      X_ab <- matrix(0, n_ab, J)
      for (i in seq_len(n_ab)) {
        p <- 1 / (1 + exp(-a * (theta_ab[i] - b)))
        if (ab_type == "guess") {
          X_ab[i, ] <- rbinom(J, 1, 0.25)
        } else if (ab_type == "cheat") {
          # Get easy items wrong, hard items right
          X_ab[i, ] <- rbinom(J, 1, 1 - p)
        } else {
          # Random on first half, perfect on second half
          X_ab[i, 1:(J %/% 2)] <- rbinom(J %/% 2, 1, 0.5)
          X_ab[i, (J %/% 2 + 1):J] <- 1
        }
      }
      theta_all <- c(theta_norm, theta_ab)
      X_all <- rbind(X_norm, X_ab)
    } else {
      theta_all <- theta_norm
      X_all <- X_norm
    }
    aberrant <- c(rep(FALSE, n_norm), rep(TRUE, n_ab))

    # Compute l_z (simplified: use true theta)
    lz <- numeric(length(theta_all))
    for (i in seq_along(theta_all)) {
      p <- 1 / (1 + exp(-a * (theta_all[i] - b)))
      p <- pmin(pmax(p, 0.001), 0.999)
      ll <- sum(X_all[i, ] * log(p) + (1 - X_all[i, ]) * log(1 - p))
      E_ll <- sum(p * log(p) + (1 - p) * log(1 - p))
      V_ll <- sum(p * (1 - p) * (log(p / (1 - p)))^2)
      lz[i] <- (ll - E_ll) / sqrt(V_ll)
    }

    # Compute outfit (unweighted mean square)
    outfit <- numeric(length(theta_all))
    for (i in seq_along(theta_all)) {
      p <- 1 / (1 + exp(-a * (theta_all[i] - b)))
      p <- pmin(pmax(p, 0.001), 0.999)
      z2 <- (X_all[i, ] - p)^2 / (p * (1 - p))
      outfit[i] <- mean(z2)
    }

    pf_data(list(theta = theta_all, lz = lz, outfit = outfit,
                 aberrant = aberrant, n = length(theta_all)))
  })

  output$pf_plot <- renderPlotly({
    res <- pf_data()
    req(res)
    col <- ifelse(res$aberrant, "#e31a1c", "rgba(35,139,69,0.4)")

    plotly::plot_ly() |>
      plotly::add_markers(
        x = res$theta, y = res$lz,
        marker = list(color = col, size = 5),
        hoverinfo = "text", showlegend = FALSE,
        text = paste0("\u03b8 = ", round(res$theta, 2),
                       "<br>l\u1d63 = ", round(res$lz, 2),
                       "<br>Aberrant: ", res$aberrant)
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = min(res$theta), x1 = max(res$theta),
          y0 = -2, y1 = -2,
          line = list(color = "#e31a1c", width = 1.5, dash = "dash")
        )),
        xaxis = list(title = "\u03b8 (Ability)"),
        yaxis = list(title = "l\u1d63 (Person fit)"),
        annotations = list(list(
          x = max(res$theta), y = -2, text = "Cutoff = \u22122",
          showarrow = FALSE, font = list(size = 11, color = "#e31a1c"),
          xanchor = "right", yanchor = "bottom"
        )),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$pf_perf <- renderTable({
    res <- pf_data(); req(res)
    flagged <- res$lz < -2
    tp <- sum(flagged & res$aberrant)
    fp <- sum(flagged & !res$aberrant)
    fn <- sum(!flagged & res$aberrant)
    tn <- sum(!flagged & !res$aberrant)
    n_ab <- sum(res$aberrant)
    n_flag <- sum(flagged)

    data.frame(
      Metric = c("True aberrant", "Flagged (l\u1d63 < \u22122)",
                  "True positives", "False positives", "Missed",
                  "Precision", "Recall"),
      Value = c(n_ab, n_flag, tp, fp, fn,
                if (n_flag > 0) round(tp / n_flag, 3) else NA,
                if (n_ab > 0) round(tp / n_ab, 3) else NA)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Item Parameter Drift ───────────────────────────────────
  ipd_data <- reactiveVal(NULL)

  observeEvent(input$ipd_go, {
    J <- input$ipd_items; n <- input$ipd_n
    drift_pct <- input$ipd_drift_pct / 100
    drift_size <- input$ipd_drift_size
    set.seed(sample.int(10000, 1))

    # Item parameters
    a <- runif(J, 0.5, 2.0)
    b_t1 <- sort(runif(J, -2, 2))

    # Select drifting items
    n_drift <- max(1, round(J * drift_pct))
    drift_items <- sort(sample(J, n_drift))
    b_t2 <- b_t1
    drift_direction <- sample(c(-1, 1), n_drift, replace = TRUE)
    b_t2[drift_items] <- b_t2[drift_items] + drift_direction * drift_size

    # Simulate Time 1
    theta_t1 <- rnorm(n)
    X_t1 <- matrix(0, n, J)
    for (j in seq_len(J)) {
      p <- 1 / (1 + exp(-a[j] * (theta_t1 - b_t1[j])))
      X_t1[, j] <- rbinom(n, 1, p)
    }

    # Simulate Time 2
    theta_t2 <- rnorm(n)
    X_t2 <- matrix(0, n, J)
    for (j in seq_len(J)) {
      p <- 1 / (1 + exp(-a[j] * (theta_t2 - b_t2[j])))
      X_t2[, j] <- rbinom(n, 1, p)
    }

    # Estimate difficulties from proportion correct (simple proxy)
    p_t1 <- colMeans(X_t1)
    p_t2 <- colMeans(X_t2)
    b_hat_t1 <- -qlogis(p_t1)
    b_hat_t2 <- -qlogis(p_t2)

    # Detect drift: simple z-test on proportion differences
    se_diff <- sqrt(p_t1 * (1 - p_t1) / n + p_t2 * (1 - p_t2) / n)
    z_stat <- (p_t1 - p_t2) / se_diff
    flagged <- abs(z_stat) > 2

    drifted <- seq_len(J) %in% drift_items

    ipd_data(list(b_hat_t1 = b_hat_t1, b_hat_t2 = b_hat_t2,
                  drifted = drifted, flagged = flagged, z_stat = z_stat,
                  J = J, drift_items = drift_items))
  })

  output$ipd_scatter <- renderPlotly({
    res <- ipd_data()
    req(res)
    col <- ifelse(res$drifted, "#e31a1c", "#238b45")
    shape <- ifelse(res$flagged, "diamond", "circle")
    rng <- range(c(res$b_hat_t1, res$b_hat_t2))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = res$b_hat_t1, y = res$b_hat_t2,
        marker = list(color = col, size = 8, symbol = shape,
                      line = list(color = "#333", width = 1)),
        hoverinfo = "text", showlegend = FALSE,
        text = paste0("Item ", seq_len(res$J),
                       "<br>b\u0302 T1 = ", round(res$b_hat_t1, 2),
                       "<br>b\u0302 T2 = ", round(res$b_hat_t2, 2),
                       "<br>z = ", round(res$z_stat, 2),
                       "<br>True drift: ", res$drifted,
                       "<br>Flagged: ", res$flagged)
      ) |>
      plotly::add_trace(x = rng, y = rng, type = "scatter", mode = "lines",
                        line = list(color = "grey60", width = 1, dash = "dash"),
                        showlegend = FALSE, hoverinfo = "skip") |>
      plotly::layout(
        xaxis = list(title = "b\u0302 Time 1"), yaxis = list(title = "b\u0302 Time 2"),
        annotations = list(list(
          x = 0.02, y = 0.98, xref = "paper", yref = "paper",
          text = "Red = truly drifted<br>Diamond = flagged",
          showarrow = FALSE, font = list(size = 10), xanchor = "left", yanchor = "top"
        )),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ipd_table <- renderTable({
    res <- ipd_data(); req(res)
    tp <- sum(res$flagged & res$drifted)
    fp <- sum(res$flagged & !res$drifted)
    fn <- sum(!res$flagged & res$drifted)
    n_drift <- sum(res$drifted)
    n_flag <- sum(res$flagged)
    data.frame(
      Metric = c("Total items", "True drifting items", "Flagged items",
                  "True positives", "False positives", "Missed",
                  "Precision", "Recall"),
      Value = c(res$J, n_drift, n_flag, tp, fp, fn,
                if (n_flag > 0) round(tp / n_flag, 3) else NA,
                if (n_drift > 0) round(tp / n_drift, 3) else NA)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 5: DTF server ─────────────────────────────────────────────────

  dtf_data <- reactiveVal(NULL)

  observeEvent(input$dtf_go, {
    set.seed(sample(1:10000, 1))
    N     <- input$dtf_n
    K     <- input$dtf_k
    pct   <- input$dtf_dif_pct / 100
    d_dif <- input$dtf_dif_d
    dir   <- input$dtf_dif_dir
    delta <- input$dtf_mean_diff

    # Item parameters (shared base)
    b_base <- sort(runif(K, -2, 2))
    a_base <- runif(K, 0.7, 1.8)

    # Which items have DIF
    n_dif  <- round(K * pct)
    dif_items <- if (n_dif > 0) sample(seq_len(K), n_dif) else integer(0)

    # DIF shifts for focal group (positive = harder for focal)
    dif_shift <- rep(0, K)
    if (n_dif > 0) {
      if (dir == "uni") {
        dif_shift[dif_items] <- d_dif
      } else {
        half <- ceiling(n_dif / 2)
        dif_shift[dif_items[seq_len(half)]]        <-  d_dif
        dif_shift[dif_items[seq_len(n_dif)[-seq_len(half)]]] <- -d_dif
      }
    }

    # Ability distributions
    theta_ref   <- rnorm(N, 0, 1)
    theta_focal <- rnorm(N, delta, 1)

    # Expected score as function of theta for each group
    theta_seq <- seq(-4, 4, length.out = 200)

    esc_ref <- sapply(theta_seq, function(th) {
      sum(1 / (1 + exp(-a_base * (th - b_base))))
    })
    esc_foc <- sapply(theta_seq, function(th) {
      sum(1 / (1 + exp(-a_base * (th - (b_base + dif_shift)))))
    })

    # DTF statistics: area between ESC curves
    dtf_signed   <- mean(esc_ref - esc_foc)
    dtf_unsigned <- mean(abs(esc_ref - esc_foc))

    # Item-level expected score difference (at theta=0)
    item_diff <- sapply(seq_len(K), function(j) {
      p_ref <- 1 / (1 + exp(-a_base[j] * (0 - b_base[j])))
      p_foc <- 1 / (1 + exp(-a_base[j] * (0 - (b_base[j] + dif_shift[j]))))
      p_ref - p_foc
    })

    dtf_data(list(
      theta_seq = theta_seq, esc_ref = esc_ref, esc_foc = esc_foc,
      item_diff = item_diff, dif_shift = dif_shift, dif_items = dif_items,
      dtf_signed = dtf_signed, dtf_unsigned = dtf_unsigned,
      K = K, n_dif = n_dif, delta = delta, dir = dir, d_dif = d_dif
    ))
  })

  output$dtf_esc_plot <- renderPlotly({
    d <- dtf_data(); req(d)
    plot_ly() |>
      add_trace(x = d$theta_seq, y = d$esc_ref,
                type = "scatter", mode = "lines", name = "Reference group",
                line = list(color = "#268bd2", width = 2.5)) |>
      add_trace(x = d$theta_seq, y = d$esc_foc,
                type = "scatter", mode = "lines", name = "Focal group",
                line = list(color = "#dc322f", width = 2.5, dash = "dash")) |>
      layout(
        xaxis = list(title = "\u03b8 (Ability)"),
        yaxis = list(title = "Expected Total Score"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        annotations = list(list(
          x = 0.02, y = 0.98, xref = "paper", yref = "paper",
          text = paste0("sDTF = ", round(d$dtf_signed, 3),
                        "  |  uDTF = ", round(d$dtf_unsigned, 3)),
          showarrow = FALSE, font = list(size = 12),
          xanchor = "left", yanchor = "top"
        )),
        margin = list(t = 10, b = 50)
      ) |> config(displayModeBar = FALSE)
  })

  output$dtf_item_plot <- renderPlotly({
    d <- dtf_data(); req(d)
    is_dif <- seq_len(d$K) %in% d$dif_items
    cols <- ifelse(is_dif, "#dc322f", "#268bd2")

    plot_ly(
      x    = paste0("I", seq_len(d$K)),
      y    = d$item_diff,
      type = "bar",
      marker = list(color = cols),
      hoverinfo = "text",
      text = paste0("Item ", seq_len(d$K),
                    "<br>DIF shift: ", round(d$dif_shift, 2),
                    "<br>Score diff at \u03b8=0: ", round(d$item_diff, 3))
    ) |> layout(
      xaxis = list(title = "Item", tickangle = -45),
      yaxis = list(title = "P(ref) \u2212 P(foc) at \u03b8 = 0"),
      shapes = list(list(type = "line", x0 = -0.5, x1 = d$K - 0.5,
                         y0 = 0, y1 = 0,
                         line = list(color = "grey60", width = 1))),
      annotations = list(list(
        x = 0.02, y = 0.98, xref = "paper", yref = "paper",
        text = "<span style='color:#dc322f'>\u25a0</span> DIF item  
                <span style='color:#268bd2'>\u25a0</span> No DIF",
        showarrow = FALSE, font = list(size = 11),
        xanchor = "left", yanchor = "top"
      )),
      margin = list(t = 10, b = 60)
    ) |> config(displayModeBar = FALSE)
  })

  output$dtf_table <- renderTable({
    d <- dtf_data(); req(d)
    pos_dif <- sum(d$dif_shift > 0)
    neg_dif <- sum(d$dif_shift < 0)
    data.frame(
      Statistic = c("Items", "DIF items", "DIF favouring reference",
                    "DIF favouring focal", "DIF magnitude (d)",
                    "True \u0394\u03b8 (focal \u2212 ref)",
                    "Signed DTF (sDTF)", "Unsigned DTF (uDTF)"),
      Value = c(d$K, d$n_dif, pos_dif, neg_dif,
                sprintf("%.2f", d$d_dif),
                sprintf("%.2f", d$delta),
                sprintf("%.3f", d$dtf_signed),
                sprintf("%.3f", d$dtf_unsigned))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
