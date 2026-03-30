# ===========================================================================
# Module: Experimental Design
# ===========================================================================

# ── UI ──────────────────────────────────────────────────────────────────
experimental_design_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Experimental Design",
  icon = icon("flask"),
  navset_card_underline(

    # ── Tab 1: Randomization ────────────────────────────────────────────
    nav_panel(
      "Randomization",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("rand_n"), "Total participants", min = 10, max = 200, value = 40, step = 2),
          selectInput(ns("rand_method"), "Randomization method",
            choices = c("Simple random", "Stratified (by gender)",
                        "Block randomization (block size 4)",
                        "Minimization (adaptive)")),
          sliderInput(ns("rand_gender_ratio"), "% Female in population", min = 20, max = 80, value = 50),
          sliderInput(ns("rand_age_diff"), "Age confound (mean diff)", min = 0, max = 10, value = 3, step = 0.5),
          numericInput(ns("rand_reps"), "Repetitions (for balance check)", value = 500, min = 100, max = 5000),
          actionButton(ns("rand_go"), "Randomize", class = "btn-success w-100 mb-2"),
          actionButton(ns("rand_sim"), "Simulate balance", class = "btn-outline-success w-100")
        ),
        explanation_box(
          tags$strong("Random Assignment"),
          tags$p("Random assignment is the foundation of causal inference in experiments.
                  By randomly assigning participants to treatment and control conditions,
                  we ensure that \u2014 on average \u2014 the groups are equivalent on all
                  characteristics, both measured and unmeasured."),
          tags$p(
            tags$strong("Simple random:"), " Each participant independently flipped to treatment
              or control with equal probability. Simple but can produce imbalanced groups,
              especially with small n.", tags$br(),
            tags$strong("Stratified:"), " First stratify by an important covariate (e.g., gender),
              then randomize within strata. Guarantees balance on that covariate.", tags$br(),
            tags$strong("Block:"), " Randomize in blocks of fixed size (e.g., 4). Within each block,
              exactly half are assigned to each condition. Ensures even group sizes.", tags$br(),
            tags$strong("Minimization:"), " Adaptive method that assigns each new participant
              to the group that minimizes overall imbalance. Used in clinical trials."
          ),
          tags$p("The simulation mode repeats the randomization many times and shows how well
                  each method achieves covariate balance. Better methods produce narrower
                  distributions of between-group differences."),
          guide = tags$ol(
            tags$li("Set the number of participants and choose a randomization method."),
            tags$li("Click 'Randomize' to see a single assignment with covariate balance."),
            tags$li("Click 'Simulate balance' to repeat many times and compare distributions."),
            tags$li("Try different methods to see which achieves better balance on covariates.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Assignment & Covariates"),
               plotly::plotlyOutput(ns("rand_assign_plot"), height = "400px")),
          card(full_screen = TRUE, card_header("Balance Distribution (Simulation)"),
               plotly::plotlyOutput(ns("rand_balance_plot"), height = "400px"))
        ),
        card(card_header("Covariate Balance Summary"),
             tableOutput(ns("rand_balance_table")))
      )
    ),

    # ── Tab 2: Factorial Designs ────────────────────────────────────────
    nav_panel(
      "Factorial Designs",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$h6("Factor A (e.g., Drug)"),
          sliderInput(ns("fact_a_levels"), "Levels", min = 2, max = 4, value = 2),
          sliderInput(ns("fact_a_effect"), "Main effect A", min = 0, max = 5, value = 2, step = 0.25),
          tags$h6("Factor B (e.g., Dose)"),
          sliderInput(ns("fact_b_levels"), "Levels", min = 2, max = 4, value = 2),
          sliderInput(ns("fact_b_effect"), "Main effect B", min = 0, max = 5, value = 1, step = 0.25),
          tags$hr(),
          sliderInput(ns("fact_interaction"), "Interaction strength", min = -3, max = 3, value = 0, step = 0.25),
          sliderInput(ns("fact_n_cell"), "n per cell", min = 5, max = 100, value = 20, step = 5),
          sliderInput(ns("fact_sigma"), "Error SD (\u03c3)", min = 0.5, max = 5, value = 2, step = 0.25),
          actionButton(ns("fact_go"), "Generate & Analyze", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Factorial Designs"),
          tags$p("A factorial design crosses every level of one factor with every level of
                  another, allowing you to study main effects and interactions simultaneously.
                  A 2\u00d72 design has four cells; a 3\u00d72 has six. The key advantage over
                  one-factor-at-a-time experiments is efficiency \u2014 every observation
                  contributes to estimating every effect."),
          tags$p("The ", tags$strong("interaction"), " is the most interesting part of a factorial
                  design. An interaction means the effect of one factor depends on the level
                  of the other. Non-parallel lines in an interaction plot signal an interaction.
                  When lines cross, it is a ", tags$em("crossover interaction"), " \u2014 the direction
                  of the effect reverses. When lines diverge but don't cross, it is an
                  ", tags$em("ordinal interaction"), "."),
          tags$p("Without a factorial design, interactions are invisible. Running two separate
                  experiments (one for each factor) would miss the interaction entirely, potentially
                  leading to incorrect conclusions about both factors."),
          guide = tags$ol(
            tags$li("Set the number of levels for each factor and the effect sizes."),
            tags$li("Adjust the interaction slider: 0 = no interaction, positive/negative = interaction."),
            tags$li("Click 'Generate & Analyze' to see data, interaction plot, and ANOVA table."),
            tags$li("Watch how the interaction plot lines become non-parallel as interaction strength increases.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Interaction Plot"),
               plotly::plotlyOutput(ns("fact_interaction_plot"), height = "400px")),
          card(full_screen = TRUE, card_header("Cell Means & Data"),
               plotly::plotlyOutput(ns("fact_data_plot"), height = "400px"))
        ),
        card(card_header("ANOVA Table"),
             tableOutput(ns("fact_anova_table")))
      )
    ),

    # ── Tab 3: Block Designs ───────────────────────────────────────────
    nav_panel(
      "Block Designs",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("block_n_blocks"), "Number of blocks", min = 2, max = 20, value = 6),
          sliderInput(ns("block_n_treat"), "Number of treatments", min = 2, max = 5, value = 3),
          sliderInput(ns("block_treat_effect"), "Treatment effect range", min = 0, max = 5, value = 2, step = 0.25),
          sliderInput(ns("block_block_var"), "Block variability (\u03c3\u2095)", min = 0, max = 8, value = 4, step = 0.5),
          sliderInput(ns("block_error_sd"), "Within-block error (\u03c3\u2091)", min = 0.5, max = 5, value = 1, step = 0.25),
          actionButton(ns("block_go"), "Simulate", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Randomized Complete Block Designs"),
          tags$p("Blocking is a strategy for reducing nuisance variability. If you know that
                  certain groups of experimental units are more similar to each other (e.g.,
                  same laboratory, same batch, same time period), you can form blocks and
                  assign all treatments within each block."),
          tags$p("Blocking removes the between-block variation from the error term, making
                  the test more powerful. It is particularly effective when block variability
                  is large relative to the error. In the extreme case where blocks explain
                  most of the variation, blocking dramatically increases the ability to
                  detect treatment effects."),
          tags$p("The key comparison here is between a ", tags$strong("completely randomized design"),
                  " (CRD), which ignores blocks, and a ", tags$strong("randomized complete block design"),
                  " (RCBD), which accounts for them. Both are applied to the same data \u2014 the
                  RCBD should have a smaller error term and thus a more significant test when
                  blocks are important."),
          guide = tags$ol(
            tags$li("Set the number of blocks and treatments."),
            tags$li("Increase 'Block variability' to create large between-block differences."),
            tags$li("Click 'Simulate' and compare the CRD vs RCBD analyses."),
            tags$li("Notice how blocking reduces the residual SD and increases the F-statistic.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Data by Block"),
               plotly::plotlyOutput(ns("block_data_plot"), height = "400px")),
          card(full_screen = TRUE, card_header("CRD vs RCBD Residual Error"),
               plotly::plotlyOutput(ns("block_compare_plot"), height = "400px"))
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(card_header("CRD (Ignoring Blocks)"),
               tableOutput(ns("block_crd_table"))),
          card(card_header("RCBD (Accounting for Blocks)"),
               tableOutput(ns("block_rcbd_table")))
        )
      )
    ),

    # ── Tab 4: Repeated Measures ───────────────────────────────────────
    nav_panel(
      "Repeated Measures",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ed_rm_n"), "Number of subjects", min = 5, max = 100, value = 20),
          sliderInput(ns("rm_timepoints"), "Timepoints", min = 2, max = 6, value = 3),
          sliderInput(ns("rm_time_effect"), "Time effect (slope)", min = -3, max = 3, value = 1, step = 0.25),
          sliderInput(ns("rm_subject_var"), "Between-subject SD", min = 0, max = 5, value = 2, step = 0.5),
          sliderInput(ns("rm_error_sd"), "Within-subject error SD", min = 0.5, max = 3, value = 1, step = 0.25),
          sliderInput(ns("rm_carryover"), "Carryover effect", min = 0, max = 2, value = 0, step = 0.1),
          actionButton(ns("ed_rm_go"), "Simulate", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Repeated Measures Designs"),
          tags$p("In a repeated measures (within-subjects) design, each participant is measured
                  at multiple timepoints or under multiple conditions. The main advantage is
                  increased power: because each subject serves as their own control, between-subject
                  variability is removed from the error term."),
          tags$p("However, repeated measures introduce complications:",
            tags$ul(
              tags$li(tags$strong("Carryover effects:"), " previous conditions can influence responses
                       to subsequent conditions. Counterbalancing (varying the order of conditions)
                       helps but does not fully eliminate carryover."),
              tags$li(tags$strong("Practice/fatigue:"), " performance may improve (practice) or decline
                       (fatigue) simply due to repeated testing."),
              tags$li(tags$strong("Sphericity:"), " the assumption that all pairs of conditions have
                       equal variance of their differences. Violation inflates Type I error.
                       The Greenhouse-Geisser or Huynh-Feldt corrections address this.")
            )
          ),
          tags$p("The spaghetti plot shows individual trajectories \u2014 each line is one
                  subject. The bold line is the group mean. When between-subject SD is large
                  but within-subject error is small, the individual lines are spread apart
                  but each follows a clear trend."),
          guide = tags$ol(
            tags$li("Set the number of subjects, timepoints, and effect sizes."),
            tags$li("Click 'Simulate' to see individual trajectories (spaghetti plot)."),
            tags$li("Compare the between-subjects vs within-subjects ANOVA — notice the power difference."),
            tags$li("Increase carryover to see how it distorts the time effect at later timepoints.")
          )
        ),
        layout_column_wrap(
          width = 1 / 2,
          card(full_screen = TRUE, card_header("Individual Trajectories (Spaghetti Plot)"),
               plotly::plotlyOutput(ns("rm_spaghetti_plot"), height = "400px")),
          card(full_screen = TRUE, card_header("Between vs Within F-statistics"),
               plotly::plotlyOutput(ns("rm_f_compare_plot"), height = "400px"))
        ),
        card(card_header("Within-Subjects ANOVA"),
             tableOutput(ns("rm_anova_table")))
      )
    ),

    # ── Tab 5: Design Comparison ───────────────────────────────────────
    nav_panel(
      "Design Comparison",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("dc_effect"), "True effect size (Cohen's d)", min = 0, max = 2, value = 0.5, step = 0.1),
          sliderInput(ns("dc_n_total"), "Total N (budget)", min = 20, max = 200, value = 60, step = 10),
          sliderInput(ns("dc_block_var"), "Block variability (if blocking)", min = 0, max = 5, value = 2, step = 0.5),
          sliderInput(ns("dc_corr_rm"), "Within-subject correlation (if RM)", min = 0, max = 0.95, value = 0.5, step = 0.05),
          numericInput(ns("dc_sims"), "Simulations", value = 2000, min = 500, max = 10000),
          actionButton(ns("dc_go"), "Compare designs", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Comparing Experimental Designs"),
          tags$p("Different designs allocate the same budget of participants differently,
                  resulting in different statistical power. This tab simulates the same
                  experiment under three designs and compares their rejection rates:"),
          tags$ul(
            tags$li(tags$strong("Completely Randomized Design (CRD):"), " N/2 per group, ignoring
                     all nuisance variables."),
            tags$li(tags$strong("Randomized Complete Block Design (RCBD):"), " Participants grouped
                     into blocks; blocking removes nuisance variation."),
            tags$li(tags$strong("Repeated Measures (RM):"), " Each of N participants measured twice
                     (treatment vs control). Within-subject correlation reduces error.")
          ),
          tags$p("The key insight: with the same total budget, RM and RCBD are almost always
                  more powerful than CRD because they remove nuisance variation. RM is
                  especially powerful when the within-subject correlation is high."),
          tags$p("Design choice should be guided by the research question and practical
                  constraints. Repeated measures designs require that the same participants
                  can be measured under both conditions, which may not always be feasible
                  (e.g., when the treatment has permanent effects). Blocking requires
                  identifying a relevant nuisance variable before randomisation."),
          tags$p("The efficiency gains from better designs can be substantial. A repeated
                  measures design with within-subject correlation of 0.7 can achieve the
                  same power as a CRD with roughly three times as many participants. This
                  makes design choice one of the most cost-effective decisions in research
                  planning."),
          guide = tags$ol(
            tags$li("Set the true effect size, total budget, and nuisance parameters."),
            tags$li("Click 'Compare designs' to simulate all three designs."),
            tags$li("The bar chart shows estimated power for each design."),
            tags$li("Try varying the within-subject correlation to see how much RM benefits.")
          )
        ),
        card(full_screen = TRUE,
             card_header("Power Comparison Across Designs"),
             plotly::plotlyOutput(ns("dc_power_plot"), height = "450px"))
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

experimental_design_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ══════════════════════════════════════════════════════════════════════

  # Tab 1: Randomization
  # ══════════════════════════════════════════════════════════════════════

  rand_data <- reactiveVal(NULL)
  rand_sim_data <- reactiveVal(NULL)

  # Helper: generate a participant pool
  rand_pool <- function(n, pct_female, age_diff) {
    gender <- sample(c("F", "M"), n, replace = TRUE,
                     prob = c(pct_female / 100, 1 - pct_female / 100))
    age <- rnorm(n, 35, 8)
    # Add confound: if not randomized properly, older people might end up in one group
    age <- age + ifelse(seq_len(n) <= n / 2, age_diff / 2, -age_diff / 2)
    data.frame(id = seq_len(n), gender = gender, age = round(age, 1),
               stringsAsFactors = FALSE)
  }

  # Helper: assign treatment by method
  rand_assign <- function(pool, method) {
    n <- nrow(pool)
    assignment <- switch(method,
      "Simple random" = sample(rep(c("Treatment", "Control"), length.out = n)),
      "Stratified (by gender)" = {
        a <- character(n)
        for (g in unique(pool$gender)) {
          idx <- which(pool$gender == g)
          a[idx] <- sample(rep(c("Treatment", "Control"), length.out = length(idx)))
        }
        a
      },
      "Block randomization (block size 4)" = {
        blocks <- ceiling(n / 4)
        unlist(lapply(seq_len(blocks), function(b) {
          sample(rep(c("Treatment", "Control"), 2))
        }))[seq_len(n)]
      },
      "Minimization (adaptive)" = {
        a <- character(n)
        for (i in seq_len(n)) {
          if (i <= 2) {
            a[i] <- sample(c("Treatment", "Control"), 1)
          } else {
            prev <- pool[seq_len(i - 1), ]
            prev$group <- a[seq_len(i - 1)]
            cur <- pool[i, ]
            # Count matching covariate levels in each group
            t_n <- sum(prev$group == "Treatment")
            c_n <- sum(prev$group == "Control")
            t_g <- sum(prev$group == "Treatment" & prev$gender == cur$gender)
            c_g <- sum(prev$group == "Control" & prev$gender == cur$gender)
            imbal_t <- abs(t_n + 1 - c_n) + abs(t_g + 1 - c_g)
            imbal_c <- abs(t_n - (c_n + 1)) + abs(t_g - (c_g + 1))
            if (imbal_t < imbal_c) a[i] <- "Treatment"
            else if (imbal_c < imbal_t) a[i] <- "Control"
            else a[i] <- sample(c("Treatment", "Control"), 1)
          }
        }
        a
      }
    )
    pool$group <- assignment
    pool
  }

  observeEvent(input$rand_go, {
    set.seed(sample.int(10000, 1))
    pool <- rand_pool(input$rand_n, input$rand_gender_ratio, input$rand_age_diff)
    result <- rand_assign(pool, input$rand_method)
    rand_data(result)
  })

  observeEvent(input$rand_sim, {
    set.seed(sample.int(10000, 1))
    n <- input$rand_n
    pct_f <- input$rand_gender_ratio
    age_diff <- input$rand_age_diff
    method <- input$rand_method
    reps <- input$rand_reps

    age_diffs <- numeric(reps)
    gender_diffs <- numeric(reps)
    for (i in seq_len(reps)) {
      pool <- rand_pool(n, pct_f, age_diff)
      result <- rand_assign(pool, method)
      t_idx <- result$group == "Treatment"
      age_diffs[i] <- mean(result$age[t_idx]) - mean(result$age[!t_idx])
      gender_diffs[i] <- mean(result$gender[t_idx] == "F") - mean(result$gender[!t_idx] == "F")
    }
    rand_sim_data(list(age_diffs = age_diffs, gender_diffs = gender_diffs, method = method))
  })

  output$rand_assign_plot <- renderPlotly({
    d <- rand_data()
    req(d)
    colors <- c("Treatment" = "#238b45", "Control" = "#268bd2")
    shapes <- c("F" = "circle", "M" = "square")

    plotly::plot_ly(d, x = ~age, y = ~jitter(as.numeric(factor(group)), 0.3),
      color = ~group, colors = colors,
      symbol = ~gender, symbols = c("circle", "square"),
      type = "scatter", mode = "markers",
      marker = list(size = 8, opacity = 0.7),
      hoverinfo = "text",
      text = ~paste0("ID: ", id, "<br>Age: ", age, "<br>Gender: ", gender,
                     "<br>Group: ", group)
    ) |> plotly::layout(
      xaxis = list(title = "Age"),
      yaxis = list(title = "", tickvals = c(1, 2),
                   ticktext = c("Control", "Treatment")),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = 1.08, yanchor = "bottom"),
      margin = list(t = 50)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rand_balance_table <- renderTable({
    d <- rand_data()
    req(d)
    t_idx <- d$group == "Treatment"
    data.frame(
      Covariate = c("Age (mean)", "% Female", "N"),
      Treatment = c(round(mean(d$age[t_idx]), 1),
                    round(mean(d$gender[t_idx] == "F") * 100, 1),
                    sum(t_idx)),
      Control = c(round(mean(d$age[!t_idx]), 1),
                  round(mean(d$gender[!t_idx] == "F") * 100, 1),
                  sum(!t_idx)),
      Difference = c(round(mean(d$age[t_idx]) - mean(d$age[!t_idx]), 2),
                     round((mean(d$gender[t_idx] == "F") - mean(d$gender[!t_idx] == "F")) * 100, 1),
                     sum(t_idx) - sum(!t_idx)),
      check.names = FALSE
    )
  }, hover = TRUE, spacing = "s")

  output$rand_balance_plot <- renderPlotly({
    sim <- rand_sim_data()
    req(sim)

    plotly::plot_ly() |>
      plotly::add_histogram(x = sim$age_diffs, name = "Age difference",
        marker = list(color = "rgba(35,139,69,0.6)"),
        nbinsx = 40,
        hovertemplate = "Diff: %{x:.2f}<br>Count: %{y}<extra>Age</extra>") |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = 0, x1 = 0, y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#e31a1c", width = 2, dash = "dash")
        )),
        xaxis = list(title = "Mean age difference (Treatment - Control)"),
        yaxis = list(title = "Count"),
        title = list(
          text = paste0(sim$method, " | SD of age diff = ",
                        round(sd(sim$age_diffs), 2)),
          font = list(size = 12)
        ),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ══════════════════════════════════════════════════════════════════════
  # Tab 2: Factorial Designs
  # ══════════════════════════════════════════════════════════════════════

  fact_data <- reactiveVal(NULL)

  observeEvent(input$fact_go, {
    set.seed(sample.int(10000, 1))
    a_lev <- input$fact_a_levels
    b_lev <- input$fact_b_levels
    n_cell <- input$fact_n_cell
    sigma <- input$fact_sigma
    a_eff <- input$fact_a_effect
    b_eff <- input$fact_b_effect
    ix <- input$fact_interaction

    design <- expand.grid(
      A = paste0("A", seq_len(a_lev)),
      B = paste0("B", seq_len(b_lev)),
      rep = seq_len(n_cell)
    )
    a_num <- as.numeric(factor(design$A)) - 1
    b_num <- as.numeric(factor(design$B)) - 1

    # Center effects
    mu <- 10 + a_eff * (a_num - (a_lev - 1) / 2) +
              b_eff * (b_num - (b_lev - 1) / 2) +
              ix * (a_num - (a_lev - 1) / 2) * (b_num - (b_lev - 1) / 2)
    design$Y <- mu + rnorm(nrow(design), 0, sigma)
    fact_data(design)
  })

  output$fact_interaction_plot <- renderPlotly({
    d <- fact_data()
    req(d)
    cell_means <- aggregate(Y ~ A + B, data = d, FUN = mean)
    b_levels <- unique(cell_means$B)
    pal <- RColorBrewer::brewer.pal(max(3, length(b_levels)), "Set1")[seq_along(b_levels)]

    p <- plotly::plot_ly()
    for (i in seq_along(b_levels)) {
      sub <- cell_means[cell_means$B == b_levels[i], ]
      p <- p |> plotly::add_trace(
        x = sub$A, y = sub$Y,
        type = "scatter", mode = "lines+markers",
        line = list(color = pal[i], width = 2.5),
        marker = list(color = pal[i], size = 8),
        name = b_levels[i],
        hovertemplate = paste0(b_levels[i], "<br>%{x}<br>Mean Y = %{y:.2f}<extra></extra>")
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "Factor A"),
      yaxis = list(title = "Mean Y"),
      legend = list(title = list(text = "Factor B"),
                    orientation = "v"),
      margin = list(t = 20)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$fact_data_plot <- renderPlotly({
    d <- fact_data()
    req(d)
    d$cell <- paste(d$A, d$B, sep = ":")
    plotly::plot_ly(d, y = ~Y, x = ~cell, color = ~B,
                    type = "box", boxpoints = "outliers") |>
      plotly::layout(
        xaxis = list(title = "Cell (A:B)", tickangle = -45),
        yaxis = list(title = "Y"),
        showlegend = FALSE,
        margin = list(b = 80, t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$fact_anova_table <- renderTable({
    d <- fact_data()
    req(d)
    fit <- aov(Y ~ A * B, data = d)
    s <- summary(fit)[[1]]
    data.frame(
      Source = rownames(s),
      df = s$Df,
      `Sum of Sq` = round(s$`Sum Sq`, 2),
      `Mean Sq` = round(s$`Mean Sq`, 2),
      `F` = round(s$`F value`, 3),
      `p-value` = format.pval(s$`Pr(>F)`, digits = 4),
      Eta.sq = round(s$`Sum Sq` / sum(s$`Sum Sq`), 3),
      check.names = FALSE
    )
  }, hover = TRUE, spacing = "s")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 3: Block Designs
  # ══════════════════════════════════════════════════════════════════════

  block_data <- reactiveVal(NULL)

  observeEvent(input$block_go, {
    set.seed(sample.int(10000, 1))
    nb <- input$block_n_blocks
    nt <- input$block_n_treat
    block_sd <- input$block_block_var
    error_sd <- input$block_error_sd
    treat_range <- input$block_treat_effect

    treat_effects <- seq(0, treat_range, length.out = nt)
    block_effects <- rnorm(nb, 0, block_sd)

    design <- expand.grid(
      block = paste0("Block ", seq_len(nb)),
      treatment = paste0("T", seq_len(nt))
    )
    design$block_num <- as.numeric(factor(design$block))
    design$treat_num <- as.numeric(factor(design$treatment))
    design$Y <- 50 + treat_effects[design$treat_num] +
                     block_effects[design$block_num] +
                     rnorm(nrow(design), 0, error_sd)
    block_data(design)
  })

  output$block_data_plot <- renderPlotly({
    d <- block_data()
    req(d)
    plotly::plot_ly(d, x = ~treatment, y = ~Y, color = ~block,
                    type = "scatter", mode = "lines+markers",
                    hoverinfo = "text",
                    text = ~paste0(block, "<br>", treatment, "<br>Y = ", round(Y, 2))) |>
      plotly::layout(
        xaxis = list(title = "Treatment"),
        yaxis = list(title = "Y"),
        legend = list(title = list(text = "Block"), font = list(size = 10)),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$block_compare_plot <- renderPlotly({
    d <- block_data()
    req(d)

    crd_fit <- aov(Y ~ treatment, data = d)
    rcbd_fit <- aov(Y ~ treatment + block, data = d)

    crd_mse <- summary(crd_fit)[[1]]["Residuals", "Mean Sq"]
    rcbd_mse <- summary(rcbd_fit)[[1]]["Residuals", "Mean Sq"]

    plotly::plot_ly() |>
      plotly::add_bars(
        x = c("CRD (no blocking)", "RCBD (with blocking)"),
        y = c(sqrt(crd_mse), sqrt(rcbd_mse)),
        marker = list(color = c("#268bd2", "#238b45"),
                      line = list(color = "white", width = 1)),
        text = c(round(sqrt(crd_mse), 2), round(sqrt(rcbd_mse), 2)),
        textposition = "none",
        hovertemplate = "%{x}<br>Residual SD = %{y:.2f}<extra></extra>",
        showlegend = FALSE
      ) |> plotly::layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Residual SD",
                     range = c(0, max(sqrt(crd_mse), sqrt(rcbd_mse)) * 1.3)),
        title = list(
          text = paste0("Blocking reduces residual SD by ",
                        round((1 - sqrt(rcbd_mse) / sqrt(crd_mse)) * 100, 1), "%"),
          font = list(size = 12)),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$block_crd_table <- renderTable({
    d <- block_data(); req(d)
    s <- summary(aov(Y ~ treatment, data = d))[[1]]
    data.frame(
      Source = rownames(s), df = s$Df,
      `Mean Sq` = round(s$`Mean Sq`, 2),
      F = round(s$`F value`, 3),
      `p-value` = format.pval(s$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, hover = TRUE, spacing = "s")

  output$block_rcbd_table <- renderTable({
    d <- block_data(); req(d)
    s <- summary(aov(Y ~ treatment + block, data = d))[[1]]
    data.frame(
      Source = rownames(s), df = s$Df,
      `Mean Sq` = round(s$`Mean Sq`, 2),
      F = round(s$`F value`, 3),
      `p-value` = format.pval(s$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, hover = TRUE, spacing = "s")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 4: Repeated Measures
  # ══════════════════════════════════════════════════════════════════════

  rm_data <- reactiveVal(NULL)

  observeEvent(input$ed_rm_go, {
    set.seed(sample.int(10000, 1))
    n <- input$ed_rm_n
    tp <- input$rm_timepoints
    time_eff <- input$rm_time_effect
    subj_sd <- input$rm_subject_var
    err_sd <- input$rm_error_sd
    carryover <- input$rm_carryover

    subj_intercept <- rnorm(n, 0, subj_sd)
    design <- expand.grid(subject = seq_len(n), time = seq_len(tp))
    design$Y <- 50 + subj_intercept[design$subject] +
                     time_eff * (design$time - 1) +
                     carryover * pmax(design$time - 1, 0) * (design$time - 1) / tp +
                     rnorm(nrow(design), 0, err_sd)
    design$subject <- factor(design$subject)
    design$time <- factor(design$time)
    rm_data(design)
  })

  output$rm_spaghetti_plot <- renderPlotly({
    d <- rm_data()
    req(d)

    means <- aggregate(Y ~ time, data = d, FUN = mean)

    p <- plotly::plot_ly()
    subjects <- unique(d$subject)
    for (s in subjects) {
      sub <- d[d$subject == s, ]
      p <- p |> plotly::add_trace(
        x = as.numeric(sub$time), y = sub$Y,
        type = "scatter", mode = "lines",
        line = list(color = "rgba(100,100,100,0.2)", width = 1),
        showlegend = FALSE, hoverinfo = "none"
      )
    }
    p <- p |> plotly::add_trace(
      x = as.numeric(means$time), y = means$Y,
      type = "scatter", mode = "lines+markers",
      line = list(color = "#238b45", width = 3),
      marker = list(color = "#238b45", size = 8),
      name = "Group mean",
      hovertemplate = "Time %{x}<br>Mean Y = %{y:.2f}<extra></extra>"
    )
    p |> plotly::layout(
      xaxis = list(title = "Timepoint"),
      yaxis = list(title = "Y"),
      margin = list(t = 20)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rm_f_compare_plot <- renderPlotly({
    d <- rm_data()
    req(d)

    # Between-subjects: ignore subject, treat time as between-group
    between_fit <- aov(Y ~ time, data = d)
    between_f <- summary(between_fit)[[1]]["time", "F value"]
    between_p <- summary(between_fit)[[1]]["time", "Pr(>F)"]

    # Within-subjects: account for subject
    within_fit <- aov(Y ~ time + subject, data = d)
    within_f <- summary(within_fit)[[1]]["time", "F value"]
    within_p <- summary(within_fit)[[1]]["time", "Pr(>F)"]

    labels <- c("Between-subjects\n(ignoring subjects)", "Within-subjects\n(accounting for subjects)")
    f_vals <- c(between_f, within_f)
    cols <- c("#268bd2", "#238b45")
    p_labels <- c(format.pval(between_p, digits = 3), format.pval(within_p, digits = 3))

    plotly::plot_ly() |>
      plotly::add_bars(
        x = labels, y = f_vals,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        text = paste0("F = ", round(f_vals, 2), "\np = ", p_labels),
        textposition = "none",
        hovertemplate = "%{x}<br>F = %{y:.2f}<extra></extra>",
        showlegend = FALSE
      ) |> plotly::layout(
        xaxis = list(title = ""),
        yaxis = list(title = "F-statistic",
                     range = c(0, max(f_vals) * 1.3)),
        title = list(text = "Removing between-subject variance boosts power",
                     font = list(size = 12)),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rm_anova_table <- renderTable({
    d <- rm_data(); req(d)
    fit <- aov(Y ~ time + subject, data = d)
    s <- summary(fit)[[1]]
    data.frame(
      Source = rownames(s), df = s$Df,
      `Sum of Sq` = round(s$`Sum Sq`, 2),
      `Mean Sq` = round(s$`Mean Sq`, 2),
      F = round(s$`F value`, 3),
      `p-value` = format.pval(s$`Pr(>F)`, digits = 4),
      check.names = FALSE
    )
  }, hover = TRUE, spacing = "s")

  # ══════════════════════════════════════════════════════════════════════
  # Tab 5: Design Comparison (power simulation)
  # ══════════════════════════════════════════════════════════════════════

  dc_result <- reactiveVal(NULL)

  observeEvent(input$dc_go, {
    set.seed(sample.int(10000, 1))
    d <- input$dc_effect
    n_total <- input$dc_n_total
    block_sd <- input$dc_block_var
    rho <- input$dc_corr_rm
    nsim <- input$dc_sims

    n_per <- n_total %/% 2
    crd_reject <- 0
    rcbd_reject <- 0
    rm_reject <- 0

    for (i in seq_len(nsim)) {
      # CRD: n_per per group, independent
      y_ctrl <- rnorm(n_per)
      y_treat <- rnorm(n_per, d)
      crd_reject <- crd_reject + (t.test(y_ctrl, y_treat)$p.value < 0.05)

      # RCBD: n_total observations in blocks of 2
      block_eff <- rep(rnorm(n_per, 0, block_sd), each = 2)
      treat <- rep(c(0, 1), n_per)
      y <- block_eff + d * treat + rnorm(n_total)
      block_f <- factor(rep(seq_len(n_per), each = 2))
      treat_f <- factor(treat)
      s <- summary(aov(y ~ treat_f + block_f))[[1]]
      rcbd_reject <- rcbd_reject + (s["treat_f", "Pr(>F)"] < 0.05)

      # RM: n_total subjects, measured twice (within)
      subj_eff <- rnorm(n_total, 0, 1)
      y_pre <- subj_eff + rnorm(n_total, 0, sqrt(1 - rho))
      y_post <- subj_eff + d + rnorm(n_total, 0, sqrt(1 - rho))
      rm_reject <- rm_reject + (t.test(y_post - y_pre)$p.value < 0.05)
    }

    dc_result(data.frame(
      Design = c("CRD", "RCBD", "Repeated Measures"),
      Power = c(crd_reject, rcbd_reject, rm_reject) / nsim
    ))
  })

  output$dc_power_plot <- renderPlotly({
    res <- dc_result()
    req(res)

    cols <- c("#268bd2", "#2aa198", "#238b45")

    plotly::plot_ly() |>
      plotly::add_bars(
        x = res$Design, y = res$Power,
        marker = list(color = cols, line = list(color = "white", width = 1)),
        text = paste0(round(res$Power * 100, 1), "%"),
        textposition = "none",
        hovertemplate = "%{x}: %{y:.1%}<extra></extra>",
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = -0.5, x1 = 2.5,
          y0 = 0.8, y1 = 0.8,
          line = list(color = "#e31a1c", width = 1.5, dash = "dash")
        )),
        annotations = list(
          list(x = 2.5, y = 0.8, text = "80% power", showarrow = FALSE,
               xanchor = "left", font = list(size = 11, color = "#e31a1c"))
        ),
        xaxis = list(title = ""),
        yaxis = list(title = "Power (rejection rate)", tickformat = ".0%",
                     range = c(0, max(1.05, max(res$Power) * 1.15))),
        title = list(
          text = paste0("N = ", input$dc_n_total, " | d = ", input$dc_effect,
                        " | ", input$dc_sims, " simulations"),
          font = list(size = 12)),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
