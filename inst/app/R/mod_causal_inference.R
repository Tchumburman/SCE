# ===========================================================================
# Module: Causal Inference
# DAGs, propensity scores, difference-in-differences, regression
# discontinuity, and instrumental variables
# ===========================================================================

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
causal_inference_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Causal Inference",
  icon = icon("scale-unbalanced"),
  navset_card_tab(
    id = ns("causal_tabs"),

    # ── Tab 1: DAGs & Confounding ──────────────────────────────────────
    nav_panel("DAGs & Confounding", icon = icon("diagram-project"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Causal Structure",
          tags$p(class = "text-muted small mb-2",
            "Choose a DAG structure and see how naive vs. correct
             adjustment changes the estimated causal effect of X on Y."),
          selectInput(ns("ci_dag_type"), "DAG Structure",
            choices = c("Confounding (X \u2190 Z \u2192 Y)" = "confound",
                        "Mediator (X \u2192 Z \u2192 Y)"   = "mediator",
                        "Collider (X \u2192 Z \u2190 Y)"   = "collider",
                        "M-Bias (butterfly)"               = "mbias"),
            selected = "confound"),
          tags$hr(),
          sliderInput(ns("ci_dag_n"), "Sample size", 200, 5000, 1000, step = 200),
          sliderInput(ns("ci_dag_bxy"), "True causal effect (X \u2192 Y)",
                      -1, 1, 0.5, step = 0.1),
          sliderInput(ns("ci_dag_conf_str"), "Confounder / path strength",
                      0, 1, 0.7, step = 0.1),
          actionButton(ns("ci_dag_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Directed Acyclic Graphs (DAGs) & Confounding"),
          tags$p("A DAG encodes assumptions about the causal structure
                  among variables. The key insight: which variables you
                  condition on (adjust for) can either remove bias or
                  introduce it."),
          tags$ul(
            tags$li(tags$strong("Confounding (X \u2190 Z \u2192 Y):"),
              " Z causes both X and Y. Failing to adjust for Z biases the
                X\u2192Y estimate. Adjusting removes the bias."),
            tags$li(tags$strong("Mediator (X \u2192 Z \u2192 Y):"),
              " Z is on the causal path. Adjusting for Z blocks the indirect
                effect and underestimates the total effect."),
            tags$li(tags$strong("Collider (X \u2192 Z \u2190 Y):"),
              " Z is a common effect. Adjusting for Z opens a spurious path
                between X and Y (collider bias). Do NOT adjust."),
            tags$li(tags$strong("M-Bias:"),
              " A butterfly structure where a naive adjustment for Z
                actually introduces bias. Shows that \u2018more control\u2019
                is not always better.")
          ),
          tags$p("The ", tags$strong("back-door criterion"), " tells us
                  exactly which variables to adjust for: block all back-door
                  paths from X to Y without opening new ones via colliders.
                  Pearl's do-calculus formalises this: we want P(Y | do(X)),
                  which differs from the observational P(Y | X) whenever
                  confounding is present."),
          tags$p("Understanding DAGs is fundamental to causal reasoning because
                  they make assumptions explicit and testable. A common mistake in
                  applied research is to adjust for every available covariate,
                  which can inadvertently condition on colliders or mediators
                  and introduce bias where none existed. Drawing and analysing
                  a DAG before specifying a regression model helps prevent
                  such errors."),
          tags$p("DAGs also clarify the distinction between prediction and causal
                  inference. A variable can be an excellent predictor of Y without
                  being on a causal path from X to Y — and including it in a
                  causal model may do more harm than good.")
        ),

        card(
          card_header("DAG Diagram"),
          uiOutput(ns("ci_dag_svg"))
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Naive Estimate (no adjustment)"),
            uiOutput(ns("ci_dag_naive"))
          ),
          card(
            card_header("Adjusted Estimate (conditioning on Z)"),
            uiOutput(ns("ci_dag_adjusted"))
          )
        ),

        card(
          card_header("Comparison & Lesson"),
          uiOutput(ns("ci_dag_lesson"))
        )
      )
    ),

    # ── Tab 2: Propensity Score Matching ────────────────────────────────
    nav_panel("Propensity Scores", icon = icon("balance-scale-left"),
      layout_sidebar(
        sidebar = sidebar(
          title = "Propensity Score Setup",
          tags$p(class = "text-muted small mb-2",
            "Simulate an observational study where treatment assignment
             depends on covariates. Compare naive, regression-adjusted,
             and propensity-score estimates."),
          sliderInput(ns("ci_ps_n"), "Sample size", 200, 5000, 1000, step = 200),
          sliderInput(ns("ci_ps_ate"), "True treatment effect (ATE)",
                      -2, 2, 0.8, step = 0.1),
          sliderInput(ns("ci_ps_confound"), "Selection bias strength",
                      0, 2, 1.0, step = 0.1),
          helpText(class = "small text-muted",
            "Higher values = treatment assignment more strongly depends on
             covariates that also affect Y."),
          sliderInput(ns("ci_ps_caliper"), "Matching caliper (SD units)",
                      0.05, 0.5, 0.2, step = 0.05),
          actionButton(ns("ci_ps_run"), "Simulate & Match",
                       class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Propensity Score Methods"),
          tags$p("In observational studies, treatment is not randomly assigned.
                  Units that receive treatment may differ systematically from
                  those that don't, confounding the treatment effect estimate."),
          tags$p("The ", tags$strong("propensity score"), " e(X) = P(Treatment = 1 | X)
                  summarizes all measured confounders into a single number."),
          tags$ul(
            tags$li(tags$strong("Matching:"), " Pair each treated unit with a
              control unit that has a similar propensity score. This creates a
              pseudo-randomized comparison."),
            tags$li(tags$strong("Weighting (IPW):"), " Weight each observation by
              the inverse of its probability of receiving its actual treatment.
              Treated: 1/e(X), Control: 1/(1\u2212e(X))."),
            tags$li(tags$strong("Subclassification:"), " Stratify on propensity
              score quintiles and average within-stratum effects.")
          ),
          tags$p(tags$strong("Key assumptions:")),
          tags$ul(
            tags$li(tags$strong("Ignorability / no unmeasured confounders:"),
              " All variables that affect both treatment and outcome are measured."),
            tags$li(tags$strong("Positivity / overlap:"),
              " Every unit has a non-zero chance of receiving either treatment. Check via propensity score distributions."),
            tags$li("Balance diagnostics (e.g., standardized mean differences)
              are essential after matching.")
          )
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Propensity Score Distributions"),
            plotlyOutput(ns("ci_ps_dist_plot"), height = "320px")
          ),
          card(
            card_header("Covariate Balance (SMD)"),
            plotlyOutput(ns("ci_ps_balance_plot"), height = "320px")
          )
        ),

        card(
          card_header("Treatment Effect Estimates"),
          uiOutput(ns("ci_ps_results"))
        ),

        card(
          card_header("Love Plot: Before vs. After Matching"),
          plotlyOutput(ns("ci_ps_love_plot"), height = "300px")
        )
      )
    ),

    # ── Tab 3: Difference-in-Differences ───────────────────────────────
    nav_panel("Difference-in-Differences", icon = icon("arrow-down-up-across-line"),
      layout_sidebar(
        sidebar = sidebar(
          title = "DiD Setup",
          tags$p(class = "text-muted small mb-2",
            "Simulate a two-group, two-period design. The treatment group
             receives an intervention between periods. DiD estimates the
             causal effect by differencing out time trends."),
          sliderInput(ns("ci_did_n"), "Units per group", 50, 1000, 200, step = 50),
          sliderInput(ns("ci_did_effect"), "True treatment effect",
                      -2, 2, 1.0, step = 0.1),
          sliderInput(ns("ci_did_trend"), "Common time trend",
                      -1, 2, 0.5, step = 0.1),
          sliderInput(ns("ci_did_group_diff"), "Baseline group difference",
                      -2, 2, 1.0, step = 0.25),
          checkboxInput(ns("ci_did_violate"), "Violate parallel trends", FALSE),
          conditionalPanel(ns = ns, 
            condition = "input.ci_did_violate == true",
            sliderInput(ns("ci_did_diff_trend"), "Differential trend (treatment group)",
                        -1, 1, 0.5, step = 0.1)
          ),
          actionButton(ns("ci_did_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Difference-in-Differences (DiD)"),
          tags$p("DiD is a quasi-experimental method for estimating causal
                  effects when randomization is not possible. It compares
                  the change over time in a treatment group to the change
                  over time in a control group."),
          tags$p(tags$strong("The DiD estimator:"),
            " \u0394Y\u209C\u1D63\u2091\u2090\u209C \u2212 \u0394Y\u1D9C\u2092\u2099\u209C\u1D63\u2092\u2097 =
              (Y\u0304\u209C\u0313\u1D56\u2092\u209B\u209C \u2212 Y\u0304\u209C\u0313\u1D56\u1D63\u2091)
              \u2212 (Y\u0304\u1D9C\u0313\u1D56\u2092\u209B\u209C \u2212 Y\u0304\u1D9C\u0313\u1D56\u1D63\u2091)"),
          tags$p(tags$strong("Key assumption \u2014 Parallel trends:"),
            " In the absence of treatment, both groups would have followed
              the same trajectory over time. This is untestable but can be
              assessed with pre-treatment data."),
          tags$ul(
            tags$li("DiD removes ", tags$strong("time-invariant confounders"),
              " (fixed differences between groups) and ",
              tags$strong("group-invariant time effects"),
              " (common shocks)."),
            tags$li("The regression form: Y = \u03b20 + \u03b21\u00b7Treat + \u03b22\u00b7Post + ",
              tags$strong("\u03b23\u00b7(Treat \u00d7 Post)"),
              " + \u03b5. The coefficient \u03b23 is the DiD estimate."),
            tags$li("Violations of parallel trends bias the estimate.
              Toggle the checkbox to see what happens."),
            tags$li("Extensions: staggered adoption, triple-differences,
              synthetic control methods.")
          )
        ),

        card(
          card_header("DiD Visualization"),
          plotlyOutput(ns("ci_did_plot"), height = "380px")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("DiD Regression Output"),
            uiOutput(ns("ci_did_table"))
          ),
          card(
            card_header("Manual DiD Calculation"),
            uiOutput(ns("ci_did_manual"))
          )
        )
      )
    ),

    # ── Tab 4: Regression Discontinuity ────────────────────────────────
    nav_panel("Regression Discontinuity", icon = icon("scissors"),
      layout_sidebar(
        sidebar = sidebar(
          title = "RD Design",
          tags$p(class = "text-muted small mb-2",
            "Simulate a sharp regression discontinuity where treatment is
             assigned based on a cutoff of a running variable."),
          sliderInput(ns("ci_rd_n"), "Sample size", 200, 5000, 500, step = 100),
          sliderInput(ns("ci_rd_effect"), "True treatment effect at cutoff",
                      -3, 3, 2.0, step = 0.25),
          sliderInput(ns("ci_rd_cutoff"), "Cutoff value",
                      -2, 2, 0, step = 0.25),
          selectInput(ns("ci_rd_func"), "True relationship shape",
            choices = c("Linear" = "linear",
                        "Quadratic" = "quadratic",
                        "Logarithmic" = "log"),
            selected = "linear"),
          sliderInput(ns("ci_rd_bw"), "Bandwidth (% of range)",
                      10, 100, 50, step = 5),
          helpText(class = "small text-muted",
            "Smaller bandwidth focuses on observations near the cutoff
             (less bias, more variance)."),
          sliderInput(ns("ci_rd_noise"), "Noise level", 0.5, 3, 1.0, step = 0.25),
          actionButton(ns("ci_rd_run"), "Simulate", class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Regression Discontinuity Design (RDD)"),
          tags$p("RDD exploits a known rule: units are assigned to treatment
                  based on whether a ", tags$strong("running variable"),
                  " (score) falls above or below a cutoff. At the cutoff,
                  assignment is essentially random."),
          tags$ul(
            tags$li(tags$strong("Sharp RD:"), " Treatment is a deterministic
              function of the running variable (score \u2265 cutoff \u2192
              treated). The causal effect is estimated as the discontinuity
              in Y at the cutoff."),
            tags$li(tags$strong("Local estimation:"), " The effect is estimated
              using only observations near the cutoff (within a bandwidth).
              Wider bandwidths use more data but risk bias from curvature."),
            tags$li(tags$strong("Key assumption \u2014 Continuity:"),
              " In the absence of treatment, Y would be a smooth function
              of the running variable at the cutoff. Units cannot precisely
              manipulate the running variable to sort around the cutoff."),
            tags$li(tags$strong("Polynomial order:"), " Linear fits on each
              side are standard. Higher-order polynomials can introduce
              instability (Gelman & Imbens, 2019 recommend against them)."),
            tags$li(tags$strong("Bandwidth selection:"), " Too narrow \u2192
              high variance; too wide \u2192 bias from misspecification.
              Methods like Imbens-Kalyanaraman provide optimal bandwidths.")
          ),
          tags$p("RDD is considered one of the most credible quasi-experimental
                  designs because its identifying assumption (continuity) is
                  relatively mild and partially testable. Researchers can check
                  for manipulation by examining the density of the running
                  variable around the cutoff (McCrary test) and verify that
                  pre-treatment covariates are balanced at the threshold."),
          tags$p("However, the RDD estimate is local \u2014 it applies only to
                  units at the cutoff, not to the entire population. Extrapolating
                  the treatment effect away from the cutoff requires additional
                  assumptions. This is both a strength (high internal validity)
                  and a limitation (limited external validity).")
        ),

        card(
          card_header("RD Plot"),
          plotlyOutput(ns("ci_rd_plot"), height = "400px")
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Local Linear Regression"),
            uiOutput(ns("ci_rd_table"))
          ),
          card(
            card_header("Bandwidth Sensitivity"),
            plotlyOutput(ns("ci_rd_bw_plot"), height = "280px")
          )
        )
      )
    ),

    # ── Tab 5: Instrumental Variables ──────────────────────────────────
    nav_panel("Instrumental Variables", icon = icon("link"),
      layout_sidebar(
        sidebar = sidebar(
          title = "IV / 2SLS Setup",
          tags$p(class = "text-muted small mb-2",
            "Simulate an endogenous treatment with an instrument.
             Compare OLS (biased) to 2SLS (IV) estimation."),
          sliderInput(ns("ci_iv_n"), "Sample size", 200, 5000, 1000, step = 200),
          sliderInput(ns("ci_iv_effect"), "True causal effect (X \u2192 Y)",
                      -2, 2, 0.8, step = 0.1),
          sliderInput(ns("ci_iv_inst_str"), "Instrument strength (Z \u2192 X)",
                      0.05, 1, 0.5, step = 0.05),
          helpText(class = "small text-muted",
            "Low values = weak instrument \u2192 biased IV estimates."),
          sliderInput(ns("ci_iv_confound"), "Confounding strength (U \u2192 X, U \u2192 Y)",
                      0, 1.5, 0.8, step = 0.1),
          actionButton(ns("ci_iv_run"), "Simulate & Estimate",
                       class = "btn-success w-100")
        ),

        explanation_box(
          tags$strong("Instrumental Variables (IV) & Two-Stage Least Squares"),
          tags$p("When X is endogenous (correlated with the error term due
                  to unmeasured confounders), OLS is biased. An ",
                  tags$strong("instrument Z"), " can recover the causal effect
                  if it satisfies three conditions:"),
          tags$ul(
            tags$li(tags$strong("Relevance:"), " Z must be correlated with X.
              Tested via the first-stage F-statistic (F > 10 is the classic
              rule of thumb)."),
            tags$li(tags$strong("Independence:"), " Z must be independent of
              unmeasured confounders U."),
            tags$li(tags$strong("Exclusion restriction:"), " Z affects Y ",
              tags$em("only"), " through X \u2014 no direct effect of Z on Y.")
          ),
          tags$p(tags$strong("Two-Stage Least Squares (2SLS):")),
          tags$ul(
            tags$li(tags$strong("Stage 1:"), " Regress X on Z to get predicted
              values X\u0302 (the exogenous part of X)."),
            tags$li(tags$strong("Stage 2:"), " Regress Y on X\u0302 to get the
              causal effect estimate."),
            tags$li("With weak instruments (low first-stage F), 2SLS can be
              more biased than OLS and has unreliable confidence intervals.")
          ),
          tags$p("IV estimation is widely used in economics (e.g., using distance to
                  college as an instrument for education, or draft lottery numbers as
                  an instrument for military service). The method identifies the Local
                  Average Treatment Effect (LATE) \u2014 the effect for \u201ccompliers\u201d
                  who change their treatment status in response to the instrument,
                  not the average effect for the whole population."),
          tags$p("Finding valid instruments is the central challenge. Relevance can be
                  tested statistically (first-stage F-test), but the exclusion
                  restriction \u2014 that Z affects Y only through X \u2014 is fundamentally
                  untestable and must be justified on substantive grounds. This makes
                  IV analysis as much an exercise in domain expertise as in statistics.")
        ),

        card(
          card_header("IV Path Diagram"),
          uiOutput(ns("ci_iv_svg"))
        ),

        layout_column_wrap(width = 1/2,
          card(
            card_header("Stage 1: Z \u2192 X"),
            plotlyOutput(ns("ci_iv_stage1_plot"), height = "280px")
          ),
          card(
            card_header("OLS vs. 2SLS Comparison"),
            uiOutput(ns("ci_iv_table"))
          )
        ),

        card(
          card_header("Weak Instrument Diagnostics"),
          uiOutput(ns("ci_iv_diagnostics"))
        )
      )
    ),

    # ── Tab 6: Sensitivity Analysis ─────────────────────────────────────────
    nav_panel("Sensitivity Analysis", icon = icon("shield-halved"),
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$h6("Observed estimate"),
          sliderInput(ns("sens_b_obs"), "Observed treatment effect \u03b2", 0, 2, 0.6, 0.05),
          sliderInput(ns("sens_se_obs"), "SE of observed estimate", 0.05, 0.5, 0.15, 0.01),
          sliderInput(ns("sens_n"), "Sample size n", 50, 1000, 300, 50),
          tags$hr(),
          tags$h6("E-value"),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
            "The E-value is the minimum strength of association that an unmeasured
             confounder would need to have with both treatment and outcome to fully
             explain away the observed effect."),
          tags$hr(),
          tags$h6("Sensitivity contour"),
          sliderInput(ns("sens_rr_conf_exp"), "Confounder-exposure RR range (max)", 1.5, 10, 5, 0.5),
          sliderInput(ns("sens_rr_conf_out"), "Confounder-outcome RR range (max)", 1.5, 10, 5, 0.5)
        ),
        accordion(
          class = "border-info mb-3",
          open = FALSE,
          accordion_panel(
            title = tagList(icon("circle-info"), " ", tags$strong("Sensitivity Analysis for Causal Claims")),
            value = "explanation",
            div(style = "font-size: 0.95rem;",
              tags$p("Observational studies can never rule out unmeasured confounding.
                      Sensitivity analyses quantify ", tags$em("how strong"),
                      " an unmeasured confounder would need to be to explain away the
                      observed result."),
              tags$p("Three complementary tools:"),
              tags$ul(
                tags$li(tags$strong("E-value"), " (VanderWeele & Ding, 2017) \u2014 the minimum
                        risk ratio (RR) for the confounder\u2013exposure and confounder\u2013outcome
                        associations that could explain away the effect:
                        E = RR + \u221a(RR \u00d7 (RR \u2212 1)).
                        Large E-values (> 2) indicate robustness."),
                tags$li(tags$strong("Sensitivity contour"), " \u2014 plots all combinations of
                        confounder-exposure and confounder-outcome RR that would shift the
                        point estimate to null. The observed effect is fragile if the contour
                        passes through plausible confounder strengths."),
                tags$li(tags$strong("Fragility index"), " \u2014 how many observations need to
                        change to flip the conclusion (p > \u03b1).")
              ),
              accordion(
                class = "mt-2", open = FALSE,
                accordion_panel(
                  title = tagList(icon("circle-question"), " Step-by-step guide"),
                  value = "guide",
                  tags$ol(
                    tags$li("Set the observed effect and its SE."),
                    tags$li("The E-value panel shows the minimum confounder strength needed to nullify the effect."),
                    tags$li("The contour plot shows the 'danger zone' for confounder associations."),
                    tags$li("Small E-values (< 1.5) indicate the result is easily explained away.")
                  )
                )
              )
            )
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("E-value Summary"), uiOutput(ns("sens_eval_summary"))),
            card(card_header("Fragility Index"), uiOutput(ns("sens_fragility")))
          ),
          card(full_screen = TRUE,
               card_header("Sensitivity Contour: Confounder Strengths Needed to Explain Away Effect"),
               plotlyOutput(ns("sens_contour"), height = "360px"))
        )
      )
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

causal_inference_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ═══════════════════════════════════════════════════════════════════════

  # Tab 1 — DAGs & Confounding
  # ═══════════════════════════════════════════════════════════════════════

  ci_dag_data <- eventReactive(input$ci_dag_run, {
    n   <- input$ci_dag_n
    bxy <- input$ci_dag_bxy
    s   <- input$ci_dag_conf_str
    type <- input$ci_dag_type

    set.seed(sample.int(10000, 1))

    if (type == "confound") {
      # Z -> X and Z -> Y  (confounder)
      Z <- rnorm(n)
      X <- s * Z + rnorm(n)
      Y <- bxy * X + s * Z + rnorm(n)
    } else if (type == "mediator") {
      # X -> Z -> Y  (mediator on the causal path)
      X <- rnorm(n)
      Z <- s * X + rnorm(n)
      Y <- bxy * X + s * Z + rnorm(n)
      # total effect = bxy + s*s
    } else if (type == "collider") {
      # X -> Z <- Y  (collider)
      X <- rnorm(n)
      Y <- bxy * X + rnorm(n)
      Z <- s * X + s * Y + rnorm(n)
    } else {
      # M-bias: U1 -> Z, U1 -> X, U2 -> Z, U2 -> Y
      U1 <- rnorm(n)
      U2 <- rnorm(n)
      Z  <- s * U1 + s * U2 + rnorm(n)
      X  <- s * U1 + rnorm(n)
      Y  <- bxy * X + s * U2 + rnorm(n)
    }

    df <- data.frame(X = X, Y = Y, Z = Z)
    naive    <- lm(Y ~ X, data = df)
    adjusted <- lm(Y ~ X + Z, data = df)

    list(
      df = df, type = type, bxy = bxy, s = s,
      naive = naive, adjusted = adjusted
    )
  })

  # ── DAG SVG ────────────────────────────────────────────────────────
  output$ci_dag_svg <- renderUI({
    req(ci_dag_data())
    d <- ci_dag_data()
    type <- d$type

    # Common SVG settings
    w <- 420; h <- 200
    node_r <- 22
    col_x <- "#268bd2"; col_y <- "#dc322f"; col_z <- "#2aa198"
    col_arrow <- "var(--bs-body-color)"
    font <- "var(--bs-body-color)"

    # Node positions vary by DAG type
    if (type == "confound") {
      nodes <- list(X = c(80, 150), Y = c(340, 150), Z = c(210, 50))
      arrows <- list(
        list(from = "Z", to = "X", label = ""),
        list(from = "Z", to = "Y", label = ""),
        list(from = "X", to = "Y", label = "causal")
      )
      title <- "Confounder: X \u2190 Z \u2192 Y"
    } else if (type == "mediator") {
      nodes <- list(X = c(60, 100), Y = c(360, 100), Z = c(210, 100))
      arrows <- list(
        list(from = "X", to = "Z", label = ""),
        list(from = "Z", to = "Y", label = ""),
        list(from = "X", to = "Y", label = "direct", curve = TRUE)
      )
      title <- "Mediator: X \u2192 Z \u2192 Y"
    } else if (type == "collider") {
      nodes <- list(X = c(80, 50), Y = c(340, 50), Z = c(210, 150))
      arrows <- list(
        list(from = "X", to = "Z", label = ""),
        list(from = "Y", to = "Z", label = ""),
        list(from = "X", to = "Y", label = "causal")
      )
      title <- "Collider: X \u2192 Z \u2190 Y"
    } else {
      # M-bias
      nodes <- list(X = c(60, 160), Y = c(360, 160),
                    Z = c(210, 80), U1 = c(130, 30), U2 = c(290, 30))
      arrows <- list(
        list(from = "U1", to = "X", label = ""),
        list(from = "U1", to = "Z", label = ""),
        list(from = "U2", to = "Z", label = ""),
        list(from = "U2", to = "Y", label = ""),
        list(from = "X", to = "Y", label = "causal")
      )
      title <- "M-Bias: U1 \u2192 X, U1 \u2192 Z \u2190 U2, U2 \u2192 Y"
      col_u <- "#b58900"
    }

    # Build SVG
    svg_parts <- c(
      sprintf('<svg width="100%%" viewBox="0 0 %d %d" xmlns="http://www.w3.org/2000/svg"
               style="max-width:%dpx; display:block; margin:auto;">', w, h, w),
      '<defs><marker id="ci_ah" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">',
      sprintf('<polygon points="0 0, 10 3.5, 0 7" fill="%s"/>', col_arrow),
      '</marker></defs>',
      sprintf('<text x="%d" y="18" text-anchor="middle" font-size="13"
               font-weight="600" fill="%s">%s</text>', w/2, font, title)
    )

    # Draw arrows
    for (a in arrows) {
      fx <- nodes[[a$from]][1]; fy <- nodes[[a$from]][2]
      tx <- nodes[[a$to]][1];   ty <- nodes[[a$to]][2]
      # Shorten by node radius
      dx <- tx - fx; dy <- ty - fy
      len <- sqrt(dx^2 + dy^2)
      ux <- dx / len; uy <- dy / len
      sx <- fx + ux * node_r; sy <- fy + uy * node_r
      ex <- tx - ux * node_r; ey <- ty - uy * node_r

      stroke_col <- if (a$label == "causal") "#268bd2" else col_arrow
      sw <- if (a$label == "causal") 2.5 else 1.5
      dash <- ""

      if (!is.null(a$curve) && isTRUE(a$curve)) {
        # Curved arrow for direct path in mediator
        cy_off <- -50
        svg_parts <- c(svg_parts, sprintf(
          '<path d="M%.0f,%.0f Q%.0f,%.0f %.0f,%.0f" fill="none"
           stroke="%s" stroke-width="%.1f" marker-end="url(#ci_ah)" %s/>',
          sx, sy, (sx+ex)/2, (sy+ey)/2 + cy_off, ex, ey,
          stroke_col, sw, dash
        ))
      } else {
        svg_parts <- c(svg_parts, sprintf(
          '<line x1="%.0f" y1="%.0f" x2="%.0f" y2="%.0f"
           stroke="%s" stroke-width="%.1f" marker-end="url(#ci_ah)" %s/>',
          sx, sy, ex, ey, stroke_col, sw, dash
        ))
      }
    }

    # Draw nodes
    for (nm in names(nodes)) {
      cx <- nodes[[nm]][1]; cy <- nodes[[nm]][2]
      col <- switch(nm,
        X = col_x, Y = col_y, Z = col_z,
        U1 = "#b58900", U2 = "#b58900", col_z
      )
      svg_parts <- c(svg_parts, sprintf(
        '<circle cx="%.0f" cy="%.0f" r="%d" fill="var(--bs-body-bg)"
         stroke="%s" stroke-width="2.5"/>',
        cx, cy, node_r, col
      ))
      svg_parts <- c(svg_parts, sprintf(
        '<text x="%.0f" y="%.0f" text-anchor="middle" dy="0.35em"
         font-size="14" font-weight="700" fill="%s">%s</text>',
        cx, cy, col, nm
      ))
    }

    svg_parts <- c(svg_parts, '</svg>')
    HTML(paste(svg_parts, collapse = "\n"))
  })

  # ── Naive estimate ─────────────────────────────────────────────────
  output$ci_dag_naive <- renderUI({
    req(ci_dag_data())
    d <- ci_dag_data()
    coefs <- summary(d$naive)$coefficients
    est <- coefs["X", "Estimate"]
    se  <- coefs["X", "Std. Error"]
    p   <- coefs["X", "Pr(>|t|)"]
    stars <- if (p < 0.001) "***" else if (p < 0.01) "**" else if (p < 0.05) "*" else ""

    bias <- est - d$bxy
    bias_col <- if (abs(bias) > 0.1) "#dc322f" else "#2aa198"

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 350px;">
          <tr><td><strong>Coefficient (X)</strong></td>
              <td>%.3f %s</td></tr>
          <tr><td>SE</td><td>%.3f</td></tr>
          <tr><td>p-value</td><td>%s</td></tr>
          <tr><td>True causal effect</td><td>%.2f</td></tr>
          <tr style="color: %s; font-weight: 600;">
              <td>Bias</td><td>%.3f</td></tr>
        </table>
        <p class="text-muted small mb-0">Model: Y ~ X (no covariates)</p>
      </div>',
      est, stars, se, format.pval(p, digits = 3), d$bxy, bias_col, bias
    ))
  })

  # ── Adjusted estimate ──────────────────────────────────────────────
  output$ci_dag_adjusted <- renderUI({
    req(ci_dag_data())
    d <- ci_dag_data()
    coefs <- summary(d$adjusted)$coefficients
    est <- coefs["X", "Estimate"]
    se  <- coefs["X", "Std. Error"]
    p   <- coefs["X", "Pr(>|t|)"]
    stars <- if (p < 0.001) "***" else if (p < 0.01) "**" else if (p < 0.05) "*" else ""

    bias <- est - d$bxy
    bias_col <- if (abs(bias) > 0.1) "#dc322f" else "#2aa198"

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 350px;">
          <tr><td><strong>Coefficient (X)</strong></td>
              <td>%.3f %s</td></tr>
          <tr><td>SE</td><td>%.3f</td></tr>
          <tr><td>p-value</td><td>%s</td></tr>
          <tr><td>True causal effect</td><td>%.2f</td></tr>
          <tr style="color: %s; font-weight: 600;">
              <td>Bias</td><td>%.3f</td></tr>
        </table>
        <p class="text-muted small mb-0">Model: Y ~ X + Z</p>
      </div>',
      est, stars, se, format.pval(p, digits = 3), d$bxy, bias_col, bias
    ))
  })

  # ── Lesson summary ─────────────────────────────────────────────────
  output$ci_dag_lesson <- renderUI({
    req(ci_dag_data())
    d <- ci_dag_data()
    naive_est <- coef(d$naive)["X"]
    adj_est   <- coef(d$adjusted)["X"]
    bxy <- d$bxy

    naive_bias <- abs(naive_est - bxy)
    adj_bias   <- abs(adj_est - bxy)

    lesson <- switch(d$type,
      "confound" = {
        better <- if (adj_bias < naive_bias) "adjusted" else "naive"
        sprintf(
          '<p><strong>Confounder structure:</strong> Z causes both X and Y,
           creating a spurious association.</p>
           <p>The <strong>%s</strong> estimate is closer to the truth (%.2f).
           Adjusting for the confounder Z removes back-door bias, bringing
           the estimate from %.3f to %.3f (true = %.2f).</p>
           <p class="text-muted small">\u2714 <strong>Adjust for Z</strong>
           to satisfy the back-door criterion.</p>',
          better, bxy, naive_est, adj_est, bxy)
      },
      "mediator" = {
        total <- bxy + d$s * d$s
        sprintf(
          '<p><strong>Mediator structure:</strong> Part of X\'s effect on Y
           flows through Z. The total causal effect = direct + indirect =
           %.2f + %.2f \u00d7 %.2f = %.2f.</p>
           <p>The <strong>naive</strong> estimate (%.3f) captures the total
           effect. Adjusting for Z blocks the indirect path, giving only
           the direct effect (%.3f).</p>
           <p class="text-muted small">\u2718 <strong>Do NOT adjust for Z</strong>
           if you want the total effect.</p>',
          bxy, d$s, d$s, total, naive_est, adj_est)
      },
      "collider" = {
        sprintf(
          '<p><strong>Collider structure:</strong> Z is a common effect of X
           and Y. Unconditionally, there is no spurious path.</p>
           <p>The <strong>naive</strong> estimate (%.3f) is unbiased.
           Adjusting for the collider Z opens a spurious path, distorting
           the estimate to %.3f (true = %.2f).</p>
           <p class="text-muted small">\u2718 <strong>Do NOT adjust for Z</strong>
           \u2014 conditioning on a collider creates bias.</p>',
          naive_est, adj_est, bxy)
      },
      "mbias" = {
        sprintf(
          '<p><strong>M-Bias (butterfly):</strong> Z is a collider on the
           path U1 \u2192 Z \u2190 U2. X and Y are connected only through
           the causal path, not through Z.</p>
           <p>The <strong>naive</strong> estimate (%.3f) is unbiased.
           Adjusting for Z opens the U1\u2013U2 path, introducing bias
           (adjusted = %.3f, true = %.2f).</p>
           <p class="text-muted small">\u2718 <strong>Do NOT adjust for Z</strong>
           \u2014 more covariates \u2260 less bias.</p>',
          naive_est, adj_est, bxy)
      }
    )

    HTML(sprintf('<div style="padding: 0.75rem;">%s</div>', lesson))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 2 — Propensity Scores
  # ═══════════════════════════════════════════════════════════════════════

  ci_ps_data <- eventReactive(input$ci_ps_run, {
    n   <- input$ci_ps_n
    ate <- input$ci_ps_ate
    s   <- input$ci_ps_confound
    cal <- input$ci_ps_caliper

    set.seed(sample.int(10000, 1))

    # Generate covariates
    X1 <- rnorm(n)
    X2 <- rnorm(n)
    X3 <- rbinom(n, 1, 0.4)

    # Treatment assignment (logistic)
    logit_p <- -0.5 + s * X1 + 0.5 * s * X2 + 0.3 * s * X3
    ps_true <- plogis(logit_p)
    Trt <- rbinom(n, 1, ps_true)

    # Outcome
    Y <- 2 + ate * Trt + 1.5 * X1 + 0.8 * X2 + 0.5 * X3 + rnorm(n)

    df <- data.frame(Y = Y, Trt = Trt, X1 = X1, X2 = X2, X3 = X3,
                     ps_true = ps_true)

    # Estimate propensity scores
    ps_mod <- glm(Trt ~ X1 + X2 + X3, data = df, family = binomial)
    df$ps_hat <- predict(ps_mod, type = "response")

    # --- Naive estimate ---
    naive <- lm(Y ~ Trt, data = df)

    # --- Regression-adjusted ---
    reg_adj <- lm(Y ~ Trt + X1 + X2 + X3, data = df)

    # --- Propensity score matching (nearest-neighbor within caliper) ---
    treated_idx <- which(df$Trt == 1)
    control_idx <- which(df$Trt == 0)
    ps_sd <- sd(df$ps_hat)

    matched_pairs <- data.frame(treated = integer(0), control = integer(0))
    used_controls <- integer(0)

    for (i in treated_idx) {
      ps_i <- df$ps_hat[i]
      dists <- abs(df$ps_hat[control_idx] - ps_i)
      # Exclude already-used controls
      dists[control_idx %in% used_controls] <- Inf
      best <- which.min(dists)
      if (dists[best] <= cal * ps_sd) {
        matched_pairs <- rbind(matched_pairs,
          data.frame(treated = i, control = control_idx[best]))
        used_controls <- c(used_controls, control_idx[best])
      }
    }

    if (nrow(matched_pairs) > 5) {
      matched_df <- rbind(
        df[matched_pairs$treated, ],
        df[matched_pairs$control, ]
      )
      ps_match_est <- mean(df$Y[matched_pairs$treated]) -
                      mean(df$Y[matched_pairs$control])
      ps_match_se  <- sqrt(
        var(df$Y[matched_pairs$treated]) / nrow(matched_pairs) +
        var(df$Y[matched_pairs$control]) / nrow(matched_pairs)
      )
    } else {
      matched_df <- NULL
      ps_match_est <- NA
      ps_match_se  <- NA
    }

    # --- IPW estimate ---
    df$ps_hat <- pmin(pmax(df$ps_hat, 0.01), 0.99)
    w <- ifelse(df$Trt == 1, 1 / df$ps_hat, 1 / (1 - df$ps_hat))
    ipw_mod <- lm(Y ~ Trt, data = df, weights = w)

    # --- Balance: SMD before and after matching ---
    smd_before <- sapply(c("X1", "X2", "X3"), function(v) {
      t_mean <- mean(df[[v]][df$Trt == 1])
      c_mean <- mean(df[[v]][df$Trt == 0])
      pooled_sd <- sqrt((var(df[[v]][df$Trt == 1]) +
                         var(df[[v]][df$Trt == 0])) / 2)
      (t_mean - c_mean) / pooled_sd
    })

    if (!is.null(matched_df)) {
      smd_after <- sapply(c("X1", "X2", "X3"), function(v) {
        t_mean <- mean(matched_df[[v]][matched_df$Trt == 1])
        c_mean <- mean(matched_df[[v]][matched_df$Trt == 0])
        pooled_sd <- sqrt((var(matched_df[[v]][matched_df$Trt == 1]) +
                           var(matched_df[[v]][matched_df$Trt == 0])) / 2)
        (t_mean - c_mean) / pooled_sd
      })
    } else {
      smd_after <- rep(NA, 3)
      names(smd_after) <- c("X1", "X2", "X3")
    }

    list(
      df = df, ate = ate, naive = naive, reg_adj = reg_adj,
      ipw_mod = ipw_mod,
      ps_match_est = ps_match_est, ps_match_se = ps_match_se,
      n_matched = nrow(matched_pairs),
      matched_df = matched_df,
      smd_before = smd_before, smd_after = smd_after
    )
  })

  # ── Propensity score distribution plot ─────────────────────────────
  output$ci_ps_dist_plot <- plotly::renderPlotly({
    req(ci_ps_data())
    d <- ci_ps_data()
    df <- d$df
    ctrl <- df$ps_hat[df$Trt == 0]
    trt  <- df$ps_hat[df$Trt == 1]
    d_ctrl <- density(ctrl)
    d_trt  <- density(trt)

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = ctrl, histnorm = "probability density", nbinsx = 40,
        marker = list(color = "rgba(38,139,210,0.45)"),
        name = "Control", legendgroup = "ctrl"
      ) |>
      plotly::add_histogram(
        x = trt, histnorm = "probability density", nbinsx = 40,
        marker = list(color = "rgba(220,50,47,0.45)"),
        name = "Treated", legendgroup = "trt"
      ) |>
      plotly::add_trace(
        x = d_ctrl$x, y = d_ctrl$y, type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2),
        name = "Control", legendgroup = "ctrl", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = d_trt$x, y = d_trt$y, type = "scatter", mode = "lines",
        line = list(color = "#dc322f", width = 2),
        name = "Treated", legendgroup = "trt", showlegend = FALSE
      ) |>
      plotly::layout(
        barmode = "overlay",
        title = list(text = "Overlap of Propensity Scores", font = list(size = 14)),
        xaxis = list(title = "Estimated Propensity Score"),
        yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Covariate balance (SMD) bar chart ──────────────────────────────
  output$ci_ps_balance_plot <- plotly::renderPlotly({
    req(ci_ps_data())
    d <- ci_ps_data()

    vars <- c("X1", "X2", "X3")
    plotly::plot_ly() |>
      plotly::add_bars(
        y = vars, x = abs(d$smd_before),
        marker = list(color = "#dc322f", opacity = 0.8),
        name = "Before Matching", orientation = "h"
      ) |>
      plotly::add_bars(
        y = vars, x = abs(d$smd_after),
        marker = list(color = "#2aa198", opacity = 0.8),
        name = "After Matching", orientation = "h"
      ) |>
      plotly::layout(
        barmode = "group",
        shapes = list(list(
          type = "line", x0 = 0.1, x1 = 0.1, y0 = -0.5, y1 = 2.5,
          line = list(color = "#b58900", dash = "dash", width = 1.5)
        )),
        title = list(text = "Covariate Balance", font = list(size = 14)),
        xaxis = list(title = "|Standardized Mean Difference|"),
        yaxis = list(title = ""),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Treatment effect comparison table ──────────────────────────────
  output$ci_ps_results <- renderUI({
    req(ci_ps_data())
    d <- ci_ps_data()

    naive_est <- coef(d$naive)["Trt"]
    naive_se  <- summary(d$naive)$coefficients["Trt", "Std. Error"]
    reg_est   <- coef(d$reg_adj)["Trt"]
    reg_se    <- summary(d$reg_adj)$coefficients["Trt", "Std. Error"]
    ipw_est   <- coef(d$ipw_mod)["Trt"]
    ipw_se    <- summary(d$ipw_mod)$coefficients["Trt", "Std. Error"]

    fmt_row <- function(method, est, se, highlight = FALSE) {
      bias <- est - d$ate
      bias_col <- if (abs(bias) > 0.15) "#dc322f" else "#2aa198"
      bg <- if (highlight) "background-color: rgba(42,161,152,0.10);" else ""
      sprintf(
        '<tr style="%s">
          <td>%s</td><td>%.3f</td><td>%.3f</td>
          <td>[%.3f, %.3f]</td>
          <td style="color:%s; font-weight:600;">%.3f</td></tr>',
        bg, method, est, se, est - 1.96*se, est + 1.96*se, bias_col, bias
      )
    }

    rows <- paste0(
      fmt_row("Naive (Y ~ Trt)", naive_est, naive_se),
      fmt_row("Regression adjusted", reg_est, reg_se, TRUE),
      fmt_row("IPW (weighted)", ipw_est, ipw_se, TRUE)
    )

    # PS matching row
    if (!is.na(d$ps_match_est)) {
      rows <- paste0(rows,
        fmt_row(sprintf("PS Matching (n=%d pairs)", d$n_matched),
                d$ps_match_est, d$ps_match_se, TRUE)
      )
    } else {
      rows <- paste0(rows,
        '<tr><td>PS Matching</td><td colspan="4" class="text-muted">
         Too few matches within caliper. Try a larger caliper or sample size.</td></tr>')
    }

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm table-striped">
          <thead><tr>
            <th>Method</th><th>Estimate</th><th>SE</th>
            <th>95%% CI</th><th>Bias</th>
          </tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="text-muted small mb-0">True ATE = %.2f. Bias = Estimate \u2212 True.</p>
      </div>', rows, d$ate))
  })

  # ── Love plot ──────────────────────────────────────────────────────
  output$ci_ps_love_plot <- plotly::renderPlotly({
    req(ci_ps_data())
    d <- ci_ps_data()

    vars <- c("X1", "X2", "X3")
    before <- abs(d$smd_before)
    after  <- abs(d$smd_after)

    p <- plotly::plot_ly()
    # Connecting lines
    for (i in seq_along(vars)) {
      p <- p |> plotly::add_trace(
        x = c(before[i], after[i]), y = c(vars[i], vars[i]),
        type = "scatter", mode = "lines",
        line = list(color = "grey60", width = 1),
        showlegend = FALSE, hoverinfo = "skip"
      )
    }
    p |>
      plotly::add_markers(
        x = before, y = vars,
        marker = list(color = "#dc322f", size = 10, symbol = "triangle-up"),
        name = "Unadjusted",
        hoverinfo = "text",
        hovertext = sprintf("%s: |SMD| = %.3f", vars, before)
      ) |>
      plotly::add_markers(
        x = after, y = vars,
        marker = list(color = "#2aa198", size = 10, symbol = "circle"),
        name = "After Matching",
        hoverinfo = "text",
        hovertext = sprintf("%s: |SMD| = %.3f", vars, after)
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0.1, x1 = 0.1, y0 = -0.5, y1 = 2.5,
               line = list(color = "#b58900", dash = "dash", width = 1.5)),
          list(type = "line", x0 = 0, x1 = 0, y0 = -0.5, y1 = 2.5,
               line = list(color = "grey40", width = 1))
        ),
        title = list(text = "Love Plot", font = list(size = 14)),
        xaxis = list(title = "|Standardized Mean Difference|"),
        yaxis = list(title = ""),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.15),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 3 — Difference-in-Differences
  # ═══════════════════════════════════════════════════════════════════════

  ci_did_data <- eventReactive(input$ci_did_run, {
    n_per   <- input$ci_did_n
    effect  <- input$ci_did_effect
    trend   <- input$ci_did_trend
    g_diff  <- input$ci_did_group_diff
    violate <- input$ci_did_violate
    d_trend <- if (violate) input$ci_did_diff_trend else 0

    set.seed(sample.int(10000, 1))

    # Each unit observed in two periods
    n <- n_per * 2
    treat  <- rep(c(0, 1), each = n_per)
    noise0 <- rnorm(n, sd = 0.8)
    noise1 <- rnorm(n, sd = 0.8)

    # Pre-period
    Y_pre  <- 5 + g_diff * treat + noise0

    # Post-period: common trend + treatment effect + possible differential trend
    Y_post <- 5 + g_diff * treat + trend +
              effect * treat + d_trend * treat + noise1

    df_long <- data.frame(
      id     = rep(1:n, 2),
      Group  = factor(rep(ifelse(treat == 1, "Treatment", "Control"), 2),
                      levels = c("Control", "Treatment")),
      Period = factor(rep(c("Pre", "Post"), each = n),
                      levels = c("Pre", "Post")),
      Y      = c(Y_pre, Y_post),
      treat  = rep(treat, 2),
      post   = rep(c(0, 1), each = n)
    )

    df_long$treat_post <- df_long$treat * df_long$post

    # DiD regression
    did_mod <- lm(Y ~ treat + post + treat_post, data = df_long)

    # Group means for manual calculation
    means <- tapply(df_long$Y, list(df_long$Group, df_long$Period), mean)

    list(
      df = df_long, did_mod = did_mod, means = means,
      true_effect = effect, d_trend = d_trend, violate = violate
    )
  })

  # ── DiD plot ───────────────────────────────────────────────────────
  output$ci_did_plot <- plotly::renderPlotly({
    req(ci_did_data())
    d <- ci_did_data()
    means <- d$means

    periods <- c("Pre", "Post")
    ctrl_y <- c(means["Control", "Pre"], means["Control", "Post"])
    trt_y  <- c(means["Treatment", "Pre"], means["Treatment", "Post"])

    ctrl_change <- means["Control", "Post"] - means["Control", "Pre"]
    cf_post <- means["Treatment", "Pre"] + ctrl_change
    cf_y <- c(means["Treatment", "Pre"], cf_post)

    did_est <- coef(d$did_mod)["treat_post"]
    all_y <- c(ctrl_y, trt_y, cf_y)

    annotations <- list(
      list(
        x = "Post", y = (cf_post + means["Treatment", "Post"]) / 2,
        text = sprintf("<b>DiD = %.2f</b>", did_est),
        showarrow = FALSE, xanchor = "left", xshift = 12,
        font = list(color = "#2aa198", size = 13)
      )
    )
    if (d$violate) {
      annotations <- c(annotations, list(list(
        x = 0.5, y = 1.05, xref = "paper", yref = "paper",
        text = "\u26a0 Parallel trends violated!",
        showarrow = FALSE,
        font = list(color = "#b58900", size = 12, weight = "bold")
      )))
    }

    plotly::plot_ly() |>
      plotly::add_trace(
        x = periods, y = ctrl_y, type = "scatter", mode = "lines+markers",
        line = list(color = "#268bd2", width = 3),
        marker = list(color = "#268bd2", size = 10),
        name = "Control"
      ) |>
      plotly::add_trace(
        x = periods, y = trt_y, type = "scatter", mode = "lines+markers",
        line = list(color = "#dc322f", width = 3),
        marker = list(color = "#dc322f", size = 10),
        name = "Treatment"
      ) |>
      plotly::add_trace(
        x = periods, y = cf_y, type = "scatter", mode = "lines+markers",
        line = list(color = "#b58900", width = 2, dash = "dash"),
        marker = list(color = "#b58900", size = 8, symbol = "circle-open",
                      line = list(width = 2)),
        name = "Counterfactual"
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = "Post", x1 = "Post",
          y0 = cf_post, y1 = means["Treatment", "Post"],
          line = list(color = "#2aa198", width = 2)
        )),
        annotations = annotations,
        title = list(text = "Difference-in-Differences", font = list(size = 14)),
        xaxis = list(title = ""),
        yaxis = list(title = "Outcome (Y)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.1),
        margin = list(t = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── DiD regression table ───────────────────────────────────────────
  output$ci_did_table <- renderUI({
    req(ci_did_data())
    d <- ci_did_data()
    s <- summary(d$did_mod)
    coefs <- s$coefficients

    rows <- ""
    for (nm in rownames(coefs)) {
      est <- coefs[nm, "Estimate"]
      se  <- coefs[nm, "Std. Error"]
      pv  <- coefs[nm, "Pr(>|t|)"]
      stars <- if (pv < 0.001) "***" else if (pv < 0.01) "**" else if (pv < 0.05) "*" else ""
      hl <- if (nm == "treat_post") "background-color: rgba(42,161,152,0.12);" else ""
      label <- switch(nm,
        "(Intercept)" = "Intercept (\u03b20)",
        "treat" = "Treatment group (\u03b21)",
        "post" = "Post period (\u03b22)",
        "treat_post" = "Treat \u00d7 Post (\u03b23 = DiD)",
        nm
      )
      rows <- paste0(rows, sprintf(
        '<tr style="%s"><td>%s</td><td>%.3f</td><td>%.3f</td><td>%s %s</td></tr>',
        hl, label, est, se, format.pval(pv, digits = 3), stars
      ))
    }

    bias <- coef(d$did_mod)["treat_post"] - d$true_effect
    bias_col <- if (abs(bias) > 0.15) "#dc322f" else "#2aa198"

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Term</th><th>Estimate</th><th>SE</th><th>p</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="small mb-1">R\u00b2 = %.3f &ensp; Residual SE = %.3f</p>
        <p class="small mb-0">True effect = %.2f &ensp;
           <span style="color: %s; font-weight: 600;">Bias = %.3f</span>%s</p>
      </div>',
      rows, s$r.squared, s$sigma, d$true_effect, bias_col, bias,
      if (d$violate) sprintf(" (includes differential trend = %.2f)", d$d_trend) else ""
    ))
  })

  # ── Manual DiD calculation ─────────────────────────────────────────
  output$ci_did_manual <- renderUI({
    req(ci_did_data())
    d <- ci_did_data()
    m <- d$means

    t_diff <- m["Treatment", "Post"] - m["Treatment", "Pre"]
    c_diff <- m["Control", "Post"]   - m["Control", "Pre"]
    did    <- t_diff - c_diff

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2">
          <thead><tr><th></th><th>Pre</th><th>Post</th><th>\u0394</th></tr></thead>
          <tbody>
            <tr><td><strong>Treatment</strong></td>
                <td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>
            <tr><td><strong>Control</strong></td>
                <td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>
          </tbody>
          <tfoot>
            <tr style="border-top: 2px solid var(--bs-border-color);">
              <td colspan="3"><strong>DiD = \u0394Treatment \u2212 \u0394Control</strong></td>
              <td><strong style="color: #2aa198;">%.3f</strong></td></tr>
          </tfoot>
        </table>
        <p class="text-muted small mb-0">
          (%.3f \u2212 %.3f) \u2212 (%.3f \u2212 %.3f) = %.3f
        </p>
      </div>',
      m["Treatment", "Pre"], m["Treatment", "Post"], t_diff,
      m["Control", "Pre"],   m["Control", "Post"],   c_diff,
      did,
      m["Treatment", "Post"], m["Treatment", "Pre"],
      m["Control", "Post"],   m["Control", "Pre"], did
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 4 — Regression Discontinuity
  # ═══════════════════════════════════════════════════════════════════════

  ci_rd_data <- eventReactive(input$ci_rd_run, {
    n      <- input$ci_rd_n
    effect <- input$ci_rd_effect
    cutoff <- input$ci_rd_cutoff
    func   <- input$ci_rd_func
    bw_pct <- input$ci_rd_bw / 100
    noise  <- input$ci_rd_noise

    set.seed(sample.int(10000, 1))

    # Running variable centered on cutoff range
    X <- runif(n, cutoff - 3, cutoff + 3)
    Treat <- as.integer(X >= cutoff)
    Xc <- X - cutoff

    # True outcome function (different shapes)
    f_x <- switch(func,
      "linear"    = 2 + 1.2 * Xc,
      "quadratic" = 2 + 0.8 * Xc + 0.3 * Xc^2,
      "log"       = 2 + 1.5 * sign(Xc) * log1p(abs(Xc))
    )
    Y <- f_x + effect * Treat + rnorm(n, sd = noise)

    df <- data.frame(X = X, Xc = Xc, Y = Y, Treat = Treat)

    # Bandwidth range
    range_x <- max(X) - min(X)
    bw <- bw_pct * range_x / 2

    # Local sample
    local_idx <- abs(Xc) <= bw
    df_local <- df[local_idx, ]

    # Local linear regression (separate slopes)
    if (nrow(df_local) > 10) {
      rd_mod <- lm(Y ~ Xc * Treat, data = df_local)
    } else {
      rd_mod <- NULL
    }

    # Bandwidth sensitivity: estimate at multiple bandwidths
    bws <- seq(0.15, 1.0, by = 0.05) * range_x / 2
    bw_results <- lapply(bws, function(h) {
      idx <- abs(Xc) <= h
      if (sum(idx) > 10 && sum(df$Treat[idx] == 1) > 3 && sum(df$Treat[idx] == 0) > 3) {
        mod <- lm(Y ~ Xc * Treat, data = df[idx, ])
        s <- summary(mod)$coefficients
        if ("Treat" %in% rownames(s)) {
          data.frame(bw = h, est = s["Treat", "Estimate"],
                     se = s["Treat", "Std. Error"],
                     n_local = sum(idx))
        } else NULL
      } else NULL
    })
    bw_df <- do.call(rbind, bw_results)

    list(df = df, df_local = df_local, rd_mod = rd_mod,
         cutoff = cutoff, effect = effect, bw = bw,
         bw_df = bw_df, func = func, n_local = sum(local_idx))
  })

  # ── RD scatter plot ────────────────────────────────────────────────
  output$ci_rd_plot <- plotly::renderPlotly({
    req(ci_rd_data())
    d <- ci_rd_data()
    df <- d$df
    ctrl <- df[df$Treat == 0, ]
    trt  <- df[df$Treat == 1, ]

    shapes <- list(
      # Cutoff line
      list(type = "line", x0 = d$cutoff, x1 = d$cutoff,
           y0 = 0, y1 = 1, yref = "paper",
           line = list(color = "#b58900", dash = "dash", width = 1.5)),
      # Bandwidth shading
      list(type = "rect",
           x0 = d$cutoff - d$bw, x1 = d$cutoff + d$bw,
           y0 = 0, y1 = 1, yref = "paper",
           fillcolor = "rgba(42,161,152,0.06)", line = list(width = 0))
    )
    annotations <- list()

    p <- plotly::plot_ly() |>
      plotly::add_markers(
        x = ctrl$X, y = ctrl$Y,
        marker = list(color = "#268bd2", opacity = 0.35, size = 4),
        name = "Control",
        hoverinfo = "text",
        hovertext = sprintf("X: %.2f<br>Y: %.2f", ctrl$X, ctrl$Y)
      ) |>
      plotly::add_markers(
        x = trt$X, y = trt$Y,
        marker = list(color = "#dc322f", opacity = 0.35, size = 4),
        name = "Treated",
        hoverinfo = "text",
        hovertext = sprintf("X: %.2f<br>Y: %.2f", trt$X, trt$Y)
      )

    if (!is.null(d$rd_mod)) {
      x_left  <- seq(d$cutoff - d$bw, d$cutoff, length.out = 100)
      x_right <- seq(d$cutoff, d$cutoff + d$bw, length.out = 100)
      pred_left  <- predict(d$rd_mod, newdata = data.frame(Xc = x_left - d$cutoff, Treat = 0))
      pred_right <- predict(d$rd_mod, newdata = data.frame(Xc = x_right - d$cutoff, Treat = 1))

      p <- p |>
        plotly::add_trace(
          x = x_left, y = pred_left, type = "scatter", mode = "lines",
          line = list(color = "#268bd2", width = 3),
          name = "Fit (control)", showlegend = FALSE
        ) |>
        plotly::add_trace(
          x = x_right, y = pred_right, type = "scatter", mode = "lines",
          line = list(color = "#dc322f", width = 3),
          name = "Fit (treated)", showlegend = FALSE
        )

      y_left  <- predict(d$rd_mod, newdata = data.frame(Xc = 0, Treat = 0))
      y_right <- predict(d$rd_mod, newdata = data.frame(Xc = 0, Treat = 1))

      shapes <- c(shapes, list(list(
        type = "line", x0 = d$cutoff, x1 = d$cutoff,
        y0 = y_left, y1 = y_right,
        line = list(color = "#2aa198", width = 3)
      )))
      annotations <- list(list(
        x = d$cutoff + 0.3,
        y = (y_left + y_right) / 2,
        text = sprintf("<b>LATE = %.2f</b>", y_right - y_left),
        showarrow = FALSE, xanchor = "left",
        font = list(color = "#2aa198", size = 12)
      ))
    }

    p |> plotly::layout(
      shapes = shapes,
      annotations = annotations,
      title = list(
        text = sprintf("Regression Discontinuity Design<br><sup>Shaded region = bandwidth (n = %d local obs)</sup>",
                       d$n_local),
        font = list(size = 14)),
      xaxis = list(title = "Running Variable (X)"),
      yaxis = list(title = "Outcome (Y)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.1),
      margin = list(t = 60)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── RD regression table ────────────────────────────────────────────
  output$ci_rd_table <- renderUI({
    req(ci_rd_data())
    d <- ci_rd_data()
    if (is.null(d$rd_mod)) {
      return(HTML('<p class="text-warning">Too few observations within bandwidth.
                   Increase bandwidth or sample size.</p>'))
    }

    s <- summary(d$rd_mod)
    coefs <- s$coefficients
    rows <- ""
    for (nm in rownames(coefs)) {
      est <- coefs[nm, "Estimate"]
      se  <- coefs[nm, "Std. Error"]
      pv  <- coefs[nm, "Pr(>|t|)"]
      stars <- if (pv < 0.001) "***" else if (pv < 0.01) "**" else if (pv < 0.05) "*" else ""
      hl <- if (nm == "Treat") "background-color: rgba(42,161,152,0.12);" else ""
      label <- switch(nm,
        "(Intercept)" = "Intercept (control at cutoff)",
        "Xc"          = "Slope (control side)",
        "Treat"       = "Treatment jump (LATE)",
        "Xc:Treat"    = "Slope difference (treat \u2212 control)",
        nm
      )
      rows <- paste0(rows, sprintf(
        '<tr style="%s"><td>%s</td><td>%.3f</td><td>%.3f</td><td>%s %s</td></tr>',
        hl, label, est, se, format.pval(pv, digits = 3), stars
      ))
    }

    late <- coefs["Treat", "Estimate"]
    bias <- late - d$effect
    bias_col <- if (abs(bias) > 0.3) "#dc322f" else "#2aa198"

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Term</th><th>Estimate</th><th>SE</th><th>p</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="small mb-1">R\u00b2 = %.3f &ensp; n (local) = %d</p>
        <p class="small mb-0">True effect = %.2f &ensp;
           <span style="color: %s; font-weight: 600;">Bias = %.3f</span></p>
      </div>',
      rows, s$r.squared, nrow(d$df_local), d$effect, bias_col, bias
    ))
  })

  # ── Bandwidth sensitivity plot ─────────────────────────────────────
  output$ci_rd_bw_plot <- plotly::renderPlotly({
    req(ci_rd_data())
    d <- ci_rd_data()
    req(!is.null(d$bw_df) && nrow(d$bw_df) > 2)

    bw_df <- d$bw_df
    bw_df$lo <- bw_df$est - 1.96 * bw_df$se
    bw_df$hi <- bw_df$est + 1.96 * bw_df$se

    plotly::plot_ly() |>
      plotly::add_trace(
        x = c(bw_df$bw, rev(bw_df$bw)),
        y = c(bw_df$hi, rev(bw_df$lo)),
        type = "scatter", mode = "none",
        fill = "toself", fillcolor = "rgba(38,139,210,0.15)",
        showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::add_trace(
        x = bw_df$bw, y = bw_df$est, type = "scatter", mode = "lines+markers",
        line = list(color = "#268bd2", width = 2),
        marker = list(color = "#268bd2", size = 5),
        name = "LATE", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("BW: %.2f<br>LATE: %.3f<br>95%% CI: [%.3f, %.3f]",
                            bw_df$bw, bw_df$est, bw_df$lo, bw_df$hi)
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = min(bw_df$bw), x1 = max(bw_df$bw),
               y0 = d$effect, y1 = d$effect,
               line = list(color = "#2aa198", dash = "dash", width = 1.5)),
          list(type = "line", x0 = d$bw, x1 = d$bw,
               y0 = min(bw_df$lo, na.rm = TRUE), y1 = max(bw_df$hi, na.rm = TRUE),
               line = list(color = "#b58900", dash = "dot", width = 1.5))
        ),
        annotations = list(list(
          x = d$bw, y = min(bw_df$lo, na.rm = TRUE),
          text = "selected", showarrow = FALSE, yanchor = "top", yshift = -5,
          font = list(color = "#b58900", size = 10)
        )),
        title = list(text = "Sensitivity to Bandwidth Choice", font = list(size = 13)),
        xaxis = list(title = "Bandwidth"),
        yaxis = list(title = "LATE Estimate"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 5 — Instrumental Variables
  # ═══════════════════════════════════════════════════════════════════════

  ci_iv_data <- eventReactive(input$ci_iv_run, {
    n      <- input$ci_iv_n
    effect <- input$ci_iv_effect
    z_str  <- input$ci_iv_inst_str
    u_str  <- input$ci_iv_confound

    set.seed(sample.int(10000, 1))

    # Unmeasured confounder
    U <- rnorm(n)
    # Instrument
    Z <- rnorm(n)
    # Endogenous X
    X <- z_str * Z + u_str * U + rnorm(n, sd = 0.5)
    # Outcome
    Y <- 1 + effect * X + u_str * U + rnorm(n, sd = 0.8)

    df <- data.frame(Z = Z, X = X, Y = Y, U = U)

    # OLS (biased)
    ols <- lm(Y ~ X, data = df)

    # 2SLS manually
    stage1 <- lm(X ~ Z, data = df)
    df$X_hat <- fitted(stage1)
    stage2 <- lm(Y ~ X_hat, data = df)

    # First-stage F
    s1_summary <- summary(stage1)
    f_stat <- s1_summary$fstatistic
    if (!is.null(f_stat)) {
      f_val <- f_stat[1]
      f_p   <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)
    } else {
      f_val <- NA; f_p <- NA
    }

    # Proper IV standard errors (via Wald estimator for just-identified case)
    # cov(Z,Y)/cov(Z,X)
    iv_wald <- cov(Z, Y) / cov(Z, X)

    list(df = df, ols = ols, stage1 = stage1, stage2 = stage2,
         effect = effect, z_str = z_str, u_str = u_str,
         f_val = f_val, f_p = f_p, iv_wald = iv_wald)
  })

  # ── IV path diagram (SVG) ─────────────────────────────────────────
  output$ci_iv_svg <- renderUI({
    req(ci_iv_data())
    d <- ci_iv_data()

    w <- 440; h <- 180
    node_r <- 22
    col_arrow <- "var(--bs-body-color)"
    font <- "var(--bs-body-color)"

    nodes <- list(Z = c(60, 90), X = c(210, 90), Y = c(370, 90), U = c(290, 30))

    # F-stat coloring for instrument strength
    f_col <- if (!is.na(d$f_val) && d$f_val >= 10) "#2aa198" else "#dc322f"

    svg_parts <- c(
      sprintf('<svg width="100%%" viewBox="0 0 %d %d" xmlns="http://www.w3.org/2000/svg"
               style="max-width:%dpx; display:block; margin:auto;">', w, h, w),
      '<defs><marker id="ci_iv_ah" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">',
      sprintf('<polygon points="0 0, 10 3.5, 0 7" fill="%s"/>', col_arrow),
      '</marker></defs>'
    )

    # Arrows
    draw_arrow <- function(from, to, color, lw, dash = "", label = "", lx = 0, ly = 0) {
      fx <- nodes[[from]][1]; fy <- nodes[[from]][2]
      tx <- nodes[[to]][1];   ty <- nodes[[to]][2]
      dx <- tx - fx; dy <- ty - fy; len <- sqrt(dx^2 + dy^2)
      ux <- dx/len; uy <- dy/len
      sx <- fx + ux*node_r; sy <- fy + uy*node_r
      ex <- tx - ux*node_r; ey <- ty - uy*node_r
      parts <- sprintf(
        '<line x1="%.0f" y1="%.0f" x2="%.0f" y2="%.0f"
         stroke="%s" stroke-width="%.1f" marker-end="url(#ci_iv_ah)" %s/>',
        sx, sy, ex, ey, color, lw, if (nchar(dash) > 0) sprintf('stroke-dasharray="%s"', dash) else ""
      )
      if (nchar(label) > 0) {
        mx <- (sx + ex)/2 + lx; my <- (sy + ey)/2 + ly
        parts <- c(parts, sprintf(
          '<text x="%.0f" y="%.0f" text-anchor="middle" font-size="11" fill="%s">%s</text>',
          mx, my, color, label
        ))
      }
      parts
    }

    svg_parts <- c(svg_parts,
      draw_arrow("Z", "X", f_col, 2.5, label = sprintf("F = %.1f", d$f_val), ly = -12),
      draw_arrow("X", "Y", "#268bd2", 2.5, label = "causal", ly = 15),
      draw_arrow("U", "X", "#dc322f", 1.5, dash = "5,4", label = "", lx = -15, ly = 0),
      draw_arrow("U", "Y", "#dc322f", 1.5, dash = "5,4", label = "", lx = 15, ly = 0)
    )

    # Nodes
    node_cols <- list(Z = "#859900", X = "#268bd2", Y = "#dc322f", U = "#b58900")
    for (nm in names(nodes)) {
      cx <- nodes[[nm]][1]; cy <- nodes[[nm]][2]
      col <- node_cols[[nm]]
      svg_parts <- c(svg_parts, sprintf(
        '<circle cx="%.0f" cy="%.0f" r="%d" fill="var(--bs-body-bg)"
         stroke="%s" stroke-width="2.5"/>',
        cx, cy, node_r, col
      ))
      svg_parts <- c(svg_parts, sprintf(
        '<text x="%.0f" y="%.0f" text-anchor="middle" dy="0.35em"
         font-size="14" font-weight="700" fill="%s">%s</text>',
        cx, cy, col, nm
      ))
    }

    svg_parts <- c(svg_parts, '</svg>')
    HTML(paste(svg_parts, collapse = "\n"))
  })

  # ── Stage 1 scatter ────────────────────────────────────────────────
  output$ci_iv_stage1_plot <- plotly::renderPlotly({
    req(ci_iv_data())
    d <- ci_iv_data()
    df <- d$df
    r2 <- summary(d$stage1)$r.squared

    # Prediction band
    ord <- order(df$Z)
    pred <- predict(d$stage1, interval = "confidence")
    zs <- df$Z[ord]
    fit_y <- pred[ord, "fit"]
    lwr <- pred[ord, "lwr"]
    upr <- pred[ord, "upr"]

    plotly::plot_ly() |>
      plotly::add_trace(
        x = c(zs, rev(zs)), y = c(upr, rev(lwr)),
        type = "scatter", mode = "none",
        fill = "toself", fillcolor = "rgba(133,153,0,0.15)",
        showlegend = FALSE, hoverinfo = "skip"
      ) |>
      plotly::add_markers(
        x = df$Z, y = df$X,
        marker = list(color = "#657b83", opacity = 0.3, size = 4),
        name = "Data", showlegend = FALSE,
        hoverinfo = "text",
        hovertext = sprintf("Z: %.2f<br>X: %.2f", df$Z, df$X)
      ) |>
      plotly::add_trace(
        x = zs, y = fit_y, type = "scatter", mode = "lines",
        line = list(color = "#859900", width = 2.5),
        name = "Fit", showlegend = FALSE
      ) |>
      plotly::layout(
        title = list(
          text = sprintf("First Stage: X ~ Z<br><sup>R\u00b2 = %.3f  |  F = %.1f  |  p %s</sup>",
                         r2, d$f_val,
                         if (d$f_p < 0.001) "< 0.001" else sprintf("= %.3f", d$f_p)),
          font = list(size = 14)),
        xaxis = list(title = "Instrument (Z)"),
        yaxis = list(title = "Endogenous Variable (X)"),
        margin = list(t = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── OLS vs 2SLS table ─────────────────────────────────────────────
  output$ci_iv_table <- renderUI({
    req(ci_iv_data())
    d <- ci_iv_data()

    ols_est  <- coef(d$ols)["X"]
    ols_se   <- summary(d$ols)$coefficients["X", "Std. Error"]
    tsls_est <- coef(d$stage2)["X_hat"]
    tsls_se  <- summary(d$stage2)$coefficients["X_hat", "Std. Error"]
    wald_est <- d$iv_wald

    fmt_row <- function(method, est, se, highlight = FALSE) {
      bias <- est - d$effect
      bias_col <- if (abs(bias) > 0.15) "#dc322f" else "#2aa198"
      bg <- if (highlight) "background-color: rgba(42,161,152,0.12);" else ""
      sprintf(
        '<tr style="%s"><td>%s</td><td>%.3f</td><td>%.3f</td>
         <td>[%.3f, %.3f]</td>
         <td style="color:%s; font-weight:600;">%.3f</td></tr>',
        bg, method, est, se, est - 1.96*se, est + 1.96*se, bias_col, bias
      )
    }

    rows <- paste0(
      fmt_row("OLS (biased)", ols_est, ols_se),
      fmt_row("2SLS (IV)", tsls_est, tsls_se, TRUE),
      sprintf('<tr style="background-color: rgba(42,161,152,0.06);">
        <td>Wald IV (cov ratio)</td><td>%.3f</td>
        <td colspan="2">\u2014</td>
        <td style="color:%s; font-weight:600;">%.3f</td></tr>',
        wald_est,
        if (abs(wald_est - d$effect) > 0.15) "#dc322f" else "#2aa198",
        wald_est - d$effect
      )
    )

    HTML(sprintf('
      <div style="padding: 0.75rem; overflow-x: auto;">
        <table class="table table-sm">
          <thead><tr><th>Method</th><th>Estimate</th><th>SE</th>
                     <th>95%% CI</th><th>Bias</th></tr></thead>
          <tbody>%s</tbody>
        </table>
        <p class="text-muted small mb-0">True causal effect = %.2f</p>
      </div>', rows, d$effect))
  })

  # ── Weak instrument diagnostics ────────────────────────────────────
  output$ci_iv_diagnostics <- renderUI({
    req(ci_iv_data())
    d <- ci_iv_data()

    f_val <- d$f_val
    strength <- if (f_val >= 10) {
      '<span style="color: #2aa198; font-weight: 600;">Strong</span> (F \u2265 10)'
    } else if (f_val >= 5) {
      '<span style="color: #b58900; font-weight: 600;">Moderate</span> (5 \u2264 F < 10)'
    } else {
      '<span style="color: #dc322f; font-weight: 600;">Weak</span> (F < 5 \u2014 IV estimates unreliable!)'
    }

    ols_bias  <- abs(coef(d$ols)["X"] - d$effect)
    tsls_bias <- abs(coef(d$stage2)["X_hat"] - d$effect)

    HTML(sprintf('
      <div style="padding: 0.75rem;">
        <table class="table table-sm mb-2" style="max-width: 450px;">
          <tr><td><strong>First-stage F-statistic</strong></td>
              <td>%.2f (p %s)</td></tr>
          <tr><td><strong>Instrument strength</strong></td>
              <td>%s</td></tr>
          <tr><td><strong>OLS bias</strong></td>
              <td>%.3f</td></tr>
          <tr><td><strong>2SLS bias</strong></td>
              <td>%.3f</td></tr>
          <tr><td><strong>Confounding strength</strong></td>
              <td>%.2f</td></tr>
        </table>
        <p class="text-muted small mb-0">
          %s
        </p>
      </div>',
      f_val,
      if (d$f_p < 0.001) "< 0.001" else sprintf("= %.3f", d$f_p),
      strength, ols_bias, tsls_bias, d$u_str,
      if (f_val < 10)
        "Try increasing instrument strength. With weak instruments, 2SLS can be more biased than OLS and CIs have poor coverage."
      else
        "The instrument is strong enough for reliable 2SLS estimation. Compare the bias of OLS vs. 2SLS above."
    ))
  })

  # ═══════════════════════════════════════════════════════════════════════
  # Tab 6 — Sensitivity Analysis
  # ═══════════════════════════════════════════════════════════════════════

  sens_reactive <- reactive({
    b    <- input$sens_b_obs
    se   <- input$sens_se_obs
    n    <- input$sens_n

    # Convert beta (log-scale effect) to risk ratio approximation
    rr_est <- exp(b)

    # E-value formula: E = RR + sqrt(RR * (RR - 1))
    eval_pt  <- rr_est + sqrt(rr_est * (rr_est - 1))

    # E-value for CI lower bound (null = RR 1)
    rr_lower <- exp(b - 1.96 * se)
    eval_ci  <- if (rr_lower > 1) rr_lower + sqrt(rr_lower * (rr_lower - 1))
                else 1

    # Fragility index: how many events need to flip to make p >= 0.05
    z_obs <- b / se
    z_crit <- qnorm(0.975)
    # Delta z needed to reduce to critical
    delta_z <- z_obs - z_crit
    # Approximate n change: delta_z ≈ sqrt(n_extra) * b_se_reduction
    frag_n <- ceiling((delta_z * se)^2 * n)

    list(rr_est = rr_est, eval_pt = eval_pt, eval_ci = eval_ci,
         frag_n = max(1, frag_n), z_obs = z_obs, b = b, se = se)
  })

  output$sens_eval_summary <- renderUI({
    r <- sens_reactive()
    col_pt <- if (r$eval_pt > 3) "#859900" else if (r$eval_pt > 1.5) "#b58900" else "#dc322f"
    col_ci <- if (r$eval_ci > 2) "#859900" else if (r$eval_ci > 1.2) "#b58900" else "#dc322f"
    mkrow <- function(l, v, col) tags$tr(
      tags$td(l),
      tags$td(style = paste0("font-weight:600; color:", col, ";"), v)
    )
    tags$div(
      tags$table(class = "table table-sm",
        tags$tbody(
          mkrow("Observed RR (exp(\u03b2))", sprintf("%.3f", r$rr_est), "#657b83"),
          mkrow("E-value (point estimate)", sprintf("%.3f", r$eval_pt), col_pt),
          mkrow("E-value (95% CI lower)", sprintf("%.3f", r$eval_ci), col_ci),
          tags$tr(tags$td(colspan = "2",
            tags$p(class = "text-muted", style = "font-size: 0.82rem; margin: 4px 0 0;",
              if (r$eval_pt > 3) "\u2705 Large E-value: result is robust to strong confounding."
              else if (r$eval_pt > 1.5) "\u26a0\ufe0f Moderate E-value: plausible confounder could explain result."
              else "\u274c Small E-value: result is fragile."
            )
          ))
        )
      )
    )
  })

  output$sens_fragility <- renderUI({
    r <- sens_reactive()
    col <- if (r$frag_n > 10) "#859900" else if (r$frag_n > 3) "#b58900" else "#dc322f"
    tags$div(class = "text-center mt-2",
      tags$h2(as.character(r$frag_n), style = paste0("font-size: 2.5rem; color:", col, ";")),
      tags$p(class = "text-muted", "Fragility index"),
      tags$p(style = "font-size: 0.83rem;",
        sprintf("Changing ~%d observations would shift p\u2265 0.05.", r$frag_n)),
      tags$p(style = "font-size: 0.83rem;",
        sprintf("Current z = %.2f | Critical z = 1.96", r$z_obs))
    )
  })

  output$sens_contour <- renderPlotly({
    b   <- input$sens_b_obs
    rr_max_exp <- input$sens_rr_conf_exp
    rr_max_out <- input$sens_rr_conf_out

    rr_est <- exp(b)
    # Grid
    rr_e <- seq(1, rr_max_exp, length.out = 80)
    rr_o <- seq(1, rr_max_out, length.out = 80)
    # Bias formula: observed RR = true RR × (rr_e × rr_o) / (rr_e + rr_o - 1)
    # We ask: what (rr_e, rr_o) would reduce observed RR to 1?
    # bias_factor = rr_e * rr_o / (rr_e + rr_o - 1)
    z_grid <- outer(rr_e, rr_o, function(e, o) {
      bf <- e * o / (e + o - 1)
      rr_est / bf  # de-biased RR
    })

    # Contour at z_grid = 1 (i.e., bias factor equals observed RR)
    plot_ly(
      x = rr_e, y = rr_o, z = z_grid,
      type = "contour",
      colorscale = list(c(0, "#fdf6e3"), c(0.5, "#268bd2"), c(1, "#073642")),
      contours = list(
        coloring = "fill",
        showlabels = TRUE
      ),
      colorbar = list(title = "De-biased RR")
    ) |>
      add_contour(
        x = rr_e, y = rr_o, z = z_grid,
        contours = list(
          start = 1, end = 1, size = 0,
          coloring = "lines"
        ),
        line = list(color = "#dc322f", width = 3),
        showscale = FALSE,
        name = "Null contour (RR=1)"
      ) |>
      layout(
        xaxis = list(title = "Confounder\u2013Exposure RR"),
        yaxis = list(title = "Confounder\u2013Outcome RR"),
        title = list(
          text = sprintf("Red line = combinations that explain away RR=%.2f | E-value = %.2f",
                         rr_est, rr_est + sqrt(rr_est * (rr_est - 1))),
          font = list(size = 11)
        )
      )
  })

  })
}
