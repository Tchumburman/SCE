# Module: Latent Class Analysis & Mixture Models
# 4 tabs: LCA Basics · Model Selection · Mixture vs K-Means · Finite Mixture (Gaussian)

# ── UI ────────────────────────────────────────────────────────────────────────
lca_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Latent Class Analysis",
  icon = icon("object-ungroup"),
  navset_card_underline(

    # ── Tab 1: LCA Basics ─────────────────────────────────────────────────────
    nav_panel(
      "LCA Basics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("lca_n"), "Sample size n", 100, 1000, 400, 50),
          sliderInput(ns("lca_k"), "True classes K", 2, 5, 3, 1),
          sliderInput(ns("lca_items"), "Binary items J", 4, 10, 6, 1),
          sliderInput(ns("lca_sep"), "Class separation (item prob. gap)",
                      0.1, 0.7, 0.4, 0.05),
          actionButton(ns("lca_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("lca_show_true"), "Show true class assignments", value = TRUE)
        ),
        explanation_box(
          tags$strong("Latent Class Analysis"),
          tags$p("Latent Class Analysis (LCA) is a model-based clustering method for categorical
                  (usually binary) indicator variables. It assumes that observed patterns in J binary
                  items arise from membership in one of K unobserved (latent) classes. Within each
                  class, items are assumed to be locally independent — the latent class explains all
                  covariation."),
          tags$p("The model parameters are:"),
          tags$ul(
            tags$li(tags$strong("Class prevalences \u03c0\u2096"), " — how common each class is."),
            tags$li(tags$strong("Item-response probabilities \u03c1\u2096\u2C7C"), " — probability of endorsing
                    item j given class k membership.")
          ),
          tags$p("Estimation uses the Expectation-Maximisation (EM) algorithm. The E-step computes
                  posterior class membership probabilities for each person; the M-step updates
                  \u03c0 and \u03c1 to maximise the complete-data log-likelihood."),
          tags$p("The posterior probability of class membership (modal assignment) is used to
                  assign individuals to classes. Entropy summarises how cleanly individuals
                  are classified: entropy near 1 means well-separated classes; near 0 means overlap."),
          guide = tags$ol(
            tags$li("Set the number of true latent classes and binary items."),
            tags$li("'Separation' controls how different the item-response probabilities are between classes."),
            tags$li("Click 'Simulate & Fit' to generate data and run EM."),
            tags$li("The heatmap shows estimated item-response probabilities by class."),
            tags$li("Increase separation to improve class recovery; decrease to see confusability.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Item-Response Probability Heatmap (Estimated)"),
                 plotlyOutput(ns("lca_heatmap"), height = "320px")),
            card(card_header("Class Prevalences"),
                 plotlyOutput(ns("lca_prev"), height = "320px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Classification Table"),
                 tableOutput(ns("lca_class_table"))),
            card(card_header("Model Fit"),
                 uiOutput(ns("lca_fit_summary")))
          )
        )
      )
    ),

    # ── Tab 2: Model Selection ────────────────────────────────────────────────
    nav_panel(
      "Model Selection",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("lca_sel_n"), "Sample size n", 200, 1000, 500, 100),
          sliderInput(ns("lca_sel_true_k"), "True classes K", 2, 5, 3, 1),
          sliderInput(ns("lca_sel_items"), "Binary items J", 4, 10, 6, 1),
          sliderInput(ns("lca_sel_sep"), "Class separation", 0.1, 0.7, 0.4, 0.05),
          sliderInput(ns("lca_sel_kmax"), "Max K to fit", 2, 7, 6, 1),
          actionButton(ns("lca_sel_go"), "Run model series", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Selecting the Number of Latent Classes"),
          tags$p("Choosing K in LCA is analogous to choosing k in k-means, but model-based criteria
                  provide principled guidance:"),
          tags$ul(
            tags$li(tags$strong("BIC"), " (Bayesian Information Criterion) — penalises log-likelihood
                    for number of parameters. Lower BIC is better. The BIC elbow or minimum is the
                    most commonly recommended rule."),
            tags$li(tags$strong("AIC"), " (Akaike IC) — lighter penalty; tends to favour larger K."),
            tags$li(tags$strong("Lo-Mendell-Rubin LRT"), " — tests K vs K\u22121 classes; significant
                    p-value favours K."),
            tags$li(tags$strong("Entropy"), " — measures sharpness of classification. Values > 0.8
                    are considered good separation; however, entropy alone should not drive K selection.")
          ),
          tags$p("A common recommendation: prefer the lowest K at which BIC stops improving
                  meaningfully, and verify that the solution is interpretable and replicable across
                  random starts."),
          guide = tags$ol(
            tags$li("Set the true K and simulation parameters, then click 'Run model series'."),
            tags$li("The plot shows BIC, AIC, and entropy across K = 2 to K_max."),
            tags$li("The vertical dashed line marks the true K; see which criteria recover it."),
            tags$li("Try low separation (0.15) to see when criteria fail.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Model Selection Criteria vs. K"),
               plotlyOutput(ns("lca_sel_plot"), height = "360px")),
          card(card_header("Fit Indices Table"),
               tableOutput(ns("lca_sel_table")))
        )
      )
    ),

    # ── Tab 3: Gaussian Mixture Model ─────────────────────────────────────────
    nav_panel(
      "Gaussian Mixture Model",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gmm_n"), "Sample size n", 100, 800, 300, 50),
          sliderInput(ns("gmm_k"), "Components K", 2, 5, 3, 1),
          sliderInput(ns("lca_gmm_sep"), "Component separation (\u03bc gap / \u03c3)",
                      0.5, 4, 2, 0.25),
          sliderInput(ns("gmm_sd_ratio"), "SD ratio (large / small component)",
                      1, 4, 1.5, 0.25),
          actionButton(ns("gmm_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("gmm_show_density"), "Show component densities", value = TRUE)
        ),
        explanation_box(
          tags$strong("Gaussian Mixture Models"),
          tags$p("A Gaussian Mixture Model (GMM) assumes the observed data come from a weighted
                  sum of K Gaussian components. Each component k has mean \u03bc\u2096, variance \u03c3\u2096\u00b2,
                  and mixing weight \u03c0\u2096 (\u03a3\u03c0\u2096 = 1):"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "f(x) = \u03a3\u2096 \u03c0\u2096 \u00d7 N(x; \u03bc\u2096, \u03c3\u2096\u00b2)"),
          tags$p("Like LCA, estimation uses EM. The E-step computes the responsibility r\u2096\u1d62 =
                  P(component k | x\u1d62); the M-step updates \u03bc, \u03c3, \u03c0 using weighted observations."),
          tags$p("GMMs extend k-means: k-means uses hard assignments and equal, spherical
                  clusters, whereas GMMs use soft probabilistic assignments and allow arbitrary
                  covariances. BIC again guides K selection."),
          guide = tags$ol(
            tags$li("Set K and the separation between component means."),
            tags$li("SD ratio > 1 creates unequal-variance components."),
            tags$li("The main plot shows the data histogram with fitted component densities."),
            tags$li("The scatter of soft responsibilities shows how certain the model is about each point.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Data Histogram + Fitted Mixture Density"),
               plotlyOutput(ns("gmm_density"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Posterior Component Probabilities"),
                 plotlyOutput(ns("gmm_responsibilities"), height = "260px")),
            card(card_header("Component Parameters"),
                 tableOutput(ns("gmm_params")))
          )
        )
      )
    ),

    # ── Tab 4: LCA vs K-Means ─────────────────────────────────────────────────
    nav_panel(
      "LCA vs. K-Means",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("lcavkm_n"), "Sample size n", 100, 600, 300, 50),
          sliderInput(ns("lcavkm_k"), "Classes K", 2, 5, 3, 1),
          sliderInput(ns("lcavkm_sep"), "Class separation", 0.1, 0.7, 0.35, 0.05),
          sliderInput(ns("lcavkm_items"), "Binary items J", 4, 8, 5, 1),
          actionButton(ns("lcavkm_go"), "Simulate & Compare", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("LCA vs. K-Means Clustering"),
          tags$p("Both methods assign individuals to groups, but differ fundamentally:"),
          tags$ul(
            tags$li(tags$strong("K-means"), " minimises within-cluster sum-of-squares; uses
                    Euclidean distance; yields hard assignments; works on continuous data."),
            tags$li(tags$strong("LCA"), " is a probabilistic model; uses conditional item-response
                    probabilities; yields soft (posterior) assignments; designed for categorical data."),
            tags$li(tags$strong("Model fit"), ": LCA provides AIC/BIC for principled K selection;
                    k-means relies on elbow/silhouette heuristics."),
            tags$li(tags$strong("Interpretability"), ": LCA class profiles (\u03c1\u2096\u2C7C) are directly
                    interpretable as item endorsement rates per class.")
          ),
          tags$p("On binary data, treating item codes as Euclidean coordinates and running k-means
                  can work tolerably, but LCA's probabilistic framework is the appropriate model."),
          guide = tags$ol(
            tags$li("Click 'Simulate & Compare' to generate binary item data and run both methods."),
            tags$li("The agreement table shows where LCA and k-means agree or disagree."),
            tags$li("Low separation reveals where k-means degrades faster than LCA."),
            tags$li("Adjusted Rand Index (ARI) quantifies agreement with true class labels.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("LCA Class Profiles"),
                 plotlyOutput(ns("lcavkm_lca_heat"), height = "280px")),
            card(card_header("K-Means Cluster Centroids"),
                 plotlyOutput(ns("lcavkm_km_heat"), height = "280px"))
          ),
          card(card_header("ARI vs. True Classes"),
               tableOutput(ns("lcavkm_table")))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

lca_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: simulate binary item data ────────────────────────────────────
  sim_lca_data <- function(n, K, J, sep, seed = NULL) {
    if (!is.null(seed)) set.seed(seed)
    # Class prevalences (roughly equal)
    pi_k <- rep(1 / K, K)
    # Item-response probabilities: low class ~ 0.2, high class ~ 0.2 + sep * rank
    rho <- matrix(NA, K, J)
    for (j in seq_len(J)) {
      base <- runif(1, 0.15, 0.35)
      rho[, j] <- pmin(pmax(base + sep * (seq_len(K) - 1) / (K - 1) * (if (runif(1) > 0.5) 1 else -1) +
                              rnorm(K, 0, 0.05), 0.05), 0.95)
    }
    # Simulate
    class_true <- sample(seq_len(K), n, replace = TRUE, prob = pi_k)
    X <- matrix(NA_integer_, n, J)
    for (i in seq_len(n))
      X[i, ] <- rbinom(J, 1, rho[class_true[i], ])
    list(X = X, class_true = class_true, rho_true = rho, pi_true = pi_k)
  }

  # ── Utility: simple EM for LCA ─────────────────────────────────────────────
  fit_lca_em <- function(X, K, max_iter = 200, tol = 1e-6) {
    n <- nrow(X); J <- ncol(X)
    # Init: random soft assignments
    set.seed(42)
    R <- matrix(runif(n * K), n, K)
    R <- R / rowSums(R)

    pi_k  <- colMeans(R)
    rho   <- matrix(NA, K, J)
    loglik_prev <- -Inf

    for (iter in seq_len(max_iter)) {
      # M-step
      Nk <- colSums(R)
      pi_k <- Nk / n
      for (k in seq_len(K))
        rho[k, ] <- pmax(pmin(colSums(R[, k] * X) / Nk[k], 0.999), 0.001)

      # E-step: log P(x_i | class k)
      log_px <- matrix(NA, n, K)
      for (k in seq_len(K)) {
        lp <- rowSums(X * log(rho[k, ])[col(X)] +
                        (1 - X) * log(1 - rho[k, ])[col(X)])
        log_px[, k] <- log(pi_k[k]) + lp
      }
      # Normalise in log space
      lmax <- apply(log_px, 1, max)
      log_px2 <- log_px - lmax
      R_raw <- exp(log_px2)
      R <- R_raw / rowSums(R_raw)

      loglik <- sum(lmax + log(rowSums(R_raw)))
      if (abs(loglik - loglik_prev) < tol) break
      loglik_prev <- loglik
    }

    # BIC / AIC
    n_params <- (K - 1) + K * J
    bic <- -2 * loglik + n_params * log(n)
    aic <- -2 * loglik + 2 * n_params

    # Entropy
    R_safe <- pmax(R, 1e-15)
    entropy_val <- 1 - (-sum(R_safe * log(R_safe))) / (n * log(K))

    # Modal assignment
    class_est <- apply(R, 1, which.max)

    list(rho = rho, pi_k = pi_k, R = R, class_est = class_est,
         loglik = loglik, bic = bic, aic = aic,
         entropy = entropy_val, n_params = n_params)
  }

  # ── ARI utility ────────────────────────────────────────────────────────────
  ari <- function(a, b) {
    # Simplified ARI
    a <- as.integer(factor(a)); b <- as.integer(factor(b))
    tab  <- table(a, b)
    sa   <- choose(rowSums(tab), 2)
    sb   <- choose(colSums(tab), 2)
    sab  <- sum(choose(tab, 2))
    n    <- length(a)
    expected <- sum(sa) * sum(sb) / choose(n, 2)
    maxval   <- (sum(sa) + sum(sb)) / 2
    if (maxval - expected == 0) return(0)
    (sab - expected) / (maxval - expected)
  }

  # ── Tab 1: LCA Basics ─────────────────────────────────────────────────────
  lca_fit <- reactiveVal(NULL)
  observeEvent(input$lca_go, {
    withProgress(message = "Fitting latent class model...", value = 0.1, {
    lca_fit({
    n <- input$lca_n; K <- input$lca_k; J <- input$lca_items; sep <- input$lca_sep
    d <- sim_lca_data(n, K, J, sep, seed = sample(9999, 1))
    fit <- fit_lca_em(d$X, K)
    list(d = d, fit = fit, K = K, J = J)
    })
    })
  })

  output$lca_heatmap <- renderPlotly({
    req(lca_fit())
    f   <- lca_fit()
    rho <- f$fit$rho
    K   <- f$K; J <- f$J
    plot_ly(
      z = rho,
      x = paste0("Item ", seq_len(J)),
      y = paste0("Class ", seq_len(K)),
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(c(0, "#fdf6e3"), c(0.5, "#268bd2"), c(1, "#073642")),
      zmin = 0, zmax = 1,
      hovertemplate = "Class %{y}, %{x}: \u03c1 = %{z:.3f}<extra></extra>"
    ) |>
      layout(xaxis = list(title = ""),
             yaxis = list(title = ""))
  })

  output$lca_prev <- renderPlotly({
    req(lca_fit())
    f    <- lca_fit()
    K    <- f$K
    est  <- f$fit$pi_k
    true <- f$d$pi_true
    plot_ly() |>
      add_bars(x = paste0("Class ", seq_len(K)), y = est,
               name = "Estimated", marker = list(color = "#268bd2")) |>
      add_bars(x = paste0("Class ", seq_len(K)), y = true,
               name = "True", marker = list(color = "#2aa198", opacity = 0.5)) |>
      layout(barmode = "group",
             xaxis = list(title = ""),
             yaxis = list(title = "Prevalence", range = c(0, 1)))
  })

  output$lca_class_table <- renderTable({
    req(lca_fit())
    f  <- lca_fit()
    if (!input$lca_show_true) return(NULL)
    # Match classes by max overlap
    ct <- f$d$class_true
    ce <- f$fit$class_est
    tab <- table(True = ct, Estimated = ce)
    as.data.frame.matrix(tab)
  }, rownames = TRUE, bordered = TRUE, striped = TRUE, hover = TRUE)

  output$lca_fit_summary <- renderUI({
    req(lca_fit())
    f <- lca_fit()$fit
    ar <- if (input$lca_show_true)
      round(ari(lca_fit()$d$class_true, f$class_est), 3) else NA
    mkrow <- function(label, val) tags$tr(tags$td(label), tags$td(tags$strong(val)))
    tags$table(class = "table table-sm",
      tags$tbody(
        mkrow("Log-likelihood", sprintf("%.2f", f$loglik)),
        mkrow("BIC", sprintf("%.2f", f$bic)),
        mkrow("AIC", sprintf("%.2f", f$aic)),
        mkrow("Entropy", sprintf("%.3f", f$entropy)),
        mkrow("# Parameters", as.character(f$n_params)),
        if (!is.na(ar)) mkrow("ARI (vs. true)", sprintf("%.3f", ar))
      )
    )
  })

  # ── Tab 2: Model Selection ─────────────────────────────────────────────────
  lca_sel_results <- reactiveVal(NULL)
  observeEvent(input$lca_sel_go, {
    withProgress(message = "Comparing models...", value = 0.1, {
    lca_sel_results({
    withProgress(message = "Fitting LCA models...", {
      n   <- input$lca_sel_n
      K_t <- input$lca_sel_true_k
      J   <- input$lca_sel_items
      sep <- input$lca_sel_sep
      kmax <- input$lca_sel_kmax

      d   <- sim_lca_data(n, K_t, J, sep, seed = 7777)

      results <- lapply(2:kmax, function(k) {
        incProgress(1 / (kmax - 1))
        fit <- fit_lca_em(d$X, k)
        data.frame(K = k, BIC = fit$bic, AIC = fit$aic,
                   Entropy = fit$entropy, LogLik = fit$loglik)
      })
      list(df = do.call(rbind, results), true_k = K_t)
    })
    })
    })
  })

  output$lca_sel_plot <- renderPlotly({
    req(lca_sel_results())
    df    <- lca_sel_results()$df
    tk    <- lca_sel_results()$true_k

    plot_ly(df) |>
      add_lines(x = ~K, y = ~BIC, name = "BIC",
                line = list(color = "#268bd2", width = 2)) |>
      add_markers(x = ~K, y = ~BIC, marker = list(color = "#268bd2")) |>
      add_lines(x = ~K, y = ~AIC, name = "AIC",
                line = list(color = "#cb4b16", dash = "dash")) |>
      add_lines(x = ~K, y = ~Entropy * max(df$BIC, na.rm = TRUE), name = "Entropy (scaled)",
                line = list(color = "#2aa198", dash = "dot")) |>
      layout(
        xaxis = list(title = "Number of classes K", dtick = 1),
        yaxis = list(title = "BIC / AIC (Entropy scaled)"),
        shapes = list(
          list(type = "line", x0 = tk, x1 = tk, y0 = 0, y1 = 1,
               xref = "x", yref = "paper",
               line = list(color = "#859900", dash = "longdash", width = 2))
        ),
        annotations = list(
          list(x = tk, y = 1, xref = "x", yref = "paper",
               text = paste("True K =", tk), showarrow = FALSE,
               font = list(color = "#859900"), xanchor = "left")
        )
      )
  })

  output$lca_sel_table <- renderTable({
    req(lca_sel_results())
    df <- lca_sel_results()$df
    df$BIC     <- round(df$BIC, 2)
    df$AIC     <- round(df$AIC, 2)
    df$Entropy <- round(df$Entropy, 3)
    df$LogLik  <- round(df$LogLik, 2)
    df
  }, bordered = TRUE, striped = TRUE, hover = TRUE)

  # ── Tab 3: Gaussian Mixture Model ─────────────────────────────────────────
  gmm_fit <- reactiveVal(NULL)
  observeEvent(input$gmm_go, {
    withProgress(message = "Fitting Gaussian mixture...", value = 0.1, {
    gmm_fit({
    set.seed(sample(9999, 1))
    n   <- input$gmm_n
    K   <- input$gmm_k
    sep <- input$lca_gmm_sep
    sdr <- input$gmm_sd_ratio

    # True parameters
    mus    <- (seq_len(K) - ceiling(K / 2)) * sep
    sds    <- seq(0.5, 0.5 * sdr, length.out = K)
    pis    <- rep(1 / K, K)
    cls    <- sample(seq_len(K), n, replace = TRUE, prob = pis)
    x      <- rnorm(n, mus[cls], sds[cls])

    # EM for univariate GMM
    mu_e  <- quantile(x, seq(0.1, 0.9, length.out = K))
    sd_e  <- rep(sd(x) / K, K)
    pi_e  <- rep(1 / K, K)

    for (iter in seq_len(200)) {
      # E
      R <- sapply(seq_len(K), function(k)
        pi_e[k] * dnorm(x, mu_e[k], sd_e[k]))
      R <- R / rowSums(R)
      # M
      Nk    <- colSums(R)
      pi_e  <- Nk / n
      mu_e  <- colSums(R * x) / Nk
      sd_e  <- sqrt(colSums(R * outer(x, mu_e, "-")^2) / Nk)
      sd_e  <- pmax(sd_e, 0.01)
    }

    list(x = x, cls = cls, K = K,
         mu = mu_e, sd = sd_e, pi = pi_e, R = R,
         mu_true = mus, sd_true = sds)
    })
    })
  })

  output$gmm_density <- renderPlotly({
    req(gmm_fit())
    f  <- gmm_fit()
    K  <- f$K
    xr <- seq(min(f$x) - 0.5, max(f$x) + 0.5, length.out = 400)

    cols <- c("#268bd2","#cb4b16","#2aa198","#d33682","#b58900")[seq_len(K)]

    p <- plot_ly() |>
      add_histogram(x = f$x, histnorm = "probability density",
                    name = "Data", marker = list(color = "rgba(101,123,131,0.3)"),
                    nbinsx = 40)

    if (input$gmm_show_density) {
      # Overall mixture
      mix_d <- rowSums(sapply(seq_len(K), function(k)
        f$pi[k] * dnorm(xr, f$mu[k], f$sd[k])))
      p <- p |> add_lines(x = xr, y = mix_d, name = "Mixture",
                           line = list(color = "#073642", width = 2.5))
      for (k in seq_len(K)) {
        comp_d <- f$pi[k] * dnorm(xr, f$mu[k], f$sd[k])
        p <- p |> add_lines(x = xr, y = comp_d,
                             name = paste("Component", k),
                             line = list(color = cols[k], dash = "dash"))
      }
    }
    p |> layout(xaxis = list(title = "x"), yaxis = list(title = "Density"),
                barmode = "overlay")
  })

  output$gmm_responsibilities <- renderPlotly({
    req(gmm_fit())
    f  <- gmm_fit()
    K  <- f$K
    # Show top responsibility for a sample of 200 points
    idx <- order(f$x)[round(seq(1, length(f$x), length.out = min(200, length(f$x))))]
    xsub <- f$x[idx]
    Rsub <- f$R[idx, , drop = FALSE]
    cols <- c("#268bd2","#cb4b16","#2aa198","#d33682","#b58900")[seq_len(K)]
    p <- plot_ly()
    for (k in seq_len(K)) {
      p <- p |> add_markers(x = xsub, y = Rsub[, k],
                             name = paste("Class", k),
                             marker = list(color = cols[k], size = 4, opacity = 0.7),
                             hovertemplate = "x=%{x:.2f}, r=%{y:.3f}<extra></extra>")
    }
    p |> layout(xaxis = list(title = "x"),
                yaxis = list(title = "Responsibility r(k|x)", range = c(0, 1)))
  })

  output$gmm_params <- renderTable({
    req(gmm_fit())
    f  <- gmm_fit()
    K  <- f$K
    data.frame(
      Component = paste0("K=", seq_len(K)),
      Pi_est    = round(f$pi, 3),
      Mu_est    = round(f$mu, 3),
      SD_est    = round(f$sd, 3),
      Mu_true   = round(f$mu_true, 3),
      SD_true   = round(f$sd_true, 3)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 4: LCA vs K-Means ─────────────────────────────────────────────────
  lcakm_fit <- reactiveVal(NULL)
  observeEvent(input$lcavkm_go, {
    withProgress(message = "Comparing LCA vs K-means...", value = 0.1, {
    lcakm_fit({
    set.seed(sample(9999, 1))
    n   <- input$lcavkm_n
    K   <- input$lcavkm_k
    J   <- input$lcavkm_items
    sep <- input$lcavkm_sep

    d   <- sim_lca_data(n, K, J, sep, seed = NULL)
    lca <- fit_lca_em(d$X, K)
    km  <- kmeans(d$X, centers = K, nstart = 20)

    list(d = d, lca = lca, km = km, K = K, J = J,
         ari_lca = ari(d$class_true, lca$class_est),
         ari_km  = ari(d$class_true, km$cluster))
    })
    })
  })

  output$lcavkm_lca_heat <- renderPlotly({
    req(lcakm_fit())
    f   <- lcakm_fit()
    rho <- f$lca$rho
    plot_ly(
      z = rho,
      x = paste0("I", seq_len(f$J)),
      y = paste0("C", seq_len(f$K)),
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(c(0,"#fdf6e3"), c(1,"#268bd2")),
      zmin = 0, zmax = 1,
      showscale = FALSE
    ) |> layout(xaxis = list(title = ""), yaxis = list(title = ""),
                title = list(text = paste("LCA  ARI =", round(f$ari_lca, 3)),
                             font = list(size = 12)))
  })

  output$lcavkm_km_heat <- renderPlotly({
    req(lcakm_fit())
    f   <- lcakm_fit()
    ctr <- f$km$centers
    plot_ly(
      z = ctr,
      x = paste0("I", seq_len(f$J)),
      y = paste0("C", seq_len(f$K)),
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(c(0,"#fdf6e3"), c(1,"#cb4b16")),
      zmin = 0, zmax = 1,
      showscale = FALSE
    ) |> layout(xaxis = list(title = ""), yaxis = list(title = ""),
                title = list(text = paste("K-Means  ARI =", round(f$ari_km, 3)),
                             font = list(size = 12)))
  })

  output$lcavkm_table <- renderTable({
    req(lcakm_fit())
    f <- lcakm_fit()
    data.frame(
      Method = c("LCA", "K-Means"),
      ARI    = round(c(f$ari_lca, f$ari_km), 4),
      Note   = c("Model-based, soft assignments", "Distance-based, hard assignments")
    )
  }, bordered = TRUE, striped = TRUE, hover = TRUE)

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Latent Class Analysis", list(lca_fit, lca_sel_results, gmm_fit, lcakm_fit))
  })
}
