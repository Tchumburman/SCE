# Module: Interrater Reliability & Cohen's Kappa
# 3 tabs: Cohen's Kappa · Weighted Kappa · Prevalence & Bias

# ── Helpers ───────────────────────────────────────────────────────────────────
compute_kappa <- function(mat) {
  n     <- sum(mat)
  p_o   <- sum(diag(mat)) / n
  p_e   <- sum(rowSums(mat) / n * colSums(mat) / n)
  kappa <- (p_o - p_e) / (1 - p_e)
  se    <- sqrt((p_o * (1 - p_o)) / (n * (1 - p_e)^2))
  list(kappa = round(kappa, 4), p_o = round(p_o, 4),
       p_e = round(p_e, 4), se = round(se, 4),
       ci_lo = round(kappa - 1.96 * se, 3),
       ci_hi = round(kappa + 1.96 * se, 3))
}

compute_weighted_kappa <- function(mat, type = "quadratic") {
  n   <- sum(mat)
  k   <- nrow(mat)
  idx <- seq_len(k)
  W   <- outer(idx, idx, function(i, j) {
    if (type == "linear")    1 - abs(i - j) / (k - 1)
    else if (type == "none") as.numeric(i == j)
    else                     1 - (i - j)^2 / (k - 1)^2
  })
  p_ij  <- mat / n
  r_i   <- rowSums(p_ij);  c_j <- colSums(p_ij)
  p_o_w <- sum(W * p_ij)
  p_e_w <- sum(W * outer(r_i, c_j))
  kappa_w <- (p_o_w - p_e_w) / (1 - p_e_w)
  round(kappa_w, 4)
}

kappa_label <- function(k) {
  if (k < 0)    "Poor (< 0)"
  else if (k < 0.20) "Slight (0.00–0.20)"
  else if (k < 0.40) "Fair (0.20–0.40)"
  else if (k < 0.60) "Moderate (0.40–0.60)"
  else if (k < 0.80) "Substantial (0.60–0.80)"
  else               "Almost Perfect (≥ 0.80)"
}

simulate_ratings <- function(n, k, agree_prob, bias1 = 0, bias2 = 0, seed = 42) {
  set.seed(seed)
  # "True" category for each item, with optional prevalence skew
  probs_true <- rep(1 / k, k)
  true_cat <- sample(seq_len(k), n, replace = TRUE, prob = probs_true)

  rater <- function(true, bias) {
    sapply(true, function(tc) {
      if (runif(1) < agree_prob) return(tc)
      probs <- rep(1 / (k - 1), k);  probs[tc] <- 0
      # add bias: shift toward category 1
      if (bias != 0 && k > 1) {
        probs[1] <- probs[1] * (1 + abs(bias))
        probs <- probs / sum(probs)
      }
      sample(seq_len(k), 1, prob = probs)
    })
  }
  r1 <- rater(true_cat, bias1)
  r2 <- rater(true_cat, bias2)
  table(Rater1 = factor(r1, seq_len(k)),
        Rater2 = factor(r2, seq_len(k)))
}

