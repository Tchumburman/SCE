# Module: Statistical Phenomena (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
phenomena_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Statistical Phenomena",
  icon = icon("arrows-split-up-and-left"),
  navset_card_underline(
    nav_panel(
      "Simpson's Paradox",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("simp_scenario"), "Scenario",
        choices = c("Treatment efficacy" = "treatment",
                    "Admission bias" = "admission",
                    "Custom (continuous)" = "custom"),
        selected = "treatment"
      ),
      conditionalPanel(ns = ns, "input.simp_scenario == 'custom'",
        sliderInput(ns("simp_n"), "n per subgroup", min = 30, max = 200, value = 80, step = 10),
        sliderInput(ns("simp_n_groups"), "Number of subgroups", min = 2, max = 5, value = 3, step = 1),
        sliderInput(ns("simp_within_slope"), "Within-group slope", min = -2, max = 2, value = -0.5, step = 0.1),
        sliderInput(ns("simp_between_shift"), "Between-group shift", min = 0.5, max = 3, value = 1.5, step = 0.1)
      ),
      checkboxInput(ns("simp_show_groups"), "Show subgroups", value = FALSE),
      actionButton(ns("simp_gen"), "Generate data", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Simpson's Paradox"),
      tags$p("Simpson's paradox occurs when a trend that appears in aggregate data
              reverses (or disappears) when the data is split by a confounding variable.
              It's a powerful reminder that correlation and causation can diverge when
              lurking variables are ignored."),
      tags$p("Simpson\u2019s paradox is not a mere curiosity \u2014 it has real consequences
              in policy and medicine. A famous example: a treatment may appear inferior
              overall but be superior within every subgroup, because the treatment is
              disproportionately given to patients in the more severe (harder to treat)
              subgroup. The resolution requires understanding the causal structure: is the
              grouping variable a confounder that should be controlled for, or a mediator
              that should not?"),
      tags$p("The paradox illustrates why exploratory data analysis should always examine
              relationships within meaningful subgroups, and why aggregate statistics can
              be deeply misleading when groups differ in composition."),
      guide = tags$ol(
        tags$li("Start with 'Show subgroups' off \u2014 observe the overall trend."),
        tags$li("Toggle 'Show subgroups' on \u2014 see the trend reverse within each group."),
        tags$li("The treatment scenario: a treatment looks worse overall, but is better within each severity group."),
        tags$li("The admission scenario: a department looks biased overall, but is actually fair within each department.")
      )
    ),

    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("The Paradox"),
           plotlyOutput(ns("simp_plot"), height = "450px")),
      card(card_header("Summary Statistics"), tableOutput(ns("simp_table")))
    )
  )
    ),

    nav_panel(
      "Regression to the Mean",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("rtm_n"), "Number of subjects", min = 50, max = 500,
                  value = 200, step = 50),
      sliderInput(ns("rtm_r"), "Test-retest reliability (r)", min = 0.1, max = 0.99,
                  value = 0.6, step = 0.05),
      sliderInput(ns("rtm_cutoff"), "Selection cutoff (percentile)",
                  min = 75, max = 99, value = 90, step = 5),
      actionButton(ns("rtm_go"), "Simulate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Regression to the Mean"),
      tags$p("When subjects are selected because of extreme scores, their scores
              tend to be less extreme on retesting \u2014 even without any treatment.
              This is regression to the mean, and it arises whenever measurement
              includes random error."),
      tags$p("A high reliability (r close to 1) means less regression to the mean.
              Low reliability means extreme scores are largely due to luck, so
              retests will regress strongly toward the mean."),
      tags$p("Regression to the mean is a statistical inevitability whenever selection is based
              on an imperfectly measured variable. Extreme scores on a first measurement tend
              to be closer to the mean on a second measurement, simply because the extreme
              result was partly due to random error that is unlikely to repeat."),
      tags$p("This has major implications for evaluating interventions: if participants are
              selected because they scored extremely (e.g., the worst-performing students),
              some \u201cimprovement\u201d will occur without any intervention at all. A control
              group is essential to distinguish genuine treatment effects from regression to
              the mean."),
      guide = tags$ol(
        tags$li("Set sample size, reliability, and a selection cutoff."),
        tags$li("Click 'Simulate' to generate test-retest data."),
        tags$li("Subjects above the cutoff on Test 1 (red points) tend to score lower on Test 2."),
        tags$li("Lower the reliability to see stronger regression to the mean."),
        tags$li("This is why 'improvement' after selecting extreme cases may be an artifact, not a real treatment effect.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Test 1 vs Test 2"),
           plotlyOutput(ns("rtm_scatter"), height = "420px")),
      card(card_header("Selected Group Summary"), tableOutput(ns("rtm_table")))
    )
  )
    ),

    nav_panel(
      "Causal Inference",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("ps_n"), "Total sample size", min = 200, max = 2000,
                  value = 500, step = 100),
      sliderInput(ns("ps_confound"), "Confounding strength", min = 0, max = 2,
                  value = 1, step = 0.1),
      sliderInput(ns("ps_ate"), "True treatment effect (ATE)", min = 0, max = 3,
                  value = 1, step = 0.1),
      actionButton(ns("ps_go"), "Simulate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Propensity Score Matching & Causal Inference"),
      tags$p("In observational studies, treatment assignment is not random.
              Confounders that affect both treatment and outcome can bias the
              estimated treatment effect."),
      tags$p("The propensity score P(Treatment | X) summarizes all covariates
              into a single number. Matching treated and control subjects with
              similar propensity scores mimics randomization, reducing confounding bias."),
      tags$p("Propensity score methods attempt to approximate the conditions of a randomised
              experiment using observational data. The propensity score is the predicted
              probability of receiving treatment given observed covariates. Matching,
              stratifying, or weighting by propensity scores can balance the covariate
              distributions between treated and control groups, reducing confounding bias."),
      tags$p("A critical limitation: propensity scores can only adjust for ", tags$em("observed"),
              " confounders. Unmeasured confounders remain a threat to causal inference.
              Sensitivity analyses (e.g., Rosenbaum bounds) assess how robust conclusions
              are to potential unmeasured confounding. Propensity score methods are not a
              substitute for randomisation but can strengthen causal claims from observational
              studies when combined with domain knowledge and sensitivity analysis."),
      guide = tags$ol(
        tags$li("Set confounding strength and true treatment effect."),
        tags$li("Click 'Simulate' to generate observational data."),
        tags$li("Compare the naive estimate (ignoring confounders), regression-adjusted estimate, and propensity-score matched estimate."),
        tags$li("Stronger confounding \u2192 bigger gap between naive and adjusted estimates.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Propensity Score Distribution"),
           plotlyOutput(ns("ps_dist"), height = "350px")),
      card(card_header("Treatment Effect Estimates"), tableOutput(ns("ps_table")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

phenomena_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  sim_data <- reactiveVal(NULL)

  observeEvent(input$simp_gen, {
    set.seed(sample.int(10000, 1))
    scn <- input$simp_scenario

    if (scn == "treatment") {
      n <- 300
      severity <- sample(c("Mild", "Moderate", "Severe"), n, replace = TRUE,
                         prob = c(0.4, 0.35, 0.25))
      p_treat <- ifelse(severity == "Mild", 0.3,
                        ifelse(severity == "Moderate", 0.5, 0.8))
      treatment <- rbinom(n, 1, p_treat)
      base <- ifelse(severity == "Mild", 80,
                     ifelse(severity == "Moderate", 55, 30))
      outcome <- base + treatment * 15 + rnorm(n, 0, 8)

      df <- data.frame(
        x = factor(ifelse(treatment == 1, "Treatment", "Control")),
        y = outcome,
        group = severity
      )
      sim_data(list(df = df, type = "categorical"))

    } else if (scn == "admission") {
      depts <- c("Engineering", "Humanities", "Science")
      df_list <- list(
        data.frame(
          gender = c(rep("Male", 40), rep("Female", 120)),
          dept = "Engineering",
          admitted = c(rbinom(40, 1, 0.30), rbinom(120, 1, 0.33))
        ),
        data.frame(
          gender = c(rep("Male", 100), rep("Female", 30)),
          dept = "Humanities",
          admitted = c(rbinom(100, 1, 0.65), rbinom(30, 1, 0.68))
        ),
        data.frame(
          gender = c(rep("Male", 60), rep("Female", 50)),
          dept = "Science",
          admitted = c(rbinom(60, 1, 0.50), rbinom(50, 1, 0.52))
        )
      )
      df <- do.call(rbind, df_list)
      df$x <- df$gender
      df$y <- df$admitted
      df$group <- df$dept
      sim_data(list(df = df, type = "admission"))

    } else {
      k <- input$simp_n_groups
      n <- input$simp_n
      within_slope <- input$simp_within_slope
      between <- input$simp_between_shift

      df_list <- lapply(seq_len(k), function(g) {
        cx <- (g - 1) * between
        cy <- (g - 1) * between * abs(within_slope) * 1.5
        x <- rnorm(n, cx, 0.8)
        y <- cy + within_slope * (x - cx) + rnorm(n, 0, 0.5)
        data.frame(x = x, y = y, group = paste0("Group ", g))
      })
      df <- do.call(rbind, df_list)
      sim_data(list(df = df, type = "continuous"))
    }
  })

  output$simp_plot <- renderPlotly({
    req(sim_data())
    r <- sim_data()
    df <- r$df
    show_groups <- input$simp_show_groups

    if (r$type == "continuous") {
      # --- Continuous scatter ---
      if (show_groups) {
        groups <- unique(df$group)
        cols <- RColorBrewer::brewer.pal(max(3, length(groups)), "Set1")[seq_along(groups)]

        p <- plotly::plot_ly()
        for (i in seq_along(groups)) {
          sub <- df[df$group == groups[i], ]
          hover_txt <- paste0(groups[i],
                              "<br>x = ", round(sub$x, 3),
                              "<br>y = ", round(sub$y, 3))
          p <- p |>
            plotly::add_markers(
              x = sub$x, y = sub$y,
              marker = list(color = cols[i], size = 5, opacity = 0.5,
                            line = list(width = 0)),
              hoverinfo = "text", text = hover_txt,
              name = groups[i], showlegend = TRUE
            )
          # Within-group fit line
          fit <- lm(y ~ x, data = sub)
          xr <- range(sub$x)
          x_line <- seq(xr[1], xr[2], length.out = 50)
          y_line <- predict(fit, newdata = data.frame(x = x_line))
          p <- p |>
            plotly::add_trace(
              x = x_line, y = y_line,
              type = "scatter", mode = "lines",
              line = list(color = cols[i], width = 2),
              hoverinfo = "none", showlegend = FALSE
            )
        }
        # Overall fit (dashed)
        fit_all <- lm(y ~ x, data = df)
        xr <- range(df$x)
        x_line <- seq(xr[1], xr[2], length.out = 50)
        y_line <- predict(fit_all, newdata = data.frame(x = x_line))
        p <- p |>
          plotly::add_trace(
            x = x_line, y = y_line,
            type = "scatter", mode = "lines",
            line = list(color = "black", width = 2.5, dash = "dash"),
            hoverinfo = "none", name = "Overall", showlegend = TRUE
          )

        p |> plotly::layout(
          xaxis = list(title = "X"), yaxis = list(title = "Y"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = "Within each group: opposite trend!",
                 showarrow = FALSE, font = list(size = 13))
          ),
          legend = list(orientation = "h", x = 0.5, xanchor = "center",
                        y = -0.12, yanchor = "top"),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

      } else {
        hover_txt <- paste0("x = ", round(df$x, 3), "<br>y = ", round(df$y, 3))
        fit_all <- lm(y ~ x, data = df)
        xr <- range(df$x)
        x_line <- seq(xr[1], xr[2], length.out = 50)
        y_line <- predict(fit_all, newdata = data.frame(x = x_line))

        plotly::plot_ly() |>
          plotly::add_markers(
            x = df$x, y = df$y,
            marker = list(color = "#238b45", size = 5, opacity = 0.4,
                          line = list(width = 0)),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE
          ) |>
          plotly::add_trace(
            x = x_line, y = y_line,
            type = "scatter", mode = "lines",
            line = list(color = "#00441b", width = 2.5),
            hoverinfo = "none", showlegend = FALSE
          ) |>
          plotly::layout(
            xaxis = list(title = "X"), yaxis = list(title = "Y"),
            annotations = list(
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = "Overall trend",
                   showarrow = FALSE, font = list(size = 13))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)
      }

    } else if (r$type == "categorical") {
      # --- Treatment bar chart ---
      if (show_groups) {
        agg <- aggregate(y ~ x + group, data = df, FUN = mean)
        groups <- unique(agg$group)
        fill_map <- c(Control = "#3182bd", Treatment = "#e31a1c")

        p <- plotly::plot_ly()
        for (trt in c("Control", "Treatment")) {
          sub <- agg[agg$x == trt, ]
          hover_txt <- paste0(trt, " \u2014 ", sub$group,
                              "<br>Mean outcome: ", round(sub$y, 1))
          p <- p |>
            plotly::add_bars(textposition = "none",
              x = sub$group, y = sub$y,
              marker = list(color = fill_map[trt], opacity = 0.7),
              hoverinfo = "text", text = hover_txt,
              name = trt
            )
        }
        p |> plotly::layout(
          barmode = "group",
          xaxis = list(title = ""),
          yaxis = list(title = "Mean Outcome"),
          legend = list(orientation = "h", x = 0.5, xanchor = "center",
                        y = -0.12, yanchor = "top"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = "Within each severity group: treatment helps!",
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

      } else {
        agg <- aggregate(y ~ x, data = df, FUN = mean)
        fill_map <- c(Control = "#3182bd", Treatment = "#e31a1c")
        hover_txt <- paste0(agg$x, "<br>Mean outcome: ", round(agg$y, 1))

        plotly::plot_ly() |>
          plotly::add_bars(textposition = "none",
            x = agg$x, y = agg$y,
            marker = list(color = fill_map[agg$x], opacity = 0.7),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE, width = 0.5
          ) |>
          plotly::layout(
            xaxis = list(title = ""),
            yaxis = list(title = "Mean Outcome"),
            annotations = list(
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = "Overall: treatment appears to hurt!",
                   showarrow = FALSE, font = list(size = 13))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)
      }

    } else {
      # --- Admission bar chart ---
      if (show_groups) {
        agg <- aggregate(admitted ~ gender + dept, data = df, FUN = mean)
        fill_map <- c(Male = "#3182bd", Female = "#e31a1c")

        p <- plotly::plot_ly()
        for (g in c("Male", "Female")) {
          sub <- agg[agg$gender == g, ]
          hover_txt <- paste0(g, " \u2014 ", sub$dept,
                              "<br>Admission rate: ", round(sub$admitted * 100, 1), "%")
          p <- p |>
            plotly::add_bars(textposition = "none",
              x = sub$dept, y = sub$admitted,
              marker = list(color = fill_map[g], opacity = 0.7),
              hoverinfo = "text", text = hover_txt,
              name = g
            )
        }
        p |> plotly::layout(
          barmode = "group",
          xaxis = list(title = ""),
          yaxis = list(title = "Admission Rate", tickformat = ".0%"),
          legend = list(orientation = "h", x = 0.5, xanchor = "center",
                        y = -0.12, yanchor = "top"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = "Within each department: no bias (or slight female advantage)!",
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)

      } else {
        agg <- aggregate(admitted ~ gender, data = df, FUN = mean)
        fill_map <- c(Male = "#3182bd", Female = "#e31a1c")
        hover_txt <- paste0(agg$gender,
                            "<br>Admission rate: ", round(agg$admitted * 100, 1), "%")

        plotly::plot_ly() |>
          plotly::add_bars(textposition = "none",
            x = agg$gender, y = agg$admitted,
            marker = list(color = fill_map[agg$gender], opacity = 0.7),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE, width = 0.5
          ) |>
          plotly::layout(
            xaxis = list(title = ""),
            yaxis = list(title = "Admission Rate", tickformat = ".0%"),
            annotations = list(
              list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                   text = "Overall: looks like gender bias!",
                   showarrow = FALSE, font = list(size = 13))
            ),
            margin = list(t = 40)
          ) |> plotly::config(displayModeBar = FALSE)
      }
    }
  })

  output$simp_table <- renderTable({
    req(sim_data())
    r <- sim_data()
    df <- r$df

    if (r$type == "continuous") {
      overall <- round(coef(lm(y ~ x, data = df))[2], 3)
      slopes <- sapply(split(df, df$group), function(sub) round(coef(lm(y ~ x, data = sub))[2], 3))
      data.frame(
        Group = c("Overall", names(slopes)),
        Slope = c(overall, unname(slopes))
      )
    } else if (r$type == "categorical") {
      overall <- aggregate(y ~ x, data = df, FUN = mean)
      names(overall) <- c("Group", "Mean_Outcome")
      by_sev <- aggregate(y ~ x + group, data = df, FUN = mean)
      names(by_sev) <- c("Treatment", "Severity", "Mean_Outcome")
      overall$Severity <- "Overall"
      names(overall) <- c("Treatment", "Mean_Outcome", "Severity")
      combined <- rbind(
        data.frame(Severity = overall$Severity, Treatment = overall$Treatment,
                   Mean_Outcome = round(overall$Mean_Outcome, 1)),
        data.frame(Severity = by_sev$Severity, Treatment = by_sev$Treatment,
                   Mean_Outcome = round(by_sev$Mean_Outcome, 1))
      )
      combined
    } else {
      overall <- aggregate(admitted ~ gender, data = df, FUN = mean)
      by_dept <- aggregate(admitted ~ gender + dept, data = df, FUN = mean)
      data.frame(
        Department = c(rep("Overall", 2), by_dept$dept),
        Gender = c(overall$gender, by_dept$gender),
        `Admission Rate` = round(c(overall$admitted, by_dept$admitted) * 100, 1),
        check.names = FALSE
      )
    }
  }, striped = TRUE, hover = TRUE, bordered = TRUE)

  rtm_data <- reactiveVal(NULL)

  observeEvent(input$rtm_go, {
    n <- input$rtm_n; r <- input$rtm_r
    cutoff_pct <- input$rtm_cutoff / 100
    set.seed(sample.int(10000, 1))

    # True ability + error
    true_ability <- rnorm(n, 100, 15)
    error_sd <- 15 * sqrt((1 - r) / r)
    test1 <- true_ability + rnorm(n, 0, error_sd)
    test2 <- true_ability + rnorm(n, 0, error_sd)

    cutoff_val <- quantile(test1, cutoff_pct)
    selected <- test1 >= cutoff_val

    dat <- data.frame(test1 = test1, test2 = test2, selected = selected)
    rtm_data(list(dat = dat, cutoff = cutoff_val))
  })

  output$rtm_scatter <- renderPlotly({
    res <- rtm_data()
    req(res)
    dat <- res$dat
    unsel <- dat[!dat$selected, ]
    sel   <- dat[dat$selected, ]
    rng <- range(c(dat$test1, dat$test2))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = unsel$test1, y = unsel$test2,
        marker = list(color = "rgba(150,150,150,0.3)", size = 4),
        name = "Not selected", hoverinfo = "text",
        text = paste0("T1 = ", round(unsel$test1, 1), "<br>T2 = ", round(unsel$test2, 1))
      ) |>
      plotly::add_markers(
        x = sel$test1, y = sel$test2,
        marker = list(color = "#e31a1c", size = 6, opacity = 0.6),
        name = "Selected (extreme)", hoverinfo = "text",
        text = paste0("T1 = ", round(sel$test1, 1), "<br>T2 = ", round(sel$test2, 1))
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = rng[1], x1 = rng[2],
               y0 = rng[1], y1 = rng[2],
               line = list(color = "grey60", width = 1, dash = "dash")),
          list(type = "line", x0 = res$cutoff, x1 = res$cutoff,
               y0 = rng[1], y1 = rng[2],
               line = list(color = "#e31a1c", width = 1, dash = "dot"))
        ),
        xaxis = list(title = "Test 1 Score", range = rng),
        yaxis = list(title = "Test 2 Score", range = rng),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rtm_table <- renderTable({
    res <- rtm_data(); req(res)
    dat <- res$dat
    sel <- dat[dat$selected, ]
    data.frame(
      Measure = c("N selected", "Mean Test 1", "Mean Test 2",
                   "Change (T2 \u2212 T1)", "Correlation (T1, T2)"),
      Value = c(sum(dat$selected),
                round(mean(sel$test1), 2),
                round(mean(sel$test2), 2),
                round(mean(sel$test2) - mean(sel$test1), 2),
                round(cor(sel$test1, sel$test2), 3))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  ps_data <- reactiveVal(NULL)

  observeEvent(input$ps_go, {
    n <- input$ps_n; conf <- input$ps_confound; ate <- input$ps_ate
    set.seed(sample.int(10000, 1))

    x1 <- rnorm(n); x2 <- rnorm(n)
    # Treatment depends on confounders
    lp <- conf * x1 + 0.5 * conf * x2
    pr_treat <- plogis(lp)
    treat <- rbinom(n, 1, pr_treat)

    # Outcome depends on treatment + confounders
    y <- ate * treat + conf * x1 + 0.5 * x2 + rnorm(n)

    dat <- data.frame(x1 = x1, x2 = x2, treat = treat, y = y, ps = pr_treat)

    # Naive estimate
    naive <- mean(y[treat == 1]) - mean(y[treat == 0])

    # Regression adjusted
    fit <- lm(y ~ treat + x1 + x2, data = dat)
    reg_adj <- coef(fit)["treat"]

    # PS matching (nearest neighbor, 1:1)
    ps_model <- glm(treat ~ x1 + x2, data = dat, family = binomial)
    dat$ps_hat <- predict(ps_model, type = "response")

    treated_idx <- which(dat$treat == 1)
    control_idx <- which(dat$treat == 0)
    matched_ctrl <- integer(length(treated_idx))
    used <- logical(length(control_idx))
    for (i in seq_along(treated_idx)) {
      dists <- abs(dat$ps_hat[treated_idx[i]] - dat$ps_hat[control_idx])
      dists[used] <- Inf
      best <- which.min(dists)
      matched_ctrl[i] <- control_idx[best]
      used[best] <- TRUE
    }
    ps_est <- mean(dat$y[treated_idx] - dat$y[matched_ctrl])

    ps_data(list(dat = dat, naive = naive, reg = reg_adj, ps = ps_est, ate = ate))
  })

  output$ps_dist <- renderPlotly({
    res <- ps_data()
    req(res)
    dat <- res$dat
    plotly::plot_ly(alpha = 0.5) |>
      plotly::add_histogram(x = dat$ps_hat[dat$treat == 1],
                            name = "Treated",
                            marker = list(color = "rgba(227,26,28,0.5)")) |>
      plotly::add_histogram(x = dat$ps_hat[dat$treat == 0],
                            name = "Control",
                            marker = list(color = "rgba(49,130,189,0.5)")) |>
      plotly::layout(
        barmode = "overlay",
        xaxis = list(title = "Estimated Propensity Score"),
        yaxis = list(title = "Count"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ps_table <- renderTable({
    res <- ps_data(); req(res)
    data.frame(
      Method = c("True ATE", "Naive (unadjusted)", "Regression adjusted",
                  "PS matched (1:1 NN)"),
      Estimate = round(c(res$ate, res$naive, res$reg, res$ps), 3),
      Bias = round(c(0, res$naive - res$ate, res$reg - res$ate, res$ps - res$ate), 3)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
