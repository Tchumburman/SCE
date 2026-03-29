# Module: Clinical Trials
# 4 tabs: Randomisation · Blinding & Bias · Adaptive Designs · CONSORT & Reporting

# ── UI ────────────────────────────────────────────────────────────────────────
clinical_trials_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Clinical Trials",
  icon = icon("flask"),
  navset_card_underline(

    # ── Tab 1: Randomisation ──────────────────────────────────────────────────
    nav_panel(
      "Randomisation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ct_n"), "Total sample size N", 20, 500, 120, 20),
          selectInput(ns("ct_rand_method"), "Randomisation method",
            choices = c("Simple (coin flip)",
                        "Block (fixed block size)",
                        "Stratified block",
                        "Minimisation (adaptive)"),
            selected = "Block (fixed block size)"),
          conditionalPanel(ns = ns, "input.ct_rand_method == 'Block (fixed block size)'",
            sliderInput(ns("ct_block_size"), "Block size", 2, 12, 4, 2)),
          conditionalPanel(ns = ns, "input.ct_rand_method == 'Stratified block'",
            sliderInput(ns("ct_n_strata"), "Number of strata", 2, 6, 3, 1),
            sliderInput(ns("ct_block_strat"), "Block size per stratum", 2, 8, 4, 2)),
          actionButton(ns("ct_rand_go"), "Generate Allocation", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Randomisation in Clinical Trials"),
          tags$p("Randomisation eliminates selection bias and, in expectation, balances all
                  covariates (measured and unmeasured) between treatment arms. Key methods:"),
          tags$ul(
            tags$li(tags$strong("Simple randomisation"), " — each participant independently
                    assigned with 50% probability. Can produce imbalanced allocation, especially
                    in small trials."),
            tags$li(tags$strong("Block randomisation"), " — ensures balance within each block
                    of b participants. The block size should be concealed from investigators
                    to prevent allocation prediction."),
            tags$li(tags$strong("Stratified block"), " — blocks applied within each stratum
                    (e.g., centre, age group). Ensures balance on known prognostic factors."),
            tags$li(tags$strong("Minimisation"), " — adaptive procedure that minimises covariate
                    imbalance at each allocation. Deterministic in its pure form; stochastic
                    element (e.g., 80% to minimising arm) is recommended.")
          ),
          tags$p("An important distinction often overlooked is between randomisation and
                  allocation concealment. Randomisation determines the sequence in advance;
                  concealment prevents investigators from knowing or predicting the next
                  assignment before a participant is enrolled. Even a properly randomised
                  trial can be compromised if the allocation sequence is predictable
                  (e.g., transparent block sizes), allowing investigators to delay or
                  selectively enrol participants."),
          tags$p("Unequal randomisation (e.g., 2:1 treatment:control) is sometimes used to
                  increase exposure to a new treatment \u2014 important when the treatment
                  has learning-curve effects, or when participant preference and dropout
                  rates differ between arms. The statistical cost is modest: a 2:1 ratio
                  achieves about 89% of the power of 1:1 allocation with the same total n.
                  Response-adaptive randomisation takes this further by updating the ratio
                  dynamically, though this introduces statistical complexity and potential
                  selection bias if not implemented carefully."),
          guide = tags$ol(
            tags$li("Select a method and generate allocations."),
            tags$li("The allocation sequence shows treatment (T) and control (C) assignments."),
            tags$li("The balance plot shows cumulative imbalance across enrolled participants."),
            tags$li("Simple randomisation shows the widest swings; block randomisation is tightest.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Allocation Sequence"),
               plotlyOutput(ns("ct_alloc_seq"), height = "200px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Cumulative Balance"),
                 plotlyOutput(ns("ct_balance"), height = "260px")),
            card(card_header("Allocation Summary"),
                 tableOutput(ns("ct_alloc_table")))
          )
        )
      )
    ),

    # ── Tab 2: Blinding & Bias ─────────────────────────────────────────────────
    nav_panel(
      "Blinding & Bias",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ct_bias_n"), "Sample size n per arm", 30, 300, 100, 10),
          sliderInput(ns("ct_true_d"), "True treatment effect d", 0, 1.5, 0.5, 0.05),
          sliderInput(ns("ct_perf_bias"), "Performance bias (unblinded effect)",
                      0, 1, 0.2, 0.05),
          sliderInput(ns("ct_det_bias"), "Detection bias (assessor unblinded)",
                      0, 1, 0.15, 0.05),
          sliderInput(ns("ct_att_bias"), "Attrition rate difference (%)",
                      0, 40, 10, 5),
          actionButton(ns("ct_bias_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Blinding and Sources of Bias"),
          tags$p("The Cochrane Risk of Bias framework identifies key bias domains
                  in randomised trials:"),
          tags$ul(
            tags$li(tags$strong("Performance bias"), " — participants/providers aware of
                    allocation may behave differently. Blinding participants and care providers
                    prevents this."),
            tags$li(tags$strong("Detection bias"), " — unblinded outcome assessors may
                    differentially assess outcomes. Blinding assessors prevents this."),
            tags$li(tags$strong("Attrition bias"), " — differential dropout between arms.
                    Worse if dropout is related to outcome (MCAR vs. MNAR)."),
            tags$li(tags$strong("Selection bias"), " — prevented by allocation concealment
                    (e.g., centralised randomisation, sealed envelopes)."),
            tags$li(tags$strong("Reporting bias"), " — selectively reporting outcomes
                    based on results; addressed by pre-registration.")
          ),
          tags$p("Blinding is not always feasible. Surgical trials cannot blind surgeons;
                  behavioural interventions cannot blind participants to what they are
                  receiving. In these cases, the focus shifts to blinding outcome
                  assessors (single-blind assessment) and using objective or validated
                  outcomes that are less susceptible to detection bias. The PRECIS-2 tool
                  helps trials distinguish between explanatory (efficacy under ideal
                  conditions) and pragmatic (effectiveness in real-world settings) designs,
                  which affects the feasibility of blinding."),
          tags$p("The intention-to-treat (ITT) principle is a direct consequence of
                  randomisation: analysing all participants as allocated, regardless of
                  compliance, preserves the balance of covariates created by randomisation.
                  Excluding participants post-randomisation (e.g., per-protocol analyses)
                  can introduce selection bias comparable to a non-randomised study. The
                  estimand framework (ICH E9 addendum) formalises this by requiring
                  trialists to define precisely what question is being answered, including
                  how intercurrent events (dropout, crossover, rescue medication) are handled."),
          guide = tags$ol(
            tags$li("Set performance and detection bias magnitudes. These add to the true effect."),
            tags$li("The forest plot shows the biased vs. unbiased estimate."),
            tags$li("High attrition rate difference increases variance and potential MNAR bias."),
            tags$li("Double-blind trials eliminate performance + detection bias simultaneously.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Effect Estimate Decomposition"),
               plotlyOutput(ns("ct_bias_plot"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Risk of Bias Summary"),
                 uiOutput(ns("ct_rob_summary"))),
            card(card_header("Estimand Comparison"),
                 tableOutput(ns("ct_bias_table")))
          )
        )
      )
    ),

    # ── Tab 3: Adaptive Designs ───────────────────────────────────────────────
    nav_panel(
      "Adaptive Designs",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("ct_adapt_type"), "Adaptive design type",
            choices = c("Sample size re-estimation",
                        "Response-adaptive randomisation (RAR)",
                        "Seamless Phase II/III",
                        "Dose-finding (3+3 rule)"),
            selected = "Sample size re-estimation"),
          sliderInput(ns("ct_adapt_n_init"), "Initial sample size (per arm)", 20, 200, 60, 10),
          sliderInput(ns("ct_adapt_d_true"), "True effect d", 0, 1.5, 0.4, 0.05),
          sliderInput(ns("ct_adapt_nsim"), "Simulations", 100, 1000, 300, 100),
          actionButton(ns("ct_adapt_go"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Adaptive Clinical Trial Designs"),
          tags$p("Adaptive designs allow pre-planned modifications during a trial based on
                  accumulating data, while preserving Type I error control."),
          tags$ul(
            tags$li(tags$strong("Sample size re-estimation (SSR)"), " — increase n if
                    interim effect is smaller than planned. Blinded SSR (using pooled variance)
                    does not inflate Type I error; unblinded SSR requires alpha spending."),
            tags$li(tags$strong("Response-adaptive randomisation"), " — increase allocation
                    to the better-performing arm. Reduces exposure to inferior treatment
                    at the cost of some statistical efficiency."),
            tags$li(tags$strong("Seamless Phase II/III"), " — select the winning dose in Phase II
                    and carry forward to Phase III without stopping. Can dramatically reduce
                    development timelines."),
            tags$li(tags$strong("3+3 dose-finding"), " — classic Phase I design for MTD
                    (maximum tolerated dose) identification.")
          ),
          tags$p("Regulatory agencies (FDA, EMA) accept adaptive designs but require
                  pre-specification of all adaptations in the protocol and statistical
                  analysis plan before the trial begins. Unplanned modifications after
                  unblinded data review are not permitted and would invalidate the
                  Type I error control. Operational firewalls \u2014 typically an
                  independent data monitoring committee (IDMC) that views unblinded
                  data while the trial team remains blinded \u2014 are required for
                  unblinded SSR and RAR to prevent inadvertent information leakage."),
          tags$p("The key statistical challenge in adaptive designs is maintaining
                  the familywise Type I error rate at \u03b1 when the final sample size
                  or test statistic depends on interim data. Methods include the
                  combination test (Bauer & K\u00f6hne), conditional error function
                  approach, and alpha-spending functions (see Group-Sequential tab).
                  The price of adaptivity is design complexity \u2014 simulations
                  are typically required to verify operating characteristics before
                  regulatory submission."),
          guide = tags$ol(
            tags$li("Select an adaptive design. Click 'Simulate'."),
            tags$li("For SSR: observe how the final n distribution varies with the true effect."),
            tags$li("For RAR: compare proportion assigned to each arm over time."),
            tags$li("Compare to fixed-sample design power.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Adaptive Design Behaviour"),
               plotlyOutput(ns("ct_adapt_plot"), height = "340px")),
          card(card_header("Performance Summary"),
               tableOutput(ns("ct_adapt_table")))
        )
      )
    ),

    # ── Tab 4: CONSORT & Reporting ────────────────────────────────────────────
    nav_panel(
      "CONSORT & Reporting",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ct_consort_enrolled"), "Enrolled", 100, 2000, 500, 50),
          sliderInput(ns("ct_consort_excluded"), "Excluded (screening)", 0, 50, 15, 5),
          sliderInput(ns("ct_consort_dropout_t"), "Treatment arm dropout (%)", 0, 30, 8, 1),
          sliderInput(ns("ct_consort_dropout_c"), "Control arm dropout (%)", 0, 30, 5, 1),
          sliderInput(ns("ct_consort_excl_itt"), "Excluded from ITT analysis (%)", 0, 10, 2, 1),
          actionButton(ns("ct_consort_go"), "Generate CONSORT", icon = icon("diagram-project"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("CONSORT Reporting Standards"),
          tags$p("The CONSORT (Consolidated Standards of Reporting Trials) checklist
                  specifies what must be reported in a randomised trial publication.
                  The CONSORT flow diagram tracks participants at each stage:"),
          tags$ul(
            tags$li(tags$strong("Enrollment"), " — screened, eligible, randomised."),
            tags$li(tags$strong("Allocation"), " — how many received each treatment."),
            tags$li(tags$strong("Follow-up"), " — dropouts, protocol deviations."),
            tags$li(tags$strong("Analysis"), " — ITT vs. per-protocol populations.")
          ),
          tags$p("Key analysis populations:"),
          tags$ul(
            tags$li(tags$strong("ITT (Intention-to-Treat)"), " — analyse as randomised, regardless
                    of compliance. Preserves randomisation; estimates effectiveness."),
            tags$li(tags$strong("mITT (modified ITT)"), " — exclude participants who received no
                    study treatment. Most common in practice."),
            tags$li(tags$strong("PP (Per-Protocol)"), " — only completers with high adherence.
                    Estimates efficacy but may be biased by differential dropout.")
          ),
          tags$p("CONSORT compliance is mandatory for submission to most major medical
                  journals. Its importance extends beyond transparency: trials with
                  incomplete reporting have been shown to exaggerate effect sizes by
                  systematically omitting information about limitations, dropout, and
                  protocol deviations. Non-adherence to CONSORT is not just a
                  reporting inconvenience \u2014 it is a signal of potentially serious
                  methodological problems in the underlying trial."),
          tags$p("The ITT population in practice usually means mITT: excluding patients
                  who were randomised but never received any treatment (e.g., withdrew
                  consent before first dose). Choosing between ITT, mITT, and PP is
                  not merely a technical decision \u2014 it reflects the estimand (the
                  precise question the trial aims to answer). The ICH E9 addendum
                  (2019) introduced the estimand framework to standardise this: trials
                  are now expected to specify the target population, the variable of
                  interest, and how intercurrent events are handled before analysis begins."),
          guide = tags$ol(
            tags$li("Set enrollment and dropout numbers. Click 'Generate CONSORT'."),
            tags$li("The flow diagram shows participant tracking."),
            tags$li("Differential dropout (treatment vs. control) creates potential attrition bias."),
            tags$li("Compare ITT, mITT, and PP sample sizes.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("CONSORT Flow Diagram"),
               plotlyOutput(ns("ct_consort_flow"), height = "420px")),
          card(card_header("Analysis Population Summary"),
               tableOutput(ns("ct_consort_table")))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

clinical_trials_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1: Randomisation ───────────────────────────────────────────────────
  ct_alloc <- reactiveVal(NULL)
  observeEvent(input$ct_rand_go, {
    ct_alloc({
    set.seed(sample(9999, 1))
    N   <- input$ct_n
    mth <- input$ct_rand_method

    alloc <- switch(mth,
      "Simple (coin flip)" = {
        sample(c("T","C"), N, replace = TRUE)
      },
      "Block (fixed block size)" = {
        bs  <- input$ct_block_size
        n_blocks <- ceiling(N / bs)
        block_seq <- replicate(n_blocks, sample(c(rep("T", bs/2), rep("C", bs/2))))
        as.vector(block_seq)[1:N]
      },
      "Stratified block" = {
        ns <- input$ct_n_strata; bs <- input$ct_block_strat
        strata <- sample(seq_len(ns), N, replace = TRUE)
        alloc <- character(N)
        for (s in seq_len(ns)) {
          idx <- which(strata == s)
          n_s <- length(idx)
          n_b <- ceiling(n_s / bs)
          seq_s <- as.vector(replicate(n_b, sample(c(rep("T",bs/2),rep("C",bs/2)))))[1:n_s]
          alloc[idx] <- seq_s
        }
        alloc
      },
      "Minimisation (adaptive)" = {
        alloc <- character(N)
        n_t <- 0; n_c <- 0
        for (i in seq_len(N)) {
          p_t <- if (n_t < n_c) 0.8 else if (n_t > n_c) 0.2 else 0.5
          alloc[i] <- if (runif(1) < p_t) "T" else "C"
          if (alloc[i] == "T") n_t <- n_t + 1 else n_c <- n_c + 1
        }
        alloc
      }
    )
    alloc
    })
  })

  output$ct_alloc_seq <- renderPlotly({
    req(ct_alloc())
    a  <- ct_alloc()
    n  <- length(a)
    cols <- ifelse(a == "T", "#268bd2", "#dc322f")
    plot_ly(x = seq_len(n), y = rep(1, n), type = "scatter", mode = "markers",
            marker = list(color = cols, size = 8, symbol = "square"),
            text = a, hovertemplate = "Position %{x}: %{text}<extra></extra>",
            showlegend = FALSE) |>
      layout(xaxis = list(title = "Enrollment order"),
             yaxis = list(showticklabels = FALSE, zeroline = FALSE),
             title = list(text = "Blue = Treatment, Red = Control", font = list(size = 11)))
  })

  output$ct_balance <- renderPlotly({
    req(ct_alloc())
    a   <- ct_alloc()
    cum <- cumsum(ifelse(a == "T", 1, -1))
    plot_ly(x = seq_along(cum), y = cum, type = "scatter", mode = "lines",
            line = list(color = "#268bd2", width = 2),
            hovertemplate = "n=%{x}: imbalance=%{y}<extra></extra>") |>
      add_lines(x = c(1, length(cum)), y = c(0, 0),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Participants enrolled"),
             yaxis = list(title = "Cumulative T \u2212 C"),
             title = list(text = "0 = perfect balance", font = list(size = 11)))
  })

  output$ct_alloc_table <- renderTable({
    req(ct_alloc())
    a <- ct_alloc()
    data.frame(
      Arm         = c("Treatment", "Control", "Total"),
      n           = c(sum(a == "T"), sum(a == "C"), length(a)),
      Proportion  = round(c(mean(a == "T"), mean(a == "C"), 1), 3)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 2: Blinding & Bias ─────────────────────────────────────────────────
  ct_bias_sim <- reactiveVal(NULL)
  observeEvent(input$ct_bias_go, {
    ct_bias_sim({
    set.seed(sample(9999, 1))
    n  <- input$ct_bias_n; d_true <- input$ct_true_d
    pb <- input$ct_perf_bias; db <- input$ct_det_bias
    ab <- input$ct_att_bias / 100

    y_t <- rnorm(n, d_true + pb + db, 1)
    y_c <- rnorm(n, 0, 1)
    # Differential dropout
    drop_t <- rbinom(n, 1, ab / 2)
    drop_c <- rbinom(n, 1, 0)
    y_t_obs <- y_t[drop_t == 0]
    y_c_obs <- y_c[drop_c == 0]

    d_biased  <- mean(y_t) - mean(y_c)
    d_unbiased <- rnorm(1, d_true, 0.1)  # oracle if double-blind
    d_cc  <- mean(y_t_obs) - mean(y_c_obs)

    list(d_true = d_true, d_biased = d_biased,
         d_cc = d_cc, d_unbiased = d_unbiased,
         pb = pb, db = db, ab = ab)
    })
  })

  output$ct_bias_plot <- renderPlotly({
    req(ct_bias_sim())
    d <- ct_bias_sim()
    labs  <- c("Oracle\n(double-blind)", "Unblinded\n(performance+detection bias)", "Complete cases\n(attrition bias)")
    ests  <- c(d$d_unbiased, d$d_biased, d$d_cc)
    ses   <- c(0.05, 0.06, 0.08)
    cols  <- c("#859900", "#dc322f", "#b58900")
    plot_ly() |>
      add_markers(x = ests, y = labs,
                  error_x = list(array = 1.96 * ses),
                  marker = list(color = cols, size = 10)) |>
      add_lines(x = c(d$d_true, d$d_true), y = c(0.5, 3.5),
                line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
      layout(xaxis = list(title = "Estimated effect (d)"),
             yaxis = list(title = "", autorange = "reversed"),
             title = list(text = paste("True d =", d$d_true, "(grey dashed)"),
                          font = list(size = 11)))
  })

  output$ct_rob_summary <- renderUI({
    d <- ct_bias_sim()
    req(d)
    risk <- function(val, label) {
      col  <- if (val < 0.1) "#859900" else if (val < 0.3) "#b58900" else "#dc322f"
      lev  <- if (val < 0.1) "Low" else if (val < 0.3) "Some concern" else "High"
      tags$tr(tags$td(label),
              tags$td(style = paste0("color:", col, "; font-weight:600;"), lev))
    }
    tags$table(class = "table table-sm",
      tags$tbody(
        risk(d$pb, "Performance bias"),
        risk(d$db, "Detection bias"),
        risk(d$ab, "Attrition bias"),
        tags$tr(tags$td("Selection bias"), tags$td(style = "color:#859900; font-weight:600;", "Low (randomised)")),
        tags$tr(tags$td("Reporting bias"), tags$td(style = "color:#b58900; font-weight:600;", "Unknown"))
      )
    )
  })

  output$ct_bias_table <- renderTable({
    req(ct_bias_sim())
    d <- ct_bias_sim()
    data.frame(
      Estimand = c("True effect (oracle)", "Double-blind (no bias)", "Unblinded (biased)", "Complete cases"),
      d        = round(c(d$d_true, d$d_unbiased, d$d_biased, d$d_cc), 3),
      Bias     = round(c(0, d$d_unbiased - d$d_true, d$d_biased - d$d_true, d$d_cc - d$d_true), 3)
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 3: Adaptive Designs ────────────────────────────────────────────────
  ct_adapt_sim <- reactiveVal(NULL)
  observeEvent(input$ct_adapt_go, {
    ct_adapt_sim({
    set.seed(sample(9999, 1))
    n_init <- input$ct_adapt_n_init; d_true <- input$ct_adapt_d_true
    nsim   <- input$ct_adapt_nsim; type <- input$ct_adapt_type

    if (type == "Sample size re-estimation") {
      final_ns <- numeric(nsim); reject <- logical(nsim)
      for (s in seq_len(nsim)) {
        # Interim analysis at n_init
        y_t <- rnorm(n_init, d_true); y_c <- rnorm(n_init)
        d_int <- mean(y_t) - mean(y_c); se_int <- sqrt(2/n_init)
        # SSR: if interim d < planned d, increase n
        n_add <- if (abs(d_int) < d_true * 0.7) {
          # Re-estimate required n for 80% power
          n_needed <- ceiling(2 * (qnorm(0.975) + qnorm(0.8))^2 / max(d_int^2, 0.01))
          max(0, n_needed - n_init * 2)
        } else 0
        n_final <- n_init + n_add
        y_t2 <- c(y_t, rnorm(n_add + n_init)); y_c2 <- c(y_c, rnorm(n_add + n_init))
        t_stat <- (mean(y_t2) - mean(y_c2)) / sqrt(2 / length(y_t2))
        reject[s] <- abs(t_stat) > qnorm(0.975)
        final_ns[s] <- length(y_t2)
      }
      list(type = type, final_ns = final_ns, reject = reject,
           power = mean(reject), avg_n = mean(final_ns))

    } else if (type == "Response-adaptive randomisation (RAR)") {
      N <- n_init * 2; alpha <- 1; beta_p <- 1
      alloc_t_list <- numeric(nsim)
      for (s in seq_len(nsim)) {
        a_t <- alpha; b_t <- beta_p; a_c <- alpha; b_c <- beta_p
        n_t <- 0; n_c <- 0; y_t <- 0; y_c <- 0
        alloc_prop <- numeric(N)
        for (i in seq_len(N)) {
          p_t <- rbeta(1, a_t, b_t); p_c <- rbeta(1, a_c, b_c)
          rand_p <- p_t / (p_t + p_c)
          alloc_prop[i] <- rand_p
          if (runif(1) < rand_p) {
            n_t <- n_t + 1; resp <- rbinom(1, 1, plogis(d_true))
            y_t <- y_t + resp; a_t <- a_t + resp; b_t <- b_t + 1 - resp
          } else {
            n_c <- n_c + 1; resp <- rbinom(1, 1, 0.5)
            y_c <- y_c + resp; a_c <- a_c + resp; b_c <- b_c + 1 - resp
          }
        }
        alloc_t_list[s] <- n_t / N
      }
      list(type = type, alloc_t = alloc_t_list, power = NA,
           avg_alloc_t = mean(alloc_t_list), avg_n = N)

    } else {
      # Generic: show a power comparison
      n_seq <- seq(n_init, n_init * 3, n_init / 2)
      pwr   <- sapply(n_seq, function(nn)
        pnorm(d_true * sqrt(nn / 2) - qnorm(0.975)))
      list(type = type, n_seq = n_seq, pwr = pwr, power = NA,
           avg_n = n_init * 2)
    }
    })
  })

  output$ct_adapt_plot <- renderPlotly({
    req(ct_adapt_sim())
    r <- ct_adapt_sim()
    if (r$type == "Sample size re-estimation") {
      plot_ly(x = r$final_ns, type = "histogram",
              marker = list(color = "#268bd2"), nbinsx = 20) |>
        layout(xaxis = list(title = "Final sample size per arm"),
               yaxis = list(title = "Count"),
               title = list(text = paste("SSR: power =", round(r$power * 100, 1), "%"),
                            font = list(size = 12)))
    } else if (r$type == "Response-adaptive randomisation (RAR)") {
      plot_ly(x = r$alloc_t, type = "histogram",
              marker = list(color = "#268bd2"), nbinsx = 20) |>
        layout(xaxis = list(title = "Proportion assigned to treatment arm"),
               yaxis = list(title = "Count"),
               title = list(text = paste("RAR: mean prop to T =",
                                          round(r$avg_alloc_t, 3)),
                            font = list(size = 12)))
    } else {
      plot_ly(x = r$n_seq, y = r$pwr, type = "scatter", mode = "lines+markers",
              line = list(color = "#268bd2", width = 2)) |>
        add_lines(x = c(min(r$n_seq), max(r$n_seq)), y = c(0.8, 0.8),
                  line = list(color = "grey", dash = "dot"), showlegend = FALSE) |>
        layout(xaxis = list(title = "Sample size per arm"),
               yaxis = list(title = "Power", range = c(0, 1)))
    }
  })

  output$ct_adapt_table <- renderTable({
    req(ct_adapt_sim())
    r <- ct_adapt_sim()
    data.frame(
      Metric = c("Adaptive design type", "Average total N", "Power (if available)"),
      Value  = c(r$type, round(r$avg_n * 2, 0),
                 if (!is.na(r$power)) sprintf("%.1f%%", r$power * 100) else "—")
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 4: CONSORT Flow ────────────────────────────────────────────────────
  ct_consort <- reactiveVal(NULL)
  observeEvent(input$ct_consort_go, {
    ct_consort({
    enrolled  <- input$ct_consort_enrolled
    excl_rate <- input$ct_consort_excluded / 100
    drop_t    <- input$ct_consort_dropout_t / 100
    drop_c    <- input$ct_consort_dropout_c / 100
    excl_itt  <- input$ct_consort_excl_itt / 100

    screened      <- round(enrolled / (1 - excl_rate))
    excluded_scr  <- screened - enrolled
    randomised    <- enrolled
    n_t <- round(randomised / 2); n_c <- randomised - n_t
    dropout_t <- round(n_t * drop_t); dropout_c <- round(n_c * drop_c)
    comp_t <- n_t - dropout_t; comp_c <- n_c - dropout_c
    excl_t <- round(n_t * excl_itt); excl_c <- round(n_c * excl_itt)
    itt_t  <- n_t - excl_t; itt_c <- n_c - excl_c
    pp_t   <- comp_t; pp_c   <- comp_c

    list(screened = screened, excluded_scr = excluded_scr,
         randomised = randomised, n_t = n_t, n_c = n_c,
         dropout_t = dropout_t, dropout_c = dropout_c,
         comp_t = comp_t, comp_c = comp_c,
         itt_t = itt_t, itt_c = itt_c,
         pp_t = pp_t, pp_c = pp_c)
    })
  })

  output$ct_consort_flow <- renderPlotly({
    req(ct_consort())
    d <- ct_consort()

    # Build a simple CONSORT-like flow using annotations and shapes
    nodes <- data.frame(
      x = c(0.5, 0.5, 0.25, 0.75, 0.25, 0.75, 0.25, 0.75),
      y = c(0.95, 0.80, 0.65, 0.65, 0.50, 0.50, 0.30, 0.30),
      label = c(
        sprintf("Screened\nn = %d", d$screened),
        sprintf("Randomised\nn = %d", d$randomised),
        sprintf("Treatment arm\nn = %d", d$n_t),
        sprintf("Control arm\nn = %d", d$n_c),
        sprintf("Completed\nn = %d\n(dropout: %d)", d$comp_t, d$dropout_t),
        sprintf("Completed\nn = %d\n(dropout: %d)", d$comp_c, d$dropout_c),
        sprintf("ITT analysed\nn = %d", d$itt_t),
        sprintf("ITT analysed\nn = %d", d$itt_c)
      ),
      width = c(0.25, 0.25, 0.22, 0.22, 0.22, 0.22, 0.22, 0.22)
    )

    p <- plot_ly()
    # Draw boxes via shapes (invisible scatter + annotations)
    for (i in seq_len(nrow(nodes))) {
      p <- p |>
        add_annotations(
          x = nodes$x[i], y = nodes$y[i],
          text = nodes$label[i], showarrow = FALSE,
          font = list(size = 10),
          bgcolor = "#eee8d5",
          bordercolor = "#268bd2", borderwidth = 1.5,
          borderpad = 4,
          ax = 0, ay = 0
        )
    }

    # Excluded box
    p |>
      add_annotations(x = 0.82, y = 0.875,
                      text = sprintf("Excluded\nn = %d", d$excluded_scr),
                      showarrow = TRUE, arrowhead = 2,
                      ax = 30, ay = 0,
                      bgcolor = "#fdf6e3", bordercolor = "#dc322f",
                      font = list(size = 9, color = "#dc322f")) |>
      layout(
        xaxis = list(range = c(0, 1), showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(range = c(0.2, 1.05), showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        showlegend = FALSE,
        plot_bgcolor = "rgba(0,0,0,0)"
      )
  })

  output$ct_consort_table <- renderTable({
    req(ct_consort())
    d <- ct_consort()
    data.frame(
      Population = c("Screened", "Randomised",
                     "Treatment: enrolled", "Control: enrolled",
                     "Treatment: completed", "Control: completed",
                     "Treatment: ITT", "Control: ITT"),
      n = c(d$screened, d$randomised,
            d$n_t, d$n_c,
            d$comp_t, d$comp_c,
            d$itt_t, d$itt_c)
    )
  }, bordered = TRUE, striped = TRUE)

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Clinical Trials", list(ct_alloc, ct_bias_sim, ct_adapt_sim, ct_consort))
  })
}
