# ===========================================================================
# Module: Effect Size Explorer
# Convert between effect size metrics, visualize distributional overlap,
# and calculate number needed to treat
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
effect_size_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Effect Size Explorer",
  icon = icon("ruler-combined"),
  navset_card_tab(
    id = ns("es_tabs"),

    # ── Tab 1: Cohen's d & Overlap ─────────────────────────────────────
    nav_panel("Cohen's d & Overlap", icon = icon("circle-half-stroke"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Cohen's d",
          tags$p(class = "text-muted small mb-2",
            "Set a standardised mean difference (Cohen's d) and see how
             two distributions overlap."),
          sliderInput(ns("es_d"), "Cohen's d", 0, 3, 0.5, step = 0.05),
          sliderInput(ns("es_n1"), "Group 1 n", 10, 500, 100, step = 10),
          sliderInput(ns("es_n2"), "Group 2 n", 10, 500, 100, step = 10),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Benchmarks (Cohen, 1988): small = 0.2, medium = 0.5, large = 0.8.
             But context matters more than benchmarks.")
        ),

        explanation_box(
          tags$strong("Cohen's d & Distributional Overlap"),
          tags$p("Cohen's d expresses the difference between two group means
                  in units of standard deviation:"),
          tags$p(tags$code("d = (M\u2081 \u2212 M\u2082) / SD\u209a\u2092\u2092\u2097\u2091\u1d48")),
          tags$ul(
            tags$li(tags$strong("Overlap coefficient (OVL):"),
              " The proportion of the two distributions that overlaps.
                At d = 0, OVL = 100%. At d = 2, OVL \u2248 32%."),
            tags$li(tags$strong("Probability of superiority (PS):"),
              " P(random person from Group 1 > random person from Group 2).
                Also called the Common Language Effect Size (CLES)."),
            tags$li(tags$strong("Cohen's U\u2083:"),
              " The percentage of the higher group that exceeds the median
                of the lower group."),
            tags$li(tags$strong("% non-overlap:"),
              " The proportion of the combined distributions that does NOT overlap.")
          ),
          tags$p("These translations help communicate effect sizes to
                  non-technical audiences. A d of 0.5 means 80% overlap
                  and a 64% probability of superiority.")
        ),

        card(
          card_header("Distribution Overlap"),
          plotlyOutput(ns("es_overlap_plot"), height = "320px")
        ),

        card(
          card_header("Effect Size Translations"),
          uiOutput(ns("es_translations"))
        )
      )
    ),

    # ── Tab 2: Effect Size Converter ───────────────────────────────────
    nav_panel("Converter", icon = icon("arrows-rotate"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Convert Effect Sizes",
          tags$p(class = "text-muted small mb-2",
            "Enter an effect size in one metric and convert to all others."),
          selectInput(ns("es_conv_from"), "Convert from",
            choices = c("Cohen's d" = "d",
                        "Correlation r" = "r",
                        "Odds Ratio (OR)" = "or",
                        "\u03b7\u00b2 (eta-squared)" = "eta2",
                        "R\u00b2" = "r2",
                        "Log Odds Ratio" = "log_or"),
            selected = "d"),
          numericInput(ns("es_conv_value"), "Value", value = 0.5, step = 0.05),
          sliderInput(ns("es_conv_n1"), "Group 1 n (for CI)", 10, 500, 50, step = 10),
          sliderInput(ns("es_conv_n2"), "Group 2 n (for CI)", 10, 500, 50, step = 10),
          actionButton(ns("es_conv_run"), "Convert", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Effect Size Conversion Formulas"),
          tags$p("Different fields and designs use different effect size
                  metrics. Converting between them enables comparison:"),
          tags$ul(
            tags$li(tags$strong("d \u2194 r:"), tags$code(" r = d / \u221a(d\u00b2 + 4)"),
              " ; ", tags$code("d = 2r / \u221a(1 \u2212 r\u00b2)")),
            tags$li(tags$strong("d \u2194 OR:"),
              tags$code(" log(OR) = d \u00d7 \u03c0 / \u221a3"),
              " (logistic approximation)"),
            tags$li(tags$strong("r \u2194 R\u00b2:"), tags$code(" R\u00b2 = r\u00b2"),
              " (for bivariate case)"),
            tags$li(tags$strong("r \u2194 \u03b7\u00b2:"),
              " For two groups, \u03b7\u00b2 = r\u00b2. More generally,
                \u03b7\u00b2 = SS\u2091\u2092\u209c\u2093\u2091\u2091\u2099 / SS\u209c\u2092\u209c\u2090\u2097.")
          ),
          tags$p(tags$strong("Caution:"), " These conversions assume certain
                  conditions (e.g., equal group sizes, normal distributions).
                  They are approximations, not exact equalities.")
        ),

        card(
          card_header("Conversion Results"),
          uiOutput(ns("es_conv_results"))
        )
      )
    ),

    # ── Tab 3: Number Needed to Treat ──────────────────────────────────
    nav_panel("NNT & Clinical Significance", icon = icon("user-plus"),
      layout_sidebar(
        sidebar = sidebar(
          title = "NNT Calculator",
          tags$p(class = "text-muted small mb-2",
            "Translate effect sizes into the Number Needed to Treat \u2014
             how many patients must be treated for one additional success."),
          sliderInput(ns("es_nnt_cer"), "Control Event Rate (CER)",
                      0.01, 0.95, 0.30, step = 0.01),
          sliderInput(ns("es_nnt_d"), "Cohen's d of treatment",
                      0, 2, 0.5, step = 0.05),
          tags$hr(),
          tags$p(class = "text-muted small",
            "Alternatively, enter rates directly:"),
          numericInput(ns("es_nnt_eer"), "Experimental Event Rate (EER)",
                       value = NULL, min = 0, max = 1, step = 0.01),
          actionButton(ns("es_nnt_run"), "Calculate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Number Needed to Treat (NNT)"),
          tags$p("NNT answers: ", tags$em("How many patients must receive the
                  treatment for one additional patient to benefit?"), " It is one
                  of the most intuitive ways to communicate treatment effectiveness
                  to clinicians and patients. Unlike abstract measures such as Cohen's d
                  or odds ratios, NNT directly conveys the practical impact of an
                  intervention in terms of individual patients."),
          tags$ul(
            tags$li(tags$strong("NNT = 1 / ARR"), " where ARR = Absolute Risk
              Reduction = CER \u2212 EER."),
            tags$li(tags$strong("From Cohen's d:"), " Convert CER to a z-score,
              shift by d, and convert back to get EER. Then NNT = 1 / (CER \u2212 EER)."),
            tags$li("NNT = 1 is perfect (every patient benefits).
              NNT = \u221e means no effect."),
            tags$li("NNT depends on the ", tags$strong("base rate"),
              " \u2014 the same d translates to different NNTs at different
              CERs. A d = 0.5 gives NNT \u2248 6 at CER = 0.30, but
              NNT \u2248 9 at CER = 0.10."),
            tags$li(tags$strong("NNH"), " (Number Needed to Harm) uses the
              same formula when the treatment increases adverse events.")
          ),
          tags$p("A common mistake is interpreting NNT without considering the baseline
                  risk. An NNT of 10 means something very different for a life-threatening
                  condition versus a mild symptom. NNT should always be reported alongside
                  confidence intervals and the time frame of the study, as treatment effects
                  may accumulate or diminish over time."),
          tags$p("NNT is also useful for comparing interventions: a treatment with NNT = 5
                  is twice as effective (in absolute terms) as one with NNT = 10, assuming
                  similar patient populations and outcome definitions.")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("NNT Results"),
            uiOutput(ns("es_nnt_results"))
          ),
          card(
            card_header("NNT Across Base Rates"),
            plotlyOutput(ns("es_nnt_plot"), height = "320px")
          )
        ),

        card(
          card_header("Visual: Treated vs. Control Outcomes"),
          plotlyOutput(ns("es_nnt_icon_plot"), height = "280px")
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

effect_size_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 1 — Cohen's d & Overlap
  # ═══════════════════════════════════════════════════════════════════════

  output$es_overlap_plot <- plotly::renderPlotly({
    d <- input$es_d
    x <- seq(-4, 4 + d, length.out = 500)
    y1 <- dnorm(x, mean = 0)
    y2 <- dnorm(x, mean = d)
    y_min <- pmin(y1, y2)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = x, y = y_min, type = "scatter", mode = "none",
        fill = "tozeroy", fillcolor = "rgba(42,161,152,0.3)",
        name = "Overlap", showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::add_trace(
        x = x, y = y1, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2), name = "Group 1"
      ) |>
      plotly::add_trace(
        x = x, y = y2, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2), name = "Group 2"
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0, x1 = 0, y0 = 0, y1 = max(y1),
               line = list(color = "#268bd2", dash = "dash", width = 1)),
          list(type = "line", x0 = d, x1 = d, y0 = 0, y1 = max(y2),
               line = list(color = "#dc322f", dash = "dash", width = 1))
        ),
        title = list(text = sprintf("d = %.2f \u2014 Distribution Overlap", d),
                     font = list(size = 14)),
        xaxis = list(title = "Standard Deviation Units"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$es_translations <- renderUI({
    d <- input$es_d
    n1 <- input$es_n1
    n2 <- input$es_n2

    # Overlap coefficient: 2 * Phi(-|d|/2)
    ovl <- 2 * pnorm(-abs(d) / 2)
    # Probability of superiority (CLES)
    ps <- pnorm(d / sqrt(2))
    # Cohen's U3: Phi(d)
    u3 <- pnorm(d)
    # Correlation r
    r <- d / sqrt(d^2 + 4)
    # Eta-squared (two groups, equal n approximation)
    eta2 <- d^2 / (d^2 + 4)
    # Variance-accounted (rough)
    # NNT at 50% base rate
    eer_50 <- pnorm(qnorm(0.5) + d)
    nnt_50 <- if (abs(0.5 - eer_50) > 0.001) 1 / abs(0.5 - eer_50) else Inf

    # CI for d (approximate)
    se_d <- sqrt((n1 + n2) / (n1 * n2) + d^2 / (2 * (n1 + n2)))
    lo <- d - 1.96 * se_d
    hi <- d + 1.96 * se_d

    bench <- if (abs(d) < 0.2) "Negligible"
             else if (abs(d) < 0.5) "Small"
             else if (abs(d) < 0.8) "Medium"
             else "Large"

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Metric</th><th>Value</th><th>Interpretation</th></tr></thead>
          <tbody>
            <tr style="background-color: rgba(42,161,152,0.08);">
                <td><strong>Cohen\'s d</strong></td><td>%.3f</td>
                <td>%s (95%% CI: [%.2f, %.2f])</td></tr>
            <tr><td>Overlap (OVL)</td><td>%.1f%%</td>
                <td>%% of distributions that overlap</td></tr>
            <tr><td>Prob. of Superiority (CLES)</td><td>%.1f%%</td>
                <td>P(Group 2 > Group 1)</td></tr>
            <tr><td>Cohen\'s U\u2083</td><td>%.1f%%</td>
                <td>%% of Group 2 above Group 1 median</td></tr>
            <tr><td>Non-overlap</td><td>%.1f%%</td>
                <td>%% of combined area not shared</td></tr>
            <tr><td>Correlation r</td><td>%.3f</td><td></td></tr>
            <tr><td>\u03b7\u00b2 (approx)</td><td>%.3f</td>
                <td>%.1f%% variance explained</td></tr>
            <tr><td>NNT (at 50%% base rate)</td><td>%.1f</td><td></td></tr>
          </tbody>
        </table>
      </div>',
      d, bench, lo, hi,
      ovl * 100, ps * 100, u3 * 100, (1 - ovl) * 100,
      r, eta2, eta2 * 100, nnt_50
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 2 — Converter
  # ═══════════════════════════════════════════════════════════════════════

  es_conv_data <- eventReactive(input$es_conv_run, {
    from <- input$es_conv_from
    val  <- input$es_conv_value
    n1   <- input$es_conv_n1
    n2   <- input$es_conv_n2

    # Convert everything to d first
    d <- switch(from,
      "d"      = val,
      "r"      = {
        r <- max(min(val, 0.999), -0.999)
        2 * r / sqrt(1 - r^2)
      },
      "or"     = log(val) * sqrt(3) / pi,
      "log_or" = val * sqrt(3) / pi,
      "eta2"   = {
        eta2 <- max(min(val, 0.999), 0.001)
        2 * sqrt(eta2 / (1 - eta2))
      },
      "r2"     = {
        r2 <- max(min(val, 0.999), 0.001)
        r <- sqrt(r2)
        2 * r / sqrt(1 - r^2)
      }
    )

    # Convert d to all others
    r      <- d / sqrt(d^2 + 4)
    or     <- exp(d * pi / sqrt(3))
    log_or <- d * pi / sqrt(3)
    eta2   <- d^2 / (d^2 + 4)
    r2     <- r^2
    ovl    <- 2 * pnorm(-abs(d) / 2)
    ps     <- pnorm(d / sqrt(2))

    # CI for d
    se_d <- sqrt((n1 + n2) / (n1 * n2) + d^2 / (2 * (n1 + n2)))
    d_lo <- d - 1.96 * se_d
    d_hi <- d + 1.96 * se_d

    list(d = d, r = r, or = or, log_or = log_or, eta2 = eta2, r2 = r2,
         ovl = ovl, ps = ps, d_lo = d_lo, d_hi = d_hi,
         from = from, original = val)
  })

  output$es_conv_results <- renderUI({
    req(es_conv_data())
    v <- es_conv_data()

    fmt_row <- function(name, val, fmt = "%.3f", is_source = FALSE) {
      bg <- if (is_source) "background-color: rgba(42,161,152,0.12);" else ""
      tag <- if (is_source) " \u2190 input" else ""
      sprintf('<tr style="%s"><td><strong>%s</strong></td><td>%s%s</td></tr>',
              bg, name, sprintf(fmt, val), tag)
    }

    rows <- paste0(
      fmt_row("Cohen's d", v$d, is_source = (v$from == "d")),
      fmt_row("95% CI for d", v$d_lo, fmt = sprintf("[%.3f, %.3f]", v$d_lo, v$d_hi)),
      fmt_row("Correlation r", v$r, is_source = (v$from == "r")),
      fmt_row("R\u00b2", v$r2, is_source = (v$from == "r2")),
      fmt_row("\u03b7\u00b2 (eta-squared)", v$eta2, is_source = (v$from == "eta2")),
      fmt_row("Odds Ratio", v$or, is_source = (v$from == "or")),
      fmt_row("Log Odds Ratio", v$log_or, is_source = (v$from == "log_or")),
      fmt_row("Overlap (OVL)", v$ovl * 100, fmt = "%.1f%%"),
      fmt_row("Prob. of Superiority", v$ps * 100, fmt = "%.1f%%")
    )

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Metric</th><th>Value</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="text-muted small mb-0">Conversions use standard approximations assuming
          equal group sizes and normal distributions.</p>
      </div>', rows))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 3 — NNT & Clinical Significance
  # ═══════════════════════════════════════════════════════════════════════

  es_nnt_vals <- eventReactive(input$es_nnt_run, {
    cer <- input$es_nnt_cer
    d   <- input$es_nnt_d
    eer_manual <- input$es_nnt_eer

    if (!is.null(eer_manual) && !is.na(eer_manual) && eer_manual > 0 && eer_manual < 1) {
      eer <- eer_manual
    } else {
      eer <- pnorm(qnorm(cer) + d)
    }

    arr <- cer - eer
    nnt <- if (abs(arr) > 0.0001) 1 / abs(arr) else Inf

    list(cer = cer, eer = eer, arr = arr, nnt = nnt, d = d)
  })

  output$es_nnt_results <- renderUI({
    req(es_nnt_vals())
    v <- es_nnt_vals()

    nnt_fmt <- if (is.finite(v$nnt)) sprintf("%.1f", v$nnt) else "\u221e"
    direction <- if (v$arr > 0) "benefit (fewer events in treatment)" else
                 if (v$arr < 0) "harm (more events in treatment)" else "no difference"

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 400px;">
          <tr><td><strong>Control Event Rate (CER)</strong></td>
              <td>%.1f%%</td></tr>
          <tr><td><strong>Experimental Event Rate (EER)</strong></td>
              <td>%.1f%%</td></tr>
          <tr><td><strong>Absolute Risk Reduction (ARR)</strong></td>
              <td>%.1f%% (%s)</td></tr>
          <tr><td><strong>Relative Risk Reduction (RRR)</strong></td>
              <td>%.1f%%</td></tr>
          <tr style="background-color: rgba(42,161,152,0.12);">
              <td><strong>NNT</strong></td>
              <td style="font-size: 1.3em; font-weight: 700; color: #2aa198;">%s</td></tr>
        </table>
        <p class="text-muted small mb-0">
          For every <strong>%s</strong> patients treated, one additional patient
          benefits compared to control.</p>
      </div>',
      v$cer * 100, v$eer * 100, abs(v$arr) * 100, direction,
      if (v$cer > 0) abs(v$arr / v$cer) * 100 else 0,
      nnt_fmt, nnt_fmt
    ))
  })

  output$es_nnt_plot <- plotly::renderPlotly({
    req(es_nnt_vals())
    v <- es_nnt_vals()
    d <- v$d

    cers <- seq(0.05, 0.90, by = 0.01)
    eers <- pnorm(qnorm(cers) + d)
    arrs <- cers - eers
    nnts <- ifelse(abs(arrs) > 0.001, 1 / abs(arrs), NA)
    y_max <- min(max(nnts, na.rm = TRUE), 50)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = cers, y = nnts, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2),
        name = "NNT curve", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("CER: %.0f%%<br>NNT: %.1f", cers * 100, nnts)
      ) |>
      plotly::add_markers(
        x = v$cer, y = v$nnt,
        marker = list(color = "#dc322f", size = 10),
        name = "Current setting", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("CER: %.0f%%<br>NNT: %.1f", v$cer * 100, v$nnt)
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = 0.05, x1 = 0.90,
          y0 = v$nnt, y1 = v$nnt,
          line = list(color = "#dc322f", dash = "dot", width = 1)
        )),
        title = list(text = sprintf("NNT across base rates (d = %.2f)", d),
                     font = list(size = 14)),
        xaxis = list(title = "Control Event Rate (CER)", tickformat = ".0%"),
        yaxis = list(title = "NNT", range = c(0, y_max)),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$es_nnt_icon_plot <- plotly::renderPlotly({
    req(es_nnt_vals())
    v <- es_nnt_vals()

    n_icons <- 100
    n_cer <- round(v$cer * n_icons)
    n_eer <- round(v$eer * n_icons)

    grid <- expand.grid(x = 1:10, y = 10:1)

    ctrl_status <- rep("No event", n_icons)
    ctrl_status[seq_len(n_cer)] <- "Event"

    trt_status <- rep("No event", n_icons)
    trt_status[seq_len(n_eer)] <- "Event"
    saved <- n_cer - n_eer
    if (saved > 0) trt_status[(n_eer + 1):n_cer] <- "Saved by treatment"

    col_map <- c("Event" = "#dc322f", "No event" = "#93a1a1",
                 "Saved by treatment" = "#2aa198")

    # Offset treatment group by 12 on x-axis
    ctrl_x <- grid$x
    trt_x  <- grid$x + 12

    all_x <- c(ctrl_x, trt_x)
    all_y <- c(grid$y, grid$y)
    all_status <- c(ctrl_status, trt_status)
    all_colors <- col_map[all_status]

    plotly::plot_ly() |>
      plotly::add_markers(
        x = all_x, y = all_y,
        marker = list(color = all_colors, size = 8, symbol = "circle"),
        hoverinfo = "text",
        hovertext = paste0(
          ifelse(all_x <= 10, "Control", "Treatment"),
          ": ", all_status
        ),
        showlegend = FALSE
      ) |>
      # Legend entries
      plotly::add_markers(x = NA, y = NA, marker = list(color = "#dc322f", size = 8),
                          name = "Event", visible = "legendonly") |>
      plotly::add_markers(x = NA, y = NA, marker = list(color = "#93a1a1", size = 8),
                          name = "No event", visible = "legendonly") |>
      plotly::add_markers(x = NA, y = NA, marker = list(color = "#2aa198", size = 8),
                          name = "Saved by treatment", visible = "legendonly") |>
      plotly::layout(
        annotations = list(
          list(x = 5.5, y = 11, text = "<b>Control</b>", showarrow = FALSE,
               font = list(size = 13)),
          list(x = 17.5, y = 11, text = "<b>Treatment</b>", showarrow = FALSE,
               font = list(size = 13))
        ),
        title = list(
          text = sprintf("100 patients per group (NNT \u2248 %.0f)<br><sup>Green = %d patients saved by treatment</sup>",
                         v$nnt, max(saved, 0)),
          font = list(size = 14)),
        xaxis = list(visible = FALSE, range = c(0, 23)),
        yaxis = list(visible = FALSE, range = c(0, 12)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.05),
        margin = list(t = 60, b = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  })
}
