# Module: Equating & Linking (consolidated)
# Tabs: Linking & Equating | IRT Linking | Vertical Scaling

# ── UI ──────────────────────────────────────────────────────────────────
mod_equating_linking_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Equating & Linking",
  icon = icon("link"),
  navset_card_underline(

    # ── Tab 1: Linking & Equating ────────────────────────────────
    nav_panel(
      "Linking & Equating",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("eq_method"), "Equating Method",
                        choices = c("Linear" = "linear",
                                    "Equipercentile" = "equipercentile",
                                    "IRT (TCC-based)" = "irt_tcc")),
            sliderInput(ns("eq_n"), "Sample size per form", min = 100, max = 2000, value = 500, step = 100),
            sliderInput(ns("eq_items"), "Items per form", min = 10, max = 40, value = 20, step = 5),
            sliderInput(ns("eq_difficulty_shift"), "Form B difficulty shift", min = -2, max = 2, value = 0.5, step = 0.25),
            sliderInput(ns("eq_sd_ratio"), "Form B difficulty spread ratio", min = 0.5, max = 1.5, value = 1.0, step = 0.1),
            actionButton(ns("eq_go"), "Simulate & Equate", class = "btn-success w-100 mb-2"),
            actionButton(ns("eq_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          explanation_box(
            tags$strong("Test Linking & Equating"),
            tags$p("Equating adjusts scores on different test forms so they are
                    interchangeable. Linear equating uses the mean and SD of each form;
                    equipercentile equating matches scores at each percentile rank;
                    IRT TCC-based equating uses item parameters to map scores through
                    the test characteristic curve via the latent trait."),
            tags$p("The goal is fairness \u2014 examinees should not be advantaged or
                    disadvantaged by which form they receive."),
          tags$p("Equating requires that the forms measure the same construct at the same
                  level of precision. If forms differ in content or reliability, the process
                  is more properly called linking or concordance rather than equating. The
                  distinction matters: equated scores are interchangeable, while linked scores
                  are only approximately comparable."),
            guide = tags$ol(
              tags$li("Select an equating method."),
              tags$li("Set a difficulty shift to make Form B harder or easier than Form A."),
              tags$li("Adjust the spread ratio to change how Form B item difficulties are scaled."),
              tags$li("Click 'Simulate & Equate' to generate two forms and apply the equating."),
              tags$li("The concordance plot shows how Form B scores map to Form A equivalent scores."),
              tags$li("Compare raw vs. equated score distributions to see the adjustment.")
            )
          ),
          layout_column_wrap(
            width = 1,
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("Score Concordance"),
                   plotlyOutput(ns("eq_concordance_plot"), height = "380px")),
              card(full_screen = TRUE, card_header("Score Distributions"),
                   plotlyOutput(ns("eq_dist_plot"), height = "380px"))
            ),
            card(card_header("Equating Summary"), uiOutput(ns("eq_summary")))
          )
        )
    ),

    # ── Tab 2: IRT Linking ───────────────────────────────────────
    nav_panel(
      "IRT Linking",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("irtl_method"), "Linking method",
              choices = c("Mean/Sigma" = "ms", "Mean/Mean" = "mm",
                          "Stocking-Lord" = "sl", "Haebara" = "hab"),
              selected = "ms"
            ),
            sliderInput(ns("irtl_items"), "Common items", min = 5, max = 20,
                        value = 10, step = 5),
            sliderInput(ns("irtl_shift_a"), "Scale shift (A)", min = 0.5, max = 2,
                        value = 1.2, step = 0.1),
            sliderInput(ns("irtl_shift_b"), "Location shift (B)", min = -2, max = 2,
                        value = 0.5, step = 0.25),
            actionButton(ns("irtl_go"), "Link", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("IRT Scaling & Linking"),
            tags$p("IRT parameters from separate calibrations are on different scales.
                    Linking places them on a common scale using the linear transformation:
                    \u03b8* = A\u03b7\u03b8 + B, b* = A\u03b7b + B, a* = a / A."),
            tags$ul(
              tags$li(tags$strong("Mean/Sigma:"), " Matches the mean and SD of common item difficulties."),
              tags$li(tags$strong("Mean/Mean:"), " Matches means of both a and b parameters."),
              tags$li(tags$strong("Stocking-Lord & Haebara:"), " Minimize differences between test characteristic curves (more robust).")
            ),
          tags$p("IRT linking methods place item and person parameters from different
                  calibrations onto a common scale. Mean/Sigma uses the first two moments
                  of the anchor item parameter distributions. Stocking-Lord minimises the
                  difference in test characteristic curves. The choice of anchor items is
                  critical: they must be free of DIF and representative of the full test."),
          tags$p("The accuracy of linking depends heavily on the quality and quantity of
                  anchor items. Typically, 20\u201330% of items are shared between forms. If
                  anchor items exhibit differential item functioning (DIF) between groups,
                  the linking transformation will be biased. Robust linking methods that
                  detect and downweight aberrant anchors have been developed to address
                  this concern."),
          tags$p("In operational testing programmes, linking is performed after every
                  administration to maintain score comparability over time. This is
                  essential for longitudinal tracking and fair comparison of scores across
                  different test forms and administrations."),
            guide = tags$ol(
              tags$li("Set the true scale transformation (A and B)."),
              tags$li("Click 'Link' to see how each method recovers A and B."),
              tags$li("Compare estimated vs. true transformations.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Common Item Plot (Before vs After Linking)"),
                 plotlyOutput(ns("irtl_plot"), height = "400px")),
            card(card_header("Linking Constants"), tableOutput(ns("irtl_table")))
          )
        )
    ),

    # ── Tab 3: Vertical Scaling ──────────────────────────────────
    nav_panel(
      "Vertical Scaling",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("vs_grades"), "Number of grade levels", min = 3, max = 8,
                        value = 5, step = 1),
            sliderInput(ns("vs_n"), "n per grade", min = 50, max = 300, value = 100, step = 50),
            sliderInput(ns("vs_growth"), "Growth per grade (logits)", min = 0.3, max = 1.5,
                        value = 0.7, step = 0.1),
            sliderInput(ns("vs_growth_var"), "Growth variability", min = 0, max = 0.5,
                        value = 0.2, step = 0.05),
            actionButton(ns("vs_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Vertical Scaling"),
            tags$p("Vertical scaling places scores from tests of different difficulty
                    levels (e.g., across grades) onto a common developmental scale.
                    This allows tracking growth over time."),
            tags$ul(
              tags$li(tags$strong("Common items:"), " Anchor items shared between adjacent grade levels link the scales."),
              tags$li(tags$strong("Growth interpretation:"), " The difference in mean \u03b8 across grades represents average growth."),
              tags$li(tags$strong("Challenges:"), " Assumes the construct is the same across levels (dimensionality invariance). Growth may not be uniform across the ability distribution.")
            ),
          tags$p("Vertical scaling links tests across different grade levels or difficulty
                  tiers onto a single developmental scale. This allows tracking growth over
                  time (e.g., reading ability from grades 3 to 8). However, the assumption
                  that the same construct is measured at each level is often tenuous \u2014
                  reading in grade 3 may be qualitatively different from reading in grade 8."),
          tags$p("Several methods exist for vertical scaling, including Thurstone scaling,
                  IRT-based concurrent calibration, and separate calibration with linking.
                  Concurrent calibration uses all grade-level data simultaneously, which
                  can be more efficient but assumes the IRT model holds across all levels.
                  Separate calibration with linking is more flexible but depends on the
                  quality of the common items between adjacent levels."),
          tags$p("Interpreting vertical scales requires caution. Equal-interval properties
                  may not hold across the full range, and growth patterns can be artefacts
                  of the scaling method rather than reflections of true developmental change.
                  Despite these challenges, vertical scales remain essential for growth
                  modelling in educational assessment."),
            guide = tags$ol(
              tags$li("Set the number of grades and growth per grade."),
              tags$li("Click 'Simulate' to generate grade-level data on a vertical scale."),
              tags$li("The growth curve shows mean ability by grade."),
              tags$li("Distributions show the overlap between adjacent grades.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Growth Curve"),
                 plotlyOutput(ns("vs_growth_plot"), height = "350px")),
            card(full_screen = TRUE, card_header("Grade Distributions"),
                 plotlyOutput(ns("vs_dist"), height = "350px")),
            card(card_header("Summary Statistics"), tableOutput(ns("vs_summary")))
          )
        )
    ),

    # ── Tab 4: Concordance Tables ────────────────────────────────────
    nav_panel(
      "Concordance Tables",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("conc_n"),     "Examinees",      min = 200,  max = 2000, value = 1000, step = 200),
          sliderInput(ns("conc_k_x"),   "Items (Form X)", min = 10,   max = 50,   value = 25,   step = 5),
          sliderInput(ns("conc_k_y"),   "Items (Form Y)", min = 10,   max = 50,   value = 30,   step = 5),
          sliderInput(ns("conc_rho"),   "True score correlation", min = 0.5, max = 1.0, value = 0.90, step = 0.05),
          selectInput(ns("conc_method"), "Equating method",
                      choices = c("Equipercentile" = "equipercentile",
                                  "Linear"         = "linear")),
          actionButton(ns("conc_go"), "Equate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Concordance Tables"),
          tags$p("A concordance table maps scores on one test form to their equivalent
                  scores on another. This is essential when different forms of a test
                  are used across administrations and scores must be comparable."),
          tags$p(tags$b("Linear equating"), " assumes the two score distributions have
                  the same shape and maps them by matching means and standard deviations:
                  Y\u2019 = \u03c3Y/\u03c3X \u00d7 (X \u2212 \u03bcX) + \u03bcY. It is
                  simple and stable but inappropriate when the forms differ in difficulty
                  distribution shape."),
          tags$p(tags$b("Equipercentile equating"), " matches scores that fall at the
                  same percentile rank in each distribution, then smooths the resulting
                  step function. It is more flexible but requires larger samples and can
                  be sensitive to sampling error in the tails."),
          tags$p("The concordance table also shows the Standard Error of Equating (SEE),
                  which is larger at the extremes where fewer examinees anchor the
                  equating relationship."),
          tags$p("Well-known real-world concordance tables include the SAT-ACT concordance
                  maintained by the College Board, which allows universities to compare
                  applicants who sat different entrance examinations. Such tables are
                  re-normed periodically because the populations taking each test change
                  over time, the test content evolves, and the score distributions shift \u2014
                  a concordance built on one cohort may not be valid a decade later."),
          tags$p("A key limitation of concordance tables is that they are population-dependent:
                  two tests measuring the same construct in the same population can be concorded,
                  but a concordance built on one population (e.g., college applicants) may not
                  hold for another (e.g., adults in a licensure exam). Concordances also assume
                  that both tests measure the same construct; if they measure related but
                  distinct constructs, the mapping may appear statistically plausible but
                  will be misleading for individual score interpretation."),
          guide = tags$ol(
            tags$li("Set sample size and number of items on each form."),
            tags$li("Adjust the true score correlation between forms."),
            tags$li("Choose linear or equipercentile equating."),
            tags$li("Click 'Equate' to generate the concordance table and plots.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Equating Function"),
                 plotlyOutput(ns("conc_eq_plot"), height = "380px")),
            card(full_screen = TRUE, card_header("Score Distributions"),
                 plotlyOutput(ns("conc_dist_plot"), height = "380px"))
          ),
          card(card_header("Concordance Table (selected rows)"),
               tableOutput(ns("conc_table")))
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_equating_linking_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Linking & Equating ─────────────────────────────────────
  eq_data <- reactiveVal(NULL)

  observeEvent(input$eq_reset, {
    updateSliderInput(session, "eq_n", value = 500)
    updateSliderInput(session, "eq_items", value = 20)
    updateSliderInput(session, "eq_difficulty_shift", value = 0.5)
    updateSliderInput(session, "eq_sd_ratio", value = 1.0)
    updateSelectInput(session, "eq_method", selected = "linear")
    eq_data(NULL)
  })

  observeEvent(input$eq_go, {
    set.seed(sample(1:10000, 1))
    n <- input$eq_n; k <- input$eq_items
    d_shift <- input$eq_difficulty_shift
    sd_ratio <- input$eq_sd_ratio

    # Form A: baseline item difficulties
    b_a <- seq(-2, 2, length.out = k)

    # Form B: shift and scale difficulties
    # b_b = d_shift + sd_ratio * b_a (since mean(b_a) = 0)
    b_b <- d_shift + sd_ratio * b_a

    # Random groups design: independent samples from the same population
    theta_a <- rnorm(n, 0, 1)
    theta_b <- rnorm(n, 0, 1)

    scores_a <- sapply(theta_a, function(th) sum(rbinom(k, 1, 1 / (1 + exp(-(th - b_a))))))
    scores_b <- sapply(theta_b, function(th) sum(rbinom(k, 1, 1 / (1 + exp(-(th - b_b))))))

    method <- input$eq_method
    raw_b <- sort(unique(scores_b))

    if (method == "linear") {
      equated <- mean(scores_a) + (sd(scores_a) / sd(scores_b)) * (raw_b - mean(scores_b))

    } else if (method == "equipercentile") {
      ecdf_b <- ecdf(scores_b)
      equated <- sapply(raw_b, function(xb) {
        p <- ecdf_b(xb)
        quantile(scores_a, probs = pmin(pmax(p, 0.001), 0.999))
      })

    } else {
      # IRT TCC-based equating
      # Since both forms' parameters are on a common scale, equating maps
      # through the latent trait: Form B score -> theta -> Form A score
      tcc_a <- function(th) sapply(th, function(t) sum(1 / (1 + exp(-(t - b_a)))))
      tcc_b <- function(th) sapply(th, function(t) sum(1 / (1 + exp(-(t - b_b)))))

      theta_grid <- seq(-6, 6, length.out = 2000)
      tcc_b_inv <- approxfun(tcc_b(theta_grid), theta_grid, rule = 2)

      equated <- sapply(raw_b, function(s) tcc_a(tcc_b_inv(s)))
    }

    eq_data(list(
      scores_a = scores_a, scores_b = scores_b,
      raw_b = raw_b, equated = equated, method = method,
      d_shift = d_shift, sd_ratio = sd_ratio, k = k,
      b_a = b_a, b_b = b_b
    ))
  })

  output$eq_concordance_plot <- renderPlotly({
    res <- eq_data(); req(res)
    df <- data.frame(Form_B = res$raw_b, Equated_A = res$equated,
                      text = paste0("Form B: ", res$raw_b,
                                    "<br>Equated to Form A: ", round(res$equated, 1),
                                    "<br>Adjustment: ", round(res$equated - res$raw_b, 1)))

    plot_ly() |>
      add_trace(x = df$Form_B, y = df$Equated_A, type = "scatter", mode = "lines",
                line = list(color = "#238b45", width = 2.5),
                hoverinfo = "text", text = df$text, showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Form B Raw Score", range = c(0, res$k)),
        yaxis = list(title = "Form A Equivalent Score", range = c(0, res$k)),
        shapes = list(
          list(type = "line", x0 = 0, y0 = 0, x1 = res$k, y1 = res$k,
               line = list(color = "grey50", dash = "dash", width = 1))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Method: ", res$method),
               showarrow = FALSE, font = list(size = 12)),
          list(x = res$k * 0.85, y = res$k * 0.78,
               text = "Identity\n(no equating)", showarrow = FALSE,
               font = list(size = 9, color = "grey50"))
        ),
        margin = list(t = 40)
      )
  })

  output$eq_dist_plot <- renderPlotly({
    res <- eq_data(); req(res)
    eq_func <- approxfun(res$raw_b, res$equated, rule = 2)
    equated_scores <- eq_func(res$scores_b)

    df <- data.frame(
      Score = c(res$scores_a, res$scores_b, equated_scores),
      Form = rep(c("Form A (reference)", "Form B (raw)", "Form B (equated)"),
                 each = length(res$scores_a))
    )
    df$Form <- factor(df$Form, levels = c("Form A (reference)", "Form B (raw)", "Form B (equated)"))

    form_levels <- c("Form A (reference)", "Form B (raw)", "Form B (equated)")
    form_colors <- c("#238b45", "#e31a1c", "#41ae76")
    scores_list <- list(res$scores_a, res$scores_b, equated_scores)

    p <- plot_ly()
    for (i in seq_along(form_levels)) {
      d <- density(scores_list[[i]], na.rm = TRUE)
      p <- p |> add_trace(x = d$x, y = d$y, type = "scatter", mode = "lines",
                           fill = "tozeroy",
                           fillcolor = paste0(form_colors[i], "40"),
                           line = list(color = form_colors[i], width = 1.5),
                           name = form_levels[i],
                           hoverinfo = "text",
                           text = paste0(form_levels[i],
                                          "<br>Score \u2248 ", round(d$x, 1),
                                          "<br>Density: ", round(d$y, 4)))
    }
    p |> layout(
      xaxis = list(title = "Score"),
      yaxis = list(title = "Density"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05)
    )
  })

  output$eq_summary <- renderUI({
    res <- eq_data(); req(res)
    eq_func <- approxfun(res$raw_b, res$equated, rule = 2)
    equated_scores <- eq_func(res$scores_b)

    div(style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$thead(tags$tr(tags$th(""), tags$th("Form A"), tags$th("Form B (raw)"), tags$th("Form B (equated)"))),
        tags$tr(tags$td(tags$strong("Mean")),
                tags$td(round(mean(res$scores_a), 2)),
                tags$td(round(mean(res$scores_b), 2)),
                tags$td(round(mean(equated_scores), 2))),
        tags$tr(tags$td(tags$strong("SD")),
                tags$td(round(sd(res$scores_a), 2)),
                tags$td(round(sd(res$scores_b), 2)),
                tags$td(round(sd(equated_scores), 2)))
      ),
      tags$p(class = "text-muted mt-2",
        paste0("Difficulty shift = ", res$d_shift,
               ", Spread ratio = ", res$sd_ratio,
               ", Method = ", res$method))
    )
  })


  # ── IRT Linking ────────────────────────────────────────────
  irtl_data <- reactiveVal(NULL)

  observeEvent(input$irtl_go, {
    J <- input$irtl_items; A_true <- input$irtl_shift_a; B_true <- input$irtl_shift_b
    method <- input$irtl_method
    set.seed(sample.int(10000, 1))

    # Form X parameters (reference)
    a_x <- runif(J, 0.5, 2.5)
    b_x <- sort(runif(J, -2, 2))

    # Form Y parameters (transformed scale)
    a_y <- a_x / A_true + rnorm(J, 0, 0.05)
    b_y <- A_true * b_x + B_true + rnorm(J, 0, 0.1)

    # Estimate linking constants
    if (method == "ms") {
      A_hat <- sd(b_y) / sd(b_x)
      B_hat <- mean(b_y) - A_hat * mean(b_x)
    } else if (method == "mm") {
      A_hat <- mean(a_x) / mean(a_y)
      B_hat <- mean(b_y) - A_hat * mean(b_x)
    } else {
      # Stocking-Lord / Haebara: grid search
      obj_fn <- function(par) {
        A <- par[1]; B <- par[2]
        b_linked <- A * b_x + B
        a_linked <- a_x / A
        theta <- seq(-3, 3, length.out = 50)
        diff <- 0
        for (j in seq_len(J)) {
          p_y <- 1 / (1 + exp(-a_y[j] * (theta - b_y[j])))
          p_linked <- 1 / (1 + exp(-a_linked[j] * (theta - b_linked[j])))
          if (method == "sl") {
            diff <- diff + sum((p_y - p_linked))^2
          } else {
            diff <- diff + sum((p_y - p_linked)^2)
          }
        }
        diff
      }
      opt <- optim(c(1, 0), obj_fn, method = "Nelder-Mead")
      A_hat <- opt$par[1]; B_hat <- opt$par[2]
    }

    # Linked parameters
    b_linked <- A_hat * b_x + B_hat

    irtl_data(list(b_x = b_x, b_y = b_y, b_linked = b_linked,
                   A_true = A_true, B_true = B_true,
                   A_hat = A_hat, B_hat = B_hat, method = method))
  })

  output$irtl_plot <- renderPlotly({
    res <- irtl_data()
    req(res)
    rng <- range(c(res$b_y, res$b_linked))

    plotly::plot_ly() |>
      plotly::add_markers(x = res$b_y, y = res$b_linked,
                          marker = list(color = "#238b45", size = 8),
                          name = "Linked vs Form Y",
                          hoverinfo = "text",
                          text = paste0("Form Y b = ", round(res$b_y, 2),
                                         "<br>Linked b = ", round(res$b_linked, 2))) |>
      plotly::add_trace(x = rng, y = rng,
                        type = "scatter", mode = "lines",
                        line = list(color = "#e31a1c", width = 1.5, dash = "dash"),
                        name = "Identity", hoverinfo = "skip") |>
      plotly::layout(
        xaxis = list(title = "Form Y difficulty"),
        yaxis = list(title = "Linked difficulty"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$irtl_table <- renderTable({
    res <- irtl_data(); req(res)
    data.frame(
      Parameter = c("A (scale)", "B (location)"),
      True = round(c(res$A_true, res$B_true), 3),
      Estimated = round(c(res$A_hat, res$B_hat), 3),
      Difference = round(c(res$A_hat - res$A_true, res$B_hat - res$B_true), 3)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Vertical Scaling ───────────────────────────────────────
  vs_data <- reactiveVal(NULL)

  observeEvent(input$vs_go, {
    G <- input$vs_grades; n <- input$vs_n
    growth <- input$vs_growth; gvar <- input$vs_growth_var
    set.seed(sample.int(10000, 1))

    # Grade-level abilities
    grade_means <- cumsum(c(0, rep(growth, G - 1)))
    # Add variability to growth
    grade_means <- grade_means + cumsum(c(0, rnorm(G - 1, 0, gvar)))

    dat <- data.frame(
      grade = rep(seq_len(G), each = n),
      theta = unlist(lapply(seq_len(G), function(g) rnorm(n, grade_means[g], 1)))
    )
    dat$grade_label <- paste0("Grade ", dat$grade)

    means <- tapply(dat$theta, dat$grade, mean)
    sds <- tapply(dat$theta, dat$grade, sd)

    vs_data(list(dat = dat, grade_means = grade_means, obs_means = means,
                 obs_sds = sds, G = G))
  })

  output$vs_growth_plot <- renderPlotly({
    res <- vs_data()
    req(res)
    grades <- seq_len(res$G)
    se <- res$obs_sds / sqrt(table(res$dat$grade))

    plotly::plot_ly() |>
      plotly::add_trace(x = grades, y = as.numeric(res$obs_means),
                        type = "scatter", mode = "lines+markers",
                        line = list(color = "#238b45", width = 3),
                        marker = list(color = "#238b45", size = 10),
                        name = "Mean \u03b8",
                        error_y = list(type = "data",
                                       array = as.numeric(1.96 * se),
                                       color = "#238b45"),
                        hoverinfo = "text",
                        text = paste0("Grade ", grades,
                                       "<br>Mean = ", round(res$obs_means, 3),
                                       "<br>SD = ", round(res$obs_sds, 3))) |>
      plotly::layout(
        xaxis = list(title = "Grade", dtick = 1),
        yaxis = list(title = "\u03b8 (Vertical Scale)"),
        showlegend = TRUE,
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        annotations = list(list(
          x = 0.01, y = 0.99, xref = "paper", yref = "paper",
          text = "Error bars = 95% CI", showarrow = FALSE,
          font = list(size = 10, color = "grey50"),
          xanchor = "left", yanchor = "top"
        )),
        margin = list(t = 30, b = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$vs_dist <- renderPlotly({
    res <- vs_data(); req(res)
    cols <- RColorBrewer::brewer.pal(max(3, res$G), "Set2")

    p <- plotly::plot_ly()
    for (g in seq_len(res$G)) {
      x <- res$dat$theta[res$dat$grade == g]
      p <- p |> plotly::add_trace(
        x = x, type = "histogram",
        opacity = 0.4,
        marker = list(color = cols[g]),
        name = paste0("Grade ", g),
        hoverinfo = "skip"
      )
    }
    p |> plotly::layout(
      barmode = "overlay",
      xaxis = list(title = "\u03b8"),
      yaxis = list(title = "Count"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$vs_summary <- renderTable({
    res <- vs_data(); req(res)
    growth <- diff(as.numeric(res$obs_means))
    data.frame(
      Grade = seq_len(res$G),
      Mean.Theta = round(as.numeric(res$obs_means), 3),
      SD = round(as.numeric(res$obs_sds), 3),
      `Growth from prev.` = c(NA, round(growth, 3)),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 4: Concordance Tables server ─────────────────────────────────

  conc_data <- reactiveVal(NULL)

  observeEvent(input$conc_go, {
    set.seed(sample(1:10000, 1))
    N   <- input$conc_n
    Kx  <- input$conc_k_x
    Ky  <- input$conc_k_y
    rho <- input$conc_rho
    method <- input$conc_method

    # True scores correlated between forms
    true_x <- rnorm(N, 0, 1)
    true_y <- rho * true_x + sqrt(1 - rho^2) * rnorm(N)

    # Observed scores: sum of Bernoulli items
    b_x <- seq(-2, 2, length.out = Kx)
    b_y <- seq(-2, 2, length.out = Ky)

    score_x <- rowSums(sapply(b_x, function(b) rbinom(N, 1, plogis(true_x - b))))
    score_y <- rowSums(sapply(b_y, function(b) rbinom(N, 1, plogis(true_y - b))))

    x_vals <- seq(0, Kx)
    y_vals <- seq(0, Ky)

    if (method == "linear") {
      # Linear equating: match first two moments
      mu_x <- mean(score_x); sd_x <- sd(score_x)
      mu_y <- mean(score_y); sd_y <- sd(score_y)
      eq_y <- (sd_y / sd_x) * (x_vals - mu_x) + mu_y
      eq_y <- pmax(0, pmin(Ky, eq_y))

      # SEE approximation for linear equating
      n_x <- N; n_y <- N
      see <- sqrt((sd_y / sd_x)^2 * (1 / n_x) * (1 + (x_vals - mu_x)^2 / (2 * (n_x - 1) * sd_x^2)))
    } else {
      # Equipercentile equating
      # Empirical CDFs
      ecdf_x <- ecdf(score_x)
      ecdf_y <- ecdf(score_y)

      # Map X percentiles onto Y distribution
      prctiles <- ecdf_x(x_vals)
      # Inverse CDF of Y
      eq_y <- quantile(score_y, probs = pmin(pmax(prctiles, 0.001), 0.999))
      eq_y <- pmax(0, pmin(Ky, as.numeric(eq_y)))

      # SEE: bootstrap approximation (simple)
      see <- sqrt(eq_y * (1 - eq_y / Ky) / N + 0.1)
    }

    conc_data(list(
      score_x = score_x, score_y = score_y,
      x_vals = x_vals, eq_y = eq_y, see = see,
      Kx = Kx, Ky = Ky, method = method, N = N
    ))
  })

  output$conc_eq_plot <- renderPlotly({
    d <- conc_data(); req(d)
    # Identity line (scaled)
    id_y <- d$x_vals * (d$Ky / d$Kx)

    plot_ly() |>
      add_trace(x = d$x_vals, y = d$eq_y + 1.96 * d$see,
                type = "scatter", mode = "lines",
                line = list(width = 0), showlegend = FALSE,
                hoverinfo = "skip", name = "upper") |>
      add_trace(x = d$x_vals, y = d$eq_y - 1.96 * d$see,
                type = "scatter", mode = "lines", fill = "tonexty",
                fillcolor = "rgba(38,139,210,0.15)",
                line = list(width = 0), showlegend = FALSE,
                hoverinfo = "skip", name = "95% CI band") |>
      add_trace(x = d$x_vals, y = id_y,
                type = "scatter", mode = "lines", name = "Identity (no diff.)",
                line = list(color = "#93a1a1", dash = "dash", width = 1.5),
                hoverinfo = "skip") |>
      add_trace(x = d$x_vals, y = d$eq_y,
                type = "scatter", mode = "lines", name = "Equating function",
                line = list(color = "#268bd2", width = 2.5),
                hoverinfo = "text",
                text = paste0("X = ", d$x_vals,
                              "<br>Y\u2019 = ", round(d$eq_y, 2),
                              "<br>SEE = ", round(d$see, 3))) |>
      layout(
        xaxis = list(title = "Form X score"),
        yaxis = list(title = "Equivalent Form Y score"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 10, b = 60)
      ) |> config(displayModeBar = FALSE)
  })

  output$conc_dist_plot <- renderPlotly({
    d <- conc_data(); req(d)
    plot_ly() |>
      add_trace(x = d$score_x, type = "histogram", name = "Form X",
                opacity = 0.6, nbinsx = d$Kx + 1,
                marker = list(color = "#268bd2")) |>
      add_trace(x = d$score_y, type = "histogram", name = "Form Y",
                opacity = 0.6, nbinsx = d$Ky + 1,
                marker = list(color = "#2aa198")) |>
      layout(
        barmode = "overlay",
        xaxis = list(title = "Raw Score"),
        yaxis = list(title = "Count"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 10, b = 60)
      ) |> config(displayModeBar = FALSE)
  })

  output$conc_table <- renderTable({
    d <- conc_data(); req(d)
    # Show every 5th score to keep table readable
    idx <- seq(1, length(d$x_vals), by = max(1, floor(length(d$x_vals) / 20)))
    data.frame(
      `Form X Score`        = d$x_vals[idx],
      `Equivalent Y Score`  = round(d$eq_y[idx], 2),
      `SEE`                 = round(d$see[idx], 3),
      `95% CI Lower`        = round(pmax(0, d$eq_y[idx] - 1.96 * d$see[idx]), 2),
      `95% CI Upper`        = round(pmin(d$Ky, d$eq_y[idx] + 1.96 * d$see[idx]), 2),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
