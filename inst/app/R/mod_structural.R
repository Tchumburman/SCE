# Module: Structural Models (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
structural_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Structural Models",
  icon = icon("diagram-project"),
  navset_card_underline(
    nav_panel(
      "SEM",
  navset_card_underline(
    nav_panel(
      "Mediation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sem_med_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
          sliderInput(ns("sem_med_a"), "a path (X \u2192 M)", min = -1, max = 1, value = 0.5, step = 0.1),
          sliderInput(ns("sem_med_b"), "b path (M \u2192 Y)", min = -1, max = 1, value = 0.4, step = 0.1),
          sliderInput(ns("med_c"), "c' path (X \u2192 Y direct)", min = -1, max = 1, value = 0.1, step = 0.1),
          actionButton(ns("med_go"), "Simulate & analyze", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Mediation Analysis"),
          tags$p("Mediation asks: does X affect Y partly or entirely through an
                  intermediate variable M? For example, does education (X) increase
                  income (Y) through job skills (M)? The effect is decomposed into:"),
          tags$p(
            tags$b("Total effect (c):"), " the overall relationship X\u2192Y = c' + a\u00d7b.", tags$br(),
            tags$b("Direct effect (c'):"), " X\u2192Y after controlling for M.", tags$br(),
            tags$b("Indirect effect (a\u00d7b):"), " X\u2192M\u2192Y — the mediated portion."
          ),
          tags$p("If the indirect effect is significant and the direct effect shrinks (vs. total),
                  M partially mediates the relationship. If c\u2019 \u2248 0, the mediation is
                  described as \u201cfull.\u201d However, full mediation is rare in practice and
                  the terminology can be misleading \u2014 it simply means the direct path
                  is not statistically significant, which may reflect low power."),
          tags$p("The Sobel test evaluates significance of the indirect effect (a\u00d7b) using
                  a Normal approximation. However, the distribution of a product is typically
                  non-Normal (especially with small samples), so bootstrap confidence intervals
                  for the indirect effect are generally preferred. A bootstrap CI that excludes
                  zero provides evidence for mediation."),
          tags$p("A critical caveat: mediation analysis with cross-sectional data cannot
                  establish causation. The causal ordering X \u2192 M \u2192 Y must come from
                  theory or experimental design (e.g., manipulating X and measuring M before Y).
                  Omitted confounders of the M\u2192Y relationship are particularly problematic."),
          guide = tags$ol(
            tags$li("Set the a path (X\u2192M), b path (M\u2192Y), and c' path (X\u2192Y direct)."),
            tags$li("Click 'Simulate & analyze'."),
            tags$li("Path diagram: shows estimated coefficients on each arrow."),
            tags$li("Scatter panels: visualize the individual relationships."),
            tags$li("Results: a, b, c' estimates with p-values; indirect effect (a\u00d7b) with Sobel test."),
            tags$li("Try a=0.5, b=0.5, c'=0 for full mediation; try c'=0.3 for partial mediation.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Path Diagram"),
               plotOutput(ns("med_path_plot"), height = "350px")),
          card(full_screen = TRUE, card_header("Scatter Panels"),
               plotOutput(ns("med_scatter"), height = "350px"))
        ),
        card(card_header("Mediation Results"), uiOutput(ns("med_result")))
      )
    ),
    nav_panel(
      "Moderation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mod_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
          sliderInput(ns("mod_b1"), "Main effect of X", min = -1, max = 1, value = 0.5, step = 0.1),
          sliderInput(ns("mod_b2"), "Main effect of W", min = -1, max = 1, value = 0.3, step = 0.1),
          sliderInput(ns("mod_b3"), "Interaction X\u00d7W", min = -1, max = 1, value = 0.4, step = 0.1),
          actionButton(ns("mod_go"), "Simulate & analyze", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Moderation Analysis"),
          tags$p("Moderation asks: does the effect of X on Y change depending on
                  the level of another variable W? For example, does the effect of
                  study hours (X) on grades (Y) depend on motivation (W)? This is
                  modeled with an interaction term: Y = b\u2081X + b\u2082W + b\u2083(X\u00d7W)."),
          tags$p("The simple slopes plot shows the X\u2192Y relationship at low (\u22121 SD),
                  mean, and high (+1 SD) levels of W. Diverging or converging slopes indicate
                  moderation. The contour plot shows the full predicted surface."),
          tags$p("The interaction coefficient b\u2083 is the key parameter: it indicates how
                  much the slope of X on Y changes per unit increase in W. When b\u2083 is
                  significant, the effect of X depends on W (and vice versa \u2014 the
                  interaction is symmetric). When both X and W are continuous, centering
                  them (subtracting the mean) reduces multicollinearity and makes the main
                  effects more interpretable."),
          tags$p("Moderation and mediation address fundamentally different questions.
                  Moderation asks ", tags$em("when"), " or ", tags$em("for whom"), " an effect occurs;
                  mediation asks ", tags$em("how"), " or ", tags$em("through what mechanism"),
                  ". They can be combined in moderated mediation or mediated moderation designs."),
          guide = tags$ol(
            tags$li("Set the main effects of X and W, and the interaction strength (X\u00d7W)."),
            tags$li("Click 'Simulate & analyze'."),
            tags$li("Left: simple slopes plot — if lines are not parallel, there's moderation."),
            tags$li("Right: contour plot of predicted Y across X and W values."),
            tags$li("Check the interaction p-value in the results."),
            tags$li("Try interaction = 0 — the simple slopes will be parallel (no moderation).")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Interaction Plot (Simple Slopes)"),
               plotOutput(ns("mod_plot"), height = "380px")),
          card(full_screen = TRUE, card_header("3D Surface"),
               plotOutput(ns("mod_surface"), height = "380px"))
        ),
        card(full_screen = TRUE, card_header("Path Diagram"),
             plotOutput(ns("mod_path_diagram"), height = "280px")),
        card(card_header("Moderation Results"), uiOutput(ns("mod_result")))
      )
    ),
    nav_panel(
      "Path Model / SEM",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("sem_n"), "Sample size", min = 100, max = 2000, value = 500, step = 100),
          sliderInput(ns("sem_nfac"), "Number of factors", min = 2, max = 4, value = 2, step = 1),
          sliderInput(ns("sem_nind"), "Indicators per factor", min = 2, max = 5, value = 3, step = 1),
          sliderInput(ns("sem_path"), "Path coefficient (each link)", min = -1, max = 1,
                      value = 0.5, step = 0.1),
          actionButton(ns("sem_go"), "Simulate & fit", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Structural Equation Modeling"),
          tags$p("SEM combines two components: a measurement model (how latent factors
                  relate to observed indicators, like factor analysis) and a structural
                  model (how latent factors relate to each other, like path analysis).
                  This allows testing complex theories about unobserved constructs."),
          tags$p("Fit indices evaluate whether the model-implied covariance matrix
                  matches the observed data. Common guidelines: CFI/TLI > 0.95, RMSEA < 0.06,
                  SRMR < 0.08 \u2014 though these are rules of thumb, not absolute thresholds.
                  The path diagram shows factor loadings and the structural regression
                  coefficient between latent variables."),
          tags$p("SEM requires careful specification: the model must be identified (enough
                  constraints to estimate all parameters), which typically requires at least
                  3 indicators per latent factor. Modification indices can suggest model
                  improvements, but data-driven modifications risk capitalising on sample-specific
                  idiosyncrasies \u2014 any post-hoc modifications should be cross-validated."),
          tags$p("SEM assumes multivariate normality and typically requires moderately large
                  samples (n > 200 as a common guideline, though requirements increase with
                  model complexity). Maximum likelihood is the default estimator; robust variants
                  (MLR) adjust standard errors and fit indices when normality is violated."),
          guide = tags$ol(
            tags$li("Set sample size, number of factors, and indicators per factor."),
            tags$li("Adjust the structural path coefficient (chain: F1\u2192F2\u2192\u2026)."),
            tags$li("Click 'Simulate & fit' \u2014 this uses the lavaan package."),
            tags$li("The path diagram shows: circles = latent factors, boxes = observed indicators, numbers = estimated loadings/paths."),
            tags$li("Check the fit indices below the diagram."),
            tags$li("Try a strong path (0.8) vs. weak (0.1) to see how the estimate changes.")
          )
        ),
        card(full_screen = TRUE, card_header("Path Diagram & Estimates"),
             plotOutput(ns("sem_path_plot"), height = "450px")),
        card(card_header("Fit Indices"), uiOutput(ns("sem_fit")))
      )
    )
  )
    ),

    nav_panel(
      "Network Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("net_nodes"), "Number of nodes", min = 10, max = 50,
                  value = 20, step = 5),
      sliderInput(ns("net_prob"), "Edge probability", min = 0.05, max = 0.5,
                  value = 0.15, step = 0.05),
      selectInput(ns("net_layout"), "Layout",
        choices = c("Force-directed" = "fr",
                    "Circle" = "circle",
                    "Random" = "random"),
        selected = "fr"
      ),
      actionButton(ns("net_go"), "Generate", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Network Analysis"),
      tags$p("Network analysis studies relationships (edges) between entities (nodes).
              Centrality measures identify the most important nodes."),
      tags$ul(
        tags$li(tags$strong("Degree centrality:"), " Number of connections (edges). Identifies highly
                connected nodes \u2014 hubs in the network."),
        tags$li(tags$strong("Betweenness centrality:"), " How often a node lies on the shortest path
                between other pairs of nodes. High-betweenness nodes are bridges that connect
                different parts of the network."),
        tags$li(tags$strong("Closeness centrality:"), " Average inverse distance to all other nodes.
                High-closeness nodes can reach all others quickly."),
        tags$li(tags$strong("Clustering coefficient:"), " Proportion of a node\u2019s neighbours that
                are also connected to each other. Measures local cohesion or \u201ccliquishness.\u201d")
      ),
      tags$p("In psychology, network analysis has become popular for modelling symptom networks,
              where nodes are symptoms and edges represent conditional associations (partial
              correlations). Central symptoms are hypothesised to play a key role in maintaining
              disorders. However, network structure can be unstable with small samples, so
              bootstrap stability analyses are essential for reliable interpretation."),
      tags$p("Network visualisation choices (layout algorithm, edge thickness, node size) can
              strongly influence how a network is perceived. Force-directed layouts (e.g.,
              Fruchterman-Reingold) place connected nodes closer together, making cluster
              structure visually apparent. Mapping centrality to node size helps identify
              important nodes at a glance. However, visual impressions should always be
              confirmed with formal centrality statistics."),
      tags$p("Beyond psychology, network analysis is widely used in social network analysis,
              epidemiology (disease transmission networks), neuroscience (brain connectivity),
              and organisational research. The mathematical foundations from graph theory
              provide a rigorous framework for quantifying network structure and dynamics."),
      guide = tags$ol(
        tags$li("Set the number of nodes and edge probability (Erd\u0151s-R\u00e9nyi model)."),
        tags$li("Click 'Generate' to create a random network."),
        tags$li("Node size reflects degree; color reflects betweenness centrality."),
        tags$li("Examine the centrality table to find the most important nodes.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Network Graph"),
           plotlyOutput(ns("net_graph"), height = "450px")),
      card(card_header("Centrality Measures (top 10)"), tableOutput(ns("net_centrality"))),
      card(card_header("Network Summary"), tableOutput(ns("net_summary")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

structural_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  is_dark <- reactive({ isTRUE(session$userData$dark_mode) })

  # -- Mediation --
  med_data <- reactiveVal(NULL)
  
  observeEvent(input$med_go, {
    withProgress(message = "Fitting mediation model...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$sem_med_n
    a <- input$sem_med_a; b <- input$sem_med_b; cp <- input$med_c
    X <- rnorm(n)
    M <- a * X + rnorm(n, 0, sqrt(1 - a^2))
    Y <- cp * X + b * M + rnorm(n, 0, 0.5)
    med_data(list(X = X, M = M, Y = Y, a = a, b = b, cp = cp))
    })
  })
  
  output$med_path_plot <- renderPlot(bg = "transparent", {
    res <- med_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    fg_col <- if (dark) "#839496" else "#657b83"
    box_fill <- if (dark) "#073642" else "#eee8d5"
    path_col <- if (dark) "#2aa198" else "#268bd2"
    sub_col <- if (dark) "#586e75" else "#93a1a1"

    fit_m <- lm(M ~ X, data = data.frame(X = res$X, M = res$M))
    fit_y <- lm(Y ~ X + M, data = data.frame(X = res$X, M = res$M, Y = res$Y))
    a_hat <- coef(fit_m)["X"]
    b_hat <- coef(fit_y)["M"]
    cp_hat <- coef(fit_y)["X"]
    indirect <- a_hat * b_hat
    total <- cp_hat + indirect

    par(mar = c(2, 2, 3, 2), bg = bg_col)
    plot.new()
    plot.window(xlim = c(0, 10), ylim = c(0, 8))
    title("Mediation Path Diagram", cex.main = 1.3, col.main = fg_col)

    rect(0.5, 3, 2.5, 5, col = box_fill, border = fg_col, lwd = 2)
    text(1.5, 4, "X", cex = 1.5, font = 2, col = fg_col)
    rect(7.5, 3, 9.5, 5, col = box_fill, border = fg_col, lwd = 2)
    text(8.5, 4, "Y", cex = 1.5, font = 2, col = fg_col)
    rect(4, 6, 6, 8, col = box_fill, border = fg_col, lwd = 2)
    text(5, 7, "M", cex = 1.5, font = 2, col = fg_col)

    arrows(2.5, 4.5, 4, 6.5, lwd = 2, col = path_col)
    text(2.8, 5.8, paste0("a = ", round(a_hat, 2)), col = path_col, cex = 1.1)
    arrows(6, 6.5, 7.5, 4.5, lwd = 2, col = path_col)
    text(7.2, 5.8, paste0("b = ", round(b_hat, 2)), col = path_col, cex = 1.1)
    arrows(2.5, 3.5, 7.5, 3.5, lwd = 2, col = "#e31a1c")
    text(5, 2.5, paste0("c' = ", round(cp_hat, 2)), col = "#e31a1c", cex = 1.1)

    text(5, 1, paste0("Indirect: a\u00d7b = ", round(indirect, 3),
                       "   |   Direct: c' = ", round(cp_hat, 3),
                       "   |   Total: ", round(total, 3)),
         cex = 0.9, col = sub_col)
  })
  
  output$med_scatter <- renderPlot(bg = "transparent", {
    res <- med_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    pt_col <- if (dark) "#2aa198" else "#073642"
    line_col <- if (dark) "#2aa198" else "#268bd2"
    text_col <- if (dark) "#93a1a1" else "#073642"
    grid_col <- if (dark) "grey30" else "grey90"

    dark_theme <- theme_minimal(base_size = 12) +
      theme(plot.background = element_rect(fill = bg_col, color = NA),
            panel.background = element_rect(fill = bg_col, color = NA),
            text = element_text(color = text_col),
            axis.text = element_text(color = text_col),
            panel.grid = element_line(color = grid_col))

    df <- data.frame(X = res$X, M = res$M, Y = res$Y)
    p1 <- ggplot(df, aes(X, M)) +
      geom_point(alpha = 0.3, color = pt_col, size = 1.5) +
      geom_smooth(method = "lm", se = FALSE, color = line_col, linewidth = 1) +
      labs(title = "X \u2192 M") + dark_theme
    p2 <- ggplot(df, aes(M, Y)) +
      geom_point(alpha = 0.3, color = pt_col, size = 1.5) +
      geom_smooth(method = "lm", se = FALSE, color = line_col, linewidth = 1) +
      labs(title = "M \u2192 Y") + dark_theme

    gridExtra::grid.arrange(p1, p2, ncol = 2)
  })
  
  output$med_result <- renderUI({
    res <- med_data()
    req(res)
    df <- data.frame(X = res$X, M = res$M, Y = res$Y)
  
    # Use lavaan for mediation with bootstrapped indirect effect
    med_out <- tryCatch({
      model <- "
        M ~ a*X
        Y ~ cp*X + b*M
        indirect := a*b
        total    := cp + a*b
      "
      fit <- lavaan::sem(model, data = df, se = "bootstrap", bootstrap = 200)
      pe <- lavaan::parameterEstimates(fit, boot.ci.type = "perc")
      list(success = TRUE, pe = pe)
    }, error = function(e) {
      # Fallback to Sobel test if lavaan fails
      fit_m <- lm(M ~ X, data = df)
      fit_y <- lm(Y ~ X + M, data = df)
      a_hat <- coef(fit_m)["X"]; b_hat <- coef(fit_y)["M"]
      cp_hat <- coef(fit_y)["X"]; indirect <- a_hat * b_hat
      se_a <- summary(fit_m)$coefficients["X", "Std. Error"]
      se_b <- summary(fit_y)$coefficients["M", "Std. Error"]
      se_sobel <- sqrt(a_hat^2 * se_b^2 + b_hat^2 * se_a^2)
      z_sobel <- indirect / se_sobel
      p_sobel <- 2 * pnorm(-abs(z_sobel))
      list(success = FALSE, a = a_hat, b = b_hat, cp = cp_hat,
           indirect = indirect, z = z_sobel, p = p_sobel)
    })
  
    if (med_out$success) {
      pe <- med_out$pe
      a_row  <- pe[pe$label == "a", ]
      b_row  <- pe[pe$label == "b", ]
      cp_row <- pe[pe$label == "cp", ]
      ind_row <- pe[pe$label == "indirect", ]
      tot_row <- pe[pe$label == "total", ]
  
      div(
        style = "padding: 10px; font-size: 0.95rem;",
        tags$p(tags$strong("Method: "), "lavaan SEM with bootstrap CI (200 resamples)"),
        tags$hr(),
        tags$p(tags$strong("a path (X\u2192M): "), round(a_row$est, 3),
               " [", round(a_row$ci.lower, 3), ", ", round(a_row$ci.upper, 3), "]",
               " (p = ", format.pval(a_row$pvalue, 4), ")"),
        tags$p(tags$strong("b path (M\u2192Y|X): "), round(b_row$est, 3),
               " [", round(b_row$ci.lower, 3), ", ", round(b_row$ci.upper, 3), "]",
               " (p = ", format.pval(b_row$pvalue, 4), ")"),
        tags$p(tags$strong("c' direct (X\u2192Y|M): "), round(cp_row$est, 3),
               " [", round(cp_row$ci.lower, 3), ", ", round(cp_row$ci.upper, 3), "]",
               " (p = ", format.pval(cp_row$pvalue, 4), ")"),
        tags$hr(),
        tags$p(tags$strong("Indirect (a\u00d7b): "), round(ind_row$est, 3),
               "  95% bootstrap CI: [", round(ind_row$ci.lower, 3), ", ",
               round(ind_row$ci.upper, 3), "]"),
        tags$p(tags$strong("Total effect: "), round(tot_row$est, 3)),
        if (ind_row$ci.lower > 0 || ind_row$ci.upper < 0)
          tags$p(style = "color: #238b45; font-weight: bold;",
                 "\u2713 Significant mediation (CI excludes 0)")
        else
          tags$p(style = "color: #e31a1c; font-weight: bold;",
                 "\u2717 Mediation not significant (CI includes 0)")
      )
    } else {
      div(
        style = "padding: 10px; font-size: 0.95rem;",
        tags$p(tags$strong("Method: "), "Sobel test (lavaan unavailable)"),
        tags$hr(),
        tags$p(tags$strong("a path: "), round(med_out$a, 3)),
        tags$p(tags$strong("b path: "), round(med_out$b, 3)),
        tags$p(tags$strong("c' direct: "), round(med_out$cp, 3)),
        tags$hr(),
        tags$p(tags$strong("Indirect (a\u00d7b): "), round(med_out$indirect, 3)),
        tags$p(tags$strong("Sobel z = "), round(med_out$z, 3),
               ", p = ", format.pval(med_out$p, 4)),
        if (med_out$p < 0.05)
          tags$p(style = "color: #238b45; font-weight: bold;",
                 "\u2713 Significant mediation")
        else
          tags$p(style = "color: #e31a1c; font-weight: bold;",
                 "\u2717 Mediation not significant")
      )
    }
  })
  
  # -- Moderation --
  mod_data <- reactiveVal(NULL)
  
  observeEvent(input$mod_go, {
    withProgress(message = "Fitting moderation model...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$mod_n
    X <- rnorm(n)
    W <- rnorm(n)
    Y <- input$mod_b1 * X + input$mod_b2 * W + input$mod_b3 * X * W + rnorm(n, 0, 0.5)
    mod_data(list(X = X, W = W, Y = Y))
    })
  })
  
  output$mod_plot <- renderPlot(bg = "transparent", {
    res <- mod_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    pt_col <- if (dark) "#2aa198" else "#073642"
    text_col <- if (dark) "#93a1a1" else "#073642"
    grid_col <- if (dark) "grey30" else "grey90"

    df <- data.frame(X = res$X, W = res$W, Y = res$Y)
    fit <- lm(Y ~ X * W, data = df)

    w_vals <- c(mean(df$W) - sd(df$W), mean(df$W), mean(df$W) + sd(df$W))
    w_labels <- c("W = -1 SD", "W = Mean", "W = +1 SD")
    x_seq <- seq(min(df$X), max(df$X), length.out = 100)

    slopes_df <- do.call(rbind, lapply(seq_along(w_vals), function(i) {
      y_pred <- coef(fit)[1] + coef(fit)[2] * x_seq +
        coef(fit)[3] * w_vals[i] + coef(fit)[4] * x_seq * w_vals[i]
      data.frame(X = x_seq, Y = y_pred, W_level = w_labels[i])
    }))
    slopes_df$W_level <- factor(slopes_df$W_level, levels = w_labels)

    ggplot(df, aes(X, Y)) +
      geom_point(alpha = 0.2, color = pt_col, size = 1.5) +
      geom_line(data = slopes_df, aes(X, Y, color = W_level), linewidth = 1.2) +
      scale_color_manual(values = c("#e31a1c", "#238b45", "#006d2c")) +
      labs(color = "Moderator Level",
           subtitle = paste0("Interaction: \u03b2 = ", round(coef(fit)[4], 3))) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top",
            plot.background = element_rect(fill = bg_col, color = NA),
            panel.background = element_rect(fill = bg_col, color = NA),
            text = element_text(color = text_col),
            axis.text = element_text(color = text_col),
            panel.grid = element_line(color = grid_col),
            legend.background = element_rect(fill = bg_col, color = NA))
  })
  
  output$mod_surface <- renderPlot(bg = "transparent", {
    res <- mod_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    text_col <- if (dark) "#93a1a1" else "#073642"
    grid_col <- if (dark) "grey30" else "grey90"

    df <- data.frame(X = res$X, W = res$W, Y = res$Y)
    fit <- lm(Y ~ X * W, data = df)
    grid <- expand.grid(
      X = seq(min(df$X), max(df$X), length.out = 80),
      W = seq(min(df$W), max(df$W), length.out = 80)
    )
    grid$Y <- predict(fit, grid)

    ggplot(grid, aes(X, W, z = Y)) +
      geom_contour_filled(bins = 12) +
      scale_fill_viridis_d(option = "G") +
      labs(x = "X", y = "W (Moderator)", fill = "Predicted Y",
           subtitle = "Contour: predicted Y across X and W") +
      theme_minimal(base_size = 14) +
      theme(plot.background = element_rect(fill = bg_col, color = NA),
            panel.background = element_rect(fill = bg_col, color = NA),
            text = element_text(color = text_col),
            axis.text = element_text(color = text_col),
            panel.grid = element_line(color = grid_col),
            legend.background = element_rect(fill = bg_col, color = NA))
  })
  
  output$mod_path_diagram <- renderPlot(bg = "transparent", {
    res <- mod_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    fg_col <- if (dark) "#839496" else "#657b83"
    box_fill <- if (dark) "#073642" else "#eee8d5"
    box_fill2 <- if (dark) "#073642" else "#eee8d5"
    path_col <- if (dark) "#2aa198" else "#268bd2"
    path_col2 <- if (dark) "#2aa198" else "#2aa198"
    sub_col <- if (dark) "#586e75" else "#93a1a1"

    df <- data.frame(X = res$X, W = res$W, Y = res$Y)
    fit <- lm(Y ~ X * W, data = df)
    cc <- coef(fit)
    b1 <- round(cc["X"], 2); b2 <- round(cc["W"], 2); b3 <- round(cc["X:W"], 2)

    par(mar = c(1, 1, 2, 1), bg = bg_col)
    plot.new()
    plot.window(xlim = c(0, 10), ylim = c(0, 6))
    title("Moderation Path Diagram", cex.main = 1.2, col.main = fg_col)

    rect(0.5, 2, 2.5, 3.5, col = box_fill, border = fg_col, lwd = 2)
    text(1.5, 2.75, "X", cex = 1.3, font = 2, col = fg_col)
    rect(7.5, 2, 9.5, 3.5, col = box_fill, border = fg_col, lwd = 2)
    text(8.5, 2.75, "Y", cex = 1.3, font = 2, col = fg_col)
    rect(3.5, 4.5, 5.5, 5.8, col = box_fill2, border = fg_col, lwd = 2)
    text(4.5, 5.15, "W", cex = 1.3, font = 2, col = fg_col)

    arrows(2.5, 2.75, 7.5, 2.75, lwd = 2.5, col = path_col, length = 0.12)
    text(5, 2.35, paste0("b1 = ", b1), cex = 1, col = path_col, font = 2)
    arrows(5.5, 5, 7.5, 3.5, lwd = 2, col = path_col2, length = 0.12)
    text(7, 4.5, paste0("b2 = ", b2), cex = 0.9, col = path_col2, font = 2)
    arrows(4.5, 4.5, 5, 3.1, lwd = 2, col = "#e31a1c", lty = 2, length = 0.1)
    text(3.7, 3.7, paste0("b3 = ", b3), cex = 1, col = "#e31a1c", font = 2)
    text(5.1, 3.3, expression("" %*% ""), cex = 1.5, col = "#e31a1c")
    text(5, 0.5, "Dashed red = interaction (moderation) effect", cex = 0.8, col = sub_col)
  })
  
  output$mod_result <- renderUI({
    res <- mod_data()
    req(res)
    df <- data.frame(X = res$X, W = res$W, Y = res$Y)
    fit <- lm(Y ~ X * W, data = df)
    s <- summary(fit)$coefficients
  
    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$p(tags$strong("Main effect X: "), "b = ", round(s["X", 1], 3),
             ", p = ", format.pval(s["X", 4], 4)),
      tags$p(tags$strong("Main effect W: "), "b = ", round(s["W", 1], 3),
             ", p = ", format.pval(s["W", 4], 4)),
      tags$p(tags$strong("Interaction X\u00d7W: "), "b = ", round(s["X:W", 1], 3),
             ", p = ", format.pval(s["X:W", 4], 4)),
      tags$p(tags$strong("R\u00b2 = "), round(summary(fit)$r.squared, 3)),
      if (s["X:W", 4] < 0.05)
        tags$p(style = "color: #238b45; font-weight: bold;",
               "\u2713 Significant interaction — the effect of X on Y depends on W")
      else
        tags$p(style = "color: #e31a1c; font-weight: bold;",
               "\u2717 No significant interaction")
    )
  })
  
  # -- SEM / Path Model --
  sem_data <- reactiveVal(NULL)
  
  observeEvent(input$sem_go, {
    withProgress(message = "Fitting structural equation model...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$sem_n
    nf <- input$sem_nfac
    ni <- input$sem_nind %||% 3
    path_coef <- input$sem_path
    base_loadings <- c(0.8, 0.7, 0.65, 0.6, 0.55)[seq_len(ni)]
  
    # Generate chain of factors: F1 -> F2 -> F3 -> ...
    Fs <- list()
    Fs[[1]] <- rnorm(n)
    for (f in 2:nf) {
      resid_sd <- sqrt(max(1 - path_coef^2, 0.01))
      Fs[[f]] <- path_coef * Fs[[f - 1]] + rnorm(n, 0, resid_sd)
    }
  
    # Indicators (ni per factor)
    dat <- data.frame(matrix(0, n, ni * nf))
    fac_names <- paste0("F", seq_len(nf))
    ind_names <- character(0)
    for (f in seq_len(nf)) {
      for (j in seq_len(ni)) {
        vname <- paste0("f", f, "v", j)
        ind_names <- c(ind_names, vname)
        dat[, (f - 1) * ni + j] <- base_loadings[j] * Fs[[f]] +
          rnorm(n, 0, sqrt(1 - base_loadings[j]^2))
      }
    }
    names(dat) <- ind_names
  
    # Build lavaan syntax
    meas_lines <- vapply(seq_len(nf), function(f) {
      items <- paste0("f", f, "v", seq_len(ni))
      paste0("F", f, " =~ ", paste(items, collapse = " + "))
    }, character(1))
    struct_lines <- vapply(2:nf, function(f) {
      paste0("F", f, " ~ F", f - 1)
    }, character(1))
    model <- paste(c(meas_lines, struct_lines), collapse = "\n")
  
    fit_info <- tryCatch({
      fit <- lavaan::sem(model, data = dat)
      ests <- lavaan::parameterEstimates(fit)
      fit_m <- lavaan::fitmeasures(fit, c("cfi", "tli", "rmsea", "srmr", "chisq", "df", "pvalue"))
      list(estimates = ests, fit_measures = fit_m, success = TRUE)
    }, error = function(e) {
      list(success = FALSE, msg = e$message)
    })
  
    sem_data(list(data = dat, fit_info = fit_info, true_path = path_coef, nfac = nf, nind = ni))
    })
  })
  
  output$sem_path_plot <- renderPlot(bg = "transparent", {
    res <- sem_data()
    req(res)
    dark <- is_dark()
    bg_col <- "transparent"
    fg_col <- if (dark) "#839496" else "#657b83"
    box_fill <- if (dark) "#073642" else "#eee8d5"
    ind_fill <- if (dark) "#002b36" else "#fdf6e3"
    ind_border <- if (dark) "#2aa198" else "#073642"
    path_col <- if (dark) "#2aa198" else "#268bd2"
    load_col <- if (dark) "#2aa198" else "#2aa198"

    nf <- res$nfac
    ni <- res$nind %||% 3
    ests <- if (res$fit_info$success) res$fit_info$estimates else NULL

    par(mar = c(1, 1, 2, 1), bg = bg_col)
    plot.new()
    x_max <- max(ni, 3) * nf + 2
    plot.window(xlim = c(0, x_max), ylim = c(0, 10))
    title("SEM Path Diagram", cex.main = 1.3, col.main = fg_col)

    fac_x <- seq(2.5, x_max - 2.5, length.out = nf)
    fac_y <- 5

    for (f in seq_len(nf)) {
      symbols(fac_x[f], fac_y, circles = 0.6, add = TRUE, inches = FALSE,
              bg = box_fill, fg = fg_col, lwd = 2)
      text(fac_x[f], fac_y, paste0("F", f), cex = 1.1, font = 2, col = fg_col)
    }

    for (f in 2:nf) {
      x_from <- fac_x[f - 1] + 0.7
      x_to <- fac_x[f] - 0.7
      arrows(x_from, fac_y, x_to, fac_y, lwd = 3, col = path_col, length = 0.1)
      lbl <- paste0("true=", res$true_path)
      if (!is.null(ests)) {
        pe <- ests$est[ests$lhs == paste0("F", f) & ests$op == "~" &
                         ests$rhs == paste0("F", f - 1)]
        if (length(pe) > 0) lbl <- paste0("\u03b2=", round(pe, 2))
      }
      text((x_from + x_to) / 2, fac_y + 0.6, lbl, cex = 0.9, col = path_col, font = 2)
    }

    ind_top <- 9.5; ind_bot <- fac_y + 1.5; box_h <- 0.7
    ind_spacing <- if (ni == 1) 0 else (ind_top - ind_bot - box_h) / (ni - 1)
    for (f in seq_len(nf)) {
      for (j in seq_len(ni)) {
        y_center <- ind_top - box_h / 2 - (j - 1) * ind_spacing
        bx <- fac_x[f]
        rect(bx - 0.45, y_center - box_h / 2, bx + 0.45, y_center + box_h / 2,
             col = ind_fill, border = ind_border, lwd = 1.2)
        text(bx, y_center, paste0("f", f, "v", j), cex = 0.7, col = ind_border)
        arrows(bx, y_center - box_h / 2, bx, fac_y + 0.65,
               lwd = 1.2, col = load_col, length = 0.08)
        if (!is.null(ests)) {
          vname <- paste0("f", f, "v", j)
          ld <- ests$est[ests$lhs == paste0("F", f) & ests$op == "=~" & ests$rhs == vname]
          if (length(ld) > 0)
            text(bx + 0.5, (y_center - box_h / 2 + fac_y + 0.65) / 2, round(ld, 2),
                 cex = 0.7, col = load_col)
        }
      }
    }
  })

  output$sem_fit <- renderUI({
    res <- sem_data()
    req(res)
    fi <- res$fit_info

    if (!fi$success) {
      return(div(
        style = "padding: 10px;",
        tags$p(style = "color: #e31a1c;",
               "lavaan package required for SEM fitting. Install with:"),
        tags$code("install.packages('lavaan')")
      ))
    }

    fm <- fi$fit_measures
    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$p(tags$strong("\u03c7\u00b2 = "), round(fm["chisq"], 2),
             tags$strong("  df = "), fm["df"],
             tags$strong("  p = "), format.pval(fm["pvalue"], 4)),
      tags$p(tags$strong("CFI = "), round(fm["cfi"], 3),
             tags$strong("  TLI = "), round(fm["tli"], 3)),
      tags$p(tags$strong("RMSEA = "), round(fm["rmsea"], 3),
             tags$strong("  SRMR = "), round(fm["srmr"], 3)),
      tags$hr(),
      tags$p(class = "text-muted",
             "Good fit: CFI/TLI > 0.95, RMSEA < 0.06, SRMR < 0.08")
    )
  })

  net_data <- reactiveVal(NULL)

  observeEvent(input$net_go, {
    withProgress(message = "Computing network analysis...", value = 0.1, {
    n <- input$net_nodes; p <- input$net_prob; layout <- input$net_layout
    set.seed(sample.int(10000, 1))

    g <- igraph::erdos.renyi.game(n, p, type = "gnp")

    # Layout
    coords <- switch(layout,
      "fr"     = igraph::layout_with_fr(g),
      "circle" = igraph::layout_in_circle(g),
      "random" = igraph::layout_randomly(g)
    )

    deg <- igraph::degree(g)
    betw <- igraph::betweenness(g)
    close <- igraph::closeness(g)

    # Edges
    el <- igraph::as_edgelist(g)

    net_data(list(g = g, coords = coords, deg = deg, betw = betw,
                  close = close, el = el, n = n))
    })
  })

  output$net_graph <- renderPlotly({
    res <- net_data()
    req(res)
    coords <- res$coords; el <- res$el

    # Draw edges
    edge_x <- c(); edge_y <- c()
    for (i in seq_len(nrow(el))) {
      edge_x <- c(edge_x, coords[el[i, 1], 1], coords[el[i, 2], 1], NA)
      edge_y <- c(edge_y, coords[el[i, 1], 2], coords[el[i, 2], 2], NA)
    }

    # Normalize betweenness for color
    bscaled <- if (max(res$betw) > 0) res$betw / max(res$betw) else rep(0, res$n)

    plotly::plot_ly() |>
      plotly::add_trace(
        x = edge_x, y = edge_y,
        type = "scatter", mode = "lines",
        line = list(color = "rgba(150,150,150,0.3)", width = 1),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = coords[, 1], y = coords[, 2],
        marker = list(
          size = pmax(res$deg * 2 + 5, 5),
          color = bscaled, colorscale = list(
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
          showscale = TRUE, colorbar = list(title = "Betweenness"),
          line = list(color = "#00441b", width = 1)
        ),
        hoverinfo = "text", showlegend = FALSE,
        text = paste0("Node ", seq_len(res$n),
                       "<br>Degree: ", res$deg,
                       "<br>Betweenness: ", round(res$betw, 1),
                       "<br>Closeness: ", round(res$close, 4))
      ) |>
      plotly::layout(
        xaxis = list(visible = FALSE), yaxis = list(visible = FALSE),
        margin = list(t = 20, b = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$net_centrality <- renderTable({
    res <- net_data(); req(res)
    df <- data.frame(
      Node = seq_len(res$n), Degree = res$deg,
      Betweenness = round(res$betw, 1),
      Closeness = round(res$close, 4)
    )
    df <- df[order(-df$Degree), ]
    head(df, 10)
  }, striped = TRUE, hover = TRUE, width = "100%", rownames = FALSE)

  output$net_summary <- renderTable({
    res <- net_data(); req(res)
    g <- res$g
    data.frame(
      Metric = c("Nodes", "Edges", "Density", "Avg degree",
                  "Avg path length", "Transitivity (global)"),
      Value = c(igraph::vcount(g), igraph::ecount(g),
                round(igraph::edge_density(g), 4),
                round(mean(res$deg), 2),
                round(igraph::mean_distance(g, directed = FALSE), 3),
                round(igraph::transitivity(g, type = "global"), 4))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Structural Models", list(med_data, mod_data, sem_data, net_data))
  })
}
