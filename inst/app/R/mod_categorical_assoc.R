# Module: Categorical & Association (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
categorical_assoc_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Categorical & Association",
  icon = icon("table-cells"),
  navset_card_underline(
    nav_panel(
      "Chi-Square",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("chi_rows"), "Number of row categories", min = 2, max = 5, value = 2),
      sliderInput(ns("chi_cols"), "Number of column categories", min = 2, max = 5, value = 3),
      sliderInput(ns("chi_n"), "Total sample size", min = 50, max = 5000, value = 200, step = 50),
      checkboxInput(ns("chi_assoc"), "Add association between variables", value = FALSE),
      conditionalPanel(ns = ns, 
        "input.chi_assoc",
        sliderInput(ns("chi_strength"), "Association strength", min = 0.1, max = 0.9,
                    value = 0.4, step = 0.1)
      ),
      actionButton(ns("chi_go"), "Generate & test", class = "btn-success w-100 mb-2"),
      actionButton(ns("chi_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    explanation_box(
      tags$strong("Chi-Square Test of Independence"),
      tags$p("The chi-square test evaluates whether two categorical variables are
              independent (unrelated). It compares observed cell counts in a
              contingency table to the counts expected under independence. Large
              deviations produce a large \u03c7\u00b2 statistic, indicating association."),
      tags$p("The test statistic is \u03c7\u00b2 = \u2211(O \u2212 E)\u00b2/E, summed over
              all cells, where O is the observed count and E is the expected count
              under independence. Under H\u2080, this follows a chi-square distribution
              with (r \u2212 1)(c \u2212 1) degrees of freedom."),
      tags$p("Assumptions: expected counts should generally be at least 5 in each cell
              (some guidelines allow a few cells below 5 if none is below 1). When this
              condition fails, Fisher\u2019s exact test is a reliable alternative. The
              chi-square test is also sensitive to sample size: with very large samples,
              even trivially small associations become statistically significant, so
              always report an effect size (Cram\u00e9r\u2019s V) alongside the p-value."),
      tags$p("The standardised residual heatmap reveals where the deviations are
              concentrated: positive values mean more cases than expected, negative
              means fewer. Residuals greater than \u00b12 in absolute value flag cells
              that contribute disproportionately to the overall \u03c7\u00b2."),
      guide = tags$ol(
        tags$li("Set the number of row and column categories and total sample size."),
        tags$li("Toggle 'Add association' to introduce a relationship between variables, and adjust its strength."),
        tags$li("Click 'Generate & test'."),
        tags$li("Left plot: grouped bar chart of proportions within each row category — under independence, bars within each group should be similar."),
        tags$li("Right plot: standardized residual heatmap — bright green/red cells indicate where observed counts deviate most from expected."),
        tags$li("Check the test result for \u03c7\u00b2, p-value, and Cram\u00e9r's V.")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Observed Proportions"),
           plotly::plotlyOutput(ns("chi_bar_plot"), height = "400px")),
      card(full_screen = TRUE, card_header("Standardized Residuals"),
           plotly::plotlyOutput(ns("chi_mosaic_plot"), height = "400px"))
    ),
    card(card_header("Contingency Table (Observed)"),
         div(style = "font-size: 1.05rem;",
             tableOutput(ns("chi_obs_table")))),
    card(card_header("Test Result"),
         div(style = "padding: 10px; font-size: 1.05rem;",
             uiOutput(ns("chi_result"))))
  )
    ),

    nav_panel(
      "Correlation",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("corr_n"), "Sample size", min = 30, max = 2000, value = 150, step = 10),
      sliderInput(ns("corr_vars"), "Number of variables", min = 3, max = 10, value = 5),
      selectInput(ns("corr_structure"), "Correlation structure",
                  choices = c("Random", "Block-correlated", "Single factor")),
      selectInput(ns("corr_method"), "Correlation method",
                  choices = c("pearson", "spearman", "kendall")),
      actionButton(ns("corr_go"), "Generate data", class = "btn-success w-100 mb-2"),
      actionButton(ns("corr_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    fillable = FALSE,
      explanation_box(
        tags$strong("Correlation Analysis"),
        tags$p("Correlation measures the strength and direction of the linear
                relationship between two variables. Values range from \u22121 (perfect
                negative) to +1 (perfect positive), with 0 meaning no linear
                relationship. The heatmap shows all pairwise correlations at a glance;
                the scatter matrix reveals the actual data patterns behind those numbers."),
        tags$p(
          tags$b("Pearson (r):"), " measures the strength of the linear relationship between
                  two continuous variables. It is sensitive to outliers and assumes both
                  variables are roughly normally distributed.", tags$br(),
          tags$b("Spearman (\u03c1):"), " a rank-based measure that captures monotonic (but not
                  necessarily linear) relationships. More robust to outliers and
                  non-normality than Pearson.", tags$br(),
          tags$b("Kendall (\u03c4):"), " also rank-based, but uses concordant/discordant pairs
                  rather than rank differences. Preferred for small samples or when
                  many ties are present."
        ),
        tags$p("A critical point: correlation does not imply causation. Two variables can be
                strongly correlated due to a common cause, reverse causation, or coincidence.
                Additionally, a correlation of zero only rules out ", tags$em("linear"), " association
                \u2014 the variables could still have a strong nonlinear relationship (e.g.,
                quadratic). Always visualise the data before interpreting the correlation
                coefficient."),
        tags$p("Correlation is also sensitive to restriction of range: if you only observe
                a narrow slice of one variable, the correlation will appear weaker than in
                the full population. This is especially relevant in selection contexts
                (e.g., correlating test scores with performance among those already selected)."),
        guide = tags$ol(
          tags$li("Choose sample size and number of variables."),
          tags$li("Pick a correlation structure: 'Random' = mixed correlations,
                   'Block-correlated' = groups of related variables,
                   'Single factor' = all variables share one latent cause."),
          tags$li("Click 'Generate data' to create the data."),
          tags$li("Examine the heatmap for the overall correlation pattern."),
          tags$li("Check the scatter matrix to verify that the correlations
                   reflect actual data patterns (watch for outliers, nonlinearity)."),
          tags$li("Try switching between Pearson and Spearman to see how rank-based
                   correlation handles nonlinear relationships differently.")
        )
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(full_screen = TRUE, card_header("Correlation Heatmap"),
             plotly::plotlyOutput(ns("corr_heatmap"), height = "450px")),
        card(full_screen = TRUE, card_header("Scatter Matrix"),
             plotly::plotlyOutput(ns("corr_scatter"), height = "450px"))
      ),
      card(card_header("Correlation Matrix"),
           div(style = "font-size: 1.05rem;",
               tableOutput(ns("corr_table"))))
  )
    ),

    nav_panel(
      "Goodness-of-Fit",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("gof_dist"), "Sample distribution",
        choices = c("Normal" = "norm", "t (df = 5)" = "t5",
                    "Exponential" = "exp", "Uniform" = "unif",
                    "Log-normal" = "lnorm", "Contaminated normal" = "contam"),
        selected = "norm"
      ),
      sliderInput(ns("gof_n"), "Sample size", min = 20, max = 500, value = 100, step = 10),
      selectInput(ns("gof_ref"), "Reference distribution",
        choices = c("Normal" = "norm", "Exponential" = "exp", "Uniform" = "unif"),
        selected = "norm"
      ),
      actionButton(ns("gof_go"), "Test", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Goodness-of-Fit Tests"),
      tags$p("Goodness-of-fit tests assess whether sample data come from a specified
              theoretical distribution. They are used to check distributional assumptions
              before applying parametric methods, or to validate that a fitted model
              adequately describes the data."),
      tags$ul(
        tags$li(tags$strong("Kolmogorov-Smirnov (KS):"), " Compares the empirical CDF to the
                theoretical CDF. The test statistic D is the maximum vertical distance
                between the two curves. It is distribution-free but has low power for
                detecting differences in the tails."),
        tags$li(tags$strong("Shapiro-Wilk:"), " Specifically tests normality and is generally
                the most powerful test for this purpose with small to moderate samples
                (n < 5000). It tests whether the data could plausibly have come from a
                Normal distribution."),
        tags$li(tags$strong("Anderson-Darling:"), " Similar to KS but places more weight on the
                tails of the distribution, making it more sensitive to departures in the
                extremes. Particularly useful when tail behaviour matters (e.g., in risk
                assessment).")
      ),
      tags$p("An important caveat: with large samples, these tests will reject the null
              hypothesis even for trivially small departures from the theoretical
              distribution. A QQ plot (see Distribution Shapes module) provides a more
              informative assessment of ", tags$em("how"), " and ", tags$em("where"), " the data
              depart from the assumed distribution. In practice, combine formal tests
              with graphical diagnostics."),
      tags$p("The choice of goodness-of-fit test depends on the specific hypothesis and
              the sample size. Shapiro-Wilk is generally the most powerful for testing
              normality with small to moderate samples but is limited to normality testing.
              Anderson-Darling is more versatile (applicable to various distributions) and
              more sensitive to tail departures. The KS test is the most general but often
              the least powerful for detecting specific types of departures."),
      guide = tags$ol(
        tags$li("Choose the sample distribution and a reference distribution."),
        tags$li("Click 'Test' to draw a sample and run tests."),
        tags$li("The CDF plot shows the empirical vs. theoretical CDFs, with the KS distance highlighted."),
        tags$li("Try sampling from a normal and testing against normal (should not reject), then try a skewed distribution.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Empirical vs Theoretical CDF"),
           plotlyOutput(ns("gof_cdf"), height = "400px")),
      card(card_header("Test Results"), tableOutput(ns("gof_table")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

categorical_assoc_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  chi_data <- reactiveVal(NULL)
  
  observeEvent(input$chi_reset, chi_data(NULL))
  
  observeEvent(input$chi_go, {
    set.seed(sample(1:10000, 1))
    nr <- input$chi_rows; nc <- input$chi_cols; N <- input$chi_n
    row_labels <- paste0("Row_", LETTERS[seq_len(nr)])
    col_labels <- paste0("Col_", seq_len(nc))
  
    if (input$chi_assoc) {
      s <- input$chi_strength
      # Build probability matrix with association
      base_probs <- matrix(1, nr, nc)
      for (i in seq_len(min(nr, nc))) base_probs[i, i] <- 1 + s * 5
      probs <- as.vector(base_probs) / sum(base_probs)
      cells <- sample(seq_len(nr * nc), N, replace = TRUE, prob = probs)
    } else {
      cells <- sample(seq_len(nr * nc), N, replace = TRUE)
    }
    row_idx <- ((cells - 1) %% nr) + 1
    col_idx <- ((cells - 1) %/% nr) + 1
  
    df <- data.frame(
      row_var = factor(row_labels[row_idx], levels = row_labels),
      col_var = factor(col_labels[col_idx], levels = col_labels)
    )
    chi_data(df)
  })
  
  output$chi_bar_plot <- plotly::renderPlotly({
    df <- chi_data()
    req(df)
    counts <- as.data.frame(table(df$row_var, df$col_var))
    names(counts) <- c("Row", "Column", "Count")
    totals <- aggregate(Count ~ Row, data = counts, sum)
    counts <- merge(counts, totals, by = "Row", suffixes = c("", "_total"))
    counts$Proportion <- counts$Count / counts$Count_total

    greens <- colorRampPalette(c("#99d8c9", "#006d2c"))(nlevels(df$col_var))
    col_levels <- levels(df$col_var)

    p <- plotly::plot_ly()
    for (i in seq_along(col_levels)) {
      sub <- counts[counts$Column == col_levels[i], ]
      p <- p |> plotly::add_bars(textposition = "none",
        x = sub$Row, y = sub$Proportion,
        name = col_levels[i],
        marker = list(color = greens[i]),
        hovertemplate = paste0("Row: %{x}<br>Col: ", col_levels[i],
                               "<br>Proportion: %{y:.3f}<extra></extra>")
      )
    }
    p |> plotly::layout(
      barmode = "group",
      xaxis = list(title = "Row Variable"),
      yaxis = list(title = "Proportion within Row"),
      legend = list(title = list(text = "Column"), orientation = "h",
                    x = 0.5, xanchor = "center", y = -0.15, yanchor = "top"),
      margin = list(b = 60, t = 20)
    )
  })
  
  output$chi_mosaic_plot <- plotly::renderPlotly({
    df <- chi_data()
    req(df)
    obs <- table(df$row_var, df$col_var)
    test <- chisq.test(obs)

    std_resid <- as.data.frame(test$residuals)
    names(std_resid) <- c("Row", "Column", "StdResid")

    rows <- levels(df$row_var)
    cols <- levels(df$col_var)
    z_mat <- matrix(std_resid$StdResid, nrow = length(rows), ncol = length(cols),
                    dimnames = list(rows, cols))

    hover_text <- matrix(
      paste0("Row: ", rep(rows, length(cols)),
             "<br>Col: ", rep(cols, each = length(rows)),
             "<br>Std. Residual: ", round(as.vector(z_mat), 2)),
      nrow = length(rows), ncol = length(cols)
    )

    zmax <- max(abs(z_mat), na.rm = TRUE)

    plotly::plot_ly(
      x = cols, y = rows, z = z_mat,
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(
          c(0,     "#ffffd9"),
          c(0.125, "#edf8b1"),
          c(0.25,  "#c7e9b4"),
          c(0.375, "#7fcdbb"),
          c(0.5,   "#41b6c4"),
          c(0.625, "#1d91c0"),
          c(0.75,  "#225ea8"),
          c(0.875, "#253494"),
          c(1,     "#081d58")
        ),
      zmin = -zmax, zmax = zmax,
      hoverinfo = "text", text = hover_text,
      colorbar = list(title = "Std.\nResid.")
    ) |>
      plotly::layout(
        annotations = lapply(seq_len(nrow(std_resid)), function(i) {
          list(x = as.character(std_resid$Column[i]),
               y = as.character(std_resid$Row[i]),
               text = round(std_resid$StdResid[i], 1),
               showarrow = FALSE,
               font = list(size = 13,
                            color = if (abs(std_resid$StdResid[i]) > 1.5) "white" else "#333"))
        }),
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        title = list(text = "Positive = more than expected; Negative = fewer",
                     font = list(size = 12)),
        margin = list(t = 40)
      )
  })
  
  output$chi_obs_table <- renderTable({
    df <- chi_data()
    req(df)
    tbl <- as.data.frame.matrix(table(df$row_var, df$col_var))
    tbl <- cbind(Category = rownames(tbl), tbl)
    rownames(tbl) <- NULL
    tbl
  }, hover = TRUE, spacing = "m")
  
  output$chi_result <- renderUI({
    df <- chi_data()
    req(df)
    obs <- table(df$row_var, df$col_var)
    test <- chisq.test(obs)
    n <- sum(obs)
    k <- min(nrow(obs), ncol(obs))
    cramers_v <- sqrt(test$statistic / (n * (k - 1)))
  
    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$p(tags$strong("Test: "), "Pearson's Chi-Square Test of Independence"),
      tags$p(tags$strong("\u03c7\u00b2 = "), round(test$statistic, 3),
             tags$strong("  df = "), test$parameter,
             tags$strong("  p = "), format.pval(test$p.value, digits = 4)),
      tags$p(tags$strong("Cram\u00e9r's V = "), round(cramers_v, 3)),
      if (test$p.value < 0.05)
        tags$p(style = "color: #238b45; font-weight: bold;",
               "\u2713 Variables appear to be associated")
      else
        tags$p(style = "color: #e31a1c; font-weight: bold;",
               "\u2717 No significant association detected")
    )
  })
  

  corr_data <- reactiveVal(NULL)
  
  observeEvent(input$corr_reset, corr_data(NULL))
  
  observeEvent(input$corr_go, {
    set.seed(sample(1:10000, 1))
    n <- input$corr_n; p <- input$corr_vars
    struct <- input$corr_structure

    if (struct == "Random") {
      A <- matrix(rnorm(p * p), p, p)
      Sigma <- crossprod(A) / p
      D <- diag(1 / sqrt(diag(Sigma)))
      Sigma <- D %*% Sigma %*% D
    } else if (struct == "Block-correlated") {
      n_blocks <- min(3, ceiling(p / 2))
      Sigma <- diag(p)
      for (b in seq_len(n_blocks)) {
        idx <- which(((seq_len(p) - 1) %% n_blocks) + 1 == b)
        for (i in idx) for (j in idx) {
          if (i != j) Sigma[i, j] <- runif(1, 0.5, 0.85)
        }
      }
      eig <- eigen(Sigma)
      eig$values <- pmax(eig$values, 0.01)
      Sigma <- eig$vectors %*% diag(eig$values) %*% t(eig$vectors)
      D <- diag(1 / sqrt(diag(Sigma)))
      Sigma <- D %*% Sigma %*% D
    } else {
      loadings <- runif(p, 0.4, 0.9)
      Sigma <- tcrossprod(loadings) + diag(1 - loadings^2)
    }

    dat <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma)
    colnames(dat) <- paste0("V", seq_len(p))
    corr_data(as.data.frame(dat))
  })
  
  output$corr_heatmap <- plotly::renderPlotly({
    df <- corr_data()
    req(df)
    r <- cor(df, method = input$corr_method)
    vars <- colnames(r)
    
    hover_text <- matrix(
      paste0(rep(vars, times = length(vars)), " \u00d7 ",
             rep(vars, each = length(vars)), "<br>r = ",
             round(as.vector(r), 3)),
      nrow = length(vars), ncol = length(vars)
    )
    
    # Annotation text for cell values
    annots <- lapply(seq_along(vars), function(i) {
      lapply(seq_along(vars), function(j) {
        list(x = vars[j], y = vars[i],
             text = round(r[i, j], 2),
             font = list(size = 10,
                         color = if (abs(r[i,j]) > 0.6) "white" else "#333"),
             showarrow = FALSE, xref = "x", yref = "y")
      })
    }) |> unlist(recursive = FALSE)
    
    plotly::plot_ly(
      x = vars, y = rev(vars), z = r[rev(seq_along(vars)), ],
      type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(
          c(0,     "#ffffd9"),
          c(0.125, "#edf8b1"),
          c(0.25,  "#c7e9b4"),
          c(0.375, "#7fcdbb"),
          c(0.5,   "#41b6c4"),
          c(0.625, "#1d91c0"),
          c(0.75,  "#225ea8"),
          c(0.875, "#253494"),
          c(1,     "#081d58")
        ),
      zmin = -1, zmax = 1,
      hoverinfo = "text",
      text = hover_text[rev(seq_along(vars)), ],
      colorbar = list(title = "r")
    ) |>
      plotly::layout(
        title = list(text = paste0(input$corr_method, " correlation"),
                     font = list(size = 13)),
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        annotations = annots,
        margin = list(t = 40, l = 50, b = 60)
      )
  })
  
  output$corr_scatter <- plotly::renderPlotly({
    df <- corr_data()
    req(df)
    np <- ncol(df)
    df_sub <- df[, seq_len(min(np, 6))]
    vars <- names(df_sub)
    nv <- length(vars)
    r <- cor(df_sub, method = input$corr_method)

    p <- plotly::subplot(
      lapply(seq_len(nv), function(row) {
        lapply(seq_len(nv), function(col) {
          xa <- paste0("x", (row - 1) * nv + col)
          ya <- paste0("y", (row - 1) * nv + col)
          if (row == col) {
            # Diagonal: show correlation label as annotation (empty plot)
            plotly::plot_ly(type = "scatter", mode = "none") |>
              plotly::layout(
                annotations = list(list(
                  x = 0.5, y = 0.5, xref = "paper", yref = "paper",
                  text = paste0("<b>", vars[row], "</b>"),
                  showarrow = FALSE, font = list(size = 14, color = "#238b45")
                ))
              )
          } else if (col < row) {
            # Lower triangle: scatter + regression line
            x_vals <- df_sub[[vars[col]]]
            y_vals <- df_sub[[vars[row]]]
            fit <- lm(y_vals ~ x_vals)
            x_seq <- seq(min(x_vals), max(x_vals), length.out = 50)
            y_hat <- predict(fit, newdata = data.frame(x_vals = x_seq))

            plotly::plot_ly() |>
              plotly::add_markers(
                x = x_vals, y = y_vals,
                marker = list(color = "rgba(0,68,27,0.3)", size = 3),
                showlegend = FALSE, hoverinfo = "text",
                text = paste0(vars[col], ": ", round(x_vals, 2),
                              "<br>", vars[row], ": ", round(y_vals, 2))
              ) |>
              plotly::add_lines(
                x = x_seq, y = y_hat,
                line = list(color = "#238b45", width = 2),
                showlegend = FALSE, hoverinfo = "none"
              )
          } else {
            # Upper triangle: show r value
            rv <- r[row, col]
            plotly::plot_ly(type = "scatter", mode = "none") |>
              plotly::layout(
                annotations = list(list(
                  x = 0.5, y = 0.5, xref = "paper", yref = "paper",
                  text = round(rv, 2), showarrow = FALSE,
                  font = list(size = 18, color = if (abs(rv) > 0.5) "#238b45" else "grey50")
                ))
              )
          }
        })
      }) |> unlist(recursive = FALSE),
      nrows = nv, shareX = FALSE, shareY = FALSE
    ) |>
      plotly::layout(
        showlegend = FALSE,
        margin = list(t = 20, l = 40, b = 40, r = 10)
      )

    # Hide all subplot axes
    axis_opts <- list(showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE)
    n_sub <- nv * nv
    ax_names <- c(
      ifelse(seq_len(n_sub) == 1, "xaxis", paste0("xaxis", seq_len(n_sub))),
      ifelse(seq_len(n_sub) == 1, "yaxis", paste0("yaxis", seq_len(n_sub)))
    )
    ax_list <- setNames(replicate(2 * n_sub, axis_opts, simplify = FALSE), ax_names)
    do.call(plotly::layout, c(list(p = p), ax_list))
  })
  
  output$corr_table <- renderTable({
    df <- corr_data()
    req(df)
    r <- cor(df, method = input$corr_method)
    out <- as.data.frame(round(r, 3))
    out <- cbind(Variable = rownames(out), out)
    rownames(out) <- NULL
    out
  }, hover = TRUE, spacing = "m")
  

  gof_data <- reactiveVal(NULL)

  observeEvent(input$gof_go, {
    n <- input$gof_n; ref <- input$gof_ref
    set.seed(sample.int(10000, 1))

    x <- switch(input$gof_dist,
      "norm"   = rnorm(n),
      "t5"     = rt(n, df = 5),
      "exp"    = rexp(n),
      "unif"   = runif(n, -2, 2),
      "lnorm"  = rlnorm(n),
      "contam" = c(rnorm(round(0.9 * n)), rnorm(round(0.1 * n), 5, 0.5))
    )

    # KS test
    ks <- switch(ref,
      "norm" = ks.test(x, "pnorm", mean(x), sd(x)),
      "exp"  = ks.test(x, "pexp", rate = 1 / mean(x)),
      "unif" = ks.test(x, "punif", min(x), max(x))
    )

    # Shapiro-Wilk (normality only, max 5000)
    sw <- if (ref == "norm" && n <= 5000) shapiro.test(x) else NULL

    gof_data(list(x = sort(x), ref = ref, ks = ks, sw = sw, n = n))
  })

  output$gof_cdf <- renderPlotly({
    res <- gof_data()
    req(res)
    x <- res$x; n <- res$n
    ecdf_y <- seq_len(n) / n

    # Theoretical CDF
    tcdf <- switch(res$ref,
      "norm" = pnorm(x, mean(x), sd(x)),
      "exp"  = pexp(x, rate = 1 / mean(x)),
      "unif" = punif(x, min(x), max(x))
    )

    # Find max distance for annotation
    diffs <- abs(ecdf_y - tcdf)
    max_idx <- which.max(diffs)

    plotly::plot_ly() |>
      plotly::add_trace(x = x, y = ecdf_y, type = "scatter", mode = "lines",
                        line = list(color = "#238b45", width = 2),
                        name = "Empirical CDF", hoverinfo = "skip") |>
      plotly::add_trace(x = x, y = tcdf, type = "scatter", mode = "lines",
                        line = list(color = "#3182bd", width = 2, dash = "dash"),
                        name = "Theoretical CDF", hoverinfo = "skip") |>
      plotly::add_trace(
        x = rep(x[max_idx], 2), y = c(ecdf_y[max_idx], tcdf[max_idx]),
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2),
        name = paste0("D = ", round(res$ks$statistic, 4)),
        hoverinfo = "text",
        text = paste0("KS distance D = ", round(res$ks$statistic, 4))
      ) |>
      plotly::layout(
        xaxis = list(title = "Value"), yaxis = list(title = "Cumulative Probability"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$gof_table <- renderTable({
    res <- gof_data(); req(res)
    rows <- list(
      data.frame(Test = "Kolmogorov-Smirnov",
                 Statistic = round(res$ks$statistic, 4),
                 `p value` = format.pval(res$ks$p.value, digits = 4),
                 check.names = FALSE)
    )
    if (!is.null(res$sw)) {
      rows[[2]] <- data.frame(Test = "Shapiro-Wilk (normality)",
                               Statistic = round(res$sw$statistic, 4),
                               `p value` = format.pval(res$sw$p.value, digits = 4),
                               check.names = FALSE)
    }
    do.call(rbind, rows)
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load
  })
}
