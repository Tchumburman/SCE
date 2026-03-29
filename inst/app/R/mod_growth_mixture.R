# Module: Growth Mixture Models
# 3 tabs: GMM Basics · Class-Varying Growth · Model Selection

# ── UI ────────────────────────────────────────────────────────────────────────
growth_mixture_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Growth Mixture Models",
  icon = icon("chart-line"),
  navset_card_underline(

    # ── Tab 1: GMM Basics ─────────────────────────────────────────────────────
    nav_panel(
      "GMM Basics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gmm_n_subj"), "Subjects", 80, 400, 200, 20),
          sliderInput(ns("gmm_n_time"), "Time points T", 3, 8, 5, 1),
          sliderInput(ns("gmm_k_true"), "True trajectory classes K", 2, 4, 3, 1),
          sliderInput(ns("gmm_sep"),
            "Trajectory separation (slope difference between classes)",
            0.1, 2, 0.8, 0.1),
          sliderInput(ns("gmm_resid_sd"), "Residual SD", 0.2, 2, 0.6, 0.1),
          actionButton(ns("gmm_basic_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          checkboxInput(ns("gmm_show_true_traj"), "Show true class trajectories", value = TRUE)
        ),
        explanation_box(
          tags$strong("Growth Mixture Models"),
          tags$p("A Growth Mixture Model (GMM) combines latent growth curve modelling with
                  latent class analysis. It assumes that the population is composed of K subgroups
                  (latent trajectory classes), each with its own mean growth trajectory and
                  within-class individual variation."),
          tags$p("The model for individual i in class k at time t:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "y\u1d62\u209c = (\u03b1\u2096 + \u03b6\u1d62\u2080) + (\u03b2\u2096 + \u03b6\u1d62\u2081)t + \u03b5\u1d62\u209c"),
          tags$p("where \u03b1\u2096, \u03b2\u2096 are the class-specific mean intercept and slope,
                  \u03b6\u1d62\u2080, \u03b6\u1d62\u2081 are within-class individual random effects, and
                  \u03b5 is residual error."),
          tags$ul(
            tags$li(tags$strong("Group-based trajectory models (Nagin)"), " — special case with
                    no within-class random variation."),
            tags$li(tags$strong("Latent class growth analysis (LCGA)"), " — all individual variation
                    is absorbed by class assignment."),
            tags$li("Full GMM allows within-class variation in intercepts and slopes.")
          ),
          guide = tags$ol(
            tags$li("Set K and the slope separation between classes."),
            tags$li("The spaghetti plot shows all individual trajectories coloured by true class."),
            tags$li("The class mean plot shows the estimated vs. true mean trajectories."),
            tags$li("Increase residual SD to see within-class variation obscure class boundaries.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Individual Trajectories by Class"),
               plotlyOutput(ns("gmm_spaghetti"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Estimated Class Mean Trajectories"),
                 plotlyOutput(ns("gmm_class_means"), height = "260px")),
            card(card_header("Class Prevalences & ARI"),
                 tableOutput(ns("gmm_class_table")))
          )
        )
      )
    ),

    # ── Tab 2: Class-Varying Growth ───────────────────────────────────────────
    nav_panel(
      "Class-Varying Growth",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("cvg_n"), "Subjects", 100, 400, 200, 50),
          sliderInput(ns("cvg_t"), "Time points", 4, 10, 6, 1),
          selectInput(ns("cvg_scenario"), "Growth scenario",
            choices = c("Linear divergence",
                        "One class plateaus",
                        "Crossing trajectories",
                        "Accelerating vs. decelerating"),
            selected = "Linear divergence"),
          sliderInput(ns("cvg_noise"), "Residual SD", 0.1, 1.5, 0.5, 0.1),
          actionButton(ns("cvg_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Diverse Trajectory Shapes"),
          tags$p("GMMs are valued in developmental psychology and epidemiology because they identify
                  qualitatively different growth patterns that are lost when a single trajectory
                  model is forced onto heterogeneous data."),
          tags$p("Common trajectory patterns found in practice:"),
          tags$ul(
            tags$li(tags$strong("Linear divergence"), " — one group gains steadily; another is stable."),
            tags$li(tags$strong("Plateau"), " — initial gain followed by levelling off in one class."),
            tags$li(tags$strong("Crossing"), " — groups start at different levels but converge or cross."),
            tags$li(tags$strong("Accelerating vs. decelerating"), " — quadratic curvature differs by class.")
          ),
          tags$p("These distinctions often have important theoretical and clinical interpretations
                  in educational achievement, weight gain, symptom remission, etc."),
          guide = tags$ol(
            tags$li("Select a growth scenario to simulate two qualitatively different trajectories."),
            tags$li("Observe how the mean and individual trajectory panels differ."),
            tags$li("Increase noise to see when trajectory classes become hard to distinguish.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Trajectories by Growth Scenario"),
               plotlyOutput(ns("cvg_plot"), height = "360px")),
          card(card_header("Mean Trajectories Only"),
               plotlyOutput(ns("cvg_means"), height = "260px"))
        )
      )
    ),

    # ── Tab 3: Model Selection ────────────────────────────────────────────────
    nav_panel(
      "Model Selection",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gms2_n"), "Subjects", 100, 400, 200, 50),
          sliderInput(ns("gms2_t"), "Time points", 3, 8, 5, 1),
          sliderInput(ns("gms2_true_k"), "True classes K", 2, 4, 3, 1),
          sliderInput(ns("gms2_sep"), "Trajectory separation", 0.1, 2, 0.7, 0.1),
          sliderInput(ns("gms2_kmax"), "Max K to fit", 2, 6, 5, 1),
          actionButton(ns("gms2_go"), "Run model series", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Selecting K in Growth Mixture Models"),
          tags$p("Choosing the number of trajectory classes involves multiple criteria:"),
          tags$ul(
            tags$li(tags$strong("BIC"), " — most commonly recommended; the K that minimises BIC.
                    Tends to be conservative (favours fewer classes)."),
            tags$li(tags$strong("AIC"), " — lighter penalty; can favour too many classes."),
            tags$li(tags$strong("Entropy"), " — measures classification certainty. Values > 0.8
                    suggest well-separated classes. Should not drive K selection alone."),
            tags$li(tags$strong("Lo-Mendell-Rubin (LMR) test"), " — compares K vs. K\u22121."),
            tags$li(tags$strong("Sample size per class"), " — classes with < 5% prevalence are
                    often substantively uninformative.")
          ),
          tags$p("Importantly, the number of classes should also be guided by theory and
                  interpretability — a statistically better-fitting K may split a class in a
                  meaningless way."),
          guide = tags$ol(
            tags$li("Set the true K and separation. Click 'Run model series'."),
            tags$li("Observe whether BIC correctly identifies the true K."),
            tags$li("Low separation (< 0.3) often causes under-recovery of the true K.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("BIC / AIC / Entropy vs. K"),
               plotlyOutput(ns("gms2_criteria"), height = "320px")),
          card(card_header("Model Fit Table"),
               tableOutput(ns("gms2_table")))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

growth_mixture_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: simulate GMM data ────────────────────────────────────────────
  sim_gmm <- function(n, T, K, sep, resid_sd, seed = NULL) {
    if (!is.null(seed)) set.seed(seed)
    times  <- seq(0, 1, length.out = T)
    pi_k   <- rep(1 / K, K)
    # Intercepts and slopes per class
    alphas <- seq(-0.5 * (K - 1), 0.5 * (K - 1), length.out = K) * 0.5
    betas  <- seq(-sep / 2, sep / 2, length.out = K)

    cls    <- sample(seq_len(K), n, replace = TRUE, prob = pi_k)
    y_mat  <- matrix(NA, n, T)
    for (i in seq_len(n)) {
      k <- cls[i]
      re_int <- rnorm(1, 0, resid_sd * 0.5)
      y_mat[i, ] <- alphas[k] + betas[k] * times + re_int +
                    rnorm(T, 0, resid_sd * 0.7)
    }

    list(y = y_mat, times = times, cls = cls, K = K,
         alphas = alphas, betas = betas, pi = pi_k)
  }

  # ── Utility: fit GMM via EM on growth trajectories ────────────────────────
  fit_gmm_em <- function(y, times, K, max_iter = 100) {
    n <- nrow(y); T <- ncol(y)
    # Design matrix: intercept + time
    X <- cbind(1, times)
    # Init via kmeans
    km <- kmeans(y, centers = K, nstart = 10)
    cls <- km$cluster
    # Init params
    alphas <- numeric(K); betas <- numeric(K)
    sigs   <- numeric(K); pi_k  <- rep(1 / K, K)
    for (k in seq_len(K)) {
      idx <- cls == k
      if (sum(idx) > 1) {
        coefs     <- lm.fit(X, colMeans(y[idx, , drop = FALSE]))$coefficients
        alphas[k] <- coefs[1]; betas[k] <- coefs[2]
        sigs[k]   <- max(sd(as.vector(y[idx, ] - outer(rep(1, sum(idx)),
                                                        alphas[k] + betas[k] * times))), 0.1)
        pi_k[k]   <- mean(idx)
      }
    }

    loglik_prev <- -Inf
    R <- matrix(1 / K, n, K)

    for (iter in seq_len(max_iter)) {
      # E-step
      log_lik <- matrix(NA, n, K)
      for (k in seq_len(K)) {
        mu_k   <- outer(rep(1, n), alphas[k] + betas[k] * times)
        resid_k <- y - mu_k
        ll_k   <- rowSums(dnorm(resid_k, 0, sigs[k], log = TRUE))
        log_lik[, k] <- log(pi_k[k]) + ll_k
      }
      lmax <- apply(log_lik, 1, max)
      R_raw <- exp(log_lik - lmax)
      R     <- R_raw / rowSums(R_raw)
      loglik <- sum(lmax + log(rowSums(R_raw)))

      # M-step
      Nk    <- colSums(R)
      pi_k  <- Nk / n
      for (k in seq_len(K)) {
        wk     <- R[, k]
        # Weighted OLS for each time point combined
        # mean trajectory: fit weighted lm of y_it ~ time
        y_vec  <- as.vector(y)
        t_vec  <- rep(times, each = n)
        w_vec  <- rep(wk, T)
        X2     <- cbind(1, t_vec)
        b <- tryCatch({
          lm.wfit(X2, y_vec, w_vec)$coefficients
        }, error = function(e) c(alphas[k], betas[k]))
        alphas[k] <- b[1]; betas[k] <- b[2]
        mu_k   <- outer(rep(1, n), alphas[k] + betas[k] * times)
        sigs[k] <- max(sqrt(sum(R[, k] * rowMeans((y - mu_k)^2)) / Nk[k]), 0.05)
      }

      if (abs(loglik - loglik_prev) < 1e-5) break
      loglik_prev <- loglik
    }

    # BIC / AIC / entropy
    n_par <- K * 3 + (K - 1)  # alphas, betas, sigs, pi
    bic   <- -2 * loglik + n_par * log(n)
    aic   <- -2 * loglik + 2 * n_par
    R_safe <- pmax(R, 1e-15)
    entropy <- 1 - (-sum(R_safe * log(R_safe))) / (n * log(K))
    cls_est <- apply(R, 1, which.max)

    list(alphas = alphas, betas = betas, sigs = sigs, pi = pi_k,
         R = R, cls_est = cls_est, loglik = loglik,
         bic = bic, aic = aic, entropy = entropy)
  }

  ari_fn <- function(a, b) {
    a <- as.integer(factor(a)); b <- as.integer(factor(b))
    tab  <- table(a, b)
    sa   <- choose(rowSums(tab), 2)
    sb   <- choose(colSums(tab), 2)
    sab  <- sum(choose(tab, 2))
    n    <- length(a)
    exp  <- sum(sa) * sum(sb) / choose(n, 2)
    mx   <- (sum(sa) + sum(sb)) / 2
    if (mx - exp == 0) return(0)
    (sab - exp) / (mx - exp)
  }

  # ── Tab 1: GMM Basics ─────────────────────────────────────────────────────
  gmm_res <- reactiveVal(NULL)
  observeEvent(input$gmm_basic_go, {
    gmm_res({
    set.seed(sample(9999, 1))
    d   <- sim_gmm(input$gmm_n_subj, input$gmm_n_time,
                   input$gmm_k_true, input$gmm_sep, input$gmm_resid_sd)
    fit <- fit_gmm_em(d$y, d$times, input$gmm_k_true)
    list(d = d, fit = fit)
    })
  })

  output$gmm_spaghetti <- renderPlotly({
    req(gmm_res())
    d   <- gmm_res()$d
    K   <- d$K
    cols <- c("#268bd2","#dc322f","#2aa198","#d33682")[seq_len(K)]
    p   <- plot_ly()
    ids <- sample(seq_len(nrow(d$y)), min(80, nrow(d$y)))
    for (i in ids) {
      k <- d$cls[i]
      p <- p |> add_lines(x = d$times, y = d$y[i, ],
                           line = list(color = paste0(sub("#","rgba(",cols[k]), ",0.2)"),
                                       width = 1),
                           showlegend = FALSE)
    }
    if (input$gmm_show_true_traj) {
      for (k in seq_len(K)) {
        p <- p |> add_lines(x = d$times,
                             y = d$alphas[k] + d$betas[k] * d$times,
                             name = paste("Class", k, "mean"),
                             line = list(color = cols[k], width = 3))
      }
    }
    p |> layout(xaxis = list(title = "Time (standardised)"),
                yaxis = list(title = "Outcome"),
                legend = list(orientation = "h"))
  })

  output$gmm_class_means <- renderPlotly({
    req(gmm_res())
    d   <- gmm_res()$d
    fit <- gmm_res()$fit
    K   <- d$K
    cols <- c("#268bd2","#dc322f","#2aa198","#d33682")[seq_len(K)]
    p <- plot_ly()
    for (k in seq_len(K)) {
      p <- p |>
        add_lines(x = d$times, y = d$alphas[k] + d$betas[k] * d$times,
                  name = paste0("True C", k),
                  line = list(color = cols[k], dash = "dot", width = 1.5)) |>
        add_lines(x = d$times, y = fit$alphas[k] + fit$betas[k] * d$times,
                  name = paste0("Estimated C", k),
                  line = list(color = cols[k], width = 2.5))
    }
    p |> layout(xaxis = list(title = "Time"), yaxis = list(title = "Mean"),
                legend = list(orientation = "h"))
  })

  output$gmm_class_table <- renderTable({
    req(gmm_res())
    d   <- gmm_res()$d
    fit <- gmm_res()$fit
    K   <- d$K
    ar  <- round(ari_fn(d$cls, fit$cls_est), 3)
    data.frame(
      Class        = paste("Class", seq_len(K)),
      True_Prev    = round(d$pi, 3),
      Est_Prev     = round(fit$pi, 3),
      True_Slope   = round(d$betas, 3),
      Est_Slope    = round(fit$betas, 3),
      ARI          = c(ar, rep(NA, K - 1))
    )
  }, bordered = TRUE, striped = TRUE, na = "")

  # ── Tab 2: Class-Varying Growth ────────────────────────────────────────────
  cvg_data <- reactiveVal(NULL)
  observeEvent(input$cvg_go, {
    cvg_data({
    set.seed(sample(9999, 1))
    n     <- input$cvg_n
    T     <- input$cvg_t
    noise <- input$cvg_noise
    sc    <- input$cvg_scenario
    times <- seq(0, 1, length.out = T)

    # Two classes
    half_n <- n %/% 2
    n2     <- n - half_n
    cls    <- c(rep(1, half_n), rep(2, n2))

    # True mean trajectories by scenario
    mu1 <- switch(sc,
      "Linear divergence"           = 0 + 0.2 * times,
      "One class plateaus"          = 0 + pmin(times * 2, 0.8),
      "Crossing trajectories"       = 1 - times,
      "Accelerating vs. decelerating" = times^2
    )
    mu2 <- switch(sc,
      "Linear divergence"           = 0 + 1.2 * times,
      "One class plateaus"          = 0 + 1.5 * times,
      "Crossing trajectories"       = times,
      "Accelerating vs. decelerating" = sqrt(times)
    )

    y1 <- matrix(rnorm(half_n * T, outer(rep(1, half_n), mu1), noise), half_n, T)
    y2 <- matrix(rnorm(n2 * T, outer(rep(1, n2), mu2), noise), n2, T)
    y  <- rbind(y1, y2)

    list(y = y, cls = cls, times = times, mu1 = mu1, mu2 = mu2, T = T, n = n)
    })
  })

  output$cvg_plot <- renderPlotly({
    req(cvg_data())
    d  <- cvg_data()
    p  <- plot_ly()
    for (i in sample(seq_len(d$n), min(80, d$n))) {
      col <- if (d$cls[i] == 1) "rgba(38,139,210,0.18)" else "rgba(220,50,47,0.18)"
      p <- p |> add_lines(x = d$times, y = d$y[i, ],
                           line = list(color = col, width = 1), showlegend = FALSE)
    }
    p |>
      add_lines(x = d$times, y = d$mu1, name = "Class 1 mean",
                line = list(color = "#268bd2", width = 3)) |>
      add_lines(x = d$times, y = d$mu2, name = "Class 2 mean",
                line = list(color = "#dc322f", width = 3)) |>
      layout(xaxis = list(title = "Time"), yaxis = list(title = "Outcome"),
             legend = list(orientation = "h"))
  })

  output$cvg_means <- renderPlotly({
    req(cvg_data())
    d <- cvg_data()
    plot_ly() |>
      add_lines(x = d$times, y = d$mu1, name = "Class 1",
                line = list(color = "#268bd2", width = 2.5)) |>
      add_lines(x = d$times, y = d$mu2, name = "Class 2",
                line = list(color = "#dc322f", width = 2.5)) |>
      layout(xaxis = list(title = "Time"), yaxis = list(title = "Mean"),
             legend = list(orientation = "h"))
  })

  # ── Tab 3: Model Selection ─────────────────────────────────────────────────
  gms2_res <- reactiveVal(NULL)
  observeEvent(input$gms2_go, {
    gms2_res({
    withProgress(message = "Fitting GMM models...", {
      n  <- input$gms2_n; T <- input$gms2_t
      Kt <- input$gms2_true_k; sep <- input$gms2_sep
      km <- input$gms2_kmax
      d  <- sim_gmm(n, T, Kt, sep, 0.5, seed = 4321)

      results <- lapply(2:km, function(k) {
        incProgress(1 / (km - 1))
        fit <- tryCatch(fit_gmm_em(d$y, d$times, k), error = function(e) NULL)
        if (is.null(fit)) return(data.frame(K = k, BIC = NA, AIC = NA, Entropy = NA))
        data.frame(K = k, BIC = round(fit$bic, 2), AIC = round(fit$aic, 2),
                   Entropy = round(fit$entropy, 3))
      })
      list(df = do.call(rbind, results), true_k = Kt)
    })
    })
  })

  output$gms2_criteria <- renderPlotly({
    req(gms2_res())
    df <- gms2_res()$df
    tk <- gms2_res()$true_k
    df <- df[!is.na(df$BIC), ]
    plot_ly(df) |>
      add_lines(x = ~K, y = ~BIC, name = "BIC",
                line = list(color = "#268bd2", width = 2)) |>
      add_markers(x = ~K, y = ~BIC, marker = list(color = "#268bd2")) |>
      add_lines(x = ~K, y = ~AIC, name = "AIC",
                line = list(color = "#cb4b16", dash = "dash")) |>
      add_lines(x = ~K, y = ~Entropy * max(df$BIC, na.rm = TRUE),
                name = "Entropy (scaled)", line = list(color = "#2aa198", dash = "dot")) |>
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

  output$gms2_table <- renderTable({
    req(gms2_res())
    gms2_res()$df
  }, bordered = TRUE, striped = TRUE)

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Growth Mixture Models", list(gmm_res, cvg_data, gms2_res))
  })
}
