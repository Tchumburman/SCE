# Module: Distribution Shapes (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
distribution_shapes_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Distribution Shapes",
  icon = icon("chart-area"),
  navset_card_underline(
    nav_panel(
      "Normal Distribution",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      sliderInput(ns("norm_mu"), "Mean (\u03bc)", min = -10, max = 10, value = 0, step = 0.5),
      sliderInput(ns("norm_sigma"), "Std Dev (\u03c3)", min = 0.5, max = 5, value = 1, step = 0.25),
      checkboxInput(ns("norm_empirical"), "Show 68-95-99.7% rule", value = FALSE)
    ),
    explanation_box(
      tags$strong("The Normal Distribution"),
      tags$p("The normal (Gaussian) distribution is the most important distribution in
              statistics. It is symmetric and bell-shaped, fully determined by two
              parameters: the mean (\u03bc), which locates the centre, and the standard
              deviation (\u03c3), which controls the spread. Many natural phenomena
              approximate this shape, and it underpins most inferential statistics."),
      tags$p("The empirical rule (or 68\u201395\u201399.7 rule) states that approximately 68%
              of data falls within \u00b11\u03c3, 95% within \u00b12\u03c3, and 99.7%
              within \u00b13\u03c3 of the mean. This is an intrinsic property of the
              normal curve and provides a quick way to gauge how unusual an observation
              is: a value more than 2\u03c3 from the mean occurs less than 5% of the time."),
      tags$p("The normal distribution owes much of its importance to the Central Limit
              Theorem (CLT): regardless of the shape of the original population, the
              distribution of the sample mean approaches a normal distribution as
              sample size increases. This is why many test statistics (t, z, F) are
              built on the normal or on distributions derived from it."),
      tags$p("A common misconception is that data must be normally distributed for
              statistical tests to work. In practice, many tests (e.g., the t-test)
              are robust to moderate departures from normality, especially with
              larger samples. What often matters more is whether the ", tags$em("sampling
              distribution of the estimator"), " is approximately normal \u2014 and the
              CLT usually ensures this."),
      guide = tags$ol(
        tags$li("Drag the \u03bc slider to shift the curve left or right."),
        tags$li("Drag the \u03c3 slider to make the curve wider (more spread) or narrower (less spread)."),
        tags$li("Toggle 'Show 68-95-99.7% rule' to see shaded bands under the curve."),
        tags$li("Notice how the total area under the curve always equals 1, regardless of \u03bc and \u03c3.")
      )
    ),
    card(
      full_screen = TRUE,
      card_header("Density Curve"),
      plotlyOutput(ns("norm_plot"), height = "450px")
    )
  )
    ),

    nav_panel(
      "Other Distributions",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("dist_family"), "Distribution",
        choices = c("t", "F", "Chi-Square", "Binomial", "Poisson"),
        selected = "t"
      ),

      # --- t parameters ---
      conditionalPanel(ns = ns, "input.dist_family == 't'",
        sliderInput(ns("dist_t_df"), "Degrees of freedom (df)", min = 1, max = 50, value = 5, step = 1),
        checkboxInput(ns("dist_t_show_normal"), "Overlay standard Normal", value = TRUE)
      ),

      # --- F parameters ---
      conditionalPanel(ns = ns, "input.dist_family == 'F'",
        sliderInput(ns("dist_f_df1"), "df\u2081 (numerator)", min = 1, max = 50, value = 5, step = 1),
        sliderInput(ns("dist_f_df2"), "df\u2082 (denominator)", min = 1, max = 100, value = 20, step = 1)
      ),

      # --- Chi-Square parameters ---
      conditionalPanel(ns = ns, "input.dist_family == 'Chi-Square'",
        sliderInput(ns("dist_chisq_df"), "Degrees of freedom (df)", min = 1, max = 50, value = 5, step = 1)
      ),

      # --- Binomial parameters ---
      conditionalPanel(ns = ns, "input.dist_family == 'Binomial'",
        sliderInput(ns("dist_binom_n"), "Number of trials (n)", min = 1, max = 100, value = 20, step = 1),
        sliderInput(ns("dist_binom_p"), "Success probability (p)", min = 0.01, max = 0.99, value = 0.5, step = 0.01)
      ),

      # --- Poisson parameters ---
      conditionalPanel(ns = ns, "input.dist_family == 'Poisson'",
        sliderInput(ns("dist_pois_lambda"), "\u03bb (rate)", min = 0.5, max = 30, value = 5, step = 0.5)
      ),

      tags$hr(),
      checkboxInput(ns("dist_show_cdf"), "Show CDF (right panel)", value = FALSE)
    ),

    explanation_box(
      tags$strong("Exploring Common Distributions"),
      tags$p("Many statistical tests rely on specific probability distributions.
              Each distribution arises from a different data-generating process, and
              understanding their shapes helps you recognise which model fits a given
              situation. This tab lets you manipulate parameters and see how the
              shape of the density (or mass) function changes in real time."),
      tags$ul(
        tags$li(tags$strong("t"), " \u2014 like a Normal but with heavier tails, reflecting extra uncertainty
                when the population variance is estimated from data. As degrees of freedom (df) increase,
                the t-distribution converges to the standard Normal. With df < 5, the tails are
                noticeably heavier, meaning extreme values are more likely than under normality."),
        tags$li(tags$strong("F"), " \u2014 the ratio of two independent Chi-Square variables, each divided
                by its degrees of freedom. It is always non-negative and right-skewed. The F-distribution
                is the basis for ANOVA F-tests and regression model comparisons. The two df parameters
                (numerator and denominator) control its shape; a large denominator df makes it more symmetric."),
        tags$li(tags$strong("Chi-Square (\u03c7\u00b2)"), " \u2014 the sum of k squared standard normals,
                where k is the degrees of freedom. It is right-skewed for small df and becomes
                approximately normal as df grows. Chi-square tests for goodness-of-fit and
                independence are among the most common applications."),
        tags$li(tags$strong("Binomial"), " \u2014 the count of successes in n independent trials,
                each with success probability p. When n is large and p is not too extreme, the
                Binomial approximates a Normal distribution. Its shape ranges from strongly skewed
                (small n or extreme p) to nearly symmetric (large n, p near 0.5)."),
        tags$li(tags$strong("Poisson"), " \u2014 the count of events occurring in a fixed interval of
                time or space, assuming events occur independently at a constant average rate \u03bb.
                For small \u03bb the distribution is strongly right-skewed; as \u03bb grows it
                approaches a Normal shape. The Poisson is notable for having equal mean and variance.")
      ),
      tags$p("An important practical skill is recognising which distribution best describes your
              data. Discrete counts often suggest Binomial or Poisson; continuous measurements
              with possible outliers may follow a t-distribution; and ratios of variances
              naturally follow an F-distribution. Choosing the right distributional assumption
              is fundamental to valid inference."),
      tags$p("All of these distributions are connected through mathematical relationships.
              As sample sizes grow, the Binomial converges to the Normal, the Poisson
              converges to the Normal, the t converges to the Normal, and the Chi-Square
              (suitably standardised) also approaches normality. Understanding these
              convergence properties helps explain why Normal-based methods work so broadly."),
      guide = tags$ol(
        tags$li("Select a distribution from the dropdown."),
        tags$li("Adjust its parameters with the sliders and watch the shape change."),
        tags$li("For the t-distribution, toggle the Normal overlay to see how heavier tails shrink with more df."),
        tags$li("Check 'Show CDF' to see the cumulative distribution function alongside the density.")
      )
    ),

    layout_column_wrap(
      width = 1,
      card(
        full_screen = TRUE,
        card_header(textOutput(ns("dist_pdf_title"))),
        plotlyOutput(ns("dist_pdf_plot"), height = "420px")
      ),
      conditionalPanel(ns = ns, "input.dist_show_cdf",
        card(
          full_screen = TRUE,
          card_header(textOutput(ns("dist_cdf_title"))),
          plotlyOutput(ns("dist_cdf_plot"), height = "350px")
        )
      )
    )
  )
    ),

    nav_panel(
      "QQ Plots",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      selectInput(ns("qq_dist"), "Sample distribution",
        choices = c("Normal", "t (heavy tails)", "Right-skewed (Gamma)",
                    "Left-skewed", "Uniform", "Bimodal"),
        selected = "Normal"
      ),
      sliderInput(ns("qq_n"), "Sample size (n)", min = 20, max = 500, value = 100, step = 10),
      sliderInput(ns("qq_df_t"), "df (for t)", min = 1, max = 30, value = 3, step = 1),
      actionButton(ns("qq_resample"), "Draw new sample", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("QQ (Quantile-Quantile) Plots"),
      tags$p("A QQ plot compares the quantiles of a sample against the
              theoretical quantiles of a reference distribution (usually Normal).
              If the points fall along the diagonal line, the sample is consistent
              with that distribution. Systematic deviations reveal skewness,
              heavy tails, or other departures from the assumed shape."),
      tags$p("Reading a QQ plot takes practice. An S-shaped curve indicates heavy tails
              (more extreme values than expected). A concave or convex bend suggests
              right- or left-skew. Scattered points at the extremes but a straight
              middle section often indicate a distribution that is \u201cclose enough\u201d
              to Normal for practical purposes. With small samples (n < 30), even
              truly Normal data can produce noisy-looking QQ plots, so avoid
              over-interpreting minor wiggles."),
      tags$p("QQ plots are particularly useful as a complement to formal normality tests
              (such as Shapiro-Wilk). While hypothesis tests give a binary yes/no answer,
              a QQ plot shows ", tags$em("how"), " the data departs from normality \u2014
              which is far more informative for deciding whether a parametric test is
              appropriate. A slight departure in the tails may matter little for a t-test
              but could substantially affect extreme quantile estimates."),
      tags$p("Formally, the i-th point on the plot has coordinates (q_i, x_(i)), where
              q_i is the theoretical quantile from the reference distribution and x_(i)
              is the i-th order statistic of the sample. The reference line is typically
              drawn through the first and third quartiles. Points above the line in the
              right tail indicate the sample has heavier right tails than the reference."),
      guide = tags$ol(
        tags$li("Select a sample distribution from the dropdown."),
        tags$li("Look at the QQ plot: points on the line = Normal-like."),
        tags$li("Heavy-tailed data (t) curves away at both extremes."),
        tags$li("Skewed data shows a curved pattern on one side."),
        tags$li("Click 'Draw new sample' to see sampling variability.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(
        full_screen = TRUE,
        card_header("Histogram of Sample"),
        plotlyOutput(ns("qq_hist"), height = "420px")
      ),
      card(
        full_screen = TRUE,
        card_header("Normal QQ Plot"),
        plotlyOutput(ns("qq_plot"), height = "420px")
      )
    )
  )
    ),

    # ── Compare Distributions (side-by-side) ───────────────────────────
    nav_panel(
      "Compare Distributions",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      tags$h6(class = "text-success", icon("a"), " Distribution A"),
      selectInput(ns("cmp_dist_a"), NULL,
        choices = c("Normal", "t", "Chi-Square", "Exponential", "Uniform"),
        selected = "Normal"),
      conditionalPanel(ns = ns, "input.cmp_dist_a == 'Normal'",
        sliderInput(ns("cmp_a_mu"), "\u03bc\u2090", min = -10, max = 10, value = 0, step = 0.5),
        sliderInput(ns("cmp_a_sigma"), "\u03c3\u2090", min = 0.5, max = 5, value = 1, step = 0.25)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_a == 't'",
        sliderInput(ns("cmp_a_df"), "df\u2090", min = 1, max = 50, value = 3)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_a == 'Chi-Square'",
        sliderInput(ns("cmp_a_chisq_df"), "df\u2090", min = 1, max = 50, value = 5)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_a == 'Exponential'",
        sliderInput(ns("cmp_a_rate"), "\u03bb\u2090", min = 0.1, max = 5, value = 1, step = 0.1)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_a == 'Uniform'",
        sliderInput(ns("cmp_a_range"), "Range\u2090", min = -10, max = 10, value = c(0, 1), step = 0.5)
      ),
      tags$hr(),
      tags$h6(class = "text-info", icon("b"), " Distribution B"),
      selectInput(ns("cmp_dist_b"), NULL,
        choices = c("Normal", "t", "Chi-Square", "Exponential", "Uniform"),
        selected = "t"),
      conditionalPanel(ns = ns, "input.cmp_dist_b == 'Normal'",
        sliderInput(ns("cmp_b_mu"), "\u03bc\u2082", min = -10, max = 10, value = 0, step = 0.5),
        sliderInput(ns("cmp_b_sigma"), "\u03c3\u2082", min = 0.5, max = 5, value = 1, step = 0.25)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_b == 't'",
        sliderInput(ns("cmp_b_df"), "df\u2082", min = 1, max = 50, value = 10)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_b == 'Chi-Square'",
        sliderInput(ns("cmp_b_chisq_df"), "df\u2082", min = 1, max = 50, value = 5)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_b == 'Exponential'",
        sliderInput(ns("cmp_b_rate"), "\u03bb\u2082", min = 0.1, max = 5, value = 1, step = 0.1)
      ),
      conditionalPanel(ns = ns, "input.cmp_dist_b == 'Uniform'",
        sliderInput(ns("cmp_b_range"), "Range\u2082", min = -10, max = 10, value = c(0, 1), step = 0.5)
      )
    ),
    explanation_box(
      tags$strong("Comparing Distributions"),
      tags$p("Overlaying two distributions side-by-side is one of the most effective ways
              to build intuition about how statistical distributions differ. You can compare
              distributions of the same family with different parameters (e.g., t with df=3
              vs df=30) or entirely different families (e.g., Normal vs Exponential)."),
      tags$p("Key things to look for when comparing:"),
      tags$ul(
        tags$li(tags$strong("Location"), " \u2014 where is the centre of each distribution?"),
        tags$li(tags$strong("Spread"), " \u2014 which distribution is more dispersed?"),
        tags$li(tags$strong("Symmetry"), " \u2014 is one skewed while the other is symmetric?"),
        tags$li(tags$strong("Tails"), " \u2014 which has heavier tails (more extreme values)?"),
        tags$li(tags$strong("Overlap"), " \u2014 how much probability mass do they share?")
      ),
      tags$p("Try comparing t(df=3) with Normal(0,1) to see how heavier tails emerge with fewer
              degrees of freedom, or compare Exponential(\u03bb=0.5) with Chi-Square(df=2) to see
              that they are actually the same distribution."),
      tags$p("Visual comparison is particularly valuable for understanding the practical
              impact of distributional assumptions. For example, the difference between
              a t-distribution with 5 df and a Normal distribution may seem small in the
              middle but is substantial in the tails \u2014 exactly where hypothesis testing
              and confidence intervals are most sensitive. Building this visual intuition
              helps you judge when distributional approximations are \u201cclose enough\u201d."),
      guide = tags$ol(
        tags$li("Select a distribution family and parameters for A (green) and B (blue)."),
        tags$li("Both density curves are overlaid on the same plot for direct comparison."),
        tags$li("Try same-family comparisons first (e.g., Normal with different \u03c3) to see parameter effects."),
        tags$li("Then try cross-family comparisons (e.g., Normal vs t) to see structural differences.")
      )
    ),
    card(
      full_screen = TRUE,
      card_header("Distribution Overlay"),
      plotlyOutput(ns("cmp_dist_plot"), height = "480px")
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

distribution_shapes_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  output$norm_plot <- renderPlotly({
    mu <- input$norm_mu
    sigma <- input$norm_sigma
    x <- seq(mu - 4 * sigma, mu + 4 * sigma, length.out = 500)
    y <- dnorm(x, mu, sigma)

    p <- plotly::plot_ly()

    if (input$norm_empirical) {
      # Bands: widest first so they layer properly
      bands <- list(
        list(k = 3, name = "99.7% (\u00b13\u03c3)", col = "#c7e9c0"),
        list(k = 2, name = "95% (\u00b12\u03c3)",   col = "#74c476"),
        list(k = 1, name = "68% (\u00b11\u03c3)",   col = "#238b45")
      )
      for (b in bands) {
        xs <- seq(mu - b$k * sigma, mu + b$k * sigma, length.out = 300)
        ys <- dnorm(xs, mu, sigma)
        p <- p |>
          plotly::add_trace(
            x = xs, y = ys, type = "scatter", mode = "lines",
            fill = "tozeroy",
            fillcolor = paste0(b$col, "CC"),
            line = list(color = "transparent"),
            name = b$name, showlegend = TRUE,
            hoverinfo = "skip"
          )
      }

      # Dashed vertical lines at each sigma
      for (k in -3:3) {
        p <- p |>
          plotly::add_trace(
            x = rep(mu + k * sigma, 2),
            y = c(0, dnorm(mu + k * sigma, mu, sigma)),
            type = "scatter", mode = "lines",
            line = list(color = "#00441b", width = 1, dash = "dash"),
            opacity = 0.45, showlegend = FALSE, hoverinfo = "skip"
          )
      }

      # Percentage annotations
      p <- p |>
        plotly::layout(annotations = list(
          list(x = mu + 0.5 * sigma, y = dnorm(mu, mu, sigma) * 0.65,
               text = "34%", showarrow = FALSE,
               font = list(size = 14, color = "white", weight = "bold")),
          list(x = mu + 1.5 * sigma,
               y = dnorm(mu + 1.5 * sigma, mu, sigma) + dnorm(mu, mu, sigma) * 0.06,
               text = "13.5%", showarrow = FALSE,
               font = list(size = 12, color = "#00441b")),
          list(x = mu + 2.5 * sigma,
               y = dnorm(mu + 2.5 * sigma, mu, sigma) + dnorm(mu, mu, sigma) * 0.06,
               text = "2.35%", showarrow = FALSE,
               font = list(size = 10, color = "#00441b"))
        ))
    }

    # Main density line
    hover_txt <- paste0("\u03b8 = ", round(x, 3), "<br>f(\u03b8) = ", round(y, 5))
    p <- p |>
      plotly::add_trace(
        x = x, y = y, type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 2.5),
        name = "Density", showlegend = FALSE,
        hoverinfo = "text", text = hover_txt
      )

    p |> plotly::layout(
      xaxis = list(title = "x"),
      yaxis = list(title = "Density"),
      legend = list(orientation = "v", x = 1.02, y = 1),
      margin = list(t = 40),
      annotations = c(
        if (!is.null(p$x$layoutAttrs)) p$x$layoutAttrs[[1]]$annotations else list(),
        list(list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                  text = paste0("\u03bc = ", mu, ",  \u03c3 = ", sigma),
                  showarrow = FALSE, font = list(size = 13)))
      )
    ) |> plotly::config(displayModeBar = FALSE)
  })


  dist_data <- reactive({
    fam <- input$dist_family

    if (fam == "t") {
      df <- input$dist_t_df
      x  <- seq(-5, 5, length.out = 500)
      dens <- dt(x, df)
      cdf  <- pt(x, df)
      subtitle <- paste0("df = ", df)
      list(x = x, y = dens, cdf = cdf, discrete = FALSE, subtitle = subtitle,
           normal_y = if (input$dist_t_show_normal) dnorm(x) else NULL,
           normal_cdf = if (input$dist_t_show_normal) pnorm(x) else NULL)

    } else if (fam == "F") {
      df1 <- input$dist_f_df1; df2 <- input$dist_f_df2
      xmax <- qf(0.995, df1, df2)
      x <- seq(0.001, xmax, length.out = 500)
      list(x = x, y = df(x, df1, df2), cdf = pf(x, df1, df2),
           discrete = FALSE,
           subtitle = paste0("df\u2081 = ", df1, ",  df\u2082 = ", df2),
           normal_y = NULL, normal_cdf = NULL)

    } else if (fam == "Chi-Square") {
      dfv <- input$dist_chisq_df
      xmax <- qchisq(0.995, dfv)
      x <- seq(0.001, xmax, length.out = 500)
      list(x = x, y = dchisq(x, dfv), cdf = pchisq(x, dfv),
           discrete = FALSE,
           subtitle = paste0("df = ", dfv),
           normal_y = NULL, normal_cdf = NULL)

    } else if (fam == "Binomial") {
      n <- input$dist_binom_n; p <- input$dist_binom_p
      x <- 0:n
      list(x = x, y = dbinom(x, n, p), cdf = pbinom(x, n, p),
           discrete = TRUE,
           subtitle = paste0("n = ", n, ",  p = ", p),
           normal_y = NULL, normal_cdf = NULL)

    } else {
      lam <- input$dist_pois_lambda
      xmax <- max(qpois(0.999, lam), 10)
      x <- 0:xmax
      list(x = x, y = dpois(x, lam), cdf = ppois(x, lam),
           discrete = TRUE,
           subtitle = paste0("\u03bb = ", lam),
           normal_y = NULL, normal_cdf = NULL)
    }
  })

  # Titles
  output$dist_pdf_title <- renderText({
    fam <- input$dist_family
    d   <- dist_data()
    lbl <- if (d$discrete) "Mass" else "Density"
    paste0(fam, " Distribution \u2014 Probability ", lbl, " (",  d$subtitle, ")")
  })
  output$dist_cdf_title <- renderText({
    d <- dist_data()
    paste0(input$dist_family, " Distribution \u2014 CDF (",  d$subtitle, ")")
  })

  # PDF / PMF plot
  output$dist_pdf_plot <- renderPlotly({
    d <- dist_data()
    fam <- input$dist_family

    if (d$discrete) {
      hover_txt <- paste0("x = ", d$x,
                          "<br>P(X = ", d$x, ") = ", round(d$y, 4),
                          "<br>Distribution: ", fam,
                          "<br>", d$subtitle)
      p <- plotly::plot_ly() |>
        plotly::add_markers(
          x = d$x, y = d$y,
          marker = list(color = "#238b45", size = 8,
                        line = list(width = 1, color = "#FFFFFF")),
          hoverinfo = "text", text = hover_txt,
          name = fam, showlegend = FALSE
        ) |>
        plotly::add_segments(
          x = d$x, xend = d$x, y = rep(0, length(d$x)), yend = d$y,
          line = list(color = "#238b45", width = 2),
          hoverinfo = "none", showlegend = FALSE
        )
    } else {
      hover_txt <- paste0("x = ", round(d$x, 3),
                          "<br>f(x) = ", round(d$y, 4),
                          "<br>F(x) = ", round(d$cdf, 4),
                          "<br>Distribution: ", fam,
                          "<br>", d$subtitle)
      p <- plotly::plot_ly() |>
        plotly::add_trace(
          x = d$x, y = d$y, type = "scatter", mode = "lines",
          line = list(color = "#00441b", width = 2.5),
          fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
          hoverinfo = "text", text = hover_txt,
          name = fam, showlegend = TRUE
        )

      # Normal overlay for t
      if (!is.null(d$normal_y)) {
        norm_hover <- paste0("x = ", round(d$x, 3),
                             "<br>N(0,1) density = ", round(d$normal_y, 4))
        p <- p |>
          plotly::add_trace(
            x = d$x, y = d$normal_y, type = "scatter", mode = "lines",
            line = list(color = "#e31a1c", width = 2, dash = "dash"),
            hoverinfo = "text", text = norm_hover,
            name = "N(0,1)", showlegend = TRUE
          )
      }
    }

    p |> plotly::layout(
      xaxis = list(title = "x"),
      yaxis = list(title = if (d$discrete) "P(X = x)" else "Density"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.15, yanchor = "top"),
      hovermode = "x unified",
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  # CDF plot
  output$dist_cdf_plot <- renderPlotly({
    req(input$dist_show_cdf)
    d <- dist_data()
    fam <- input$dist_family

    hover_txt <- paste0("x = ", round(d$x, 3),
                        "<br>F(x) = ", round(d$cdf, 4),
                        "<br>Distribution: ", fam,
                        "<br>", d$subtitle)

    if (d$discrete) {
      p <- plotly::plot_ly() |>
        plotly::add_trace(
          x = d$x, y = d$cdf, type = "scatter", mode = "lines+markers",
          line = list(color = "#238b45", width = 2, shape = "hv"),
          marker = list(color = "#238b45", size = 6),
          hoverinfo = "text", text = hover_txt,
          name = "CDF", showlegend = FALSE
        )
    } else {
      p <- plotly::plot_ly() |>
        plotly::add_trace(
          x = d$x, y = d$cdf, type = "scatter", mode = "lines",
          line = list(color = "#00441b", width = 2.5),
          hoverinfo = "text", text = hover_txt,
          name = "CDF", showlegend = TRUE
        )
      if (!is.null(d$normal_cdf)) {
        norm_hover <- paste0("x = ", round(d$x, 3),
                             "<br>N(0,1) CDF = ", round(d$normal_cdf, 4))
        p <- p |>
          plotly::add_trace(
            x = d$x, y = d$normal_cdf, type = "scatter", mode = "lines",
            line = list(color = "#e31a1c", width = 2, dash = "dash"),
            hoverinfo = "text", text = norm_hover,
            name = "N(0,1)", showlegend = TRUE
          )
      }
    }

    p |> plotly::layout(
      xaxis = list(title = "x"),
      yaxis = list(title = "F(x)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.15, yanchor = "top"),
      hovermode = "x unified",
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })


  sample_data <- eventReactive(input$qq_resample, {
    n <- input$qq_n
    switch(input$qq_dist,
      "Normal"              = rnorm(n),
      "t (heavy tails)"     = rt(n, df = input$qq_df_t),
      "Right-skewed (Gamma)" = rgamma(n, shape = 2, rate = 1),
      "Left-skewed"         = -rgamma(n, shape = 2, rate = 1),
      "Uniform"             = runif(n, -2, 2),
      "Bimodal"             = {
        k <- rbinom(n, 1, 0.5)
        ifelse(k == 1, rnorm(n, -2, 0.7), rnorm(n, 2, 0.7))
      },
      rnorm(n)
    )
  })

  output$qq_hist <- renderPlotly({
    x <- sample_data()
    req(x)
    brks <- seq(min(x), max(x), length.out = 31)
    h <- hist(x, breaks = brks, plot = FALSE)

    hover_txt <- paste0("Bin: [", round(h$breaks[-length(h$breaks)], 2), ", ",
                        round(h$breaks[-1], 2), ")",
                        "<br>Count: ", h$counts,
                        "<br>Density: ", round(h$density, 4))

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = h$mids, y = h$density, width = diff(h$breaks)[1],
        marker = list(color = "rgba(35,139,69,0.7)",
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_txt,
        name = "Histogram", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Value"),
        yaxis = list(title = "Density"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(input$qq_dist, "  (n = ", input$qq_n, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        bargap = 0.05,
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$qq_plot <- renderPlotly({
    x <- sort(sample_data())
    req(x)
    n <- length(x)
    # Theoretical quantiles
    p <- (seq_len(n) - 0.5) / n
    theo <- qnorm(p)

    # QQ line through Q1 and Q3
    q_sample <- quantile(x, c(0.25, 0.75))
    q_theo   <- qnorm(c(0.25, 0.75))
    slope     <- diff(q_sample) / diff(q_theo)
    intercept <- q_sample[1] - slope * q_theo[1]
    line_y    <- intercept + slope * theo

    hover_txt <- paste0("Theoretical: ", round(theo, 3),
                        "<br>Sample: ", round(x, 3),
                        "<br>Percentile: ", round(p * 100, 1), "%",
                        "<br>Deviation: ", round(x - line_y, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = theo, y = line_y, type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2, dash = "dash"),
        hoverinfo = "none", name = "Reference line", showlegend = TRUE
      ) |>
      plotly::add_markers(
        x = theo, y = x,
        marker = list(color = "#238b45", size = 5, opacity = 0.6,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt,
        name = "Sample", showlegend = TRUE
      ) |>
      plotly::layout(
        xaxis = list(title = "Theoretical Quantiles (Normal)"),
        yaxis = list(title = "Sample Quantiles"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(input$qq_dist, "  (n = ", input$qq_n, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Compare Distributions ───────────────────────────────────────────
  # Helper: compute density for a given distribution + inputs
  cmp_dens <- function(which_dist, side, x_seq) {
    switch(which_dist,
      "Normal" = {
        mu <- if (side == "a") input$cmp_a_mu else input$cmp_b_mu
        sigma <- if (side == "a") input$cmp_a_sigma else input$cmp_b_sigma
        dnorm(x_seq, mu, sigma)
      },
      "t" = {
        df <- if (side == "a") input$cmp_a_df else input$cmp_b_df
        dt(x_seq, df)
      },
      "Chi-Square" = {
        df <- if (side == "a") input$cmp_a_chisq_df else input$cmp_b_chisq_df
        dchisq(pmax(x_seq, 0), df)
      },
      "Exponential" = {
        rate <- if (side == "a") input$cmp_a_rate else input$cmp_b_rate
        dexp(pmax(x_seq, 0), rate)
      },
      "Uniform" = {
        rng <- if (side == "a") input$cmp_a_range else input$cmp_b_range
        dunif(x_seq, rng[1], rng[2])
      }
    )
  }

  cmp_xrange <- function(dist, side) {
    switch(dist,
      "Normal" = {
        mu <- if (side == "a") input$cmp_a_mu else input$cmp_b_mu
        sigma <- if (side == "a") input$cmp_a_sigma else input$cmp_b_sigma
        c(mu - 4 * sigma, mu + 4 * sigma)
      },
      "t" = c(-5, 5),
      "Chi-Square" = {
        df <- if (side == "a") input$cmp_a_chisq_df else input$cmp_b_chisq_df
        c(0, df + 4 * sqrt(2 * df))
      },
      "Exponential" = {
        rate <- if (side == "a") input$cmp_a_rate else input$cmp_b_rate
        c(0, 5 / rate)
      },
      "Uniform" = {
        rng <- if (side == "a") input$cmp_a_range else input$cmp_b_range
        span <- diff(rng) * 0.3
        c(rng[1] - span, rng[2] + span)
      }
    )
  }

  cmp_label <- function(dist, side) {
    switch(dist,
      "Normal" = {
        mu <- if (side == "a") input$cmp_a_mu else input$cmp_b_mu
        sigma <- if (side == "a") input$cmp_a_sigma else input$cmp_b_sigma
        paste0("Normal(\u03bc=", mu, ", \u03c3=", sigma, ")")
      },
      "t" = {
        df <- if (side == "a") input$cmp_a_df else input$cmp_b_df
        paste0("t(df=", df, ")")
      },
      "Chi-Square" = {
        df <- if (side == "a") input$cmp_a_chisq_df else input$cmp_b_chisq_df
        paste0("\u03c7\u00b2(df=", df, ")")
      },
      "Exponential" = {
        rate <- if (side == "a") input$cmp_a_rate else input$cmp_b_rate
        paste0("Exp(\u03bb=", rate, ")")
      },
      "Uniform" = {
        rng <- if (side == "a") input$cmp_a_range else input$cmp_b_range
        paste0("Unif(", rng[1], ", ", rng[2], ")")
      }
    )
  }

  output$cmp_dist_plot <- renderPlotly({
    dist_a <- input$cmp_dist_a
    dist_b <- input$cmp_dist_b

    rng_a <- cmp_xrange(dist_a, "a")
    rng_b <- cmp_xrange(dist_b, "b")
    x_lo <- min(rng_a[1], rng_b[1])
    x_hi <- max(rng_a[2], rng_b[2])
    x_seq <- seq(x_lo, x_hi, length.out = 500)

    y_a <- cmp_dens(dist_a, "a", x_seq)
    y_b <- cmp_dens(dist_b, "b", x_seq)

    lab_a <- cmp_label(dist_a, "a")
    lab_b <- cmp_label(dist_b, "b")

    plotly::plot_ly() |>
      plotly::add_trace(
        x = x_seq, y = y_a, type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
        name = lab_a,
        hovertemplate = paste0(lab_a, "<br>x = %{x:.2f}<br>f(x) = %{y:.4f}<extra></extra>")
      ) |>
      plotly::add_trace(
        x = x_seq, y = y_b, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2.5),
        fill = "tozeroy", fillcolor = "rgba(38,139,210,0.15)",
        name = lab_b,
        hovertemplate = paste0(lab_b, "<br>x = %{x:.2f}<br>f(x) = %{y:.4f}<extra></extra>")
      ) |>
      plotly::layout(
        xaxis = list(title = "x"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = 1.05, yanchor = "bottom", font = list(size = 12)),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  })
}
