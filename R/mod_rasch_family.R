# Module: Rasch Family (consolidated)
# Tabs: Rasch Model | Many-Facet Rasch | Testlet Models

# ── UI ──────────────────────────────────────────────────────────────────
rasch_family_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Rasch Family",
  icon = icon("stairs"),
  navset_card_underline(

    # ── Tab 1: Rasch Model ────────────────────────────────────────────
    nav_panel(
      "Rasch Model",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("rasch_n"), "Number of persons", min = 50, max = 1000, value = 300, step = 50),
          sliderInput(ns("rasch_items"), "Number of items", min = 5, max = 30, value = 15, step = 1),
          sliderInput(ns("rasch_ability_sd"), "Ability SD", min = 0.5, max = 3, value = 1, step = 0.25),
          sliderInput(ns("rasch_misfit_items"), "Misfitting items", min = 0, max = 5, value = 2, step = 1),
          actionButton(ns("rasch_go"), "Simulate & Fit", class = "btn-success w-100 mb-2"),
          actionButton(ns("rasch_reset"), "Reset", class = "btn-outline-secondary w-100")
        ),
        explanation_box(
          tags$strong("Rasch Model"),
          tags$p("The Rasch (1PL) model is the simplest IRT model: P(correct) =
                  logistic(\u03b8 \u2212 b), where \u03b8 is person ability and b is
                  item difficulty. All items share equal discrimination. This yields
                  specific objectivity — person comparisons don't depend on which items
                  are used, and vice versa."),
          tags$p("Fit statistics (infit, outfit) detect items that do not conform to the
                  model. Infit is information-weighted and sensitive to unexpected responses
                  near the item\u2019s difficulty. Outfit is unweighted and sensitive to unexpected
                  responses far from the item\u2019s difficulty (often due to guessing or careless
                  errors). Values between 0.7 and 1.3 are typically acceptable for survey data;
                  tighter bounds (0.8\u20131.2) are used for high-stakes testing."),
          tags$p("The Wright map (person-item map) displays persons and items on a shared logit
                  scale, revealing targeting (whether items match the ability distribution) and
                  gaps (ability regions with no items providing information). A well-targeted test
                  has items spread across the ability range of the examinees."),
          tags$p("The Rasch model\u2019s key philosophical distinction from other IRT models is
                  that it treats the model as a prescription for good measurement, not merely
                  a description of data. Items that misfit are revised or removed, rather than
                  accommodated by adding parameters (as in 2PL/3PL). This leads to instruments
                  with interval-level measurement properties on the logit scale."),
          guide = tags$ol(
            tags$li("Set the number of persons, items, and ability spread."),
            tags$li("Add misfitting items to see how fit statistics detect them."),
            tags$li("Click 'Simulate & Fit' to generate Rasch data and estimate parameters."),
            tags$li("The Wright map shows person-item alignment."),
            tags$li("The fit statistics table flags items with poor fit (infit/outfit outside 0.7\u20131.3).")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Wright Map (Person-Item Map)"),
                 plotOutput(ns("rasch_wright_map"), height = "450px")),
            card(full_screen = TRUE, card_header("Item Fit Statistics"),
                 plotlyOutput(ns("rasch_fit_plot"), height = "450px"))
          ),
          card(card_header("Item Parameters & Fit"), tableOutput(ns("rasch_table")))
        )
      )
    ),

    # ── Tab 2: Many-Facet Rasch ───────────────────────────────────────
    nav_panel(
      "Many-Facet Rasch",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mfr_examinees"), "Examinees", min = 30, max = 200,
                      value = 80, step = 10),
          sliderInput(ns("mfr_items"), "Items (tasks)", min = 3, max = 10,
                      value = 5, step = 1),
          sliderInput(ns("mfr_raters"), "Raters", min = 3, max = 8,
                      value = 4, step = 1),
          sliderInput(ns("mfr_severity_sd"), "Rater severity SD",
                      min = 0, max = 2, value = 0.8, step = 0.1),
          checkboxInput(ns("mfr_bias"), "Add rater-specific bias (halo effect)", value = FALSE),
          actionButton(ns("mfr_go"), "Simulate", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Many-Facet Rasch Model"),
          tags$p("When performance is judged by raters, the Many-Facet Rasch Model (MFRM)
                  separates person ability, item difficulty, and rater severity onto
                  the same logit scale."),
          tags$p("log(P(X=1)/P(X=0)) = \u03b8_n - b_i - d_r, where d_r is rater severity."),
          tags$ul(
            tags$li(tags$strong("Rater severity:"), " How strict each rater is. Harsh raters have high
                    d_r, effectively raising the difficulty for all examinees they rate. MFRM
                    adjusts person estimates for rater severity, producing fair scores."),
            tags$li(tags$strong("Rater agreement:"), " How consistent raters are with each other.
                    Low agreement suggests raters interpret the rubric differently, warranting
                    additional training."),
            tags$li(tags$strong("Halo effect:"), " A rater\u2019s tendency to give uniformly high or low
                    ratings across all items for a given examinee, failing to differentiate
                    between easy and hard items.")
          ),
          tags$p("MFRM is widely used in performance assessments (essay scoring, oral exams,
                  clinical skill evaluations) where subjective judgment introduces an additional
                  source of measurement error. By modelling rater effects explicitly, MFRM
                  separates genuine ability differences from rater artefacts. The model can also
                  accommodate additional facets such as task difficulty or rating occasion."),
          guide = tags$ol(
            tags$li("Set the number of examinees, items, and raters."),
            tags$li("Increase severity SD to make raters more different."),
            tags$li("Toggle 'halo effect' to add rater-specific bias."),
            tags$li("Click 'Simulate' and examine the Wright-style variable map.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Rater Severity Map"),
               plotlyOutput(ns("mfr_map"), height = "400px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Rater Statistics"), tableOutput(ns("mfr_rater_stats"))),
            card(card_header("Inter-Rater Agreement"), tableOutput(ns("mfr_agreement")))
          )
        )
      )
    ),

    # ── Tab 3: Testlet Models ─────────────────────────────────────────
    nav_panel(
      "Testlet Models",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("tl_n"), "Examinees", min = 100, max = 500, value = 200, step = 50),
          sliderInput(ns("tl_testlets"), "Number of testlets", min = 3, max = 8,
                      value = 5, step = 1),
          sliderInput(ns("tl_items_per"), "Items per testlet", min = 3, max = 8,
                      value = 4, step = 1),
          sliderInput(ns("tl_dep"), "Local dependence strength (\u03c3_\u03b3)",
                      min = 0, max = 1.5, value = 0.5, step = 0.1),
          actionButton(ns("tl_go"), "Simulate", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Testlet Models"),
          tags$p("When items are grouped (e.g., items about the same reading passage),
                  responses within a testlet are locally dependent \u2014 violating the
                  standard IRT assumption. Testlet models add a random effect (\u03b3)
                  for each person-testlet combination."),
          tags$p("P(X=1) = logistic(a(\u03b8 + \u03b3 - b)), where \u03b3 ~ N(0, \u03c3\u00b2_\u03b3)."),
          tags$ul(
            tags$li(tags$strong("\u03c3_\u03b3 = 0:"), " Reduces to standard IRT (no local dependence). Items
                    within the testlet are conditionally independent given \u03b8."),
            tags$li(tags$strong("\u03c3_\u03b3 > 0:"), " Substantial local dependence. If ignored (using standard
                    IRT), reliability is overestimated, standard errors are underestimated, and
                    the test appears to provide more information than it actually does.")
          ),
          tags$p("Testlet effects arise naturally in reading comprehension tests (items about the
                  same passage), listening tests (items about the same audio clip), and any context
                  where a shared stimulus creates dependence among items. The testlet model is
                  mathematically equivalent to a bifactor model with a general factor (\u03b8) and
                  testlet-specific factors (\u03b3)."),
          tags$p("The practical consequence of ignoring testlet effects is that the test appears
                  to measure more precisely than it does. This can lead to misclassification
                  (pass/fail decisions) and over-confidence in score interpretations. Testlet
                  models produce more honest standard errors and reliability estimates."),
          guide = tags$ol(
            tags$li("Set the number of testlets, items per testlet, and dependence strength."),
            tags$li("Click 'Simulate' to generate data."),
            tags$li("Compare reliability estimates: ignoring vs. accounting for local dependence."),
            tags$li("Increase \u03c3_\u03b3 to see how ignoring testlet effects inflates \u03b1.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Within-Testlet Correlations"),
               plotlyOutput(ns("tl_corr"), height = "350px")),
          card(card_header("Reliability Comparison"), tableOutput(ns("tl_reliability"))),
          card(card_header("Testlet Variance Components"), tableOutput(ns("tl_variance")))
        )
      )
    ),

    # ── Tab 4: Guttman Scalogram ─────────────────────────────────────
    nav_panel(
      "Guttman Scalogram",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gss_n"), "Persons", min = 10, max = 60, value = 20, step = 5),
          sliderInput(ns("gss_k"), "Items", min = 4, max = 15, value = 8, step = 1),
          sliderInput(ns("gss_noise"), "Response noise (0 = perfect scale)",
                      min = 0, max = 0.5, value = 0.1, step = 0.05),
          selectInput(ns("gss_sort"), "Sort order",
                      choices = c("Person score (descending)" = "person",
                                  "Item difficulty (ascending)" = "item",
                                  "Both (canonical)" = "both")),
          actionButton(ns("gss_go"), "Generate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Guttman Scalogram"),
          tags$p("A Guttman scale (cumulative scale) assumes items form a perfect
                  hierarchy: if a person answers item j correctly, they also answer
                  all easier items correctly. Persons and items can be arranged into
                  a triangular pattern of 1s and 0s with no errors."),
          tags$p("In practice, real data deviate from this ideal. A scalogram
                  visualises how close a response matrix comes to the perfect triangular
                  pattern. Errors (unexpected responses) appear as isolated 1s in the
                  lower-right triangle or 0s in the upper-left triangle."),
          tags$p("The Coefficient of Reproducibility (CR) quantifies fit:
                  CR = 1 \u2212 (errors / total responses). CR \u2265 0.90 is the
                  conventional threshold for accepting a Guttman scale. The
                  Minimum Marginal Reproducibility (MMR) is a baseline accounting
                  for the marginal proportions, and the Coefficient of Scalability
                  (CS) = (CR \u2212 MMR) / (1 \u2212 MMR) adjusts for it."),
          tags$p("Loevinger's H coefficient, used in Mokken scaling, is a related
                  probabilistic generalisation that relaxes the strict deterministic
                  requirement of the Guttman model. Mokken scaling assumes only that
                  items are stochastically ordered (items with higher difficulty have a
                  higher expected score for any given person), making it a useful middle
                  ground between the strict Guttman model and full parametric IRT.
                  Items with H \u2265 0.40 are considered scalable; H \u2265 0.50
                  indicates a strong scale."),
          tags$p("The Guttman scalogram is also related to the Rasch model: both
                  require a strict item hierarchy, but the Rasch model makes this
                  probabilistic rather than deterministic. A perfectly fitting Rasch
                  dataset would, on average, produce a near-perfect scalogram. Guttman
                  errors in the scalogram therefore correspond to Rasch misfit \u2014
                  the scalogram visualises what Rasch fit statistics capture numerically."),
          guide = tags$ol(
            tags$li("Set persons, items, and noise level."),
            tags$li("Click 'Generate' to simulate responses and sort them canonically."),
            tags$li("Blue = correct (1), white = incorrect (0). Red cells = Guttman errors."),
            tags$li("Increase noise to see CR and CS decline and more red errors appear.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Scalogram"),
               plotlyOutput(ns("gss_plot"), height = "480px")),
          card(card_header("Scale Statistics"), tableOutput(ns("gss_stats")))
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

rasch_family_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Rasch Model ─────────────────────────────────────────────────────
  rasch_data <- reactiveVal(NULL)

  observeEvent(input$rasch_reset, {
    updateSliderInput(session, "rasch_n", value = 300)
    updateSliderInput(session, "rasch_items", value = 15)
    updateSliderInput(session, "rasch_ability_sd", value = 1)
    updateSliderInput(session, "rasch_misfit_items", value = 2)
    rasch_data(NULL)
  })

  observeEvent(input$rasch_go, {
    set.seed(sample(1:10000, 1))
    n <- input$rasch_n; k <- input$rasch_items
    ab_sd <- input$rasch_ability_sd
    n_misfit <- min(input$rasch_misfit_items, k)

    theta <- rnorm(n, 0, ab_sd)
    b <- seq(-2, 2, length.out = k)
    misfit_items <- if (n_misfit > 0) sample(seq_len(k), n_misfit) else integer(0)

    dat <- matrix(0L, n, k)
    for (j in seq_len(k)) {
      if (j %in% misfit_items) {
        p <- 0.2 + 0.6 / (1 + exp(-(theta - b[j])))
      } else {
        p <- 1 / (1 + exp(-(theta - b[j])))
      }
      dat[, j] <- rbinom(n, 1, p)
    }
    colnames(dat) <- paste0("Item", seq_len(k))

    total <- rowSums(dat)
    p_vals <- colMeans(dat)
    p_clamped <- pmin(pmax(p_vals, 0.01), 0.99)
    b_hat <- -log(p_clamped / (1 - p_clamped))

    prop_correct <- total / k
    prop_correct <- pmin(pmax(prop_correct, 0.01), 0.99)
    theta_hat <- log(prop_correct / (1 - prop_correct))
    b_hat <- b_hat - mean(b_hat)

    fit_stats <- data.frame(Item = paste0("Item", seq_len(k)),
                             b_est = round(b_hat, 3), b_true = round(b, 3),
                             Infit = NA_real_, Outfit = NA_real_,
                             Misfit = ifelse(seq_len(k) %in% misfit_items, "Yes", ""),
                             stringsAsFactors = FALSE)

    for (j in seq_len(k)) {
      e_ij <- 1 / (1 + exp(-(theta_hat - b_hat[j])))
      r_ij <- dat[, j] - e_ij
      v_ij <- e_ij * (1 - e_ij)
      z_ij <- r_ij / sqrt(pmax(v_ij, 0.001))
      fit_stats$Outfit[j] <- round(mean(z_ij^2), 3)
      fit_stats$Infit[j] <- round(sum(r_ij^2) / sum(v_ij), 3)
    }

    rasch_data(list(
      fit_stats = fit_stats, theta_hat = theta_hat, b_hat = b_hat,
      b_true = b, misfit_items = misfit_items, k = k
    ))
  })

  output$rasch_wright_map <- renderPlot(bg = "transparent", {
    res <- rasch_data(); req(res)
    dark <- isTRUE(session$userData$dark_mode)
    bg_col <- "transparent"
    fg_col <- if (dark) "#839496" else "#657b83"
    axis_col <- if (dark) "#586e75" else "#93a1a1"

    par(mar = c(4, 4, 3, 4), bg = bg_col, fg = fg_col,
        col.axis = axis_col, col.lab = fg_col, col.main = fg_col)

    h <- hist(res$theta_hat, breaks = 30, plot = FALSE)
    max_count <- max(h$counts)

    plot(NULL, xlim = c(-max_count * 1.1, max_count * 1.1),
         ylim = range(c(res$theta_hat, res$b_hat)) + c(-0.5, 0.5),
         xlab = "", ylab = "Logits", main = "Wright Map (Person-Item Map)",
         xaxt = "n")

    rect(-h$counts, h$breaks[-length(h$breaks)], 0, h$breaks[-1],
         col = adjustcolor("#238b45", 0.5), border = bg_col)
    mtext("Persons", side = 1, at = -max_count / 2, line = 1, cex = 0.9, col = fg_col)

    item_cols <- ifelse(seq_along(res$b_hat) %in% res$misfit_items, "#e31a1c", "#41ae76")
    segments(0.5, res$b_hat, max_count * 0.3, res$b_hat, col = item_cols, lwd = 2)
    text(max_count * 0.35, res$b_hat, paste0("I", seq_along(res$b_hat)),
         cex = 0.7, col = item_cols, adj = 0)
    mtext("Items", side = 1, at = max_count / 2, line = 1, cex = 0.9, col = fg_col)

    abline(v = 0, lty = 2, col = if (dark) "grey50" else "grey60")

    legend("topleft",
           legend = c("Persons", "Fitting items", "Misfitting items"),
           fill   = c(adjustcolor("#238b45", 0.5), "#41ae76", "#e31a1c"),
           border = NA, bty = "n", cex = 0.75, text.col = fg_col)
  })

  output$rasch_fit_plot <- renderPlotly({
    res <- rasch_data(); req(res)
    df <- res$fit_stats
    df$Item <- factor(df$Item, levels = df$Item)
    df$Flag <- ifelse(df$Infit < 0.7 | df$Infit > 1.3 | df$Outfit < 0.7 | df$Outfit > 1.3,
                       "Misfit", "OK")

    df_long <- rbind(
      data.frame(Item = df$Item, Value = df$Infit, Stat = "Infit", Flag = df$Flag),
      data.frame(Item = df$Item, Value = df$Outfit, Stat = "Outfit", Flag = df$Flag)
    )
    df_long$text <- paste0(df_long$Item,
                           "<br>", df_long$Stat, " = ", round(df_long$Value, 3),
                           "<br>Status: ", df_long$Flag,
                           "<br>Range: 0.7\u20131.3")

    y_max <- max(2, max(df_long$Value) * 1.1)
    items_chr <- as.character(df$Item)
    stats <- c("Infit", "Outfit")

    shown_ok <- FALSE; shown_misfit <- FALSE
    subplots <- lapply(stats, function(stat) {
      d <- df_long[df_long$Stat == stat, ]
      colors <- ifelse(d$Flag == "OK", "#238b45", "#e31a1c")
      p <- plot_ly()
      for (j in seq_len(nrow(d))) {
        flag <- as.character(d$Flag[j])
        sl <- FALSE
        if (flag == "OK" && !shown_ok) { sl <- TRUE; shown_ok <<- TRUE }
        if (flag == "Misfit" && !shown_misfit) { sl <- TRUE; shown_misfit <<- TRUE }
        p <- p |> add_bars(x = as.character(d$Item[j]), y = d$Value[j],
                            text = d$text[j], textposition = "none",
                            hoverinfo = "text", name = flag,
                            marker = list(color = colors[j], opacity = 0.8),
                            legendgroup = flag, showlegend = sl)
      }
      p |> layout(
        xaxis = list(title = "", tickangle = -45,
                     categoryorder = "array", categoryarray = items_chr),
        yaxis = list(title = "Mean Square", range = c(0, y_max)),
        annotations = list(
          list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
               text = stat, showarrow = FALSE, font = list(size = 12))
        )
      )
    })
    subplot(subplots, nrows = 1, shareY = TRUE, titleX = TRUE) |>
      layout(
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.08),
        shapes = list(
          list(type = "line", y0 = 0.7, y1 = 0.7, x0 = 0, x1 = 1,
               xref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1)),
          list(type = "line", y0 = 1.3, y1 = 1.3, x0 = 0, x1 = 1,
               xref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1)),
          list(type = "line", y0 = 1.0, y1 = 1.0, x0 = 0, x1 = 1,
               xref = "paper", line = list(color = "grey50", width = 1))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = 0.7,
               text = "Lower (0.7)", showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c")),
          list(x = 1.02, xref = "paper", y = 1.3,
               text = "Upper (1.3)", showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c")),
          list(x = 1.02, xref = "paper", y = 1.0,
               text = "Expected", showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "grey50"))
        )
      )
  })

  output$rasch_table <- renderTable({
    res <- rasch_data(); req(res); res$fit_stats
  }, hover = TRUE, spacing = "s")

  # ── Many-Facet Rasch ────────────────────────────────────────────────
  mfr_data <- reactiveVal(NULL)

  observeEvent(input$mfr_go, {
    N <- input$mfr_examinees; J <- input$mfr_items; R <- input$mfr_raters
    sev_sd <- input$mfr_severity_sd; bias <- input$mfr_bias
    set.seed(sample.int(10000, 1))

    theta <- rnorm(N, 0, 1)
    b <- sort(runif(J, -1.5, 1.5))
    d <- rnorm(R, 0, sev_sd)

    ratings <- array(NA, dim = c(N, J, R))
    for (r in seq_len(R)) {
      for (j in seq_len(J)) {
        lp <- theta - b[j] - d[r]
        if (bias) lp <- lp + rnorm(N, 0, 0.3)
        p <- 1 / (1 + exp(-lp))
        ratings[, j, r] <- rbinom(N, 1, p)
      }
    }

    rater_means <- sapply(seq_len(R), function(r) mean(ratings[, , r], na.rm = TRUE))
    rater_severity <- -qlogis(rater_means)

    kappa_pairs <- numeric(0)
    for (r1 in seq_len(R - 1)) {
      for (r2 in (r1 + 1):R) {
        x1 <- as.vector(ratings[, , r1])
        x2 <- as.vector(ratings[, , r2])
        tb <- table(x1, x2)
        po <- sum(diag(tb)) / sum(tb)
        pe <- sum(rowSums(tb) * colSums(tb)) / sum(tb)^2
        kappa <- (po - pe) / (1 - pe)
        kappa_pairs <- c(kappa_pairs, kappa)
      }
    }

    mfr_data(list(theta = theta, b = b, d = d, rater_means = rater_means,
                  rater_severity = rater_severity, kappa_pairs = kappa_pairs,
                  R = R, J = J, N = N))
  })

  output$mfr_map <- renderPlotly({
    res <- mfr_data()
    req(res)

    plotly::plot_ly() |>
      plotly::add_markers(
        x = rep(1, res$R), y = res$d,
        marker = list(color = "#e31a1c", size = 12, symbol = "diamond"),
        name = "Rater severity",
        hoverinfo = "text",
        text = paste0("Rater ", seq_len(res$R),
                       "<br>Severity = ", round(res$d, 2),
                       "<br>Mean rating = ", round(res$rater_means, 3))
      ) |>
      plotly::add_markers(
        x = rep(2, res$J), y = res$b,
        marker = list(color = "#3182bd", size = 10, symbol = "triangle-up"),
        name = "Item difficulty",
        hoverinfo = "text",
        text = paste0("Item ", seq_len(res$J), "<br>b = ", round(res$b, 2))
      ) |>
      plotly::add_markers(
        x = rep(3, res$N), y = res$theta,
        marker = list(color = "rgba(35,139,69,0.3)", size = 5),
        name = "Person ability",
        hoverinfo = "text",
        text = paste0("\u03b8 = ", round(res$theta, 2))
      ) |>
      plotly::layout(
        xaxis = list(title = "", tickvals = 1:3,
                     ticktext = c("Rater Severity", "Item Difficulty", "Person Ability"),
                     range = c(0.5, 3.5)),
        yaxis = list(title = "Logits"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mfr_rater_stats <- renderTable({
    res <- mfr_data(); req(res)
    data.frame(
      Rater = seq_len(res$R),
      Severity = round(res$d, 3),
      `Mean Rating` = round(res$rater_means, 3),
      `Severity Estimate` = round(res$rater_severity, 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$mfr_agreement <- renderTable({
    res <- mfr_data(); req(res)
    data.frame(
      Metric = c("Mean Cohen's \u03ba", "Min \u03ba", "Max \u03ba", "Rater pairs"),
      Value = c(round(mean(res$kappa_pairs), 3),
                round(min(res$kappa_pairs), 3),
                round(max(res$kappa_pairs), 3),
                length(res$kappa_pairs))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Testlet Models ──────────────────────────────────────────────────
  tl_data <- reactiveVal(NULL)

  observeEvent(input$tl_go, {
    n <- input$tl_n; nt <- input$tl_testlets; ni <- input$tl_items_per
    sig_gamma <- input$tl_dep
    set.seed(sample.int(10000, 1))

    J <- nt * ni
    a <- runif(J, 0.8, 2.0)
    b <- sort(runif(J, -2, 2))
    theta <- rnorm(n)

    gamma <- matrix(rnorm(n * nt, 0, sig_gamma), n, nt)

    X <- matrix(0, n, J)
    testlet_id <- rep(seq_len(nt), each = ni)
    for (j in seq_len(J)) {
      t_idx <- testlet_id[j]
      p <- 1 / (1 + exp(-a[j] * (theta + gamma[, t_idx] - b[j])))
      X[, j] <- rbinom(n, 1, p)
    }
    colnames(X) <- paste0("T", testlet_id, "_I", rep(seq_len(ni), nt))

    Cx <- cov(X)
    k <- ncol(Cx)
    alpha_standard <- (k / (k - 1)) * (1 - sum(diag(Cx)) / sum(Cx))

    testlet_scores <- matrix(0, n, nt)
    for (t in seq_len(nt)) {
      cols <- which(testlet_id == t)
      testlet_scores[, t] <- rowSums(X[, cols])
    }
    Ct <- cov(testlet_scores)
    alpha_testlet <- (nt / (nt - 1)) * (1 - sum(diag(Ct)) / sum(Ct))

    within_cors <- numeric(nt)
    for (t in seq_len(nt)) {
      cols <- which(testlet_id == t)
      if (length(cols) >= 2) {
        cm <- cor(X[, cols])
        within_cors[t] <- mean(cm[lower.tri(cm)])
      }
    }

    between_cor <- cor(testlet_scores)
    avg_between <- mean(between_cor[lower.tri(between_cor)])

    tl_data(list(within_cors = within_cors, avg_between = avg_between,
                 alpha_standard = alpha_standard, alpha_testlet = alpha_testlet,
                 sig_gamma = sig_gamma, nt = nt, ni = ni, J = J,
                 testlet_id = testlet_id))
  })

  output$tl_corr <- renderPlotly({
    res <- tl_data()
    req(res)
    plotly::plot_ly(
      x = paste0("Testlet ", seq_len(res$nt)),
      y = res$within_cors,
      type = "bar",
      marker = list(color = "#238b45"),
      hoverinfo = "text",
      text = paste0("Testlet ", seq_len(res$nt),
                     "<br>Avg within-r = ", round(res$within_cors, 3))
    ) |> plotly::layout(
      xaxis = list(title = "Testlet"),
      yaxis = list(title = "Average Within-Testlet Correlation"),
      shapes = list(list(type = "line", x0 = -0.5, x1 = res$nt - 0.5,
                         y0 = res$avg_between, y1 = res$avg_between,
                         line = list(color = "#e31a1c", dash = "dash", width = 2))),
      annotations = list(list(x = 0.5, y = res$avg_between,
                               text = paste0("Avg between = ", round(res$avg_between, 3)),
                               showarrow = FALSE, xref = "paper",
                               font = list(color = "#e31a1c", size = 11),
                               yanchor = "bottom")),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$tl_reliability <- renderTable({
    res <- tl_data(); req(res)
    data.frame(
      Method = c("Standard \u03b1 (ignoring testlets)",
                  "Testlet-level \u03b1 (using testlet parcels)"),
      Alpha = round(c(res$alpha_standard, res$alpha_testlet), 3),
      Note = c(if (res$sig_gamma > 0) "Inflated due to local dependence" else "Unbiased",
               "More appropriate when testlet effects exist"),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$tl_variance <- renderTable({
    res <- tl_data(); req(res)
    data.frame(
      Component = c("\u03c3\u00b2_\u03b3 (testlet effect)", "Items per testlet",
                     "Total items", "Testlets"),
      Value = c(round(res$sig_gamma^2, 3), res$ni, res$J, res$nt)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 4: Guttman Scalogram server ──────────────────────────────────

  gss_data <- reactiveVal(NULL)

  observeEvent(input$gss_go, {
    set.seed(sample(1:10000, 1))
    N <- input$gss_n; K <- input$gss_k; noise <- input$gss_noise

    # Item difficulties evenly spread
    b <- seq(-2, 2, length.out = K)
    # Person abilities
    theta <- rnorm(N, 0, 1)

    # Perfect Guttman responses + noise
    resp <- matrix(0L, N, K)
    for (j in seq_len(K)) {
      p_correct <- ifelse(theta >= b[j], 1 - noise, noise)
      resp[, j] <- rbinom(N, 1, p_correct)
    }

    gss_data(list(resp = resp, theta = theta, b = b, N = N, K = K, noise = noise))
  })

  # Sort and annotate the response matrix
  gss_sorted <- reactive({
    d <- gss_data(); req(d)
    sort_type <- input$gss_sort
    resp <- d$resp

    # Sort items by difficulty (ascending p-correct)
    item_order <- order(colMeans(resp), decreasing = TRUE)
    resp <- resp[, item_order]

    # Sort persons by total score (descending)
    person_order <- order(rowSums(resp), decreasing = TRUE)
    resp <- resp[person_order, ]

    # Compute expected (perfect Guttman) pattern
    row_scores <- rowSums(resp)
    expected <- matrix(0L, d$N, d$K)
    for (i in seq_len(d$N)) {
      expected[i, seq_len(row_scores[i])] <- 1L
    }

    errors <- (resp != expected)
    list(resp = resp, expected = expected, errors = errors,
         item_order = item_order, person_order = person_order)
  })

  output$gss_plot <- renderPlotly({
    d <- gss_data(); req(d)
    s <- gss_sorted(); req(s)

    N <- d$N; K <- d$K
    resp  <- s$resp
    errors <- s$errors

    # Build z matrix: 0 = incorrect, 1 = correct, 2 = guttman error
    z_mat <- resp
    z_mat[errors] <- 2L

    # Color mapping: 0="#eee8d5", 1="#4575b4", 2="#d73027"
    colorscale <- list(c(0, "#eee8d5"), c(0.5, "#4575b4"), c(1, "#d73027"))

    hover_mat <- matrix(
      paste0("Person P", rep(seq_len(N), K), " × Item I", rep(seq_len(K), each = N),
             "<br>", ifelse(as.vector(errors), "Guttman Error",
                            ifelse(as.vector(resp) == 1, "Correct", "Incorrect"))),
      nrow = N)

    plotly::plot_ly(
      z = z_mat, x = paste0("I", seq_len(K)), y = paste0("P", seq_len(N)),
      type = "heatmap",
      colorscale = colorscale,
      showscale = FALSE, xgap = 1, ygap = 1,
      hoverinfo = "text", text = hover_mat
    ) |>
      plotly::layout(
        xaxis = list(title = "Items (easy → hard)", tickangle = -45),
        yaxis = list(title = "Persons (high → low score)", autorange = "reversed"),
        annotations = list(
          list(x = 0.5, y = -0.12, xref = "paper", yref = "paper",
               text = "Blue = Correct | White = Incorrect | Red = Guttman Error",
               showarrow = FALSE, font = list(size = 11, color = "#657b83"))
        ),
        margin = list(t = 20, b = 80)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$gss_stats <- renderTable({
    d <- gss_data(); req(d)
    s <- gss_sorted(); req(s)

    total_resp  <- d$N * d$K
    n_errors    <- sum(s$errors)
    cr          <- 1 - n_errors / total_resp

    # MMR: based on modal response (majority 0 or 1) per item
    p_items <- colMeans(s$resp)
    mmr     <- 1 - sum(pmin(p_items, 1 - p_items)) / d$K
    cs      <- if (mmr < 1) (cr - mmr) / (1 - mmr) else NA

    data.frame(
      Statistic = c("Persons", "Items", "Total responses", "Guttman errors",
                    "Coeff. of Reproducibility (CR)", "Min. Marginal Reprod. (MMR)",
                    "Coeff. of Scalability (CS)"),
      Value = c(d$N, d$K, total_resp, n_errors,
                sprintf("%.3f", cr), sprintf("%.3f", mmr),
                ifelse(is.na(cs), "—", sprintf("%.3f", cs)))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
