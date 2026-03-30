# Module: Information Theory
# 4 tabs: Entropy · KL Divergence · Mutual Information · Cross-Entropy & ML

# ── UI ────────────────────────────────────────────────────────────────────────
information_theory_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Information Theory",
  icon = icon("infinity"),
  navset_card_underline(

    # ── Tab 1: Entropy ────────────────────────────────────────────────────────
    nav_panel(
      "Entropy",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("it_dist"), "Distribution",
            choices = c("Bernoulli", "Categorical (k equal)", "Binomial",
                        "Normal (differential)", "Exponential (differential)"),
            selected = "Bernoulli"),
          conditionalPanel(ns = ns, "input.it_dist == 'Bernoulli'",
            sliderInput(ns("it_bp"), "Probability p", 0.01, 0.99, 0.5, 0.01)),
          conditionalPanel(ns = ns, "input.it_dist == 'Categorical (k equal)'",
            sliderInput(ns("it_cat_k"), "Number of categories k", 2, 20, 4, 1)),
          conditionalPanel(ns = ns, "input.it_dist == 'Binomial'",
            sliderInput(ns("it_bn"), "Trials n", 2, 30, 10, 1),
            sliderInput(ns("it_bpb"), "Success probability p", 0.01, 0.99, 0.5, 0.01)),
          conditionalPanel(ns = ns, "input.it_dist == 'Normal (differential)'",
            sliderInput(ns("it_nsd"), "Standard deviation \u03c3", 0.1, 5, 1, 0.1)),
          conditionalPanel(ns = ns, "input.it_dist == 'Exponential (differential)'",
            sliderInput(ns("it_elam"), "Rate \u03bb", 0.1, 5, 1, 0.1)),
          radioButtons(ns("it_base"), "Logarithm base",
            choices = c("2 (bits)" = "2", "e (nats)" = "e"),
            selected = "2", inline = TRUE)
        ),
        explanation_box(
          tags$strong("Entropy"),
          tags$p("Shannon entropy quantifies the average uncertainty (or information content) of a
                  random variable. For a discrete distribution:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "H(X) = \u2212 \u03a3 p(x) log p(x)"),
          tags$p("Key properties:"),
          tags$ul(
            tags$li(tags$strong("Maximum entropy"), " occurs when all outcomes are equally likely — maximum uncertainty."),
            tags$li(tags$strong("Zero entropy"), " when one outcome has probability 1 — no uncertainty."),
            tags$li(tags$strong("Units"), " depend on the log base: base 2 gives bits, base e gives nats."),
            tags$li(tags$strong("Differential entropy"), " extends the concept to continuous distributions, but can be
                    negative and is not directly comparable to discrete entropy.")
          ),
          tags$p("For a normal distribution: H = \u00bd log(2\u03c0e\u03c3\u00b2). Entropy grows with
                  spread \u03c3. For Exponential(\u03bb): H = 1 \u2212 log(\u03bb)."),
          guide = tags$ol(
            tags$li("Select a distribution. The bar chart shows the PMF (or PDF) with entropy annotated."),
            tags$li("Move the parameter slider. The curve below tracks how entropy changes."),
            tags$li("Notice that entropy peaks at maximum uncertainty (e.g., p = 0.5 for Bernoulli)."),
            tags$li("Switch between bits and nats — values scale by log\u2082(e) \u2248 1.44.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Distribution & Current Entropy"),
               plotlyOutput(ns("it_ent_dist"), height = "320px")),
          card(full_screen = TRUE,
               card_header("Entropy vs. Parameter"),
               plotlyOutput(ns("it_ent_curve"), height = "260px"))
        )
      )
    ),

    # ── Tab 2: KL Divergence ─────────────────────────────────────────────────
    nav_panel(
      "KL Divergence",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$h6("Distribution P (reference)"),
          sliderInput(ns("it_kl_mu1"), "Mean \u03bc\u2081", -3, 3, 0, 0.1),
          sliderInput(ns("it_kl_sd1"), "SD \u03c3\u2081", 0.3, 4, 1, 0.1),
          tags$hr(),
          tags$h6("Distribution Q (approximation)"),
          sliderInput(ns("it_kl_mu2"), "Mean \u03bc\u2082", -3, 3, 1, 0.1),
          sliderInput(ns("it_kl_sd2"), "SD \u03c3\u2082", 0.3, 4, 1.5, 0.1),
          radioButtons(ns("it_kl_base"), "Log base",
            choices = c("2 (bits)" = "2", "e (nats)" = "e"),
            selected = "e", inline = TRUE)
        ),
        explanation_box(
          tags$strong("KL Divergence"),
          tags$p("The Kullback\u2013Leibler divergence KL(P \u2016 Q) measures how much the distribution Q
                  departs from the reference distribution P:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "KL(P \u2016 Q) = \u03a3 p(x) log [ p(x) / q(x) ]"),
          tags$p("Critical properties:"),
          tags$ul(
            tags$li(tags$strong("Non-negative:"), " KL(P \u2016 Q) \u2265 0, with equality iff P = Q (Gibbs' inequality)."),
            tags$li(tags$strong("Asymmetric:"), " KL(P \u2016 Q) \u2260 KL(Q \u2016 P) in general — it is not a true distance."),
            tags$li(tags$strong("Information interpretation:"), " Extra bits needed to encode P using Q instead of P's
                    optimal code."),
            tags$li(tags$strong("Reverse KL"), " KL(Q \u2016 P) is used in variational inference; it tends to
                    produce mode-seeking behaviour.")
          ),
          tags$p("For two normals P = N(\u03bc\u2081, \u03c3\u2081\u00b2) and Q = N(\u03bc\u2082, \u03c3\u2082\u00b2):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "KL(P\u2016Q) = log(\u03c3\u2082/\u03c3\u2081) + (\u03c3\u2081\u00b2 + (\u03bc\u2081\u2212\u03bc\u2082)\u00b2) / (2\u03c3\u2082\u00b2) \u2212 1/2"),
          guide = tags$ol(
            tags$li("P is the true/reference distribution (blue). Q is the approximation (orange)."),
            tags$li("Move the means apart to increase KL divergence."),
            tags$li("Notice how KL(P\u2016Q) and KL(Q\u2016P) differ — asymmetry is key."),
            tags$li("The pointwise contribution plot shows where the distributions disagree most.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("P vs. Q Distributions"),
               plotlyOutput(ns("it_kl_dists"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Pointwise KL Contribution"), plotlyOutput(ns("it_kl_pointwise"), height = "260px")),
            card(card_header("KL Asymmetry"), plotlyOutput(ns("it_kl_asym"), height = "260px"))
          )
        )
      )
    ),

    # ── Tab 3: Mutual Information ─────────────────────────────────────────────
    nav_panel(
      "Mutual Information",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("it_mi_rho"), "Correlation \u03c1 (bivariate normal)", -0.99, 0.99, 0.6, 0.01),
          sliderInput(ns("it_mi_n"), "Sample size n", 50, 500, 200, 50),
          actionButton(ns("it_mi_go"), "Resample", icon = icon("dice"), class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("it_mi_show_linear"), "Show linear fit", value = TRUE),
          tags$p(class = "text-muted mt-2", style = "font-size: 0.85rem;",
            "MI is computed from the bivariate normal formula:
             I(X;Y) = \u2212\u00bd log(1\u2212\u03c1\u00b2)")
        ),
        explanation_box(
          tags$strong("Mutual Information"),
          tags$p("Mutual information I(X; Y) measures how much knowing X reduces uncertainty about Y
                  (and vice versa). Unlike correlation, it captures any statistical dependence,
                  including nonlinear:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "I(X; Y) = H(X) \u2212 H(X | Y) = H(Y) \u2212 H(Y | X)"),
          tags$p("Key relationships:"),
          tags$ul(
            tags$li(tags$strong("I(X; Y) \u2265 0"), ", zero iff X and Y are independent."),
            tags$li(tags$strong("Symmetric:"), " I(X; Y) = I(Y; X)."),
            tags$li("For bivariate normal: I = \u2212\u00bd log\u2082(1 \u2212 \u03c1\u00b2) bits."),
            tags$li(tags$strong("Normalized MI (NMI)"), " = I(X;Y) / \u221a[H(X)H(Y)] ranges 0\u20131 for comparison.")
          ),
          tags$p("In feature selection, MI identifies variables that share information with the outcome
                  regardless of relationship shape."),
          guide = tags$ol(
            tags$li("Move the \u03c1 slider to control bivariate association."),
            tags$li("MI (bottom right) increases monotonically with |\u03c1|."),
            tags$li("Note: MI and |r| agree for linear relationships but diverge for nonlinear ones."),
            tags$li("Resample to see variability around the population MI.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Bivariate Sample"),
               plotlyOutput(ns("it_mi_scatter"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("MI vs. |Correlation|"), plotlyOutput(ns("it_mi_curve"), height = "250px")),
            card(card_header("Association Summary"), tableOutput(ns("it_mi_table")))
          )
        )
      )
    ),

    # ── Tab 4: Cross-Entropy & ML ─────────────────────────────────────────────
    nav_panel(
      "Cross-Entropy & ML",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("it_ce_ptrue"), "True probability p", 0.01, 0.99, 0.7, 0.01),
          sliderInput(ns("it_ce_q"), "Predicted probability q", 0.01, 0.99, 0.5, 0.01),
          tags$hr(),
          checkboxInput(ns("it_ce_show_sq"), "Overlay squared-error loss", value = TRUE),
          checkboxInput(ns("it_ce_decomp"), "Show H(P) + KL decomposition", value = TRUE)
        ),
        explanation_box(
          tags$strong("Cross-Entropy & Machine Learning"),
          tags$p("Cross-entropy H(P, Q) measures the average number of bits needed to encode samples
                  drawn from P using the code optimised for Q:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "H(P, Q) = \u2212\u03a3 p(x) log q(x)"),
          tags$p("Crucially, cross-entropy decomposes into:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "H(P, Q) = H(P) + KL(P \u2016 Q)"),
          tags$p("Minimising cross-entropy is therefore equivalent to minimising KL divergence.
                  This is exactly what neural network classifiers do via the log-loss / binary
                  cross-entropy:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "L = \u2212[p log(q) + (1\u2212p) log(1\u2212q)]"),
          tags$ul(
            tags$li("Loss is minimised when q = p (perfect calibration)."),
            tags$li("Cross-entropy is more sensitive to confident wrong predictions than squared error."),
            tags$li("H(P) is a fixed floor — irreducible entropy of the true labels.")
          ),
          guide = tags$ol(
            tags$li("Set 'true probability p' — the actual class probability."),
            tags$li("Move 'predicted probability q' and watch the loss change."),
            tags$li("The loss surface (right) shows loss over all q values for the chosen p."),
            tags$li("Enable the H(P) + KL decomposition to see the irreducible vs. reducible portions."),
            tags$li("Compare to squared-error: note the steep penalty for confident wrong predictions.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Loss Summary"), uiOutput(ns("it_ce_summary"))),
            card(card_header("H(P) + KL Decomposition"), plotlyOutput(ns("it_ce_bar"), height = "260px"))
          ),
          card(full_screen = TRUE,
               card_header("Cross-Entropy Loss Surface (all q values)"),
               plotlyOutput(ns("it_ce_surface"), height = "300px"))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

information_theory_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── helper: log base ───────────────────────────────────────────────────────
  logb <- function(x, base) {
    if (base == "e") log(x) else log2(x)
  }
  unit_lbl <- reactive(if (input$it_base == "2") "bits" else "nats")

  # ── Tab 1: Entropy ─────────────────────────────────────────────────────────

  ent_vals <- reactive({
    dist <- input$it_dist
    base <- input$it_base
    lb   <- function(x) logb(x, base)

    if (dist == "Bernoulli") {
      p <- input$it_bp
      h <- -(p * lb(p) + (1 - p) * lb(1 - p))
      x <- c("0", "1")
      px <- c(1 - p, p)
      list(h = h, x = x, px = px, type = "discrete",
           param_seq = seq(0.01, 0.99, 0.01),
           h_seq = sapply(seq(0.01, 0.99, 0.01), function(pp)
             -(pp * lb(pp) + (1 - pp) * lb(1 - pp))),
           xlab = "p")
    } else if (dist == "Categorical (k equal)") {
      k <- input$it_cat_k
      h <- lb(k)
      list(h = h, x = as.character(seq_len(k)), px = rep(1 / k, k), type = "discrete",
           param_seq = 2:20,
           h_seq = sapply(2:20, function(kk) lb(kk)),
           xlab = "k")
    } else if (dist == "Binomial") {
      n <- input$it_bn; p <- input$it_bpb
      xs <- 0:n; px <- dbinom(xs, n, p)
      px_pos <- pmax(px, 1e-15)
      h <- -sum(px * lb(px_pos))
      list(h = h, x = as.character(xs), px = px, type = "discrete",
           param_seq = seq(0.01, 0.99, 0.01),
           h_seq = sapply(seq(0.01, 0.99, 0.01), function(pp) {
             ppx <- dbinom(0:n, n, pp); ppx[ppx < 1e-15] <- 1e-15
             -sum(ppx * lb(ppx))
           }),
           xlab = "p")
    } else if (dist == "Normal (differential)") {
      sd <- input$it_nsd
      h  <- if (base == "e") 0.5 * log(2 * pi * exp(1) * sd^2) else
              0.5 * log2(2 * pi * exp(1) * sd^2)
      xv <- seq(-4 * sd, 4 * sd, length.out = 200)
      list(h = h, xv = xv, px = dnorm(xv, 0, sd), type = "continuous",
           param_seq = seq(0.1, 5, 0.05),
           h_seq = sapply(seq(0.1, 5, 0.05), function(s)
             if (base == "e") 0.5 * log(2 * pi * exp(1) * s^2) else
               0.5 * log2(2 * pi * exp(1) * s^2)),
           xlab = "\u03c3")
    } else {  # Exponential
      lam <- input$it_elam
      h   <- if (base == "e") 1 - log(lam) else (1 - log(lam)) / log(2)
      xv  <- seq(0, 6 / lam, length.out = 200)
      list(h = h, xv = xv, px = dexp(xv, lam), type = "continuous",
           param_seq = seq(0.1, 5, 0.05),
           h_seq = sapply(seq(0.1, 5, 0.05), function(l)
             if (base == "e") 1 - log(l) else (1 - log(l)) / log(2)),
           xlab = "\u03bb")
    }
  })

  output$it_ent_dist <- renderPlotly({
    v   <- ent_vals()
    lbl <- unit_lbl()
    title_h <- sprintf("H = %.4f %s", v$h, lbl)

    if (v$type == "discrete") {
      plot_ly(x = v$x, y = v$px, type = "bar",
              marker = list(color = "#268bd2"),
              hovertemplate = "P(X=%{x}) = %{y:.4f}<extra></extra>") |>
        layout(title = list(text = title_h, font = list(size = 13)),
               xaxis = list(title = "Outcome"),
               yaxis = list(title = "Probability"))
    } else {
      plot_ly(x = v$xv, y = v$px, type = "scatter", mode = "lines",
              fill = "tozeroy", fillcolor = "rgba(38,139,210,0.15)",
              line = list(color = "#268bd2"),
              hovertemplate = "x=%{x:.2f}, f(x)=%{y:.4f}<extra></extra>") |>
        layout(title = list(text = paste(title_h, "(differential)"), font = list(size = 13)),
               xaxis = list(title = "x"),
               yaxis = list(title = "Density"))
    }
  })

  output$it_ent_curve <- renderPlotly({
    v   <- ent_vals()
    lbl <- unit_lbl()

    # Mark current value
    cur_param <- switch(input$it_dist,
      "Bernoulli"               = input$it_bp,
      "Categorical (k equal)"   = input$it_cat_k,
      "Binomial"                = input$it_bpb,
      "Normal (differential)"   = input$it_nsd,
      "Exponential (differential)" = input$it_elam
    )

    plot_ly() |>
      add_lines(x = v$param_seq, y = v$h_seq,
                line = list(color = "#2aa198"),
                hovertemplate = paste0(v$xlab, "=%{x:.2f}, H=%{y:.4f} ", lbl, "<extra></extra>")) |>
      add_markers(x = cur_param, y = v$h,
                  marker = list(color = "#dc322f", size = 10),
                  hovertemplate = paste0("Current: H=%.4f ", lbl, "<extra></extra>")) |>
      layout(xaxis = list(title = v$xlab),
             yaxis = list(title = paste("Entropy (", lbl, ")")),
             showlegend = FALSE)
  })

  # ── Tab 2: KL Divergence ───────────────────────────────────────────────────

  kl_data <- reactive({
    mu1 <- input$it_kl_mu1; sd1 <- input$it_kl_sd1
    mu2 <- input$it_kl_mu2; sd2 <- input$it_kl_sd2
    base <- input$it_kl_base

    kl_pq <- log(sd2 / sd1) + (sd1^2 + (mu1 - mu2)^2) / (2 * sd2^2) - 0.5
    kl_qp <- log(sd1 / sd2) + (sd2^2 + (mu2 - mu1)^2) / (2 * sd1^2) - 0.5
    if (base == "2") { kl_pq <- kl_pq / log(2); kl_qp <- kl_qp / log(2) }

    xr  <- range(c(mu1 - 4 * sd1, mu1 + 4 * sd1, mu2 - 4 * sd2, mu2 + 4 * sd2))
    xv  <- seq(xr[1], xr[2], length.out = 400)
    pv  <- dnorm(xv, mu1, sd1)
    qv  <- dnorm(xv, mu2, sd2)
    # Pointwise contribution to KL(P||Q): p(x) * log(p(x)/q(x))
    contrib <- ifelse(pv < 1e-12, 0, pv * (log(pmax(pv, 1e-12)) - log(pmax(qv, 1e-12))))
    if (base == "2") contrib <- contrib / log(2)

    list(xv = xv, pv = pv, qv = qv, contrib = contrib,
         kl_pq = kl_pq, kl_qp = kl_qp,
         unit = if (base == "e") "nats" else "bits")
  })

  output$it_kl_dists <- renderPlotly({
    d <- kl_data()
    plot_ly() |>
      add_lines(x = d$xv, y = d$pv, name = "P (reference)",
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = d$xv, y = d$qv, name = "Q (approx.)",
                line = list(color = "#cb4b16", width = 2, dash = "dash")) |>
      layout(xaxis = list(title = "x"), yaxis = list(title = "Density"),
             legend = list(orientation = "h"),
             annotations = list(
               list(x = 0.5, y = 1.05, xref = "paper", yref = "paper", showarrow = FALSE,
                    text = sprintf("KL(P\u2016Q) = %.4f %s  |  KL(Q\u2016P) = %.4f %s",
                                   d$kl_pq, d$unit, d$kl_qp, d$unit),
                    font = list(size = 12))
             ))
  })

  output$it_kl_pointwise <- renderPlotly({
    d <- kl_data()
    plot_ly(x = d$xv, y = d$contrib, type = "scatter", mode = "lines",
            fill = "tozeroy", fillcolor = "rgba(38,139,210,0.2)",
            line = list(color = "#268bd2"),
            hovertemplate = "x=%{x:.2f}<br>contrib=%{y:.5f}<extra></extra>") |>
      layout(xaxis = list(title = "x"),
             yaxis = list(title = paste0("p(x) log[p(x)/q(x)] (", d$unit, ")")))
  })

  output$it_kl_asym <- renderPlotly({
    d <- kl_data()
    plot_ly(
      x = c("KL(P\u2016Q)", "KL(Q\u2016P)"),
      y = c(d$kl_pq, d$kl_qp),
      type = "bar",
      marker = list(color = c("#268bd2", "#cb4b16")),
      hovertemplate = "%{x}: %{y:.4f}<extra></extra>"
    ) |>
      layout(yaxis = list(title = paste("Divergence (", d$unit, ")")),
             xaxis = list(title = ""),
             title = list(text = "Asymmetry of KL", font = list(size = 12)))
  })

  # ── Tab 3: Mutual Information ──────────────────────────────────────────────

  mi_data <- eventReactive(input$it_mi_go, {
    rho <- input$it_mi_rho
    n   <- input$it_mi_n
    set.seed(NULL)
    Sigma <- matrix(c(1, rho, rho, 1), 2, 2)
    xy    <- MASS::mvrnorm(n, mu = c(0, 0), Sigma = Sigma)
    mi    <- -0.5 * log2(1 - rho^2)  # bits
    list(x = xy[, 1], y = xy[, 2], rho = rho, mi = mi, n = n,
         pearson_r = cor(xy[, 1], xy[, 2]))
  })

  output$it_mi_scatter <- renderPlotly({
    d <- mi_data()
    req(d)
    p <- plot_ly(x = d$x, y = d$y, type = "scatter", mode = "markers",
                 marker = list(color = "#268bd2", size = 4, opacity = 0.6),
                 hovertemplate = "(%{x:.2f}, %{y:.2f})<extra></extra>")
    if (input$it_mi_show_linear) {
      fit  <- lm(d$y ~ d$x)
      xr   <- seq(min(d$x), max(d$x), length.out = 100)
      ypred <- coef(fit)[1] + coef(fit)[2] * xr
      p <- p |> add_lines(x = xr, y = ypred,
                           line = list(color = "#dc322f", dash = "dash"),
                           name = "Linear fit", showlegend = FALSE)
    }
    p |> layout(
      xaxis = list(title = "X"),
      yaxis = list(title = "Y"),
      title = list(
        text = sprintf("n=%d | \u03c1=%.2f | I(X;Y)=%.4f bits | r=%.3f",
                       d$n, d$rho, d$mi, d$pearson_r),
        font = list(size = 12)
      )
    )
  })

  output$it_mi_curve <- renderPlotly({
    d   <- mi_data()
    req(d)
    rho_seq <- seq(-0.99, 0.99, 0.01)
    mi_seq  <- -0.5 * log2(1 - rho_seq^2)
    plot_ly() |>
      add_lines(x = rho_seq, y = mi_seq, line = list(color = "#2aa198")) |>
      add_markers(x = d$rho, y = d$mi, marker = list(color = "#dc322f", size = 10),
                  hovertemplate = sprintf("\u03c1=%.2f, MI=%.4f bits", d$rho, d$mi)) |>
      layout(xaxis = list(title = "Correlation \u03c1"),
             yaxis = list(title = "I(X;Y) (bits)"),
             showlegend = FALSE)
  })

  output$it_mi_table <- renderTable({
    d <- mi_data()
    req(d)
    data.frame(
      Measure   = c("Pearson r", "Spearman \u03c1 (sample)", "Mutual Information (pop.)", "MI (sample est.)"),
      Value     = c(
        round(d$pearson_r, 4),
        round(cor(d$x, d$y, method = "spearman"), 4),
        round(d$mi, 4),
        round(-0.5 * log2(1 - cor(d$x, d$y)^2), 4)
      )
    )
  }, bordered = TRUE, striped = TRUE, hover = TRUE)

  # ── Tab 4: Cross-Entropy & ML ──────────────────────────────────────────────

  ce_vals <- reactive({
    p <- input$it_ce_ptrue
    q <- input$it_ce_q
    hp  <- -(p * log2(p) + (1 - p) * log2(1 - p))   # H(P)
    kl  <- p * log2(p / q) + (1 - p) * log2((1 - p) / (1 - q))  # KL(P||Q)
    ce  <- hp + kl  # H(P, Q)
    mse <- (p - q)^2
    list(p = p, q = q, hp = hp, kl = kl, ce = ce, mse = mse)
  })

  output$it_ce_summary <- renderUI({
    v <- ce_vals()
    mkrow <- function(label, val, col = "#657b83") {
      tags$tr(
        tags$td(style = "padding: 6px 10px;", label),
        tags$td(style = paste0("padding: 6px 10px; font-weight:600; color:", col, ";"),
                sprintf("%.4f bits", val))
      )
    }
    tags$table(
      class = "table table-sm",
      style = "font-size: 0.9rem;",
      tags$tbody(
        mkrow("True probability p",   v$p, "#268bd2"),
        mkrow("Predicted prob. q",    v$q, "#cb4b16"),
        tags$tr(tags$td(tags$hr(), colspan = "2")),
        mkrow("H(P) — irreducible entropy",   v$hp, "#657b83"),
        mkrow("KL(P\u2016Q) — excess cost",   v$kl, "#b58900"),
        mkrow("H(P, Q) — cross-entropy",      v$ce, "#dc322f"),
        tags$tr(tags$td(tags$hr(), colspan = "2")),
        mkrow("Squared error (p\u2212q)\u00b2", v$mse, "#6c71c4")
      )
    )
  })

  output$it_ce_bar <- renderPlotly({
    req(input$it_ce_decomp)
    v <- ce_vals()
    plot_ly(
      x = c("H(P)", "KL(P\u2016Q)", "H(P,Q)"),
      y = c(v$hp, v$kl, v$ce),
      type = "bar",
      marker = list(color = c("#2aa198", "#b58900", "#dc322f")),
      hovertemplate = "%{x}: %{y:.4f} bits<extra></extra>"
    ) |>
      layout(yaxis = list(title = "Bits"),
             title = list(text = "Cross-entropy decomposition", font = list(size = 12)))
  })

  output$it_ce_surface <- renderPlotly({
    v    <- ce_vals()
    qseq <- seq(0.01, 0.99, 0.005)
    # Cross-entropy as function of q for current p
    ce_q <- -(v$p * log2(qseq) + (1 - v$p) * log2(1 - qseq))

    p <- plot_ly() |>
      add_lines(x = qseq, y = ce_q,
                name = "Cross-entropy H(P,Q)",
                line = list(color = "#dc322f", width = 2)) |>
      add_markers(x = v$q, y = v$ce,
                  marker = list(color = "#dc322f", size = 10, symbol = "circle"),
                  name = "Current q", showlegend = FALSE,
                  hovertemplate = sprintf("q=%.2f, H(P,Q)=%.4f bits", v$q, v$ce))

    if (input$it_ce_show_sq) {
      mse_q <- (v$p - qseq)^2
      # Rescale MSE to same range for visual comparison
      p <- p |>
        add_lines(x = qseq, y = mse_q,
                  name = "Squared error (p\u2212q)\u00b2",
                  line = list(color = "#6c71c4", dash = "dash"))
    }

    if (input$it_ce_decomp) {
      # Show H(P) floor line
      p <- p |>
        add_lines(x = c(0.01, 0.99), y = c(v$hp, v$hp),
                  name = "H(P) floor",
                  line = list(color = "#2aa198", dash = "dot"),
                  hovertemplate = sprintf("H(P) = %.4f bits", v$hp))
    }

    p |> layout(
      xaxis = list(title = "Predicted probability q", range = c(0, 1)),
      yaxis = list(title = "Loss (bits / squared error)"),
      legend = list(orientation = "h", y = -0.2)
    )
  })
  })
}
