# Module: Advanced Psychometric Models (consolidated)
# Tabs: Cognitive Diagnostic | G-Theory | Item Generation

# ── UI ──────────────────────────────────────────────────────────────────
mod_advanced_psych_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Advanced Models",
  icon = icon("brain"),
  navset_card_underline(

    # ── Tab 1: Cognitive Diagnostic ──────────────────────────────
    nav_panel(
      "Cognitive Diagnostic",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("cdm_n"), "Number of examinees", min = 100, max = 1000,
                        value = 300, step = 100),
            sliderInput(ns("cdm_items"), "Number of items", min = 8, max = 20,
                        value = 12, step = 2),
            sliderInput(ns("cdm_skills"), "Number of skills (attributes)", min = 2, max = 4,
                        value = 3, step = 1),
            sliderInput(ns("cdm_slip"), "Slip probability", min = 0, max = 0.3,
                        value = 0.1, step = 0.05),
            sliderInput(ns("cdm_guess"), "Guessing probability", min = 0, max = 0.3,
                        value = 0.1, step = 0.05),
            actionButton(ns("cdm_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Cognitive Diagnostic Models (CDM)"),
            tags$p("CDMs classify examinees into mastery profiles based on which skills
                    (attributes) they have mastered. Unlike IRT, which places examinees
                    on a continuous scale, CDMs provide discrete diagnostic feedback."),
            tags$ul(
              tags$li(tags$strong("Q-matrix:"), " Specifies which skills each item requires (binary matrix)."),
              tags$li(tags$strong("DINA model:"), " Examinee must master ALL required skills. Slip = P(wrong | mastered all), Guess = P(correct | missing any)."),
              tags$li(tags$strong("Attribute profile:"), " Binary vector indicating which skills an examinee has mastered.")
            ),
          tags$p("Unlike IRT, which estimates a single continuous ability, CDMs classify
                  examinees into mastery profiles across multiple discrete skills (attributes).
                  The Q-matrix specifies which attributes each item requires. The DINA model
                  is the most commonly used CDM: it assumes an examinee must master all required
                  attributes to have a high probability of correct response (conjunctive rule),
                  with slipping and guessing parameters capturing imperfect measurement."),
          tags$p("CDMs are particularly useful for formative assessment: they provide detailed
                  diagnostic feedback about which specific skills a student has and has not
                  mastered, rather than just a single score. This enables targeted remediation."),
          tags$p("The quality of a CDM analysis depends heavily on the quality of the Q-matrix,
                  which must be defined by subject-matter experts. A misspecified Q-matrix
                  leads to inaccurate mastery classifications. Validation methods include
                  expert review, empirical Q-matrix estimation, and comparison of observed
                  and expected response patterns under the fitted model."),
            guide = tags$ol(
              tags$li("Set examinees, items, skills, slip, and guessing parameters."),
              tags$li("Click 'Simulate' to generate data under a DINA model."),
              tags$li("The Q-matrix heatmap shows item-skill requirements."),
              tags$li("The profile distribution shows how many examinees have each mastery pattern.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Q-Matrix"),
                 plotlyOutput(ns("cdm_qmatrix"), height = "300px")),
            card(full_screen = TRUE, card_header("Attribute Profile Distribution"),
                 plotlyOutput(ns("cdm_profiles"), height = "350px")),
            card(card_header("Classification Summary"), tableOutput(ns("cdm_summary")))
          )
        )
    ),

    # ── Tab 2: G-Theory ──────────────────────────────────────────
    nav_panel(
      "G-Theory",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            tags$h6("Design: Persons \u00d7 Items \u00d7 Raters"),
            sliderInput(ns("gt_persons"), "Number of persons", min = 20, max = 200, value = 50, step = 10),
            sliderInput(ns("gt_items"), "Number of items", min = 3, max = 15, value = 6, step = 1),
            sliderInput(ns("gt_raters"), "Number of raters", min = 2, max = 8, value = 3, step = 1),
            tags$hr(),
            tags$h6("Variance Components (true proportions)"),
            sliderInput(ns("gt_var_p"), "Person variance (%)", min = 10, max = 80, value = 40, step = 5),
            sliderInput(ns("gt_var_i"), "Item variance (%)", min = 0, max = 40, value = 10, step = 5),
            sliderInput(ns("gt_var_r"), "Rater variance (%)", min = 0, max = 40, value = 15, step = 5),
            actionButton(ns("gt_go"), "Run G-Study", class = "btn-success w-100 mb-2"),
            actionButton(ns("ap_gt_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          explanation_box(
            tags$strong("Generalizability Theory"),
            tags$p("G-Theory extends CTT by decomposing score variance into multiple
                    facets (persons, items, raters, occasions) rather than lumping all
                    error into one term. A G-study estimates variance components; a
                    D-study uses these to plan optimal designs (e.g., how many raters
                    or items to minimize error)."),
            tags$p("The generalizability coefficient (\u03c1\u00b2) is analogous to
                    reliability in CTT but accounts for all sources of error simultaneously."),
          tags$p("Generalisability theory (G-theory) extends classical reliability by
                  decomposing variance into multiple sources simultaneously (persons, items,
                  raters, occasions, and their interactions). The G-coefficient is a generalised
                  reliability index that accounts for all specified error sources."),
          tags$p("G-theory is especially valuable for designing performance assessments: it
                  answers questions like \u201cHow many raters and tasks do we need for reliable
                  scores?\u201d The D-study (decision study) optimises the assessment design by
                  showing how reliability changes with different numbers of each facet."),
            guide = tags$ol(
              tags$li("Set the number of persons, items, and raters."),
              tags$li("Adjust variance component proportions to simulate different scenarios."),
              tags$li("Click 'Run G-Study' to generate data and estimate variance components."),
              tags$li("The pie chart shows relative contribution of each source of variance."),
              tags$li("The D-study plot shows how \u03c1\u00b2 changes as you vary facet sizes.")
            )
          ),
          layout_column_wrap(
            width = 1,
            layout_column_wrap(
              width = 1 / 2,
              card(card_header("Variance Components"), uiOutput(ns("gt_vc_table"))),
              card(full_screen = TRUE, card_header("Variance Decomposition"),
                   plotlyOutput(ns("gt_pie_plot"), height = "350px"))
            ),
            card(full_screen = TRUE, card_header("D-Study: \u03c1\u00b2 by Design"),
                 plotlyOutput(ns("gt_dstudy_plot"), height = "380px"))
          )
        )
    ),

    # ── Tab 3: Item Generation ───────────────────────────────────
    nav_panel(
      "Item Generation",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("aig_domain"), "Item domain",
              choices = c("Arithmetic" = "arith",
                          "Analogies" = "analogy",
                          "Spatial reasoning" = "spatial"),
              selected = "arith"
            ),
            sliderInput(ns("aig_n_items"), "Items to generate", min = 5, max = 30,
                        value = 10, step = 5),
            sliderInput(ns("aig_diff_range"), "Difficulty range",
                        min = -3, max = 3, value = c(-1.5, 1.5), step = 0.5),
            actionButton(ns("aig_go"), "Generate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Automatic Item Generation (AIG)"),
            tags$p("AIG uses item templates (item models) with variable elements to produce
                    families of items with predictable statistical properties."),
            tags$ul(
              tags$li(tags$strong("Item model:"), " A template with fixed structure and variable content (e.g., numbers, words)."),
              tags$li(tags$strong("Isomorphs:"), " Items from the same model are structurally identical but differ in surface features."),
              tags$li(tags$strong("Difficulty prediction:"), " Item features (number of operations, distractor similarity) predict difficulty.")
            ),
            tags$p("This module simulates how AIG works by generating item families
                    and predicting their psychometric properties from features."),
          tags$p("Automatic item generation (AIG) uses templates (item models) with variable
                  elements that can be systematically varied to produce large numbers of items.
                  This addresses a fundamental bottleneck in testing: the cost and time required
                  to develop high-quality items manually."),
          tags$p("AIG is most feasible for well-structured domains (e.g., arithmetic, grammar
                  rules) where item difficulty can be predicted from structural features.
                  Cognitive models of task complexity help calibrate generated items without
                  extensive pre-testing. Recent advances in natural language processing are
                  expanding AIG to less structured domains."),
            guide = tags$ol(
              tags$li("Choose a domain and number of items."),
              tags$li("Click 'Generate' to create items from templates."),
              tags$li("Examine how item features relate to predicted difficulty."),
              tags$li("The plot shows feature-difficulty relationships.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Generated Items"),
                 tableOutput(ns("aig_items"))),
            card(full_screen = TRUE, card_header("Feature-Difficulty Relationship"),
                 plotlyOutput(ns("aig_plot"), height = "350px"))
          )
        )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_advanced_psych_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Cognitive Diagnostic ───────────────────────────────────
  cdm_data <- reactiveVal(NULL)

  observeEvent(input$cdm_go, {
    n <- input$cdm_n; J <- input$cdm_items; K <- input$cdm_skills
    s <- input$cdm_slip; g <- input$cdm_guess
    set.seed(sample.int(10000, 1))

    # Generate Q-matrix: each item requires 1-2 skills
    Q <- matrix(0, J, K)
    for (j in seq_len(J)) {
      n_req <- sample(1:min(2, K), 1)
      Q[j, sample(K, n_req)] <- 1
    }
    # Ensure each skill is required by at least 2 items
    for (k in seq_len(K)) {
      if (sum(Q[, k]) < 2) Q[sample(J, 2), k] <- 1
    }
    rownames(Q) <- paste0("Item", seq_len(J))
    colnames(Q) <- paste0("Skill", seq_len(K))

    # Generate true attribute profiles
    alpha <- matrix(rbinom(n * K, 1, 0.5), n, K)
    colnames(alpha) <- paste0("Skill", seq_len(K))

    # DINA: eta_ij = prod(alpha_ik^Q_jk)
    eta <- matrix(0, n, J)
    for (j in seq_len(J)) {
      req_skills <- which(Q[j, ] == 1)
      eta[, j] <- apply(alpha[, req_skills, drop = FALSE], 1, function(a) as.integer(all(a == 1)))
    }

    # Response probability
    P <- eta * (1 - s) + (1 - eta) * g
    X <- matrix(rbinom(n * J, 1, P), n, J)

    # Profile labels
    profile_labels <- apply(alpha, 1, paste, collapse = "")
    profile_counts <- sort(table(profile_labels), decreasing = TRUE)

    # Marginal skill mastery rates
    skill_mastery <- colMeans(alpha)

    cdm_data(list(Q = Q, alpha = alpha, X = X,
                  profile_counts = profile_counts,
                  skill_mastery = skill_mastery,
                  K = K, J = J, n = n))
  })

  output$cdm_qmatrix <- renderPlotly({
    res <- cdm_data()
    req(res)
    Q <- res$Q
    skills <- colnames(Q); items <- rownames(Q)
    # Build matrix for heatmap (items as rows, skills as columns)
    z_mat <- Q[rev(seq_len(nrow(Q))), , drop = FALSE]
    text_mat <- ifelse(z_mat == 1, "Yes", "No")
    hover_mat <- matrix(paste0(rep(rev(items), ncol(Q)), " × ", rep(skills, each = nrow(Q)),
                                "<br>Required: ", text_mat), nrow = nrow(Q))
    plotly::plot_ly(
      z = z_mat, x = skills, y = rev(items),
      type = "heatmap",
      colorscale = list(c(0, "#93a1a1"), c(1, "#268bd2")),
      showscale = FALSE,
      hoverinfo = "text", text = hover_mat
    ) |>
      plotly::add_annotations(
        x = rep(skills, each = nrow(Q)),
        y = rep(rev(items), ncol(Q)),
        text = as.vector(text_mat),
        showarrow = FALSE,
        font = list(color = "white", size = 11)
      ) |>
      plotly::layout(
        xaxis = list(title = "Skill", side = "bottom"),
        yaxis = list(title = "Item"),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$cdm_profiles <- renderPlotly({
    res <- cdm_data(); req(res)
    pc <- res$profile_counts
    top <- head(pc, 15)

    plotly::plot_ly(
      x = names(top), y = as.integer(top),
      type = "bar",
      marker = list(color = "#238b45"),
      hoverinfo = "text",
      text = paste0("Profile: ", names(top), "<br>Count: ", as.integer(top))
    ) |> plotly::layout(
      xaxis = list(title = "Attribute Profile", categoryorder = "total descending"),
      yaxis = list(title = "Count"),
      margin = list(t = 20, b = 80)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$cdm_summary <- renderTable({
    res <- cdm_data(); req(res)
    data.frame(
      Skill = names(res$skill_mastery),
      `Mastery Rate (%)` = round(res$skill_mastery * 100, 1),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── G-Theory ───────────────────────────────────────────────
  gt_data <- reactiveVal(NULL)
  
  observeEvent(input$ap_gt_reset, {
    updateSliderInput(session, "gt_persons", value = 50)
    updateSliderInput(session, "gt_items", value = 6)
    updateSliderInput(session, "gt_raters", value = 3)
    updateSliderInput(session, "gt_var_p", value = 40)
    updateSliderInput(session, "gt_var_i", value = 10)
    updateSliderInput(session, "gt_var_r", value = 15)
    gt_data(NULL)
  })
  
  observeEvent(input$gt_go, {
    set.seed(sample(1:10000, 1))
    np <- input$gt_persons; ni <- input$gt_items; nr <- input$gt_raters
  
    # Normalize variance proportions
    raw <- c(input$gt_var_p, input$gt_var_i, input$gt_var_r)
    residual_pct <- max(100 - sum(raw), 5)
    total_var <- 4
    props <- c(raw, residual_pct) / 100
  
    var_p <- props[1] * total_var
    var_i <- props[2] * total_var
    var_r <- props[3] * total_var
    var_e <- props[4] * total_var
  
    # Generate effects
    p_eff <- rnorm(np, 0, sqrt(var_p))
    i_eff <- rnorm(ni, 0, sqrt(var_i))
    r_eff <- rnorm(nr, 0, sqrt(var_r))
  
    # Score: grand mean + person + item + rater + error
    scores <- array(NA, dim = c(np, ni, nr))
    grand_mean <- 5
    for (p in seq_len(np))
      for (i in seq_len(ni))
        for (r in seq_len(nr))
          scores[p, i, r] <- grand_mean + p_eff[p] + i_eff[i] + r_eff[r] + rnorm(1, 0, sqrt(var_e))
  
    # Estimate variance components via ANOVA
    df_long <- expand.grid(Person = seq_len(np), Item = seq_len(ni), Rater = seq_len(nr))
    df_long$Score <- as.vector(scores)
    df_long$Person <- factor(df_long$Person)
    df_long$Item <- factor(df_long$Item)
    df_long$Rater <- factor(df_long$Rater)
  
    fit <- aov(Score ~ Person + Item + Rater, data = df_long)
    ms <- summary(fit)[[1]][, "Mean Sq"]
    df_vals <- summary(fit)[[1]][, "Df"]
  
    # EMS-based variance component estimates
    est_var_p <- max((ms[1] - ms[4]) / (ni * nr), 0)
    est_var_i <- max((ms[2] - ms[4]) / (np * nr), 0)
    est_var_r <- max((ms[3] - ms[4]) / (np * ni), 0)
    est_var_e <- max(ms[4], 0)
    est_total <- est_var_p + est_var_i + est_var_r + est_var_e
  
    # G-coefficient
    g_coef <- est_var_p / (est_var_p + est_var_i / ni + est_var_r / nr + est_var_e / (ni * nr))
  
    gt_data(list(
      est_var_p = est_var_p, est_var_i = est_var_i,
      est_var_r = est_var_r, est_var_e = est_var_e,
      est_total = est_total, g_coef = g_coef,
      ni = ni, nr = nr
    ))
  })
  
  output$gt_vc_table <- renderUI({
    res <- gt_data(); req(res)
    pct <- function(v) round(100 * v / res$est_total, 1)
    div(style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$thead(tags$tr(tags$th("Source"), tags$th("Variance"), tags$th("% of Total"))),
        tags$tr(tags$td("Person (object of measurement)"), tags$td(round(res$est_var_p, 4)),
                tags$td(paste0(pct(res$est_var_p), "%"))),
        tags$tr(tags$td("Item"), tags$td(round(res$est_var_i, 4)),
                tags$td(paste0(pct(res$est_var_i), "%"))),
        tags$tr(tags$td("Rater"), tags$td(round(res$est_var_r, 4)),
                tags$td(paste0(pct(res$est_var_r), "%"))),
        tags$tr(tags$td("Residual / Error"), tags$td(round(res$est_var_e, 4)),
                tags$td(paste0(pct(res$est_var_e), "%")))
      ),
      tags$hr(),
      tags$p(tags$strong("G-coefficient (\u03c1\u00b2): "), round(res$g_coef, 4),
             style = "font-size: 1.1rem;")
    )
  })
  
  output$gt_pie_plot <- renderPlotly({
    res <- gt_data(); req(res)
    vals <- c(res$est_var_p, res$est_var_i, res$est_var_r, res$est_var_e)
    labels <- c("Person", "Item", "Rater", "Residual")
    pcts <- round(100 * vals / sum(vals), 1)

    hover_txt <- paste0(labels, "<br>Variance: ", round(vals, 4),
                        "<br>", pcts, "%")

    plotly::plot_ly(
      labels = labels, values = vals,
      type = "pie",
      marker = list(colors = c("#238b45", "#41ae76", "#e31a1c", "#999999"),
                    line = list(color = "white", width = 2)),
      textinfo = "label+percent",
      hoverinfo = "text", text = hover_txt,
      hole = 0.3
    ) |>
      plotly::layout(
        showlegend = FALSE,
        margin = list(t = 30, b = 10)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  
  output$gt_dstudy_plot <- renderPlotly({
    res <- gt_data(); req(res)
    items_seq <- seq(2, 30, 1)
    raters_seq <- c(1, 2, 3, 5)

    ds <- expand.grid(Items = items_seq, Raters = raters_seq)
    ds$G <- res$est_var_p / (res$est_var_p + res$est_var_i / ds$Items +
              res$est_var_r / ds$Raters + res$est_var_e / (ds$Items * ds$Raters))
    ds$Raters_label <- paste0(ds$Raters, " rater", ifelse(ds$Raters > 1, "s", ""))
    ds$text <- paste0(ds$Raters_label,
                      "<br>Items: ", ds$Items,
                      "<br>\u03c1\u00b2 = ", round(ds$G, 4))

    dark2 <- RColorBrewer::brewer.pal(4, "Dark2")
    rater_lvls <- unique(ds$Raters_label)

    p <- plot_ly()
    for (i in seq_along(rater_lvls)) {
      d <- ds[ds$Raters_label == rater_lvls[i], ]
      p <- p |> add_trace(x = d$Items, y = d$G, type = "scatter", mode = "lines",
                           name = rater_lvls[i],
                           line = list(color = dark2[i], width = 2),
                           hoverinfo = "text", text = d$text)
    }
    p |>
      add_trace(x = res$ni, y = res$g_coef, type = "scatter", mode = "markers",
                marker = list(color = "#e31a1c", size = 8),
                hoverinfo = "text",
                text = paste0("Current design<br>Items: ", res$ni,
                               "<br>\u03c1\u00b2 = ", round(res$g_coef, 4)),
                showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Number of items"),
        yaxis = list(title = "Generalizability coefficient (\u03c1\u00b2)", range = c(0, 1)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.7, y1 = 0.7,
               line = list(color = "grey70", dash = "dash", width = 1)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.8, y1 = 0.8,
               line = list(color = "grey70", dash = "dash", width = 1)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 0.9, y1 = 0.9,
               line = list(color = "grey70", dash = "dash", width = 1))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = "Red dot = current design",
               showarrow = FALSE, font = list(size = 12)),
          list(x = 1.02, xref = "paper", y = 0.7, text = "0.70",
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "grey50")),
          list(x = 1.02, xref = "paper", y = 0.8, text = "0.80",
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "grey50")),
          list(x = 1.02, xref = "paper", y = 0.9, text = "0.90",
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "grey50"))
        ),
        margin = list(t = 40)
      )
  })
  

  # ── Item Generation ────────────────────────────────────────
  aig_data <- reactiveVal(NULL)

  observeEvent(input$aig_go, {
    n <- input$aig_n_items
    diff_lo <- input$aig_diff_range[1]; diff_hi <- input$aig_diff_range[2]
    domain <- input$aig_domain
    set.seed(sample.int(10000, 1))

    if (domain == "arith") {
      # Arithmetic: feature = number of operations + operand size
      n_ops <- sample(1:4, n, replace = TRUE)
      op_size <- sample(c(1, 2, 3), n, replace = TRUE)
      feature <- n_ops + 0.5 * op_size
      diff <- diff_lo + (feature - min(feature)) / (max(feature) - min(feature)) *
              (diff_hi - diff_lo) + rnorm(n, 0, 0.3)

      items <- paste0(
        sapply(seq_len(n), function(i) {
          ops <- sample(c("+", "-", "*"), n_ops[i], replace = TRUE)
          nums <- sample(10^op_size[i]:(10^(op_size[i]+1)-1), n_ops[i] + 1)
          paste(nums[1], paste(ops, nums[-1], collapse = " "), sep = " ")
        }), " = ?")

      feature_name <- "Complexity (ops + operand size)"
      feat_df <- data.frame(Item = seq_len(n), Stem = items,
                             Operations = n_ops, `Operand Size` = op_size,
                             Complexity = round(feature, 2),
                             `Predicted b` = round(diff, 2),
                             check.names = FALSE)
    } else if (domain == "analogy") {
      vocab_size <- sample(c(1, 2, 3), n, replace = TRUE)
      feature <- vocab_size
      diff <- diff_lo + (feature - 1) / 2 * (diff_hi - diff_lo) + rnorm(n, 0, 0.4)
      items <- paste0("A : B :: C : ?  [complexity ", vocab_size, "]")
      feature_name <- "Vocabulary level"
      feat_df <- data.frame(Item = seq_len(n), Stem = items,
                             `Vocab Level` = vocab_size,
                             `Predicted b` = round(diff, 2),
                             check.names = FALSE)
    } else {
      n_rotations <- sample(0:3, n, replace = TRUE)
      n_elements <- sample(2:6, n, replace = TRUE)
      feature <- n_rotations + 0.3 * n_elements
      diff <- diff_lo + (feature - min(feature)) / max(1, max(feature) - min(feature)) *
              (diff_hi - diff_lo) + rnorm(n, 0, 0.3)
      items <- paste0("Spatial item with ", n_rotations, " rotations, ", n_elements, " elements")
      feature_name <- "Spatial complexity"
      feat_df <- data.frame(Item = seq_len(n), Stem = items,
                             Rotations = n_rotations, Elements = n_elements,
                             Complexity = round(feature, 2),
                             `Predicted b` = round(diff, 2),
                             check.names = FALSE)
    }

    aig_data(list(items = feat_df, feature = feature, diff = diff,
                  feature_name = feature_name))
  })

  output$aig_items <- renderTable({
    res <- aig_data()
    req(res)
    res$items
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$aig_plot <- renderPlotly({
    res <- aig_data()
    req(res)
    feat  <- res$feature
    diff  <- res$diff
    fit   <- lm(diff ~ feat)
    xseq  <- seq(min(feat), max(feat), length.out = 50)
    yhat  <- predict(fit, newdata = data.frame(feat = xseq))

    plotly::plot_ly() |>
      plotly::add_markers(x = res$feature, y = res$diff,
                          marker = list(color = "#238b45", size = 8),
                          hoverinfo = "text", showlegend = FALSE,
                          text = paste0("Feature = ", round(res$feature, 2),
                                         "<br>Predicted b = ", round(res$diff, 2))) |>
      plotly::add_trace(x = xseq, y = as.numeric(yhat),
                        type = "scatter", mode = "lines",
                        line = list(color = "#e31a1c", width = 2),
                        showlegend = FALSE, hoverinfo = "skip") |>
      plotly::layout(
        xaxis = list(title = res$feature_name),
        yaxis = list(title = "Predicted difficulty (b)"),
        annotations = list(list(
          x = 0.5, y = 1.05, xref = "paper", yref = "paper",
          text = paste0("R\u00b2 = ", round(summary(fit)$r.squared, 3)),
          showarrow = FALSE, font = list(size = 12)
        )),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
