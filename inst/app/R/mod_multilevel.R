# Module: Multilevel Models (consolidated)
# Tabs: Random Intercepts & Slopes | Variance Components & ICC | Growth Curves | Three-Level | Model Comparison

# ── UI ──────────────────────────────────────────────────────────────────
multilevel_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Multilevel Models",
  icon = icon("sitemap"),
  navset_card_underline(

    # ── Tab 1: Random Intercepts & Slopes ──────────────────────────────
    nav_panel(
      "Random Intercepts & Slopes",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("mlm_ris_n_groups"), "Number of groups", min = 3, max = 30, value = 10),
          sliderInput(ns("mlm_ris_n_per"), "Obs per group", min = 5, max = 50, value = 20),
          sliderInput(ns("mlm_ris_fixed_slope"), "Fixed slope", min = -2, max = 2, value = 0.5, step = 0.1),
          sliderInput(ns("mlm_ris_tau0"), "\u03c4\u2080 (intercept SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          sliderInput(ns("mlm_ris_tau1"), "\u03c4\u2081 (slope SD)", min = 0, max = 2, value = 0.5, step = 0.1),
          sliderInput(ns("mlm_ris_sigma"), "\u03c3 (residual SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          actionButton(ns("mlm_ris_go"), "Simulate & Fit", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Random Intercepts & Slopes"),
          tags$p("Multilevel (hierarchical/mixed-effects) models account for data that is nested
                  within groups (e.g. students within schools, measurements within patients).
                  A random-intercept model allows each group to have its own baseline, while a
                  random-slope model additionally lets the effect of a predictor vary across groups."),
          tags$p("The key insight is ", tags$em("partial pooling"), ": group-level estimates are
                  pulled (shrunk) toward the overall mean, especially for groups with little data.
                  This is a principled compromise between ignoring group structure (complete pooling)
                  and fitting each group independently (no pooling)."),
          tags$p("The degree of shrinkage depends on group sample size and the ratio of within-group
                  to between-group variance. Groups with few observations are shrunk more heavily
                  toward the grand mean, which acts as a form of regularisation that reduces
                  overfitting. This property makes multilevel models particularly well-suited for
                  educational and clinical research where group sizes are often unbalanced."),
          guide = tags$ol(
            tags$li("Set the number of groups and observations per group."),
            tags$li("Adjust the fixed slope and variance components."),
            tags$li("Click Simulate & Fit to generate data and compare pooled, no-pooling, and partial-pooling estimates."),
            tags$li("The shrinkage plot shows how group estimates are pulled toward the grand mean.")
          )
        ),
        layout_column_wrap(width = 1 / 2,
          card(full_screen = TRUE, card_header("Complete Pooling"),
               plotOutput(ns("mlm_ris_pooled"), height = "350px")),
          card(full_screen = TRUE, card_header("No Pooling"),
               plotOutput(ns("mlm_ris_nopool"), height = "350px"))
        ),
        card(full_screen = TRUE, card_header("Partial Pooling (Mixed Model)"),
             plotOutput(ns("mlm_ris_partial"), height = "400px")),
        card(full_screen = TRUE, card_header("Shrinkage"),
             plotOutput(ns("mlm_ris_shrinkage"), height = "350px")),
        card(card_header("Model Summary"), uiOutput(ns("mlm_ris_summary")))
      )
    ),

    # ── Tab 2: Variance Components & ICC ───────────────────────────────
    nav_panel(
      "Variance Components & ICC",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("mlm_icc_n_groups"), "Number of groups", min = 5, max = 50, value = 20),
          sliderInput(ns("mlm_icc_n_per"), "Obs per group", min = 5, max = 50, value = 15),
          sliderInput(ns("mlm_icc_tau"), "\u03c4 (between-group SD)", min = 0.1, max = 5, value = 2, step = 0.1),
          sliderInput(ns("mlm_icc_sigma"), "\u03c3 (within-group SD)", min = 0.1, max = 5, value = 2, step = 0.1),
          actionButton(ns("mlm_icc_go"), "Simulate", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Variance Components & ICC"),
          tags$p("The Intraclass Correlation Coefficient (ICC) quantifies the proportion of total
                  variance that lies between groups: ICC = \u03c4\u00b2 / (\u03c4\u00b2 + \u03c3\u00b2).
                  A high ICC means observations within the same group are similar to each other
                  relative to observations across groups."),
          tags$p("ICC informs study design: high ICC means observations within clusters are
                  similar, so the effective sample size is smaller than the total n. Adding
                  more clusters is more efficient than adding more observations within
                  existing clusters. The design effect (DEFF \u2248 1 + (m \u2212 1) \u00d7 ICC,
                  where m is cluster size) quantifies how much larger the sample must be
                  compared to simple random sampling."),
          tags$p("As a rule of thumb: ICC < 0.05 suggests minimal clustering and single-level
                  analysis may suffice. ICC > 0.10 strongly warrants a multilevel approach.
                  Ignoring clustering when ICC is substantial leads to artificially small
                  standard errors and inflated Type I error rates."),
          guide = tags$ol(
            tags$li("Adjust between-group (\u03c4) and within-group (\u03c3) standard deviations."),
            tags$li("Click Simulate to generate clustered data."),
            tags$li("The dot plot shows individual observations by group."),
            tags$li("The bar chart decomposes total variance into between and within components.")
          )
        ),
        layout_column_wrap(width = 1 / 2,
          card(full_screen = TRUE, card_header("Observations by Group"),
               plotOutput(ns("mlm_icc_dotplot"), height = "400px")),
          card(full_screen = TRUE, card_header("Variance Decomposition"),
               plotOutput(ns("mlm_icc_bar"), height = "400px"))
        ),
        card(card_header("ICC Summary"), uiOutput(ns("mlm_icc_summary")))
      )
    ),

    # ── Tab 3: Growth Curve Models ─────────────────────────────────────
    nav_panel(
      "Growth Curves",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("mlm_gc_n_subj"), "Number of subjects", min = 5, max = 50, value = 20),
          sliderInput(ns("mlm_gc_n_time"), "Time points", min = 3, max = 15, value = 6),
          sliderInput(ns("mlm_gc_fixed_slope"), "Fixed time slope", min = -1, max = 1, value = 0.3, step = 0.05),
          sliderInput(ns("mlm_gc_tau0"), "\u03c4\u2080 (intercept SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          sliderInput(ns("mlm_gc_tau1"), "\u03c4\u2081 (slope SD)", min = 0, max = 1, value = 0.2, step = 0.05),
          sliderInput(ns("mlm_gc_sigma"), "\u03c3 (residual SD)", min = 0.1, max = 2, value = 0.5, step = 0.1),
          checkboxInput(ns("mlm_gc_quadratic"), "Add quadratic term", value = FALSE),
          actionButton(ns("mlm_gc_go"), "Simulate & Fit", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Growth Curve Models"),
          tags$p("Growth curve models are multilevel models for longitudinal data where
                  repeated measurements (level 1) are nested within individuals (level 2).
                  They capture individual trajectories over time, allowing both the initial
                  status (intercept) and rate of change (slope) to vary across people."),
          tags$p("Adding a quadratic term allows for curvature in the trajectories
                  (acceleration or deceleration over time). Higher-order polynomials or
                  piecewise-linear models can capture more complex patterns, though
                  interpretation becomes more difficult."),
          tags$p("Growth curve models are a special case of multilevel models where
                  \u201ctime\u201d is the level-1 predictor. They are preferable to repeated-measures
                  ANOVA because they handle unequal time spacing, missing observations,
                  and time-varying covariates naturally. The spaghetti plot shows individual
                  raw trajectories; the fitted plot overlays the model-implied trajectories."),
          guide = tags$ol(
            tags$li("Set the number of subjects and time points."),
            tags$li("Adjust the fixed slope and random-effect variances."),
            tags$li("Optionally add a quadratic time term."),
            tags$li("Click Simulate & Fit to see spaghetti plots and model-implied trajectories.")
          )
        ),
        layout_column_wrap(width = 1 / 2,
          card(full_screen = TRUE, card_header("Raw Trajectories (Spaghetti)"),
               plotOutput(ns("mlm_gc_spaghetti"), height = "400px")),
          card(full_screen = TRUE, card_header("Model-Fitted Trajectories"),
               plotOutput(ns("mlm_gc_fitted"), height = "400px"))
        ),
        card(card_header("Model Summary"), uiOutput(ns("mlm_gc_summary")))
      )
    ),

    # ── Tab 4: Three-Level Models ──────────────────────────────────────
    nav_panel(
      "Three-Level",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("mlm_3l_n_l3"), "Level-3 units", min = 3, max = 20, value = 8),
          sliderInput(ns("mlm_3l_n_l2"), "Level-2 per L3", min = 3, max = 15, value = 5),
          sliderInput(ns("mlm_3l_n_l1"), "Level-1 per L2", min = 3, max = 20, value = 10),
          sliderInput(ns("mlm_3l_tau_l3"), "\u03c4 (Level-3 SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          sliderInput(ns("mlm_3l_tau_l2"), "\u03c4 (Level-2 SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          sliderInput(ns("mlm_3l_sigma"), "\u03c3 (Level-1 SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          actionButton(ns("mlm_3l_go"), "Simulate & Fit", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Three-Level Models"),
          tags$p("When data has three levels of nesting (e.g. students within classrooms
                  within schools), a three-level model partitions variance across all three
                  levels. This extends the two-level framework with an additional random
                  effect for the highest grouping factor."),
          tags$p("The structure plot shows the hierarchical nesting visually. The variance
                  bar chart decomposes total variance into level-3 (between top-level units),
                  level-2 (between mid-level units), and level-1 (within lowest units)."),
          tags$p("Three-level models require adequate sample sizes at each level for stable
                  estimation. A common guideline suggests at least 20\u201330 units at the highest
                  level, though requirements depend on ICC values and the complexity of the
                  random-effects structure. With few top-level units, variance components may
                  be poorly estimated."),
          guide = tags$ol(
            tags$li("Set the number of units at each level."),
            tags$li("Adjust the variance at each level."),
            tags$li("Click Simulate & Fit to generate nested data and decompose variance.")
          )
        ),
        layout_column_wrap(width = 1 / 2,
          card(full_screen = TRUE, card_header("Nesting Structure"),
               plotOutput(ns("mlm_3l_structure"), height = "400px")),
          card(full_screen = TRUE, card_header("Variance Decomposition"),
               plotOutput(ns("mlm_3l_variance"), height = "400px"))
        ),
        card(card_header("Model Summary"), uiOutput(ns("mlm_3l_summary")))
      )
    ),

    # ── Tab 5: Model Comparison ────────────────────────────────────────
    nav_panel(
      "Model Comparison",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("mlm_mc_n_groups"), "Number of groups", min = 5, max = 30, value = 15),
          sliderInput(ns("mlm_mc_n_per"), "Obs per group", min = 5, max = 50, value = 20),
          sliderInput(ns("mlm_mc_tau0"), "\u03c4\u2080 (intercept SD)", min = 0.1, max = 3, value = 1.5, step = 0.1),
          sliderInput(ns("mlm_mc_tau1"), "\u03c4\u2081 (slope SD)", min = 0, max = 2, value = 0.5, step = 0.1),
          sliderInput(ns("mlm_mc_sigma"), "\u03c3 (residual SD)", min = 0.1, max = 3, value = 1, step = 0.1),
          actionButton(ns("mlm_mc_go"), "Compare Models", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Model Comparison"),
          tags$p("Multilevel model building typically proceeds by comparing nested models:
                  intercept-only \u2192 random intercept \u2192 random slope \u2192
                  random intercept + slope. The likelihood ratio test (LRT) compares the
                  fit of nested models, though boundary issues arise when testing variance
                  components (which cannot be negative)."),
          tags$p("AIC and BIC provide alternative comparison criteria that penalise model
                  complexity. Lower values indicate better fit-complexity trade-offs. BIC
                  penalises complexity more heavily than AIC and tends to favour simpler
                  models, especially with large samples."),
          tags$p("A subtlety when comparing multilevel models: the LRT for variance components
                  tests at the boundary of the parameter space (variance \u2265 0), so the
                  standard \u03c7\u00b2 distribution is too conservative. A common correction is
                  to use a 50:50 mixture of \u03c7\u00b2 distributions. In practice, software
                  packages like lme4 report boundary-aware tests. Models should be compared
                  using ML (not REML) when fixed effects differ, and REML when only random
                  effects differ."),
          guide = tags$ol(
            tags$li("Set the data-generating parameters."),
            tags$li("Click Compare Models to fit a sequence of nested models."),
            tags$li("Examine the fit statistics table and LRT results."),
            tags$li("The plot shows AIC/BIC across models.")
          )
        ),
        card(full_screen = TRUE, card_header("Model Fit Comparison"),
             plotOutput(ns("mlm_mc_fit_plot"), height = "400px")),
        card(card_header("Likelihood Ratio Tests"), uiOutput(ns("mlm_mc_lrt"))),
        card(card_header("Fit Statistics"), tableOutput(ns("mlm_mc_table")))
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

multilevel_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: Random Intercepts & Slopes ────────────────────────────────
  ris_data <- reactiveVal(NULL)

  observeEvent(input$mlm_ris_go, {
    set.seed(sample(1:10000, 1))
    ng <- input$mlm_ris_n_groups; np <- input$mlm_ris_n_per
    b0 <- 5; b1 <- input$mlm_ris_fixed_slope
    tau0 <- input$mlm_ris_tau0; tau1 <- input$mlm_ris_tau1
    sig <- input$mlm_ris_sigma

    u0 <- rnorm(ng, 0, tau0)
    u1 <- rnorm(ng, 0, tau1)
    df <- do.call(rbind, lapply(1:ng, function(j) {
      x <- runif(np, 0, 10)
      y <- (b0 + u0[j]) + (b1 + u1[j]) * x + rnorm(np, 0, sig)
      data.frame(group = factor(j), x = x, y = y)
    }))

    # Fit models
    fit_pool <- lm(y ~ x, data = df)
    fit_nopool <- lm(y ~ x * group, data = df)
    fit_mixed <- lme4::lmer(y ~ x + (1 + x | group), data = df)

    ris_data(list(df = df, pool = fit_pool, nopool = fit_nopool, mixed = fit_mixed, ng = ng))
  })

  output$mlm_ris_pooled <- renderPlot(bg = "transparent", {
    d <- ris_data(); req(d)
    ggplot(d$df, aes(x, y)) + geom_point(alpha = 0.3) +
      geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
      labs(title = "Complete Pooling (one line for all)")
  })

  output$mlm_ris_nopool <- renderPlot(bg = "transparent", {
    d <- ris_data(); req(d)
    ggplot(d$df, aes(x, y, colour = group)) + geom_point(alpha = 0.3) +
      geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
      labs(title = "No Pooling (separate line per group)") +
      theme(legend.position = "none")
  })

  output$mlm_ris_partial <- renderPlot(bg = "transparent", {
    d <- ris_data(); req(d)
    pred_df <- expand.grid(
      x = seq(0, 10, length.out = 50),
      group = factor(1:d$ng)
    )
    pred_df$y <- predict(d$mixed, newdata = pred_df)
    ggplot(d$df, aes(x, y, colour = group)) + geom_point(alpha = 0.2) +
      geom_line(data = pred_df, aes(x, y, colour = group), linewidth = 0.8) +
      labs(title = "Partial Pooling (mixed model)") +
      theme(legend.position = "none")
  })

  output$mlm_ris_shrinkage <- renderPlot(bg = "transparent", {
    d <- ris_data(); req(d)
    # Compare no-pool vs mixed intercepts and slopes
    coef_np <- coef(d$nopool)
    int_np <- coef_np[1] + c(0, coef_np[grep("^group", names(coef_np))])
    coef_mx <- coef(d$mixed)$group
    shrink_df <- data.frame(
      nopool_int = int_np[1:d$ng],
      mixed_int = coef_mx[, 1]
    )
    grand <- fixef(d$mixed)[1]
    ggplot(shrink_df, aes(nopool_int, mixed_int)) +
      geom_point(size = 2) +
      geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey50") +
      geom_hline(yintercept = grand, linetype = "dotted", colour = "steelblue") +
      labs(x = "No-pooling intercept", y = "Mixed-model intercept",
           title = "Shrinkage: group intercepts pulled toward grand mean")
  })

  output$mlm_ris_summary <- renderUI({
    d <- ris_data(); req(d)
    HTML(fmt_lmer_html(d$mixed))
  })

  # ── Tab 2: Variance Components & ICC ─────────────────────────────────
  icc_data <- reactiveVal(NULL)

  observeEvent(input$mlm_icc_go, {
    set.seed(sample(1:10000, 1))
    ng <- input$mlm_icc_n_groups; np <- input$mlm_icc_n_per
    tau <- input$mlm_icc_tau; sig <- input$mlm_icc_sigma

    u <- rnorm(ng, 0, tau)
    df <- do.call(rbind, lapply(1:ng, function(j) {
      y <- 50 + u[j] + rnorm(np, 0, sig)
      data.frame(group = factor(j), y = y)
    }))

    fit <- lme4::lmer(y ~ 1 + (1 | group), data = df)
    vc <- as.data.frame(lme4::VarCorr(fit))
    icc_data(list(df = df, fit = fit, vc = vc, tau = tau, sigma = sig))
  })

  output$mlm_icc_dotplot <- renderPlot(bg = "transparent", {
    d <- icc_data(); req(d)
    ggplot(d$df, aes(y = reorder(group, y, mean), x = y)) +
      geom_point(alpha = 0.4, size = 1.5) +
      stat_summary(fun = mean, geom = "point", size = 3, colour = "red") +
      labs(x = "y", y = "Group", title = "Observations by Group")
  })

  output$mlm_icc_bar <- renderPlot(bg = "transparent", {
    d <- icc_data(); req(d)
    vc <- d$vc
    tau2 <- vc$vcov[vc$grp == "group"]
    sig2 <- vc$vcov[vc$grp == "Residual"]
    icc_val <- tau2 / (tau2 + sig2)

    bar_df <- data.frame(
      Component = c("Between-group (\u03c4\u00b2)", "Within-group (\u03c3\u00b2)"),
      Variance = c(tau2, sig2)
    )
    ggplot(bar_df, aes(x = Component, y = Variance, fill = Component)) +
      geom_col(width = 0.5) +
      labs(title = paste0("Variance Decomposition (ICC = ", round(icc_val, 3), ")"),
           y = "Estimated Variance") +
      theme(legend.position = "none")
  })

  output$mlm_icc_summary <- renderUI({
    d <- icc_data(); req(d)
    vc <- d$vc
    tau2 <- vc$vcov[vc$grp == "group"]
    sig2 <- vc$vcov[vc$grp == "Residual"]
    icc <- tau2 / (tau2 + sig2)
    true_icc <- d$tau^2 / (d$tau^2 + d$sigma^2)

    HTML(sprintf('
      <div style="padding: 0.5rem;">
        <div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">
          Model: y ~ 1 + (1 | group)
        </div>
        <table class="table table-sm table-striped mb-3" style="font-size: 0.9rem;">
          <thead><tr><th>Component</th><th>Estimated</th><th>True</th></tr></thead>
          <tbody>
            <tr><td>Between-group variance (\u03c4\u00b2)</td>
                <td>%.3f</td><td>%.3f</td></tr>
            <tr><td>Within-group variance (\u03c3\u00b2)</td>
                <td>%.3f</td><td>%.3f</td></tr>
            <tr style="font-weight: 600;">
                <td>ICC</td><td>%.4f</td><td>%.4f</td></tr>
          </tbody>
        </table>
        <small class="text-muted">
          ICC = \u03c4\u00b2 / (\u03c4\u00b2 + \u03c3\u00b2).
          True \u03c4 = %.1f, True \u03c3 = %.1f.
        </small>
      </div>',
      tau2, d$tau^2, sig2, d$sigma^2, icc, true_icc, d$tau, d$sigma
    ))
  })

  # ── Tab 3: Growth Curve Models ───────────────────────────────────────
  gc_data <- reactiveVal(NULL)

  observeEvent(input$mlm_gc_go, {
    set.seed(sample(1:10000, 1))
    ns <- input$mlm_gc_n_subj; nt <- input$mlm_gc_n_time
    b0 <- 5; b1 <- input$mlm_gc_fixed_slope
    tau0 <- input$mlm_gc_tau0; tau1 <- input$mlm_gc_tau1
    sig <- input$mlm_gc_sigma
    quad <- input$mlm_gc_quadratic

    u0 <- rnorm(ns, 0, tau0)
    u1 <- rnorm(ns, 0, tau1)
    df <- do.call(rbind, lapply(1:ns, function(i) {
      time <- seq(0, nt - 1)
      y <- (b0 + u0[i]) + (b1 + u1[i]) * time
      if (quad) y <- y - 0.02 * time^2
      y <- y + rnorm(nt, 0, sig)
      data.frame(id = factor(i), time = time, y = y)
    }))

    formula <- if (quad) y ~ time + I(time^2) + (1 + time | id)
               else y ~ time + (1 + time | id)
    fit <- lme4::lmer(formula, data = df)
    gc_data(list(df = df, fit = fit, ns = ns))
  })

  output$mlm_gc_spaghetti <- renderPlot(bg = "transparent", {
    d <- gc_data(); req(d)
    ggplot(d$df, aes(time, y, group = id, colour = id)) +
      geom_line(alpha = 0.5) + geom_point(size = 1, alpha = 0.5) +
      labs(title = "Individual Trajectories") +
      theme(legend.position = "none")
  })

  output$mlm_gc_fitted <- renderPlot(bg = "transparent", {
    d <- gc_data(); req(d)
    d$df$fitted <- predict(d$fit)
    ggplot(d$df, aes(time, fitted, group = id, colour = id)) +
      geom_line(linewidth = 0.8) +
      labs(title = "Model-Fitted Trajectories", y = "Predicted y") +
      theme(legend.position = "none")
  })

  output$mlm_gc_summary <- renderUI({
    d <- gc_data(); req(d)
    HTML(fmt_lmer_html(d$fit))
  })

  # ── Tab 4: Three-Level Models ────────────────────────────────────────
  three_data <- reactiveVal(NULL)

  observeEvent(input$mlm_3l_go, {
    set.seed(sample(1:10000, 1))
    n3 <- input$mlm_3l_n_l3; n2 <- input$mlm_3l_n_l2; n1 <- input$mlm_3l_n_l1
    tau3 <- input$mlm_3l_tau_l3; tau2 <- input$mlm_3l_tau_l2
    sig <- input$mlm_3l_sigma

    u3 <- rnorm(n3, 0, tau3)
    df <- do.call(rbind, lapply(1:n3, function(k) {
      u2 <- rnorm(n2, 0, tau2)
      do.call(rbind, lapply(1:n2, function(j) {
        y <- 50 + u3[k] + u2[j] + rnorm(n1, 0, sig)
        data.frame(l3 = factor(k), l2 = factor(paste0(k, ".", j)), y = y)
      }))
    }))

    fit <- lme4::lmer(y ~ 1 + (1 | l3) + (1 | l2), data = df)
    three_data(list(df = df, fit = fit, n3 = n3, n2 = n2))
  })

  output$mlm_3l_structure <- renderPlot(bg = "transparent", {
    d <- three_data(); req(d)
    # Dot plot coloured by level-3 unit
    ggplot(d$df, aes(y = l2, x = y, colour = l3)) +
      geom_point(alpha = 0.3, size = 1) +
      stat_summary(fun = mean, geom = "point", size = 2.5) +
      labs(title = "Observations by Level-2 Unit (coloured by Level-3)",
           y = "Level-2 Unit", colour = "Level-3") +
      theme(axis.text.y = element_text(size = 6))
  })

  output$mlm_3l_variance <- renderPlot(bg = "transparent", {
    d <- three_data(); req(d)
    vc <- as.data.frame(lme4::VarCorr(d$fit))
    bar_df <- data.frame(
      Level = c("Level 3 (between)", "Level 2 (between)", "Level 1 (within)"),
      Variance = c(
        vc$vcov[vc$grp == "l3"],
        vc$vcov[vc$grp == "l2"],
        vc$vcov[vc$grp == "Residual"]
      )
    )
    bar_df$Level <- factor(bar_df$Level, levels = bar_df$Level)
    ggplot(bar_df, aes(y = Level, x = Variance, fill = Level)) +
      geom_col(width = 0.5) +
      labs(title = "Three-Level Variance Decomposition", x = "Variance") +
      theme(legend.position = "none")
  })

  output$mlm_3l_summary <- renderUI({
    d <- three_data(); req(d)
    HTML(fmt_lmer_html(d$fit))
  })

  # ── Tab 5: Model Comparison ──────────────────────────────────────────
  mc_data <- reactiveVal(NULL)

  observeEvent(input$mlm_mc_go, {
    set.seed(sample(1:10000, 1))
    ng <- input$mlm_mc_n_groups; np <- input$mlm_mc_n_per
    tau0 <- input$mlm_mc_tau0; tau1 <- input$mlm_mc_tau1
    sig <- input$mlm_mc_sigma

    u0 <- rnorm(ng, 0, tau0); u1 <- rnorm(ng, 0, tau1)
    df <- do.call(rbind, lapply(1:ng, function(j) {
      x <- runif(np, 0, 10)
      y <- (5 + u0[j]) + (0.5 + u1[j]) * x + rnorm(np, 0, sig)
      data.frame(group = factor(j), x = x, y = y)
    }))

    m0 <- lm(y ~ x, data = df)
    m1 <- lme4::lmer(y ~ x + (1 | group), data = df)
    m2 <- lme4::lmer(y ~ x + (1 + x | group), data = df)

    mc_data(list(df = df, m0 = m0, m1 = m1, m2 = m2))
  })

  output$mlm_mc_fit_plot <- renderPlot(bg = "transparent", {
    d <- mc_data(); req(d)
    fits <- data.frame(
      Model = c("OLS (no random)", "Random Intercept", "Random Int + Slope"),
      AIC = c(AIC(d$m0), AIC(d$m1), AIC(d$m2)),
      BIC = c(BIC(d$m0), BIC(d$m1), BIC(d$m2))
    )
    fits$Model <- factor(fits$Model, levels = fits$Model)
    fits_long <- reshape(fits, direction = "long",
      varying = list(c("AIC", "BIC")), v.names = "Value",
      timevar = "Criterion", times = c("AIC", "BIC"))
    ggplot(fits_long, aes(Model, Value, fill = Criterion)) +
      geom_col(position = "dodge", width = 0.6) +
      labs(title = "Model Fit Comparison", y = "Information Criterion")
  })

  output$mlm_mc_lrt <- renderUI({
    d <- mc_data(); req(d)
    a <- anova(d$m1, d$m2)
    a_df <- as.data.frame(a)

    rows <- vapply(seq_len(nrow(a_df)), function(i) {
      p_val <- if (!is.na(a_df[i, "Pr(>Chisq)"])) {
        pv <- a_df[i, "Pr(>Chisq)"]
        if (pv < 0.001) "< .001" else sprintf("%.4f", pv)
      } else "\u2014"
      chisq_val <- if (!is.na(a_df[i, "Chisq"])) sprintf("%.2f", a_df[i, "Chisq"]) else "\u2014"
      chi_df <- if (!is.na(a_df[i, "Chi Df"])) as.integer(a_df[i, "Chi Df"]) else "\u2014"
      sprintf(
        "<tr><td>%s</td><td>%d</td><td>%.1f</td><td>%.1f</td><td>%.1f</td><td>%s</td><td>%s</td><td>%s</td></tr>",
        rownames(a_df)[i], a_df[i, "npar"], a_df[i, "AIC"], a_df[i, "BIC"],
        a_df[i, "logLik"], chisq_val, chi_df, p_val
      )
    }, character(1))

    HTML(sprintf('
      <div style="padding: 0.5rem;">
        <p class="small text-muted mb-2">
          <strong>Note:</strong> LM vs. LMER not directly comparable via LRT.
          Comparison below is Random Intercept vs. Random Intercept + Slope.
        </p>
        <table class="table table-sm table-striped" style="font-size: 0.9rem;">
          <thead><tr><th>Model</th><th>npar</th><th>AIC</th><th>BIC</th>
                     <th>logLik</th><th>\u03c7\u00b2</th><th>df</th><th>p</th></tr></thead>
          <tbody>%s</tbody>
        </table>
      </div>', paste(rows, collapse = "")
    ))
  })

  output$mlm_mc_table <- renderTable({
    d <- mc_data(); req(d)
    data.frame(
      Model = c("OLS", "Random Intercept", "Random Int + Slope"),
      AIC = round(c(AIC(d$m0), AIC(d$m1), AIC(d$m2)), 1),
      BIC = round(c(BIC(d$m0), BIC(d$m1), BIC(d$m2)), 1),
      logLik = round(c(logLik(d$m0), logLik(d$m1), logLik(d$m2)), 1)
    )
  })
  # Auto-run simulations on first load
  })
}
