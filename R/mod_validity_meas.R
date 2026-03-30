# Module: Validity & Measurement Models (consolidated)
# Tabs: Validity Evidence | CFA & Invariance

# ── UI ──────────────────────────────────────────────────────────────────
mod_validity_meas_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Validity & Measurement",
  icon = icon("check-double"),
  navset_card_underline(

    # ── Tab 1: Validity Evidence ─────────────────────────────────
    nav_panel(
      "Validity Evidence",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            tags$h6("MTMM Design"),
            sliderInput(ns("val_traits"), "Number of traits", min = 2, max = 4, value = 3, step = 1),
            sliderInput(ns("val_methods"), "Number of methods", min = 2, max = 4, value = 3, step = 1),
            sliderInput(ns("val_n"), "Sample size", min = 100, max = 1000, value = 300, step = 50),
            tags$hr(),
            sliderInput(ns("val_trait_cor"), "True trait correlation", min = 0.1, max = 0.8,
                        value = 0.3, step = 0.05),
            sliderInput(ns("val_method_cor"), "Method effect strength", min = 0, max = 0.6,
                        value = 0.2, step = 0.05),
            sliderInput(ns("val_convergent"), "Convergent validity (same trait)", min = 0.3, max = 0.95,
                        value = 0.7, step = 0.05),
            actionButton(ns("val_go"), "Generate MTMM", class = "btn-success w-100 mb-2"),
            actionButton(ns("val_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          explanation_box(
            tags$strong("Validity Evidence: MTMM Matrix"),
            tags$p("The Multitrait-Multimethod (MTMM) matrix, proposed by Campbell & Fiske (1959),
                    assesses construct validity by measuring multiple traits with multiple methods.
                    Good validity evidence requires: (1) high convergent validity (same trait,
                    different methods correlate strongly), (2) low discriminant correlations
                    (different traits should correlate less than same traits), and (3) small
                    method effects."),
            tags$p("The matrix is organized so you can compare monotrait-heteromethod (convergent),
                    heterotrait-monomethod (method effects), and heterotrait-heteromethod blocks."),
          tags$p("The MTMM matrix evaluates construct validity by examining convergent and
                  discriminant evidence simultaneously. Convergent validity is demonstrated when
                  different methods measuring the same trait correlate highly (monotrait-heteromethod
                  values). Discriminant validity is demonstrated when the same method measuring
                  different traits does not correlate too highly (heterotrait-monomethod values)."),
          tags$p("If method effects dominate (high heterotrait-monomethod correlations), the
                  measurements may reflect the method of assessment more than the trait being
                  measured. CFA-based MTMM models can formally decompose variance into trait,
                  method, and error components."),
            guide = tags$ol(
              tags$li("Set the number of traits and methods for the MTMM design."),
              tags$li("Adjust convergent validity and method effect strength."),
              tags$li("Click 'Generate MTMM' to simulate data and compute the matrix."),
              tags$li("The heatmap highlights convergent (diagonal) vs. discriminant blocks."),
              tags$li("Compare convergent coefficients (should be high) with heterotrait values (should be lower).")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("MTMM Correlation Matrix"),
                 plotlyOutput(ns("val_mtmm_plot"), height = "450px")),
            layout_column_wrap(
              width = 1 / 2,
              card(card_header("Validity Summary"), uiOutput(ns("val_summary"))),
              card(full_screen = TRUE, card_header("Convergent vs. Discriminant"),
                   plotlyOutput(ns("val_bar_plot"), height = "320px"))
            )
          )
        )
    ),

    # ── Tab 2: CFA & Invariance ──────────────────────────────────
    nav_panel(
      "CFA & Invariance",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            tags$h6("Data Generation"),
            sliderInput(ns("cfa_n"), "N per group", min = 50, max = 500, value = 200, step = 50),
            sliderInput(ns("cfa_items"), "Items per factor", min = 3, max = 6, value = 4, step = 1),
            sliderInput(ns("cfa_factors"), "Number of factors", min = 1, max = 3, value = 2, step = 1),
            tags$hr(),
            tags$h6("Non-invariance (Group 2 shift)"),
            sliderInput(ns("cfa_loading_shift"), "Loading difference", min = 0, max = 0.3,
                        value = 0, step = 0.05),
            sliderInput(ns("cfa_intercept_shift"), "Intercept difference", min = 0, max = 0.5,
                        value = 0, step = 0.1),
            tags$hr(),
            actionButton(ns("cfa_go"), "Simulate & Test", class = "btn-success w-100 mb-2"),
            actionButton(ns("cfa_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          fillable = FALSE,
          div(
            explanation_box(
              tags$strong("CFA & Measurement Invariance"),
              tags$p("Confirmatory Factor Analysis (CFA) tests whether a hypothesized factor
                      structure fits the observed data. Measurement invariance tests whether
                      a measurement instrument functions equivalently across groups (e.g.,
                      gender, country). This is essential before comparing latent means."),
              tags$p("Invariance is tested in a hierarchy: (1) Configural — same factor
                      structure; (2) Metric (weak) — equal factor loadings; (3) Scalar (strong) —
                      equal intercepts; (4) Strict — equal residual variances. Each level is
                      compared to the previous using \u0394CFI (\u2264 0.01) and \u0394RMSEA
                      (\u2264 0.015) criteria."),
          tags$p("Measurement invariance is essential for meaningful group comparisons. If the
                  measurement model differs across groups, observed score differences may reflect
                  measurement artefacts rather than true differences in the construct. Testing
                  proceeds through a hierarchy: configural (same structure), metric (same loadings),
                  scalar (same intercepts), and strict (same residual variances). Scalar invariance
                  is the minimum requirement for comparing group means."),
          tags$p("In practice, partial invariance (allowing a few items to vary across groups)
                  is often acceptable when full invariance is not achieved. The key question is
                  whether the non-invariant items substantially affect the conclusions."),
              guide = tags$ol(
                tags$li("Set the number of items per factor and number of factors."),
                tags$li("Keep shifts at 0 to see invariance hold, or increase them to violate it."),
                tags$li("Click 'Simulate & Test' to generate two-group data and run the invariance sequence."),
                tags$li("The table shows fit indices at each level and whether invariance holds."),
                tags$li("The path diagram shows the CFA structure with standardized loadings."),
                tags$li("The loading comparison compares estimated loadings across groups."),
                tags$li("Try small shifts (0.05-0.1) to see partial invariance scenarios.")
              )
            ),
            card(
              card_header("Invariance Testing Sequence"),
              uiOutput(ns("cfa_table")),
              style = "max-height: 260px; overflow-y: auto;"
            ),
            layout_column_wrap(
              width = 1 / 2,
              card(
                full_screen = TRUE,
                card_header("CFA Path Diagram"),
                plotly::plotlyOutput(ns("cfa_path_diagram"), height = "420px")
              ),
              card(
                full_screen = TRUE,
                card_header("Factor Loadings by Group"),
                plotly::plotlyOutput(ns("cfa_loadings_plot"), height = "420px")
              )
            ),
            card(
              card_header("CFA Fit Summary"),
              uiOutput(ns("cfa_fit_text"))
            )
          )
        )
    ),

    # ── Tab 3: Criterion Validity & ROC ──────────────────────────────
    nav_panel(
      "Criterion Validity & ROC",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("val_roc_n"), "Sample size", min = 100, max = 1000, value = 400, step = 100),
          sliderInput(ns("val_roc_prev"), "Prevalence (base rate)", min = 0.05, max = 0.60,
                      value = 0.25, step = 0.05),
          sliderInput(ns("roc_r"), "Criterion validity (r)", min = 0.10, max = 0.90,
                      value = 0.55, step = 0.05),
          sliderInput(ns("val_roc_threshold"), "Classification threshold (percentile)",
                      min = 5, max = 95, value = 50, step = 5),
          actionButton(ns("roc_go"), "Simulate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Criterion Validity & ROC Analysis"),
          tags$p("Criterion validity is the correlation between a test score and an
                  external outcome. But the practical usefulness of a test also depends
                  on the base rate (prevalence) of the criterion and the chosen cut-score.
                  ROC analysis separates the test's intrinsic discriminability from the
                  cut-score decision."),
          tags$p("The ROC curve plots sensitivity (true positive rate) against 1 \u2212
                  specificity (false positive rate) across all possible thresholds. The
                  Area Under the Curve (AUC) is a threshold-free measure of discrimination:
                  0.5 = chance, 1.0 = perfect. AUC can be interpreted as the probability
                  that a randomly chosen positive case scores higher than a randomly chosen
                  negative case."),
          tags$p("The confusion matrix and derived statistics (sensitivity, specificity,
                  PPV, NPV) depend heavily on prevalence. High prevalence inflates PPV;
                  low prevalence deflates it. A test that performs well in a clinical
                  setting may appear weak in a low-prevalence general population screen."),
          tags$p("Incremental validity asks whether a new test adds predictive value beyond
                  what is already captured by existing measures. A test with a validity
                  coefficient of r = 0.40 may still add little if another predictor already
                  explains most of the criterion variance. Evaluating incremental validity
                  requires examining the semi-partial correlation after partialling out
                  existing predictors, not just the zero-order correlation."),
          tags$p("Statistical significance of a validity coefficient should not be confused
                  with practical utility. With large samples, even r = 0.05 is statistically
                  significant, yet explains only 0.25% of criterion variance. Conversely, a
                  meaningful validity coefficient (r \u2265 0.30) can be non-significant in
                  small validation studies. Confidence intervals around the validity coefficient
                  and utility analysis (expected gain in criterion scores) provide a more
                  complete picture of a test's value."),
          guide = tags$ol(
            tags$li("Adjust validity (r) and base rate (prevalence) to set up the scenario."),
            tags$li("Click 'Simulate' to generate test scores and criterion status."),
            tags$li("Move the threshold slider to see how sensitivity/specificity trade off."),
            tags$li("Note how PPV and NPV change with prevalence, even at fixed sensitivity.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("ROC Curve"),
                 plotlyOutput(ns("roc_curve"), height = "380px")),
            card(full_screen = TRUE, card_header("Score Distributions by Group"),
                 plotlyOutput(ns("roc_density"), height = "380px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Confusion Matrix & Statistics"), tableOutput(ns("roc_stats"))),
            card(full_screen = TRUE, card_header("PPV & NPV vs. Prevalence"),
                 plotlyOutput(ns("roc_prev_plot"), height = "300px"))
          )
        )
      )
    ),

    # ── Tab 4: Formative vs. Reflective Models ───────────────────────
    nav_panel(
      "Formative vs. Reflective",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("fvr_n"),        "Sample size",   min = 100, max = 1000, value = 400, step = 100),
          sliderInput(ns("fvr_items"),    "Indicators",    min = 3,   max = 8,    value = 5,   step = 1),
          sliderInput(ns("fvr_loading"),  "Reflective loading (\u03bb)", min = 0.3, max = 0.95, value = 0.70, step = 0.05),
          sliderInput(ns("fvr_formative_r"), "Formative predictor correlation", min = 0.0, max = 0.7, value = 0.3, step = 0.05),
          actionButton(ns("fvr_go"), "Simulate", class = "btn-success w-100 mb-2")
        ),
        explanation_box(
          tags$strong("Formative vs. Reflective Measurement Models"),
          tags$p("In a ", tags$b("reflective model"), ", a latent construct causes the
                  indicators. Removing an item does not change the construct; items
                  should be interchangeable, highly correlated, and have similar loadings.
                  Most psychometric scales (personality, ability) are reflective."),
          tags$p("In a ", tags$b("formative model"), ", the indicators define and cause the
                  construct. Items need not correlate \u2014 socioeconomic status, for
                  example, is formed by income, education, and occupation, which can vary
                  independently. Removing an indicator changes what is measured."),
          tags$p("Confusing the two leads to serious errors: applying Cronbach's \u03b1
                  to a formative scale is meaningless (low \u03b1 does not indicate poor
                  reliability). CFA fit indices are also inappropriate for formative models.
                  The key diagnostic question is: does the construct cause the indicators
                  (reflective), or do the indicators define the construct (formative)?"),
          tags$p("Practical heuristics can help distinguish the two. Ask: if you removed one
                  indicator, would the construct still exist conceptually? If yes (as with
                  anxiety symptoms), the model is likely reflective. If the construct would
                  be incomplete without that indicator (as with components of quality of life),
                  it is likely formative. Another clue: would changing the construct score
                  logically cause a change in the indicator? If so, the model is reflective."),
          tags$p("In structural equation modeling, formative constructs are treated as
                  composites with fixed residuals and require external identification
                  (at least two reflective indicators as \u2018effect\u2019 indicators, or
                  a direct path to an outcome). Without proper identification, formative
                  models are under-identified and cannot be estimated. Many scales in
                  psychology and health research are mislabeled as reflective when their
                  item content is actually formative, leading to inappropriate use of
                  internal consistency as a quality criterion."),
          guide = tags$ol(
            tags$li("Adjust loading strength (reflective) and predictor correlations (formative)."),
            tags$li("Click 'Simulate' to generate data under both models."),
            tags$li("Compare inter-item correlations: high for reflective, can be near-zero for formative."),
            tags$li("Note how \u03b1 is informative for reflective but misleading for formative.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Reflective: Inter-Item Correlations"),
                 plotlyOutput(ns("fvr_refl_corr"), height = "360px")),
            card(full_screen = TRUE, card_header("Formative: Predictor Correlations"),
                 plotlyOutput(ns("fvr_form_corr"), height = "360px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Reflective Model Summary"), tableOutput(ns("fvr_refl_table"))),
            card(card_header("Formative Model Summary"),  tableOutput(ns("fvr_form_table")))
          )
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_validity_meas_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Validity Evidence ──────────────────────────────────────
  val_data <- reactiveVal(NULL)
  
  observeEvent(input$val_reset, {
    updateSliderInput(session, "val_traits", value = 3)
    updateSliderInput(session, "val_methods", value = 3)
    updateSliderInput(session, "val_n", value = 300)
    updateSliderInput(session, "val_trait_cor", value = 0.3)
    updateSliderInput(session, "val_method_cor", value = 0.2)
    updateSliderInput(session, "val_convergent", value = 0.7)
    val_data(NULL)
  })
  
  observeEvent(input$val_go, {
    set.seed(sample(1:10000, 1))
    nt <- input$val_traits; nm <- input$val_methods; n <- input$val_n
    tc <- input$val_trait_cor; mc <- input$val_method_cor; cv <- input$val_convergent
    p <- nt * nm
  
    # Build correlation matrix
    R <- diag(p)
    var_names <- character(p)
    idx <- 0
    for (t in seq_len(nt))
      for (m in seq_len(nm)) {
        idx <- idx + 1
        var_names[idx] <- paste0("T", t, "M", m)
      }
  
    for (i in 1:p) {
      for (j in 1:p) {
        if (i == j) next
        ti <- ((i - 1) %/% nm) + 1; mi <- ((i - 1) %% nm) + 1
        tj <- ((j - 1) %/% nm) + 1; mj <- ((j - 1) %% nm) + 1
  
        if (ti == tj && mi != mj) {
          # Same trait, different method (convergent validity)
          R[i, j] <- cv
        } else if (ti != tj && mi == mj) {
          # Different trait, same method (method effect)
          R[i, j] <- mc + tc * 0.3
        } else if (ti != tj && mi != mj) {
          # Different trait, different method
          R[i, j] <- tc * 0.5
        }
      }
    }
  
    # Ensure positive definite
    eig <- eigen(R, symmetric = TRUE)
    eig$values <- pmax(eig$values, 0.01)
    R <- eig$vectors %*% diag(eig$values) %*% t(eig$vectors)
    D <- diag(1 / sqrt(diag(R)))
    R <- D %*% R %*% D
    colnames(R) <- rownames(R) <- var_names
  
    # Generate data
    dat <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = R)
    colnames(dat) <- var_names
    obs_R <- cor(dat)
  
    # Extract validity coefficients
    convergent <- numeric(); discriminant_same_m <- numeric(); discriminant_diff <- numeric()
    for (i in 1:p) for (j in 1:p) {
      if (j <= i) next
      ti <- ((i - 1) %/% nm) + 1; mi <- ((i - 1) %% nm) + 1
      tj <- ((j - 1) %/% nm) + 1; mj <- ((j - 1) %% nm) + 1
      if (ti == tj && mi != mj) convergent <- c(convergent, obs_R[i, j])
      else if (ti != tj && mi == mj) discriminant_same_m <- c(discriminant_same_m, obs_R[i, j])
      else if (ti != tj && mi != mj) discriminant_diff <- c(discriminant_diff, obs_R[i, j])
    }
  
    val_data(list(
      R = obs_R, var_names = var_names, nt = nt, nm = nm,
      convergent = convergent, disc_same = discriminant_same_m,
      disc_diff = discriminant_diff
    ))
  })
  
  output$val_mtmm_plot <- renderPlotly({
    res <- val_data(); req(res)
    R <- res$R; nms <- colnames(R); p_n <- length(nms)
    z_mat <- R[rev(seq_len(p_n)), ]
    text_mat <- matrix(sprintf("%.2f", as.vector(z_mat)), nrow = p_n)
    hover_mat <- matrix(
      paste0(rep(rev(nms), p_n), " × ", rep(nms, each = p_n),
             "<br>r = ", sprintf("%.3f", as.vector(z_mat))),
      nrow = p_n)
    plotly::plot_ly(
      z = z_mat, x = nms, y = rev(nms),
      type = "heatmap",
      colorscale = list(c(0, "#dc322f"), c(0.5, "#fdf6e3"), c(1, "#268bd2")),
      zmin = -1, zmax = 1,
      colorbar = list(title = "r"),
      hoverinfo = "text", text = hover_mat
    ) |>
      plotly::add_annotations(
        x = rep(nms, each = p_n), y = rep(rev(nms), p_n),
        text = as.vector(text_mat),
        showarrow = FALSE,
        font = list(size = if (p_n <= 9) 9 else 7,
                    color = ifelse(abs(as.vector(z_mat)) > 0.5, "white", "#657b83"))
      ) |>
      plotly::layout(
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        annotations = list(
          list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
               text = "MTMM Correlation Matrix", showarrow = FALSE,
               font = list(size = 13))
        ),
        margin = list(t = 40, b = 80)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  
  output$val_summary <- renderUI({
    res <- val_data(); req(res)
    div(style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$thead(tags$tr(tags$th("Coefficient Type"), tags$th("Mean r"), tags$th("Range"))),
        tags$tr(tags$td(tags$strong("Convergent"), " (same trait, diff method)"),
                tags$td(round(mean(res$convergent), 3)),
                tags$td(paste0("[", round(min(res$convergent), 3), ", ",
                               round(max(res$convergent), 3), "]"))),
        tags$tr(tags$td(tags$strong("Discriminant"), " (diff trait, same method)"),
                tags$td(round(mean(res$disc_same), 3)),
                tags$td(paste0("[", round(min(res$disc_same), 3), ", ",
                               round(max(res$disc_same), 3), "]"))),
        tags$tr(tags$td(tags$strong("Heterotrait-Heteromethod")),
                tags$td(round(mean(res$disc_diff), 3)),
                tags$td(paste0("[", round(min(res$disc_diff), 3), ", ",
                               round(max(res$disc_diff), 3), "]")))
      ),
      tags$hr(),
      if (mean(res$convergent) > mean(res$disc_same) &&
          mean(res$convergent) > mean(res$disc_diff))
        tags$p(style = "color: #238b45; font-weight: bold;",
               "\u2713 Convergent > discriminant — evidence supports construct validity")
      else
        tags$p(style = "color: #e31a1c; font-weight: bold;",
               "\u2717 Convergent validity is not clearly higher — weak validity evidence")
    )
  })
  
  output$val_bar_plot <- renderPlotly({
    res <- val_data(); req(res)
    df <- data.frame(
      Type = rep(c("Convergent", "Discrim.\n(same method)", "Discrim.\n(diff method)"),
                 c(length(res$convergent), length(res$disc_same), length(res$disc_diff))),
      r = c(res$convergent, res$disc_same, res$disc_diff)
    )
    df$Type <- factor(df$Type, levels = c("Convergent", "Discrim.\n(same method)", "Discrim.\n(diff method)"))

    type_colors <- c("Convergent" = "#238b45",
                      "Discrim.\n(same method)" = "#e31a1c",
                      "Discrim.\n(diff method)" = "#999999")
    type_lvls <- c("Convergent", "Discrim.\n(same method)", "Discrim.\n(diff method)")

    p <- plot_ly()
    for (tl in type_lvls) {
      vals <- df$r[df$Type == tl]
      p <- p |> add_trace(y = vals, type = "box", name = tl,
                           marker = list(color = type_colors[tl]),
                           line = list(color = type_colors[tl]),
                           fillcolor = paste0(type_colors[tl], "B3"),
                           jitter = 0.3, pointpos = 0, boxpoints = "all",
                           hoverinfo = "y")
    }
    p |> layout(
      xaxis = list(title = ""),
      yaxis = list(title = "Correlation (r)"),
      showlegend = FALSE
    )
  })
  

  # ── CFA & Invariance ───────────────────────────────────────
  cfa_result <- reactiveVal(NULL)
  
  observeEvent(input$cfa_reset, {
    updateSliderInput(session, "cfa_n", value = 200)
    updateSliderInput(session, "cfa_items", value = 4)
    updateSliderInput(session, "cfa_factors", value = 2)
    updateSliderInput(session, "cfa_loading_shift", value = 0)
    updateSliderInput(session, "cfa_intercept_shift", value = 0)
    cfa_result(NULL)
  })
  
  observeEvent(input$cfa_go, {
    set.seed(sample(1:10000, 1))
    n_per  <- as.numeric(input$cfa_n)
    n_items <- as.numeric(input$cfa_items)
    n_fac  <- as.numeric(input$cfa_factors)
    l_shift <- as.numeric(input$cfa_loading_shift)
    i_shift <- as.numeric(input$cfa_intercept_shift)
    req(n_per, n_items, n_fac)

    p <- n_items * n_fac
    base_loadings <- rep(c(0.8, 0.7, 0.65, 0.6, 0.55, 0.5)[seq_len(n_items)], n_fac)

    # Build loading matrix
    Lambda <- matrix(0, nrow = p, ncol = n_fac)
    for (f in seq_len(n_fac)) {
      rows <- ((f - 1) * n_items + 1):(f * n_items)
      Lambda[rows, f] <- base_loadings[seq_len(n_items)]
    }

    # Factor correlation matrix
    Phi <- diag(n_fac)
    if (n_fac > 1) Phi[lower.tri(Phi)] <- Phi[upper.tri(Phi)] <- 0.3

    make_pd <- function(M) {
      M <- (M + t(M)) / 2
      eig <- eigen(M, symmetric = TRUE)
      eig$values <- pmax(eig$values, 0.05)
      eig$vectors %*% diag(eig$values) %*% t(eig$vectors)
    }

    Theta <- diag(p) - diag(diag(Lambda %*% Phi %*% t(Lambda)))
    diag(Theta) <- pmax(diag(Theta), 0.1)

    Sigma1 <- make_pd(Lambda %*% Phi %*% t(Lambda) + Theta)
    mu1 <- rep(0, p)

    # Group 2: shifted loadings and intercepts
    Lambda2 <- Lambda
    Lambda2[1, 1] <- Lambda2[1, 1] - l_shift
    if (n_items > 1) Lambda2[2, 1] <- Lambda2[2, 1] + l_shift * 0.5
    Theta2 <- diag(p) - diag(diag(Lambda2 %*% Phi %*% t(Lambda2)))
    diag(Theta2) <- pmax(diag(Theta2), 0.1)
    Sigma2 <- make_pd(Lambda2 %*% Phi %*% t(Lambda2) + Theta2)
    mu2 <- rep(0, p)
    mu2[1] <- mu2[1] + i_shift
    if (n_items > 1) mu2[2] <- mu2[2] + i_shift * 0.5

    dat1 <- as.data.frame(MASS::mvrnorm(n_per, mu1, Sigma1))
    dat2 <- as.data.frame(MASS::mvrnorm(n_per, mu2, Sigma2))
    vnames <- paste0("x", seq_len(p))
    names(dat1) <- names(dat2) <- vnames
    dat1$group <- "Group 1"
    dat2$group <- "Group 2"
    dat <- rbind(dat1, dat2)
    dat$group <- factor(dat$group)

    # Build lavaan model syntax
    fac_names <- paste0("F", seq_len(n_fac))
    model_lines <- vapply(seq_len(n_fac), function(f) {
      items <- paste0("x", ((f - 1) * n_items + 1):(f * n_items))
      paste0(fac_names[f], " =~ ", paste(items, collapse = " + "))
    }, character(1))
    model_syntax <- paste(model_lines, collapse = "\n")

    # Fit invariance sequence
    fit_results <- tryCatch({
      fit_config <- lavaan::cfa(model_syntax, data = dat, group = "group")
      fit_metric <- lavaan::cfa(model_syntax, data = dat, group = "group",
                                 group.equal = "loadings")
      fit_scalar <- lavaan::cfa(model_syntax, data = dat, group = "group",
                                 group.equal = c("loadings", "intercepts"))
      fit_strict <- lavaan::cfa(model_syntax, data = dat, group = "group",
                                 group.equal = c("loadings", "intercepts", "residuals"))

      get_fm <- function(fit) {
        fm <- lavaan::fitmeasures(fit, c("cfi", "tli", "rmsea", "srmr", "chisq", "df"))
        data.frame(
          cfi = as.numeric(fm["cfi"]), tli = as.numeric(fm["tli"]),
          rmsea = as.numeric(fm["rmsea"]), srmr = as.numeric(fm["srmr"]),
          chisq = as.numeric(fm["chisq"]), df = as.numeric(fm["df"])
        )
      }

      fm_df <- rbind(
        cbind(Level = "1. Configural", get_fm(fit_config)),
        cbind(Level = "2. Metric",     get_fm(fit_metric)),
        cbind(Level = "3. Scalar",     get_fm(fit_scalar)),
        cbind(Level = "4. Strict",     get_fm(fit_strict))
      )
      fm_df$cfi <- as.numeric(fm_df$cfi)
      fm_df$delta_cfi <- c(NA, diff(fm_df$cfi))

      list(success = TRUE, fm = fm_df, fit_config = fit_config,
           model_syntax = model_syntax, n_fac = n_fac, n_items = n_items)
    }, error = function(e) {
      list(success = FALSE, msg = e$message)
    })

    cfa_result(fit_results)
  })
  
  output$cfa_table <- renderUI({
    res <- cfa_result()
    req(res)
    if (!res$success) {
      return(div(class = "p-3",
        tags$p(style = "color: #e31a1c;", "Error fitting CFA models:"),
        tags$pre(res$msg)
      ))
    }

    fm <- res$fm
    header <- tags$tr(
      tags$th("Level"), tags$th("CFI"), tags$th("TLI"),
      tags$th("RMSEA"), tags$th("SRMR"),
      tags$th("\u03c7\u00b2"), tags$th("df"),
      tags$th("\u0394CFI"), tags$th("Decision")
    )

    rows <- lapply(seq_len(nrow(fm)), function(i) {
      dcfi <- fm$delta_cfi[i]
      decision <- if (is.na(dcfi)) "\u2014" else if (abs(dcfi) <= 0.01)
        "\u2713 Holds" else "\u2717 Fails"
      decision_style <- if (is.na(dcfi)) "" else if (abs(dcfi) <= 0.01)
        "color: #238b45; font-weight: bold;" else "color: #e31a1c; font-weight: bold;"

      tags$tr(
        tags$td(tags$strong(fm$Level[i])),
        tags$td(round(fm$cfi[i], 3)),
        tags$td(round(fm$tli[i], 3)),
        tags$td(round(fm$rmsea[i], 3)),
        tags$td(round(fm$srmr[i], 3)),
        tags$td(round(fm$chisq[i], 1)),
        tags$td(fm$df[i]),
        tags$td(if (is.na(dcfi)) "\u2014" else round(dcfi, 4)),
        tags$td(style = decision_style, decision)
      )
    })

    div(
      style = "padding: 10px;",
      tags$table(class = "table table-sm",
        tags$thead(header),
        tags$tbody(rows)
      ),
      tags$p(class = "text-muted mt-2",
        "Invariance holds when |\u0394CFI| \u2264 0.01 between successive levels.")
    )
  })
  
  # CFA Path Diagram (plotly shapes)
  output$cfa_path_diagram <- plotly::renderPlotly({
    res <- cfa_result()
    req(res, res$success)
    
    fit <- res$fit_config
    pe <- lavaan::parameterEstimates(fit, standardized = TRUE)
    loadings <- pe[pe$op == "=~" & pe$group == 1, ]
    
    n_fac <- res$n_fac
    n_items <- res$n_items
    p <- n_fac * n_items
    
    shapes <- list()
    annotations <- list()
    
    # Layout: factors at top, items at bottom
    fac_names <- unique(loadings$lhs)
    f_x <- seq(2, 8, length.out = n_fac)
    f_y <- rep(8, n_fac)
    
    v_x <- seq(1, 9, length.out = p)
    v_y <- rep(2, p)
    item_names <- paste0("x", seq_len(p))
    
    # Draw loading paths with standardized estimates
    for (i in seq_len(nrow(loadings))) {
      fac_idx <- match(loadings$lhs[i], fac_names)
      var_idx <- match(loadings$rhs[i], item_names)
      if (is.na(fac_idx) || is.na(var_idx)) next
      
      std_val <- loadings$std.all[i]
      col <- if (std_val >= 0) "#238b45" else "#e31a1c"
      w <- max(1, abs(std_val) * 5)
      
      shapes[[length(shapes) + 1]] <- list(
        type = "line",
        x0 = f_x[fac_idx], y0 = f_y[fac_idx] - 0.55,
        x1 = v_x[var_idx], y1 = v_y[var_idx] + 0.45,
        xref = "x", yref = "y",
        line = list(color = col, width = w), opacity = 0.7
      )
      # Loading value at midpoint
      mid_x <- (f_x[fac_idx] + v_x[var_idx]) / 2
      mid_y <- (f_y[fac_idx] - 0.55 + v_y[var_idx] + 0.45) / 2
      annotations[[length(annotations) + 1]] <- list(
        x = mid_x, y = mid_y,
        text = round(std_val, 2),
        font = list(size = 9, color = col),
        showarrow = FALSE, xref = "x", yref = "y",
        bgcolor = "rgba(255,255,255,0.7)"
      )
    }
    
    # Factor covariance arrows (if > 1 factor)
    if (n_fac > 1) {
      covs <- pe[pe$op == "~~" & pe$lhs != pe$rhs & pe$group == 1 &
                   pe$lhs %in% fac_names & pe$rhs %in% fac_names, ]
      for (i in seq_len(nrow(covs))) {
        fi <- match(covs$lhs[i], fac_names)
        fj <- match(covs$rhs[i], fac_names)
        if (is.na(fi) || is.na(fj)) next
        # Curved arrow between factors (draw as line above)
        mid_x <- (f_x[fi] + f_x[fj]) / 2
        shapes[[length(shapes) + 1]] <- list(
          type = "line",
          x0 = f_x[fi] + 0.5, y0 = f_y[fi] + 0.2,
          x1 = f_x[fj] - 0.5, y1 = f_y[fj] + 0.2,
          xref = "x", yref = "y",
          line = list(color = "#7570b3", width = 2, dash = "dash")
        )
        annotations[[length(annotations) + 1]] <- list(
          x = mid_x, y = f_y[fi] + 0.6,
          text = round(covs$std.all[i], 2),
          font = list(size = 9, color = "#7570b3"),
          showarrow = FALSE, xref = "x", yref = "y"
        )
      }
    }
    
    # Draw factor ellipses (circles)
    for (f in seq_len(n_fac)) {
      shapes[[length(shapes) + 1]] <- list(
        type = "circle",
        x0 = f_x[f] - 0.55, y0 = f_y[f] - 0.5,
        x1 = f_x[f] + 0.55, y1 = f_y[f] + 0.5,
        xref = "x", yref = "y",
        fillcolor = "#e5f5f9", opacity = 0.9,
        line = list(color = "#006d2c", width = 2)
      )
      annotations[[length(annotations) + 1]] <- list(
        x = f_x[f], y = f_y[f],
        text = paste0("<b>", fac_names[f], "</b>"),
        font = list(size = 13, color = "#006d2c"),
        showarrow = FALSE, xref = "x", yref = "y"
      )
    }
    
    # Draw item rectangles
    for (j in seq_len(p)) {
      shapes[[length(shapes) + 1]] <- list(
        type = "rect",
        x0 = v_x[j] - 0.4, y0 = v_y[j] - 0.4,
        x1 = v_x[j] + 0.4, y1 = v_y[j] + 0.4,
        xref = "x", yref = "y",
        fillcolor = "#f7fcfd", opacity = 0.9,
        line = list(color = "#00441b", width = 1.5)
      )
      annotations[[length(annotations) + 1]] <- list(
        x = v_x[j], y = v_y[j],
        text = paste0("<b>x", j, "</b>"),
        font = list(size = 10, color = "#00441b"),
        showarrow = FALSE, xref = "x", yref = "y"
      )
    }
    
    # Legend
    annotations[[length(annotations) + 1]] <- list(
      x = 5, y = 0.4, showarrow = FALSE, xref = "x", yref = "y",
      text = "Standardized loadings (Group 1 configural model)",
      font = list(size = 10, color = "#666666")
    )
    
    plotly::plot_ly(type = "scatter", mode = "none") |>
      plotly::layout(
        title = list(text = "CFA Path Diagram", font = list(size = 14)),
        shapes = shapes, annotations = annotations,
        xaxis = list(range = c(0, 10), showgrid = FALSE, zeroline = FALSE,
                     showticklabels = FALSE, title = ""),
        yaxis = list(range = c(-0.2, 9.5), showgrid = FALSE, zeroline = FALSE,
                     showticklabels = FALSE, title = ""),
        showlegend = FALSE,
        margin = list(t = 40)
      )
  })
  
  output$cfa_loadings_plot <- plotly::renderPlotly({
    res <- cfa_result()
    req(res, res$success)

    fit <- res$fit_config
    pe <- lavaan::parameterEstimates(fit, standardized = TRUE)
    loadings <- pe[pe$op == "=~", c("lhs", "rhs", "std.all", "group")]
    loadings$group <- ifelse(loadings$group == 1, "Group 1", "Group 2")

    factors <- unique(loadings$lhs)
    grp_colors <- c("Group 1" = "#238b45", "Group 2" = "#e31a1c")
    shown_g1 <- FALSE; shown_g2 <- FALSE

    subplots <- lapply(factors, function(fct) {
      d <- loadings[loadings$lhs == fct, ]
      p <- plot_ly()
      for (grp in c("Group 1", "Group 2")) {
        dg <- d[d$group == grp, ]
        if (nrow(dg) == 0) next
        hover <- paste0(dg$rhs, " \u2192 ", dg$lhs,
                         "<br>Std. Loading: ", round(dg$std.all, 3),
                         "<br>", grp)
        sl <- FALSE
        if (grp == "Group 1" && !shown_g1) { sl <- TRUE; shown_g1 <<- TRUE }
        if (grp == "Group 2" && !shown_g2) { sl <- TRUE; shown_g2 <<- TRUE }
        p <- p |> add_bars(x = dg$rhs, y = dg$std.all, name = grp,
                            text = hover, textposition = "none", hoverinfo = "text",
                            marker = list(color = grp_colors[grp], opacity = 0.85),
                            legendgroup = grp, showlegend = sl)
      }
      p |> layout(
        barmode = "group", bargap = 0.3,
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = "Standardized Loading"),
        annotations = list(
          list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
               text = fct, showarrow = FALSE, font = list(size = 11))
        )
      )
    })
    plotly::subplot(subplots, nrows = 1, shareY = TRUE, titleX = TRUE) |>
      plotly::layout(
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top", font = list(size = 11)),
        margin = list(b = 70)
      )
  })
  
  output$cfa_fit_text <- renderUI({
    res <- cfa_result()
    req(res, res$success)
    fit <- res$fit_config

    # Fit measures
    fm <- lavaan::fitMeasures(fit, c("chisq", "df", "pvalue",
                                      "cfi", "tli", "rmsea",
                                      "rmsea.ci.lower", "rmsea.ci.upper",
                                      "srmr"))
    fit_rows <- sprintf('
      <tr><td>\u03c7\u00b2</td><td>%.2f</td><td>df = %d, p %s</td></tr>
      <tr><td>CFI</td><td>%.3f</td><td>%s</td></tr>
      <tr><td>TLI</td><td>%.3f</td><td>%s</td></tr>
      <tr><td>RMSEA</td><td>%.3f</td><td>90%% CI [%.3f, %.3f]</td></tr>
      <tr><td>SRMR</td><td>%.3f</td><td>%s</td></tr>',
      fm["chisq"], fm["df"],
      if (fm["pvalue"] < 0.001) "< .001" else sprintf("= %.3f", fm["pvalue"]),
      fm["cfi"],
      if (fm["cfi"] >= 0.95) "Good" else if (fm["cfi"] >= 0.90) "Acceptable" else "Poor",
      fm["tli"],
      if (fm["tli"] >= 0.95) "Good" else if (fm["tli"] >= 0.90) "Acceptable" else "Poor",
      fm["rmsea"], fm["rmsea.ci.lower"], fm["rmsea.ci.upper"],
      fm["srmr"],
      if (fm["srmr"] <= 0.08) "Good" else "Elevated"
    )

    # Standardized parameter estimates (loadings)
    pe <- lavaan::parameterEstimates(fit, standardized = TRUE)
    loadings <- pe[pe$op == "=~", ]
    load_rows <- vapply(seq_len(nrow(loadings)), function(i) {
      r <- loadings[i, ]
      pv <- r$pvalue
      p_str <- if (is.na(pv)) "\u2014"
               else if (pv < 0.001) "< .001"
               else sprintf("%.3f", pv)
      sprintf("<tr><td>%s \u2192 %s</td><td>%.3f</td><td>%.3f</td><td>%s</td><td>%d</td></tr>",
              r$lhs, r$rhs, r$est, r$std.all, p_str, r$group)
    }, character(1))

    HTML(sprintf('
      <div style="padding: 0.5rem;">
        <div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">
          Model Fit Indices (Configural)
        </div>
        <table class="table table-sm table-striped mb-3" style="font-size: 0.9rem; max-width: 500px;">
          <thead><tr><th>Index</th><th>Value</th><th>Note</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">
          Standardized Factor Loadings
        </div>
        <table class="table table-sm table-striped mb-2" style="font-size: 0.9rem;">
          <thead><tr><th>Path</th><th>Estimate</th><th>Std. All</th><th>p</th><th>Group</th></tr></thead>
          <tbody>%s</tbody>
        </table>
      </div>',
      fit_rows, paste(load_rows, collapse = "")
    ))
  })

  # ── Tab 3: Criterion Validity & ROC server ───────────────────────────

  roc_data <- reactiveVal(NULL)

  observeEvent(input$roc_go, {
    set.seed(sample(1:10000, 1))
    N     <- input$val_roc_n
    prev  <- input$val_roc_prev
    r     <- input$roc_r

    # Generate test scores and binary criterion
    n_pos <- round(N * prev)
    n_neg <- N - n_pos

    # Scores for positives (higher mean) and negatives
    # Effect size d from r: d = 2r / sqrt(1 - r^2)
    d <- 2 * r / sqrt(1 - r^2)
    score_pos <- rnorm(n_pos, mean =  d / 2, sd = 1)
    score_neg <- rnorm(n_neg, mean = -d / 2, sd = 1)

    scores    <- c(score_pos, score_neg)
    criterion <- c(rep(1L, n_pos), rep(0L, n_neg))

    # ROC curve across thresholds
    thresholds <- sort(unique(scores), decreasing = TRUE)
    tpr <- vapply(thresholds, function(t) mean(score_pos >= t), numeric(1))
    fpr <- vapply(thresholds, function(t) mean(score_neg >= t), numeric(1))

    # AUC via trapezoidal rule
    auc <- sum(diff(c(0, fpr, 1)) * (c(0, tpr, 1) + c(tpr, 1, 1)) / 2)
    auc <- abs(auc)

    roc_data(list(
      scores = scores, criterion = criterion,
      score_pos = score_pos, score_neg = score_neg,
      tpr = tpr, fpr = fpr, auc = auc,
      N = N, prev = prev, r = r, d = d
    ))
  })

  output$roc_curve <- renderPlotly({
    d <- roc_data(); req(d)
    thresh_pct <- input$val_roc_threshold / 100
    cut <- quantile(d$scores, 1 - thresh_pct)
    tpr_at <- mean(d$score_pos >= cut)
    fpr_at <- mean(d$score_neg >= cut)

    plot_ly() |>
      add_trace(x = c(0, d$fpr, 1), y = c(0, d$tpr, 1),
                type = "scatter", mode = "lines",
                line = list(color = "#268bd2", width = 2.5),
                name = sprintf("ROC (AUC = %.3f)", d$auc)) |>
      add_trace(x = c(0, 1), y = c(0, 1),
                type = "scatter", mode = "lines",
                line = list(color = "#93a1a1", dash = "dash", width = 1),
                name = "Chance", showlegend = FALSE) |>
      add_trace(x = fpr_at, y = tpr_at, type = "scatter", mode = "markers",
                marker = list(color = "#dc322f", size = 12, symbol = "circle"),
                name = "Current threshold") |>
      layout(
        xaxis = list(title = "1 \u2212 Specificity (FPR)", range = c(0, 1)),
        yaxis = list(title = "Sensitivity (TPR)", range = c(0, 1)),
        title = list(text = sprintf("AUC = %.3f", d$auc), font = list(size = 14)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 40)
      ) |> config(displayModeBar = FALSE)
  })

  output$roc_density <- renderPlotly({
    d <- roc_data(); req(d)
    thresh_pct <- input$val_roc_threshold / 100
    cut <- quantile(d$scores, 1 - thresh_pct)

    xs <- seq(min(d$scores) - 0.5, max(d$scores) + 0.5, length.out = 300)
    dens_pos <- dnorm(xs, mean(d$score_pos), sd(d$score_pos))
    dens_neg <- dnorm(xs, mean(d$score_neg), sd(d$score_neg))

    plot_ly() |>
      add_trace(x = xs, y = dens_neg, type = "scatter", mode = "lines",
                fill = "tozeroy", fillcolor = "rgba(38,139,210,0.25)",
                line = list(color = "#268bd2", width = 2), name = "Negative") |>
      add_trace(x = xs, y = dens_pos, type = "scatter", mode = "lines",
                fill = "tozeroy", fillcolor = "rgba(220,50,47,0.25)",
                line = list(color = "#dc322f", width = 2), name = "Positive") |>
      layout(
        xaxis = list(title = "Test Score"),
        yaxis = list(title = "Density"),
        shapes = list(list(type = "line", x0 = cut, x1 = cut, y0 = 0, y1 = 1,
                           yref = "paper", line = list(color = "#b58900", width = 2, dash = "dash"))),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 10)
      ) |> config(displayModeBar = FALSE)
  })

  output$roc_stats <- renderTable({
    d <- roc_data(); req(d)
    thresh_pct <- input$val_roc_threshold / 100
    cut <- quantile(d$scores, 1 - thresh_pct)

    tp <- sum(d$score_pos >= cut)
    fn <- sum(d$score_pos <  cut)
    fp <- sum(d$score_neg >= cut)
    tn <- sum(d$score_neg <  cut)

    sens <- tp / (tp + fn)
    spec <- tn / (tn + fp)
    ppv  <- tp / (tp + fp)
    npv  <- tn / (tn + fn)
    acc  <- (tp + tn) / d$N

    data.frame(
      Metric = c("True Positives", "False Positives", "False Negatives", "True Negatives",
                 "Sensitivity (recall)", "Specificity", "PPV (precision)", "NPV", "Accuracy"),
      Value = c(tp, fp, fn, tn,
                sprintf("%.3f", sens), sprintf("%.3f", spec),
                sprintf("%.3f", ppv), sprintf("%.3f", npv),
                sprintf("%.3f", acc))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$roc_prev_plot <- renderPlotly({
    d <- roc_data(); req(d)
    thresh_pct <- input$val_roc_threshold / 100
    cut <- quantile(d$scores, 1 - thresh_pct)
    sens <- mean(d$score_pos >= cut)
    spec <- mean(d$score_neg <  cut)

    prev_seq <- seq(0.05, 0.95, by = 0.01)
    ppv_seq  <- (sens * prev_seq) / (sens * prev_seq + (1 - spec) * (1 - prev_seq))
    npv_seq  <- (spec * (1 - prev_seq)) / (spec * (1 - prev_seq) + (1 - sens) * prev_seq)

    plot_ly() |>
      add_trace(x = prev_seq, y = ppv_seq, type = "scatter", mode = "lines",
                line = list(color = "#dc322f", width = 2), name = "PPV") |>
      add_trace(x = prev_seq, y = npv_seq, type = "scatter", mode = "lines",
                line = list(color = "#268bd2", width = 2), name = "NPV") |>
      add_trace(x = d$prev, y = (sens * d$prev) / (sens * d$prev + (1 - spec) * (1 - d$prev)),
                type = "scatter", mode = "markers",
                marker = list(color = "#dc322f", size = 10), showlegend = FALSE) |>
      add_trace(x = d$prev, y = (spec * (1 - d$prev)) / (spec * (1 - d$prev) + (1 - sens) * d$prev),
                type = "scatter", mode = "markers",
                marker = list(color = "#268bd2", size = 10), showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Prevalence", range = c(0, 1)),
        yaxis = list(title = "Predictive Value", range = c(0, 1)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2),
        margin = list(t = 5)
      ) |> config(displayModeBar = FALSE)
  })

  # ── Tab 4: Formative vs. Reflective server ────────────────────────────

  fvr_data <- reactiveVal(NULL)

  observeEvent(input$fvr_go, {
    set.seed(sample(1:10000, 1))
    N <- input$fvr_n; K <- input$fvr_items
    lam <- input$fvr_loading; r_form <- input$fvr_formative_r

    # --- Reflective model ---
    # Latent factor + unique variances
    eta  <- rnorm(N)
    err_var <- 1 - lam^2
    refl <- matrix(0, N, K)
    for (j in seq_len(K)) refl[, j] <- lam * eta + rnorm(N, 0, sqrt(err_var))
    colnames(refl) <- paste0("X", seq_len(K))

    R_refl <- cor(refl)
    alpha_refl <- if (K > 1) {
      mean_r <- mean(R_refl[upper.tri(R_refl)])
      K * mean_r / (1 + (K - 1) * mean_r)
    } else NA

    # --- Formative model ---
    # Predictors with moderate inter-correlations
    Sigma_form <- matrix(r_form, K, K); diag(Sigma_form) <- 1
    L <- chol(Sigma_form)
    form_raw <- matrix(rnorm(N * K), N, K) %*% L
    colnames(form_raw) <- paste0("Z", seq_len(K))

    # Composite = equal weights
    weights <- rep(1 / K, K)
    composite <- form_raw %*% weights
    R_form <- cor(form_raw)

    alpha_form <- if (K > 1) {
      mean_r_f <- mean(R_form[upper.tri(R_form)])
      K * mean_r_f / (1 + (K - 1) * mean_r_f)
    } else NA

    fvr_data(list(
      R_refl = R_refl, alpha_refl = alpha_refl, lam = lam, K = K,
      R_form = R_form, alpha_form = alpha_form, r_form = r_form,
      composite = composite
    ))
  })

  # Plotly heatmap helper
  .corr_heatmap_plotly <- function(R, title_txt, hi_col = "#268bd2") {
    nms <- colnames(R)
    K <- length(nms)
    z_mat <- R[rev(seq_len(K)), ]
    text_mat <- matrix(sprintf("%.2f", as.vector(z_mat)), nrow = K)
    hover_mat <- matrix(
      paste0(rep(rev(nms), K), " × ", rep(nms, each = K),
             "<br>r = ", sprintf("%.3f", as.vector(z_mat))),
      nrow = K)
    plotly::plot_ly(
      z = z_mat, x = nms, y = rev(nms),
      type = "heatmap",
      colorscale = list(c(0, "#dc322f"), c(0.5, "#fdf6e3"), c(1, hi_col)),
      zmin = -1, zmax = 1,
      colorbar = list(title = "r"),
      hoverinfo = "text", text = hover_mat
    ) |>
      plotly::add_annotations(
        x = rep(nms, each = K), y = rep(rev(nms), K),
        text = as.vector(text_mat),
        showarrow = FALSE,
        font = list(size = if (K <= 8) 10 else 8,
                    color = ifelse(abs(as.vector(z_mat)) > 0.5, "white", "#657b83"))
      ) |>
      plotly::layout(
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        annotations = list(
          list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
               text = title_txt, showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  }

  output$fvr_refl_corr <- renderPlotly({
    d <- fvr_data(); req(d)
    .corr_heatmap_plotly(d$R_refl, "Reflective: Inter-Item Correlations", hi_col = "#268bd2")
  })

  output$fvr_form_corr <- renderPlotly({
    d <- fvr_data(); req(d)
    .corr_heatmap_plotly(d$R_form, "Formative: Predictor Correlations", hi_col = "#2aa198")
  })

  output$fvr_refl_table <- renderTable({
    d <- fvr_data(); req(d)
    mean_r <- mean(d$R_refl[upper.tri(d$R_refl)])
    data.frame(
      Metric = c("Model type", "Indicators", "Specified loading (\u03bb)",
                 "Mean inter-item r", "Cronbach\u2019s \u03b1",
                 "\u03b1 interpretation"),
      Value  = c("Reflective", d$K,
                 sprintf("%.2f", d$lam),
                 sprintf("%.3f", mean_r),
                 sprintf("%.3f", d$alpha_refl),
                 if (d$alpha_refl >= 0.70) "Acceptable (\u2265 0.70)"
                 else "Low \u2014 check loadings")
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$fvr_form_table <- renderTable({
    d <- fvr_data(); req(d)
    mean_r_f <- mean(d$R_form[upper.tri(d$R_form)])
    data.frame(
      Metric = c("Model type", "Indicators", "Specified predictor r",
                 "Mean observed predictor r", "Cronbach\u2019s \u03b1",
                 "\u03b1 interpretation"),
      Value  = c("Formative", d$K,
                 sprintf("%.2f", d$r_form),
                 sprintf("%.3f", mean_r_f),
                 sprintf("%.3f", d$alpha_form),
                 "\u26a0 Misleading for formative models")
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load

  })
}
