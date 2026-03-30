# Module: Adaptive & Computerized Testing (consolidated)
# Tabs: CAT Simulation | Classification Testing | Test Assembly

# ── UI ──────────────────────────────────────────────────────────────────
mod_adaptive_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Adaptive Testing",
  icon = icon("robot"),
  navset_card_underline(

    # ── Tab 1: CAT Simulation ────────────────────────────────────
    nav_panel(
      "CAT Simulation",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("cat_bank_size"), "Item bank size", min = 20, max = 200, value = 60, step = 10),
            sliderInput(ns("cat_max_items"), "Max items administered", min = 5, max = 50, value = 20, step = 1),
            sliderInput(ns("cat_true_theta"), "True ability (\u03b8)", min = -3, max = 3, value = 0.5, step = 0.25),
            sliderInput(ns("cat_se_stop"), "Stopping SE threshold", min = 0.1, max = 0.6, value = 0.3, step = 0.05),
            actionButton(ns("cat_go"), "Run CAT", class = "btn-success w-100 mb-2"),
            actionButton(ns("cat_reset"), "Reset", class = "btn-outline-secondary w-100")
          ),
          explanation_box(
            tags$strong("Computerized Adaptive Testing (CAT)"),
            tags$p("CAT selects items in real-time based on the examinee's estimated ability.
                    After each response, the ability estimate is updated and the next item is chosen
                    to maximize information at the current estimate. This yields precise measurement
                    with fewer items than a fixed-length test."),
            tags$p("The algorithm: (1) Start with an initial \u03b8 estimate; (2) Select the most
                    informative unused item; (3) Update \u03b8 via maximum likelihood; (4) Stop when
                    SE falls below a threshold or max items are reached."),
          tags$p("CAT typically requires 40\u201360% fewer items than a fixed-length test to
                  achieve the same measurement precision, because every item is targeted at
                  the examinee\u2019s estimated ability. However, CAT introduces challenges:
                  item exposure control (preventing popular items from becoming compromised),
                  content balancing (ensuring the adaptive algorithm selects items from all
                  required content areas), and the need for a large, well-calibrated item pool."),
            guide = tags$ol(
              tags$li("Set the item bank size and maximum test length."),
              tags$li("Choose a true ability level for the simulated examinee."),
              tags$li("Set the stopping SE threshold — lower = more precise but more items."),
              tags$li("Click 'Run CAT' to simulate the adaptive test."),
              tags$li("Watch the ability estimate converge to the true value step by step."),
              tags$li("The item map shows which items were selected from the bank.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Ability Estimate Convergence"),
                 plotlyOutput(ns("cat_convergence_plot"), height = "380px")),
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("Items Selected from Bank"),
                   plotlyOutput(ns("cat_item_map"), height = "340px")),
              card(card_header("CAT Summary"), uiOutput(ns("cat_summary")))
            )
          )
        )
    ),

    # ── Tab 2: Classification Testing ────────────────────────────
    nav_panel(
      "Classification Testing",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("cct_cut"), "Cut score (\u03b8)", min = -2, max = 2,
                        value = 0, step = 0.25),
            sliderInput(ns("cct_true_theta"), "True \u03b8 of examinee", min = -3, max = 3,
                        value = 0.3, step = 0.1),
            sliderInput(ns("cct_max_items"), "Maximum items", min = 10, max = 50,
                        value = 30, step = 5),
            sliderInput(ns("cct_alpha"), "Type I error rate (\u03b1)", min = 0.01, max = 0.1,
                        value = 0.05, step = 0.01),
            actionButton(ns("cct_go"), "Simulate", class = "btn-success w-100 mt-2")
          ),
          explanation_box(
            tags$strong("Computerized Classification Testing (CCT)"),
            tags$p("CCT is like CAT, but the goal is classification (pass/fail) rather
                    than precise ability estimation. It uses the Sequential Probability
                    Ratio Test (SPRT) to decide when enough evidence has accumulated."),
            tags$p("After each item, the SPRT computes the likelihood ratio of the
                    examinee being above vs. below the cut score. Testing stops when
                    the ratio exceeds a decision boundary."),
            tags$ul(
              tags$li(tags$strong("SPRT:"), " Compares H\u2080: \u03b8 = \u03b8_cut \u2212 \u03b4 vs H\u2081: \u03b8 = \u03b8_cut + \u03b4."),
              tags$li(tags$strong("Boundaries:"), " Lower = log(\u03b2/(1\u2212\u03b1)), Upper = log((1\u2212\u03b2)/\u03b1)."),
              tags$li("Testing stops early when the decision is clear, saving items for examinees far from the cut.")
            ),
          tags$p("Unlike CAT, which estimates a continuous ability score, CCT makes a binary
                  decision (pass/fail, master/non-master) as efficiently as possible. The
                  sequential probability ratio test (SPRT) monitors the cumulative evidence
                  after each item. Testing terminates when sufficient evidence accumulates for
                  either classification, keeping the error rates (false positive, false negative)
                  below specified thresholds."),
            guide = tags$ol(
              tags$li("Set the cut score and the examinee's true ability."),
              tags$li("Click 'Simulate' to watch the SPRT accumulate evidence."),
              tags$li("Examinees far from the cut are classified quickly; those near the cut require more items.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("SPRT Accumulation"),
                 plotlyOutput(ns("cct_sprt"), height = "400px")),
            card(card_header("Classification Result"), tableOutput(ns("cct_result")))
          )
        )
    ),

    # ── Tab 4: Multistage Testing ────────────────────────────────
    nav_panel(
      "Multistage Testing",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("mst_design"), "MST design",
            choices = c(
              "1-2  (2 stages, 3 modules)"  = "1_2",
              "1-3  (2 stages, 4 modules)"  = "1_3",
              "1-2-3 (3 stages, 6 modules)" = "1_2_3"
            ),
            selected = "1_2_3"
          ),
          sliderInput(ns("mst_items"), "Items per module",
                      min = 5, max = 20, value = 10, step = 1),
          sliderInput(ns("mst_theta"), "True ability (\u03b8)",
                      min = -3, max = 3, value = 0.5, step = 0.25),
          actionButton(ns("mst_run"), "Run simulation",
                       class = "btn-success w-100 mt-2", icon = icon("play"))
        ),
        explanation_box(
          tags$strong("Multistage Testing (MST)"),
          tags$p("MST divides a test into stages. Each stage contains one or more
                  pre-assembled \u2018modules\u2019 (small fixed item sets). After completing
                  a module, the examinee is routed to the next stage\u2019s module based
                  on their performance \u2014 harder if they scored well, easier if not."),
          tags$p("Unlike item-by-item CAT, routing decisions are made only between
                  stages. This lets examinees review and change answers within each
                  module, a key practical benefit for high-stakes tests."),
          tags$ul(
            tags$li(tags$strong("Stage 1:"), " All examinees see the same routing module."),
            tags$li(tags$strong("Stage 2+:"), " Modules vary in difficulty; harder for
                    high scorers, easier for low scorers."),
            tags$li(tags$strong("Routing rule:"), " Score < 40% \u2192 easier; 40\u201370%
                    \u2192 medium; > 70% \u2192 harder.")
          ),
          tags$p("MST is used in GMAT, NAEP, and many licensure exams. The 1-2-3 design
                  (1 routing module, 2 in stage\u00a02, 3 in stage\u00a03) is the most common,
                  providing six distinct measurement paths through the test."),
          tags$p("Compared to item-by-item CAT, MST offers several operational advantages:
                  test-takers can review and change answers within a module (impossible in
                  CAT where the next item depends on the current response), item exposure is
                  easier to control because entire modules are pre-assembled and vetted, and
                  the test can be reviewed for content coverage and fairness before delivery.
                  The trade-off is somewhat lower measurement efficiency, since adaptation
                  happens only between stages rather than after every item."),
          tags$p("Routing thresholds are a critical design decision. A conservative routing
                  rule (wide middle range) sends more examinees down the medium-difficulty
                  path, providing good measurement for the majority but less precise
                  measurement at the extremes. Aggressive routing (narrow thresholds)
                  classifies more examinees into hard or easy modules, improving precision
                  at the extremes but at the risk of mis-routing examinees who happen to
                  perform atypically on the routing stage due to measurement error.
                  Simulation studies are routinely used to evaluate routing rules before
                  operational deployment."),
          guide = tags$ol(
            tags$li("Choose a design: 1-2 (simple 2-stage), 1-3 (2-stage with 3 second-stage options), or 1-2-3 (full 3-stage)."),
            tags$li("Set items per module and a true ability level for the simulated examinee."),
            tags$li("Click \u2018Run simulation\u2019 to trace the examinee through the MST."),
            tags$li("The panel diagram highlights the actual path taken (blue = visited)."),
            tags$li("The ability plot shows how the \u03b8 estimate improves after each stage.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("MST Panel Structure"),
                 plotOutput(ns("mst_routing_plot"), height = "380px")),
            card(full_screen = TRUE, card_header("Ability Estimate by Stage"),
                 plotlyOutput(ns("mst_theta_plot"), height = "380px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Items Administered (by Stage)"),
                 plotlyOutput(ns("mst_items_plot"), height = "300px")),
            card(card_header("MST Summary"), uiOutput(ns("mst_summary")))
          )
        )
      )
    ),

    # ── Tab 4: Test Assembly ─────────────────────────────────────
    nav_panel(
      "Test Assembly",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            sliderInput(ns("ta_bank_size"), "Item bank size", min = 20, max = 200, value = 50, step = 10),
            sliderInput(ns("ta_test_length"), "Test length (items to select)", min = 5, max = 50, value = 20, step = 1),
            selectInput(ns("ta_target"), "Target information shape",
              choices = c("Flat (uniform precision)" = "flat",
                          "Peaked at \u03b8 = 0" = "peaked",
                          "Two peaks (\u03b8 = \u00b11)" = "bimodal"),
              selected = "peaked"
            ),
            sliderInput(ns("ta_target_level"), "Target information level", min = 2, max = 20, value = 8, step = 1),
            actionButton(ns("ta_run"), "Assemble test", icon = icon("play"),
                         class = "btn-success w-100 mt-2")
          ),
      
          explanation_box(
            tags$strong("Automated Test Assembly"),
            tags$p("Given an item bank with known IRT parameters, test assembly selects a
                    subset of items whose combined test information function (TIF) best
                    matches a target. This is crucial for constructing tests with
                    desired measurement precision at specific ability levels."),
            tags$p("This module uses a greedy algorithm: at each step it adds the item
                    that most reduces the difference between the current TIF and the target."),
          tags$p("Automated test assembly uses mathematical optimisation (typically mixed-integer
                  programming) to select items that satisfy multiple constraints simultaneously:
                  content specifications, target information function, enemy items (items that
                  must not appear together), exposure limits, and item format requirements.
                  This produces tests that are both psychometrically optimal and practically
                  valid \u2014 something manual assembly struggles to achieve consistently."),
          tags$p("The target information function determines where the test measures most
                  precisely. A flat target provides uniform measurement across the ability
                  range, suitable for norm-referenced tests. A peaked target concentrated
                  around a cut score maximises precision where it matters most for
                  classification decisions. Multiple peaked targets can be used for tests
                  with multiple performance levels."),
            guide = tags$ol(
              tags$li("Set the item bank size and test length."),
              tags$li("Choose a target shape: flat for broad measurement, peaked for precision around \u03b8 = 0."),
              tags$li("Click 'Assemble test' to see the selected items and how well the TIF matches the target."),
              tags$li("The bottom plot shows the item bank parameters and which items were selected.")
            )
          ),
      
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE, card_header("Test Information vs. Target"),
                 plotlyOutput(ns("ta_tif_plot"), height = "380px")),
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("Item Bank (a vs. b)"),
                   plotlyOutput(ns("ta_bank_plot"), height = "340px")),
              card(full_screen = TRUE, card_header("Selected Item ICCs"),
                   plotlyOutput(ns("ta_icc_plot"), height = "340px"))
            )
          )
        )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_adaptive_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── CAT Simulation ─────────────────────────────────────────
  cat_data <- reactiveVal(NULL)
  
  observeEvent(input$cat_reset, {
    updateSliderInput(session, "cat_bank_size", value = 60)
    updateSliderInput(session, "cat_max_items", value = 20)
    updateSliderInput(session, "cat_true_theta", value = 0.5)
    updateSliderInput(session, "cat_se_stop", value = 0.3)
    cat_data(NULL)
  })
  
  observeEvent(input$cat_go, {
    set.seed(sample(1:10000, 1))
    bank_size <- input$cat_bank_size
    max_items <- min(input$cat_max_items, bank_size)
    true_theta <- input$cat_true_theta
    se_stop <- input$cat_se_stop
  
    # Generate item bank
    b_bank <- sort(runif(bank_size, -3, 3))
    a_bank <- runif(bank_size, 0.5, 2.5)
  
    # CAT algorithm
    theta_hat <- 0  # initial estimate
    used <- integer(0)
    all_responses <- numeric(0)
    history <- data.frame(Step = integer(), Theta = numeric(), SE = numeric(),
                          Response = integer(), ItemB = numeric())

    for (step in seq_len(max_items)) {
      available <- setdiff(seq_len(bank_size), used)
      if (length(available) == 0) break

      info_avail <- sapply(available, function(j) {
        p <- 1 / (1 + exp(-a_bank[j] * (theta_hat - b_bank[j])))
        a_bank[j]^2 * p * (1 - p)
      })

      best <- available[which.max(info_avail)]
      used <- c(used, best)

      p_correct <- 1 / (1 + exp(-a_bank[best] * (true_theta - b_bank[best])))
      response <- rbinom(1, 1, p_correct)
      all_responses <- c(all_responses, response)

      # Update theta via MLE (Newton-Raphson)
      for (iter in 1:20) {
        p_vec <- 1 / (1 + exp(-a_bank[used] * (theta_hat - b_bank[used])))
        p_vec <- pmin(pmax(p_vec, 1e-6), 1 - 1e-6)

        grad <- sum(a_bank[used] * (all_responses - p_vec))
        hess <- -sum(a_bank[used]^2 * p_vec * (1 - p_vec))
        if (abs(hess) < 1e-10) break
        delta <- grad / hess
        theta_hat <- theta_hat - delta
        theta_hat <- pmin(pmax(theta_hat, -4), 4)
        if (abs(delta) < 1e-4) break
      }
  
      # SE
      p_vec <- 1 / (1 + exp(-a_bank[used] * (theta_hat - b_bank[used])))
      info_total <- sum(a_bank[used]^2 * p_vec * (1 - p_vec))
      se <- 1 / sqrt(max(info_total, 0.01))
  
      history <- rbind(history, data.frame(
        Step = step, Theta = theta_hat, SE = se,
        Response = response, ItemB = b_bank[best]
      ))
  
      if (se < se_stop) break
    }
  
    cat_data(list(
      history = history, used = used, b_bank = b_bank, a_bank = a_bank,
      true_theta = true_theta, bank_size = bank_size,
      final_theta = theta_hat, final_se = se
    ))
  })
  
  output$cat_convergence_plot <- renderPlotly({
    res <- cat_data(); req(res)
    h <- res$history
    ci_lo <- h$Theta - 1.96 * h$SE
    ci_hi <- h$Theta + 1.96 * h$SE

    hover_line <- paste0("Step ", h$Step,
                          "<br>\u03b8\u0302 = ", round(h$Theta, 3),
                          "<br>SE = ", round(h$SE, 3),
                          "<br>Response: ", ifelse(h$Response == 1, "Correct", "Incorrect"))

    correct <- h$Response == 1
    plot_ly() |>
      # CI ribbon
      add_trace(x = c(h$Step, rev(h$Step)),
                y = c(ci_hi, rev(ci_lo)),
                type = "scatter", mode = "lines", fill = "toself",
                fillcolor = "rgba(35,139,69,0.12)", line = list(width = 0),
                showlegend = FALSE, hoverinfo = "skip") |>
      # Main line
      add_trace(x = h$Step, y = h$Theta, type = "scatter", mode = "lines",
                line = list(color = "#238b45", width = 2),
                hoverinfo = "text", text = hover_line, showlegend = FALSE) |>
      # Correct responses
      { \(p) if (any(correct)) p |>
        add_trace(x = h$Step[correct], y = h$Theta[correct],
                  type = "scatter", mode = "markers", name = "Correct",
                  marker = list(color = "#238b45", size = 8, symbol = "circle"),
                  hoverinfo = "skip") else p }() |>
      # Incorrect responses
      { \(p) if (any(!correct)) p |>
        add_trace(x = h$Step[!correct], y = h$Theta[!correct],
                  type = "scatter", mode = "markers", name = "Incorrect",
                  marker = list(color = "#238b45", size = 8, symbol = "x"),
                  hoverinfo = "skip") else p }() |>
      layout(
        xaxis = list(title = "Item Number"),
        yaxis = list(title = "Ability Estimate (\u03b8\u0302)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.05),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = res$true_theta, y1 = res$true_theta,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 0.5, y = 1.10, xref = "paper", yref = "paper",
               text = "Shaded band = 95% CI", showarrow = FALSE,
               font = list(size = 12)),
          list(x = 1.02, xref = "paper", y = res$true_theta,
               text = paste0("True \u03b8 = ", res$true_theta),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      )
  })

  output$cat_item_map <- renderPlotly({
    res <- cat_data(); req(res)
    sel <- seq_along(res$b_bank) %in% res$used
    order_vec <- rep(NA_integer_, length(res$b_bank))
    order_vec[res$used] <- seq_along(res$used)

    hover_sel <- paste0("Item ", which(sel), "<br>b = ", round(res$b_bank[sel], 2),
                         "<br>Order: ", order_vec[sel])
    hover_unsel <- paste0("Item ", which(!sel), "<br>b = ", round(res$b_bank[!sel], 2))

    p <- plot_ly()
    if (any(!sel)) {
      p <- p |>
        add_trace(x = res$b_bank[!sel], y = which(!sel),
                  type = "scatter", mode = "markers",
                  marker = list(color = "grey70", size = 4, opacity = 0.3),
                  hoverinfo = "text", text = hover_unsel,
                  showlegend = FALSE)
    }
    if (any(sel)) {
      p <- p |>
        add_trace(x = res$b_bank[sel], y = which(sel),
                  type = "scatter", mode = "markers",
                  marker = list(color = "#238b45", size = 8),
                  hoverinfo = "text", text = hover_sel,
                  showlegend = FALSE)
    }
    p |>
      layout(
        xaxis = list(title = "Item Difficulty (b)"),
        yaxis = list(title = "Item Index"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = "Hover for selection order", showarrow = FALSE,
               font = list(size = 12)),
          list(x = res$true_theta, y = 1.02, yref = "paper",
               text = paste0("True \u03b8 = ", res$true_theta),
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      )
  })
  
  output$cat_summary <- renderUI({
    res <- cat_data(); req(res)
    h <- res$history
    div(style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm",
        tags$tr(tags$td(tags$strong("True \u03b8")), tags$td(res$true_theta)),
        tags$tr(tags$td(tags$strong("Final \u03b8\u0302")), tags$td(round(res$final_theta, 3))),
        tags$tr(tags$td(tags$strong("Final SE")), tags$td(round(res$final_se, 3))),
        tags$tr(tags$td(tags$strong("Bias")),
                tags$td(round(res$final_theta - res$true_theta, 3))),
        tags$tr(tags$td(tags$strong("Items administered")), tags$td(nrow(h))),
        tags$tr(tags$td(tags$strong("Items in bank")), tags$td(res$bank_size)),
        tags$tr(tags$td(tags$strong("Correct responses")),
                tags$td(paste0(sum(h$Response), " / ", nrow(h),
                               " (", round(100 * mean(h$Response), 1), "%)")))
      )
    )
  })
  

  # ── Classification Testing ─────────────────────────────────
  cct_data <- reactiveVal(NULL)

  observeEvent(input$cct_go, {
    cut <- input$cct_cut; true_theta <- input$cct_true_theta
    max_items <- input$cct_max_items; alpha <- input$cct_alpha
    set.seed(sample.int(10000, 1))
    beta <- alpha  # symmetric error rates

    delta <- 0.5  # indifference region half-width
    theta_0 <- cut - delta  # H0: fail
    theta_1 <- cut + delta  # H1: pass

    upper <- log((1 - beta) / alpha)
    lower <- log(beta / (1 - alpha))

    # Item bank
    b <- sort(runif(max_items * 2, -3, 3))
    a <- runif(length(b), 0.5, 2.5)

    cum_lr <- 0
    lr_path <- numeric(max_items)
    items_used <- integer(max_items)
    responses <- integer(max_items)
    decision <- "Indeterminate"
    n_used <- max_items

    available <- seq_along(b)
    for (k in seq_len(max_items)) {
      # Select most informative item at cut
      info_at_cut <- a[available]^2 * 0.25  # max info for 2PL at b=theta
      info_diff <- abs(b[available] - cut)
      # Prefer items near the cut
      scores <- a[available]^2 / (1 + info_diff^2)
      best <- available[which.max(scores)]
      items_used[k] <- best
      available <- setdiff(available, best)

      # Simulate response
      p <- 1 / (1 + exp(-a[best] * (true_theta - b[best])))
      resp <- rbinom(1, 1, p)
      responses[k] <- resp

      # SPRT log-likelihood ratio
      p1 <- 1 / (1 + exp(-a[best] * (theta_1 - b[best])))
      p0 <- 1 / (1 + exp(-a[best] * (theta_0 - b[best])))
      if (resp == 1) {
        cum_lr <- cum_lr + log(p1 / p0)
      } else {
        cum_lr <- cum_lr + log((1 - p1) / (1 - p0))
      }
      lr_path[k] <- cum_lr

      if (cum_lr >= upper) { decision <- "Pass"; n_used <- k; break }
      if (cum_lr <= lower) { decision <- "Fail"; n_used <- k; break }
    }

    cct_data(list(lr_path = lr_path[seq_len(n_used)],
                  upper = upper, lower = lower,
                  decision = decision, n_used = n_used,
                  true_theta = true_theta, cut = cut,
                  true_class = ifelse(true_theta >= cut, "Pass", "Fail")))
  })

  output$cct_sprt <- renderPlotly({
    res <- cct_data()
    req(res)
    items <- seq_along(res$lr_path)

    plotly::plot_ly() |>
      plotly::add_trace(x = items, y = res$lr_path,
                        type = "scatter", mode = "lines+markers",
                        line = list(color = "#238b45", width = 2),
                        marker = list(color = "#238b45", size = 6),
                        name = "Cumulative LR",
                        hoverinfo = "text",
                        text = paste0("Item ", items,
                                       "<br>Cum. LR = ", round(res$lr_path, 3))) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0.5, x1 = max(items) + 0.5,
               y0 = res$upper, y1 = res$upper,
               line = list(color = "#238b45", width = 1.5, dash = "dash")),
          list(type = "line", x0 = 0.5, x1 = max(items) + 0.5,
               y0 = res$lower, y1 = res$lower,
               line = list(color = "#e31a1c", width = 1.5, dash = "dash")),
          list(type = "line", x0 = 0.5, x1 = max(items) + 0.5,
               y0 = 0, y1 = 0,
               line = list(color = "grey60", width = 1))
        ),
        xaxis = list(title = "Item number", dtick = 5),
        yaxis = list(title = "Cumulative log-likelihood ratio"),
        annotations = list(
          list(x = max(items), y = res$upper,
               text = "Pass boundary", showarrow = FALSE,
               font = list(size = 10, color = "#238b45"), yanchor = "bottom"),
          list(x = max(items), y = res$lower,
               text = "Fail boundary", showarrow = FALSE,
               font = list(size = 10, color = "#e31a1c"), yanchor = "top")
        ),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$cct_result <- renderTable({
    res <- cct_data(); req(res)
    data.frame(
      Metric = c("True \u03b8", "Cut score", "True classification",
                  "CCT decision", "Items used", "Correct?"),
      Value = c(res$true_theta, res$cut, res$true_class,
                res$decision, res$n_used,
                ifelse(res$decision == res$true_class, "\u2713 Yes", "\u2717 No"))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Multistage Testing ─────────────────────────────────────
  mst_data <- reactiveVal(NULL)

  # MLE theta (same Newton-Raphson used in CAT)
  .mst_mle <- function(a, b, resp) {
    th <- 0
    for (iter in seq_len(30)) {
      p     <- pmin(pmax(1 / (1 + exp(-a * (th - b))), 1e-6), 1 - 1e-6)
      grad  <- sum(a * (resp - p))
      hess  <- -sum(a^2 * p * (1 - p))
      if (abs(hess) < 1e-10) break
      delta <- grad / hess
      th    <- max(min(th - delta, 4), -4)
      if (abs(delta) < 1e-5) break
    }
    th
  }

  observeEvent(input$mst_run, {
    set.seed(sample.int(10000, 1))
    design   <- input$mst_design
    ni       <- input$mst_items
    true_th  <- input$mst_theta

    # Generate modules: each has item parameters + metadata
    gen <- function(mu, n) list(a = runif(n, 0.8, 2.0), b = rnorm(n, mu, 0.5))
    mods <- list(
      S1   = gen(0,     ni),
      S2_E = gen(-1.2,  ni),
      S2_M = gen(0,     ni),
      S2_H = gen(1.2,   ni),
      S3_E = gen(-1.6,  ni),
      S3_M = gen(0,     ni),
      S3_H = gen(1.6,   ni)
    )

    # Routing helpers: proportion correct → difficulty level index
    r3 <- function(score) if (score / ni < 0.4) 1L else if (score / ni < 0.7) 2L else 3L
    r2 <- function(score) if (score / ni < 0.5) 1L else 2L

    sim_resp <- function(mod, theta) {
      rbinom(ni, 1, 1 / (1 + exp(-mod$a * (theta - mod$b))))
    }

    # Stage 1 — all examinees see the same routing module
    resp1    <- sim_resp(mods$S1, true_th)
    cum_a    <- mods$S1$a;  cum_b <- mods$S1$b;  cum_r <- resp1
    th_s1    <- .mst_mle(cum_a, cum_b, cum_r)
    path_ids <- "S1"
    s1_score <- sum(resp1)

    # Stage 2 — route based on Stage 1 score
    if (design == "1_2") {
      s2id <- if (r2(s1_score) == 1) "S2_E" else "S2_H"
    } else {
      s2id <- c("S2_E", "S2_M", "S2_H")[r3(s1_score)]
    }
    m2    <- mods[[s2id]]
    resp2 <- sim_resp(m2, true_th)
    cum_a <- c(cum_a, m2$a);  cum_b <- c(cum_b, m2$b);  cum_r <- c(cum_r, resp2)
    th_s2    <- .mst_mle(cum_a, cum_b, cum_r)
    path_ids <- c(path_ids, s2id)
    s2_score <- sum(resp2)

    # Stage 3 — only for 1-2-3 design
    th_s3 <- NULL
    if (design == "1_2_3") {
      # S2_E → {S3_E, S3_M};  S2_H → {S3_M, S3_H}
      s3id <- if (s2id == "S2_E") {
        if (r2(s2_score) == 1) "S3_E" else "S3_M"
      } else {
        if (r2(s2_score) == 1) "S3_M" else "S3_H"
      }
      m3    <- mods[[s3id]]
      resp3 <- sim_resp(m3, true_th)
      cum_a <- c(cum_a, m3$a);  cum_b <- c(cum_b, m3$b);  cum_r <- c(cum_r, resp3)
      th_s3    <- .mst_mle(cum_a, cum_b, cum_r)
      path_ids <- c(path_ids, s3id)
    }

    # Final theta & SE
    th_final <- if (!is.null(th_s3)) th_s3 else th_s2
    p_f      <- pmin(pmax(1 / (1 + exp(-cum_a * (th_final - cum_b))), 1e-6), 1 - 1e-6)
    se_final <- 1 / sqrt(max(sum(cum_a^2 * p_f * (1 - p_f)), 0.01))

    # Theta history and stage labels for convergence plot
    th_history  <- c(0, th_s1, th_s2, if (!is.null(th_s3)) th_s3)
    stg_labels  <- c("Prior", "After Stage\u00a01", "After Stage\u00a02",
                     if (!is.null(th_s3)) "After Stage\u00a03")

    # Items data frame for scatter plot
    n_stages_sim <- length(path_ids)
    items_df <- data.frame(
      b     = cum_b,
      a     = cum_a,
      resp  = cum_r,
      stage = rep(paste0("Stage ", seq_len(n_stages_sim)), each = ni)
    )

    # ── Diagram node positions ────────────────────────────────
    nodes_df <- switch(design,
      "1_2" = data.frame(
        id    = c("S1",        "S2_E",      "S2_H"),
        label = c("Stage 1\nMedium", "Stage 2\nEasy", "Stage 2\nHard"),
        cx = c(0, -1,  1),
        cy = c(2,  1,  1),
        stringsAsFactors = FALSE
      ),
      "1_3" = data.frame(
        id    = c("S1",        "S2_E",      "S2_M",        "S2_H"),
        label = c("Stage 1\nMedium", "Stage 2\nEasy", "Stage 2\nMedium", "Stage 2\nHard"),
        cx = c(0, -1.5,  0,  1.5),
        cy = c(2,  1,    1,  1),
        stringsAsFactors = FALSE
      ),
      "1_2_3" = data.frame(
        id    = c("S1",        "S2_E",       "S2_H",
                  "S3_E",      "S3_M",        "S3_H"),
        label = c("Stage 1\nMedium", "Stage 2\nEasy",   "Stage 2\nHard",
                  "Stage 3\nEasy",   "Stage 3\nMedium", "Stage 3\nHard"),
        cx = c(0,   -1.8,  1.8, -2.8,  0,  2.8),
        cy = c(3,    2,    2,    1,    1,  1),
        stringsAsFactors = FALSE
      )
    )
    nodes_df$in_path <- nodes_df$id %in% path_ids

    # ── Diagram edges ─────────────────────────────────────────
    edges_df <- switch(design,
      "1_2"   = data.frame(from = c("S1","S1"),
                            to   = c("S2_E","S2_H"),
                            stringsAsFactors = FALSE),
      "1_3"   = data.frame(from = c("S1","S1","S1"),
                            to   = c("S2_E","S2_M","S2_H"),
                            stringsAsFactors = FALSE),
      "1_2_3" = data.frame(
        from = c("S1","S1","S2_E","S2_E","S2_H","S2_H"),
        to   = c("S2_E","S2_H","S3_E","S3_M","S3_M","S3_H"),
        stringsAsFactors = FALSE
      )
    )
    # Mark edges that lie on the examinee's actual path
    edges_df$in_path <- mapply(function(f, t) {
      idx_f <- which(path_ids == f)
      any(idx_f < length(path_ids) & path_ids[idx_f + 1] == t)
    }, edges_df$from, edges_df$to)

    mst_data(list(
      nodes        = nodes_df,
      edges        = edges_df,
      path_ids     = path_ids,
      th_history   = th_history,
      stg_labels   = stg_labels,
      true_theta   = true_th,
      th_final     = th_final,
      se_final     = se_final,
      items_df     = items_df,
      design       = design,
      ni           = ni
    ))
  })

  # ── Routing diagram ──────────────────────────────────────────
  output$mst_routing_plot <- renderPlot({
    req(mst_data())
    res    <- mst_data()
    nodes  <- res$nodes
    edges  <- res$edges

    hw <- 0.72;  hh <- 0.30   # box half-width / half-height
    nodes$xmin <- nodes$cx - hw;  nodes$xmax <- nodes$cx + hw
    nodes$ymin <- nodes$cy - hh;  nodes$ymax <- nodes$cy + hh
    nodes$path_cat <- ifelse(nodes$in_path, "active", "inactive")

    # Segments: bottom of from-box → top of to-box
    seg_list <- lapply(seq_len(nrow(edges)), function(i) {
      f <- nodes[nodes$id == edges$from[i], ]
      t <- nodes[nodes$id == edges$to[i],   ]
      data.frame(x = f$cx, y = f$cy - hh,
                 xend = t$cx, yend = t$cy + hh,
                 path_cat = ifelse(edges$in_path[i], "active", "inactive"))
    })
    seg_df <- do.call(rbind, seg_list)

    # Stage labels on right margin
    stage_ys  <- sort(unique(nodes$cy), decreasing = TRUE)
    stage_lbl <- data.frame(
      x     = max(nodes$cx) + hw + 0.35,
      y     = stage_ys,
      label = paste0("Stage ", seq_along(stage_ys))
    )

    ggplot() +
      geom_segment(
        data = seg_df,
        aes(x = x, y = y, xend = xend, yend = yend, color = path_cat),
        linewidth = ifelse(seg_df$path_cat == "active", 1.8, 0.7),
        arrow = arrow(length = unit(0.10, "inches"), type = "closed"),
        linejoin = "mitre"
      ) +
      geom_rect(
        data = nodes,
        aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = path_cat),
        color = "white", linewidth = 1.2
      ) +
      geom_text(
        data = nodes,
        aes(x = cx, y = cy, label = label, color = path_cat),
        size = 3.4, lineheight = 0.9, fontface = "bold"
      ) +
      geom_text(
        data = stage_lbl,
        aes(x = x, y = y, label = label),
        hjust = 0, size = 3.5, color = "#657b83"
      ) +
      scale_fill_manual(
        values  = c("active" = "#268bd2", "inactive" = "#eee8d5"),
        guide   = "none"
      ) +
      scale_color_manual(
        values  = c("active" = "white",   "inactive" = "#657b83"),
        guide   = "none"
      ) +
      coord_cartesian(
        xlim = c(min(nodes$cx) - hw - 0.2, max(nodes$cx) + hw + 1.4),
        ylim = c(min(nodes$cy) - hh - 0.4, max(nodes$cy) + hh + 0.4)
      ) +
      theme_void() +
      theme(plot.background = element_rect(fill = "transparent", color = NA))
  }, bg = "transparent")

  # ── Theta convergence plot ────────────────────────────────────
  output$mst_theta_plot <- renderPlotly({
    req(mst_data())
    res <- mst_data()
    x_lbl <- factor(res$stg_labels, levels = res$stg_labels)

    plot_ly(
      x = x_lbl, y = res$th_history,
      type = "scatter", mode = "lines+markers",
      line   = list(color = "#268bd2", width = 2.5),
      marker = list(color = "#268bd2", size = 10),
      hoverinfo = "text",
      text = paste0(res$stg_labels, "<br>\u03b8\u0302 = ", round(res$th_history, 3))
    ) |>
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Ability Estimate (\u03b8\u0302)"),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = res$true_theta, y1 = res$true_theta,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = res$true_theta,
               text = paste0("True \u03b8 = ", res$true_theta),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 20, r = 80)
      ) |>
      config(displayModeBar = FALSE)
  })

  # ── Items administered scatter ────────────────────────────────
  output$mst_items_plot <- renderPlotly({
    req(mst_data())
    res <- mst_data()
    df  <- res$items_df
    stage_colors <- c("#268bd2", "#2aa198", "#859900")
    n_stg <- length(unique(df$stage))

    plot_ly(df,
      x = ~b, y = ~stage,
      type   = "scatter", mode = "markers",
      color  = ~stage,
      colors = stage_colors[seq_len(n_stg)],
      symbol = ~factor(resp, labels = c("Incorrect", "Correct")),
      symbols = c("circle-open", "circle"),
      marker = list(size = 9, opacity = 0.75),
      hoverinfo = "text",
      text = ~paste0("b = ", round(b, 2), "  a = ", round(a, 2),
                     "<br>", ifelse(resp == 1, "Correct", "Incorrect"),
                     "<br>", stage)
    ) |>
      layout(
        xaxis = list(title = "Item Difficulty (b)"),
        yaxis = list(title = ""),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.25, yanchor = "top", title = list(text = "")),
        shapes = list(
          list(type = "line",
               x0 = res$true_theta, x1 = res$true_theta,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = res$true_theta, y = 1.10, yref = "paper",
               text = paste0("True \u03b8 = ", res$true_theta),
               showarrow = FALSE, font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 30)
      ) |>
      config(displayModeBar = FALSE)
  })

  # ── MST summary card ─────────────────────────────────────────
  output$mst_summary <- renderUI({
    req(mst_data())
    res    <- mst_data()
    n_tot  <- length(res$path_ids) * res$ni
    path_str <- paste(gsub("_", "-", res$path_ids), collapse = " \u2192 ")
    design_str <- switch(res$design, "1_2"="1-2","1_3"="1-3","1_2_3"="1-2-3")

    div(style = "padding:10px; font-size:0.95rem;",
      tags$table(class = "table table-sm",
        tags$tr(tags$td(tags$strong("Design")),
                tags$td(design_str)),
        tags$tr(tags$td(tags$strong("True \u03b8")),
                tags$td(res$true_theta)),
        tags$tr(tags$td(tags$strong("Final \u03b8\u0302")),
                tags$td(round(res$th_final, 3))),
        tags$tr(tags$td(tags$strong("Bias")),
                tags$td(round(res$th_final - res$true_theta, 3))),
        tags$tr(tags$td(tags$strong("Final SE")),
                tags$td(round(res$se_final, 3))),
        tags$tr(tags$td(tags$strong("Stages")),
                tags$td(length(res$path_ids))),
        tags$tr(tags$td(tags$strong("Items per module")),
                tags$td(res$ni)),
        tags$tr(tags$td(tags$strong("Total items")),
                tags$td(n_tot)),
        tags$tr(tags$td(tags$strong("Path taken")),
                tags$td(path_str))
      )
    )
  })

  # ── Test Assembly ──────────────────────────────────────────

  ta_result <- reactiveVal(NULL)

  observeEvent(input$ta_run, {
    set.seed(sample.int(10000, 1))
    n_bank <- input$ta_bank_size
    n_test <- min(input$ta_test_length, n_bank)
    target_shape <- input$ta_target
    target_level <- input$ta_target_level

    theta <- seq(-4, 4, length.out = 200)

    # Generate item bank (2PL)
    a <- runif(n_bank, 0.5, 2.5)
    b <- runif(n_bank, -3, 3)

    # Item information function
    item_info <- function(a_i, b_i, th) {
      p <- 1 / (1 + exp(-a_i * (th - b_i)))
      a_i^2 * p * (1 - p)
    }

    # Target information function
    target_fn <- switch(target_shape,
      "flat"    = rep(target_level, length(theta)),
      "peaked"  = target_level * dnorm(theta, 0, 1) / dnorm(0, 0, 1),
      "bimodal" = target_level * (dnorm(theta, -1, 0.8) + dnorm(theta, 1, 0.8)) /
                  (dnorm(0, 0, 0.8))
    )

    # Info matrix: rows = items, cols = theta points
    info_mat <- sapply(seq_along(theta), function(j) {
      mapply(item_info, a, b, MoreArgs = list(th = theta[j]))
    })

    # Greedy assembly
    selected <- integer(0)
    remaining <- seq_len(n_bank)
    current_tif <- rep(0, length(theta))

    for (step in seq_len(n_test)) {
      sse <- sapply(remaining, function(i) {
        candidate <- current_tif + info_mat[i, ]
        sum((candidate - target_fn)^2)
      })
      best <- remaining[which.min(sse)]
      selected <- c(selected, best)
      remaining <- setdiff(remaining, best)
      current_tif <- current_tif + info_mat[best, ]
    }

    ta_result(list(
      theta = theta, a = a, b = b,
      selected = selected, target = target_fn,
      tif = current_tif, info_mat = info_mat,
      n_bank = n_bank, n_test = n_test
    ))
  })

  output$ta_tif_plot <- renderPlotly({
    req(ta_result())
    r <- ta_result()

    hover_tif <- paste0("\u03b8 = ", round(r$theta, 2),
                        "<br>TIF = ", round(r$tif, 3))
    hover_tgt <- paste0("\u03b8 = ", round(r$theta, 2),
                        "<br>Target = ", round(r$target, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = r$theta, y = r$tif,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_tif,
        name = "Selected TIF"
      ) |>
      plotly::add_trace(
        x = r$theta, y = r$target,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2, dash = "dash"),
        hoverinfo = "text", text = hover_tgt,
        name = "Target"
      ) |>
      plotly::layout(
        xaxis = list(title = "\u03b8 (Ability)"),
        yaxis = list(title = "Information"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(r$n_test, " items selected from bank of ", r$n_bank),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ta_bank_plot <- renderPlotly({
    req(ta_result())
    r <- ta_result()
    sel <- seq_len(r$n_bank) %in% r$selected
    col <- ifelse(sel, "#238b45", "grey70")
    lbl <- ifelse(sel, "Selected", "Not selected")

    hover_txt <- paste0("Item ", seq_len(r$n_bank),
                        "<br>b = ", round(r$b, 3),
                        "<br>a = ", round(r$a, 3),
                        "<br>", lbl)

    # Plot selected and not-selected as separate traces for legend
    idx_sel <- which(sel)
    idx_not <- which(!sel)

    p <- plotly::plot_ly()
    if (length(idx_not) > 0) {
      p <- p |> plotly::add_markers(
        x = r$b[idx_not], y = r$a[idx_not],
        marker = list(color = "grey70", size = 7, opacity = 0.5,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt[idx_not],
        name = "Not selected"
      )
    }
    if (length(idx_sel) > 0) {
      p <- p |> plotly::add_markers(
        x = r$b[idx_sel], y = r$a[idx_sel],
        marker = list(color = "#238b45", size = 7, opacity = 0.8,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt[idx_sel],
        name = "Selected"
      )
    }
    p |>
      plotly::layout(
        xaxis = list(title = "Difficulty (b)"),
        yaxis = list(title = "Discrimination (a)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ta_icc_plot <- renderPlotly({
    req(ta_result())
    r <- ta_result()
    sel <- r$selected

    p <- plotly::plot_ly()
    for (i in seq_along(sel)) {
      idx <- sel[i]
      prob <- 1 / (1 + exp(-r$a[idx] * (r$theta - r$b[idx])))
      hover_txt <- paste0("Item ", idx,
                          "<br>\u03b8 = ", round(r$theta, 2),
                          "<br>P = ", round(prob, 3))
      p <- p |>
        plotly::add_trace(
          x = r$theta, y = prob,
          type = "scatter", mode = "lines",
          line = list(color = "#238b45", width = 1),
          opacity = 0.4,
          hoverinfo = "text", text = hover_txt,
          name = paste0("Item ", idx), showlegend = FALSE
        )
    }
    p |> plotly::layout(
      xaxis = list(title = "\u03b8 (Ability)"),
      yaxis = list(title = "P(Correct)"),
      annotations = list(
        list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
             text = paste0(length(sel), " selected item ICCs"),
             showarrow = FALSE, font = list(size = 13))
      ),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load
  })
}
