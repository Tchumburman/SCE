# ===========================================================================
# Module: Type I & Type II Errors
# Visualise alpha (Type I), beta (Type II), power, and the decision table
# interactively across effect size, sample size, and significance level.
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
type12_error_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Type I & II Errors",
  icon = icon("circle-exclamation"),
  navset_card_tab(
    id = ns("t12_tabs"),

    # ── Tab 1: Distribution Diagram ─────────────────────────────────────
    nav_panel("Error Visualiser", icon = icon("chart-area"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Parameters",
          width = 290,

          tags$p(class = "text-muted small mb-2",
            "Adjust the sliders to see how the two hypothesis distributions
             overlap and where each type of error lives."),

          sliderInput(ns("t12_delta"),
                      HTML("True mean difference (&mu;<sub>1</sub> &minus; &mu;<sub>0</sub>)"),
                      min = 0, max = 3, value = 1, step = 0.05),
          sliderInput(ns("t12_sigma"), HTML("Population SD (&sigma;)"),
                      min = 0.5, max = 3, value = 1, step = 0.05),
          sliderInput(ns("t12_n"), "Sample size per group (n)",
                      min = 5, max = 300, value = 30, step = 5),
          sliderInput(ns("t12_alpha"), HTML("Significance level (&alpha;)"),
                      min = 0.001, max = 0.20, value = 0.05, step = 0.001),
          selectInput(ns("t12_tails"), "Test direction",
                      choices = c("Two-tailed" = "two", "One-tailed (upper)" = "one"),
                      selected = "two"),
          tags$hr(),
          checkboxInput(ns("t12_show_alpha"), HTML("Shade &alpha; (Type I error)"),  value = TRUE),
          checkboxInput(ns("t12_show_beta"),  HTML("Shade &beta; (Type II error)"),  value = TRUE),
          checkboxInput(ns("t12_show_power"), HTML("Shade Power (1 &minus; &beta;)"), value = TRUE)
        ),

        explanation_box(
          tags$strong("Type I & Type II Errors"),
          tags$p("Every null-hypothesis significance test makes a binary decision: reject H\u2080 or
                  retain it. Because we are working with samples rather than the full population,
                  this decision can be wrong in two distinct ways."),
          tags$ul(
            tags$li(tags$strong("Type I error (\u03b1) \u2014 False Positive:"),
              " Rejecting H\u2080 when H\u2080 is actually true. The significance level \u03b1
                directly controls this probability \u2014 if you set \u03b1 = 0.05, you accept a
                5% chance of a false positive on any single test. The orange region on the H\u2080
                distribution shows exactly where these errors occur: in the tails beyond the
                critical value."),
            tags$li(tags$strong("Type II error (\u03b2) \u2014 False Negative:"),
              " Failing to reject H\u2080 when H\u2081 is actually true. Unlike \u03b1, \u03b2 is
                not set directly. It depends on how far apart the two distributions are (the true
                effect size), how precisely the mean is estimated (sample size and SD), and how
                strictly we set \u03b1. The purple region on the H\u2081 distribution shows the
                portion that falls below the critical value \u2014 tests whose result lands here
                will (incorrectly) be retained as null."),
            tags$li(tags$strong("Power (1 \u2212 \u03b2) \u2014 True Positive:"),
              " The probability of correctly detecting a real effect. The teal region shows the
                portion of the H\u2081 distribution that clears the critical value. Conventional
                minimum targets are 80% (behavioral research) and 95% (clinical trials and
                high-stakes decisions). Underpowered studies waste resources and produce
                unreliable estimates even when they do reach significance.")
          ),
          tags$p("The dashed vertical line is the ", tags$strong("critical value"), " \u2014
                  the threshold set by \u03b1 under H\u2080. The ", tags$strong("left (blue) curve"),
                  " is the sampling distribution of the mean under H\u2080 (\u03bc = 0). The ",
                  tags$strong("right (red) curve"), " is the sampling distribution under H\u2081,
                  centred at the true mean difference. As n increases, both curves narrow and
                  separate, reducing \u03b2 without changing \u03b1. As the true effect decreases,
                  the curves shift closer together and overlap more, increasing \u03b2."),
          tags$p(tags$strong("Cohen\u2019s d"), " (displayed in the plot title) standardises the
                  mean difference by \u03c3, making it comparable across studies regardless of
                  measurement scale. The SE is \u03c3\u2009/\u2009\u221an and determines how wide
                  each curve is."),
          guide = tags$ol(
            tags$li("With defaults, locate all three coloured regions in the plot."),
            tags$li("Drag \u03b1 upward: the orange region grows, the purple (\u03b2) shrinks,
                     and power rises \u2014 you gain sensitivity at the cost of more false positives."),
            tags$li("Increase n: both curves narrow; \u03b2 shrinks and power rises without
                     touching \u03b1. This is the cleanest way to improve a study."),
            tags$li("Reduce the true mean difference toward 0: the curves converge, \u03b2
                     expands, and power falls \u2014 small effects require large samples to detect."),
            tags$li("Switch to one-tailed: the critical value shifts left, gaining power in one
                     direction at the cost of ignoring effects in the other.")
          )
        ),

        card(full_screen = TRUE,
          card_header("H\u2080 vs H\u2081 Sampling Distributions \u2014 Error Regions"),
          plotlyOutput(ns("t12_dist_plot"), height = "380px")
        ),

        card(
          card_header("Error Summary"),
          tableOutput(ns("t12_summary_table"))
        )
      )
    ),

    # ── Tab 2: Power Curves ──────────────────────────────────────────────
    nav_panel("Power Curves", icon = icon("chart-line"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Power Curve Controls",
          width = 290,

          tags$p(class = "text-muted small mb-2",
            "Plot power as a function of sample size or effect size,
             with all other parameters held constant."),

          selectInput(ns("t12_pc_xvar"), "X-axis variable",
                      choices = c("Sample size (n)"           = "n",
                                  "Effect size (Cohen\u2019s d)" = "d"),
                      selected = "n"),
          sliderInput(ns("t12_pc_alpha"), HTML("Significance level (&alpha;)"),
                      min = 0.001, max = 0.20, value = 0.05, step = 0.001),

          conditionalPanel(ns = ns, "input.t12_pc_xvar === 'n'",
            sliderInput(ns("t12_pc_d"), "Cohen\u2019s d (fixed)",
                        min = 0.1, max = 2, value = 0.5, step = 0.05),
            sliderInput(ns("t12_pc_nmax"), "Max n per group",
                        min = 50, max = 500, value = 200, step = 10)
          ),
          conditionalPanel(ns = ns, "input.t12_pc_xvar === 'd'",
            sliderInput(ns("t12_pc_n"), "Sample size n (fixed)",
                        min = 5, max = 300, value = 50, step = 5)
          ),

          selectInput(ns("t12_pc_tails"), "Test direction",
                      choices = c("Two-tailed" = "two", "One-tailed (upper)" = "one"),
                      selected = "two"),
          tags$hr(),
          checkboxInput(ns("t12_pc_line80"), "Show 80% power reference", value = TRUE),
          checkboxInput(ns("t12_pc_line95"), "Show 95% power reference", value = FALSE)
        ),

        explanation_box(
          tags$strong("Power Curves"),
          tags$p("A power curve traces how the probability of detecting a true effect changes as
                  one parameter varies while everything else stays fixed. Reading a power curve
                  before collecting data is a core part of study planning."),
          tags$ul(
            tags$li(tags$strong("Power vs n:"), " As sample size grows, the standard error
              (SE = \u03c3\u2009/\u2009\u221an) shrinks. Smaller SE means the H\u2081 distribution
              shifts further right of the critical value, reducing overlap and increasing power.
              The relationship is not linear: doubling power from 50% to nearly 100% may require
              quadrupling n. This is why planning ahead matters \u2014 post-hoc power calculations
              on non-significant results are not informative."),
            tags$li(tags$strong("Power vs d:"), " Larger true effects are easier to detect.
              At d = 0, power equals \u03b1 (the distributions are identical and any rejection
              is a false positive). As d grows, the two distributions separate and power rises
              toward 1. The curve shows the ", tags$strong("minimum detectable effect (MDE)"),
              " at any given n: the smallest d that achieves acceptable power."),
            tags$li(tags$strong("Role of \u03b1:"), " Increasing \u03b1 shifts the critical
              value left, mechanically raising power but also raising the Type I error rate.
              This is a genuine trade-off, not a free lunch.")
          ),
          tags$p("The 80% reference line (Cohen, 1988) is conventional but not sacrosanct. In
                  contexts where false negatives are costly (e.g., safety-critical screening,
                  rare-disease trials), target 90\u201395%. In exploratory work where follow-up is
                  cheap, 80% may be sufficient. The curve lets you see the sample-size cost of
                  each target explicitly."),
          guide = tags$ol(
            tags$li("With x = n and d = 0.5 (medium effect), find the n where the curve crosses
                     the 80% line. That is the conventionally required sample size."),
            tags$li("Halve the effect size to d = 0.25: observe how much n must grow to recover
                     the same power \u2014 roughly 4\u00d7 as many participants."),
            tags$li("Switch to x = d with n fixed: read off the MDE for your planned study."),
            tags$li("Increase \u03b1 to 0.10 and compare the curve to \u03b1 = 0.05: same power
                     is achievable with fewer participants, but at a higher false-positive rate.")
          )
        ),

        card(full_screen = TRUE,
          card_header("Power Curve"),
          plotlyOutput(ns("t12_power_plot"), height = "420px")
        )
      )
    ),

    # ── Tab 3: Decision Table ────────────────────────────────────────────
    nav_panel("Decision Table", icon = icon("table-cells"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Decision Table",
          width = 290,

          tags$p(class = "text-muted small mb-2",
            "Set study parameters and an assumed prevalence of true effects to
             see the full 2\u00d72 decision table with expected counts and
             derived rates."),

          sliderInput(ns("t12_dt_delta"), "True mean difference",
                      min = 0, max = 3, value = 1, step = 0.05),
          sliderInput(ns("t12_dt_sigma"), HTML("Population SD (&sigma;)"),
                      min = 0.5, max = 3, value = 1, step = 0.05),
          sliderInput(ns("t12_dt_n"), "Sample size per group (n)",
                      min = 5, max = 300, value = 30, step = 5),
          sliderInput(ns("t12_dt_alpha"), HTML("Significance level (&alpha;)"),
                      min = 0.001, max = 0.20, value = 0.05, step = 0.001),
          selectInput(ns("t12_dt_tails"), "Test direction",
                      choices = c("Two-tailed" = "two", "One-tailed (upper)" = "one"),
                      selected = "two"),
          tags$hr(),
          sliderInput(ns("t12_dt_prev"), "Prevalence of true effects (%)",
                      min = 1, max = 99, value = 30, step = 1),
          numericInput(ns("t12_dt_total"), "Total number of tests / studies",
                       value = 1000, min = 10, max = 100000, step = 10)
        ),

        explanation_box(
          tags$strong("The 2\u00d72 Decision Table & False Discovery Rate"),
          tags$p("Every statistical test produces one of four outcomes, depending on the decision
                  made (reject or retain H\u2080) and the underlying truth (H\u2080 or H\u2081):"),
          tags$table(class = "table table-sm table-bordered small",
            tags$thead(tags$tr(
              tags$th(""),
              tags$th("H\u2080 is True"),
              tags$th("H\u2081 is True")
            )),
            tags$tbody(
              tags$tr(
                tags$td(tags$strong("Reject H\u2080")),
                tags$td("False Positive \u2014 Type I error (\u03b1)"),
                tags$td("True Positive \u2014 Power (1 \u2212 \u03b2)")
              ),
              tags$tr(
                tags$td(tags$strong("Retain H\u2080")),
                tags$td("True Negative (1 \u2212 \u03b1)"),
                tags$td("False Negative \u2014 Type II error (\u03b2)")
              )
            )
          ),
          tags$p("The counts in each cell depend on three things: \u03b1, power (1 \u2212 \u03b2),
                  and the ", tags$strong("prevalence"), " \u2014 the proportion of tested hypotheses
                  that are actually true. Prevalence is rarely known but has a dramatic effect on
                  what a significant p-value actually means."),
          tags$p(tags$strong("Positive Predictive Value (PPV)"), " is the probability that a
                  significant result reflects a real effect. Using Bayes\u2019 theorem:"),
          tags$p(tags$code("PPV = (Power \u00d7 Prev) / (Power \u00d7 Prev + \u03b1 \u00d7 (1 \u2212 Prev))")),
          tags$p("When prevalence is low (e.g., 10% of tested hypotheses are true), even with
                  \u03b1 = 0.05 and 80% power, PPV is only about 64% \u2014 more than one-third of
                  significant findings will be false positives. This arithmetic partly underlies
                  the replication crisis in many fields. Raising power and pre-registering
                  hypotheses (increasing the effective prevalence) both improve PPV."),
          guide = tags$ol(
            tags$li("With 30% prevalence and default parameters, read the PPV and FDR in the
                     table below the decision grid."),
            tags$li("Reduce prevalence to 10%: watch the FDR climb steeply even though \u03b1 is
                     unchanged. This illustrates why broad exploratory screening produces many
                     spurious findings."),
            tags$li("Now raise power to 95% (increase n): PPV improves because the true-positive
                     cell grows relative to the false-positive cell."),
            tags$li("Set prevalence to 90% (a confirmatory study of a well-established effect):
                     PPV is very high; FDR is low even with modest power.")
          )
        ),

        card(
          card_header("Expected Outcomes across Studies / Tests"),
          uiOutput(ns("t12_decision_table"))
        ),

        card(
          card_header("Positive Predictive Value, False Discovery Rate & Negative Predictive Value"),
          uiOutput(ns("t12_fdr_info"))
        )
      )
    )
  )
)
}

# ---------------------------------------------------------------------------
# Helper: compute power for a two-sample z-test
# ---------------------------------------------------------------------------
.t12_power <- function(delta, sigma, n, alpha, tails) {
  se  <- sigma / sqrt(n)
  d   <- delta / sigma
  ncp <- delta / se

  if (tails == "two") {
    cv    <- qnorm(1 - alpha / 2)
    power <- 1 - pnorm(cv - ncp) + pnorm(-cv - ncp)
  } else {
    cv    <- qnorm(1 - alpha)
    power <- 1 - pnorm(cv - ncp)
  }
  list(power = power, cv = cv, ncp = ncp, se = se, d = d)
}

# Helper: build a closed filled polygon for plotly (area under a curve segment)
.t12_fill_poly <- function(xs, ys) {
  list(x = c(xs[1], xs, xs[length(xs)]),
       y = c(0,     ys, 0))
}


# ---------------------------------------------------------------------------
# SERVER
# ---------------------------------------------------------------------------

type12_error_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: Distribution plot ─────────────────────────────────────────
  output$t12_dist_plot <- renderPlotly({
    delta <- input$t12_delta
    sigma <- input$t12_sigma
    n     <- input$t12_n
    alpha <- input$t12_alpha
    tails <- input$t12_tails

    res <- .t12_power(delta, sigma, n, alpha, tails)
    se  <- res$se
    cv  <- res$cv

    mu0 <- 0
    mu1 <- delta
    xs  <- seq(mu0 - 4.5 * se, mu1 + 4.5 * se, length.out = 800)

    cv_upper <- mu0 + cv * se
    cv_lower <- mu0 - cv * se

    d0 <- dnorm(xs, mu0, se)
    d1 <- dnorm(xs, mu1, se)

    title_text <- sprintf(
      "d = %.2f  |  SE = %.3f  |  \u03b1 = %.3f  |  \u03b2 = %.3f  |  Power = %.3f",
      res$d, se, alpha, 1 - res$power, res$power
    )

    p <- plotly::plot_ly() |>

      # H0 distribution line
      plotly::add_trace(
        x = xs, y = d0, type = "scatter", mode = "lines",
        line = list(color = "#0077bb", width = 2.5),
        name = "H\u2080 (null)",
        hoverinfo = "text",
        text = paste0("x = ", round(xs, 3), "<br>H\u2080 density: ", round(d0, 4))
      ) |>

      # H1 distribution line
      plotly::add_trace(
        x = xs, y = d1, type = "scatter", mode = "lines",
        line = list(color = "#cc3311", width = 2.5),
        name = "H\u2081 (alternative)",
        hoverinfo = "text",
        text = paste0("x = ", round(xs, 3), "<br>H\u2081 density: ", round(d1, 4))
      )

    # Shade Type I error: upper tail of H0 (and lower tail if two-tailed)
    if (input$t12_show_alpha) {
      xs_a <- xs[xs >= cv_upper]
      if (length(xs_a) > 1) {
        poly <- .t12_fill_poly(xs_a, dnorm(xs_a, mu0, se))
        p <- p |> plotly::add_trace(
          x = poly$x, y = poly$y,
          type = "scatter", mode = "lines", fill = "toself",
          fillcolor = "rgba(238,119,51,0.45)",
          line = list(color = "transparent"),
          name = "\u03b1 (Type I error)",
          hoverinfo = "text",
          text = paste0("\u03b1 region<br>Type I error = ", round(alpha, 3))
        )
      }
      if (tails == "two") {
        xs_a2 <- xs[xs <= cv_lower]
        if (length(xs_a2) > 1) {
          poly2 <- .t12_fill_poly(xs_a2, dnorm(xs_a2, mu0, se))
          p <- p |> plotly::add_trace(
            x = poly2$x, y = poly2$y,
            type = "scatter", mode = "lines", fill = "toself",
            fillcolor = "rgba(238,119,51,0.45)",
            line = list(color = "transparent"),
            showlegend = FALSE,
            hoverinfo = "text",
            text = paste0("\u03b1 region (left tail)<br>Type I error = ", round(alpha / 2, 4))
          )
        }
      }
    }

    # Shade Type II error: H1 distribution below cv_upper
    if (input$t12_show_beta) {
      xs_b <- xs[xs <= cv_upper]
      if (length(xs_b) > 1) {
        poly <- .t12_fill_poly(xs_b, dnorm(xs_b, mu1, se))
        p <- p |> plotly::add_trace(
          x = poly$x, y = poly$y,
          type = "scatter", mode = "lines", fill = "toself",
          fillcolor = "rgba(170,51,119,0.40)",
          line = list(color = "transparent"),
          name = "\u03b2 (Type II error)",
          hoverinfo = "text",
          text = paste0("\u03b2 region<br>Type II error = ", round(1 - res$power, 3))
        )
      }
    }

    # Shade Power: H1 distribution above cv_upper
    if (input$t12_show_power) {
      xs_p <- xs[xs >= cv_upper]
      if (length(xs_p) > 1) {
        poly <- .t12_fill_poly(xs_p, dnorm(xs_p, mu1, se))
        p <- p |> plotly::add_trace(
          x = poly$x, y = poly$y,
          type = "scatter", mode = "lines", fill = "toself",
          fillcolor = "rgba(0,153,136,0.40)",
          line = list(color = "transparent"),
          name = "Power (1\u2212\u03b2)",
          hoverinfo = "text",
          text = paste0("Power region<br>Power = ", round(res$power, 3))
        )
      }
    }

    # Critical value shape(s)
    y_max <- max(d0, d1) * 1.15
    shapes <- list(
      list(type = "line", x0 = cv_upper, x1 = cv_upper, y0 = 0, y1 = y_max,
           line = list(color = "grey40", width = 1.6, dash = "dash"))
    )
    if (tails == "two") {
      shapes <- c(shapes, list(
        list(type = "line", x0 = cv_lower, x1 = cv_lower, y0 = 0, y1 = y_max,
             line = list(color = "grey40", width = 1.6, dash = "dash"))
      ))
    }

    p |> plotly::layout(
      shapes = shapes,
      xaxis  = list(title = "Sample mean"),
      yaxis  = list(title = "Density", range = c(0, y_max)),
      annotations = list(
        list(x = 0.5, y = 1.07, xref = "paper", yref = "paper",
             text = title_text, showarrow = FALSE,
             font = list(size = 12))
      ),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.15, yanchor = "top"),
      margin = list(t = 40, b = 60)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Tab 1: Summary table ─────────────────────────────────────────────
  output$t12_summary_table <- renderTable({
    res <- .t12_power(input$t12_delta, input$t12_sigma,
                      input$t12_n, input$t12_alpha, input$t12_tails)
    data.frame(
      Quantity = c(
        "Cohen\u2019s d (standardised effect size)",
        "Standard error of the mean (SE = \u03c3 / \u221an)",
        "Significance level \u03b1 \u2014 Type I error rate",
        "Type II error rate \u03b2",
        "Power (1 \u2212 \u03b2)",
        "Critical z (two-tailed)",
        "Critical z (one-tailed)"
      ),
      Value = c(
        sprintf("%.3f", res$d),
        sprintf("%.4f", res$se),
        sprintf("%.3f", input$t12_alpha),
        sprintf("%.3f", 1 - res$power),
        sprintf("%.3f", res$power),
        sprintf("\u00b1%.3f", qnorm(1 - input$t12_alpha / 2)),
        sprintf("%.3f",  qnorm(1 - input$t12_alpha))
      )
    )
  }, striped = TRUE, bordered = TRUE, hover = TRUE)


  # ── Tab 2: Power curve ───────────────────────────────────────────────
  output$t12_power_plot <- renderPlotly({
    alpha <- input$t12_pc_alpha
    tails <- input$t12_pc_tails

    if (input$t12_pc_xvar == "n") {
      d_fixed   <- input$t12_pc_d
      n_seq     <- seq(5, input$t12_pc_nmax, by = 1)
      power_seq <- sapply(n_seq, function(n_)
        .t12_power(d_fixed, 1, n_, alpha, tails)$power)
      df_pc    <- data.frame(x = n_seq, power = power_seq)
      x_lab    <- "Sample size per group (n)"
      subtitle <- sprintf("d = %.2f  |  \u03b1 = %.3f  |  %s",
                          d_fixed, alpha,
                          if (tails == "two") "Two-tailed" else "One-tailed")

      # Find n for 80% and 95% power (for annotation)
      n80 <- if (any(power_seq >= 0.80)) n_seq[which(power_seq >= 0.80)[1]] else NA
      n95 <- if (any(power_seq >= 0.95)) n_seq[which(power_seq >= 0.95)[1]] else NA
    } else {
      n_fixed   <- input$t12_pc_n
      d_seq     <- seq(0.01, 2, by = 0.01)
      power_seq <- sapply(d_seq, function(d_)
        .t12_power(d_, 1, n_fixed, alpha, tails)$power)
      df_pc    <- data.frame(x = d_seq, power = power_seq)
      x_lab    <- "Cohen\u2019s d"
      subtitle <- sprintf("n = %d  |  \u03b1 = %.3f  |  %s",
                          n_fixed, alpha,
                          if (tails == "two") "Two-tailed" else "One-tailed")
      n80 <- NA; n95 <- NA
    }

    hover_text <- paste0(
      x_lab, " = ", round(df_pc$x, 2),
      "<br>Power = ", round(df_pc$power * 100, 1), "%"
    )

    p <- plotly::plot_ly() |>
      plotly::add_trace(
        x = df_pc$x, y = df_pc$power,
        type = "scatter", mode = "lines",
        line = list(color = "#0077bb", width = 2.5),
        name = "Power",
        hoverinfo = "text", text = hover_text
      )

    shapes      <- list()
    annotations <- list(
      list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
           text = subtitle, showarrow = FALSE, font = list(size = 13))
    )

    if (input$t12_pc_line80) {
      shapes <- c(shapes, list(
        list(type = "line", x0 = min(df_pc$x), x1 = max(df_pc$x),
             y0 = 0.80, y1 = 0.80,
             line = list(color = "#ee7733", width = 1.5, dash = "dash"))
      ))
      label_80 <- if (!is.na(n80)) {
        paste0("80% power  (n \u2265 ", n80, ")")
      } else "80% power"
      annotations <- c(annotations, list(
        list(x = max(df_pc$x), y = 0.82, xanchor = "right",
             text = label_80, showarrow = FALSE,
             font = list(size = 11, color = "#ee7733"))
      ))
    }

    if (input$t12_pc_line95) {
      shapes <- c(shapes, list(
        list(type = "line", x0 = min(df_pc$x), x1 = max(df_pc$x),
             y0 = 0.95, y1 = 0.95,
             line = list(color = "#aa3377", width = 1.5, dash = "dash"))
      ))
      label_95 <- if (!is.na(n95)) {
        paste0("95% power  (n \u2265 ", n95, ")")
      } else "95% power"
      annotations <- c(annotations, list(
        list(x = max(df_pc$x), y = 0.97, xanchor = "right",
             text = label_95, showarrow = FALSE,
             font = list(size = 11, color = "#aa3377"))
      ))
    }

    p |> plotly::layout(
      shapes      = shapes,
      annotations = annotations,
      xaxis = list(title = x_lab),
      yaxis = list(title = "Power (1 \u2212 \u03b2)",
                   tickformat = ".0%", range = c(0, 1.05)),
      margin = list(t = 45)
    ) |> plotly::config(displayModeBar = FALSE)
  })


  # ── Tab 3: Decision table ────────────────────────────────────────────
  output$t12_decision_table <- renderUI({
    res   <- .t12_power(input$t12_dt_delta, input$t12_dt_sigma,
                        input$t12_dt_n, input$t12_dt_alpha, input$t12_dt_tails)
    power <- res$power
    alpha <- input$t12_dt_alpha
    beta  <- 1 - power
    prev  <- input$t12_dt_prev / 100
    total <- input$t12_dt_total

    n_true  <- round(total * prev)
    n_false <- total - n_true

    tp <- round(n_true  * power)
    fn <- round(n_true  * beta)
    fp <- round(n_false * alpha)
    tn <- round(n_false * (1 - alpha))

    cell <- function(count, pct_label, outcome_label, bg) {
      tags$td(
        style = paste0("background:", bg, "; text-align:center;
                        vertical-align:middle; padding:12px;"),
        tags$div(class = "fw-bold", style = "font-size:1.6rem;", count),
        tags$div(class = "small fw-semibold", pct_label),
        tags$div(class = "text-muted", style = "font-size:0.78rem;", outcome_label)
      )
    }

    tags$table(class = "table table-bordered text-center mb-0",
      style = "font-size:0.92rem;",
      tags$thead(
        tags$tr(
          tags$th(style = "width:22%;", ""),
          tags$th(style = "background:#cce4f7;",
                  HTML(paste0("H<sub>0</sub> True<br><small>", n_false, " tests</small>"))),
          tags$th(style = "background:#fdd8d8;",
                  HTML(paste0("H<sub>1</sub> True<br><small>", n_true, " tests</small>")))
        )
      ),
      tags$tbody(
        tags$tr(
          tags$th(style = "vertical-align:middle;", HTML("Reject H<sub>0</sub>")),
          cell(fp,
               sprintf("\u03b1 = %.1f%%", alpha * 100),
               "Type I error \u2014 False Positive", "#fff3e0"),
          cell(tp,
               sprintf("Power = %.1f%%", power * 100),
               "Correct detection \u2014 True Positive", "#d4edda")
        ),
        tags$tr(
          tags$th(style = "vertical-align:middle;", HTML("Retain H<sub>0</sub>")),
          cell(tn,
               sprintf("1\u2212\u03b1 = %.1f%%", (1 - alpha) * 100),
               "Correct retention \u2014 True Negative", "#e8f4f8"),
          cell(fn,
               sprintf("\u03b2 = %.1f%%", beta * 100),
               "Missed effect \u2014 False Negative", "#fde8f0")
        )
      )
    )
  })

  output$t12_fdr_info <- renderUI({
    res   <- .t12_power(input$t12_dt_delta, input$t12_dt_sigma,
                        input$t12_dt_n, input$t12_dt_alpha, input$t12_dt_tails)
    power <- res$power
    alpha <- input$t12_dt_alpha
    beta  <- 1 - power
    prev  <- input$t12_dt_prev / 100

    ppv <- (power * prev) / (power * prev + alpha * (1 - prev))
    fdr <- 1 - ppv
    npv <- ((1 - alpha) * (1 - prev)) / ((1 - alpha) * (1 - prev) + beta * prev)

    fmt_pct <- function(x) sprintf("%.1f%%", x * 100)

    tags$div(
      tags$table(class = "table table-sm table-hover mb-2",
        tags$thead(tags$tr(
          tags$th("Metric"), tags$th("Value"), tags$th("Interpretation")
        )),
        tags$tbody(
          tags$tr(
            tags$td(tags$strong("Positive Predictive Value (PPV)")),
            tags$td(tags$span(class = "fw-bold text-success", fmt_pct(ppv))),
            tags$td(HTML("P(H<sub>1</sub> true | significant result) \u2014
                          the probability a significant finding reflects a real effect"))
          ),
          tags$tr(
            tags$td(tags$strong("False Discovery Rate (FDR)")),
            tags$td(tags$span(class = "fw-bold text-danger", fmt_pct(fdr))),
            tags$td(HTML("P(H<sub>0</sub> true | significant result) \u2014
                          the proportion of positive findings that are false"))
          ),
          tags$tr(
            tags$td(tags$strong("Negative Predictive Value (NPV)")),
            tags$td(tags$span(class = "fw-bold", fmt_pct(npv))),
            tags$td(HTML("P(H<sub>0</sub> true | non-significant result) \u2014
                          the probability a null result is genuinely null"))
          )
        )
      ),
      tags$p(class = "text-muted small mb-0",
        tags$strong("Note:"), " PPV and FDR depend critically on the prevalence of true effects,
         which is almost never known in practice. The table illustrates why low-prevalence
         screening (e.g., genome-wide association studies, drug candidate screens) requires
         very strict \u03b1 or Bonferroni-type corrections to keep FDR manageable, even with
         high power. Raising power helps PPV only modestly when prevalence is very low;
         the dominant driver of FDR in that regime is \u03b1 \u00d7 (1 \u2212 prevalence).")
    )
  })
  })
}
