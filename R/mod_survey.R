# ===========================================================================
# Survey Methodology Module
# Topics: Sampling designs, weighting, design effects, complex survey SE
# ===========================================================================

survey_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  title = "Survey Methodology",
  icon  = icon("clipboard-list"),
  layout_sidebar(
    sidebar = sidebar(
      title = "Survey Settings",
      width = 310,

      # ── Tab 1: Sampling Designs ──
      conditionalPanel(ns = ns, 
        "input.survey_tabs == 'Sampling Designs'",
        sliderInput(ns("surv_pop_n"), "Population size", 500, 5000, 2000, step = 500),
        sliderInput(ns("surv_samp_n"), "Sample size", 20, 500, 100, step = 10),
        selectInput(ns("surv_strat_var"), "Stratification variable",
                    c("Region (4 strata)", "Income (3 strata)", "Age group (5 strata)")),
        sliderInput(ns("surv_n_clusters"), "Number of clusters (for cluster design)",
                    5, 50, 20, step = 5),
        actionButton(ns("surv_draw"), "Draw Samples", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 2: Design Effects ──
      conditionalPanel(ns = ns, 
        "input.survey_tabs == 'Design Effects'",
        sliderInput(ns("surv_icc"), "Intra-class correlation (ICC)", 0, 0.5, 0.05, step = 0.01),
        sliderInput(ns("surv_cluster_size"), "Cluster size (m)", 5, 100, 20, step = 5),
        sliderInput(ns("surv_n_clusters_deff"), "Number of clusters", 5, 100, 30, step = 5),
        actionButton(ns("surv_deff_go"), "Calculate DEFF", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 3: Weighting ──
      conditionalPanel(ns = ns, 
        "input.survey_tabs == 'Weighting'",
        sliderInput(ns("surv_weight_n"), "Sample size", 100, 2000, 500, step = 100),
        selectInput(ns("surv_weight_type"), "Weighting method",
                    c("Post-stratification", "Raking (iterative)", "Inverse probability")),
        checkboxInput(ns("surv_weight_show_eff"), "Show effective sample size", TRUE),
        actionButton(ns("surv_weight_go"), "Simulate & Weight", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 4: Complex Survey SEs ──
      conditionalPanel(ns = ns, 
        "input.survey_tabs == 'Complex Survey SEs'",
        sliderInput(ns("surv_se_n"), "Total sample size", 200, 3000, 1000, step = 200),
        selectInput(ns("surv_se_design"), "Survey design",
                    c("SRS", "Stratified", "Cluster", "Stratified + Cluster")),
        sliderInput(ns("surv_se_icc"), "ICC (for cluster designs)", 0, 0.3, 0.05, step = 0.01),
        actionButton(ns("surv_se_go"), "Compare SEs", class = "btn-success w-100 mt-2")
      )
    ),

    navset_card_tab(
      id = ns("survey_tabs"),

      # ── Tab 1 ──
      nav_panel("Sampling Designs",
        explanation_box(
          tags$strong("Sampling Designs"),
          tags$p("The way you select a sample from a population determines
                  both the precision of your estimates and the kinds of
                  inferences you can draw. A simple random sample (SRS)
                  gives every unit an equal chance of selection, but it
                  can be inefficient when the population has known
                  subgroups that differ on the outcome of interest."),
          tags$p("Stratified sampling divides the population into
                  homogeneous strata (e.g., regions or age groups) and
                  samples independently within each stratum. Because
                  variability within strata is lower than overall variability,
                  stratified designs typically produce smaller standard
                  errors than SRS of the same total size. The improvement
                  depends on how much the strata means differ."),
          tags$p("Cluster sampling selects entire groups (clusters) rather
                  than individual units. This is often used for logistical
                  reasons — it is cheaper to survey everyone in 20 selected
                  schools than to reach 20 students scattered across 200
                  schools. The trade-off is that individuals within a cluster
                  tend to be similar (positive ICC), so cluster samples carry
                  less information per unit than an SRS of the same size.
                  Multi-stage designs combine clustering and stratification
                  for large national surveys.")
        ),
        layout_column_wrap(width = 1 / 2,
          card(card_header("Population & Samples"), card_body(plotly::plotlyOutput(ns("surv_design_plot"), height = "380px"))),
          card(card_header("Estimate Comparison"), card_body(plotly::plotlyOutput(ns("surv_estimate_plot"), height = "380px")))
        ),
        card(card_header("Summary Table"), card_body(tableOutput(ns("surv_design_table"))))
      ),

      # ── Tab 2 ──
      nav_panel("Design Effects",
        explanation_box(
          tags$strong("Design Effects (DEFF)"),
          tags$p("The design effect (DEFF) measures how much less efficient
                  a complex design is compared to a simple random sample of
                  the same size. A DEFF of 2 means you need twice as many
                  observations to achieve the same precision as an SRS. For
                  cluster sampling, the classic approximation is
                  DEFF = 1 + (m − 1) × ICC, where m is the cluster size
                  and ICC is the intra-class correlation."),
          tags$p("The effective sample size equals n / DEFF. If you
                  surveyed 600 people in 30 clusters of 20, and the ICC is
                  0.05, DEFF = 1 + 19 × 0.05 = 1.95, so your effective
                  sample is about 308 — nearly half the actual count. This
                  has major implications for power calculations and for
                  reporting honest margins of error."),
          tags$p("In practice, ICC values vary by outcome. Health
                  behaviours in geographic clusters often have ICCs around
                  0.01–0.05; opinions within schools can be 0.10–0.30. It
                  pays to look up published ICCs for your outcome domain
                  before choosing cluster sizes, because even modest ICCs
                  inflate the DEFF substantially when cluster sizes are
                  large.")
        ),
        layout_column_wrap(width = 1 / 2,
          card(card_header("DEFF by ICC and Cluster Size"), card_body(plotly::plotlyOutput(ns("surv_deff_surface"), height = "380px"))),
          card(card_header("Effective Sample Size"), card_body(plotly::plotlyOutput(ns("surv_deff_eff_plot"), height = "380px")))
        ),
        card(card_header("Current DEFF"), card_body(uiOutput(ns("surv_deff_summary"))))
      ),

      # ── Tab 3 ──
      nav_panel("Weighting",
        explanation_box(
          tags$strong("Survey Weighting"),
          tags$p("Survey weights adjust for differences between the sample
                  and the target population. Without weighting, groups that
                  are overrepresented in the sample exert too much influence
                  on estimates. Post-stratification reweights the sample so
                  that weighted cell proportions match known population
                  proportions (e.g., from census data)."),
          tags$p("Raking (iterative proportional fitting) adjusts weights
                  to match population marginal totals on multiple
                  dimensions simultaneously, even when cross-tabulated
                  population counts are unavailable. Inverse probability
                  weighting gives each unit a weight equal to the reciprocal
                  of its selection probability, which is especially important
                  in unequal-probability designs."),
          tags$p("Weighting improves representativeness but comes at a
                  cost: the effective sample size shrinks. Highly variable
                  weights increase the variance of estimates. The design
                  effect due to weighting is approximately
                  1 + CV(w)², where CV(w) is the coefficient of variation
                  of the weights. Trimming extreme weights or using bounded
                  raking can mitigate this variance inflation while
                  maintaining reasonable bias correction.")
        ),
        layout_column_wrap(width = 1 / 2,
          card(card_header("Unweighted vs. Weighted Estimates"), card_body(plotly::plotlyOutput(ns("surv_weight_plot"), height = "380px"))),
          card(card_header("Weight Distribution"), card_body(plotly::plotlyOutput(ns("surv_weight_dist_plot"), height = "380px")))
        ),
        card(card_header("Weighting Summary"), card_body(tableOutput(ns("surv_weight_table"))))
      ),

      # ── Tab 4 ──
      nav_panel("Complex Survey SEs",
        explanation_box(
          tags$strong("Standard Errors Under Complex Designs"),
          tags$p("Standard textbook formulas for standard errors assume
                  simple random sampling. When data come from stratified,
                  clustered, or weighted designs, using naive SEs leads to
                  incorrect confidence intervals and p-values — usually
                  underestimating uncertainty for cluster designs."),
          tags$p("Design-based inference uses the actual sampling structure
                  to estimate variances. Taylor-series linearisation is the
                  default method in most survey software. Replication methods
                  (jackknife, balanced repeated replication) provide
                  alternatives that are especially useful for complex
                  statistics like medians or quantiles."),
          tags$p("This tab simulates data under different designs and
                  compares the 'naive' SE (ignoring the design) with the
                  correct design-based SE. For stratified designs the
                  correct SE is usually smaller than the naive SE; for
                  cluster designs it is larger. Ignoring clustering is one
                  of the most common methodological errors in applied
                  research.")
        ),
        layout_column_wrap(width = 1 / 2,
          card(card_header("SE Comparison"), card_body(plotly::plotlyOutput(ns("surv_se_plot"), height = "380px"))),
          card(card_header("Coverage Simulation"), card_body(plotly::plotlyOutput(ns("surv_se_coverage"), height = "380px")))
        ),
        card(card_header("Design Summary"), card_body(uiOutput(ns("surv_se_summary"))))
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

survey_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ════════════════════════════════════════════════════════════

  # Tab 1 — Sampling Designs
  # ════════════════════════════════════════════════════════════
  surv_design_data <- eventReactive(input$surv_draw, {
    N <- input$surv_pop_n
    n <- min(input$surv_samp_n, N)

    n_strata <- switch(input$surv_strat_var,
      "Region (4 strata)" = 4,
      "Income (3 strata)" = 3,
      "Age group (5 strata)" = 5, 4)

    strat_means <- seq(5, 5 + (n_strata - 1) * 3, length.out = n_strata)
    pop_stratum <- sample(seq_len(n_strata), N, replace = TRUE)
    pop_y <- rnorm(N, mean = strat_means[pop_stratum], sd = 3)
    pop <- data.frame(id = seq_len(N), stratum = pop_stratum, y = pop_y,
                      x = runif(N), ycoord = runif(N))

    pop_mean <- mean(pop$y)

    # SRS
    srs_idx <- sample(N, n)
    srs_est <- mean(pop$y[srs_idx])
    srs_se <- sd(pop$y[srs_idx]) / sqrt(n)

    # Stratified (proportional allocation)
    strat_n <- as.integer(round(n * table(pop$stratum) / N))
    strat_n[strat_n < 1] <- 1
    strat_idx <- unlist(lapply(seq_len(n_strata), function(s) {
      pool <- which(pop$stratum == s)
      sample(pool, min(strat_n[s], length(pool)))
    }))
    strat_est <- mean(pop$y[strat_idx])
    strat_se <- sqrt(sum(sapply(seq_len(n_strata), function(s) {
      idx <- strat_idx[pop$stratum[strat_idx] == s]
      w <- sum(pop$stratum == s) / N
      w^2 * var(pop$y[idx]) / length(idx)
    })))

    # Cluster
    n_cl <- min(input$surv_n_clusters, N %/% 5)
    cl_size <- N %/% n_cl
    pop$cluster <- rep(seq_len(n_cl), each = cl_size)[seq_len(N)]
    pop$cluster[is.na(pop$cluster)] <- n_cl
    sel_cl <- sample(seq_len(n_cl), max(2, n_cl %/% 3))
    cl_idx <- which(pop$cluster %in% sel_cl)
    cl_est <- mean(pop$y[cl_idx])
    cl_means <- sapply(sel_cl, function(c) mean(pop$y[pop$cluster == c]))
    cl_se <- sd(cl_means) / sqrt(length(sel_cl))

    list(pop = pop, pop_mean = pop_mean,
         srs = list(idx = srs_idx, est = srs_est, se = srs_se),
         strat = list(idx = strat_idx, est = strat_est, se = strat_se),
         clust = list(idx = cl_idx, est = cl_est, se = cl_se, sel_cl = sel_cl))
  })

  output$surv_design_plot <- plotly::renderPlotly({
    d <- surv_design_data(); req(d)
    pop <- d$pop
    is_srs <- seq_len(nrow(pop)) %in% d$srs$idx
    marker_col <- ifelse(is_srs, "#268bd2", "#c0c0c0")
    marker_opa <- ifelse(is_srs, 1, 0.15)
    plotly::plot_ly(pop, x = ~x, y = ~ycoord, type = "scatter", mode = "markers",
                    marker = list(size = 4, color = marker_col, opacity = marker_opa),
                    hoverinfo = "text",
                    text = ~paste0("ID: ", id, "<br>Y: ", round(y, 2),
                                   "<br>Stratum: ", stratum)) |>
      plotly::layout(
        xaxis = list(title = "", showticklabels = FALSE),
        yaxis = list(title = "", showticklabels = FALSE),
        title = list(text = "Population with SRS highlights", font = list(size = 12)),
        margin = list(t = 40),
        showlegend = FALSE
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_estimate_plot <- plotly::renderPlotly({
    d <- surv_design_data(); req(d)
    designs <- c("SRS", "Stratified", "Cluster")
    ests <- c(d$srs$est, d$strat$est, d$clust$est)
    ses <- c(d$srs$se, d$strat$se, d$clust$se)
    cols <- c("#268bd2", "#2aa198", "#b58900")

    plotly::plot_ly() |>
      plotly::add_trace(
        x = designs, y = ests, type = "bar",
        marker = list(color = cols, line = list(color = "white", width = 1)),
        error_y = list(type = "data", array = 1.96 * ses, color = "#333"),
        hoverinfo = "text", textposition = "none",
        text = paste0(designs, "<br>Est: ", round(ests, 3),
                      "<br>SE: ", round(ses, 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = -0.5, x1 = 2.5,
                           y0 = d$pop_mean, y1 = d$pop_mean,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = 2.5, y = d$pop_mean, text = paste0("True mean = ", round(d$pop_mean, 2)),
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = ""),
        yaxis = list(title = "Estimated Mean"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_design_table <- renderTable({
    d <- surv_design_data(); req(d)
    data.frame(
      Design = c("SRS", "Stratified", "Cluster"),
      Estimate = round(c(d$srs$est, d$strat$est, d$clust$est), 3),
      SE = round(c(d$srs$se, d$strat$se, d$clust$se), 3),
      `95% CI Lower` = round(c(d$srs$est, d$strat$est, d$clust$est) -
                               1.96 * c(d$srs$se, d$strat$se, d$clust$se), 3),
      `95% CI Upper` = round(c(d$srs$est, d$strat$est, d$clust$est) +
                               1.96 * c(d$srs$se, d$strat$se, d$clust$se), 3),
      `Sample n` = c(length(d$srs$idx), length(d$strat$idx), length(d$clust$idx)),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, spacing = "s", width = "100%")

  # ════════════════════════════════════════════════════════════
  # Tab 2 — Design Effects
  # ════════════════════════════════════════════════════════════
  surv_deff_data <- eventReactive(input$surv_deff_go, {
    icc <- input$surv_icc
    m <- input$surv_cluster_size
    k <- input$surv_n_clusters_deff
    deff <- 1 + (m - 1) * icc
    n_total <- m * k
    n_eff <- n_total / deff
    list(icc = icc, m = m, k = k, deff = deff, n_total = n_total, n_eff = n_eff)
  })

  output$surv_deff_surface <- plotly::renderPlotly({
    d <- surv_deff_data(); req(d)
    iccs <- seq(0, 0.3, length.out = 30)
    ms <- seq(5, 100, length.out = 30)
    z <- outer(iccs, ms, function(i, m) 1 + (m - 1) * i)

    plotly::plot_ly(x = ms, y = iccs, z = z, type = "heatmap", xgap = 2, ygap = 2,
                    colorscale = list(c(0, "#edf8b1"), c(0.5, "#41b6c4"), c(1, "#253494")),
                    hoverinfo = "text",
                    text = outer(iccs, ms, function(i, m)
                      paste0("ICC = ", round(i, 3), "<br>m = ", round(m),
                             "<br>DEFF = ", round(1 + (m - 1) * i, 2)))) |>
      plotly::layout(
        xaxis = list(title = "Cluster Size (m)"),
        yaxis = list(title = "ICC"),
        margin = list(t = 20)
      ) |>
      plotly::colorbar(title = "DEFF") |>
      plotly::config(displayModeBar = FALSE)
  })

  output$surv_deff_eff_plot <- plotly::renderPlotly({
    d <- surv_deff_data(); req(d)
    ms <- seq(5, 100, by = 5)
    k <- d$k
    n_effs <- (ms * k) / (1 + (ms - 1) * d$icc)

    plotly::plot_ly(x = ms, y = n_effs, type = "scatter", mode = "lines+markers",
                    line = list(color = "#268bd2", width = 2),
                    marker = list(color = "#268bd2", size = 5),
                    hoverinfo = "text",
                    text = paste0("Cluster size = ", ms,
                                  "<br>Total n = ", ms * k,
                                  "<br>n_eff = ", round(n_effs))) |>
      plotly::add_trace(x = ms, y = ms * k, mode = "lines",
                        line = list(color = "#93a1a1", dash = "dash", width = 1),
                        name = "Actual n", hoverinfo = "skip") |>
      plotly::layout(
        xaxis = list(title = "Cluster Size (m)"),
        yaxis = list(title = "Sample Size"),
        showlegend = TRUE,
        legend = list(x = 0.7, y = 0.95),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_deff_summary <- renderUI({
    d <- surv_deff_data(); req(d)
    HTML(sprintf(
      '<div style="padding: 0.5rem;">
       <table class="table table-sm table-striped" style="font-size: 0.9rem; max-width: 500px;">
       <tr><td><strong>ICC</strong></td><td>%.3f</td></tr>
       <tr><td><strong>Cluster size (m)</strong></td><td>%d</td></tr>
       <tr><td><strong>Number of clusters (k)</strong></td><td>%d</td></tr>
       <tr><td><strong>Total n</strong></td><td>%d</td></tr>
       <tr><td><strong>DEFF</strong></td><td>%.2f</td></tr>
       <tr><td><strong>Effective n</strong></td><td>%.0f</td></tr>
       <tr><td><strong>Efficiency</strong></td><td>%.1f%%</td></tr>
       </table></div>',
      d$icc, d$m, d$k, d$n_total, d$deff, d$n_eff, d$n_eff / d$n_total * 100
    ))
  })

  # ════════════════════════════════════════════════════════════
  # Tab 3 — Weighting
  # ════════════════════════════════════════════════════════════
  surv_weight_data <- eventReactive(input$surv_weight_go, {
    n <- input$surv_weight_n

    # Population proportions for 3 age groups
    pop_props <- c(Young = 0.30, Middle = 0.45, Old = 0.25)
    pop_means <- c(Young = 45, Middle = 55, Old = 65)

    # Biased sample: over-sample young, under-sample old
    samp_probs <- c(Young = 0.50, Middle = 0.35, Old = 0.15)
    groups <- sample(names(pop_props), n, replace = TRUE, prob = samp_probs)
    y <- rnorm(n, mean = pop_means[groups], sd = 8)
    samp <- data.frame(group = groups, y = y, stringsAsFactors = FALSE)

    # Unweighted estimate
    unwt_est <- mean(samp$y)

    # Post-stratification weights
    samp_props <- table(samp$group) / n
    ps_weights <- pop_props[samp$group] / samp_props[samp$group]
    ps_weights <- ps_weights / mean(ps_weights)  # normalise to mean = 1

    wt_est <- weighted.mean(samp$y, ps_weights)
    pop_true <- sum(pop_props * pop_means)

    # Effective sample size
    n_eff <- n / (1 + var(ps_weights) / mean(ps_weights)^2)
    cv_w <- sd(ps_weights) / mean(ps_weights)

    samp$weight <- as.numeric(ps_weights)

    list(samp = samp, unwt_est = unwt_est, wt_est = wt_est,
         pop_true = pop_true, pop_props = pop_props, samp_props = samp_props,
         n_eff = n_eff, cv_w = cv_w, n = n, method = input$surv_weight_type)
  })

  output$surv_weight_plot <- plotly::renderPlotly({
    d <- surv_weight_data(); req(d)
    labs <- c("Unweighted", "Weighted")
    vals <- c(d$unwt_est, d$wt_est)
    cols <- c("#b58900", "#2aa198")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = labs, y = vals,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        hoverinfo = "text", textposition = "none",
        text = paste0(labs, ": ", round(vals, 2)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = -0.5, x1 = 1.5,
                           y0 = d$pop_true, y1 = d$pop_true,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = 1.5, y = d$pop_true,
          text = paste0("Pop. mean = ", round(d$pop_true, 2)),
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = ""),
        yaxis = list(title = "Estimated Mean"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_weight_dist_plot <- plotly::renderPlotly({
    d <- surv_weight_data(); req(d)
    w <- d$samp$weight
    h <- hist(w, breaks = 25, plot = FALSE)

    plotly::plot_ly() |>
      plotly::add_bars(
        x = h$mids, y = h$counts,
        marker = list(color = "#268bd2", line = list(color = "white", width = 0.5)),
        hoverinfo = "text", textposition = "none",
        text = paste0("Weight \u2248 ", round(h$mids, 2), "<br>Count: ", h$counts),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Weight"),
        yaxis = list(title = "Frequency"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_weight_table <- renderTable({
    d <- surv_weight_data(); req(d)
    grps <- names(d$pop_props)
    data.frame(
      Group = grps,
      `Pop. Proportion` = as.numeric(d$pop_props[grps]),
      `Sample Proportion` = as.numeric(d$samp_props[grps]),
      `Ratio (Pop/Samp)` = round(as.numeric(d$pop_props[grps]) /
                                  as.numeric(d$samp_props[grps]), 2),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, spacing = "s", width = "100%")

  # ════════════════════════════════════════════════════════════
  # Tab 4 — Complex Survey SEs
  # ════════════════════════════════════════════════════════════
  surv_se_data <- eventReactive(input$surv_se_go, {
    n <- input$surv_se_n
    design <- input$surv_se_design
    icc <- input$surv_se_icc
    pop_mean <- 50; pop_sd <- 10

    n_sims <- 500
    naive_ci_covers <- 0
    design_ci_covers <- 0
    naive_ses <- numeric(n_sims)
    design_ses <- numeric(n_sims)

    for (i in seq_len(n_sims)) {
      if (design == "SRS") {
        y <- rnorm(n, pop_mean, pop_sd)
        naive_se <- sd(y) / sqrt(n)
        design_se <- naive_se
      } else if (design == "Stratified") {
        n_strata <- 4
        strat_means <- pop_mean + c(-5, -2, 2, 5)
        ns <- rep(n %/% n_strata, n_strata)
        ns[1] <- ns[1] + n - sum(ns)
        y_list <- lapply(seq_len(n_strata), function(s)
          rnorm(ns[s], strat_means[s], pop_sd * 0.7))
        y <- unlist(y_list)
        naive_se <- sd(y) / sqrt(n)
        design_se <- sqrt(sum(sapply(y_list, function(yy)
          (length(yy) / n)^2 * var(yy) / length(yy))))
      } else if (design == "Cluster") {
        m <- 20
        k <- n %/% m
        cluster_means <- rnorm(k, pop_mean, pop_sd * sqrt(icc))
        y <- unlist(lapply(cluster_means, function(cm)
          rnorm(m, cm, pop_sd * sqrt(1 - icc))))
        cl_means <- sapply(split(y, rep(seq_len(k), each = m)), mean)
        naive_se <- sd(y) / sqrt(length(y))
        design_se <- sd(cl_means) / sqrt(k)
      } else {
        # Stratified + Cluster
        n_strata <- 4
        strat_means <- pop_mean + c(-5, -2, 2, 5)
        k_per <- max(3, (n %/% 20) %/% n_strata)
        m <- 20
        y_all <- c(); design_var <- 0
        for (s in seq_len(n_strata)) {
          cl_m <- rnorm(k_per, strat_means[s], pop_sd * sqrt(icc))
          y_s <- unlist(lapply(cl_m, function(cm) rnorm(m, cm, pop_sd * sqrt(1 - icc))))
          y_all <- c(y_all, y_s)
          cl_s_means <- sapply(split(y_s, rep(seq_len(k_per), each = m)), mean)
          w <- 0.25
          design_var <- design_var + w^2 * var(cl_s_means) / k_per
        }
        y <- y_all
        naive_se <- sd(y) / sqrt(length(y))
        design_se <- sqrt(design_var)
      }

      est <- mean(y)
      naive_ci_covers <- naive_ci_covers +
        (est - 1.96 * naive_se <= pop_mean & est + 1.96 * naive_se >= pop_mean)
      design_ci_covers <- design_ci_covers +
        (est - 1.96 * design_se <= pop_mean & est + 1.96 * design_se >= pop_mean)
      naive_ses[i] <- naive_se
      design_ses[i] <- design_se
    }

    list(design = design, n = n, icc = icc,
         naive_se_mean = mean(naive_ses), design_se_mean = mean(design_ses),
         naive_coverage = naive_ci_covers / n_sims,
         design_coverage = design_ci_covers / n_sims,
         naive_ses = naive_ses, design_ses = design_ses)
  })

  output$surv_se_plot <- plotly::renderPlotly({
    d <- surv_se_data(); req(d)
    labs <- c("Naive SE", "Design-based SE")
    vals <- c(d$naive_se_mean, d$design_se_mean)
    cols <- c("#b58900", "#268bd2")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = labs, y = vals,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        hoverinfo = "text", textposition = "none",
        text = paste0(labs, ": ", round(vals, 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Average SE (across simulations)"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_se_coverage <- plotly::renderPlotly({
    d <- surv_se_data(); req(d)
    labs <- c("Naive CI", "Design-based CI")
    vals <- c(d$naive_coverage, d$design_coverage)
    cols <- c("#b58900", "#268bd2")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = labs, y = vals,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        hoverinfo = "text", textposition = "none",
        text = paste0(labs, ": ", round(vals * 100, 1), "%"),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = -0.5, x1 = 1.5,
                           y0 = 0.95, y1 = 0.95,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = 1.5, y = 0.95, text = "95% target",
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = ""),
        yaxis = list(title = "Coverage Rate", tickformat = ".0%",
                     range = c(max(0, min(vals) - 0.1), 1.02)),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_se_summary <- renderUI({
    d <- surv_se_data(); req(d)
    ratio <- d$design_se_mean / d$naive_se_mean
    direction <- if (ratio > 1.05) "Design SE is <strong>larger</strong> than naive — ignoring the design underestimates uncertainty."
                 else if (ratio < 0.95) "Design SE is <strong>smaller</strong> than naive — the design is more efficient than SRS."
                 else "Design SE is approximately equal to naive SE."
    HTML(sprintf(
      '<div style="padding: 0.5rem;">
       <table class="table table-sm table-striped" style="font-size: 0.9rem; max-width: 550px;">
       <tr><td><strong>Design</strong></td><td>%s</td></tr>
       <tr><td><strong>Sample size</strong></td><td>%d</td></tr>
       <tr><td><strong>Mean naive SE</strong></td><td>%.4f</td></tr>
       <tr><td><strong>Mean design SE</strong></td><td>%.4f</td></tr>
       <tr><td><strong>SE ratio (design/naive)</strong></td><td>%.2f</td></tr>
       <tr><td><strong>Naive CI coverage</strong></td><td>%.1f%%</td></tr>
       <tr><td><strong>Design CI coverage</strong></td><td>%.1f%%</td></tr>
       </table>
       <p class="text-muted mt-2">%s</p></div>',
      d$design, d$n, d$naive_se_mean, d$design_se_mean, ratio,
      d$naive_coverage * 100, d$design_coverage * 100, direction
    ))
  })
  })
}
