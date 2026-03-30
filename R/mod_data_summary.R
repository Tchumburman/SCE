# Module: Data Summary (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
data_summary_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Data Summary",
  icon = icon("list-ol"),
  navset_card_underline(
    nav_panel(
      "Descriptive Statistics",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("desc_dist"), "Distribution",
        choices = c("Normal", "Uniform", "Right-skewed (Gamma)",
                    "Left-skewed", "Bimodal", "Heavy-tailed (t)"),
        selected = "Normal"
      ),
      sliderInput(ns("desc_n"), "Sample size", min = 20, max = 2000,
                  value = 200, step = 20),
      actionButton(ns("desc_gen"), "Generate sample",
                   class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Descriptive Statistics"),
      tags$p("Descriptive statistics summarise the central tendency, spread, and
              shape of a data set. Understanding these measures is the essential
              first step before any inferential analysis. They provide a concise
              portrait of the data that guides decisions about which models and
              tests are appropriate."),
      tags$ul(
        tags$li(tags$strong("Central tendency:"), " Mean, median, and mode locate the \u201ccentre\u201d of the data.
                The mean is sensitive to outliers; the median is robust. When these two diverge
                substantially, the distribution is likely skewed."),
        tags$li(tags$strong("Spread:"), " Standard deviation (SD) measures average distance from the mean.
                The interquartile range (IQR) captures the middle 50% and is more robust to outliers.
                Coefficient of variation (SD/mean) allows comparison of variability across different scales."),
        tags$li(tags$strong("Shape:"), " Skewness quantifies asymmetry (positive = right tail, negative = left tail).
                Kurtosis measures tail heaviness relative to a Normal distribution. High kurtosis
                (leptokurtic) means more extreme values than expected; low kurtosis (platykurtic) means fewer.")
      ),
      tags$p("A common pitfall is reporting only the mean and ignoring spread and shape.
              Two data sets can share the same mean yet differ dramatically in variability
              and distributional form. Always examine a histogram or density plot alongside
              numerical summaries \u2014 Anscombe\u2019s quartet is the classic illustration
              of why summary statistics alone can be misleading."),
      tags$p("When comparing groups, standardised effect sizes (like Cohen\u2019s d) are
              often more useful than raw differences because they account for variability.
              Descriptive statistics also inform your choice of inferential methods: highly
              skewed data may call for nonparametric tests or data transformations, while
              bimodal distributions may indicate a mixture of subpopulations worth
              investigating separately."),
      guide = tags$ol(
        tags$li("Choose a distribution shape and sample size."),
        tags$li("Click 'Generate sample' to draw a random sample."),
        tags$li("Examine the histogram with overlaid mean/median lines."),
        tags$li("Compare measures in the summary table \u2014 notice how mean and median diverge for skewed distributions."),
        tags$li("Try different distributions to see how shape affects descriptive statistics.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Distribution"),
           plotlyOutput(ns("desc_hist"), height = "400px")),
      card(card_header("Summary Statistics"), tableOutput(ns("desc_table"))),
      card(full_screen = TRUE, card_header("Box Plot"),
           plotlyOutput(ns("desc_box"), height = "250px"))
    )
  )
    ),

    nav_panel(
      "Probability",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("prob_topic"), "Topic",
        choices = c("Conditional Probability" = "cond",
                    "Bayes' Rule" = "bayes",
                    "Birthday Problem" = "birthday"),
        selected = "cond"
      ),
      conditionalPanel(ns = ns, "input.prob_topic == 'cond'",
        sliderInput(ns("prob_pa"), "P(A)", min = 0.05, max = 0.95, value = 0.3, step = 0.05),
        sliderInput(ns("prob_pb"), "P(B)", min = 0.05, max = 0.95, value = 0.4, step = 0.05),
        sliderInput(ns("prob_pab"), "P(A \u2229 B)", min = 0, max = 0.5, value = 0.12, step = 0.02)
      ),
      conditionalPanel(ns = ns, "input.prob_topic == 'bayes'",
        sliderInput(ns("prob_prev"), "Prevalence P(Disease)", min = 0.001, max = 0.1,
                    value = 0.01, step = 0.001),
        sliderInput(ns("prob_sens"), "Sensitivity P(+|D)", min = 0.50, max = 1,
                    value = 0.95, step = 0.01),
        sliderInput(ns("prob_spec"), "Specificity P(\u2212|\u00acD)", min = 0.50, max = 1,
                    value = 0.95, step = 0.01)
      ),
      conditionalPanel(ns = ns, "input.prob_topic == 'birthday'",
        sliderInput(ns("prob_npeople"), "Number of people", min = 2, max = 80,
                    value = 23, step = 1)
      )
    ),
    explanation_box(
      tags$strong("Probability Fundamentals"),
      tags$p("Core probability concepts underlie all of statistics. Understanding
              conditional probability, independence, and Bayesian updating provides
              the foundation for hypothesis testing, statistical modelling, and
              decision-making under uncertainty."),
      tags$ul(
        tags$li(tags$strong("Conditional probability:"), " P(A|B) = P(A \u2229 B) / P(B). This
                is the probability of A occurring given that B has already occurred. It is
                the building block for Bayes\u2019 rule and underpins concepts like sensitivity
                and specificity in diagnostic testing."),
        tags$li(tags$strong("Bayes\u2019 Rule:"), " P(H|D) = P(D|H) \u00d7 P(H) / P(D). This updates
                the probability of a hypothesis (H) given new data (D). The prior probability P(H)
                is combined with the likelihood P(D|H) to produce the posterior P(H|D). Bayesian
                reasoning is essential for interpreting medical tests: a positive result on a rare
                disease test may still mean a low probability of actually having the disease."),
        tags$li(tags$strong("Birthday problem:"), " In a group of just 23 people, there is a greater
                than 50% chance that two share a birthday. This is a classic example of how human
                intuition about probability can be wildly inaccurate, and why mathematical reasoning
                is essential.")
      ),
      tags$p("These concepts connect directly to inferential statistics: p-values are
              conditional probabilities (probability of the data given the null hypothesis),
              and the base-rate fallacy (ignoring prior probabilities) is one of the most
              common errors in interpreting statistical results."),
      tags$p("The birthday problem illustrates that our intuitions about probability are
              frequently unreliable, especially for events involving combinations or
              coincidences. In statistics, this same poor intuition manifests as surprise
              at multiple-testing inflation or the prosecutor\u2019s fallacy. Building
              formal probabilistic reasoning skills is essential for avoiding such traps."),
      tags$p("Independence is another key concept: two events are independent if knowing
              the outcome of one provides no information about the other. Many statistical
              methods assume independence of observations, and violations of this assumption
              (e.g., clustered data, repeated measures) require specialised techniques.")
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header(textOutput(ns("prob_title"))),
           plotlyOutput(ns("prob_plot"), height = "420px")),
      card(card_header("Results"), uiOutput(ns("prob_results")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

data_summary_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  desc_data <- reactiveVal(NULL)

  observeEvent(input$desc_gen, {
    n <- input$desc_n
    set.seed(sample.int(10000, 1))
    x <- switch(input$desc_dist,
      "Normal"               = rnorm(n, 50, 10),
      "Uniform"              = runif(n, 20, 80),
      "Right-skewed (Gamma)" = rgamma(n, shape = 2, rate = 0.1),
      "Left-skewed"          = 100 - rgamma(n, shape = 2, rate = 0.1),
      "Bimodal"              = c(rnorm(n / 2, 35, 5), rnorm(n / 2, 65, 5)),
      "Heavy-tailed (t)"     = 50 + 10 * rt(n, df = 3),
      rnorm(n, 50, 10)
    )
    desc_data(x)
  })

  output$desc_hist <- renderPlotly({
    x <- desc_data()
    req(x)
    mn <- mean(x); md <- median(x)
    plotly::plot_ly(x = x, type = "histogram",
                    marker = list(color = "rgba(35,139,69,0.6)",
                                  line = list(color = "#238b45", width = 1)),
                    showlegend = FALSE, hovertemplate = "Bin: %{x}<br>Count: %{y}<extra></extra>") |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = mn, x1 = mn, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#e31a1c", width = 2, dash = "solid")),
          list(type = "line", x0 = md, x1 = md, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#3182bd", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Value"),
        yaxis = list(title = "Count"),
        annotations = list(
          list(x = mn, y = 1.02, yref = "paper", text = paste0("Mean = ", round(mn, 2)),
               showarrow = FALSE, font = list(size = 11, color = "#e31a1c")),
          list(x = md, y = 0.95, yref = "paper", text = paste0("Median = ", round(md, 2)),
               showarrow = FALSE, font = list(size = 11, color = "#3182bd"))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$desc_table <- renderTable({
    x <- desc_data()
    req(x)
    q1 <- quantile(x, 0.25); q3 <- quantile(x, 0.75)
    n <- length(x)
    m <- mean(x); s <- sd(x)
    skew <- (sum((x - m)^3) / n) / (sum((x - m)^2) / n)^1.5
    kurt <- (sum((x - m)^4) / n) / (sum((x - m)^2) / n)^2 - 3
    data.frame(
      Statistic = c("N", "Mean", "Median", "Std Dev", "Min", "Max",
                     "Q1 (25th)", "Q3 (75th)", "IQR", "Range",
                     "Skewness", "Excess Kurtosis"),
      Value = round(c(n, m, median(x), s, min(x), max(x),
                       q1, q3, q3 - q1, max(x) - min(x),
                       skew, kurt), 3)
    )
  }, striped = TRUE, hover = TRUE, width = "100%", digits = 3)

  output$desc_box <- renderPlotly({
    x <- desc_data()
    req(x)
    plotly::plot_ly(x = x, type = "box",
                    marker = list(color = "#238b45"),
                    line = list(color = "#238b45"),
                    fillcolor = "rgba(35,139,69,0.3)",
                    boxpoints = "outliers") |>
      plotly::layout(xaxis = list(title = "Value"),
                     margin = list(t = 20, b = 30)) |>
      plotly::config(displayModeBar = FALSE)
  })


  output$prob_title <- renderText({
    switch(input$prob_topic,
      "cond" = "Venn Diagram", "bayes" = "Natural Frequencies",
      "birthday" = "Birthday Collision Probability")
  })

  output$prob_plot <- renderPlotly({
    topic <- input$prob_topic

    if (topic == "cond") {
      pa <- input$prob_pa; pb <- input$prob_pb; pab <- input$prob_pab
      pab <- min(pab, pa, pb)
      # Venn diagram via circles (approximation with scatter)
      theta <- seq(0, 2 * pi, length.out = 100)
      r <- 1
      cx_a <- -0.4; cx_b <- 0.4
      xa <- cx_a + r * cos(theta); ya <- r * sin(theta)
      xb <- cx_b + r * cos(theta); yb <- r * sin(theta)

      plotly::plot_ly() |>
        plotly::add_trace(x = xa, y = ya, type = "scatter", mode = "lines",
                          fill = "toself", fillcolor = "rgba(49,130,189,0.2)",
                          line = list(color = "#3182bd", width = 2),
                          name = paste0("A: P=", pa), hoverinfo = "name") |>
        plotly::add_trace(x = xb, y = yb, type = "scatter", mode = "lines",
                          fill = "toself", fillcolor = "rgba(227,26,28,0.2)",
                          line = list(color = "#e31a1c", width = 2),
                          name = paste0("B: P=", pb), hoverinfo = "name") |>
        plotly::layout(
          xaxis = list(visible = FALSE, scaleanchor = "y"),
          yaxis = list(visible = FALSE),
          annotations = list(
            list(x = cx_a - 0.4, y = 0, text = "A", showarrow = FALSE,
                 font = list(size = 20, color = "#3182bd")),
            list(x = cx_b + 0.4, y = 0, text = "B", showarrow = FALSE,
                 font = list(size = 20, color = "#e31a1c")),
            list(x = 0, y = 0, text = paste0("A\u2229B\n", pab), showarrow = FALSE,
                 font = list(size = 14, color = "#333"))
          ),
          margin = list(t = 20, b = 20)
        ) |> plotly::config(displayModeBar = FALSE)

    } else if (topic == "bayes") {
      prev <- input$prob_prev; sens <- input$prob_sens; spec <- input$prob_spec
      N <- 10000
      n_dis <- round(N * prev)
      n_healthy <- N - n_dis
      tp <- round(n_dis * sens)
      fn <- n_dis - tp
      fp <- round(n_healthy * (1 - spec))
      tn <- n_healthy - fp
      ppv <- tp / (tp + fp)

      labels <- c("True Positive", "False Negative", "False Positive", "True Negative")
      vals <- c(tp, fn, fp, tn)
      cols <- c("#238b45", "#e31a1c", "#fd8d3c", "#3182bd")

      plotly::plot_ly(labels = labels, values = vals, type = "pie",
                      marker = list(colors = cols),
                      textinfo = "label+value",
                      hoverinfo = "text",
                      text = paste0(labels, ": ", vals, " / ", N)) |>
        plotly::layout(
          annotations = list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0("Out of ", N, " people tested"),
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 50)
        ) |> plotly::config(displayModeBar = FALSE)

    } else {
      n <- input$prob_npeople
      ns <- 2:80
      probs <- sapply(ns, function(k) {
        1 - prod((365 - seq(0, k - 1)) / 365)
      })

      plotly::plot_ly() |>
        plotly::add_trace(x = ns, y = probs * 100,
                          type = "scatter", mode = "lines",
                          line = list(color = "#238b45", width = 2),
                          name = "P(match)", hoverinfo = "text",
                          text = paste0("n = ", ns, "<br>P = ", round(probs * 100, 1), "%")) |>
        plotly::add_markers(x = n,
                            y = (1 - prod((365 - seq(0, n - 1)) / 365)) * 100,
                            marker = list(color = "#e31a1c", size = 10),
                            name = paste0("n = ", n), showlegend = FALSE,
                            hoverinfo = "skip") |>
        plotly::layout(
          xaxis = list(title = "Number of people"),
          yaxis = list(title = "Probability of shared birthday (%)",
                       range = c(0, 105)),
          shapes = list(list(type = "line", x0 = 2, x1 = 80,
                             y0 = 50, y1 = 50,
                             line = list(color = "grey60", dash = "dash", width = 1))),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$prob_results <- renderUI({
    topic <- input$prob_topic
    if (topic == "cond") {
      pa <- input$prob_pa; pb <- input$prob_pb
      pab <- min(input$prob_pab, pa, pb)
      p_a_given_b <- if (pb > 0) round(pab / pb, 4) else NA
      p_b_given_a <- if (pa > 0) round(pab / pa, 4) else NA
      tags$div(
        tags$p(paste0("P(A|B) = P(A\u2229B) / P(B) = ", pab, " / ", pb, " = ", p_a_given_b)),
        tags$p(paste0("P(B|A) = P(A\u2229B) / P(A) = ", pab, " / ", pa, " = ", p_b_given_a)),
        tags$p(paste0("P(A\u222aB) = P(A) + P(B) \u2212 P(A\u2229B) = ",
                       round(pa + pb - pab, 4)))
      )
    } else if (topic == "bayes") {
      prev <- input$prob_prev; sens <- input$prob_sens; spec <- input$prob_spec
      ppv <- (sens * prev) / (sens * prev + (1 - spec) * (1 - prev))
      npv <- (spec * (1 - prev)) / (spec * (1 - prev) + (1 - sens) * prev)
      tags$div(
        tags$p(tags$strong("Positive Predictive Value (PPV):"),
               paste0(" P(Disease | +) = ", round(ppv * 100, 2), "%")),
        tags$p(tags$strong("Negative Predictive Value (NPV):"),
               paste0(" P(Healthy | \u2212) = ", round(npv * 100, 2), "%")),
        tags$p(class = "text-muted",
               "Even with a good test, low prevalence means most positives are false positives.")
      )
    } else {
      n <- input$prob_npeople
      p <- 1 - prod((365 - seq(0, n - 1)) / 365)
      tags$div(
        tags$p("With ", n, " people, the probability that at least two share a birthday is ",
               tags$strong(paste0(round(p * 100, 2), "%")), "."),
        if (n >= 23) tags$p(class = "text-muted", "With 23 people, the probability already exceeds 50%!")
      )
    }
  })
  # Auto-run simulations on first load
  })
}
