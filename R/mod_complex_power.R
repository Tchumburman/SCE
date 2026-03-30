# Module: Power for Complex Designs
# 4 tabs: Multilevel Power · Mediation Power · Interaction / Moderation Power · Longitudinal Power

# ── UI ────────────────────────────────────────────────────────────────────────
complex_power_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Power: Complex Designs",
  icon = icon("bolt"),
  navset_card_underline(

    # ── Tab 1: Multilevel Power ───────────────────────────────────────────────
    nav_panel(
      "Multilevel / Clustered",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$h6("Cluster design"),
          sliderInput(ns("cp_ml_n_clust"), "Number of clusters (schools / sites)", 5, 100, 30, 5),
          sliderInput(ns("cp_ml_n_per"), "Units per cluster", 5, 50, 20, 5),
          sliderInput(ns("cp_ml_icc"), "ICC (intraclass correlation)", 0, 0.5, 0.15, 0.01),
          sliderInput(ns("cp_ml_d"), "Effect size d (standardised)", 0.1, 1.2, 0.4, 0.05),
          sliderInput(ns("cp_ml_alpha"), "Alpha", 0.01, 0.1, 0.05, 0.01),
          actionButton(ns("cp_ml_go"), "Calculate Power", icon = icon("bolt"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
            "DEFF = 1 + (n\u2212 1)\u00d7ICC. Effective n = N/DEFF.")
        ),
        explanation_box(
          tags$strong("Power for Multilevel / Clustered Designs"),
          tags$p("When observations are clustered (students in schools, patients in clinics),
                  the effective sample size is reduced by the design effect:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "DEFF = 1 + (n \u2212 1) \u00d7 ICC\nn_eff = N / DEFF"),
          tags$p("For cluster-randomised trials (treatment assigned at cluster level),
                  power depends primarily on the number of clusters, not the number of
                  individuals within clusters. Adding more individuals per cluster has
                  rapidly diminishing returns once ICC > 0.1."),
          tags$p("The optimal allocation for fixed total cost:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "n_opt = \u221a[(1\u2212ICC)/ICC \u00d7 c_cluster/c_unit]"),
          guide = tags$ol(
            tags$li("Move ICC from 0 to 0.4. Notice how power drops rapidly."),
            tags$li("For high ICC, increasing clusters (not n per cluster) restores power."),
            tags$li("The DEFF curve shows power loss as a function of cluster size and ICC."),
            tags$li("Aim for at least 0.80 power.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 3,
            card(card_header("Power"), uiOutput(ns("cp_ml_power_gauge"))),
            card(card_header("Design Effect"), uiOutput(ns("cp_ml_deff"))),
            card(card_header("Effective n"), uiOutput(ns("cp_ml_neff")))
          ),
          card(full_screen = TRUE,
               card_header("Power vs. Number of Clusters (for varying ICC)"),
               plotlyOutput(ns("cp_ml_curve"), height = "300px"))
        )
      )
    ),

    # ── Tab 2: Mediation Power ────────────────────────────────────────────────
    nav_panel(
      "Mediation (Indirect Effect)",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("cp_med_a"), "Path a (X \u2192 M)", -1, 1, 0.4, 0.05),
          sliderInput(ns("cp_med_b"), "Path b (M \u2192 Y)", -1, 1, 0.4, 0.05),
          sliderInput(ns("cp_med_cp"), "Direct effect c' (X \u2192 Y)", -1, 1, 0.1, 0.05),
          sliderInput(ns("cp_med_n"), "Sample size n", 20, 500, 100, 10),
          sliderInput(ns("cp_med_alpha"), "Alpha", 0.01, 0.1, 0.05, 0.01),
          sliderInput(ns("cp_med_sims"), "Bootstrap iterations", 500, 5000, 1000, 500),
          actionButton(ns("cp_med_go"), "Simulate Power", icon = icon("play"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.82rem;",
            "Power = proportion of bootstrap CIs for a\u00d7b that exclude zero.")
        ),
        explanation_box(
          tags$strong("Power for Mediation Analysis"),
          tags$p("Statistical power for the indirect effect (a \u00d7 b) cannot be computed
                  analytically with standard formulas because the sampling distribution of a
                  product of two regression coefficients is non-normal (especially in small samples)."),
          tags$p("Two approaches:"),
          tags$ul(
            tags$li(tags$strong("Monte Carlo / parametric bootstrap"), " — draw a and b from
                    their sampling distributions many times. Power = proportion of simulations
                    where the CI for a\u00d7b excludes zero."),
            tags$li(tags$strong("Sobel test power"), " — analytic approximation using the
                    delta method SE for a\u00d7b. Accurate for large samples; overly conservative otherwise.")
          ),
          tags$p("Key finding: power for mediation is often surprisingly low. For small-to-moderate
                  path coefficients (a = b = 0.3), you typically need n > 200 for 80% power."),
          guide = tags$ol(
            tags$li("Set paths a and b. The indirect effect = a\u00d7b."),
            tags$li("Click 'Simulate Power'. Power is estimated from simulation."),
            tags$li("Adjust n to find the sample size that achieves 80% power."),
            tags$li("Notice how power drops dramatically when one path is small.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Power Estimate"), uiOutput(ns("cp_med_power"))),
            card(card_header("Indirect Effect Distribution"),
                 plotlyOutput(ns("cp_med_dist"), height = "260px"))
          ),
          card(full_screen = TRUE,
               card_header("Power vs. n (for varying path b)"),
               plotlyOutput(ns("cp_med_curve"), height = "280px"))
        )
      )
    ),

    # ── Tab 3: Interaction / Moderation ───────────────────────────────────────
    nav_panel(
      "Interaction / Moderation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("cp_int_d_main"), "Main effect d", 0.1, 1.5, 0.5, 0.05),
          sliderInput(ns("cp_int_d_int"), "Interaction effect d", 0, 1, 0.3, 0.05),
          sliderInput(ns("cp_int_n"), "n per cell", 10, 200, 50, 10),
          sliderInput(ns("cp_int_k"), "Number of groups (levels of moderator)", 2, 6, 2, 1),
          sliderInput(ns("cp_int_alpha"), "Alpha", 0.01, 0.1, 0.05, 0.01),
          radioButtons(ns("cp_int_design"), "Design",
            choices = c("Between-subjects", "Within-subjects"),
            selected = "Between-subjects", inline = TRUE)
        ),
        explanation_box(
          tags$strong("Power for Interaction Tests"),
          tags$p("Interaction effects (moderation) require substantially larger samples than
                  main effects of the same magnitude. For a factorial design, the interaction
                  effect is tested on the product of group membership — its variance is much
                  smaller than that of the main effect."),
          tags$p("Rule of thumb: to detect an interaction of size d, you need approximately
                  ", tags$strong("4\u00d7"), " the sample size needed for a main effect of the
                  same size (Gelman & Loken, 2014)."),
          tags$p("For continuous moderators (regression interaction), the effective sample size
                  for the product term x\u00d7z is further reduced by multicollinearity and the
                  variance of the moderator."),
          guide = tags$ol(
            tags$li("Set main effect and interaction effect sizes."),
            tags$li("Compare powers: the interaction has far less power for the same n."),
            tags$li("Within-subjects designs greatly boost power for interaction effects.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Power: Main Effect"),
                 uiOutput(ns("cp_int_power_main"))),
            card(card_header("Power: Interaction"),
                 uiOutput(ns("cp_int_power_int")))
          ),
          card(full_screen = TRUE,
               card_header("Power vs. n per Cell: Main vs. Interaction"),
               plotlyOutput(ns("cp_int_curve"), height = "300px"))
        )
      )
    ),

    # ── Tab 4: Longitudinal ───────────────────────────────────────────────────
    nav_panel(
      "Longitudinal",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("cp_long_n"), "Subjects n", 20, 300, 80, 10),
          sliderInput(ns("cp_long_t"), "Time points T", 2, 10, 4, 1),
          sliderInput(ns("cp_long_rho"), "Correlation across time (AR1 \u03c1)", 0, 0.9, 0.5, 0.05),
          sliderInput(ns("cp_long_d_slope"), "Effect: slope difference (d)", 0.1, 1.5, 0.4, 0.05),
          sliderInput(ns("cp_long_alpha"), "Alpha", 0.01, 0.1, 0.05, 0.01),
          radioButtons(ns("cp_long_design"), "Test",
            choices = c("Slope (growth curve)", "Pre-post change"),
            selected = "Slope (growth curve)", inline = TRUE)
        ),
        explanation_box(
          tags$strong("Power for Longitudinal Designs"),
          tags$p("Longitudinal designs offer substantial power advantages over cross-sectional
                  designs for detecting change over time, because each subject serves as their
                  own control (within-subject correlation reduces noise)."),
          tags$p("Power increases with:"),
          tags$ul(
            tags$li(tags$strong("More time points"), " (up to a point — diminishing returns)."),
            tags$li(tags$strong("Higher within-subject correlation"), " (more of the variance is
                    systematic)."),
            tags$li(tags$strong("Larger slope difference"), " between groups.")
          ),
          tags$p("For a two-group growth curve comparison (mixed-model slope test), the effective
                  variance of the slope estimate is approximately:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "Var(\u03b2\u0302) \u221d \u03c3\u00b2 / [n \u00d7 Var(time) \u00d7 (1\u2212\u03c1\u00b2)]"),
          tags$p("There is a fundamental trade-off between recruiting more subjects and
                  collecting more time points. For detecting a mean difference at a single
                  time point, doubling n has a direct effect on power. For detecting a
                  slope difference, adding time points also increases power, but with
                  diminishing returns once T is beyond 4\u20136 points (because the
                  variance of the time scores, Var(time), grows, but the additional
                  information per point decreases). Budget permitting, a moderate
                  number of subjects with adequate time points is usually more efficient
                  than many subjects with only 2\u20133 measurements."),
          tags$p("Attrition is a critical design consideration in longitudinal studies.
                  If 20% of participants drop out by the final wave, the effective sample
                  size for the slope estimate is reduced. Power calculations should be
                  inflated to account for expected dropout: if 80% retention is expected,
                  recruit n / 0.80 participants to achieve the target analysis n. For
                  mixed-model analyses under MAR, the impact of dropout on power is less
                  severe than under complete-case analysis because maximum likelihood uses
                  all available data, but attrition still reduces the precision of the
                  slope estimate, especially if early dropouts are more common in one arm."),
          guide = tags$ol(
            tags$li("Move \u03c1 from 0 to 0.8. Higher correlation = more power for slope tests."),
            tags$li("Adding time points beyond ~5 gives diminishing returns."),
            tags$li("Compare 'Slope (growth curve)' vs. 'Pre-post change' power.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Power"), uiOutput(ns("cp_long_power"))),
            card(card_header("Effective n vs. Cross-Sectional"), uiOutput(ns("cp_long_neff")))
          ),
          card(full_screen = TRUE,
               card_header("Power vs. n: Longitudinal vs. Cross-Sectional"),
               plotlyOutput(ns("cp_long_curve"), height = "300px"))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

complex_power_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Utility: power gauge UI ────────────────────────────────────────────────
  power_gauge <- function(pwr, col = NULL) {
    if (is.null(col)) {
      col <- if (pwr >= 0.8) "#859900" else if (pwr >= 0.6) "#b58900" else "#dc322f"
    }
    tags$div(class = "text-center mt-3",
      tags$h2(sprintf("%.1f%%", pwr * 100), style = paste0("color:", col, "; font-size: 2.5rem;")),
      tags$p(class = "text-muted",
             if (pwr >= 0.8) "\u2705 Adequate power (\u2265 80%)"
             else if (pwr >= 0.6) "\u26a0\ufe0f Moderate power (60\u201380%)"
             else "\u274c Insufficient power (< 60%)")
    )
  }

  # ── Tab 1: Multilevel Power ────────────────────────────────────────────────
  cp_ml_reactive <- reactive({
    J    <- input$cp_ml_n_clust
    n    <- input$cp_ml_n_per
    icc  <- input$cp_ml_icc
    d    <- input$cp_ml_d
    alph <- input$cp_ml_alpha

    N    <- J * n
    deff <- 1 + (n - 1) * icc
    n_eff <- N / deff

    # For cluster-randomised trial (half treated, half control)
    # Use effective SE formula
    se <- sqrt(2 * deff / (J * n))
    z_crit <- qnorm(1 - alph / 2)
    pwr  <- pnorm(d / se - z_crit) + pnorm(-d / se - z_crit)

    list(J = J, n = n, N = N, deff = deff, n_eff = n_eff, pwr = pwr, d = d)
  })

  observeEvent(input$cp_ml_go, {
    withProgress(message = "Simulating multilevel power...", value = 0.1, {
    output$cp_ml_power_gauge <- renderUI(power_gauge(cp_ml_reactive()$pwr))
    output$cp_ml_deff <- renderUI({
      d <- cp_ml_reactive()$deff
      tags$div(class = "text-center mt-3",
        tags$h2(sprintf("%.2f", d), style = "font-size: 2rem; color: #268bd2;"),
        tags$p(class = "text-muted", "Design effect (DEFF)"),
        tags$p(style = "font-size: 0.82rem;",
          paste0("Variance inflation factor due to clustering."))
      )
    })
    output$cp_ml_neff <- renderUI({
      r <- cp_ml_reactive()
      tags$div(class = "text-center mt-3",
        tags$h2(sprintf("%.0f", r$n_eff), style = "font-size: 2rem; color: #2aa198;"),
        tags$p(class = "text-muted", "Effective sample size"),
        tags$p(style = "font-size: 0.82rem;",
          sprintf("Total N = %d, DEFF = %.2f", r$N, r$deff))
      )
    })
    })
  })

  output$cp_ml_curve <- renderPlotly({
    d    <- input$cp_ml_d
    n    <- input$cp_ml_n_per
    alph <- input$cp_ml_alpha
    iccs <- c(0, 0.05, 0.10, 0.20, 0.30)
    j_seq <- seq(5, 100, 5)
    pal   <- c("#268bd2","#2aa198","#b58900","#cb4b16","#dc322f")
    p <- plot_ly()
    for (i in seq_along(iccs)) {
      icc <- iccs[i]
      deff <- 1 + (n - 1) * icc
      se_j <- sqrt(2 * deff / (j_seq * n))
      z_c  <- qnorm(1 - alph / 2)
      pwr_j <- pnorm(d / se_j - z_c) + pnorm(-d / se_j - z_c)
      p <- p |> add_lines(x = j_seq, y = pwr_j, name = paste0("ICC=", icc),
                           line = list(color = pal[i], width = 2))
    }
    p |>
      add_lines(x = c(5, 100), y = c(0.8, 0.8),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Number of clusters J"),
             yaxis = list(title = "Power", range = c(0, 1)),
             legend = list(orientation = "h"))
  })

  # ── Tab 2: Mediation Power ─────────────────────────────────────────────────
  cp_med_sim <- reactiveVal(NULL)
  observeEvent(input$cp_med_go, {
    withProgress(message = "Simulating mediation power...", value = 0.1, {
    cp_med_sim({
    a    <- input$cp_med_a; b <- input$cp_med_b
    cp   <- input$cp_med_cp; n <- input$cp_med_n
    alph <- input$cp_med_alpha; sims <- input$cp_med_sims

    set.seed(sample(9999, 1))
    # Simulate indirect effects using Monte Carlo
    ab_dist <- rnorm(sims, a, sqrt((1 - a^2) / n)) *
               rnorm(sims, b, sqrt((1 - b^2) / n))

    # CI = percentile bootstrap approximation
    ci  <- quantile(ab_dist, c(alph / 2, 1 - alph / 2))
    pwr <- mean(ab_dist > 0) > 0.975 || mean(ab_dist < 0) > 0.975
    # Better: proportion of samples where CI excludes zero
    n_reps <- 200
    count  <- 0
    for (s in seq_len(n_reps)) {
      x <- rnorm(n); m <- a * x + rnorm(n); y <- b * m + cp * x + rnorm(n)
      # Bootstrap CI for a*b
      ab_boot <- replicate(200, {
        idx <- sample(n, replace = TRUE)
        coef(lm(m[idx] ~ x[idx]))["x[idx]"] *
        coef(lm(y[idx] ~ m[idx] + x[idx]))["m[idx]"]
      })
      ci_b <- quantile(ab_boot, c(alph/2, 1-alph/2))
      if (ci_b[1] > 0 || ci_b[2] < 0) count <- count + 1
    }
    pwr_sim <- count / n_reps

    # Sobel SE
    se_a <- sqrt((1 - a^2) / (n - 2))
    se_b <- sqrt((1 - b^2) / (n - 2))
    se_ab_sobel <- sqrt(b^2 * se_a^2 + a^2 * se_b^2)
    pwr_sobel <- pnorm(abs(a * b) / se_ab_sobel - qnorm(1 - alph/2))

    list(ab_dist = ab_dist, a = a, b = b, pwr_sim = pwr_sim,
         pwr_sobel = pwr_sobel, ci = ci, true_ab = a * b)
    })
    })
  })

  output$cp_med_power <- renderUI({
    req(cp_med_sim())
    r <- cp_med_sim()
    tags$div(
      power_gauge(r$pwr_sim),
      tags$p(class = "text-muted text-center", style = "font-size: 0.85rem;",
        sprintf("Indirect effect = %.3f | Sobel power = %.1f%%",
                r$true_ab, r$pwr_sobel * 100))
    )
  })

  output$cp_med_dist <- renderPlotly({
    req(cp_med_sim())
    r <- cp_med_sim()
    plot_ly(x = r$ab_dist, type = "histogram",
            histnorm = "probability density", nbinsx = 30,
            marker = list(color = "#268bd2")) |>
      add_lines(x = c(r$ci[1], r$ci[1]), y = c(0, 2),
                line = list(color = "#dc322f", dash = "dash"), showlegend = FALSE) |>
      add_lines(x = c(r$ci[2], r$ci[2]), y = c(0, 2),
                line = list(color = "#dc322f", dash = "dash"), showlegend = FALSE) |>
      add_lines(x = c(0, 0), y = c(0, 3),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Indirect effect a\u00d7b"),
             yaxis = list(title = "Density"))
  })

  output$cp_med_curve <- renderPlotly({
    a <- input$cp_med_a; alph <- input$cp_med_alpha
    n_seq <- seq(20, 500, 20)
    b_vals <- c(0.2, 0.3, 0.4, 0.5)
    pal <- c("#268bd2","#2aa198","#b58900","#dc322f")
    p <- plot_ly()
    for (j in seq_along(b_vals)) {
      bv <- b_vals[j]
      pwr_v <- sapply(n_seq, function(nn) {
        se_a <- sqrt((1 - a^2) / (nn - 2))
        se_b <- sqrt((1 - bv^2) / (nn - 2))
        se_ab <- sqrt(bv^2 * se_a^2 + a^2 * se_b^2)
        pnorm(abs(a * bv) / se_ab - qnorm(1 - alph/2))
      })
      p <- p |> add_lines(x = n_seq, y = pwr_v, name = paste0("b=", bv),
                           line = list(color = pal[j], width = 2))
    }
    p |>
      add_lines(x = c(20, 500), y = c(0.8, 0.8),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Sample size n"),
             yaxis = list(title = "Power (Sobel approx.)", range = c(0, 1)),
             legend = list(orientation = "h"))
  })

  # ── Tab 3: Interaction Power ───────────────────────────────────────────────
  output$cp_int_power_main <- renderUI({
    n_cell <- input$cp_int_n; d <- input$cp_int_d_main
    k <- input$cp_int_k; alph <- input$cp_int_alpha
    ws <- input$cp_int_design == "Within-subjects"
    n_total <- n_cell * k * 2
    se <- if (ws) sqrt(2 / n_total) else sqrt(4 / n_total)
    pwr <- pnorm(d / se - qnorm(1 - alph/2))
    power_gauge(pwr)
  })

  output$cp_int_power_int <- renderUI({
    n_cell <- input$cp_int_n; d <- input$cp_int_d_int
    k <- input$cp_int_k; alph <- input$cp_int_alpha
    ws <- input$cp_int_design == "Within-subjects"
    n_total <- n_cell * k * 2
    # Interaction has roughly 1/k the main effect variance
    se <- if (ws) sqrt(2 / (n_total / k)) else sqrt(4 / (n_total / k))
    pwr <- pnorm(d / se - qnorm(1 - alph/2))
    power_gauge(pwr)
  })

  output$cp_int_curve <- renderPlotly({
    d_main <- input$cp_int_d_main; d_int <- input$cp_int_d_int
    k <- input$cp_int_k; alph <- input$cp_int_alpha
    ws <- input$cp_int_design == "Within-subjects"
    n_seq <- seq(10, 200, 10)
    pwr_main <- sapply(n_seq, function(nc) {
      n_total <- nc * k * 2
      se <- if (ws) sqrt(2/n_total) else sqrt(4/n_total)
      pnorm(d_main/se - qnorm(1-alph/2))
    })
    pwr_int <- sapply(n_seq, function(nc) {
      n_total <- nc * k * 2
      se <- if (ws) sqrt(2/(n_total/k)) else sqrt(4/(n_total/k))
      pnorm(d_int/se - qnorm(1-alph/2))
    })
    plot_ly() |>
      add_lines(x = n_seq, y = pwr_main, name = paste0("Main effect (d=", d_main, ")"),
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = n_seq, y = pwr_int, name = paste0("Interaction (d=", d_int, ")"),
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      add_lines(x = c(10, 200), y = c(0.8, 0.8),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "n per cell"),
             yaxis = list(title = "Power", range = c(0, 1)),
             legend = list(orientation = "h"))
  })

  # ── Tab 4: Longitudinal Power ──────────────────────────────────────────────
  cp_long_reactive <- reactive({
    n    <- input$cp_long_n; T <- input$cp_long_t
    rho  <- input$cp_long_rho; d <- input$cp_long_d_slope
    alph <- input$cp_long_alpha; des <- input$cp_long_design

    times <- seq(0, 1, length.out = T)
    var_time <- var(times)

    # AR1 correlation matrix
    R_ar1 <- outer(seq_len(T), seq_len(T), function(i,j) rho^abs(i-j))
    V_slope <- 1 / (n * var_time * (T - 1) * (1 - rho^2) + n * var_time)
    se_long <- sqrt(V_slope * 2 / n)  # two groups

    # Cross-sectional equivalent
    se_cs <- sqrt(2 / n)

    z_c  <- qnorm(1 - alph/2)
    if (des == "Pre-post change") {
      se_pp <- sqrt(2 * (1 - rho) / n)
      pwr <- pnorm(d / se_pp - z_c)
    } else {
      pwr <- pnorm(d / se_long - z_c)
    }
    pwr_cs <- pnorm(d / se_cs - z_c)

    list(pwr = pwr, pwr_cs = pwr_cs, n = n, T = T, rho = rho)
  })

  output$cp_long_power <- renderUI(power_gauge(cp_long_reactive()$pwr))

  output$cp_long_neff <- renderUI({
    r <- cp_long_reactive()
    ratio <- r$pwr / max(r$pwr_cs, 0.001)
    tags$div(class = "text-center mt-3",
      tags$h2(sprintf("%.1f\u00d7", ratio), style = "font-size: 2rem; color: #2aa198;"),
      tags$p(class = "text-muted", "Power boost vs. cross-sectional"),
      tags$p(style = "font-size: 0.82rem;",
        sprintf("Long. power: %.1f%% | CS power: %.1f%%",
                r$pwr * 100, r$pwr_cs * 100))
    )
  })

  output$cp_long_curve <- renderPlotly({
    d    <- input$cp_long_d_slope; T <- input$cp_long_t
    rho  <- input$cp_long_rho; alph <- input$cp_long_alpha
    des  <- input$cp_long_design
    n_seq <- seq(10, 300, 10)

    pwr_long <- sapply(n_seq, function(nn) {
      times <- seq(0, 1, length.out = T)
      vt <- var(times)
      V <- 1 / (nn * vt * (T-1) * (1-rho^2) + nn * vt)
      se <- if (des == "Pre-post change") sqrt(2*(1-rho)/nn) else sqrt(V * 2/nn)
      pnorm(d/se - qnorm(1-alph/2))
    })
    pwr_cs <- sapply(n_seq, function(nn) {
      pnorm(d/sqrt(2/nn) - qnorm(1-alph/2))
    })

    plot_ly() |>
      add_lines(x = n_seq, y = pwr_long, name = "Longitudinal",
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = n_seq, y = pwr_cs, name = "Cross-sectional",
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      add_lines(x = c(10, 300), y = c(0.8, 0.8),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Sample size n"),
             yaxis = list(title = "Power", range = c(0, 1)),
             legend = list(orientation = "h"))
  })
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Power: Complex Designs", list(cp_med_sim))
  })
}
