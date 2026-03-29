# Module: Scoring & Reporting (consolidated)
# Tabs: CTT | Score Reporting | SEM (Measurement)

# ── UI ──────────────────────────────────────────────────────────────────
scoring_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Scoring & Reporting",
  icon = icon("ruler-combined"),
  navset_card_underline(

    # ── Tab 1: CTT ─────────────────────────────────────────────────────
    nav_panel(
      "CTT",
        navset_card_underline(
          # Tab A: Scaling
          nav_panel(
            "Score Scaling",
            layout_sidebar(
              sidebar = sidebar(
                width = 300,
                sliderInput(ns("ctt_n"), "Number of examinees", min = 50, max = 2000, value = 500, step = 50),
                sliderInput(ns("ctt_items"), "Number of items", min = 10, max = 100, value = 30, step = 5),
                sliderInput(ns("ctt_mean_diff"), "Mean item difficulty (p)", min = 0.3, max = 0.8,
                            value = 0.6, step = 0.05),
                sliderInput(ns("ctt_n_forms"), "Number of test forms", min = 1, max = 4, value = 1, step = 1),
                actionButton(ns("ctt_gen"), "Generate test data", class = "btn-success w-100")
              ),
              explanation_box(
                tags$strong("Classical Test Theory \u2014 Score Scaling"),
                tags$p("Classical Test Theory (CTT) is the traditional framework for test
                        analysis. It assumes each observed score X is composed of a true
                        score T plus random measurement error E: X = T + E. The reliability
                        of a test (\u03b1) indicates what proportion of score variance is true
                        variance vs. error variance."),
                tags$p("Raw scores are often hard to interpret on their own. Scaling transforms
                        them to standardized metrics:",
                       tags$br(),
                       tags$b("z-score:"), " (X - M) / SD \u2014 mean = 0, SD = 1.", tags$br(),
                       tags$b("T-score:"), " 50 + 10 \u00d7 z \u2014 mean = 50, SD = 10. Used in many psychological tests.", tags$br(),
                       tags$b("Percentile:"), " percentage scoring at or below \u2014 intuitive but nonlinear."),
                tags$p("An important distinction: z-scores and T-scores are linear transformations
                        that preserve the shape of the distribution. Percentile ranks are nonlinear
                        \u2014 they compress differences in the middle of the distribution and expand
                        differences in the tails. This means a 5-point difference in percentile rank
                        near the median corresponds to a smaller ability difference than a 5-point
                        difference in the tails."),
                tags$p("CTT has notable limitations: reliability and item statistics are sample-dependent
                        (they change with different examinee populations), and the SEM is assumed
                        constant across all score levels. IRT addresses both of these limitations
                        but requires larger samples and stronger assumptions."),
                tags$p(tags$b("Multiple forms:"), " When more than one form is generated, each form uses
                        slightly different item difficulties drawn around the same mean. Compare their
                        score distributions and statistics side by side."),
                guide = tags$ol(
                  tags$li("Set the number of examinees, items, and average difficulty."),
                  tags$li("Optionally increase 'Number of test forms' to generate parallel forms."),
                  tags$li("Click 'Generate test data' to simulate item responses."),
                  tags$li("The left plot shows the raw score distribution (overlaid for multiple forms)."),
                  tags$li("The right plot shows the same scores on three standard scales."),
                  tags$li("Check the statistics table for mean, SD, Cronbach's \u03b1, and SEM per form.")
                )
              ),
              layout_column_wrap(
                width = 1 / 2,
                card(full_screen = TRUE, card_header("Raw Score Distribution"),
                     plotlyOutput(ns("ctt_raw_plot"), height = "350px")),
                card(full_screen = TRUE, card_header("Scaled Scores"),
                     plotlyOutput(ns("ctt_scaled_plot"), height = "350px"))
              ),
              card(card_header("Score Statistics"), tableOutput(ns("ctt_stats")))
            )
          ),
          # Tab B: Equating
          nav_panel(
            "Equipercentile Equating",
            layout_sidebar(
              sidebar = sidebar(
                width = 300,
                sliderInput(ns("ctt_eq_n"), "Examinees per form", min = 100, max = 3000, value = 500, step = 100),
                sliderInput(ns("ctt_eq_items"), "Items per form", min = 10, max = 60, value = 30, step = 5),
                sliderInput(ns("ctt_eq_n_forms"), "Number of forms", min = 2, max = 4, value = 2, step = 1),
                sliderInput(ns("ctt_eq_diff"), "Difficulty shift (per form)", min = -5, max = 5,
                            value = 2, step = 0.5),
                actionButton(ns("ctt_eq_gen"), "Generate & equate", class = "btn-success w-100")
              ),
              explanation_box(
                tags$strong("Equipercentile Equating"),
                tags$p("When two test forms differ in difficulty, a raw score of 20 on Form A
                        may not represent the same ability as 20 on Form B. Equating adjusts
                        for these differences. Equipercentile equating maps scores by matching
                        percentile ranks: a score at the 70th percentile on Form B is equated
                        to whatever score is at the 70th percentile on Form A."),
                tags$p("With multiple forms, each successive form is shifted by the difficulty
                        parameter. All forms are equated back to Form A as the reference."),
                tags$p("Equipercentile equating requires that the groups taking each form are
                        equivalent (random groups design) or that a common set of anchor items
                        links the forms (common-item design). The method is nonlinear: it can
                        correct for differences in both difficulty and score distribution shape.
                        Smoothing (e.g., log-linear or kernel methods) is typically applied to
                        reduce irregularities from sampling variability."),
                guide = tags$ol(
                  tags$li("Set the number of examinees per form and items per form."),
                  tags$li("Choose the number of forms (2\u20134)."),
                  tags$li("Adjust difficulty shift \u2014 positive values make each successive form harder."),
                  tags$li("Click 'Generate & equate'."),
                  tags$li("Left: compare the score distributions of all forms."),
                  tags$li("Right: equating functions mapping each form back to Form A.")
                )
              ),
              layout_column_wrap(
                width = 1 / 2,
                card(full_screen = TRUE, card_header("Score Distributions"),
                     plotlyOutput(ns("ctt_eq_dist_plot"), height = "350px")),
                card(full_screen = TRUE, card_header("Equating Functions (\u2192 Form A)"),
                     plotlyOutput(ns("ctt_eq_func_plot"), height = "350px"))
              )
            )
          )
        )
    ),

    # ── Tab 2: Score Reporting ──────────────────────────────────────────
    nav_panel(
      "Score Reporting",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("sr_raw"), "Raw score", min = 0, max = 50, value = 35, step = 1),
            sliderInput(ns("sr_items"), "Total items", min = 20, max = 80, value = 50, step = 5),
            sliderInput(ns("sr_mean"), "Population mean", min = 20, max = 40, value = 30, step = 1),
            sliderInput(ns("sr_sd"), "Population SD", min = 3, max = 12, value = 8, step = 1),
            sliderInput(ns("sr_reliability"), "Test reliability", min = 0.5, max = 0.98,
                        value = 0.85, step = 0.01),
            actionButton(ns("sr_go"), "Compute", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Score Reporting"),
            tags$p("Raw scores must be converted into interpretable scales for reporting.
                    This module demonstrates common transformations and the concept of
                    measurement error in reported scores."),
            tags$ul(
              tags$li(tags$strong("Percentile rank:"), " Percentage of the population scoring at or below this score."),
              tags$li(tags$strong("z-score:"), " Standard deviations above/below the mean."),
              tags$li(tags$strong("T-score:"), " Mean = 50, SD = 10."),
              tags$li(tags$strong("Scaled score:"), " Mean = 100, SD = 15 (IQ-type)."),
              tags$li(tags$strong("SEM:"), " Standard error of measurement = SD \u00d7 \u221a(1 \u2212 r). Defines the confidence band around the score."),
              tags$li(tags$strong("Classification consistency:"), " Probability the examinee would be classified the same way on retest.")
            ),
            tags$p("When reporting scores, always communicate measurement uncertainty. A score
                    of 105 with SEM = 5 should be understood as \u201cprobably between 95 and 115\u201d
                    (95% CI), not as a precise value. Classification decisions (pass/fail,
                    diagnosis) near the cut-score are particularly uncertain and should be
                    communicated with appropriate caution."),
            tags$p("Different score scales serve different purposes. Percentile ranks are easy
                    to interpret but compress differences near the mean and exaggerate differences
                    in the tails. Standard scores (z, T, scaled) maintain equal intervals along
                    the scale, making them suitable for tracking change over time. The choice of
                    reporting scale should consider the audience and the decisions being made."),
            tags$p("Score reports for educational tests increasingly include confidence bands,
                    growth charts, and diagnostic subscores. These additional details help
                    educators and examinees understand not just the overall performance level
                    but also areas of strength and weakness, and whether score differences
                    across time or subtests are meaningful given measurement error.")
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Score with Confidence Band"),
                 plotlyOutput(ns("sr_band"), height = "300px")),
            card(card_header("Score Conversions"), tableOutput(ns("sr_conversions"))),
            card(card_header("Classification"), tableOutput(ns("sr_classification")))
          )
        )
    ),

    # ── Tab 3: SEM (Measurement) ───────────────────────────────────────
    nav_panel(
      "SEM (Measurement)",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            tags$h6("CTT Parameters"),
            sliderInput(ns("sem_m_rel"), "Test reliability (\u03b1)", min = 0.5, max = 0.99,
                        value = 0.85, step = 0.01),
            sliderInput(ns("sem_m_sd"), "Score SD", min = 1, max = 20, value = 10, step = 1),
            tags$hr(),
            tags$h6("IRT Parameters (2PL)"),
            sliderInput(ns("sem_m_a"), "Discrimination (a)", min = 0.3, max = 3, value = 1.2, step = 0.1),
            sliderInput(ns("sem_m_items_irt"), "Number of items", min = 5, max = 60, value = 20, step = 5),
            actionButton(ns("sem_m_go"), "Compute & Compare", class = "btn-success w-100")
          ),
          explanation_box(
            tags$strong("Standard Error of Measurement"),
            tags$p("The SEM quantifies the precision of individual test scores. In CTT,
                    SEM = SD\u221a(1 \u2212 \u03b1), which is constant for all examinees.
                    In IRT, the standard error varies by ability level — tests are most
                    precise where information is highest (typically near item difficulty)."),
            tags$p("This page compares CTT\u2019s constant SEM with IRT\u2019s conditional SEM,
                    illustrating why IRT provides a richer picture of measurement precision."),
            tags$p("The practical implication is substantial: in CTT, a score of 50 and a score
                    of 90 are estimated with the same precision. In IRT, the test may be very
                    precise at 50 (where most items provide information) but imprecise at 90
                    (where few items are difficult enough to be informative). This conditional
                    precision is especially important for cut-score decisions, where the SEM at
                    the specific cut-point determines classification accuracy."),
            guide = tags$ol(
              tags$li("Set CTT reliability and score SD to see the constant SEM."),
              tags$li("Set IRT discrimination and test length."),
              tags$li("Click 'Compute & Compare' to see both SEMs plotted together."),
              tags$li("Notice how IRT SEM is small at medium ability but large at extremes."),
              tags$li("Higher discrimination or more items reduces IRT SEM across the board.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("SEM Comparison: CTT vs. IRT"),
                 plotlyOutput(ns("sem_m_plot"), height = "420px")),
            card(full_screen = TRUE, card_header("Test Information Function"),
                 plotlyOutput(ns("sem_m_info_plot"), height = "420px"))
          )
        )
    ),

    # ── Tab 6: IRT Scoring Methods Compared ─────────────────────────
    nav_panel(
      "IRT Scoring",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("irts_n"),     "Examinees",   min = 100, max = 1000, value = 500, step = 100),
          sliderInput(ns("irts_k"),     "Items",        min = 5,   max = 30,   value = 15,  step = 1),
          sliderInput(ns("irts_a_bar"), "Mean discrimination (a)", min = 0.5, max = 2.5, value = 1.2, step = 0.1),
          selectInput(ns("irts_model"), "Generating model",
                      choices = c("1PL", "2PL", "3PL"), selected = "2PL"),
          actionButton(ns("irts_go"), "Simulate & Score", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("IRT Scoring Methods Compared"),
          tags$p("Once item parameters are known, ability (\u03b8) can be estimated
                  several ways. Each method has different properties in terms of bias,
                  variance, and behaviour at the extremes."),
          tags$ul(
            tags$li(tags$b("MLE (Maximum Likelihood):"),
                    " Finds the \u03b8 that maximises the likelihood of the observed responses.
                     Unbiased asymptotically, but undefined for perfect (0 or K) scores and
                     has high variance for short tests."),
            tags$li(tags$b("WLE (Warm\u2019s weighted MLE):"),
                    " Adds a bias correction to MLE. Better for short tests; still undefined
                     at extremes but more stable than MLE."),
            tags$li(tags$b("EAP (Expected A Posteriori):"),
                    " Bayesian estimate integrating over a prior (\u03b8 ~ N(0,1)).
                     Always defined, lower variance than MLE, but slightly shrunk toward
                     the prior mean \u2014 introduces small bias near the extremes.")
          ),
          tags$p("The scatter plots compare each estimate against the true \u03b8, and the
                  bias/RMSE table summarises accuracy across the ability range."),
          tags$p("The choice of scoring method has practical consequences. For short tests
                  (fewer than 20 items), EAP typically yields the lowest root mean squared
                  error (RMSE) because the prior acts as a regulariser, shrinking extreme
                  estimates toward the population mean. For long tests (30+ items), the data
                  overwhelm the prior and all three methods converge to similar estimates.
                  WLE is a good default when the goal is unbiased ability estimation and the
                  test is of moderate length."),
          tags$p("At extreme scores (all correct or all incorrect), MLE is undefined and
                  special procedures are needed: score-bumping (adding 0.5 to the raw
                  score), maximum likelihood with a boundary constraint, or simply using
                  EAP or WLE. Score reporting systems must handle these edge cases explicitly,
                  as examinees with perfect scores may still differ meaningfully in true
                  ability \u2014 a point that is invisible when using number-correct scoring."),
          tags$p("When comparing ability estimates across groups or test forms, the scoring
                  method should be consistent. Mixing MLE and EAP estimates introduces
                  systematic differences because EAP shrinks toward the prior while MLE
                  does not. For population-level inference (e.g., PISA), EAP-based plausible
                  values from a population model are preferred because they correctly
                  propagate measurement uncertainty into group-level statistics."),
          guide = tags$ol(
            tags$li("Choose sample size, items, and generating model."),
            tags$li("Click 'Simulate & Score' to generate data and apply all three methods."),
            tags$li("Compare scatter plots: look for systematic bias and spread."),
            tags$li("Check the bias/RMSE table \u2014 EAP tends to win on RMSE for short tests.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("True \u03b8 vs. Estimated \u03b8"),
               plotlyOutput(ns("irts_scatter"), height = "420px")),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Bias by Ability Quintile"),
                 plotlyOutput(ns("irts_bias_plot"), height = "320px")),
            card(card_header("Method Comparison"), tableOutput(ns("irts_table")))
          )
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

scoring_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── CTT ───────────────────────────────────────────────────────────────
  ctt_result <- reactiveVal(NULL)
  
  observeEvent(input$ctt_gen, {
    set.seed(sample(1:10000, 1))
    n <- input$ctt_n; k <- input$ctt_items; p_mean <- input$ctt_mean_diff
    n_forms <- input$ctt_n_forms %||% 1
    
    # Convert mean p-value to ability-difficulty threshold
    target_threshold <- qnorm(p_mean)
    
    forms <- lapply(seq_len(n_forms), function(f) {
      # Item difficulties centered so average p-value matches p_mean
      diffs <- rnorm(k, mean = 0, sd = 0.8)
      diffs <- diffs - mean(diffs)  # center at 0
      # Shift so that an average-ability person (theta=0) has P(correct) ~ p_mean
      diffs <- diffs - target_threshold
      
      theta <- rnorm(n)
      probs <- pnorm(outer(theta, diffs, "-"))
      responses <- matrix(rbinom(n * k, 1, probs), n, k)
      raw_scores <- rowSums(responses)
      
      list(raw = raw_scores, n_items = k, responses = responses, form = paste0("Form ", LETTERS[f]))
    })
    
    ctt_result(forms)
  })
  
  output$ctt_raw_plot <- renderPlotly({
    res <- ctt_result()
    req(res)

    form_colors <- c("Form A" = "#238b45", "Form B" = "#e31a1c",
                      "Form C" = "#2171b5", "Form D" = "#6a3d9a")

    if (length(res) == 1) {
      scores <- res[[1]]$raw
      brks <- seq(min(scores) - 0.5, max(scores) + 0.5, by = 1)
      h <- hist(scores, breaks = brks, plot = FALSE)
      hover <- paste0("Score: ", round(h$mids), "<br>Count: ", h$counts)
      plot_ly() |>
        add_bars(x = h$mids, y = h$counts, text = hover, textposition = "none",
                 hoverinfo = "text", width = 1,
                 marker = list(color = "#238b45", opacity = 0.8,
                               line = list(color = "white", width = 0.5)),
                 showlegend = FALSE) |>
        layout(
          xaxis = list(title = "Raw Score"),
          yaxis = list(title = "Count"),
          bargap = 0.02,
          annotations = list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0("Mean = ", round(mean(scores), 1),
                                "  |  SD = ", round(sd(scores), 1)),
                 showarrow = FALSE, font = list(size = 12))
          ),
          margin = list(t = 40)
        )
    } else {
      p <- plot_ly()
      for (i in seq_along(res)) {
        scores <- res[[i]]$raw
        fname <- res[[i]]$form
        brks <- seq(min(scores) - 0.5, max(scores) + 0.5, by = 1)
        h <- hist(scores, breaks = brks, plot = FALSE)
        dens <- h$counts / (sum(h$counts) * diff(brks)[1])
        p <- p |> add_bars(x = h$mids, y = dens, name = fname,
                            text = paste0(fname, "<br>Score: ", round(h$mids),
                                          "<br>Density: ", round(dens, 3)),
                            textposition = "none", hoverinfo = "text", width = 1,
                            marker = list(color = form_colors[fname], opacity = 0.5))
      }
      p |> layout(
        barmode = "overlay", bargap = 0.02,
        xaxis = list(title = "Raw Score"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05)
      )
    }
  })
  
  output$ctt_scaled_plot <- renderPlotly({
    res <- ctt_result()
    req(res)
    raw <- res[[1]]$raw
    z <- scale(raw)[, 1]
    t_score <- 50 + 10 * z
    pctile <- ecdf(raw)(raw) * 100

    scales_list <- list(
      list(vals = z, name = "z-score"),
      list(vals = t_score, name = "T-score"),
      list(vals = pctile, name = "Percentile")
    )

    p <- plotly::subplot(
      lapply(scales_list, function(s) {
        brks <- seq(min(s$vals), max(s$vals), length.out = 31)
        h <- hist(s$vals, breaks = brks, plot = FALSE)
        hover_txt <- paste0(s$name, " \u2248 ", round(h$mids, 2),
                            "<br>Count: ", h$counts)
        plotly::plot_ly() |>
          plotly::add_bars(textposition = "none",
            x = h$mids, y = h$counts,
            marker = list(color = "#41ae76", opacity = 0.8,
                          line = list(color = "white", width = 0.5)),
            hoverinfo = "text", text = hover_txt,
            showlegend = FALSE, width = diff(brks)[1]
          ) |>
          plotly::layout(
            xaxis = list(title = s$name),
            yaxis = list(title = "Count"),
            bargap = 0.02
          )
      }),
      nrows = 1, shareY = TRUE, titleX = TRUE
    )

    sub <- if (length(res) > 1) paste0("Showing: ", res[[1]]$form) else ""
    p |> plotly::layout(
      annotations = list(
        list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
             text = sub, showarrow = FALSE, font = list(size = 12))
      ),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })
  
  output$ctt_stats <- renderTable({
    res <- ctt_result()
    req(res)
    
    stats_list <- lapply(res, function(f) {
      raw <- f$raw
      resp <- f$responses
      k <- ncol(resp)
      item_vars <- apply(resp, 2, var)
      total_var <- var(raw)
      alpha <- (k / (k - 1)) * (1 - sum(item_vars) / total_var)
      
      data.frame(
        Form = f$form,
        Mean = round(mean(raw), 2),
        SD = round(sd(raw), 2),
        Min = min(raw),
        Max = max(raw),
        Cronbachs_alpha = round(alpha, 3),
        SEM = round(sd(raw) * sqrt(1 - alpha), 2),
        Items = k,
        check.names = FALSE
      )
    })
    
    result <- do.call(rbind, stats_list)
    names(result)[names(result) == "Cronbachs_alpha"] <- "Cronbach's \u03b1"
    result
  }, hover = TRUE, spacing = "s")
  
  # -- Equating --
  eq_result <- reactiveVal(NULL)
  
  observeEvent(input$ctt_eq_gen, {
    set.seed(sample(1:10000, 1))
    n <- input$ctt_eq_n; k <- input$ctt_eq_items; shift <- input$ctt_eq_diff
    n_forms <- input$ctt_eq_n_forms %||% 2
    
    diffs_a <- sort(rnorm(k))
    
    # Generate scores for each form
    scores <- list()
    form_names <- paste0("Form ", LETTERS[seq_len(n_forms)])
    for (f in seq_len(n_forms)) {
      theta_f <- rnorm(n)
      diffs_f <- diffs_a + (f - 1) * shift / k
      scores[[f]] <- rowSums(matrix(rbinom(n * k, 1, pnorm(outer(theta_f, diffs_f, "-"))), n, k))
    }
    names(scores) <- form_names
    
    eq_result(list(scores = scores, k = k, n_forms = n_forms, form_names = form_names))
  })
  
  output$ctt_eq_dist_plot <- renderPlotly({
    res <- eq_result()
    req(res)

    form_colors <- c("Form A" = "#238b45", "Form B" = "#e31a1c",
                      "Form C" = "#2171b5", "Form D" = "#6a3d9a")

    p <- plot_ly()
    for (i in seq_along(res$scores)) {
      scores <- res$scores[[i]]
      fname <- res$form_names[i]
      brks <- seq(min(scores) - 0.5, max(scores) + 0.5, by = 1)
      h <- hist(scores, breaks = brks, plot = FALSE)
      dens <- h$counts / (sum(h$counts) * diff(brks)[1])
      p <- p |> add_bars(x = h$mids, y = dens, name = fname,
                          text = paste0(fname, "<br>Score: ", round(h$mids),
                                        "<br>Density: ", round(dens, 3)),
                          textposition = "none", hoverinfo = "text", width = 1,
                          marker = list(color = form_colors[fname], opacity = 0.5))
    }
    p |> layout(
      barmode = "overlay", bargap = 0.02,
      xaxis = list(title = "Raw Score"),
      yaxis = list(title = "Density"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05)
    )
  })

  output$ctt_eq_func_plot <- renderPlotly({
    res <- eq_result()
    req(res)

    k <- res$k
    score_range <- 0:k
    cdf_a <- ecdf(res$scores[[1]])

    form_colors <- c("Form B" = "#e31a1c", "Form C" = "#2171b5", "Form D" = "#6a3d9a")

    eq_lines <- do.call(rbind, lapply(2:res$n_forms, function(f) {
      cdf_f <- ecdf(res$scores[[f]])
      pctiles_f <- cdf_f(score_range)
      equated_a <- sapply(pctiles_f, function(p) {
        idx <- which(cdf_a(score_range) >= p)
        if (length(idx) == 0) max(score_range) else score_range[min(idx)]
      })
      data.frame(form_score = score_range, equated_a = equated_a,
                 form = res$form_names[f])
    }))
    eq_lines$form <- factor(eq_lines$form, levels = res$form_names[-1])
    form_colors <- c("Form B" = "#e31a1c", "Form C" = "#2171b5", "Form D" = "#6a3d9a")

    p <- plot_ly()
    for (fname in unique(eq_lines$form)) {
      d <- eq_lines[eq_lines$form == fname, ]
      hover <- paste0(fname, "<br>Score: ", d$form_score,
                       " \u2192 Form A: ", round(d$equated_a, 1),
                       "<br>Difference: ", round(d$equated_a - d$form_score, 1))
      p <- p |> add_trace(x = d$form_score, y = d$equated_a,
                           type = "scatter", mode = "lines", name = fname,
                           line = list(color = form_colors[fname], width = 2.5),
                           hoverinfo = "text", text = hover)
    }
    p |> layout(
      xaxis = list(title = "Form Score"),
      yaxis = list(title = "Equated Form A Score"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05),
      shapes = list(
        list(type = "line", x0 = 0, y0 = 0, x1 = k, y1 = k,
             line = list(color = "grey50", dash = "dash", width = 1))
      ),
      annotations = list(
        list(x = k * 0.85, y = k * 0.78,
             text = "Identity\n(no equating)", showarrow = FALSE,
             font = list(size = 9, color = "grey50"))
      )
    )
  })
  

  # ── Score Reporting ───────────────────────────────────────────────────
  sr_data <- reactiveVal(NULL)

  observeEvent(input$sr_go, {
    raw <- input$sr_raw; items <- input$sr_items
    mu <- input$sr_mean; sigma <- input$sr_sd; rel <- input$sr_reliability

    raw <- min(raw, items)
    z <- (raw - mu) / sigma
    percentile <- pnorm(z) * 100
    t_score <- 50 + 10 * z
    scaled <- 100 + 15 * z
    sem <- sigma * sqrt(1 - rel)

    # Confidence intervals (68% and 95%)
    ci68 <- c(raw - sem, raw + sem)
    ci95 <- c(raw - 1.96 * sem, raw + 1.96 * sem)

    # Classification: pass/fail at various cut scores
    cuts <- c(0.4, 0.5, 0.6, 0.7) * items
    cut_labels <- paste0(c(40, 50, 60, 70), "%")
    pass <- raw >= cuts
    # Consistency: probability of same classification on retest
    consistency <- sapply(cuts, function(c) {
      z_cut <- (c - raw) / sem
      if (raw >= c) 1 - pnorm(z_cut) else pnorm(z_cut)
    })

    sr_data(list(raw = raw, items = items, z = z, percentile = percentile,
                 t_score = t_score, scaled = scaled, sem = sem,
                 ci68 = ci68, ci95 = ci95, cuts = cuts,
                 cut_labels = cut_labels, pass = pass,
                 consistency = consistency, mu = mu, sigma = sigma))
  })

  output$sr_band <- renderPlotly({
    res <- sr_data()
    req(res)
    # Normal distribution of possible "true scores"
    x <- seq(res$ci95[1] - 2, res$ci95[2] + 2, length.out = 200)
    y <- dnorm(x, res$raw, res$sem)

    plotly::plot_ly() |>
      plotly::add_trace(x = x, y = y, type = "scatter", mode = "lines",
                        fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
                        line = list(color = "#238b45", width = 2),
                        name = "Score distribution", hoverinfo = "skip") |>
      plotly::layout(
        shapes = list(
          list(type = "rect", x0 = res$ci68[1], x1 = res$ci68[2],
               y0 = 0, y1 = max(y), fillcolor = "rgba(35,139,69,0.2)",
               line = list(width = 0)),
          list(type = "line", x0 = res$raw, x1 = res$raw,
               y0 = 0, y1 = max(y),
               line = list(color = "#e31a1c", width = 2))
        ),
        xaxis = list(title = "Score"),
        yaxis = list(title = "Density"),
        annotations = list(
          list(x = res$raw, y = max(y) * 1.05, text = paste0("Observed score = ", res$raw),
               showarrow = FALSE, font = list(size = 12, color = "#e31a1c")),
          list(x = (res$ci68[1] + res$ci68[2]) / 2, y = max(y) * 0.25,
               text = "\u00b11 SEM (68% CI)", showarrow = FALSE,
               font = list(size = 10, color = "#238b45")),
          list(x = 0.5, y = -0.15, xref = "paper", yref = "paper",
               text = paste0("68% CI: [", round(res$ci68[1], 1), ", ", round(res$ci68[2], 1), "]",
                              "  |  95% CI: [", round(res$ci95[1], 1), ", ", round(res$ci95[2], 1), "]"),
               showarrow = FALSE, font = list(size = 11))
        ),
        margin = list(t = 30, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$sr_conversions <- renderTable({
    res <- sr_data(); req(res)
    data.frame(
      Scale = c("Raw", "Percent correct", "z-score", "T-score",
                 "Scaled (IQ-type)", "Percentile rank", "SEM"),
      Value = c(res$raw, round(res$raw / res$items * 100, 1),
                round(res$z, 3), round(res$t_score, 1),
                round(res$scaled, 1), round(res$percentile, 1),
                round(res$sem, 2))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$sr_classification <- renderTable({
    res <- sr_data(); req(res)
    data.frame(
      `Cut Score` = res$cut_labels,
      `Cut Value` = res$cuts,
      Decision = ifelse(res$pass, "Pass", "Fail"),
      `Classification Consistency` = paste0(round(res$consistency * 100, 1), "%"),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── SEM (Measurement) ─────────────────────────────────────────────────
  output$sem_m_plot <- renderPlotly({
    input$sem_m_go
      rel <- input$sem_m_rel
      sd_score <- input$sem_m_sd
      a_irt <- input$sem_m_a
      n_items <- input$sem_m_items_irt
  
      # CTT SEM in score metric: constant
      sem_ctt_score <- sd_score * sqrt(1 - rel)

      # IRT: test information for n_items with equal discrimination
      # Spread item difficulties evenly across -2 to 2
      b_vals <- seq(-2, 2, length.out = n_items)
      theta <- seq(-4, 4, length.out = 500)

      info <- sapply(theta, function(th) {
        p <- 1 / (1 + exp(-a_irt * (th - b_vals)))
        sum(a_irt^2 * p * (1 - p))
      })

      # IRT SEM in theta metric
      sem_irt_theta <- 1 / sqrt(info)

      # Convert CTT SEM to theta metric via average TCC slope in the
      # central ability range so both curves are on the same scale
      tcc_deriv <- sapply(theta, function(th) {
        p <- 1 / (1 + exp(-a_irt * (th - b_vals)))
        sum(a_irt * p * (1 - p))
      })
      tcc_slope_mid <- mean(tcc_deriv[theta > -1.5 & theta < 1.5])
      sem_ctt_theta <- sem_ctt_score / tcc_slope_mid

      sem_vals <- c(rep(sem_ctt_theta, length(theta)), sem_irt_theta)
      meth_vals <- rep(c("CTT (constant)", "IRT (conditional)"), each = length(theta))
      df_plot <- data.frame(
        Ability = rep(theta, 2),
        SEM = sem_vals,
        Method = meth_vals,
        text = paste0("Method: ", meth_vals,
                      "<br>\u03b8 = ", round(rep(theta, 2), 2),
                      "<br>SEM = ", round(sem_vals, 4))
      )

      # Region where IRT outperforms CTT
      irt_better <- sem_irt_theta < sem_ctt_theta
      shade_df <- data.frame(
        x = theta[irt_better],
        ymin = sem_irt_theta[irt_better],
        ymax = sem_ctt_theta
      )

      # geom_ribbon(inherit.aes=FALSE) and annotate() don't convert
      # reliably via ggplotly; use plotly shapes/annotations instead
      hover_ctt <- paste0("CTT (constant)<br>\u03b8 = ", round(theta, 2),
                          "<br>SEM = ", round(sem_ctt_theta, 4))
      hover_irt <- paste0("IRT (conditional)<br>\u03b8 = ", round(theta, 2),
                          "<br>SEM = ", round(sem_irt_theta, 4))

      plt <- plot_ly()
      # Shaded region where IRT outperforms CTT
      if (nrow(shade_df) > 0) {
        plt <- plt |>
          add_trace(x = c(shade_df$x, rev(shade_df$x)),
                    y = c(rep(shade_df$ymax[1], nrow(shade_df)), rev(shade_df$ymin)),
                    type = "scatter", mode = "lines", fill = "toself",
                    fillcolor = "rgba(35, 139, 69, 0.12)",
                    line = list(width = 0),
                    showlegend = FALSE, hoverinfo = "skip")
      }
      plt |>
        add_trace(x = theta, y = rep(sem_ctt_theta, length(theta)),
                  type = "scatter", mode = "lines", name = "CTT (constant)",
                  line = list(color = "#e31a1c", width = 2.5, dash = "dash"),
                  hoverinfo = "text", text = hover_ctt) |>
        add_trace(x = theta, y = sem_irt_theta,
                  type = "scatter", mode = "lines", name = "IRT (conditional)",
                  line = list(color = "#238b45", width = 2.5),
                  hoverinfo = "text", text = hover_irt) |>
        layout(
          xaxis = list(title = "Ability (\u03b8)"),
          yaxis = list(title = "Standard Error of Measurement", rangemode = "tozero"),
          legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05),
          annotations = list(
            list(x = 0, y = sem_ctt_theta * 0.72,
                 text = "<i>IRT more precise</i>", showarrow = FALSE,
                 font = list(size = 13, color = "#238b45"))
          )
        )
  })

  output$sem_m_info_plot <- renderPlotly({
    input$sem_m_go
      a_irt <- input$sem_m_a
      n_items <- input$sem_m_items_irt
      b_vals <- seq(-2, 2, length.out = n_items)
      theta <- seq(-4, 4, length.out = 500)
  
      info <- sapply(theta, function(th) {
        p <- 1 / (1 + exp(-a_irt * (th - b_vals)))
        sum(a_irt^2 * p * (1 - p))
      })
  
      df_info <- data.frame(Ability = theta, Information = info,
                             text = paste0("\u03b8 = ", round(theta, 2),
                                           "<br>I(\u03b8) = ", round(info, 3),
                                           "<br>SE = ", round(1 / sqrt(pmax(info, 0.001)), 3)))
      plot_ly() |>
        add_trace(x = df_info$Ability, y = df_info$Information,
                  type = "scatter", mode = "lines",
                  fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
                  line = list(color = "#238b45", width = 2.5),
                  hoverinfo = "text", text = df_info$text,
                  showlegend = FALSE) |>
        layout(
          xaxis = list(title = "Ability (\u03b8)"),
          yaxis = list(title = "Test Information I(\u03b8)"),
          annotations = list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0(n_items, " items, a = ", a_irt),
                 showarrow = FALSE, font = list(size = 12))
          ),
          margin = list(t = 40)
        )
  })

  # ── Tab 6: IRT Scoring Methods server ───────────────────────────────

  irts_data <- reactiveVal(NULL)

  observeEvent(input$irts_go, {
    set.seed(sample(1:10000, 1))
    N <- input$irts_n; K <- input$irts_k
    a_bar <- input$irts_a_bar; model <- input$irts_model

    # True parameters
    b <- sort(runif(K, -2.5, 2.5))
    a <- if (model == "1PL") rep(1, K) else pmax(0.3, rnorm(K, a_bar, 0.3))
    c <- if (model == "3PL") runif(K, 0.05, 0.25) else rep(0, K)
    theta_true <- rnorm(N, 0, 1)

    # Simulate responses
    resp <- matrix(0L, N, K)
    for (j in seq_len(K)) {
      p <- c[j] + (1 - c[j]) / (1 + exp(-a[j] * (theta_true - b[j])))
      resp[, j] <- rbinom(N, 1, p)
    }

    # Log-likelihood helper
    ll_fn <- function(th, r) {
      p <- pmax(c + (1 - c) / (1 + exp(-a * (th - b))), 1e-9)
      sum(r * log(p) + (1 - r) * log(1 - p))
    }

    # MLE: maximise log-likelihood; NA for perfect scores
    mle <- vapply(seq_len(N), function(i) {
      rs <- sum(resp[i, ])
      if (rs == 0 || rs == K) return(NA_real_)
      tryCatch(
        optimise(function(th) -ll_fn(th, resp[i, ]), lower = -6, upper = 6)$minimum,
        error = function(e) NA_real_
      )
    }, numeric(1))

    # WLE: Warm's bias-corrected MLE
    wle <- vapply(seq_len(N), function(i) {
      rs <- sum(resp[i, ])
      if (rs == 0 || rs == K) return(NA_real_)
      tryCatch({
        optimise(function(th) {
          p  <- pmax(c + (1 - c) / (1 + exp(-a * (th - b))), 1e-9)
          q  <- 1 - p
          w  <- a^2 * p * q           # item information
          W  <- sum(w)                # test information
          # Warm's correction term
          bias_corr <- 0.5 * sum(a * w * (q - p)) / W^2
          -(ll_fn(th, resp[i, ]) + bias_corr * W)
        }, lower = -6, upper = 6)$minimum
      }, error = function(e) NA_real_)
    }, numeric(1))

    # EAP: quadrature over N(0,1) prior
    quad_pts  <- seq(-4, 4, length.out = 41)
    prior     <- dnorm(quad_pts)
    eap <- vapply(seq_len(N), function(i) {
      liks <- exp(vapply(quad_pts, function(th) ll_fn(th, resp[i, ]), numeric(1)))
      post <- liks * prior
      post <- post / sum(post)
      sum(quad_pts * post)
    }, numeric(1))

    irts_data(list(
      theta_true = theta_true, mle = mle, wle = wle, eap = eap,
      N = N, K = K, model = model
    ))
  })

  output$irts_scatter <- renderPlotly({
    d <- irts_data(); req(d)
    theta <- d$theta_true
    lim   <- c(-3.5, 3.5)
    cols  <- c(MLE = "#268bd2", WLE = "#2aa198", EAP = "#b58900")

    p <- plot_ly()
    for (nm in c("MLE", "WLE", "EAP")) {
      est <- switch(nm, MLE = d$mle, WLE = d$wle, EAP = d$eap)
      ok  <- !is.na(est)
      p <- p |> add_trace(
        x = theta[ok], y = est[ok], type = "scatter", mode = "markers",
        name = nm, marker = list(color = cols[nm], size = 4, opacity = 0.5),
        hoverinfo = "text",
        text = paste0("True: ", round(theta[ok], 2), "<br>Est: ", round(est[ok], 2))
      )
    }
    p |> add_trace(x = lim, y = lim, type = "scatter", mode = "lines",
                   line = list(color = "grey60", dash = "dash", width = 1),
                   showlegend = FALSE, hoverinfo = "skip") |>
      layout(
        xaxis = list(title = "True \u03b8", range = lim),
        yaxis = list(title = "Estimated \u03b8", range = lim),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 10)
      ) |> config(displayModeBar = FALSE)
  })

  output$irts_bias_plot <- renderPlotly({
    d <- irts_data(); req(d)
    theta <- d$theta_true
    quintiles <- cut(theta, breaks = quantile(theta, probs = seq(0, 1, 0.2)),
                     labels = paste0("Q", 1:5), include.lowest = TRUE)
    cols <- c(MLE = "#268bd2", WLE = "#2aa198", EAP = "#b58900")

    p <- plot_ly()
    for (nm in c("MLE", "WLE", "EAP")) {
      est  <- switch(nm, MLE = d$mle, WLE = d$wle, EAP = d$eap)
      bias <- est - theta
      means <- tapply(bias, quintiles, mean, na.rm = TRUE)
      p <- p |> add_trace(
        x = names(means), y = as.numeric(means),
        type = "scatter", mode = "lines+markers", name = nm,
        line = list(color = cols[nm], width = 2),
        marker = list(color = cols[nm], size = 8),
        hoverinfo = "text",
        text = paste0(nm, " Q", 1:5, "<br>Bias = ", round(as.numeric(means), 3))
      )
    }
    p |> add_trace(x = paste0("Q", 1:5), y = rep(0, 5),
                   type = "scatter", mode = "lines",
                   line = list(color = "grey60", dash = "dash", width = 1),
                   showlegend = FALSE, hoverinfo = "skip") |>
      layout(
        xaxis = list(title = "Ability quintile"),
        yaxis = list(title = "Mean bias (Est \u2212 True)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2),
        margin = list(t = 10, b = 60)
      ) |> config(displayModeBar = FALSE)
  })

  output$irts_table <- renderTable({
    d <- irts_data(); req(d)
    theta <- d$theta_true
    methods <- list(MLE = d$mle, WLE = d$wle, EAP = d$eap)
    rows <- lapply(names(methods), function(nm) {
      est  <- methods[[nm]]
      ok   <- !is.na(est)
      bias <- mean(est[ok] - theta[ok])
      rmse <- sqrt(mean((est[ok] - theta[ok])^2))
      corr <- cor(est[ok], theta[ok])
      n_na <- sum(!ok)
      data.frame(Method = nm,
                 Bias    = sprintf("%.3f", bias),
                 RMSE    = sprintf("%.3f", rmse),
                 r       = sprintf("%.3f", corr),
                 `Undefined` = n_na,
                 check.names = FALSE)
    })
    do.call(rbind, rows)
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load

  })
}
