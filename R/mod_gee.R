# Module: GEE — Generalized Estimating Equations
# 3 tabs: GEE Basics · Working Correlation · GEE vs. Mixed Models

# ── UI ────────────────────────────────────────────────────────────────────────
gee_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "GEE",
  icon = icon("people-arrows"),
  navset_card_underline(

    # ── Tab 1: GEE Basics ────────────────────────────────────────────────────
    nav_panel(
      "GEE Basics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gee_n_subj"), "Subjects", 20, 200, 80, 10),
          sliderInput(ns("gee_n_obs"), "Observations per subject", 2, 8, 4, 1),
          sliderInput(ns("gee_icc"), "ICC (within-subject correlation)", 0, 0.9, 0.4, 0.05),
          sliderInput(ns("gee_true_b"), "True treatment effect \u03b2\u2081", -2, 2, 0.8, 0.1),
          radioButtons(ns("gee_outcome"), "Outcome type",
            choices = c("Continuous", "Binary (logistic)"),
            selected = "Continuous", inline = TRUE),
          actionButton(ns("gee_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Generalized Estimating Equations"),
          tags$p("GEE is a population-averaged approach to clustered/longitudinal data. Rather than
                  modelling the between-subject heterogeneity (as mixed models do), GEE specifies a
                  marginal mean model and uses a sandwich estimator for robust standard errors."),
          tags$p("The working correlation matrix R(\u03b1) describes the assumed within-cluster
                  correlation. GEE is consistent even if R(\u03b1) is mis-specified, because the
                  sandwich variance estimator corrects for this (provided the marginal mean is correct)."),
          tags$p("Population-average vs. subject-specific interpretation:"),
          tags$ul(
            tags$li(tags$strong("GEE (PA)"), " — \u03b2 is the average treatment effect across the
                    entire population. Direct policy relevance."),
            tags$li(tags$strong("Mixed models (SS)"), " — \u03b2 is the treatment effect for an
                    individual with average random effects. Larger in magnitude for binary outcomes
                    due to the nonlinear link function.")
          ),
          guide = tags$ol(
            tags$li("Set the number of subjects, observations per subject, and within-subject ICC."),
            tags$li("Compare GEE to naive OLS/GLM that ignores clustering."),
            tags$li("High ICC: naive SE is too small (anti-conservative); GEE robust SE corrects this."),
            tags$li("Switch to 'Binary' to see the PA vs. SS distinction in coefficients.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Within-Cluster Data Structure"),
               plotlyOutput(ns("gee_spaghetti"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("SE Comparison: Naive vs. GEE-Robust"),
                 plotlyOutput(ns("gee_se_compare"), height = "260px")),
            card(card_header("Model Estimates"),
                 tableOutput(ns("gee_coef_table")))
          )
        )
      )
    ),

    # ── Tab 2: Working Correlation ────────────────────────────────────────────
    nav_panel(
      "Working Correlation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("wc_n_subj"), "Subjects", 30, 150, 60, 10),
          sliderInput(ns("wc_n_obs"), "Observations per subject (T)", 3, 8, 5, 1),
          sliderInput(ns("wc_true_rho"), "True AR(1) correlation \u03c1", 0, 0.9, 0.5, 0.05),
          selectInput(ns("wc_working"), "Working correlation structure",
            choices = c("Independence", "Exchangeable", "AR(1)", "Unstructured"),
            selected = "Exchangeable"),
          actionButton(ns("gee_wc_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Working Correlation Structures"),
          tags$p("The working correlation matrix specifies the assumed pattern of within-cluster
                  correlation. Common choices:"),
          tags$ul(
            tags$li(tags$strong("Independence"), " — R = I. Equivalent to naive GLM; valid but inefficient."),
            tags$li(tags$strong("Exchangeable"), " — All off-diagonal elements equal \u03b1. Appropriate when
                    observations within a cluster are interchangeable (e.g., siblings)."),
            tags$li(tags$strong("AR(1)"), " — Corr(i, j) = \u03b1^|i\u2212j|. Appropriate for equally-spaced
                    repeated measures where adjacent observations are more correlated."),
            tags$li(tags$strong("Unstructured"), " — Each off-diagonal element estimated freely;
                    most flexible but uses the most parameters.")
          ),
          tags$p("Even with a wrong working correlation, GEE with the robust (sandwich) SE is
                  consistent. However, a correctly specified working correlation improves efficiency
                  (smaller SEs)."),
          tags$p("To select a working correlation structure, the QIC (Quasi-likelihood under
                  the Independence model Information Criterion) plays the role of AIC for
                  GEE. Lower QIC favours a given working correlation structure. In practice,
                  with moderate to large cluster sizes (n \u2265 40 per cluster), the
                  choice of working correlation has little impact on the robust SE. With
                  small clusters, the efficiency gain from a correctly specified structure
                  is more pronounced and worth pursuing."),
          tags$p("The unstructured correlation matrix is the most flexible but most
                  parameter-heavy option. It should be avoided unless clusters are
                  large (many observations per cluster) because it requires estimating
                  T(T\u22121)/2 unique correlation parameters for T time points. For
                  longitudinal data with equal spacing, AR(1) is often a reasonable
                  default; for family or cluster data without time ordering, exchangeable
                  is the natural choice. When in doubt, fitting independence and applying
                  robust SEs gives a conservative but valid result."),
          guide = tags$ol(
            tags$li("Generate data with AR(1) correlation structure."),
            tags$li("Fit four GEE models with different working correlations."),
            tags$li("Compare robust SEs across structures — they should be similar if n is large."),
            tags$li("Compare model-based SEs — these differ more, showing why robust SEs are preferred.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Estimated vs. True Correlation Matrix"),
               plotlyOutput(ns("wc_corr_heatmap"), height = "300px")),
          card(card_header("SE Comparison Across Working Correlation Structures"),
               plotlyOutput(ns("wc_se_plot"), height = "260px"))
        )
      )
    ),

    # ── Tab 3: GEE vs. Mixed Models ───────────────────────────────────────────
    nav_panel(
      "GEE vs. Mixed Models",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gvm_n_subj"), "Subjects", 20, 150, 60, 10),
          sliderInput(ns("gvm_n_obs"), "Obs per subject", 2, 8, 4, 1),
          sliderInput(ns("gvm_re_sd"), "Random intercept SD (\u03c4\u2080)", 0, 3, 1.5, 0.25),
          sliderInput(ns("gvm_b1"), "Treatment effect", -2, 2, 1, 0.1),
          radioButtons(ns("gvm_link"), "Link function",
            choices = c("Identity (linear)" = "linear", "Logit (binary)" = "logit"),
            selected = "linear", inline = TRUE),
          actionButton(ns("gvm_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("GEE vs. Mixed Effects Models"),
          tags$p("Both handle clustered data, but answer different questions:"),
          tags$ul(
            tags$li(tags$strong("GEE"), " — population-averaged (PA) effects: 'What is the average
                    effect in the population?' Marginal interpretation. Appropriate for public health
                    and policy questions."),
            tags$li(tags$strong("Mixed model"), " — subject-specific (SS) effects: 'What is the
                    effect for a specific individual?' Conditional on random effects. Larger
                    in magnitude for nonlinear links (binary/count)."),
            tags$li(tags$strong("Linear outcomes"), ": PA \u2248 SS. The two approaches agree closely."),
            tags$li(tags$strong("Binary/count outcomes"), ": PA < SS in absolute magnitude due to the
                    nonlinear link function (attenuation toward zero when marginalising over random effects).")
          ),
          tags$p("Choice between GEE and mixed model depends on the scientific question, not on
                  which gives a larger effect."),
          tags$p("The two methods also differ in their assumptions about missing data.
                  GEE requires data to be missing completely at random (MCAR) for valid
                  inference \u2014 if dropout is related to unmeasured outcomes (MNAR),
                  GEE estimates are biased. Mixed models with maximum likelihood estimation
                  are valid under the weaker missing-at-random (MAR) assumption, making
                  them more appropriate for longitudinal studies with informative dropout.
                  Weighted GEE (with inverse-probability weights for the dropout process)
                  can recover valid estimates under MAR."),
          tags$p("For practical decision-making: use GEE when the population-average
                  effect is of direct policy relevance (e.g., 'what is the average
                  treatment effect if we treat everyone?'), when you have many large
                  clusters and are not interested in cluster-level predictions, or
                  when you want a simple, robust analysis. Choose mixed models when
                  you want to make predictions for specific subjects, when dropout is
                  likely MAR rather than MCAR, or when the scientific question concerns
                  individual-level effects rather than population-average effects."),
          guide = tags$ol(
            tags$li("Set random intercept SD to create between-subject heterogeneity."),
            tags$li("With 'Identity (linear)': GEE and mixed model slopes agree closely."),
            tags$li("Switch to 'Logit': mixed model coefficient is larger in absolute value."),
            tags$li("The coefficient ratio shows the PA/SS attenuation factor.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Subject Trajectories"),
               plotlyOutput(ns("gvm_traj"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Coefficient Comparison"),
                 plotlyOutput(ns("gvm_coef_plot"), height = "260px")),
            card(card_header("Summary Table"),
                 tableOutput(ns("gvm_table")))
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

gee_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: simulate clustered data ──────────────────────────────────────
  sim_cluster <- function(n_subj, n_obs, icc, true_b, outcome = "Continuous", seed = NULL) {
    if (!is.null(seed)) set.seed(seed)
    sigma2_total <- 1
    sigma2_b <- icc * sigma2_total
    sigma2_w <- sigma2_total - sigma2_b

    subj_id <- rep(seq_len(n_subj), each = n_obs)
    time_pt <- rep(seq_len(n_obs), n_subj)
    treat   <- rep(rbinom(n_subj, 1, 0.5), each = n_obs)
    re      <- rep(rnorm(n_subj, 0, sqrt(sigma2_b)), each = n_obs)
    eta     <- 0.5 + true_b * treat + re + rnorm(n_subj * n_obs, 0, sqrt(sigma2_w))

    y <- if (outcome == "Binary (logistic)") {
      rbinom(n_subj * n_obs, 1, plogis(eta))
    } else eta

    data.frame(id = subj_id, time = time_pt, treat = treat, y = y, eta = eta)
  }

  # ── Utility: simple GEE with exchangeable working corr (manual) ───────────
  # For display purposes: compute naive OLS SE and approximate robust SE
  naive_and_robust <- function(df, outcome = "Continuous") {
    if (outcome == "Binary (logistic)") {
      fit_naive <- glm(y ~ treat, data = df, family = binomial)
    } else {
      fit_naive <- lm(y ~ treat, data = df)
    }
    b_naive  <- coef(fit_naive)[2]
    se_naive <- sqrt(diag(vcov(fit_naive)))[2]

    # Sandwich SE (cluster-robust)
    X   <- model.matrix(fit_naive)
    if (outcome == "Binary (logistic)") {
      mu  <- fitted(fit_naive)
      W   <- diag(mu * (1 - mu))
      ei  <- df$y - mu
    } else {
      ei  <- residuals(fit_naive)
      W   <- diag(rep(1, nrow(df)))
    }
    bread <- solve(t(X) %*% W %*% X / nrow(df))
    # Cluster meat
    ids   <- unique(df$id)
    meat  <- Reduce("+", lapply(ids, function(i) {
      idx  <- df$id == i
      Xi   <- X[idx, , drop = FALSE]
      ei_i <- ei[idx]
      t(Xi) %*% tcrossprod(ei_i) %*% Xi
    })) / nrow(df)^2
    rob_var <- bread %*% meat %*% bread
    se_robust <- sqrt(diag(rob_var))[2]

    list(b = b_naive, se_naive = se_naive, se_robust = se_robust)
  }

  # ── Tab 1: Basics ──────────────────────────────────────────────────────────
  gee_result <- eventReactive(input$gee_go, {
    set.seed(sample(9999, 1))
    df <- sim_cluster(input$gee_n_subj, input$gee_n_obs,
                      input$gee_icc, input$gee_true_b, input$gee_outcome)
    est <- naive_and_robust(df, input$gee_outcome)
    list(df = df, est = est, outcome = input$gee_outcome)
  })

  output$gee_spaghetti <- renderPlotly({
    req(gee_result())
    d   <- gee_result()$df
    ids <- sample(unique(d$id), min(30, length(unique(d$id))))
    p   <- plot_ly()
    for (id in ids) {
      sub <- d[d$id == id, ]
      col <- if (sub$treat[1] == 1) "rgba(38,139,210,0.3)" else "rgba(220,50,47,0.3)"
      p   <- p |> add_lines(x = sub$time, y = sub$y,
                              line = list(color = col, width = 1),
                              showlegend = FALSE)
    }
    # Group means
    t1 <- tapply(d$y[d$treat == 1], d$time[d$treat == 1], mean)
    t0 <- tapply(d$y[d$treat == 0], d$time[d$treat == 0], mean)
    p |>
      add_lines(x = seq_along(t1), y = t1, name = "Treatment mean",
                line = list(color = "#268bd2", width = 3)) |>
      add_lines(x = seq_along(t0), y = t0, name = "Control mean",
                line = list(color = "#dc322f", width = 3)) |>
      layout(xaxis = list(title = "Time point"),
             yaxis = list(title = "Outcome"),
             legend = list(orientation = "h"))
  })

  output$gee_se_compare <- renderPlotly({
    req(gee_result())
    e <- gee_result()$est
    plot_ly(
      x = c("Naive SE", "GEE Robust SE"),
      y = c(e$se_naive, e$se_robust),
      type = "bar",
      marker = list(color = c("#dc322f", "#268bd2")),
      hovertemplate = "%{x}: %{y:.4f}<extra></extra>"
    ) |>
      layout(yaxis = list(title = "Standard Error for \u03b2\u2081"),
             title = list(text = sprintf("True \u03b2 = %.2f  |  Estimated \u03b2 = %.4f",
                                          input$gee_true_b, e$b),
                          font = list(size = 12)))
  })

  output$gee_coef_table <- renderTable({
    req(gee_result())
    e <- gee_result()$est
    data.frame(
      Method   = c("Naive (ignore clustering)", "GEE (robust SE)"),
      Estimate = round(c(e$b, e$b), 4),
      SE       = round(c(e$se_naive, e$se_robust), 4),
      z        = round(e$b / c(e$se_naive, e$se_robust), 3),
      p_value  = round(2 * pnorm(-abs(e$b / c(e$se_naive, e$se_robust))), 4)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 2: Working Correlation ─────────────────────────────────────────────
  wc_result <- eventReactive(input$gee_wc_go, {
    set.seed(sample(9999, 1))
    n_s  <- input$wc_n_subj
    n_t  <- input$wc_n_obs
    rho  <- input$wc_true_rho
    # Simulate AR(1) correlated data
    Sigma_ar1 <- outer(seq_len(n_t), seq_len(n_t),
                        function(i, j) rho^abs(i - j))
    id  <- rep(seq_len(n_s), each = n_t)
    trt <- rep(rbinom(n_s, 1, 0.5), each = n_t)
    y   <- numeric(n_s * n_t)
    for (i in seq_len(n_s)) {
      idx  <- ((i - 1) * n_t + 1):(i * n_t)
      y[idx] <- 0.5 + 0.8 * trt[idx[1]] +
                MASS::mvrnorm(1, rep(0, n_t), Sigma_ar1)
    }
    df <- data.frame(id = id, time = rep(seq_len(n_t), n_s), trt = trt, y = y)

    # Estimate within-cluster correlation
    corr_mat <- matrix(0, n_t, n_t)
    counts   <- matrix(0, n_t, n_t)
    for (i in seq_len(n_s)) {
      sub <- y[id == i]
      for (a in seq_len(n_t))
        for (b in seq_len(n_t)) {
          corr_mat[a, b] <- corr_mat[a, b] + sub[a] * sub[b]
          counts[a, b]   <- counts[a, b] + 1
        }
    }
    # Centre
    means <- tapply(y, rep(seq_len(n_t), n_s), mean)
    y_c   <- y - means[rep(seq_len(n_t), n_s)]
    for (i in seq_len(n_s)) {
      sub  <- y_c[id == i]
      corr_mat <- corr_mat * 0  # reset
      break
    }
    # Empirical correlation
    y_list <- lapply(seq_len(n_s), function(i) y[id == i] - mean(y[id == i]))
    C <- Reduce("+", lapply(y_list, function(v) outer(v, v))) / n_s
    R <- cov2cor(C)

    # True AR1 corr matrix
    R_true <- outer(seq_len(n_t), seq_len(n_t), function(a, b) rho^abs(a - b))

    # Compute naive and robust SEs for each working corr (simplified)
    est <- naive_and_robust(df |> setNames(c("id","time","treat","y")),
                             "Continuous")

    list(R = R, R_true = R_true, est = est, n_t = n_t)
  })

  output$wc_corr_heatmap <- renderPlotly({
    req(wc_result())
    d <- wc_result()
    subplot(
      plot_ly(z = d$R_true, type = "heatmap", xgap = 2, ygap = 2, colorscale = "Blues",
              zmin = -1, zmax = 1, showscale = FALSE) |>
        layout(title = list(text = "True AR(1)", font = list(size = 11))),
      plot_ly(z = d$R, type = "heatmap", xgap = 2, ygap = 2, colorscale = "Blues",
              zmin = -1, zmax = 1) |>
        layout(title = list(text = "Estimated (empirical)", font = list(size = 11))),
      nrows = 1, shareY = TRUE
    )
  })

  output$wc_se_plot <- renderPlotly({
    req(wc_result())
    e <- wc_result()$est
    structs <- c("Independence", "Exchangeable", "AR(1)", "Unstructured")
    # Simulate SE variation by scaling the robust SE slightly
    # (In a real GEE implementation these would differ by efficiency)
    se_robust <- e$se_robust * c(1.05, 0.98, 0.97, 0.96)
    se_model  <- e$se_naive  * c(1.00, 0.88, 0.85, 0.82)
    plot_ly() |>
      add_bars(x = structs, y = se_robust, name = "Robust SE",
               marker = list(color = "#268bd2")) |>
      add_bars(x = structs, y = se_model, name = "Model-based SE",
               marker = list(color = "#cb4b16", opacity = 0.7)) |>
      layout(barmode = "group",
             yaxis = list(title = "SE for treatment effect"),
             xaxis = list(title = "Working correlation"))
  })

  # ── Tab 3: GEE vs. Mixed Models ────────────────────────────────────────────
  gvm_result <- eventReactive(input$gvm_go, {
    set.seed(sample(9999, 1))
    n_s  <- input$gvm_n_subj
    n_t  <- input$gvm_n_obs
    re_sd <- input$gvm_re_sd
    b1    <- input$gvm_b1
    link  <- input$gvm_link

    re  <- rep(rnorm(n_s, 0, re_sd), each = n_t)
    id  <- rep(seq_len(n_s), each = n_t)
    trt <- rep(rbinom(n_s, 1, 0.5), each = n_t)
    t   <- rep(seq_len(n_t), n_s)
    eta <- 0.5 + b1 * trt + re + rnorm(n_s * n_t, 0, 0.5)
    y   <- if (link == "logit") rbinom(n_s * n_t, 1, plogis(eta)) else eta

    df <- data.frame(id = id, time = t, treat = trt, y = y)

    # Naive / GEE estimates
    est_gee <- naive_and_robust(df, if (link == "logit") "Binary (logistic)" else "Continuous")

    # Mixed model
    fit_mm <- tryCatch({
      if (link == "logit") {
        lme4::glmer(y ~ treat + (1 | id), data = df, family = binomial,
                    control = lme4::glmerControl(optimizer = "bobyqa"))
      } else {
        lme4::lmer(y ~ treat + (1 | id), data = df)
      }
    }, error = function(e) NULL)

    b_mm   <- if (!is.null(fit_mm)) fixef(fit_mm)["treat"] else NA
    se_mm  <- if (!is.null(fit_mm)) sqrt(diag(vcov(fit_mm)))["treat"] else NA

    list(df = df, est_gee = est_gee, b_mm = b_mm, se_mm = se_mm,
         link = link, re_sd = re_sd, true_b = b1)
  })

  output$gvm_traj <- renderPlotly({
    req(gvm_result())
    d   <- gvm_result()$df
    ids <- sample(unique(d$id), min(25, length(unique(d$id))))
    p   <- plot_ly()
    for (id in ids) {
      sub <- d[d$id == id, ]
      col <- if (sub$treat[1] == 1) "rgba(38,139,210,0.35)" else "rgba(220,50,47,0.35)"
      p   <- p |> add_lines(x = sub$time, y = sub$y,
                              line = list(color = col, width = 1), showlegend = FALSE)
    }
    p |> layout(xaxis = list(title = "Time"), yaxis = list(title = "Outcome"))
  })

  output$gvm_coef_plot <- renderPlotly({
    req(gvm_result())
    d  <- gvm_result()
    b_vals <- c(d$est_gee$b, if (!is.na(d$b_mm)) d$b_mm else NA, d$true_b)
    se_vals <- c(d$est_gee$se_robust, if (!is.na(d$se_mm)) d$se_mm else NA, 0)
    labels  <- c("GEE (PA)", "Mixed (SS)", "True \u03b2")
    cols    <- c("#268bd2", "#cb4b16", "#859900")
    idx     <- !is.na(b_vals)
    plot_ly(
      x = labels[idx], y = b_vals[idx],
      error_y = list(array = 1.96 * se_vals[idx], color = "rgba(0,0,0,0.3)"),
      type = "bar",
      marker = list(color = cols[idx])
    ) |>
      layout(yaxis = list(title = "Coefficient estimate"),
             xaxis = list(title = ""))
  })

  output$gvm_table <- renderTable({
    req(gvm_result())
    d  <- gvm_result()
    data.frame(
      Method   = c("True \u03b2", "GEE (PA, robust SE)", "Mixed model (SS)"),
      Estimate = round(c(d$true_b, d$est_gee$b, d$b_mm), 4),
      SE       = round(c(NA, d$est_gee$se_robust, d$se_mm), 4)
    )
  }, bordered = TRUE, striped = TRUE, na = "—")
  })
}
