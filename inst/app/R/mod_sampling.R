# Module: Sampling (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
sampling_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Sampling",
  icon = icon("object-group"),
  navset_card_underline(
    nav_panel(
      "Sample Size Effect",
  layout_sidebar(
    sidebar = sidebar(
      width = 280,
      selectInput(ns("size_pop"), "Population Distribution",
                  choices = c("Normal", "Uniform", "Exponential")),
      sliderInput(ns("size_n1"), "Small sample n\u2081", min = 2, max = 500, value = 5),
      sliderInput(ns("size_n2"), "Large sample n\u2082", min = 10, max = 5000, value = 100),
      actionButton(ns("size_go"), "Simulate (5 000 samples each)", class = "btn-success w-100")
    ),
    explanation_box(
      tags$strong("Sample Size & Precision"),
      tags$p("Larger samples yield more precise estimates. The standard error of the
              mean is SE = \u03c3/\u221an, meaning that quadrupling the sample size
              halves the standard error. This explains the law of diminishing returns:
              going from n = 10 to n = 40 helps substantially, but going from n = 1000
              to n = 4000 yields a comparatively modest improvement."),
      tags$p("The relationship between sample size and precision has deep practical
              implications for study design. Researchers must balance statistical power
              against cost: collecting more data is always better statistically, but
              resources are finite. A power analysis (covered in the Calculator tab)
              formalises this trade-off by determining the minimum n needed to detect
              an effect of a given size."),
      tags$p("It is important to note that precision (low SE) is not the same as
              accuracy. A large biased sample will give precise but wrong answers.
              Sampling method matters just as much as sample size \u2014 a well-designed
              stratified sample of n = 500 can outperform a convenience sample of
              n = 5000 if the latter suffers from systematic non-response or
              selection bias."),
      guide = tags$ol(
        tags$li("Set a small value for n\u2081 (e.g., 5) and a larger value for n\u2082 (e.g., 100)."),
        tags$li("Click 'Simulate' to draw 5,000 samples at each size."),
        tags$li("Compare the two histograms — the larger sample produces a much tighter distribution."),
        tags$li("Try different population shapes to see that the effect holds regardless of distribution.")
      )
    ),
    card(full_screen = TRUE, card_header("Sampling Distributions Compared"),
         plotly::plotlyOutput(ns("size_plot"), height = "450px"))
  )
    ),

    nav_panel(
      "Sampling Methods",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("method_type"), "Sampling Method",
                  choices = c("Simple Random", "Stratified", "Cluster",
                              "Two-Stage Cluster (PISA/TIMSS)")),
      numericInput(ns("method_pop"), "Population size", value = 2000, min = 100, max = 50000, step = 100),
      sliderInput(ns("method_n"), "Target sample size", min = 10, max = 2000, value = 100, step = 10),
      conditionalPanel(ns = ns, 
        "input.method_type === 'Two-Stage Cluster (PISA/TIMSS)'",
        sliderInput(ns("method_clusters_sel"), "Clusters to select (stage 1)",
                    min = 2, max = 30, value = 8),
        sliderInput(ns("method_within_n"), "Sample per cluster (stage 2)",
                    min = 5, max = 100, value = 25, step = 5)
      ),
      actionButton(ns("method_draw"), "Draw sample", class = "btn-success w-100")
    ),
    explanation_box(
      tags$strong("Sampling Methods"),
      tags$p("Different research designs require different sampling strategies. The
              choice of method affects representativeness, cost, and the precision of
              estimates. International assessments like PISA, PIRLS, and TIMSS use
              two-stage cluster sampling for practical reasons: it's infeasible to
              randomly sample students from every school, so they first sample
              schools (clusters), then students within selected schools."),
      tags$p(
        tags$b("Simple Random:"), " every unit equally likely to be selected.", tags$br(),
        tags$b("Stratified:"), " divide into strata, sample proportionally from each — ensures representation.", tags$br(),
        tags$b("Cluster:"), " randomly select entire clusters — cheaper, but more variable.", tags$br(),
        tags$b("Two-Stage Cluster:"), " select clusters, then sample within each — balances cost and coverage."
      ),
      tags$p("The choice of sampling method has direct implications for how you analyse
              the resulting data. Stratified and cluster samples require design-based
              analysis that accounts for the sampling structure, typically using survey
              weights and design effects. Ignoring the design (e.g., treating a cluster
              sample as if it were a simple random sample) leads to underestimated standard
              errors and overly narrow confidence intervals."),
      tags$p("Two-stage cluster sampling is the workhorse of large-scale educational
              assessments because it dramatically reduces logistical costs while maintaining
              national representativeness. In PISA, for example, schools are sampled
              proportional to size in the first stage, then a fixed number of students
              are randomly selected within each school. The resulting design effect
              typically means that the effective sample size is smaller than the raw
              count of respondents."),
      guide = tags$ol(
        tags$li("Set the population size and choose a sampling method."),
        tags$li("Click 'Draw sample' — bright points are sampled, faded ones are not."),
        tags$li("Check the breakdown table to see how many were sampled from each group."),
        tags$li("Try 'Stratified' — notice each group is represented proportionally."),
        tags$li("Try 'Cluster' — notice entire clusters are selected or excluded."),
        tags$li("Try 'Two-Stage Cluster' — set clusters to select and within-cluster sample size to mimic PISA/TIMSS designs.")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Population & Sample"),
           plotly::plotlyOutput(ns("method_plot"), height = "420px")),
      card(full_screen = TRUE, card_header("Sample Breakdown by Group"),
           div(style = "overflow-y: auto; max-height: 420px;",
               tableOutput(ns("method_table"))))
    )
  )
    ),

    nav_panel(
      "Sample Size Calculator",
  navset_card_underline(
    # --- Tab A: Power-based ---
    nav_panel(
      "Power Analysis",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("ss_test"), "Test type",
                      choices = c("Two-sample t-test", "One-sample t-test",
                                  "One-way ANOVA", "Correlation")),
          sliderInput(ns("ss_power"), "Desired power", min = 0.50, max = 0.99,
                      value = 0.80, step = 0.01),
          sliderInput(ns("ss_alpha"), "Significance level (\u03b1)", min = 0.01, max = 0.10,
                      value = 0.05, step = 0.01),
          conditionalPanel(ns = ns, 
            "input.ss_test === 'Two-sample t-test' || input.ss_test === 'Paired t-test'",
            sliderInput(ns("ss_d"), "Effect size (Cohen's d)", min = 0.05, max = 2.0,
                        value = 0.5, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            "input.ss_test === 'Correlation'",
            sliderInput(ns("ss_r"), "Effect size (r)", min = 0.05, max = 0.95,
                        value = 0.3, step = 0.05)
          ),
          conditionalPanel(ns = ns, 
            "input.ss_test === 'One-way ANOVA'",
            sliderInput(ns("ss_f"), "Effect size (Cohen's f)", min = 0.05, max = 1.0,
                        value = 0.25, step = 0.05),
            sliderInput(ns("ss_k"), "Number of groups", min = 2, max = 10, value = 3)
          )
        ),
        explanation_box(
          tags$strong("Power Analysis"),
          tags$p("Power is the probability of correctly detecting a real effect
                  (rejecting H\u2080 when it is actually false). Before collecting data,
                  a power analysis determines the sample size needed to achieve a
                  desired level of power (typically 80%) for detecting an effect of a
                  given size at a given significance level. Underpowered studies risk
                  Type II errors (missing real effects); overpowered studies waste resources."),
          tags$p("Four quantities are linked in a power analysis: sample size (n), effect
                  size, significance level (\u03b1), and power (1 \u2212 \u03b2). Fixing
                  any three determines the fourth. Common effect size metrics include
                  Cohen\u2019s d (t-tests), Cohen\u2019s f (ANOVA), and r (correlation).
                  Cohen\u2019s conventional benchmarks (d = 0.2/0.5/0.8 for small/medium/large)
                  are widely used but should be interpreted in context \u2014 a \u201csmall\u201d
                  effect in one field may be practically important in another."),
          tags$p("A common mistake is performing power analysis ", tags$em("after"), " collecting data
                  (post-hoc power). This is circular and uninformative because observed power
                  is a direct transformation of the p-value. Power analysis is only meaningful
                  as a prospective planning tool."),
          guide = tags$ol(
            tags$li("Select the test type (t-test, ANOVA, or correlation)."),
            tags$li("Set desired power (0.80 is standard), significance level (0.05 is standard)."),
            tags$li("Adjust the effect size — smaller effects need larger samples."),
            tags$li("The left panel shows the required n; the power curve on the right shows how n varies with effect size."),
            tags$li("The red dot marks your current selection.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Required n"),
               uiOutput(ns("ss_result"))),
          card(full_screen = TRUE, card_header("Power Curve"),
               plotly::plotlyOutput(ns("ss_curve"), height = "380px"))
        ),
        card(full_screen = TRUE, card_header("Population vs Sample Visualization"),
             plotly::plotlyOutput(ns("ss_pop_viz"), height = "300px"))
      )
    ),
    # --- Tab B: Survey-style ---
    nav_panel(
      "Survey / Proportion",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          numericInput(ns("sv_pop"), "Population size (leave blank for infinite)",
                       value = NA, min = 1, step = 1),
          sliderInput(ns("sv_conf"), "Confidence level", min = 0.80, max = 0.99,
                      value = 0.95, step = 0.01),
          sliderInput(ns("sv_margin"), "Margin of error (%)", min = 0.5, max = 20,
                      value = 5, step = 0.5),
          sliderInput(ns("sv_p"), "Expected proportion (p)", min = 0.01, max = 0.99,
                      value = 0.50, step = 0.01),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
                 "Use p = 0.50 for maximum (most conservative) sample size.
                  Set a specific p if you have a prior estimate.")
        ),
        explanation_box(
          tags$strong("Survey Sample Size Calculator"),
          tags$p("When designing a survey to estimate a proportion (e.g., percentage who
                  support a policy), you need enough responses to achieve a desired
                  margin of error. The formula uses the z-score for the confidence level,
                  the expected proportion p, and the margin of error e:
                  n = z\u00b2 \u00d7 p(1\u2212p) / e\u00b2. If the population is finite,
                  a finite population correction (FPC) reduces the required n."),
          tags$p("Using p = 0.50 gives the most conservative (largest) sample size
                  because the variance p(1\u2212p) is maximised at 0.5. If you have a
                  reasonable prior estimate (e.g., from a pilot study), using that value
                  reduces the required n. For rare outcomes (p near 0 or 1), considerably
                  fewer respondents may be needed."),
          tags$p("The margin of error applies to the point estimate of the proportion.
                  A \u00b13% margin means the true proportion is likely within 3 percentage
                  points of the survey result. Halving the margin of error requires
                  roughly quadrupling the sample size, illustrating the same diminishing-returns
                  principle seen in the Sample Size Effect tab."),
          tags$p("Keep in mind that these calculations assume simple random sampling. If
                  you are using cluster or stratified designs, the effective sample size
                  may differ due to design effects. Non-response also inflates the required
                  sample: if you expect a 50% response rate, you need to invite twice as
                  many participants as the calculated n."),
          guide = tags$ol(
            tags$li("Enter the population size (leave blank if very large or unknown)."),
            tags$li("Set the confidence level (95% is standard) and margin of error (e.g., 5%)."),
            tags$li("Adjust the expected proportion if you have a prior estimate; use 0.50 if unsure."),
            tags$li("The left panel shows the required sample size; the curve shows how n changes with margin of error.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(card_header("Required Sample Size"),
               uiOutput(ns("sv_result"))),
          card(full_screen = TRUE, card_header("Sample Size vs Margin of Error"),
               plotly::plotlyOutput(ns("sv_curve"), height = "380px"))
        )
      )
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

sampling_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  size_data <- reactiveVal(NULL)
  
  observeEvent(input$size_go, {
    n1 <- input$size_n1; n2 <- input$size_n2; pop <- input$size_pop
    means1 <- replicate(5000, mean(rpop(n1, pop)))
    means2 <- replicate(5000, mean(rpop(n2, pop)))
    size_data(data.frame(
      xbar = c(means1, means2),
      group = factor(rep(c(paste0("n = ", n1), paste0("n = ", n2)),
                         each = 5000),
                     levels = c(paste0("n = ", n1), paste0("n = ", n2)))
    ))
  })
  
  output$size_plot <- plotly::renderPlotly({
    df <- size_data()
    req(df)
    {
      groups <- levels(df$group)
      colors <- c("#e31a1c", "#238b45")
      p <- plotly::plot_ly()
      for (i in seq_along(groups)) {
        vals <- df$xbar[df$group == groups[i]]
        p <- p |> plotly::add_histogram(
          x = vals, name = groups[i],
          histnorm = "probability density", nbinsx = 60,
          marker = list(color = colors[i], opacity = 0.55,
                        line = list(color = "white", width = 0.5))
        )
      }
      p |> plotly::layout(
        barmode = "overlay",
        xaxis = list(title = "Sample Mean"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = 1.02, yanchor = "bottom", font = list(size = 11)),
        margin = list(b = 40, t = 50)
      )
    }
  })
  

  pop_df <- reactive({
    n_pop <- input$method_pop
    # Seed depends on pop size so population regenerates when slider changes
    set.seed(4781 + n_pop)
    group <- sample(LETTERS[1:5], n_pop, replace = TRUE,
                    prob = c(0.3, 0.25, 0.2, 0.15, 0.1))
    cluster_size <- max(20, round(n_pop / 40))
    x <- rnorm(n_pop) + as.numeric(factor(group))
    y <- rnorm(n_pop) + as.numeric(factor(group)) * 0.5
    data.frame(x = x, y = y, group = group,
               cluster = paste0("C", ceiling(seq_len(n_pop) / cluster_size)))
  })
  
  method_result <- reactiveVal(NULL)
  
  observeEvent(input$method_draw, {
    df <- pop_df()
    n <- min(input$method_n, nrow(df))
  
    idx <- switch(input$method_type,
      "Simple Random" = sample(nrow(df), n),
      "Stratified" = {
        groups <- unique(df$group)
        # Proportional allocation
        group_sizes <- table(df$group)
        unlist(lapply(groups, function(g) {
          rows <- which(df$group == g)
          n_g <- max(1, round(n * length(rows) / nrow(df)))
          sample(rows, min(n_g, length(rows)))
        }))
      },
      "Cluster" = {
        clusters <- unique(df$cluster)
        n_clusters <- max(1, ceiling(n / (nrow(df) / length(clusters))))
        sel_clusters <- sample(clusters, min(n_clusters, length(clusters)))
        which(df$cluster %in% sel_clusters)
      },
      "Two-Stage Cluster (PISA/TIMSS)" = {
        clusters <- unique(df$cluster)
        n_sel <- min(input$method_clusters_sel, length(clusters))
        sel_clusters <- sample(clusters, n_sel)
        # Stage 2: sample within each selected cluster
        within_n <- input$method_within_n
        unlist(lapply(sel_clusters, function(cl) {
          rows <- which(df$cluster == cl)
          sample(rows, min(within_n, length(rows)))
        }))
      }
    )
  
    df$sampled <- seq_len(nrow(df)) %in% idx
    method_result(df)
  })
  
  output$method_plot <- plotly::renderPlotly({
    df <- method_result()
    req(df)
    {
      use_cluster <- input$method_type %in% c("Cluster", "Two-Stage Cluster (PISA/TIMSS)")
      color_var <- if (use_cluster) "cluster" else "group"
      cats <- sort(unique(df[[color_var]]))
      palette <- if (length(cats) <= 8) {
        RColorBrewer::brewer.pal(max(3, length(cats)), "Dark2")[seq_along(cats)]
      } else {
        colorRampPalette(c("#1b9e77", "#d95f02", "#7570b3", "#e7298a"))(length(cats))
      }

      p <- plotly::plot_ly()
      # Unsampled (faded)
      unsamp <- df[!df$sampled, ]
      if (nrow(unsamp) > 0) {
        p <- p |> plotly::add_markers(
          data = unsamp, x = ~x, y = ~y,
          color = unsamp[[color_var]],
          colors = palette,
          marker = list(size = 3, opacity = 0.12),
          showlegend = FALSE, hoverinfo = "none"
        )
      }
      # Sampled (bright)
      samp <- df[df$sampled, ]
      if (nrow(samp) > 0) {
        p <- p |> plotly::add_markers(
          data = samp, x = ~x, y = ~y,
          color = samp[[color_var]],
          colors = palette,
          marker = list(size = 6, opacity = 0.85),
          hoverinfo = "text",
          text = paste0(if (use_cluster) "Cluster: " else "Group: ",
                        samp[[color_var]],
                        "<br>x: ", round(samp$x, 2),
                        "<br>y: ", round(samp$y, 2))
        )
      }
      p |> plotly::layout(
        title = list(
          text = paste0(input$method_type, " \u2014 ",
                        sum(df$sampled), " of ", nrow(df), " units selected"),
          font = list(size = 13)
        ),
        xaxis = list(title = ""), yaxis = list(title = ""),
        legend = list(title = list(text = if (use_cluster) "Cluster" else "Group"),
                      orientation = "v", font = list(size = 10)),
        margin = list(t = 40)
      )
    }
  })
  
  output$method_table <- renderTable({
    df <- method_result()
    req(df)
    is_cluster <- input$method_type %in% c("Cluster", "Two-Stage Cluster (PISA/TIMSS)")
    by_var <- if (is_cluster) "cluster" else "group"
    by_label <- if (is_cluster) "Cluster" else "Group"

    grp_pop <- as.data.frame(table(df[[by_var]]), stringsAsFactors = FALSE)
    names(grp_pop) <- c(by_label, "Population")
    grp_samp <- as.data.frame(table(df[[by_var]][df$sampled]), stringsAsFactors = FALSE)
    names(grp_samp) <- c(by_label, "Sampled")
    tbl <- merge(grp_pop, grp_samp, by = by_label, all.x = TRUE)
    tbl$Sampled[is.na(tbl$Sampled)] <- 0L
    tbl$`% Sampled` <- round(tbl$Sampled / tbl$Population * 100, 1)

    if (is_cluster) {
      tbl$Status <- ifelse(tbl$Sampled > 0, "\u2713 Selected", "\u2717 Not selected")
      # Collapse unselected clusters into a single summary row
      selected <- tbl[tbl$Sampled > 0, ]
      not_selected <- tbl[tbl$Sampled == 0, ]
      if (nrow(not_selected) > 0) {
        summary_row <- data.frame(
          V1 = paste0("(", nrow(not_selected), " unselected clusters)"),
          Population = sum(not_selected$Population),
          Sampled = 0L,
          Pct = 0,
          Status = "\u2717 Not selected",
          stringsAsFactors = FALSE
        )
        names(summary_row) <- names(tbl)
        tbl <- rbind(selected, summary_row)
      }
    }

    totals <- data.frame(V1 = "TOTAL",
                         Population = sum(grp_pop$Population),
                         Sampled = sum(grp_samp$Sampled),
                         Pct = round(sum(grp_samp$Sampled) / sum(grp_pop$Population) * 100, 1),
                         check.names = FALSE)
    names(totals)[1] <- by_label
    if (is_cluster) totals$Status <- ""
    names(totals) <- names(tbl)
    rbind(tbl, totals)
  }, hover = TRUE, spacing = "m")
  

  ss_calc <- reactive({
    test <- input$ss_test
    alpha <- input$ss_alpha
    power <- input$ss_power
  
    if (test == "Two-sample t-test") {
      d <- input$ss_d
      res <- power.t.test(delta = d, sd = 1, sig.level = alpha,
                          power = power, type = "two.sample")
      list(n = ceiling(res$n), label = "per group")
    } else if (test == "One-sample t-test") {
      d <- input$ss_d
      res <- power.t.test(delta = d, sd = 1, sig.level = alpha,
                          power = power, type = "one.sample")
      list(n = ceiling(res$n), label = "total")
    } else if (test == "One-way ANOVA") {
      f <- input$ss_f
      k <- input$ss_k
      res <- power.anova.test(groups = k, between.var = f^2,
                              within.var = 1, sig.level = alpha,
                              power = power)
      list(n = ceiling(res$n), label = "per group")
    } else {
      # Correlation
      r <- input$ss_r
      # Fisher z approach
      z_alpha <- qnorm(1 - alpha / 2)
      z_beta <- qnorm(power)
      C <- 0.5 * log((1 + r) / (1 - r))
      n <- ceiling(((z_alpha + z_beta) / C)^2 + 3)
      list(n = n, label = "total")
    }
  })
  
  output$ss_result <- renderUI({
    res <- ss_calc()
    div(
      style = "text-align: center; padding: 30px 0;",
      tags$h1(style = "color: #238b45; font-size: 3rem; margin: 0;", res$n),
      tags$p(style = "font-size: 1.1rem; color: #00441b;",
             paste("observations", res$label)),
      tags$p(class = "text-muted",
             paste0("Test: ", input$ss_test, "  |  \u03b1 = ", input$ss_alpha,
                    "  |  Power = ", input$ss_power))
    )
  })
  
  output$ss_curve <- plotly::renderPlotly({
    test <- input$ss_test
    alpha <- input$ss_alpha
    target_power <- input$ss_power

    if (test %in% c("Two-sample t-test", "One-sample t-test")) {
      d_seq <- seq(0.1, 2.0, by = 0.05)
      tt_type <- if (test == "Two-sample t-test") "two.sample" else "one.sample"
      n_seq <- sapply(d_seq, function(d) {
        ceiling(power.t.test(delta = d, sd = 1, sig.level = alpha,
                             power = target_power, type = tt_type)$n)
      })
      cur_d <- input$ss_d
      cur_n <- ss_calc()$n
      x_lab <- "Effect size (Cohen's d)"
      y_lab <- "Required n"
      subtitle <- paste0("Power = ", target_power, "  |  \u03b1 = ", alpha)

      plotly::plot_ly() |>
        plotly::add_lines(x = d_seq, y = n_seq,
                          line = list(color = "#238b45", width = 2),
                          showlegend = FALSE, hovertemplate = "d = %{x}<br>n = %{y}<extra></extra>") |>
        plotly::add_markers(x = cur_d, y = cur_n,
                            marker = list(color = "#e31a1c", size = 10),
                            showlegend = FALSE, hoverinfo = "text",
                            text = paste0("Current: d = ", cur_d, ", n = ", cur_n)) |>
        plotly::layout(xaxis = list(title = x_lab), yaxis = list(title = y_lab),
                       title = list(text = subtitle, font = list(size = 13)),
                       margin = list(t = 40))

    } else if (test == "One-way ANOVA") {
      f_seq <- seq(0.1, 1.0, by = 0.05)
      k <- input$ss_k
      n_seq <- sapply(f_seq, function(f) {
        ceiling(power.anova.test(groups = k, between.var = f^2,
                                 within.var = 1, sig.level = alpha,
                                 power = target_power)$n)
      })
      cur_f <- input$ss_f
      cur_n <- ss_calc()$n
      subtitle <- paste0(k, " groups  |  Power = ", target_power, "  |  \u03b1 = ", alpha)

      plotly::plot_ly() |>
        plotly::add_lines(x = f_seq, y = n_seq,
                          line = list(color = "#238b45", width = 2),
                          showlegend = FALSE, hovertemplate = "f = %{x}<br>n = %{y}<extra></extra>") |>
        plotly::add_markers(x = cur_f, y = cur_n,
                            marker = list(color = "#e31a1c", size = 10),
                            showlegend = FALSE, hoverinfo = "text",
                            text = paste0("Current: f = ", cur_f, ", n = ", cur_n)) |>
        plotly::layout(xaxis = list(title = "Effect size (Cohen's f)"),
                       yaxis = list(title = "Required n per group"),
                       title = list(text = subtitle, font = list(size = 13)),
                       margin = list(t = 40))

    } else {
      r_seq <- seq(0.1, 0.9, by = 0.05)
      z_alpha <- qnorm(1 - alpha / 2)
      z_beta <- qnorm(target_power)
      n_seq <- sapply(r_seq, function(r) {
        C <- 0.5 * log((1 + r) / (1 - r))
        ceiling(((z_alpha + z_beta) / C)^2 + 3)
      })
      cur_r <- input$ss_r
      cur_n <- ss_calc()$n
      subtitle <- paste0("Power = ", target_power, "  |  \u03b1 = ", alpha)

      plotly::plot_ly() |>
        plotly::add_lines(x = r_seq, y = n_seq,
                          line = list(color = "#238b45", width = 2),
                          showlegend = FALSE, hovertemplate = "r = %{x}<br>n = %{y}<extra></extra>") |>
        plotly::add_markers(x = cur_r, y = cur_n,
                            marker = list(color = "#e31a1c", size = 10),
                            showlegend = FALSE, hoverinfo = "text",
                            text = paste0("Current: r = ", cur_r, ", n = ", cur_n)) |>
        plotly::layout(xaxis = list(title = "Effect size (r)"),
                       yaxis = list(title = "Required n"),
                       title = list(text = subtitle, font = list(size = 13)),
                       margin = list(t = 40))
    }
  })
  
  output$ss_pop_viz <- plotly::renderPlotly({
    res <- ss_calc()
    req(res)
    n_sample <- res$n
    n_pop <- max(n_sample * 5, 200)
    set.seed(7193)
    x <- runif(n_pop)
    y <- runif(n_pop)
    sampled <- seq_len(n_pop) <= n_sample

    plotly::plot_ly() |>
      plotly::add_markers(
        x = x[!sampled], y = y[!sampled],
        marker = list(color = "#cccccc", size = 3, opacity = 0.2),
        name = paste0("Population (N=", n_pop, ")"),
        hoverinfo = "none"
      ) |>
      plotly::add_markers(
        x = x[sampled], y = y[sampled],
        marker = list(color = "#238b45", size = 5, opacity = 0.9),
        name = paste0("Sample (n=", n_sample, ")"),
        hoverinfo = "none"
      ) |>
      plotly::layout(
        title = list(
          text = paste0("Sample of ", n_sample, " from population of ", n_pop),
          font = list(size = 13)
        ),
        xaxis = list(visible = FALSE), yaxis = list(visible = FALSE),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.05, yanchor = "top", font = list(size = 11)),
        margin = list(t = 40, b = 40)
      )
  })
  
  # -----------------------------------------------------------------------
  # 8b — Survey Sample Size Calculator
  # -----------------------------------------------------------------------
  sv_calc <- reactive({
    z <- qnorm(1 - (1 - input$sv_conf) / 2)
    e <- input$sv_margin / 100
    p <- input$sv_p
  
    n_inf <- ceiling((z^2 * p * (1 - p)) / e^2)
  
    pop <- input$sv_pop
    if (!is.na(pop) && pop > 0) {
      n <- ceiling((n_inf * pop) / (n_inf + pop - 1))
    } else {
      n <- n_inf
    }
    list(n = n, n_inf = n_inf)
  })
  
  output$sv_result <- renderUI({
    res <- sv_calc()
    pop <- input$sv_pop
    fpc_note <- if (!is.na(pop) && pop > 0) {
      paste0("(with FPC from N = ", format(pop, big.mark = ","), ";  ",
             "without FPC: ", format(res$n_inf, big.mark = ","), ")")
    } else {
      "(infinite population assumed)"
    }
  
    div(
      style = "text-align: center; padding: 30px 0;",
      tags$h1(style = "color: #238b45; font-size: 3rem; margin: 0;",
              format(res$n, big.mark = ",")),
      tags$p(style = "font-size: 1.1rem; color: #00441b;", "responses needed"),
      tags$p(class = "text-muted", fpc_note),
      tags$p(class = "text-muted",
             paste0("Confidence: ", input$sv_conf * 100,
                    "%  |  Margin: \u00b1", input$sv_margin,
                    "%  |  p = ", input$sv_p))
    )
  })
  
  output$sv_curve <- plotly::renderPlotly({
    z <- qnorm(1 - (1 - input$sv_conf) / 2)
    p <- input$sv_p
    pop <- input$sv_pop
    cur_margin <- input$sv_margin

    m_seq <- seq(1, 20, by = 0.5)
    n_seq <- sapply(m_seq, function(m) {
      e <- m / 100
      n0 <- ceiling((z^2 * p * (1 - p)) / e^2)
      if (!is.na(pop) && pop > 0) ceiling(n0 / (1 + (n0 - 1) / pop)) else n0
    })
    cur_n <- sv_calc()$n
    subtitle <- paste0("Confidence: ", input$sv_conf * 100, "%  |  p = ", p)

    plotly::plot_ly() |>
      plotly::add_lines(
        x = m_seq, y = n_seq,
        line = list(color = "#238b45", width = 2),
        showlegend = FALSE,
        hovertemplate = "Margin: %{x}%<br>n = %{y}<extra></extra>"
      ) |>
      plotly::add_markers(
        x = cur_margin, y = cur_n,
        marker = list(color = "#e31a1c", size = 10),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Current: \u00b1", cur_margin, "%, n = ", cur_n)
      ) |>
      plotly::layout(
        xaxis = list(title = "Margin of Error",
                     ticksuffix = "%"),
        yaxis = list(title = "Required n",
                     separatethousands = TRUE),
        title = list(text = subtitle, font = list(size = 13)),
        margin = list(t = 40)
      )
  })
  # Auto-run simulations on first load
  

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Sampling", list(size_data, method_result))
  })
}
