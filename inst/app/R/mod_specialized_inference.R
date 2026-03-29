# Module: Specialized Inference (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
specialized_inference_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Specialized Inference",
  icon = icon("heart-pulse"),
  navset_card_underline(
    nav_panel(
      "Survival Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("surv_n"), "n per group", min = 20, max = 200, value = 50, step = 10),
      sliderInput(ns("surv_hr"), "Hazard ratio (Treatment / Control)",
                  min = 0.2, max = 3, value = 0.5, step = 0.1),
      sliderInput(ns("surv_censor"), "Censoring rate (%)", min = 0, max = 50,
                  value = 20, step = 5),
      actionButton(ns("surv_go"), "Simulate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Survival Analysis"),
      tags$p("Survival analysis models time-to-event data, where the outcome is the time
              until an event occurs (death, relapse, equipment failure, etc.). A defining
              feature is ", tags$em("censoring"), ": some subjects have not yet experienced
              the event by the end of the study. Ignoring censored observations (e.g.,
              dropping them or treating their censoring time as the event time) leads to
              biased estimates. Survival methods handle censoring properly."),
      tags$ul(
        tags$li(tags$strong("Kaplan-Meier (KM) curve:"), " A non-parametric estimate of the survival
                function S(t) = P(T > t). The curve is a step function that drops at each
                observed event time. The median survival time is where S(t) = 0.5."),
        tags$li(tags$strong("Hazard ratio (HR):"), " From the Cox proportional hazards model.
                HR < 1 means the treatment group has a lower instantaneous risk (longer survival);
                HR > 1 means higher risk. The Cox model assumes that the ratio of hazards is
                constant over time (the proportional hazards assumption)."),
        tags$li(tags$strong("Log-rank test:"), " A non-parametric test of whether survival curves
                differ between groups. It is most powerful when hazards are proportional;
                if curves cross, the Wilcoxon (Gehan-Breslow) test may be more sensitive.")
      ),
      tags$p("The Cox model can accommodate multiple covariates simultaneously, functioning
              as a regression model for survival data. It is semi-parametric: the baseline
              hazard function is left unspecified, and only the covariate effects (hazard
              ratios) are estimated. This flexibility is one reason it is so widely used
              in clinical research."),
      tags$p("Checking the proportional hazards assumption is essential. If the hazard ratio
              changes over time (crossing survival curves), the Cox model\u2019s summary HR
              averages over time periods with different effects, which may be misleading.
              Schoenfeld residuals and log-log plots are standard diagnostics. When proportional
              hazards is violated, stratified models, time-varying coefficients, or parametric
              alternatives (Weibull, accelerated failure time) may be more appropriate."),
      guide = tags$ol(
        tags$li("Set sample size, hazard ratio, and censoring rate."),
        tags$li("HR = 0.5 means treatment halves the hazard \u2014 strong benefit."),
        tags$li("Click 'Simulate' to generate data and see KM curves."),
        tags$li("Increase censoring to see how it affects the tail of the curves.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Kaplan-Meier Survival Curves"),
           plotlyOutput(ns("surv_km"), height = "420px")),
      layout_column_wrap(
        width = 1 / 2,
        card(card_header("Log-Rank Test"), tableOutput(ns("surv_logrank"))),
        card(card_header("Cox Regression"), tableOutput(ns("surv_cox")))
      )
    )
  )
    ),

    nav_panel(
      "Meta-Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("meta_k"), "Number of studies", min = 5, max = 30, value = 10, step = 1),
      sliderInput(ns("meta_true_d"), "True effect (Cohen's d)", min = 0, max = 1.5,
                  value = 0.3, step = 0.05),
      sliderInput(ns("meta_tau"), "Between-study SD (\u03c4)", min = 0, max = 0.5,
                  value = 0.1, step = 0.05),
      sliderInput(ns("meta_n_range"), "Study n range", min = 20, max = 200,
                  value = c(30, 100), step = 10),
      actionButton(ns("meta_go"), "Simulate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Meta-Analysis"),
      tags$p("Meta-analysis combines results from multiple studies to produce a more
              precise and generalisable estimate of an effect. It weights each study
              by its precision (inverse variance), so larger and more precise studies
              contribute more to the pooled estimate. The forest plot is the standard
              visual summary, showing each study\u2019s effect with its confidence interval
              and the overall pooled estimate."),
      tags$ul(
        tags$li(tags$strong("Fixed-effect model:"), " Assumes there is one true effect size underlying
                all studies; all variation between studies is attributed to sampling error.
                Appropriate when studies are functionally identical (same population, intervention,
                outcome measure)."),
        tags$li(tags$strong("Random-effects model:"), " Allows the true effect to vary across studies,
                with between-study variance \u03c4\u00b2. This is more realistic when studies
                differ in populations, methods, or contexts. The pooled estimate represents the
                ", tags$em("average"), " effect across a distribution of true effects."),
        tags$li(tags$strong("I\u00b2 statistic:"), " Quantifies the percentage of total variation that
                is due to heterogeneity rather than sampling error. I\u00b2 > 75% is considered
                high heterogeneity, warranting investigation of moderators (study-level variables
                that explain the variability).")
      ),
      tags$p("Meta-analysis is only as good as the studies it includes. Publication bias
              (studies with non-significant results being less likely to be published) can
              inflate the pooled estimate. Funnel plots and tests like Egger\u2019s regression
              can detect asymmetry suggestive of publication bias, though they have limited
              power with fewer than 10 studies."),
      tags$p("When conducting a meta-analysis, it is crucial to define clear inclusion
              criteria, conduct a systematic search, and assess study quality. A meta-analysis
              of biased studies will produce a biased pooled estimate with deceptive precision.
              Pre-registration of the meta-analytic protocol (e.g., on PROSPERO) helps prevent
              post-hoc decisions about which studies to include or exclude."),
      guide = tags$ol(
        tags$li("Set the true effect, number of studies, heterogeneity (\u03c4), and sample size range."),
        tags$li("Click 'Simulate' to generate study-level data."),
        tags$li("The forest plot shows each study's effect size with CI, plus the pooled estimate."),
        tags$li("Try \u03c4 = 0 (homogeneous) vs. \u03c4 = 0.3 (heterogeneous) to see I\u00b2 change.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Forest Plot"),
           plotlyOutput(ns("meta_forest"), height = "500px")),
      card(card_header("Summary"), tableOutput(ns("meta_summary")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

specialized_inference_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  surv_data <- reactiveVal(NULL)

  observeEvent(input$surv_go, {
    n <- input$surv_n; hr <- input$surv_hr; cens <- input$surv_censor / 100
    set.seed(sample.int(10000, 1))

    # Exponential survival times
    rate_ctrl <- 0.05
    rate_trt  <- rate_ctrl * hr
    t_ctrl <- rexp(n, rate_ctrl)
    t_trt  <- rexp(n, rate_trt)

    # Censoring times (uniform)
    max_time <- quantile(c(t_ctrl, t_trt), 0.95)
    cens_ctrl <- runif(n, 0, max_time / (cens + 0.01))
    cens_trt  <- runif(n, 0, max_time / (cens + 0.01))

    obs_ctrl <- pmin(t_ctrl, cens_ctrl)
    obs_trt  <- pmin(t_trt, cens_trt)
    event_ctrl <- as.integer(t_ctrl <= cens_ctrl)
    event_trt  <- as.integer(t_trt <= cens_trt)

    dat <- data.frame(
      time  = c(obs_ctrl, obs_trt),
      event = c(event_ctrl, event_trt),
      group = factor(rep(c("Control", "Treatment"), each = n))
    )
    surv_data(dat)
  })

  output$surv_km <- renderPlotly({
    dat <- surv_data()
    req(dat)

    sf <- survival::survfit(survival::Surv(time, event) ~ group, data = dat)
    sm <- summary(sf)
    km_df <- data.frame(
      time = sm$time, surv = sm$surv, group = sm$strata,
      lower = sm$lower, upper = sm$upper
    )
    km_df$group <- gsub("group=", "", km_df$group)

    cols <- c(Control = "#3182bd", Treatment = "#e31a1c")
    p <- plotly::plot_ly()
    for (g in c("Control", "Treatment")) {
      d <- km_df[km_df$group == g, ]
      # Step function: duplicate points
      n_pts <- nrow(d)
      if (n_pts > 1) {
        step_x <- c(0, rep(d$time, each = 2))
        step_y <- c(1, 1, rep(d$surv[-n_pts], each = 2), d$surv[n_pts], d$surv[n_pts])
        # Trim to equal length
        len <- min(length(step_x), length(step_y))
        step_x <- step_x[seq_len(len)]
        step_y <- step_y[seq_len(len)]
      } else {
        step_x <- c(0, d$time)
        step_y <- c(1, d$surv)
      }
      p <- p |> plotly::add_trace(
        x = step_x, y = step_y,
        type = "scatter", mode = "lines",
        line = list(color = cols[g], width = 2, shape = "hv"),
        name = g, hoverinfo = "text",
        text = paste0(g, "<br>Time = ", round(step_x, 2),
                       "<br>S(t) = ", round(step_y, 3))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "Time"),
      yaxis = list(title = "Survival Probability", range = c(0, 1.02)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$surv_logrank <- renderTable({
    dat <- surv_data(); req(dat)
    lr <- survival::survdiff(survival::Surv(time, event) ~ group, data = dat)
    data.frame(
      Statistic = c("Chi-squared", "df", "p-value"),
      Value = c(round(lr$chisq, 3), 1,
                format.pval(pchisq(lr$chisq, 1, lower.tail = FALSE), digits = 4))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$surv_cox <- renderTable({
    dat <- surv_data(); req(dat)
    fit <- survival::coxph(survival::Surv(time, event) ~ group, data = dat)
    s <- summary(fit)
    coefs <- s$coefficients
    data.frame(
      Term = rownames(coefs),
      HR = round(coefs[, "exp(coef)"], 3),
      `95% CI` = paste0("[", round(s$conf.int[, "lower .95"], 3), ", ",
                         round(s$conf.int[, "upper .95"], 3), "]"),
      `p value` = format.pval(coefs[, "Pr(>|z|)"], digits = 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  meta_data <- reactiveVal(NULL)

  observeEvent(input$meta_go, {
    k <- input$meta_k; true_d <- input$meta_true_d
    tau <- input$meta_tau; n_lo <- input$meta_n_range[1]; n_hi <- input$meta_n_range[2]
    set.seed(sample.int(10000, 1))

    ns <- round(runif(k, n_lo, n_hi))
    # True study-level effects
    theta_i <- rnorm(k, true_d, tau)
    # Observed effects
    se_i <- sqrt(2 / ns + theta_i^2 / (4 * ns))
    d_obs <- rnorm(k, theta_i, se_i)
    # Recalculate SE from observed
    se_obs <- sqrt(2 / ns + d_obs^2 / (4 * ns))

    studies <- data.frame(
      study = paste0("Study ", seq_len(k)),
      d = d_obs, se = se_obs, n = ns,
      lower = d_obs - 1.96 * se_obs,
      upper = d_obs + 1.96 * se_obs
    )

    # Random-effects (DerSimonian-Laird)
    w <- 1 / se_obs^2
    d_fe <- sum(w * d_obs) / sum(w)
    Q <- sum(w * (d_obs - d_fe)^2)
    C <- sum(w) - sum(w^2) / sum(w)
    tau2_hat <- max(0, (Q - (k - 1)) / C)
    w_re <- 1 / (se_obs^2 + tau2_hat)
    d_re <- sum(w_re * d_obs) / sum(w_re)
    se_re <- 1 / sqrt(sum(w_re))
    I2 <- max(0, (Q - (k - 1)) / Q) * 100

    meta_data(list(studies = studies, d_fe = d_fe, d_re = d_re, se_re = se_re,
                   tau2 = tau2_hat, Q = Q, I2 = I2, k = k))
  })

  output$meta_forest <- renderPlotly({
    res <- meta_data()
    req(res)
    s <- res$studies
    k <- res$k

    # Pooled estimate
    pool_lo <- res$d_re - 1.96 * res$se_re
    pool_hi <- res$d_re + 1.96 * res$se_re

    p <- plotly::plot_ly()
    for (i in seq_len(k)) {
      p <- p |> plotly::add_trace(
        x = c(s$lower[i], s$upper[i]), y = c(i, i),
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0(s$study[i], "<br>d = ", round(s$d[i], 3),
                       " [", round(s$lower[i], 3), ", ", round(s$upper[i], 3), "]",
                       "<br>n = ", s$n[i])
      )
    }
    # Study point estimates (sized by n)
    p <- p |>
      plotly::add_markers(
        x = s$d, y = seq_len(k),
        marker = list(color = "#238b45", size = sqrt(s$n) * 1.2,
                      symbol = "square"),
        showlegend = FALSE, hoverinfo = "skip"
      )

    # Pooled diamond
    diamond_y <- -0.5
    p <- p |>
      plotly::add_trace(
        x = c(pool_lo, res$d_re, pool_hi, res$d_re, pool_lo),
        y = c(diamond_y, diamond_y + 0.35, diamond_y, diamond_y - 0.35, diamond_y),
        type = "scatter", mode = "lines",
        fill = "toself", fillcolor = "rgba(227,26,28,0.4)",
        line = list(color = "#e31a1c", width = 1),
        name = "Pooled RE", hoverinfo = "text",
        text = paste0("RE pooled d = ", round(res$d_re, 3),
                       " [", round(pool_lo, 3), ", ", round(pool_hi, 3), "]")
      )

    # Null line
    p |> plotly::layout(
      shapes = list(list(
        type = "line", x0 = 0, x1 = 0, y0 = -1.5, y1 = k + 0.5,
        line = list(color = "grey60", width = 1, dash = "dash")
      )),
      xaxis = list(title = "Cohen's d"),
      yaxis = list(title = "", tickvals = seq_len(k),
                   ticktext = s$study, autorange = "reversed"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.1),
      margin = list(l = 80, t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$meta_summary <- renderTable({
    res <- meta_data(); req(res)
    data.frame(
      Statistic = c("Pooled d (RE)", "95% CI", "SE",
                     "\u03c4\u00b2 (between-study var.)", "Q statistic",
                     "I\u00b2 (%)", "k (studies)"),
      Value = c(round(res$d_re, 4),
                paste0("[", round(res$d_re - 1.96 * res$se_re, 3), ", ",
                       round(res$d_re + 1.96 * res$se_re, 3), "]"),
                round(res$se_re, 4),
                round(res$tau2, 4), round(res$Q, 3),
                round(res$I2, 1), res$k)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
