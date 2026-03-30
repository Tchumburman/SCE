# ===========================================================================
# p-Hacking / Garden of Forking Paths Simulator
# Users interactively make analytic choices and watch the p-value change.
# ===========================================================================

phacking_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  title = "p-Hacking Simulator",
  icon  = icon("wand-magic-sparkles"),
  layout_sidebar(
    sidebar = sidebar(
      title = "Analytic Choices",
      width = 320,

      # ── Tab 1: Interactive Forking ──
      conditionalPanel(ns = ns, 
        "input.phack_tabs == 'Garden of Forking Paths'",
        tags$p(class = "text-muted", style = "font-size: 0.85rem;",
          "This dataset has NO real effect. Make analysis choices and
           watch how easily you can find p < .05 anyway."),
        actionButton(ns("phack_new_data"), "Generate New (Null) Dataset",
                     icon = icon("dice"), class = "btn-outline-primary w-100 mb-3"),
        tags$hr(),
        selectInput(ns("phack_outcome"), "Outcome variable",
                    c("Score A", "Score B", "Score C")),
        selectInput(ns("phack_group"), "Grouping variable",
                    c("Treatment vs. Control",
                      "Gender (Male vs. Female)",
                      "Age group (Young vs. Old)")),
        checkboxGroupInput(ns("phack_covariates"), "Covariates to include",
                           c("Age", "Baseline score", "SES index")),
        selectInput(ns("phack_outlier"), "Outlier handling",
                    c("Keep all data",
                      "Remove |z| > 3",
                      "Remove |z| > 2.5",
                      "Remove |z| > 2")),
        selectInput(ns("phack_transform"), "Transformation",
                    c("None", "Log(y + 1)", "Square root", "Rank-based")),
        selectInput(ns("phack_subset"), "Subset",
                    c("Full sample",
                      "Only participants who completed all items",
                      "Only high-engagement participants",
                      "Only first-time participants")),
        selectInput(ns("phack_test"), "Test type",
                    c("t-test (two-sided)",
                      "t-test (one-sided: > 0)",
                      "Wilcoxon rank-sum",
                      "ANCOVA (with selected covariates)")),
        actionButton(ns("phack_run"), "Run Analysis",
                     icon = icon("flask"), class = "btn-success w-100 mt-2")
      ),

      # ── Tab 2: Many Analysts ──
      conditionalPanel(ns = ns, 
        "input.phack_tabs == 'Many Analysts Simulation'",
        sliderInput(ns("phack_n_analysts"), "Number of analysts", 50, 5000, 1000, step = 50),
        sliderInput(ns("phack_n_choices"), "Decisions per analyst", 2, 8, 5),
        sliderInput(ns("phack_sample_n"), "Sample size per study", 30, 500, 80, step = 10),
        checkboxInput(ns("phack_null_true"), "Null hypothesis is TRUE (no real effect)", TRUE),
        conditionalPanel(ns = ns, 
          "!input.phack_null_true",
          sliderInput(ns("phack_true_d"), "True effect size (Cohen's d)", 0.05, 0.5, 0.2, step = 0.05)
        ),
        actionButton(ns("phack_sim_go"), "Simulate", class = "btn-success w-100 mt-2")
      ),

      # ── Tab 3: p-Curve ──
      conditionalPanel(ns = ns, 
        "input.phack_tabs == 'p-Curve Diagnostics'",
        tags$p(class = "text-muted", style = "font-size: 0.85rem;",
          "A p-curve is the distribution of statistically significant p-values.
           Its shape reveals whether the evidence reflects a true effect or selective reporting."),
        sliderInput(ns("pcurve_n_studies"), "Number of studies", 20, 500, 100, step = 10),
        sliderInput(ns("pcurve_n_per"), "Sample size per study", 20, 200, 50, step = 10),
        selectInput(ns("pcurve_scenario"), "Scenario",
                    c("True effect (d = 0.5)",
                      "True effect (d = 0.2)",
                      "No effect (pure p-hacking)",
                      "Mix: 50% real + 50% p-hacked")),
        actionButton(ns("pcurve_go"), "Generate p-Curve", class = "btn-success w-100 mt-2")
      )
    ),

    navset_card_tab(
      id = ns("phack_tabs"),

      # ── Tab 1 ──
      nav_panel("Garden of Forking Paths",
        explanation_box(
          tags$strong("The Garden of Forking Paths"),
          tags$p("Researcher degrees of freedom refer to the many
                  legitimate-seeming decisions researchers make during
                  data analysis: which outcome to focus on, how to define
                  groups, whether to include covariates, how to handle
                  outliers, which test to use, and whether to transform
                  the data. Each choice is defensible in isolation, but
                  the cumulative effect of making these choices after
                  seeing the data dramatically inflates the false positive
                  rate."),
          tags$p("In this simulator, the dataset has NO real effect
                  built in \u2014 the groups are generated from the same
                  distribution. Yet by trying different combinations
                  of analytic choices, you can almost always find a
                  'statistically significant' result (p < .05). This
                  is not fraud; it is the natural consequence of
                  exploring a flexible analytic pipeline without
                  pre-registration."),
          tags$p("Gelman and Loken (2013) called this 'the garden of
                  forking paths' \u2014 even without intentional
                  p-hacking, researchers who make data-contingent
                  decisions inflate their error rates. The solution is
                  pre-registration: specifying the analysis plan before
                  seeing the data, so that there is only one path through
                  the garden.")
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(
            card_header(
              class = "d-flex justify-content-between align-items-center",
              "Current Result",
              uiOutput(ns("phack_badge"))
            ),
            card_body(uiOutput(ns("phack_result")))
          ),
          card(card_header("p-Value History"),
               card_body(plotly::plotlyOutput(ns("phack_history_plot"), height = "280px")))
        ),
        card(card_header("Forking Path Log"),
             card_body(
               style = "max-height: 250px; overflow-y: auto;",
               uiOutput(ns("phack_log"))
             ))
      ),

      # ── Tab 2 ──
      nav_panel("Many Analysts Simulation",
        explanation_box(
          tags$strong("Many Analysts, One Dataset"),
          tags$p("Imagine giving the same dataset to many independent
                  analysts, each of whom makes their own reasonable
                  analytic decisions. Even when there is no true effect,
                  a substantial proportion will report p < .05 simply
                  because of the variability introduced by different
                  analytic choices. Simonsohn et al. (2014) showed that
                  even a small number of researcher degrees of freedom
                  can inflate the false positive rate from 5% to over
                  50%."),
          tags$p("This simulation generates null (or small-effect) data
                  and sends it through many random analysis pipelines.
                  Each 'analyst' randomly chooses an outcome, a grouping
                  variable, whether to include covariates, how to handle
                  outliers, and which test to use. The resulting
                  distribution of p-values shows how many analysts find
                  'significance' by chance."),
          tags$p("The key insight is that the nominal \u03b1 = .05 only
                  holds when you commit to a single analysis in advance.
                  When the analysis is chosen post-hoc from a space of
                  possibilities, the effective \u03b1 is much higher. This
                  is why pre-registration and multiverse analysis
                  (reporting results across all defensible pipelines)
                  are increasingly required by journals.")
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("p-Value Distribution (all analysts)"),
               card_body(plotly::plotlyOutput(ns("phack_sim_hist"), height = "340px"))),
          card(full_screen = TRUE, card_header("False Positive Rate by # of Choices"),
               card_body(plotly::plotlyOutput(ns("phack_sim_fpr"), height = "340px")))
        ),
        card(card_header("Summary"), card_body(uiOutput(ns("phack_sim_summary"))))
      ),

      # ── Tab 3 ──
      nav_panel("p-Curve Diagnostics",
        explanation_box(
          tags$strong("p-Curve Analysis"),
          tags$p("The p-curve is the distribution of statistically
                  significant p-values (those below .05). Its shape is
                  diagnostic: when a true effect exists, the p-curve is
                  right-skewed (more values near 0 than near .05). When
                  results come from p-hacking or selective reporting with
                  no true effect, the p-curve is flat or left-skewed
                  (values concentrate near .05 because those are the
                  ones that just barely crossed the threshold)."),
          tags$p("Simonsohn, Nelson, and Simmons (2014) introduced
                  p-curve as a tool for evaluating the evidential value
                  of a set of findings. A right-skewed p-curve suggests
                  that the published results reflect genuine effects; a
                  flat or left-skewed curve suggests that the literature
                  may be contaminated by selective reporting."),
          tags$p("This tab lets you generate p-curves under different
                  scenarios: a true effect (which produces right-skew),
                  pure p-hacking (which produces a flat or left-skewed
                  curve), and a mixture. Comparing these shapes builds
                  intuition for reading p-curves in published
                  meta-scientific research.")
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("p-Curve (significant results only)"),
               card_body(plotly::plotlyOutput(ns("pcurve_plot"), height = "340px"))),
          card(full_screen = TRUE, card_header("Full p-Value Distribution"),
               card_body(plotly::plotlyOutput(ns("pcurve_full_plot"), height = "340px")))
        ),
        card(card_header("Diagnostics"), card_body(uiOutput(ns("pcurve_summary"))))
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

phacking_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ════════════════════════════════════════════════════════════
  # Tab 1 — Garden of Forking Paths
  # ════════════════════════════════════════════════════════════

  # Reactive dataset — purely null (no real effect)
  phack_data <- reactiveVal(NULL)
  phack_log_entries <- reactiveVal(list())
  phack_p_history <- reactiveVal(numeric(0))

  observeEvent(input$phack_new_data, {
    set.seed(sample.int(10000, 1))
    n <- 200

    d <- data.frame(
      id = seq_len(n),
      treatment = sample(c("Treatment", "Control"), n, replace = TRUE),
      gender = sample(c("Male", "Female"), n, replace = TRUE),
      age_group = sample(c("Young", "Old"), n, replace = TRUE),
      age = round(rnorm(n, 40, 12)),
      baseline = rnorm(n, 50, 10),
      ses = rnorm(n, 0, 1),
      completed_all = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.7, 0.3)),
      high_engagement = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.5, 0.5)),
      first_time = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.6, 0.4))
    )

    # All outcomes are pure noise — NO group differences
    d$score_a <- rnorm(n, 50, 10)
    d$score_b <- rnorm(n, 50, 10)
    d$score_c <- rnorm(n, 50, 10)

    phack_data(d)
    phack_log_entries(list())
    phack_p_history(numeric(0))
  })

  observe({
    if (is.null(phack_data())) {
      set.seed(sample.int(10000, 1))
      n <- 200
      d <- data.frame(
        id = seq_len(n),
        treatment = sample(c("Treatment", "Control"), n, replace = TRUE),
        gender = sample(c("Male", "Female"), n, replace = TRUE),
        age_group = sample(c("Young", "Old"), n, replace = TRUE),
        age = round(rnorm(n, 40, 12)),
        baseline = rnorm(n, 50, 10),
        ses = rnorm(n, 0, 1),
        completed_all = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.7, 0.3)),
        high_engagement = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.5, 0.5)),
        first_time = sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.6, 0.4)),
        score_a = rnorm(n, 50, 10),
        score_b = rnorm(n, 50, 10),
        score_c = rnorm(n, 50, 10)
      )
      phack_data(d)
    }
  })

  phack_current <- reactiveVal(NULL)
  observeEvent(input$phack_run, {
    withProgress(message = "Testing for significance...", value = 0.1, {
    phack_current({
    d <- phack_data(); req(d)

    # Select outcome
    y_col <- switch(input$phack_outcome,
      "Score A" = "score_a", "Score B" = "score_b", "Score C" = "score_c")
    y <- d[[y_col]]

    # Select grouping
    grp <- switch(input$phack_group,
      "Treatment vs. Control" = d$treatment,
      "Gender (Male vs. Female)" = d$gender,
      "Age group (Young vs. Old)" = d$age_group)
    grp_levels <- unique(grp)

    # Subset
    keep <- rep(TRUE, nrow(d))
    if (input$phack_subset == "Only participants who completed all items") {
      keep <- d$completed_all
    } else if (input$phack_subset == "Only high-engagement participants") {
      keep <- d$high_engagement
    } else if (input$phack_subset == "Only first-time participants") {
      keep <- d$first_time
    }
    y <- y[keep]; grp <- grp[keep]
    covs <- d[keep, , drop = FALSE]
    n_used <- sum(keep)

    # Transform
    if (input$phack_transform == "Log(y + 1)") {
      y <- log(y - min(y) + 1)
    } else if (input$phack_transform == "Square root") {
      y <- sqrt(y - min(y))
    } else if (input$phack_transform == "Rank-based") {
      y <- rank(y)
    }

    # Outlier removal
    if (input$phack_outlier != "Keep all data") {
      threshold <- switch(input$phack_outlier,
        "Remove |z| > 3" = 3, "Remove |z| > 2.5" = 2.5, "Remove |z| > 2" = 2)
      z <- abs(scale(y))
      ok <- z <= threshold
      y <- y[ok]; grp <- grp[ok]; covs <- covs[ok, , drop = FALSE]
      n_used <- length(y)
    }

    # Run test
    g1 <- y[grp == grp_levels[1]]
    g2 <- y[grp == grp_levels[2]]

    if (input$phack_test == "t-test (two-sided)") {
      tt <- t.test(g1, g2)
      p <- tt$p.value; stat <- tt$statistic; test_name <- "Two-sided t-test"
    } else if (input$phack_test == "t-test (one-sided: > 0)") {
      tt <- t.test(g1, g2, alternative = "greater")
      p <- tt$p.value; stat <- tt$statistic; test_name <- "One-sided t-test"
    } else if (input$phack_test == "Wilcoxon rank-sum") {
      wt <- wilcox.test(g1, g2)
      p <- wt$p.value; stat <- wt$statistic; test_name <- "Wilcoxon rank-sum"
    } else {
      # ANCOVA
      df_anc <- data.frame(y = y, grp = grp)
      form <- "y ~ grp"
      if ("Age" %in% input$phack_covariates) { df_anc$age <- covs$age; form <- paste0(form, " + age") }
      if ("Baseline score" %in% input$phack_covariates) { df_anc$baseline <- covs$baseline; form <- paste0(form, " + baseline") }
      if ("SES index" %in% input$phack_covariates) { df_anc$ses <- covs$ses; form <- paste0(form, " + ses") }
      fit <- lm(as.formula(form), data = df_anc)
      aov_tab <- anova(fit)
      p <- aov_tab["grp", "Pr(>F)"]; stat <- aov_tab["grp", "F value"]
      test_name <- "ANCOVA F-test"
    }

    d_est <- (mean(g1) - mean(g2)) / sqrt((var(g1) + var(g2)) / 2)

    # Log the entry
    entry <- list(
      attempt = length(phack_p_history()) + 1,
      outcome = input$phack_outcome,
      group = input$phack_group,
      subset = input$phack_subset,
      transform = input$phack_transform,
      outlier = input$phack_outlier,
      test = input$phack_test,
      covariates = paste(input$phack_covariates, collapse = ", "),
      n = n_used, p = p, d = d_est
    )

    old_log <- phack_log_entries()
    phack_log_entries(c(old_log, list(entry)))
    phack_p_history(c(phack_p_history(), p))

    list(p = p, stat = stat, test_name = test_name, n = n_used,
         d = d_est, entry = entry)
    })
    })
  })

  output$phack_badge <- renderUI({
    res <- phack_current(); req(res)
    if (res$p < 0.05) {
      tags$span(class = "badge bg-danger", "p < .05!")
    } else {
      tags$span(class = "badge bg-secondary", "Not significant")
    }
  })

  output$phack_result <- renderUI({
    res <- phack_current(); req(res)
    sig_class <- if (res$p < 0.05) "text-danger fw-bold" else "text-muted"
    HTML(sprintf(
      '<div style="padding: 0.5rem;">
       <table class="table table-sm" style="font-size: 0.9rem; max-width: 400px;">
       <tr><td><strong>Test</strong></td><td>%s</td></tr>
       <tr><td><strong>n</strong></td><td>%d</td></tr>
       <tr><td><strong>Test statistic</strong></td><td>%.3f</td></tr>
       <tr><td><strong>p-value</strong></td><td class="%s">%s</td></tr>
       <tr><td><strong>Cohen\'s d</strong></td><td>%.3f</td></tr>
       </table>
       <p class="text-muted mt-2" style="font-size: 0.85rem;">
       Remember: this data has <strong>no real effect</strong>. Any significance is a false positive.</p>
       </div>',
      res$test_name, res$n, res$stat, sig_class,
      formatC(res$p, format = "f", digits = 4), res$d
    ))
  })

  output$phack_history_plot <- plotly::renderPlotly({
    ps <- phack_p_history()
    req(length(ps) > 0)

    cols <- ifelse(ps < 0.05, "#dc322f", "#268bd2")
    plotly::plot_ly() |>
      plotly::add_trace(
        x = seq_along(ps), y = ps, type = "scatter", mode = "markers+lines",
        marker = list(color = cols, size = 8,
                      line = list(color = "white", width = 1)),
        line = list(color = "#93a1a1", width = 1),
        hoverinfo = "text", showlegend = FALSE,
        text = paste0("Attempt ", seq_along(ps), "<br>p = ", round(ps, 4))
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = 0.5, x1 = length(ps) + 0.5,
                           y0 = 0.05, y1 = 0.05,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = length(ps) + 0.5, y = 0.05, text = "\u03b1 = .05",
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = "Attempt #", dtick = 1),
        yaxis = list(title = "p-value", range = c(0, 1)),
        margin = list(t = 10, r = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$phack_log <- renderUI({
    entries <- phack_log_entries()
    if (length(entries) == 0) return(tags$p(class = "text-muted", "No analyses run yet."))

    rows <- lapply(rev(entries), function(e) {
      sig <- if (e$p < 0.05) tags$span(class = "badge bg-danger", "p < .05") else
                              tags$span(class = "badge bg-secondary", "n.s.")
      tags$div(
        class = "border-bottom py-2",
        style = "font-size: 0.85rem;",
        tags$strong(paste0("#", e$attempt, " ")), sig,
        tags$span(class = "text-muted ms-2",
          paste0(e$outcome, " | ", e$group, " | ", e$subset, " | ",
                 e$transform, " | ", e$outlier, " | ", e$test,
                 if (nchar(e$covariates) > 0) paste0(" | +", e$covariates) else "",
                 " | n=", e$n, " | p=", formatC(e$p, format = "f", digits = 4)))
      )
    })
    tagList(rows)
  })

  # ════════════════════════════════════════════════════════════
  # Tab 2 — Many Analysts Simulation
  # ════════════════════════════════════════════════════════════
  phack_sim_data <- reactiveVal(NULL)
  observeEvent(input$phack_sim_go, {
    withProgress(message = "Running p-hacking simulation...", value = 0.1, {
    phack_sim_data({
    n_analysts <- input$phack_n_analysts
    n_choices <- input$phack_n_choices
    n_per <- input$phack_sample_n
    null_true <- input$phack_null_true
    true_d <- if (!null_true) input$phack_true_d else 0

    p_values <- numeric(n_analysts)
    for (a in seq_len(n_analysts)) {
      # Generate data
      g1 <- rnorm(n_per, 0, 1)
      g2 <- rnorm(n_per, true_d, 1)
      y <- c(g1, g2)
      grp <- rep(c("A", "B"), each = n_per)

      # Random analytic choices
      best_p <- 1
      for (ch in seq_len(n_choices)) {
        y_tmp <- y; grp_tmp <- grp

        # Random outlier rule
        if (sample(c(TRUE, FALSE), 1)) {
          z <- abs(scale(y_tmp))
          thr <- sample(c(2, 2.5, 3), 1)
          keep <- z <= thr
          y_tmp <- y_tmp[keep]; grp_tmp <- grp_tmp[keep]
        }

        # Random transform
        tr <- sample(1:3, 1)
        if (tr == 2) y_tmp <- log(y_tmp - min(y_tmp) + 1)
        else if (tr == 3) y_tmp <- rank(y_tmp)

        # Random test
        test <- sample(1:3, 1)
        if (test == 1) {
          p <- t.test(y_tmp[grp_tmp == "A"], y_tmp[grp_tmp == "B"])$p.value
        } else if (test == 2) {
          p <- t.test(y_tmp[grp_tmp == "A"], y_tmp[grp_tmp == "B"],
                      alternative = "greater")$p.value
        } else {
          p <- suppressWarnings(
            wilcox.test(y_tmp[grp_tmp == "A"], y_tmp[grp_tmp == "B"])$p.value)
        }
        best_p <- min(best_p, p)
      }
      p_values[a] <- best_p
    }

    # Also compute FPR for different numbers of choices
    fpr_by_k <- numeric(8)
    for (k in 1:8) {
      ps_k <- numeric(500)
      for (i in 1:500) {
        g1 <- rnorm(n_per, 0, 1)
        g2 <- rnorm(n_per, true_d, 1)
        y <- c(g1, g2); grp <- rep(c("A", "B"), each = n_per)
        bp <- 1
        for (ch in seq_len(k)) {
          y_tmp <- y; grp_tmp <- grp
          if (sample(c(TRUE, FALSE), 1)) {
            z <- abs(scale(y_tmp))
            keep <- z <= sample(c(2, 2.5, 3), 1)
            y_tmp <- y_tmp[keep]; grp_tmp <- grp_tmp[keep]
          }
          tr <- sample(1:3, 1)
          if (tr == 2) y_tmp <- log(y_tmp - min(y_tmp) + 1)
          else if (tr == 3) y_tmp <- rank(y_tmp)
          test <- sample(1:2, 1)
          p <- if (test == 1) t.test(y_tmp[grp_tmp == "A"], y_tmp[grp_tmp == "B"])$p.value
               else t.test(y_tmp[grp_tmp == "A"], y_tmp[grp_tmp == "B"],
                           alternative = "greater")$p.value
          bp <- min(bp, p)
        }
        ps_k[i] <- bp
      }
      fpr_by_k[k] <- mean(ps_k < 0.05)
    }

    list(p_values = p_values, fpr_by_k = fpr_by_k,
         null_true = null_true, true_d = true_d,
         n_analysts = n_analysts, n_choices = n_choices, n_per = n_per)
    })
    })
  })

  output$phack_sim_hist <- plotly::renderPlotly({
    d <- phack_sim_data(); req(d)
    h <- hist(d$p_values, breaks = seq(0, 1, by = 0.025), plot = FALSE)
    cols <- ifelse(h$mids <= 0.05, "#dc322f", "#268bd2")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = h$mids, y = h$counts,
        marker = list(color = cols, line = list(color = "white", width = 0.5)),
        hoverinfo = "text", textposition = "none",
        text = paste0("p \u2248 ", round(h$mids, 3), "<br>Count: ", h$counts),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line",
                           x0 = 0.05, x1 = 0.05,
                           y0 = 0, y1 = max(h$counts) * 1.1,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        xaxis = list(title = "Best p-value per analyst"),
        yaxis = list(title = "Count"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$phack_sim_fpr <- plotly::renderPlotly({
    d <- phack_sim_data(); req(d)
    cols <- ifelse(d$fpr_by_k > 0.05, "#dc322f", "#268bd2")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = seq_len(8), y = d$fpr_by_k,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        hoverinfo = "text", textposition = "none",
        text = paste0(seq_len(8), " choices<br>FPR: ",
                      round(d$fpr_by_k * 100, 1), "%"),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = 0.5, x1 = 8.5,
                           y0 = 0.05, y1 = 0.05,
                           line = list(color = "#dc322f", dash = "dash", width = 1.5))),
        annotations = list(list(
          x = 8.5, y = 0.05, text = "Nominal \u03b1 = .05",
          showarrow = FALSE, xanchor = "left",
          font = list(color = "#dc322f", size = 10))),
        xaxis = list(title = "Number of analytic decisions", dtick = 1),
        yaxis = list(title = "Proportion finding p < .05",
                     tickformat = ".0%", range = c(0, max(d$fpr_by_k) * 1.15)),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$phack_sim_summary <- renderUI({
    d <- phack_sim_data(); req(d)
    fpr <- mean(d$p_values < 0.05)
    median_p <- median(d$p_values)
    label <- if (d$null_true) "False positive rate" else "Discovery rate"
    HTML(sprintf(
      '<div style="padding: 0.5rem;">
       <table class="table table-sm table-striped" style="font-size: 0.9rem; max-width: 500px;">
       <tr><td><strong>Analysts simulated</strong></td><td>%d</td></tr>
       <tr><td><strong>Decisions per analyst</strong></td><td>%d</td></tr>
       <tr><td><strong>Sample size</strong></td><td>%d per group</td></tr>
       <tr><td><strong>True effect</strong></td><td>%s</td></tr>
       <tr><td><strong>%s</strong></td><td class="%s">%.1f%%</td></tr>
       <tr><td><strong>Median best p</strong></td><td>%.4f</td></tr>
       </table>
       <p class="text-muted mt-2">%s</p></div>',
      d$n_analysts, d$n_choices, d$n_per,
      if (d$null_true) "d = 0 (null is true)" else paste0("d = ", d$true_d),
      label,
      if (fpr > 0.10) "text-danger fw-bold" else "",
      fpr * 100, median_p,
      if (d$null_true && fpr > 0.10)
        sprintf("With %d analytic choices, the false positive rate is %.0f%% \u2014 far above the nominal 5%%.",
                d$n_choices, fpr * 100)
      else if (!d$null_true)
        "With a true effect, more flexibility increases the discovery rate but also inflates the false positive rate when applied to null results."
      else
        "With few analytic choices, the false positive rate stays close to nominal."
    ))
  })

  # ════════════════════════════════════════════════════════════
  # Tab 3 — p-Curve
  # ════════════════════════════════════════════════════════════
  pcurve_data <- reactiveVal(NULL)
  observeEvent(input$pcurve_go, {
    withProgress(message = "Computing p-curve...", value = 0.1, {
    pcurve_data({
    n_studies <- input$pcurve_n_studies
    n_per <- input$pcurve_n_per
    scenario <- input$pcurve_scenario

    p_values <- numeric(n_studies)

    for (i in seq_len(n_studies)) {
      if (scenario == "True effect (d = 0.5)") {
        g1 <- rnorm(n_per, 0, 1)
        g2 <- rnorm(n_per, 0.5, 1)
        p_values[i] <- t.test(g1, g2)$p.value
      } else if (scenario == "True effect (d = 0.2)") {
        g1 <- rnorm(n_per, 0, 1)
        g2 <- rnorm(n_per, 0.2, 1)
        p_values[i] <- t.test(g1, g2)$p.value
      } else if (scenario == "No effect (pure p-hacking)") {
        # Try multiple analyses until p < .05 (or give up)
        best_p <- 1
        for (attempt in 1:20) {
          g1 <- rnorm(n_per, 0, 1)
          g2 <- rnorm(n_per, 0, 1)
          p <- t.test(g1, g2)$p.value
          best_p <- min(best_p, p)
          if (best_p < 0.05) break
        }
        p_values[i] <- best_p
      } else {
        # Mix: 50% real, 50% p-hacked
        if (runif(1) < 0.5) {
          g1 <- rnorm(n_per, 0, 1)
          g2 <- rnorm(n_per, 0.3, 1)
          p_values[i] <- t.test(g1, g2)$p.value
        } else {
          best_p <- 1
          for (attempt in 1:20) {
            g1 <- rnorm(n_per, 0, 1)
            g2 <- rnorm(n_per, 0, 1)
            p <- t.test(g1, g2)$p.value
            best_p <- min(best_p, p)
            if (best_p < 0.05) break
          }
          p_values[i] <- best_p
        }
      }
    }

    list(p_values = p_values, sig = p_values[p_values < 0.05],
         scenario = scenario, n_studies = n_studies)
    })
    })
  })

  output$pcurve_plot <- plotly::renderPlotly({
    d <- pcurve_data(); req(d)
    sig <- d$sig
    req(length(sig) >= 3)

    h <- hist(sig, breaks = seq(0, 0.05, by = 0.005), plot = FALSE)
    plotly::plot_ly() |>
      plotly::add_bars(
        x = h$mids, y = h$counts,
        marker = list(color = "#268bd2", line = list(color = "white", width = 0.5)),
        hoverinfo = "text", textposition = "none",
        text = paste0("p \u2208 [", round(h$breaks[-length(h$breaks)], 3), ", ",
                      round(h$breaks[-1], 3), ")<br>Count: ", h$counts),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "p-value (significant only)", range = c(0, 0.055)),
        yaxis = list(title = "Count"),
        title = list(text = paste0("p-Curve: ", d$scenario), font = list(size = 12)),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$pcurve_full_plot <- plotly::renderPlotly({
    d <- pcurve_data(); req(d)
    h <- hist(d$p_values, breaks = seq(0, 1, by = 0.025), plot = FALSE)
    cols <- ifelse(h$mids <= 0.05, "#dc322f", "#93a1a1")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = h$mids, y = h$counts,
        marker = list(color = cols, line = list(color = "white", width = 0.5)),
        hoverinfo = "text", textposition = "none",
        text = paste0("p \u2248 ", round(h$mids, 3), "<br>Count: ", h$counts),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "p-value"),
        yaxis = list(title = "Count"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$pcurve_summary <- renderUI({
    d <- pcurve_data(); req(d)
    n_sig <- length(d$sig)
    pct_sig <- round(100 * n_sig / d$n_studies, 1)
    # Simple skewness test on significant p-values
    if (n_sig >= 5) {
      median_sig <- median(d$sig)
      skew_dir <- if (median_sig < 0.025) "right-skewed (consistent with a true effect)"
                  else if (median_sig > 0.04) "left-skewed / flat (consistent with p-hacking)"
                  else "ambiguous (weak evidence either way)"
    } else {
      skew_dir <- "too few significant results to assess"
    }

    HTML(sprintf(
      '<div style="padding: 0.5rem;">
       <table class="table table-sm table-striped" style="font-size: 0.9rem; max-width: 500px;">
       <tr><td><strong>Scenario</strong></td><td>%s</td></tr>
       <tr><td><strong>Studies simulated</strong></td><td>%d</td></tr>
       <tr><td><strong>Significant (p < .05)</strong></td><td>%d (%.1f%%)</td></tr>
       <tr><td><strong>Median significant p</strong></td><td>%s</td></tr>
       <tr><td><strong>p-Curve shape</strong></td><td>%s</td></tr>
       </table>
       <p class="text-muted mt-2"><strong>Interpretation:</strong> A right-skewed p-curve
       (more values near 0) suggests genuine evidential value. A flat or left-skewed curve
       (values clustering near .05) suggests selective reporting or p-hacking.</p></div>',
      d$scenario, d$n_studies, n_sig, pct_sig,
      if (n_sig > 0) formatC(median(d$sig), format = "f", digits = 4) else "N/A",
      skew_dir
    ))
  })

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "p-Hacking Simulator", list(phack_data, phack_log_entries, phack_p_history, phack_current, phack_sim_data, pcurve_data))
  })
}
