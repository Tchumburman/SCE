# ===========================================================================
# Module: Mediation & Moderation
# Interactive exploration of indirect effects, simple slopes, and
# Johnson-Neyman intervals
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
mediation_moderation_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Mediation & Moderation",
  icon = icon("arrows-split-up-and-left"),
  navset_card_tab(
    id = ns("medmod_tabs"),

    # ── Tab 1: Mediation ──────────────────────────────────────────────
    nav_panel("Mediation", icon = icon("diagram-project"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Mediation Model",
          tags$p(class = "text-muted small mb-2", "X → M → Y with direct path X → Y"),
          sliderInput(ns("med_a"), "a path (X → M)", -1, 1, 0.5, step = 0.05),
          sliderInput(ns("med_b"), "b path (M → Y, controlling X)", -1, 1, 0.4, step = 0.05),
          sliderInput(ns("med_cp"), "c' path (direct: X → Y)", -1, 1, 0.1, step = 0.05),
          sliderInput(ns("med_n"), "Sample size", 50, 1000, 200, step = 50),
          sliderInput(ns("med_noise"), "Noise level", 0.5, 3, 1, step = 0.25),
          actionButton(ns("med_run"), "Generate & Test", class = "btn-success w-100"),
          tags$hr(),
          sliderInput(ns("med_boot_r"), "Bootstrap resamples", 500, 5000, 2000, step = 500),
          tags$p(class = "text-muted small",
            "The indirect effect = a × b. Bootstrap CI that excludes zero
             indicates significant mediation.")
        ),
        explanation_box(
          tags$strong("Mediation Analysis"),
          tags$p("Mediation asks: does X affect Y ",
                 tags$em("through"), " an intermediate variable M?
                 The total effect of X on Y (path c) is decomposed into:"),
          tags$ul(
            tags$li(tags$strong("Indirect effect (a × b):"), " X influences M (path a), and M in turn influences Y (path b)."),
            tags$li(tags$strong("Direct effect (c'):"), " The remaining effect of X on Y after accounting for M.")
          ),
          tags$p("Total effect: c = c' + a × b (in linear models)."),
          tags$p(tags$strong("Key points:"),
            tags$ul(
              tags$li("The Sobel test (normal-theory) is outdated — bootstrap CIs are preferred because the sampling distribution of a × b is often skewed."),
              tags$li("Full mediation: c' ≈ 0 and a × b is significant (X affects Y only through M)."),
              tags$li("Partial mediation: both c' and a × b are significant (X affects Y both directly and through M)."),
              tags$li("Mediation does NOT prove causation. The causal interpretation (X causes M causes Y) requires strong theoretical justification and appropriate design."),
              tags$li("Proportion mediated = (a × b) / c can be unstable with small total effects.")
            ))
        ),
        card(
          card_header("Path Diagram & Estimates"),
          uiOutput(ns("med_path_diagram"))
        ),
        layout_column_wrap(width = 1/2,
          card(
            card_header("Regression Results"),
            uiOutput(ns("med_reg_output"))
          ),
          card(
            card_header("Bootstrap Indirect Effect"),
            plotOutput(ns("med_boot_plot"), height = "280px")
          )
        ),
        card(
          card_header("Effect Decomposition"),
          tableOutput(ns("med_effects_table"))
        )
      )
    ),

    # ── Tab 2: Moderation ─────────────────────────────────────────────
    nav_panel("Moderation", icon = icon("sliders"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Moderation Model",
          tags$p(class = "text-muted small mb-2", "Y = b0 + b1·X + b2·W + b3·X·W + e"),
          sliderInput(ns("modr_b1"), "b1 (main effect of X)", -1, 1, 0.5, step = 0.05),
          sliderInput(ns("modr_b2"), "b2 (main effect of W)", -1, 1, 0.3, step = 0.05),
          sliderInput(ns("modr_b3"), "b3 (interaction X × W)", -1, 1, 0.4, step = 0.05),
          sliderInput(ns("modr_n"), "Sample size", 50, 1000, 200, step = 50),
          sliderInput(ns("modr_noise"), "Noise level", 0.5, 3, 1, step = 0.25),
          actionButton(ns("modr_run"), "Generate & Test", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "When b3 ≠ 0, the effect of X on Y depends on the level of
             the moderator W. Simple slopes show this conditional relationship.")
        ),
        explanation_box(
          tags$strong("Moderation (Interaction Effects)"),
          tags$p("Moderation asks: does the effect of X on Y ",
                 tags$em("depend on"), " the level of another variable W?
                 If so, X and W interact."),
          tags$p("The regression model: Y = b0 + b1·X + b2·W + b3·X·W + e"),
          tags$p("The conditional effect of X on Y at a given value of W is: b1 + b3·W"),
          tags$p(tags$strong("Key points:"),
            tags$ul(
              tags$li("If b3 is significant, the effect of X on Y varies across levels of W — this IS the interaction."),
              tags$li("Simple slopes analysis probes the interaction at specific values of W (typically mean, mean ± 1 SD)."),
              tags$li("Always center predictors before creating the interaction term — this makes main effects interpretable."),
              tags$li("A non-significant interaction means the effect of X on Y is roughly constant across W."),
              tags$li("Graphically, parallel lines = no interaction; non-parallel lines = interaction.")
            ))
        ),
        card(
          card_header("Moderation Diagram"),
          uiOutput(ns("modr_path_diagram"))
        ),
        card(
          card_header("Interaction Plot (Simple Slopes)"),
          plotOutput(ns("modr_plot"), height = "350px")
        ),
        card(
          card_header("Regression Table"),
          uiOutput(ns("modr_reg_output"))
        ),
        card(
          card_header("Simple Slopes at W = Mean ± 1 SD"),
          tableOutput(ns("modr_slopes_table"))
        )
      )
    ),

    # ── Tab 3: Johnson-Neyman ─────────────────────────────────────────
    nav_panel("Johnson-Neyman", icon = icon("arrows-left-right"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Johnson-Neyman Interval",
          tags$p(class = "text-muted small mb-2",
            "Find the exact range of moderator values where the effect of X on Y is significant."),
          sliderInput(ns("jn_b1"), "b1 (main effect of X)", -1, 1, 0.3, step = 0.05),
          sliderInput(ns("jn_b3"), "b3 (interaction X × W)", -1, 1, 0.4, step = 0.05),
          sliderInput(ns("jn_n"), "Sample size", 50, 1000, 200, step = 50),
          sliderInput(ns("jn_noise"), "Noise level", 0.5, 3, 1, step = 0.25),
          sliderInput(ns("jn_alpha"), "Significance level", 0.01, 0.10, 0.05, step = 0.01),
          actionButton(ns("jn_run"), "Generate & Compute", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "The J-N technique avoids arbitrary cutpoints (like ±1 SD) by
             finding the exact moderator values where the confidence band
             for the conditional effect crosses zero.")
        ),
        explanation_box(
          tags$strong("The Johnson-Neyman Technique"),
          tags$p("Simple slopes analysis only probes the interaction at a few
                  pre-chosen values of the moderator (e.g., mean ± 1 SD). The
                  Johnson-Neyman (J-N) technique goes further by finding the
                  exact value(s) of W where the conditional effect of X on Y
                  transitions from non-significant to significant (or vice versa)."),
          tags$p(tags$strong("How it works:"),
            tags$ul(
              tags$li("The conditional effect of X at moderator value w is: b1 + b3·w."),
              tags$li("The standard error of this conditional effect depends on w."),
              tags$li("The J-N point is where |conditional effect / SE| = t_critical."),
              tags$li("This defines a region of significance: the range of W values where the effect of X on Y is statistically significant.")
            )),
          tags$p(tags$strong("Interpretation:"),
            "The J-N plot shows the conditional effect of X on Y across the full
             range of W. The shaded region shows where the effect is significant.
             This is more informative than pick-a-point (simple slopes) because it
             doesn't depend on arbitrary choices of W values.")
        ),
        card(
          card_header("Johnson-Neyman Plot"),
          plotOutput(ns("jn_plot"), height = "400px")
        ),
        card(
          card_header("Region of Significance"),
          uiOutput(ns("jn_summary"))
        )
      )
    ),

    # ── Tab 4: Mediated Moderation ────────────────────────────────────
    nav_panel("Combined Models", icon = icon("code-merge"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Mediated Moderation",
          tags$p(class = "text-muted small mb-2",
            "X → M → Y, with W moderating the a path (X → M)."),
          sliderInput(ns("mm_a"), "a path (X → M, when W = 0)", -1, 1, 0.5, step = 0.05),
          sliderInput(ns("mm_a_mod"), "a × W interaction", -1, 1, 0.3, step = 0.05),
          sliderInput(ns("mm_b"), "b path (M → Y)", -1, 1, 0.4, step = 0.05),
          sliderInput(ns("mm_cp"), "c' path (direct X → Y)", -1, 1, 0.1, step = 0.05),
          sliderInput(ns("mm_n"), "Sample size", 100, 1000, 300, step = 50),
          sliderInput(ns("mm_noise"), "Noise level", 0.5, 3, 1, step = 0.25),
          actionButton(ns("mm_run"), "Generate & Test", class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "The indirect effect now depends on W:
             indirect = (a + a_mod × W) × b.
             Compare indirect effects at low vs high W.")
        ),
        explanation_box(
          tags$strong("Combining Mediation and Moderation"),
          tags$p("Real-world processes often involve both mediation and moderation.
                  Common combinations include:"),
          tags$ul(
            tags$li(tags$strong("Moderated mediation:"), " The indirect effect (X → M → Y) varies across levels of a moderator. For example, a training program (X) improves skills (M) which improve performance (Y), but the X → M link is stronger for motivated employees (W)."),
            tags$li(tags$strong("Mediated moderation:"), " An interaction effect operates through a mediator. Conceptually similar but framed differently."),
            tags$li(tags$strong("Conditional process models:"), " Andrew Hayes' PROCESS framework popularized these models, estimating conditional indirect effects at different moderator values.")
          ),
          tags$p(tags$strong("In this simulation:"),
            "W moderates the a path. The indirect effect = (a + a_mod \u00d7 W) \u00d7 b,
             so it changes across W. The index of moderated mediation = a_mod \u00d7 b
             tests whether this moderation of the indirect effect is significant."),
          tags$p("These models are powerful but require careful theoretical justification.
                  Simply testing all possible combinations of mediation and moderation
                  inflates Type I error and leads to uninterpretable results. Start with
                  a clear theory about which paths are moderated and why, then test only
                  those specific hypotheses."),
          tags$p("Interpretation of conditional indirect effects should be done at meaningful
                  values of the moderator (e.g., \u00b11 SD, or substantively relevant cutoffs).
                  The Johnson-Neyman technique identifies the exact range of moderator values
                  where the indirect effect is significant, providing a more complete picture
                  than point estimates alone.")
        ),
        card(
          card_header("Conditional Indirect Effects"),
          plotOutput(ns("mm_plot"), height = "350px")
        ),
        card(
          card_header("Effect Summary"),
          tableOutput(ns("mm_table"))
        ),
        card(
          card_header("Index of Moderated Mediation"),
          uiOutput(ns("mm_index"))
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

mediation_moderation_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ══════════════════════════════════════════════════════════════════════
  # Tab 1: Mediation
  # ══════════════════════════════════════════════════════════════════════
  med_data <- eventReactive(input$med_run, {
    set.seed(sample(1:10000, 1))
    n <- input$med_n
    noise <- input$med_noise
    a <- input$med_a
    b <- input$med_b
    cp <- input$med_cp

    X <- rnorm(n)
    M <- a * X + rnorm(n, 0, noise)
    Y <- cp * X + b * M + rnorm(n, 0, noise)

    df <- data.frame(X = X, M = M, Y = Y)

    # Fit regressions
    fit_mx <- lm(M ~ X, data = df)
    fit_ymx <- lm(Y ~ X + M, data = df)
    fit_yx <- lm(Y ~ X, data = df)

    # Bootstrap indirect effect
    n_boot <- input$med_boot_r
    ab_boot <- numeric(n_boot)
    for (i in seq_len(n_boot)) {
      idx <- sample(n, replace = TRUE)
      d <- df[idx, ]
      a_b <- coef(lm(M ~ X, data = d))["X"]
      b_b <- coef(lm(Y ~ X + M, data = d))["M"]
      ab_boot[i] <- a_b * b_b
    }

    list(df = df, fit_mx = fit_mx, fit_ymx = fit_ymx, fit_yx = fit_yx,
         ab_boot = ab_boot,
         a_hat = coef(fit_mx)["X"],
         b_hat = coef(fit_ymx)["M"],
         cp_hat = coef(fit_ymx)["X"],
         c_hat = coef(fit_yx)["X"])
  })

  output$med_path_diagram <- renderUI({
    req(med_data())
    d <- med_data()
    ci <- quantile(d$ab_boot, c(0.025, 0.975))
    sig <- (ci[1] > 0 | ci[2] < 0)

    a_p <- summary(d$fit_mx)$coefficients["X", "Pr(>|t|)"]
    b_p <- summary(d$fit_ymx)$coefficients["M", "Pr(>|t|)"]
    cp_p <- summary(d$fit_ymx)$coefficients["X", "Pr(>|t|)"]
    fmt_stars <- function(pv) {
      if (pv < 0.001) "***" else if (pv < 0.01) "**" else if (pv < 0.05) "*" else ""
    }

    a_lbl  <- sprintf("a = %.3f%s", d$a_hat, fmt_stars(a_p))
    b_lbl  <- sprintf("b = %.3f%s", d$b_hat, fmt_stars(b_p))
    cp_lbl <- sprintf("c' = %.3f%s", d$cp_hat, fmt_stars(cp_p))

    indirect_val <- d$a_hat * d$b_hat
    sig_color <- if (sig) "#2aa198" else "#839496"

    HTML(sprintf('
      <svg viewBox="0 0 500 260" xmlns="http://www.w3.org/2000/svg"
           style="width:100%%; max-width:500px; display:block; margin:auto; font-family:inherit;">
        <defs>
          <marker id="arrowG" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
            <path d="M0,0 L8,3 L0,6 Z" fill="#657b83"/>
          </marker>
          <marker id="arrowD" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
            <path d="M0,0 L8,3 L0,6 Z" fill="#586e75"/>
          </marker>
        </defs>

        <!-- Arrows -->
        <line x1="95" y1="120" x2="210" y2="55" stroke="#657b83" stroke-width="2.5"
              marker-end="url(#arrowG)"/>
        <line x1="290" y1="55" x2="405" y2="120" stroke="#657b83" stroke-width="2.5"
              marker-end="url(#arrowG)"/>
        <line x1="100" y1="140" x2="400" y2="140" stroke="#586e75" stroke-width="2"
              stroke-dasharray="8,5" marker-end="url(#arrowD)"/>

        <!-- Path labels -->
        <text x="120" y="75" font-size="15" font-weight="bold" fill="#657b83">%s</text>
        <text x="340" y="75" font-size="15" font-weight="bold" fill="#657b83">%s</text>
        <text x="220" y="170" font-size="14" fill="#586e75">%s</text>

        <!-- Nodes -->
        <rect x="35" y="115" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#268bd2" stroke-width="2.5"/>
        <text x="62" y="142" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#268bd2">X</text>

        <rect x="222" y="20" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#2aa198" stroke-width="2.5"/>
        <text x="250" y="47" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#2aa198">M</text>

        <rect x="410" y="115" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#dc322f" stroke-width="2.5"/>
        <text x="437" y="142" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#dc322f">Y</text>

        <!-- Summary -->
        <text x="250" y="210" text-anchor="middle" font-size="14" font-weight="bold"
              fill="%s">Indirect (a × b) = %.3f    95%% CI [%.3f, %.3f]</text>
        <text x="250" y="232" text-anchor="middle" font-size="12"
              fill="%s">%s</text>
        <text x="250" y="252" text-anchor="middle" font-size="12"
              fill="#657b83">Total (c) = %.3f  |  Direct (c&apos;) = %.3f  |  Indirect = %.3f</text>
      </svg>',
      a_lbl, b_lbl, cp_lbl,
      sig_color, indirect_val, ci[1], ci[2],
      sig_color, if (sig) "Significant" else "Not significant",
      d$c_hat, d$cp_hat, indirect_val
    ))
  })

  # Helper: format a model's coefficients into an HTML table
  fmt_coef_table <- function(fit, label, highlight = NULL) {
    cc <- summary(fit)$coefficients
    r2 <- summary(fit)$r.squared
    df_res <- summary(fit)$df[2]
    rows <- lapply(seq_len(nrow(cc)), function(i) {
      pval <- cc[i, "Pr(>|t|)"]
      p_str <- if (pval < 0.001) "< .001" else sprintf("%.3f", pval)
      stars <- if (pval < 0.001) "***" else if (pval < 0.01) "**" else if (pval < 0.05) "*" else ""
      rn <- rownames(cc)[i]
      # Highlight specific rows
      hl <- if (!is.null(highlight) && rn %in% highlight)
        ' style="background-color: rgba(42,161,152,0.12); font-weight: 600;"' else ""
      sprintf("<tr%s><td>%s</td><td>%.3f</td><td>%.3f</td><td>%.2f</td><td>%s %s</td></tr>",
              hl, rn, cc[i,1], cc[i,2], cc[i,3], p_str, stars)
    })
    paste0(
      '<div class="mb-3">',
      sprintf('<div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">%s</div>', label),
      '<table class="table table-sm table-striped mb-1" style="font-size: 0.9rem;">',
      '<thead><tr><th>Term</th><th>Estimate</th><th>SE</th><th>t</th><th>p</th></tr></thead><tbody>',
      paste(rows, collapse = ""),
      '</tbody></table>',
      sprintf('<small class="text-muted">R² = %.3f | Residual df = %d</small>', r2, df_res),
      '</div>'
    )
  }

  output$med_reg_output <- renderUI({
    req(med_data())
    d <- med_data()
    HTML(paste0(
      fmt_coef_table(d$fit_mx, "Model 1: M ~ X (a path)", highlight = "X"),
      fmt_coef_table(d$fit_ymx, "Model 2: Y ~ X + M (b and c' paths)", highlight = c("X", "M")),
      fmt_coef_table(d$fit_yx, "Total Effect: Y ~ X (c path)", highlight = "X")
    ))
  })

  output$med_boot_plot <- renderPlot(bg = "transparent", {
    req(med_data())
    d <- med_data()
    ab <- d$ab_boot
    ci <- quantile(ab, c(0.025, 0.975))
    sig <- (ci[1] > 0 | ci[2] < 0)

    ggplot(data.frame(ab = ab), aes(ab)) +
      geom_histogram(bins = 50, fill = if (sig) "#2aa198" else "#839496", alpha = 0.7) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "#dc322f", linewidth = 0.8) +
      geom_vline(xintercept = ci[1], color = "#268bd2", linewidth = 0.8) +
      geom_vline(xintercept = ci[2], color = "#268bd2", linewidth = 0.8) +
      labs(title = "Bootstrap Distribution of Indirect Effect (a×b)",
           subtitle = sprintf("95%% CI: [%.3f, %.3f] %s",
                              ci[1], ci[2],
                              if (sig) "— Significant" else "— Not significant"),
           x = "Indirect Effect", y = "Count")
  })

  output$med_effects_table <- renderTable({
    req(med_data())
    d <- med_data()
    ci <- quantile(d$ab_boot, c(0.025, 0.975))
    data.frame(
      Effect = c("Total (c)", "Direct (c')", "Indirect (a*b)"),
      Estimate = sprintf("%.3f", c(d$c_hat, d$cp_hat, d$a_hat * d$b_hat)),
      `Bootstrap 95% CI` = c("—", "—",
        sprintf("[%.3f, %.3f]", ci[1], ci[2])),
      Significant = c(
        ifelse(summary(d$fit_yx)$coefficients["X", "Pr(>|t|)"] < 0.05, "Yes", "No"),
        ifelse(summary(d$fit_ymx)$coefficients["X", "Pr(>|t|)"] < 0.05, "Yes", "No"),
        ifelse(ci[1] > 0 | ci[2] < 0, "Yes", "No")
      ),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 2: Moderation
  # ══════════════════════════════════════════════════════════════════════
  modr_data <- eventReactive(input$modr_run, {
    set.seed(sample(1:10000, 1))
    n <- input$modr_n
    noise <- input$modr_noise

    X <- rnorm(n)
    W <- rnorm(n)
    Y <- input$modr_b1 * X + input$modr_b2 * W +
         input$modr_b3 * X * W + rnorm(n, 0, noise)

    df <- data.frame(X = X, W = W, Y = Y, XW = X * W)
    fit <- lm(Y ~ X * W, data = df)

    # Simple slopes at W = mean, mean ± 1 SD
    w_vals <- c(Low = mean(W) - sd(W), Mean = mean(W), High = mean(W) + sd(W))
    slopes <- data.frame(
      `W Level` = names(w_vals),
      `W Value` = sprintf("%.2f", w_vals),
      `Slope of X` = sprintf("%.3f", coef(fit)["X"] + coef(fit)["X:W"] * w_vals),
      check.names = FALSE
    )
    # p-values for simple slopes
    vcov_mat <- vcov(fit)
    for (i in seq_along(w_vals)) {
      w <- w_vals[i]
      slope <- coef(fit)["X"] + coef(fit)["X:W"] * w
      se <- sqrt(vcov_mat["X","X"] + 2*w*vcov_mat["X","X:W"] + w^2*vcov_mat["X:W","X:W"])
      t_val <- slope / se
      p_val <- 2 * pt(abs(t_val), df = n - 4, lower.tail = FALSE)
      slopes$SE[i] <- sprintf("%.3f", se)
      slopes$t[i] <- sprintf("%.2f", t_val)
      slopes$p[i] <- ifelse(p_val < 0.001, "< .001", sprintf("%.3f", p_val))
    }

    list(df = df, fit = fit, slopes = slopes, w_vals = w_vals)
  })

  output$modr_path_diagram <- renderUI({
    req(modr_data())
    d <- modr_data()
    fit <- d$fit
    cc <- summary(fit)$coefficients
    fmt_stars <- function(pv) {
      if (pv < 0.001) "***" else if (pv < 0.01) "**" else if (pv < 0.05) "*" else ""
    }

    b1_lbl <- sprintf("b1 = %.3f%s", cc["X","Estimate"], fmt_stars(cc["X","Pr(>|t|)"]))
    b2_lbl <- sprintf("b2 = %.3f%s", cc["W","Estimate"], fmt_stars(cc["W","Pr(>|t|)"]))
    b3_lbl <- sprintf("b3 = %.3f%s", cc["X:W","Estimate"], fmt_stars(cc["X:W","Pr(>|t|)"]))
    int_sig <- cc["X:W","Pr(>|t|)"] < 0.05
    int_color <- if (int_sig) "#2aa198" else "#839496"

    HTML(sprintf('
      <svg viewBox="0 0 500 240" xmlns="http://www.w3.org/2000/svg"
           style="width:100%%; max-width:500px; display:block; margin:auto; font-family:inherit;">
        <defs>
          <marker id="arrowMod" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
            <path d="M0,0 L8,3 L0,6 Z" fill="#657b83"/>
          </marker>
          <marker id="arrowInt" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
            <path d="M0,0 L8,3 L0,6 Z" fill="%s"/>
          </marker>
        </defs>

        <!-- X -> Y arrow -->
        <line x1="100" y1="140" x2="400" y2="140" stroke="#657b83" stroke-width="2.5"
              marker-end="url(#arrowMod)"/>
        <text x="250" y="165" text-anchor="middle" font-size="14" font-weight="bold"
              fill="#657b83">%s</text>

        <!-- W -> Y arrow (main effect) -->
        <line x1="250" y1="55" x2="410" y2="125" stroke="#657b83" stroke-width="2"
              stroke-dasharray="6,4" marker-end="url(#arrowMod)"/>
        <text x="355" y="78" font-size="13" fill="#657b83">%s</text>

        <!-- W moderates X->Y (arrow to the path) -->
        <line x1="250" y1="55" x2="250" y2="130" stroke="%s" stroke-width="2.5"
              marker-end="url(#arrowInt)"/>
        <circle cx="250" cy="140" r="4" fill="%s"/>
        <text x="270" y="105" font-size="14" font-weight="bold" fill="%s">%s</text>

        <!-- X node -->
        <rect x="35" y="120" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#268bd2" stroke-width="2.5"/>
        <text x="62" y="147" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#268bd2">X</text>

        <!-- W node -->
        <rect x="222" y="15" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#b58900" stroke-width="2.5"/>
        <text x="250" y="42" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#b58900">W</text>

        <!-- Y node -->
        <rect x="410" y="120" width="55" height="40" rx="6" fill="var(--bs-body-bg, white)"
              stroke="#dc322f" stroke-width="2.5"/>
        <text x="437" y="147" text-anchor="middle" font-size="20" font-weight="bold"
              fill="#dc322f">Y</text>

        <!-- Summary -->
        <text x="250" y="205" text-anchor="middle" font-size="13" font-weight="bold"
              fill="%s">Interaction %s (effect of X on Y %s on W)</text>
        <text x="250" y="228" text-anchor="middle" font-size="12"
              fill="#657b83">Conditional effect of X = b1 + b3 × W = %.3f + %.3f × W</text>
      </svg>',
      int_color,
      b1_lbl, b2_lbl,
      int_color, int_color, int_color, b3_lbl,
      int_color,
      if (int_sig) "is significant" else "is not significant",
      if (int_sig) "depends" else "does not depend",
      cc["X","Estimate"], cc["X:W","Estimate"]
    ))
  })

  output$modr_plot <- renderPlot(bg = "transparent", {
    req(modr_data())
    d <- modr_data()
    fit <- d$fit
    b <- coef(fit)

    x_range <- seq(-3, 3, length.out = 100)
    w_vals <- d$w_vals
    plot_data <- do.call(rbind, lapply(names(w_vals), function(nm) {
      w <- w_vals[nm]
      data.frame(
        X = x_range,
        Y = b[1] + b["X"] * x_range + b["W"] * w + b["X:W"] * x_range * w,
        W_level = nm
      )
    }))
    plot_data$W_level <- factor(plot_data$W_level, levels = c("Low", "Mean", "High"))

    ggplot(plot_data, aes(X, Y, color = W_level, linetype = W_level)) +
      geom_line(linewidth = 1.2) +
      scale_color_manual(values = c(Low = "#268bd2", Mean = "#657b83", High = "#dc322f"),
                         name = "Moderator (W)") +
      scale_linetype_manual(values = c(Low = "dashed", Mean = "solid", High = "dashed"),
                            name = "Moderator (W)") +
      geom_point(data = d$df, aes(x = X, y = Y), inherit.aes = FALSE,
                 alpha = 0.15, color = "#657b83", size = 1) +
      labs(title = "Simple Slopes: Effect of X on Y at Different Levels of W",
           subtitle = sprintf("Interaction b3 = %.3f (p = %s)",
                              b["X:W"],
                              ifelse(summary(fit)$coefficients["X:W","Pr(>|t|)"] < 0.001,
                                     "< .001",
                                     sprintf("%.3f", summary(fit)$coefficients["X:W","Pr(>|t|)"]))),
           x = "X", y = "Y")
  })

  output$modr_reg_output <- renderUI({
    req(modr_data())
    d <- modr_data()
    fit <- d$fit
    s <- summary(fit)
    f_stat <- s$fstatistic
    f_p <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)

    HTML(paste0(
      fmt_coef_table(fit, "Y ~ X * W", highlight = "X:W"),
      '<div class="mt-1">',
      sprintf('<small class="text-muted">F(%d, %d) = %.2f, p %s | Adj. R² = %.3f</small>',
              f_stat[2], f_stat[3], f_stat[1],
              if (f_p < 0.001) "< .001" else sprintf("= %.3f", f_p),
              s$adj.r.squared),
      '</div>'
    ))
  })

  output$modr_slopes_table <- renderTable({
    req(modr_data())
    modr_data()$slopes
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 3: Johnson-Neyman
  # ══════════════════════════════════════════════════════════════════════
  jn_data <- eventReactive(input$jn_run, {
    set.seed(sample(1:10000, 1))
    n <- input$jn_n
    noise <- input$jn_noise
    b1 <- input$jn_b1
    b3 <- input$jn_b3
    alpha <- input$jn_alpha

    X <- rnorm(n)
    W <- rnorm(n)
    Y <- b1 * X + 0.2 * W + b3 * X * W + rnorm(n, 0, noise)

    df <- data.frame(X = X, W = W, Y = Y)
    fit <- lm(Y ~ X * W, data = df)

    # Compute conditional effect and CI across W range
    w_range <- seq(min(W) - 0.5, max(W) + 0.5, length.out = 200)
    vcov_mat <- vcov(fit)
    t_crit <- qt(1 - alpha / 2, df = n - 4)

    cond_eff <- coef(fit)["X"] + coef(fit)["X:W"] * w_range
    se_eff <- sqrt(vcov_mat["X","X"] + 2*w_range*vcov_mat["X","X:W"] +
                   w_range^2*vcov_mat["X:W","X:W"])
    ci_lo <- cond_eff - t_crit * se_eff
    ci_hi <- cond_eff + t_crit * se_eff

    # Find J-N points (where CI crosses zero)
    sign_changes_lo <- which(diff(sign(ci_lo)) != 0)
    sign_changes_hi <- which(diff(sign(ci_hi)) != 0)
    jn_points <- numeric()

    for (idx in c(sign_changes_lo, sign_changes_hi)) {
      # Linear interpolation
      w1 <- w_range[idx]; w2 <- w_range[idx + 1]
      # Solve: cond_eff = ± t_crit * se_eff
      # Approximate by interpolation on the CI bound that crosses zero
      if (idx %in% sign_changes_lo) {
        y1 <- ci_lo[idx]; y2 <- ci_lo[idx + 1]
      } else {
        y1 <- ci_hi[idx]; y2 <- ci_hi[idx + 1]
      }
      jn_w <- w1 - y1 * (w2 - w1) / (y2 - y1)
      jn_points <- c(jn_points, jn_w)
    }
    jn_points <- sort(unique(round(jn_points, 3)))

    jn_df <- data.frame(W = w_range, Effect = cond_eff, SE = se_eff,
                        CI_lo = ci_lo, CI_hi = ci_hi,
                        Significant = (ci_lo > 0 | ci_hi < 0))

    list(df = df, fit = fit, jn_df = jn_df, jn_points = jn_points,
         alpha = alpha, w_range = range(W))
  })

  output$jn_plot <- renderPlot(bg = "transparent", {
    req(jn_data())
    d <- jn_data()
    jdf <- d$jn_df

    p <- ggplot(jdf, aes(x = W, y = Effect)) +
      geom_ribbon(aes(ymin = CI_lo, ymax = CI_hi, fill = Significant), alpha = 0.25) +
      geom_line(linewidth = 1.2, color = "#268bd2") +
      geom_hline(yintercept = 0, linetype = "dashed", color = "#dc322f", linewidth = 0.6) +
      scale_fill_manual(values = c("TRUE" = "#2aa198", "FALSE" = "#839496"),
                        labels = c("TRUE" = "Significant", "FALSE" = "Not significant"),
                        name = NULL) +
      labs(title = "Johnson-Neyman Plot: Conditional Effect of X on Y",
           subtitle = sprintf("Alpha = %.2f | J-N point(s): %s",
                              d$alpha,
                              if (length(d$jn_points) == 0) "none within range"
                              else paste(sprintf("W = %.2f", d$jn_points), collapse = ", ")),
           x = "Moderator (W)", y = "Conditional Effect of X on Y")

    # Mark J-N points
    if (length(d$jn_points) > 0) {
      for (jnp in d$jn_points) {
        p <- p + geom_vline(xintercept = jnp, linetype = "dotted",
                            color = "#b58900", linewidth = 0.8)
      }
    }

    # Mark observed W range
    p + annotate("segment", x = d$w_range[1], xend = d$w_range[2],
                 y = min(jdf$CI_lo) * 1.05, yend = min(jdf$CI_lo) * 1.05,
                 color = "#586e75", linewidth = 2, alpha = 0.4) +
      annotate("text", x = mean(d$w_range), y = min(jdf$CI_lo) * 1.1,
               label = "Observed W range", color = "#586e75", size = 3)
  })

  output$jn_summary <- renderUI({
    req(jn_data())
    d <- jn_data()
    pts <- d$jn_points

    if (length(pts) == 0) {
      tags$div(class = "alert alert-info",
        icon("info-circle"),
        " The conditional effect of X on Y is either always significant or never significant across the observed range of W. No transition point was found.")
    } else if (length(pts) == 1) {
      # Determine direction
      jdf <- d$jn_df
      above <- jdf$Significant[jdf$W > pts[1]]
      pct_above <- mean(above, na.rm = TRUE)
      if (pct_above > 0.5) {
        msg <- sprintf("The effect of X on Y becomes significant when W > %.2f.", pts[1])
      } else {
        msg <- sprintf("The effect of X on Y becomes significant when W < %.2f.", pts[1])
      }
      tags$div(class = "alert alert-success",
        icon("check-circle"), " ", tags$strong("Johnson-Neyman point: "),
        sprintf("W = %.2f. ", pts[1]), msg)
    } else {
      tags$div(class = "alert alert-success",
        icon("check-circle"), " ", tags$strong("Johnson-Neyman points: "),
        paste(sprintf("W = %.2f", pts), collapse = " and "), ". ",
        "The effect of X on Y is significant outside the interval [",
        sprintf("%.2f, %.2f", min(pts), max(pts)), "].")
    }
  })

  # ══════════════════════════════════════════════════════════════════════
  # Tab 4: Combined Models (Moderated Mediation)
  # ══════════════════════════════════════════════════════════════════════
  mm_data <- eventReactive(input$mm_run, {
    set.seed(sample(1:10000, 1))
    n <- input$mm_n
    noise <- input$mm_noise

    X <- rnorm(n)
    W <- rnorm(n)
    # a path moderated by W
    M <- (input$mm_a + input$mm_a_mod * W) * X + rnorm(n, 0, noise)
    Y <- input$mm_cp * X + input$mm_b * M + rnorm(n, 0, noise)

    df <- data.frame(X = X, W = W, M = M, Y = Y)

    # Fit models
    fit_m <- lm(M ~ X * W, data = df)
    fit_y <- lm(Y ~ X + M, data = df)

    # Conditional indirect effects at W = -1, 0, +1 SD
    w_vals <- c(-1, 0, 1) * sd(W)
    a_cond <- coef(fit_m)["X"] + coef(fit_m)["X:W"] * w_vals
    b_hat <- coef(fit_y)["M"]
    indirect <- a_cond * b_hat

    # Bootstrap index of moderated mediation
    n_boot <- 2000
    index_boot <- numeric(n_boot)
    for (i in seq_len(n_boot)) {
      idx <- sample(n, replace = TRUE)
      d <- df[idx, ]
      fm <- coef(lm(M ~ X * W, data = d))
      fy <- coef(lm(Y ~ X + M, data = d))
      index_boot[i] <- fm["X:W"] * fy["M"]
    }

    list(df = df, fit_m = fit_m, fit_y = fit_y,
         w_vals = w_vals, indirect = indirect,
         b_hat = b_hat, index_boot = index_boot)
  })

  output$mm_plot <- renderPlot(bg = "transparent", {
    req(mm_data())
    d <- mm_data()
    W <- d$df$W

    w_range <- seq(min(W), max(W), length.out = 100)
    a_cond <- coef(d$fit_m)["X"] + coef(d$fit_m)["X:W"] * w_range
    indirect_range <- a_cond * d$b_hat

    plot_df <- data.frame(W = w_range, Indirect = indirect_range)

    # Points for low/mean/high
    pts <- data.frame(
      W = d$w_vals,
      Indirect = d$indirect,
      Label = c("W = -1 SD", "W = Mean", "W = +1 SD")
    )

    ggplot(plot_df, aes(W, Indirect)) +
      geom_line(linewidth = 1.2, color = "#268bd2") +
      geom_hline(yintercept = 0, linetype = "dashed", color = "#dc322f", linewidth = 0.6) +
      geom_point(data = pts, aes(W, Indirect), size = 4, color = "#2aa198") +
      geom_text(data = pts, aes(W, Indirect, label = Label),
                vjust = -1.5, size = 3.5, color = "#657b83") +
      labs(title = "Conditional Indirect Effect Across Moderator (W)",
           subtitle = "Indirect = (a + a_mod*W) * b",
           x = "Moderator (W)", y = "Indirect Effect of X on Y through M")
  })

  output$mm_table <- renderTable({
    req(mm_data())
    d <- mm_data()
    data.frame(
      `W Level` = c("-1 SD", "Mean", "+1 SD"),
      `W Value` = sprintf("%.2f", d$w_vals),
      `Conditional a` = sprintf("%.3f",
        coef(d$fit_m)["X"] + coef(d$fit_m)["X:W"] * d$w_vals),
      b = sprintf("%.3f", d$b_hat),
      `Indirect Effect` = sprintf("%.3f", d$indirect),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$mm_index <- renderUI({
    req(mm_data())
    d <- mm_data()
    idx_est <- coef(d$fit_m)["X:W"] * d$b_hat
    ci <- quantile(d$index_boot, c(0.025, 0.975))
    sig <- (ci[1] > 0 | ci[2] < 0)

    tags$div(
      class = if (sig) "alert alert-success" else "alert alert-secondary",
      tags$strong("Index of Moderated Mediation: "),
      sprintf("%.3f", idx_est),
      tags$br(),
      sprintf("95%% Bootstrap CI: [%.3f, %.3f]", ci[1], ci[2]),
      tags$br(),
      if (sig)
        "The indirect effect significantly differs across levels of the moderator."
      else
        "The indirect effect does NOT significantly differ across levels of the moderator."
    )
  })
  })
}