# ── UI ────────────────────────────────────────────────────────────────────────
interrater_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Interrater Reliability",
  icon = icon("users-between-lines"),
  navset_card_underline(

    # ── Tab 1: Cohen's Kappa ──────────────────────────────────────────────────
    nav_panel(
      "Cohen's Kappa",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ir_n"), "Number of items rated", 20, 500, 100, 10),
          sliderInput(ns("ir_k"), "Number of categories", 2, 6, 3, 1),
          sliderInput(ns("ir_agree"), "True agreement probability", 0.3, 1.0, 0.7, 0.05),
          tags$hr(),
          sliderInput(ns("ir_seed"), "Random seed", 1, 9999, 42, 1),
          actionButton(ns("ir_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Cohen's Kappa (κ)"),
          tags$p("Percent agreement is misleading because two raters could agree by chance
                  simply by guessing. Cohen's kappa corrects for this:"),
          tags$p(tags$code("κ = (p_o − p_e) / (1 − p_e)"), ", where p_o is the observed
                  proportion of agreement and p_e is the agreement expected by chance."),
          tags$p("p_e is calculated from the marginal totals: if Rater 1 uses category A
                  40% of the time and Rater 2 uses it 35% of the time, they will agree on
                  A by chance 0.40 × 0.35 = 14% of the time. Summing across all categories
                  gives p_e. κ = 0 means agreement no better than chance; κ = 1 is perfect
                  agreement; κ < 0 means systematic disagreement."),
          tags$p("Landis & Koch (1977) benchmarks: < 0.20 Slight, 0.20–0.40 Fair,
                  0.40–0.60 Moderate, 0.60–0.80 Substantial, ≥ 0.80 Almost Perfect.
                  These benchmarks are widely used but not universally accepted —
                  treat them as rough guides, not bright lines."),
          tags$p("Kappa requires the same set of categories for both raters and that
                  categories are nominal (unordered). For ordinal categories, use
                  weighted kappa instead. Kappa also assumes independence of items,
                  and can be sensitive to the number of categories and their marginal
                  distributions — see the Prevalence & Bias tab for more."),
          guide = tags$ol(
            tags$li("Set the number of items and categories."),
            tags$li("Adjust 'True agreement probability' — the chance each rater correctly
                     reproduces the item's true category."),
            tags$li("Click Simulate and read κ from the stats panel."),
            tags$li("Compare the observed agreement % and chance-expected % to
                     understand how much κ discounts the raw agreement.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Agreement Matrix"),
               plotlyOutput(ns("ir_heatmap"), height = "360px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Kappa Statistics"), uiOutput(ns("ir_kappa_stats"))),
            card(card_header("Interpretation"), uiOutput(ns("ir_kappa_interp")))
          )
        )
      )
    ),

    # ── Tab 2: Weighted Kappa ─────────────────────────────────────────────────
    nav_panel(
      "Weighted Kappa",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("wk_n"), "Number of items", 50, 500, 150, 50),
          sliderInput(ns("wk_k"), "Ordinal scale points", 3, 7, 5, 1),
          sliderInput(ns("wk_agree"), "Agreement probability", 0.3, 1.0, 0.65, 0.05),
          sliderInput(ns("wk_seed"), "Random seed", 1, 9999, 7, 1),
          actionButton(ns("wk_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Weighted Kappa"),
          tags$p("When categories are ordered (e.g., a 1–5 severity scale), not all
                  disagreements are equal. Being off by one point is less serious than
                  being off by four. Weighted kappa incorporates a weight matrix W where
                  W_ij reflects the credit given to cells (i, j):"),
          tags$ul(
            tags$li(tags$strong("Unweighted (κ)"), ": credit only for exact agreement —
                     W_ij = 1 if i = j, else 0."),
            tags$li(tags$strong("Linear weights"), ": W_ij = 1 − |i − j| / (k − 1).
                     Partial credit decreases linearly with distance."),
            tags$li(tags$strong("Quadratic weights"), ": W_ij = 1 − (i − j)² / (k − 1)².
                     Near-misses are penalised little; large disagreements heavily. This is
                     equivalent to the intraclass correlation coefficient (ICC) for two raters.")
          ),
          tags$p("Quadratic-weighted kappa is the standard in many clinical and educational
                  measurement contexts (e.g., essay scoring, pain ratings) because large
                  disagreements are penalised much more than small ones. Note that
                  quadratic-weighted kappa always ≥ linear-weighted kappa ≥ unweighted kappa
                  when disagreements are spread across adjacent categories."),
          tags$p("The weight matrix is shown below the kappa comparison table so you can
                  see exactly how credit is assigned to each cell."),
          guide = tags$ol(
            tags$li("Set the scale points (3–7) and simulate ratings."),
            tags$li("Compare the three kappa values in the table — unweighted is strictest."),
            tags$li("Inspect the weight matrices: quadratic gives near-misses much more credit.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(card_header("Kappa Comparison: Unweighted vs Linear vs Quadratic"),
               tableOutput(ns("wk_table"))),
          card(full_screen = TRUE,
               card_header("Weight Matrices"),
               plotlyOutput(ns("wk_weights_plot"), height = "380px"))
        )
      )
    ),

    # ── Tab 3: Prevalence & Bias ───────────────────────────────────────────────
    nav_panel(
      "Prevalence & Bias",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$p(class = "text-muted small",
            "2-category case: observe how kappa changes as the prevalence of
             'positive' items changes, even when raw agreement stays fixed."),
          sliderInput(ns("pb_agree"), "Fixed raw agreement (%)", 50, 99, 80, 1),
          sliderInput(ns("pb_n"), "Items per simulation", 100, 2000, 400, 100),
          actionButton(ns("pb_go"), "Run", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("The Prevalence & Bias Problem"),
          tags$p("Kappa has a well-known sensitivity to the prevalence of the categories
                  being rated. With two categories (e.g., Present / Absent), if one
                  category is very rare or very common, p_e becomes large, making kappa
                  small even when raw agreement is high. This is the",
                  tags$strong("prevalence paradox"), "."),
          tags$p("Example: if 95% of items are 'Absent' and both raters say 'Absent' for
                  everything, raw agreement = 95% but κ ≈ 0, because two raters could
                  achieve the same agreement by chance simply by always saying 'Absent'."),
          tags$p("A related problem is", tags$strong("bias"), ": if Rater 1 systematically
                  uses 'Positive' more than Rater 2, their marginals differ. Counter-
                  intuitively, bias increases p_e and can actually make kappa look larger
                  even when cell-level disagreement patterns are the same. Cicchetti &
                  Feinstein (1990) showed that the prevalence and bias paradoxes mean
                  kappa can be misleading, recommending reporting both positive and
                  negative agreement separately alongside κ."),
          tags$p("The plot shows κ across the full range of prevalence for the chosen
                  raw agreement level. Notice how kappa peaks near 50% prevalence and
                  collapses at the extremes."),
          guide = tags$ol(
            tags$li("Set a fixed raw agreement % (e.g., 80%)."),
            tags$li("Click Run and observe the kappa curve across all prevalence values."),
            tags$li("Find the prevalence that gives maximum κ — it's always near 0.5."),
            tags$li("Try different agreement levels and compare how the curve shifts.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Kappa vs. Prevalence (fixed raw agreement)"),
               plotlyOutput(ns("pb_plot"), height = "400px")),
          card(card_header("Positive & Negative Agreement"),
               plotlyOutput(ns("pb_pn_plot"), height = "260px"))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

interrater_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: Cohen's Kappa ────────────────────────────────────────────────────
  mat_r <- eventReactive(input$ir_go, {
    simulate_ratings(input$ir_n, input$ir_k, input$ir_agree,
                     seed = input$ir_seed)
  })

  output$ir_heatmap <- renderPlotly({
    mat  <- mat_r()
    req(mat)
    k    <- nrow(mat)
    cats <- paste0("Cat ", seq_len(k))
    pct  <- round(100 * mat / sum(mat), 1)

    plot_ly(
      x = cats, y = rev(cats),
      z = pct[k:1, ],
      type = "heatmap",
      colorscale = list(c(0, "#002b36"), c(1, "#268bd2")),
      text       = matrix(paste0(pct[k:1, ], "%"), nrow = k),
      hovertemplate = "Rater1: %{y}<br>Rater2: %{x}<br>%{text}<extra></extra>",
      xgap = 3, ygap = 3,
      showscale = TRUE
    ) |>
      layout(
        xaxis = list(title = "Rater 2", tickfont = list(size = 12)),
        yaxis = list(title = "Rater 1", tickfont = list(size = 12)),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  output$ir_kappa_stats <- renderUI({
    mat  <- mat_r()
    req(mat)
    kres <- compute_kappa(mat)
    tags$table(
      class = "table table-sm",
      tags$tbody(
        tags$tr(tags$td("Observed agreement (p_o)"),
                tags$td(class = "fw-bold", sprintf("%.1f%%", kres$p_o * 100))),
        tags$tr(tags$td("Chance agreement (p_e)"),
                tags$td(sprintf("%.1f%%", kres$p_e * 100))),
        tags$tr(tags$td("Cohen's κ"),
                tags$td(class = "fw-bold text-primary", sprintf("%.3f", kres$kappa))),
        tags$tr(tags$td("Standard error"),
                tags$td(sprintf("%.4f", kres$se))),
        tags$tr(tags$td("95% CI"),
                tags$td(sprintf("[%.3f, %.3f]", kres$ci_lo, kres$ci_hi))),
        tags$tr(tags$td("N items"), tags$td(sum(mat)))
      )
    )
  })

  output$ir_kappa_interp <- renderUI({
    kres  <- compute_kappa(mat_r())
    req(kres)
    k_val <- kres$kappa
    label <- kappa_label(k_val)
    pct   <- min(max((k_val + 0.1) / 1.1, 0), 1)
    col   <- if (k_val >= 0.8) "#2aa198" else if (k_val >= 0.6) "#859900"
             else if (k_val >= 0.4) "#b58900" else if (k_val >= 0.2) "#cb4b16"
             else "#dc322f"
    tagList(
      tags$p(class = "text-muted small mb-1", "Landis & Koch (1977) benchmark:"),
      tags$p(class = "fw-bold", style = paste0("color:", col, ";"), label),
      tags$div(
        class = "progress mt-2", style = "height: 18px;",
        tags$div(
          class = "progress-bar",
          style = sprintf("width: %.0f%%; background-color: %s;",
                          pct * 100, col),
          sprintf("κ = %.3f", k_val)
        )
      ),
      tags$p(class = "text-muted small mt-3 mb-0",
        "Positive agreement: ",
        tags$strong(sprintf("%.1f%%", 200 * mat_r()[1,1] /
                              (sum(mat_r()[1,]) + sum(mat_r()[,1])))),
        " | Negative agreement: ",
        tags$strong(sprintf("%.1f%%",
          if (nrow(mat_r()) >= 2) {
            200 * mat_r()[nrow(mat_r()), ncol(mat_r())] /
              (sum(mat_r()[nrow(mat_r()),]) +
               sum(mat_r()[, ncol(mat_r())]))
          } else NA_real_))
      )
    )
  })

  # ── Tab 2: Weighted Kappa ───────────────────────────────────────────────────
  wk_mat_r <- eventReactive(input$wk_go, {
    simulate_ratings(input$wk_n, input$wk_k, input$wk_agree,
                     seed = input$wk_seed)
  })

  output$wk_table <- renderTable({
    mat <- wk_mat_r()
    req(mat)
    k   <- nrow(mat)
    ku  <- compute_weighted_kappa(mat, "none")
    kl  <- compute_weighted_kappa(mat, "linear")
    kq  <- compute_weighted_kappa(mat, "quadratic")
    ko  <- compute_kappa(mat)$p_o
    data.frame(
      Scheme       = c("Unweighted (κ)", "Linear weighted (κ_w)",
                       "Quadratic weighted (κ_w)"),
      Kappa        = c(ku, kl, kq),
      Interpretation = c(kappa_label(ku), kappa_label(kl), kappa_label(kq)),
      stringsAsFactors = FALSE
    )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)

  output$wk_weights_plot <- renderPlotly({
    k    <- input$wk_k
    idx  <- seq_len(k)
    cats <- paste0(idx)

    W_lin  <- outer(idx, idx, function(i, j) 1 - abs(i-j)/(k-1))
    W_quad <- outer(idx, idx, function(i, j) 1 - (i-j)^2/(k-1)^2)
    W_none <- diag(k)

    make_hmap <- function(W, title_txt) {
      plot_ly(
        x = cats, y = rev(cats),
        z = W[k:1, ],
        type = "heatmap",
        colorscale = list(c(0,"#073642"), c(0.5,"#268bd2"), c(1,"#2aa198")),
        zmin = 0, zmax = 1, showscale = FALSE,
        xgap = 3, ygap = 3,
        text  = matrix(sprintf("%.2f", W[k:1,]), nrow=k),
        hovertemplate = "i=%{y}, j=%{x}<br>weight=%{text}<extra></extra>",
        name = title_txt
      ) |>
        layout(
          title = list(text = title_txt, font = list(size = 12)),
          xaxis = list(title = "Rater 2", tickfont = list(size = 10)),
          yaxis = list(title = "Rater 1", tickfont = list(size = 10))
        )
    }

    subplot(
      make_hmap(W_none,  "Unweighted"),
      make_hmap(W_lin,   "Linear"),
      make_hmap(W_quad,  "Quadratic"),
      nrows = 1, shareY = TRUE, titleX = TRUE
    ) |>
      layout(
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  # ── Tab 3: Prevalence & Bias ────────────────────────────────────────────────
  pb_data_r <- eventReactive(input$pb_go, {
    agree_frac <- input$pb_agree / 100
    n          <- input$pb_n
    prev_seq   <- seq(0.02, 0.98, by = 0.02)

    results <- lapply(prev_seq, function(prev) {
      # Expected counts given prevalence and agreement
      n_pos <- round(n * prev)
      n_neg <- n - n_pos
      # Raters agree on agree_frac of items
      agree_pos <- round(n_pos * agree_frac)
      agree_neg <- round(n_neg * agree_frac)
      disagree  <- n - agree_pos - agree_neg

      # Build 2x2 table assuming disagreements split evenly
      a  <- agree_pos           # both say Positive
      d  <- agree_neg           # both say Negative
      bc <- max(disagree, 0)
      b  <- round(bc / 2)       # R1=Pos, R2=Neg
      cc <- bc - b              # R1=Neg, R2=Pos

      mat <- matrix(c(a, b, cc, d), nrow=2)
      kr  <- compute_kappa(mat)

      # Specific agreement
      pa <- if ((2*a + b + cc) > 0) 2*a / (2*a + b + cc) else NA
      na_ <- if ((2*d + b + cc) > 0) 2*d / (2*d + b + cc) else NA
      list(prev=prev, kappa=kr$kappa, p_o=kr$p_o, p_e=kr$p_e,
           pos_agree=pa, neg_agree=na_)
    })

    do.call(rbind, lapply(results, as.data.frame))
  })

  output$pb_plot <- renderPlotly({
    df      <- pb_data_r()
    req(df)
    po_line <- input$pb_agree / 100

    plot_ly(df, x = ~prev) |>
      add_lines(y = ~kappa, name = "Cohen's κ",
                line = list(color = "#268bd2", width = 2.5)) |>
      add_lines(y = ~p_o, name = "Raw agreement",
                line = list(color = "#2aa198", width = 1.5, dash = "dash")) |>
      add_lines(y = ~p_e, name = "Chance (p_e)",
                line = list(color = "#dc322f", width = 1.5, dash = "dot")) |>
      layout(
        xaxis = list(title = "Prevalence of 'Positive' category",
                     tickformat = ".0%"),
        yaxis = list(title = "Value", range = c(-0.1, 1),
                     tickformat = ".2f"),
        legend = list(orientation = "h", y = -0.2),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83"),
        shapes = list(list(
          type = "line", x0 = 0, x1 = 1, y0 = po_line, y1 = po_line,
          line = list(color = "#b58900", dash = "longdash", width = 1),
          xref = "paper"
        ))
      )
  })

  output$pb_pn_plot <- renderPlotly({
    df <- pb_data_r()
    plot_ly(df, x = ~prev) |>
      add_lines(y = ~pos_agree, name = "Positive agreement",
                line = list(color = "#859900", width = 2)) |>
      add_lines(y = ~neg_agree, name = "Negative agreement",
                line = list(color = "#6c71c4", width = 2)) |>
      layout(
        xaxis = list(title = "Prevalence", tickformat = ".0%"),
        yaxis = list(title = "Specific agreement", range = c(0, 1),
                     tickformat = ".0%"),
        legend = list(orientation = "h", y = -0.25),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })
  })
}
