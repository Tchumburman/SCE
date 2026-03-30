# Module: IRT Models (consolidated)
# Tabs: Unidimensional | Polytomous | Multidimensional | Nominal Response | Bayesian

# ── UI ──────────────────────────────────────────────────────────────────
irt_models_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "IRT Models",
  icon = icon("wave-square"),
  navset_card_underline(

    # ── Tab 1: Unidimensional IRT ─────────────────────────────────────
    nav_panel(
      "Unidimensional",
      navset_card_underline(
        nav_panel(
          "ICC Explorer",
          layout_sidebar(
            sidebar = sidebar(
              width = 300,
              selectInput(ns("irt_model"), "Model",
                          choices = c("1PL (Rasch)", "2PL", "3PL")),
              sliderInput(ns("irt_b"), "Difficulty (b)", min = -3, max = 3, value = 0, step = 0.1),
              conditionalPanel(ns = ns, 
                "input.irt_model !== '1PL (Rasch)'",
                sliderInput(ns("irt_a"), "Discrimination (a)", min = 0.2, max = 3.0,
                            value = 1.0, step = 0.1)
              ),
              conditionalPanel(ns = ns, 
                "input.irt_model === '3PL'",
                sliderInput(ns("irt_c"), "Guessing (c)", min = 0, max = 0.5,
                            value = 0.2, step = 0.05)
              ),
              numericInput(ns("irt_n_choices"), "Answer choices", value = 4, min = 2, max = 6, step = 1)
            ),
            explanation_box(
              tags$strong("Item Characteristic Curve (ICC)"),
              tags$p("Item Response Theory (IRT) models the probability of a correct
                      response as a function of the person's latent ability (\u03b8) and the
                      item's properties. Unlike CTT, IRT separates person and item parameters,
                      allowing them to be estimated independently."),
              tags$p(
                tags$b("1PL (Rasch):"), " P(\u03b8) = 1/(1 + exp(-(\u03b8 - b))). Items differ only in difficulty.", tags$br(),
                tags$b("2PL:"), " adds discrimination (a): steeper curves = better differentiation.", tags$br(),
                tags$b("3PL:"), " adds guessing (c): a lower asymptote for low-ability examinees."
              ),
              tags$p(tags$b("Answer choices:"), " For 3PL, the theoretical chance level is 1/k where k = number of answer choices.",
                     " The guessing parameter c is shown relative to this baseline."),
              tags$p("The information function I(\u03b8) shows where each item is most useful for
                      measurement. High information at a given \u03b8 means the item discriminates
                      well at that ability level. Item information is proportional to the square
                      of the slope of the ICC and inversely related to the variance of the response.
                      Test information is the sum of item information functions, and its inverse
                      gives the standard error of the ability estimate at each point."),
              guide = tags$ol(
                tags$li("Select a model (1PL, 2PL, or 3PL)."),
                tags$li("Drag the difficulty slider (b) \u2014 the curve shifts left/right."),
                tags$li("For 2PL/3PL, adjust discrimination (a) \u2014 the curve becomes steeper or flatter."),
                tags$li("For 3PL, adjust guessing (c) \u2014 the lower asymptote rises."),
                tags$li("Set the number of answer choices \u2014 the chance level line (1/k) is shown as a dotted line."),
                tags$li("The red dashed line marks b (where P = 0.5 for 1PL/2PL).")
              )
            ),
            card(full_screen = TRUE, card_header("Item Characteristic Curve"),
                 plotlyOutput(ns("irt_icc_plot"), height = "420px"))
          )
        ),
        nav_panel(
          "Compare Items",
          layout_sidebar(
            sidebar = sidebar(
              width = 300,
              selectInput(ns("irt_cmp_model"), "Model",
                          choices = c("1PL (Rasch)", "2PL", "3PL")),
              sliderInput(ns("irt_n_items"), "Number of items", min = 2, max = 8, value = 4),
              actionButton(ns("irt_cmp_gen"), "Generate items", class = "btn-success w-100 mb-2"),
              tags$hr(),
              tags$strong("Edit Item Parameters"),
              tags$p(class = "text-muted small", "Modify parameters below and click 'Apply' to update the plots."),
              uiOutput(ns("irt_param_inputs")),
              actionButton(ns("irt_apply_params"), "Apply parameters", class = "btn-outline-primary w-100 mt-2")
            ),
            explanation_box(
              tags$strong("Comparing Multiple Items"),
              tags$p("When multiple items are combined into a test, each contributes
                      information at different points on the ability scale. The Test
                      Information Function (TIF) sums individual item information \u2014
                      its peak shows where the test measures most precisely. The
                      inverse of information gives the standard error: SE(\u03b8) = 1/\u221aI(\u03b8)."),
              tags$p("A test with items clustered at one difficulty level is very precise
                      for that ability range but poor elsewhere. A broader spread of
                      difficulties gives more uniform precision across the ability continuum.
                      This trade-off is central to test design: should the test measure well
                      for everyone (broad information) or very well for a specific population
                      (peaked information)? Adaptive tests (CAT) resolve this by selecting
                      items matched to each examinee\u2019s estimated ability."),
              tags$p("The conditional standard error of measurement, SE(\u03b8) = 1/\u221aI(\u03b8),
                      varies across the ability scale \u2014 unlike CTT, where a single SEM applies
                      to all examinees. This is one of IRT\u2019s major advantages: it provides
                      precision estimates tailored to each individual."),
              tags$p(tags$b("Manual editing:"), " After generating items, you can fine-tune each item's
                      parameters using the input fields in the sidebar, then click 'Apply parameters'."),
              guide = tags$ol(
                tags$li("Select the IRT model and number of items."),
                tags$li("Click 'Generate items' to create items with random parameters."),
                tags$li("Optionally edit the item parameters in the sidebar and click 'Apply parameters'."),
                tags$li("Left: the ICC for each item. Right: the total test information curve (green) and SE (red dashed)."),
                tags$li("Check the parameter table below for each item's a, b, c values.")
              )
            ),
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("Item Characteristic Curves"),
                   plotlyOutput(ns("irt_multi_icc"), height = "400px")),
              card(full_screen = TRUE, card_header("Test Information Function"),
                   plotlyOutput(ns("irt_info_plot"), height = "400px"))
            ),
            card(card_header("Item Parameters"), tableOutput(ns("irt_params_table")))
          )
        )
      )
    ),

    # ── Tab 2: Polytomous IRT ─────────────────────────────────────────
    nav_panel(
      "Polytomous",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("pirt_model"), "Model",
            choices = c("Graded Response (GRM)" = "grm",
                        "Partial Credit (PCM)" = "pcm",
                        "Rating Scale (RSM)" = "rsm"),
            selected = "grm"
          ),
          sliderInput(ns("pirt_cats"), "Response categories", min = 3, max = 7,
                      value = 5, step = 1),
          sliderInput(ns("pirt_disc"), "Discrimination (a)", min = 0.3, max = 3,
                      value = 1.5, step = 0.1),
          sliderInput(ns("pirt_diff_spread"), "Threshold spread", min = 0.5, max = 3,
                      value = 1.5, step = 0.25),
          actionButton(ns("pirt_go"), "Plot", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Polytomous IRT Models"),
          tags$p("When items have more than two response categories (e.g., Likert scales),
                  polytomous IRT models are used."),
          tags$ul(
            tags$li(tags$strong("GRM (Graded Response):"), " Models cumulative probabilities P(X \u2265 k)
                    at each threshold. Each threshold has its own difficulty but shares a common
                    discrimination parameter. Best when category boundaries reflect different
                    levels of the latent trait."),
            tags$li(tags$strong("PCM (Partial Credit):"), " Each item has unique step difficulties,
                    representing the difficulty of moving from one category to the next. There
                    is no discrimination parameter (fixed at 1, like Rasch). Appropriate when
                    steps represent qualitatively different achievements."),
            tags$li(tags$strong("RSM (Rating Scale):"), " All items share identical step parameters,
                    differing only in overall location. A constrained version of PCM suitable
                    when all items use the same response format with equivalent category
                    spacing (e.g., a uniform Likert scale).")
          ),
          tags$p("The category response curves (CRCs) show the probability of each response
                  category as a function of \u03b8. Each category has a region of \u03b8 where it is
                  most likely. If categories overlap heavily or a category is never the most
                  probable response, the item may have too many response options or poorly
                  defined categories."),
          tags$p("Choosing between GRM, PCM, and RSM depends on the item format and measurement
                  goals. The GRM is most flexible and is widely used for Likert-type items. The
                  PCM is appropriate when items represent tasks with distinct, ordered steps
                  (e.g., partial credit scoring on a math problem). The RSM is the most
                  parsimonious and is suitable when all items share the same rating scale
                  structure with equivalent category interpretations."),
          tags$p("Item information in polytomous models peaks where the CRCs change most rapidly
                  and is generally higher than for dichotomous items because more response categories
                  carry more information about \u03b8. Well-designed polytomous items with 4\u20135
                  ordered categories tend to maximise measurement precision across a broad range
                  of the latent trait."),
          guide = tags$ol(
            tags$li("Choose a model and set the number of categories."),
            tags$li("Adjust discrimination and threshold spread."),
            tags$li("Click 'Plot' to see category response curves (CRCs) and item information."),
            tags$li("Compare models: GRM CRCs are bell-shaped; PCM/RSM have different shapes.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Category Response Curves"),
               plotlyOutput(ns("pirt_crc"), height = "400px")),
          card(full_screen = TRUE,
               card_header("Item Information Function"),
               plotlyOutput(ns("pirt_info"), height = "300px"))
        )
      )
    ),

    # ── Tab 3: Multidimensional IRT ───────────────────────────────────
    nav_panel(
      "Multidimensional",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mirt_items"), "Number of items", min = 6, max = 20,
                      value = 10, step = 2),
          sliderInput(ns("mirt_a1"), "Item 1 loading on Dim 1", min = 0, max = 3,
                      value = 2, step = 0.1),
          sliderInput(ns("mirt_a2"), "Item 1 loading on Dim 2", min = 0, max = 3,
                      value = 0.3, step = 0.1),
          sliderInput(ns("mirt_corr"), "Dimension correlation", min = -0.8, max = 0.8,
                      value = 0.3, step = 0.1),
          actionButton(ns("mirt_go"), "Simulate", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Multidimensional IRT (MIRT)"),
          tags$p("When items measure more than one latent trait, unidimensional IRT
                  is insufficient. MIRT extends IRT to multiple dimensions."),
          tags$p("The 2PL MIRT model: P(X=1|\u03b8) = 1 / (1 + exp(\u2212(a\u2081\u03b8\u2081 + a\u2082\u03b8\u2082 + d))).
                  Each item has loadings (a) on each dimension and a difficulty (d)."),
          tags$ul(
            tags$li(tags$strong("Item direction:"), " The vector (a\u2081, a\u2082) shows which dimension
                    an item primarily measures. An item with a\u2081 >> a\u2082 is predominantly
                    a measure of dimension 1."),
            tags$li(tags$strong("MDISC:"), " Multidimensional discrimination = \u221a(a\u2081\u00b2 + a\u2082\u00b2).
                    Analogous to the unidimensional a parameter; higher values mean the item
                    discriminates more sharply."),
            tags$li(tags$strong("Item response surface:"), " In 2D, the ICC becomes a surface over the
                    (\u03b8\u2081, \u03b8\u2082) plane, with contour lines indicating equal probability.")
          ),
          tags$p("MIRT is essential when assuming unidimensionality is untenable \u2014 for
                  example, maths items that require both computation skill and reading
                  comprehension. Ignoring a relevant dimension can distort item parameter
                  estimates and ability scores. However, MIRT requires substantially larger
                  samples for stable estimation compared to unidimensional models."),
          guide = tags$ol(
            tags$li("Set loadings for a focal item and the dimension correlation."),
            tags$li("Click 'Simulate' to generate items and see the loading plot."),
            tags$li("Arrows show each item's direction in the 2D ability space."),
            tags$li("Longer arrows = more discriminating items; direction = which dimension the item measures.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Item Loading Vectors"),
               plotlyOutput(ns("mirt_vectors"), height = "420px")),
          card(full_screen = TRUE, card_header("Item Response Surface (Focal Item)"),
               plotlyOutput(ns("mirt_surface"), height = "400px")),
          card(card_header("Item Parameters"), tableOutput(ns("mirt_params")))
        )
      )
    ),

    # ── Tab 4: Nominal Response ───────────────────────────────────────
    nav_panel(
      "Nominal Response",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("nom_cats"), "Number of options", min = 3, max = 6,
                      value = 4, step = 1),
          sliderInput(ns("nom_a_correct"), "Slope for correct option", min = 1, max = 3,
                      value = 2, step = 0.1),
          sliderInput(ns("nom_a_attract"), "Slope for attractive distractor", min = -1.5, max = 0.5,
                      value = -0.5, step = 0.1),
          actionButton(ns("nom_go"), "Plot", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Nominal Response Model (NRM)"),
          tags$p("The NRM is for items where response options are unordered (e.g.,
                  multiple-choice distractors). Each option has its own slope (a_k) and
                  intercept (c_k) parameters."),
          tags$p("P(response = k | \u03b8) = exp(a_k\u03b8 + c_k) / \u03a3 exp(a_j\u03b8 + c_j)"),
          tags$ul(
            tags$li("The correct option typically has a positive slope (probability increases with ability)."),
            tags$li("Attractive distractors have negative slopes (appeal to low-ability examinees)."),
            tags$li("Non-functional distractors have slopes near zero \u2014 they are chosen
                    regardless of ability and contribute nothing to measurement.")
          ),
          tags$p("The NRM is valuable for diagnostic purposes: by examining distractor trace
                  lines, test developers can identify which wrong answers are attractive to
                  low-ability examinees (potentially revealing specific misconceptions) and
                  which distractors are ineffective and should be revised. It subsumes the
                  2PL and 3PL as special cases when applied to dichotomous items."),
          guide = tags$ol(
            tags$li("Set the slopes for the correct answer and an attractive distractor."),
            tags$li("Click 'Plot' to see option characteristic curves (OCCs)."),
            tags$li("Notice how the attractive distractor peaks at low ability."),
            tags$li("This provides rich diagnostic information about how distractors function.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Option Characteristic Curves"),
               plotlyOutput(ns("nom_occ"), height = "400px")),
          card(card_header("Parameters"), tableOutput(ns("nom_params")))
        )
      )
    ),

    # ── Tab 5: Bayesian IRT ───────────────────────────────────────────
    nav_panel(
      "Bayesian",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("birt_items"), "Number of items", min = 5, max = 30,
                      value = 15, step = 5),
          sliderInput(ns("birt_true_theta"), "True \u03b8", min = -3, max = 3,
                      value = 0.5, step = 0.25),
          selectInput(ns("birt_prior"), "Prior for \u03b8",
            choices = c("N(0, 1) standard" = "standard",
                        "N(0, 0.5) informative" = "inform",
                        "N(0, 3) diffuse" = "diffuse"),
            selected = "standard"
          ),
          actionButton(ns("birt_go"), "Estimate", class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Bayesian IRT"),
          tags$p("In Bayesian IRT, item parameters and person abilities have prior
                  distributions. The posterior distribution of \u03b8 combines the prior
                  belief with the likelihood from observed responses."),
          tags$p("Posterior \u221d Prior \u00d7 Likelihood"),
          tags$ul(
            tags$li(tags$strong("MLE:"), " Maximises the likelihood function (ignores the prior). Produces
                    infinite estimates for perfect (all correct) or zero (all incorrect) response
                    patterns, which is a practical limitation."),
            tags$li(tags$strong("EAP (Expected A Posteriori):"), " The mean of the posterior distribution.
                    Always finite and tends to shrink extreme scores toward the prior mean.
                    With a standard Normal prior, this is equivalent to adding a small amount
                    of regularisation."),
            tags$li(tags$strong("MAP (Maximum A Posteriori):"), " The mode of the posterior. Less shrinkage
                    than EAP but more than MLE. Equivalent to penalised MLE.")
          ),
          tags$p("The choice of prior matters most for short tests and extreme scores. With
                  many items, the likelihood dominates and all three estimators converge. For
                  adaptive testing (CAT), EAP is often preferred because it provides stable
                  estimates after every item, even at the start of the test when few responses
                  are available. The posterior standard deviation serves as a natural measure
                  of estimation precision."),
          guide = tags$ol(
            tags$li("Set the true \u03b8 and choose a prior."),
            tags$li("Click 'Estimate' to simulate responses and compute posteriors."),
            tags$li("Compare prior, likelihood, and posterior."),
            tags$li("Try an informative vs. diffuse prior to see how the prior affects the estimate.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Prior, Likelihood, and Posterior"),
               plotlyOutput(ns("birt_plot"), height = "420px")),
          card(card_header("Estimation Summary"), tableOutput(ns("birt_table")))
        )
      )
    ),

    # ── Tab 6: Item Fit — Empirical ICC Misfit ────────────────────────
    nav_panel(
      "Item Fit",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          numericInput(ns("ifit_n"), "Examinees", value = 2000, min = 500, max = 10000, step = 500),
          numericInput(ns("ifit_k"), "Items", value = 15, min = 5, max = 30, step = 1),
          numericInput(ns("ifit_bins"), "Ability bins", value = 10, min = 5, max = 20, step = 1),
          actionButton(ns("ifit_gen"), "Generate Data", class = "btn-success w-100 mb-2"),
          hr(),
          uiOutput(ns("ifit_item_selector")),
          checkboxInput(ns("ifit_misfit"), "Inject misfit on selected item", value = FALSE),
          selectInput(ns("ifit_misfit_type"), "Misfit type",
                      choices = c("Excess guessing" = "guess",
                                  "Lower discrimination" = "low_a",
                                  "Bimodal (item compromise)" = "bimodal")),
          conditionalPanel(ns = ns, "input.ifit_misfit", class = "text-muted small",
            "The selected item's responses are replaced with a misfit pattern so you can see how observed proportions deviate from the expected ICC."
          )
        ),
        explanation_box(
          tags$strong("Empirical Item Fit"),
          tags$p("A core diagnostic in IRT is checking whether the model's predicted
                  Item Characteristic Curve (ICC) matches the observed data. To do this,
                  examinees are grouped into ability bins based on their estimated \u03b8,
                  and the observed proportion correct is computed for each bin."),
          tags$p("When the model fits well, the observed proportions should fall close
                  to the theoretical ICC. Systematic deviations indicate misfit:"),
          tags$ul(
            tags$li(tags$strong("Excess guessing:"), " Low-ability bins show higher observed proportions than expected."),
            tags$li(tags$strong("Low discrimination:"), " The observed curve is flatter than the theoretical ICC."),
            tags$li(tags$strong("Item compromise:"), " High-ability examinees who saw the item leaked perform too well, creating a bump.")
          ),
          tags$p("Formal fit statistics like S-X\u00b2 (Orlando & Thissen) and infit/outfit
                  (Rasch) quantify this discrepancy. This visualisation gives you the
                  intuition behind those numbers."),
          tags$p("Infit is weighted by information and is sensitive to unexpected responses
                  near an item's difficulty level \u2014 the region where the item is most
                  informative. Outfit is an unweighted statistic and is more sensitive to
                  surprising responses at the extremes (very easy items answered incorrectly
                  by high-ability examinees, or hard items answered correctly by low-ability
                  ones). Conventional thresholds flag mean-square infit/outfit values outside
                  0.5\u20131.5 for high-stakes tests and 0.5\u20132.0 for rating scales."),
          tags$p("When an item shows misfit, the appropriate response depends on the source.
                  Items with excessive guessing might be retained with a 3PL model but removed
                  from Rasch calibration. Items that are too flat (low discrimination) may
                  simply add noise and reduce measurement precision. Chronically misfitting
                  items should be reviewed for content ambiguity, scoring key errors, or
                  construct-irrelevant variance before a decision is made to retain or drop them."),
          guide = tags$ol(
            tags$li("Click 'Generate Data' to simulate IRT responses."),
            tags$li("Select an item to inspect its empirical vs. expected ICC."),
            tags$li("Toggle 'Inject misfit' and choose a misfit type to see how deviations appear."),
            tags$li("Try different bin counts to see how granularity affects the diagnostic.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE, card_header("Observed vs. Expected ICC"),
               plotlyOutput(ns("ifit_icc_plot"), height = "420px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Item Parameters"), tableOutput(ns("ifit_params_table"))),
            card(card_header("Fit Statistics"), tableOutput(ns("ifit_fit_table")))
          )
        )
      )
    ),

    # ── Tab 7: Model Comparison — 1PL vs 2PL vs 3PL ────────────────────
    nav_panel(
      "Model Comparison",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          numericInput(ns("mcmp_n"), "Examinees", value = 1000, min = 500, max = 5000, step = 500),
          numericInput(ns("mcmp_k"), "Items", value = 10, min = 5, max = 25, step = 1),
          selectInput(ns("mcmp_true_model"), "True generating model",
                      choices = c("1PL", "2PL", "3PL"), selected = "2PL"),
          actionButton(ns("mcmp_run"), "Simulate & Fit", class = "btn-success w-100 mb-2"),
          hr(),
          uiOutput(ns("mcmp_item_selector"))
        ),
        explanation_box(
          tags$strong("IRT Model Comparison: 1PL vs 2PL vs 3PL"),
          tags$p("When fitting IRT models, we must choose the right level of complexity.
                  A 1PL (Rasch) model assumes all items share equal discrimination and no
                  guessing. The 2PL adds item-specific discrimination, and the 3PL adds a
                  lower asymptote (pseudo-guessing) parameter."),
          tags$p("More complex models always fit at least as well, but extra parameters
                  risk over-fitting. Information criteria (AIC, BIC) penalise complexity;
                  the Likelihood Ratio Test (LRT) formally tests whether the improvement
                  in fit justifies the extra parameters."),
          tags$p("This tab lets you generate data under a known true model, then fit all
                  three and compare. When the true model is 1PL, the extra parameters in
                  2PL/3PL should not significantly improve fit. When the true model is 3PL,
                  simpler models should show noticeable misfit in the ICC overlays."),
          tags$p("In practice, the 2PL is often a sensible default for large-scale assessments:
                  it allows items to differ in how sharply they differentiate between ability levels,
                  which is realistic for most item pools, while avoiding the instability of
                  estimating a guessing parameter from limited data. The 3PL is most appropriate
                  when the test is speeded or when examinees are likely to guess on items they
                  cannot answer (e.g., multiple-choice achievement tests with low-ability groups)."),
          tags$p("The Likelihood Ratio Test (LRT) is only valid for nested model comparisons
                  (1PL vs. 2PL, or 2PL vs. 3PL) and requires the same data. AIC rewards
                  parsimony less aggressively than BIC, meaning BIC more often selects simpler
                  models. When sample sizes are large, even trivially small parameter differences
                  will be statistically significant \u2014 in that case, focus on effect sizes
                  and the ICC overlay rather than p-values alone."),
          guide = tags$ol(
            tags$li("Choose the true generating model and sample size."),
            tags$li("Click 'Simulate & Fit' to generate data and fit all three models."),
            tags$li("Check the Information Criteria table \u2014 the star marks the best model."),
            tags$li("Review the Likelihood Ratio Tests for nested comparisons."),
            tags$li("Select individual items to see how the fitted ICCs compare to the truth.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Information Criteria"), tableOutput(ns("mcmp_ic_table"))),
            card(card_header("Likelihood Ratio Tests"), tableOutput(ns("mcmp_lrt_table")))
          ),
          card(full_screen = TRUE, card_header("Fitted vs. True ICC"),
               plotlyOutput(ns("mcmp_icc_plot"), height = "420px"))
        )
      )
    )
  )
)
}

# ── Helper for PCM/RSM cumulative sum ─────────────────────────────────
sum_seq <- function(theta, tau, k, a) {
  s <- rep(0, length(theta))
  for (j in seq_len(k - 1)) {
    s <- s + a * (theta - tau[j])
  }
  s
}

# ── Server ──────────────────────────────────────────────────────────────


irt_models_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Shared IRT helpers ──────────────────────────────────────────────
  irt_prob <- function(theta, a = 1, b = 0, c = 0) {
    c + (1 - c) / (1 + exp(-a * (theta - b)))
  }
  irt_info <- function(theta, a = 1, b = 0, c = 0) {
    p <- irt_prob(theta, a, b, c)
    q <- 1 - p
    num <- a^2 * (p - c)^2 * q
    denom <- (1 - c)^2 * p
    ifelse(denom > 0, num / denom, 0)
  }

  # ── Unidimensional IRT ──────────────────────────────────────────────
  output$irt_icc_plot <- renderPlotly({
    model <- input$irt_model
    b <- input$irt_b
    a <- if (model == "1PL (Rasch)") 1 else input$irt_a
    cc <- if (model == "3PL") input$irt_c else 0
    n_choices <- max(2, input$irt_n_choices %||% 4)
    chance <- 1 / n_choices

    theta <- seq(-4, 4, length.out = 500)
    pr <- irt_prob(theta, a, b, cc)

    sub <- paste0(model, ":  b = ", b)
    if (model != "1PL (Rasch)") sub <- paste0(sub, ",  a = ", a)
    if (model == "3PL") sub <- paste0(sub, ",  c = ", cc)
    sub <- paste0(sub, "  |  ", n_choices, " choices (chance = ", round(chance, 3), ")")

    hover_txt <- paste0("\u03b8 = ", round(theta, 3), "<br>P = ", round(pr, 4))

    shapes <- list(
      list(type = "line", x0 = -4, x1 = 4, y0 = chance, y1 = chance,
           line = list(color = "grey60", width = 1, dash = "dot")),
      list(type = "line", x0 = b, x1 = b, y0 = 0, y1 = 1,
           line = list(color = "#e31a1c", width = 1.5, dash = "dash"),
           opacity = 0.5)
    )
    annots <- list(
      list(x = 3.5, y = chance + 0.03, text = paste0("Chance = 1/", n_choices),
           showarrow = FALSE, font = list(size = 11, color = "grey40")),
      list(x = b + 0.15, y = 0.95, text = paste0("b = ", b),
           showarrow = FALSE, font = list(size = 11, color = "#e31a1c"), xanchor = "left"),
      list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
           text = sub, showarrow = FALSE, font = list(size = 12))
    )

    if (cc > 0) {
      shapes <- c(shapes, list(
        list(type = "line", x0 = -4, x1 = 4, y0 = cc, y1 = cc,
             line = list(color = "#006d2c", width = 1.5, dash = "dash"),
             opacity = 0.5)
      ))
      annots <- c(annots, list(
        list(x = -3.5, y = cc + 0.03, text = paste0("c = ", cc),
             showarrow = FALSE, font = list(size = 12, color = "#006d2c"))
      ))
    }

    plotly::plot_ly() |>
      plotly::add_trace(
        x = theta, y = pr, type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Ability (\u03b8)"),
        yaxis = list(title = "P(correct)", range = c(0, 1)),
        shapes = shapes,
        annotations = annots,
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  irt_items <- reactiveVal(NULL)

  observe({
    if (is.null(irt_items())) {
      k <- 4
      set.seed(7623)
      b <- round(sort(runif(k, -2.5, 2.5)), 2)
      irt_items(data.frame(Item = seq_len(k), a = rep(1, k), b = b, c = rep(0, k)))
    }
  })

  observeEvent(input$irt_cmp_gen, {
    set.seed(sample(1:10000, 1))
    k <- input$irt_n_items
    model <- input$irt_cmp_model
    b <- round(sort(runif(k, -2.5, 2.5)), 2)
    a <- if (model == "1PL (Rasch)") rep(1, k) else round(runif(k, 0.5, 2.5), 2)
    cc <- if (model == "3PL") round(runif(k, 0.05, 0.35), 2) else rep(0, k)
    irt_items(data.frame(Item = seq_len(k), a = a, b = b, c = cc))
  })

  output$irt_param_inputs <- renderUI({
    params <- irt_items()
    req(params)
    model <- input$irt_cmp_model

    param_rows <- lapply(seq_len(nrow(params)), function(i) {
      row_inputs <- list(
        tags$strong(paste0("Item ", i), style = "margin-bottom: 4px; display: block;")
      )
      if (model != "1PL (Rasch)") {
        row_inputs <- c(row_inputs, list(
          numericInput(session$ns(paste0("irt_edit_a_", i)), paste0("a", i),
                       value = params$a[i], min = 0.2, max = 3.0, step = 0.1, width = "100%")
        ))
      }
      row_inputs <- c(row_inputs, list(
        numericInput(session$ns(paste0("irt_edit_b_", i)), paste0("b", i),
                     value = params$b[i], min = -3, max = 3, step = 0.1, width = "100%")
      ))
      if (model == "3PL") {
        row_inputs <- c(row_inputs, list(
          numericInput(session$ns(paste0("irt_edit_c_", i)), paste0("c", i),
                       value = params$c[i], min = 0, max = 0.5, step = 0.05, width = "100%")
        ))
      }
      row_inputs <- c(row_inputs, list(tags$hr(style = "margin: 5px 0;")))
      tagList(row_inputs)
    })
    tagList(param_rows)
  })

  observeEvent(input$irt_apply_params, {
    params <- irt_items()
    req(params)
    model <- input$irt_cmp_model
    k <- nrow(params)

    new_params <- data.frame(Item = seq_len(k))
    new_params$a <- if (model == "1PL (Rasch)") {
      rep(1, k)
    } else {
      sapply(seq_len(k), function(i) {
        val <- input[[paste0("irt_edit_a_", i)]]
        if (is.null(val) || is.na(val)) params$a[i] else val
      })
    }
    new_params$b <- sapply(seq_len(k), function(i) {
      val <- input[[paste0("irt_edit_b_", i)]]
      if (is.null(val) || is.na(val)) params$b[i] else val
    })
    new_params$c <- if (model == "3PL") {
      sapply(seq_len(k), function(i) {
        val <- input[[paste0("irt_edit_c_", i)]]
        if (is.null(val) || is.na(val)) params$c[i] else val
      })
    } else {
      rep(0, k)
    }
    irt_items(new_params)
  })

  output$irt_multi_icc <- renderPlotly({
    params <- irt_items()
    req(params)
    theta <- seq(-4, 4, length.out = 500)
    greens <- colorRampPalette(c("#99d8c9", "#00441b"))(nrow(params))

    p <- plot_ly()
    for (i in seq_len(nrow(params))) {
      pr <- irt_prob(theta, params$a[i], params$b[i], params$c[i])
      hover <- paste0("Item ", i,
                       "<br>\u03b8 = ", round(theta, 2),
                       "<br>P(correct) = ", round(pr, 3),
                       "<br>b = ", params$b[i],
                       "<br>a = ", params$a[i])
      p <- p |> add_trace(
        x = theta, y = pr, type = "scatter", mode = "lines",
        name = paste0("Item ", i, " (b=", params$b[i], ")"),
        line = list(color = greens[i], width = 2),
        hoverinfo = "text", text = hover
      )
    }
    p |> layout(
      xaxis = list(title = "Ability (\u03b8)"),
      yaxis = list(title = "P(correct)", range = c(0, 1)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.08),
      annotations = list(
        list(x = 0.5, y = 1.12, xref = "paper", yref = "paper",
             text = paste0(input$irt_cmp_model, "  |  ", nrow(params), " items"),
             showarrow = FALSE, font = list(size = 13))
      )
    )
  })

  output$irt_info_plot <- renderPlotly({
    params <- irt_items()
    req(params)
    theta <- seq(-4, 4, length.out = 500)
    test_info <- rowSums(sapply(seq_len(nrow(params)), function(i) {
      irt_info(theta, params$a[i], params$b[i], params$c[i])
    }))
    se <- 1 / sqrt(pmax(test_info, 0.001))

    plot_ly() |>
      add_trace(x = theta, y = test_info, type = "scatter", mode = "lines",
                name = "Information",
                line = list(color = "#238b45", width = 2.5),
                hoverinfo = "text",
                text = paste0("\u03b8 = ", round(theta, 2),
                              "<br>Information = ", round(test_info, 3))) |>
      add_trace(x = theta, y = se, type = "scatter", mode = "lines",
                name = "SE(\u03b8)", yaxis = "y2",
                line = list(color = "#e31a1c", width = 2, dash = "dash"),
                hoverinfo = "text",
                text = paste0("\u03b8 = ", round(theta, 2),
                              "<br>SE(\u03b8) = ", round(se, 3))) |>
      layout(
        xaxis = list(title = "Ability (\u03b8)"),
        yaxis = list(title = "Test Information", side = "left",
                     rangemode = "tozero"),
        yaxis2 = list(title = "SE(\u03b8)", side = "right",
                      overlaying = "y", rangemode = "tozero"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.08)
      )
  })

  output$irt_params_table <- renderTable({
    params <- irt_items()
    req(params)
    params
  }, hover = TRUE, spacing = "s", digits = 2)

  # ── Polytomous IRT ──────────────────────────────────────────────────
  pirt_result <- reactiveVal(NULL)

  observeEvent(input$pirt_go, {
    withProgress(message = "Fitting polytomous IRT model...", value = 0.1, {
    model <- input$pirt_model
    K <- input$pirt_cats
    a <- input$pirt_disc
    spread <- input$pirt_diff_spread

    theta <- seq(-4, 4, length.out = 300)
    b <- seq(-spread, spread, length.out = K - 1)

    if (model == "grm") {
      Pstar <- matrix(0, nrow = length(theta), ncol = K - 1)
      for (k in seq_len(K - 1)) {
        Pstar[, k] <- 1 / (1 + exp(-a * (theta - b[k])))
      }
      P <- matrix(0, nrow = length(theta), ncol = K)
      P[, 1] <- 1 - Pstar[, 1]
      for (k in 2:(K - 1)) {
        P[, k] <- Pstar[, k - 1] - Pstar[, k]
      }
      P[, K] <- Pstar[, K - 1]
    } else {
      tau <- b
      numer <- matrix(0, nrow = length(theta), ncol = K)
      for (k in seq_len(K)) {
        if (k == 1) {
          numer[, k] <- 1
        } else {
          numer[, k] <- exp(sum_seq(theta, tau, k, a))
        }
      }
      denom <- rowSums(numer)
      P <- numer / denom
    }

    E <- P %*% (0:(K - 1))
    E2 <- P %*% ((0:(K - 1))^2)
    info <- as.numeric(E2 - E^2)

    pirt_result(list(theta = theta, P = P, info = info, K = K, model = model))
    })
  })

  output$pirt_crc <- renderPlotly({
    res <- pirt_result()
    req(res)
    cols <- if (res$K <= 8) {
      RColorBrewer::brewer.pal(max(3, res$K), "Set2")[seq_len(res$K)]
    } else grDevices::hcl.colors(res$K, "Set2")

    p <- plotly::plot_ly()
    for (k in seq_len(res$K)) {
      p <- p |> plotly::add_trace(
        x = res$theta, y = res$P[, k],
        type = "scatter", mode = "lines",
        line = list(color = cols[k], width = 2),
        name = paste0("Cat ", k - 1),
        hoverinfo = "text",
        text = paste0("\u03b8 = ", round(res$theta, 2),
                       "<br>P(X=", k - 1, ") = ", round(res$P[, k], 3))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "\u03b8 (Ability)"),
      yaxis = list(title = "Probability", range = c(0, 1)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$pirt_info <- renderPlotly({
    res <- pirt_result(); req(res)
    plotly::plot_ly(x = res$theta, y = res$info,
                    type = "scatter", mode = "lines",
                    line = list(color = "#238b45", width = 2),
                    name = "Item information",
                    hoverinfo = "text",
                    text = paste0("\u03b8 = ", round(res$theta, 2),
                                   "<br>Info = ", round(res$info, 3))) |>
      plotly::layout(
        xaxis = list(title = "\u03b8 (Ability)"),
        yaxis = list(title = "Information I(\u03b8)"),
        title = list(text = "Item Information Function", font = list(size = 13)),
        showlegend = FALSE,
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Multidimensional IRT ────────────────────────────────────────────
  mirt_data <- reactiveVal(NULL)

  observeEvent(input$mirt_go, {
    withProgress(message = "Fitting multidimensional IRT...", value = 0.1, {
    J <- input$mirt_items
    a1_focal <- input$mirt_a1; a2_focal <- input$mirt_a2
    rho <- input$mirt_corr
    set.seed(sample.int(10000, 1))

    a1 <- c(a1_focal, runif(J - 1, 0.3, 2.5))
    a2 <- c(a2_focal, runif(J - 1, 0.3, 2.5))
    d  <- runif(J, -1.5, 1.5)

    for (j in 2:J) {
      if (j <= J / 2) {
        a2[j] <- a2[j] * 0.2
      } else {
        a1[j] <- a1[j] * 0.2
      }
    }

    mdisc <- sqrt(a1^2 + a2^2)
    mirt_data(list(a1 = a1, a2 = a2, d = d, mdisc = mdisc, J = J, rho = rho))
    })
  })

  output$mirt_vectors <- renderPlotly({
    res <- mirt_data()
    req(res)
    p <- plotly::plot_ly()
    cols <- RColorBrewer::brewer.pal(max(3, res$J), "Set3")
    if (res$J > length(cols)) cols <- grDevices::hcl.colors(res$J, "Set3")

    for (j in seq_len(res$J)) {
      p <- p |> plotly::add_annotations(
        x = res$a1[j], y = res$a2[j],
        ax = 0, ay = 0,
        xref = "x", yref = "y", axref = "x", ayref = "y",
        showarrow = TRUE, arrowhead = 2, arrowsize = 1.2,
        arrowwidth = 2, arrowcolor = cols[j],
        text = ""
      )
    }
    p <- p |> plotly::add_markers(
      x = res$a1, y = res$a2,
      marker = list(color = cols[seq_len(res$J)], size = 8),
      hoverinfo = "text",
      text = paste0("Item ", seq_len(res$J),
                     "<br>a\u2081 = ", round(res$a1, 2),
                     "<br>a\u2082 = ", round(res$a2, 2),
                     "<br>MDISC = ", round(res$mdisc, 2)),
      showlegend = FALSE
    )

    mx <- max(c(res$a1, res$a2)) * 1.2
    p |> plotly::layout(
      xaxis = list(title = "a\u2081 (Dimension 1 loading)", range = c(-0.2, mx)),
      yaxis = list(title = "a\u2082 (Dimension 2 loading)", range = c(-0.2, mx),
                   scaleanchor = "x"),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mirt_surface <- renderPlotly({
    res <- mirt_data(); req(res)
    th1 <- seq(-3, 3, length.out = 50)
    th2 <- seq(-3, 3, length.out = 50)
    z <- outer(th1, th2, function(t1, t2) {
      1 / (1 + exp(-(res$a1[1] * t1 + res$a2[1] * t2 + res$d[1])))
    })

    plotly::plot_ly(x = th1, y = th2, z = z, type = "surface",
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
                    showscale = FALSE,
                    hoverinfo = "text",
                    text = outer(th1, th2, function(t1, t2)
                      paste0("\u03b8\u2081=", round(t1, 1), ", \u03b8\u2082=", round(t2, 1),
                             "<br>P=", round(1/(1+exp(-(res$a1[1]*t1+res$a2[1]*t2+res$d[1]))), 3)))) |>
      plotly::layout(
        scene = list(
          xaxis = list(title = "\u03b8\u2081"),
          yaxis = list(title = "\u03b8\u2082"),
          zaxis = list(title = "P(X=1)", range = c(0, 1))
        ),
        margin = list(t = 20)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mirt_params <- renderTable({
    res <- mirt_data(); req(res)
    data.frame(
      Item = seq_len(res$J),
      a1 = round(res$a1, 3), a2 = round(res$a2, 3),
      d = round(res$d, 3),
      MDISC = round(res$mdisc, 3)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Nominal Response ────────────────────────────────────────────────
  nom_data <- reactiveVal(NULL)

  observeEvent(input$nom_go, {
    withProgress(message = "Fitting nominal response model...", value = 0.1, {
    K <- input$nom_cats
    a_correct <- input$nom_a_correct
    a_attract <- input$nom_a_attract

    a <- c(a_correct, a_attract, runif(K - 2, -0.3, 0.3))
    c_param <- c(0, 0.5, runif(K - 2, -0.5, 0.5))
    labels <- c("Correct", "Attractive Distractor",
                 paste0("Distractor ", seq_len(K - 2)))

    theta <- seq(-4, 4, length.out = 300)
    numer <- matrix(0, length(theta), K)
    for (k in seq_len(K)) {
      numer[, k] <- exp(a[k] * theta + c_param[k])
    }
    denom <- rowSums(numer)
    P <- numer / denom

    nom_data(list(theta = theta, P = P, a = a, c = c_param,
                  labels = labels, K = K))
    })
  })

  output$nom_occ <- renderPlotly({
    res <- nom_data()
    req(res)
    cols <- c("#238b45", "#e31a1c", "#3182bd", "#fd8d3c", "#984ea3", "#a65628")

    p <- plotly::plot_ly()
    for (k in seq_len(res$K)) {
      p <- p |> plotly::add_trace(
        x = res$theta, y = res$P[, k],
        type = "scatter", mode = "lines",
        line = list(color = cols[k], width = 2,
                    dash = if (k == 1) "solid" else "dot"),
        name = res$labels[k],
        hoverinfo = "text",
        text = paste0(res$labels[k], "<br>\u03b8 = ", round(res$theta, 2),
                       "<br>P = ", round(res$P[, k], 3))
      )
    }
    p |> plotly::layout(
      xaxis = list(title = "\u03b8 (Ability)"),
      yaxis = list(title = "Probability", range = c(0, 1)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$nom_params <- renderTable({
    res <- nom_data(); req(res)
    data.frame(
      Option = res$labels,
      `Slope (a)` = round(res$a, 3),
      `Intercept (c)` = round(res$c, 3),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Bayesian IRT ────────────────────────────────────────────────────
  birt_data <- reactiveVal(NULL)

  observeEvent(input$birt_go, {
    withProgress(message = "Running Bayesian IRT...", value = 0.1, {
    J <- input$birt_items
    true_theta <- input$birt_true_theta
    prior_type <- input$birt_prior
    set.seed(sample.int(10000, 1))

    b <- sort(runif(J, -2, 2))
    p <- 1 / (1 + exp(-(true_theta - b)))
    x <- rbinom(J, 1, p)

    prior_sd <- switch(prior_type, "standard" = 1, "inform" = 0.5, "diffuse" = 3)
    prior_mu <- 0

    theta_grid <- seq(-4, 4, length.out = 500)
    log_prior <- dnorm(theta_grid, prior_mu, prior_sd, log = TRUE)
    log_lik <- sapply(theta_grid, function(th) {
      pi <- 1 / (1 + exp(-(th - b)))
      pi <- pmin(pmax(pi, 1e-10), 1 - 1e-10)
      sum(x * log(pi) + (1 - x) * log(1 - pi))
    })

    log_posterior <- log_prior + log_lik
    log_posterior <- log_posterior - max(log_posterior)
    posterior <- exp(log_posterior)
    posterior <- posterior / (sum(posterior) * diff(theta_grid[1:2]))

    prior <- dnorm(theta_grid, prior_mu, prior_sd)
    lik <- exp(log_lik - max(log_lik))
    lik <- lik / (sum(lik) * diff(theta_grid[1:2]))

    eap <- sum(theta_grid * posterior * diff(theta_grid[1:2]))
    map <- theta_grid[which.max(posterior)]
    mle <- theta_grid[which.max(log_lik)]
    psd <- sqrt(sum((theta_grid - eap)^2 * posterior * diff(theta_grid[1:2])))

    birt_data(list(theta_grid = theta_grid, prior = prior, lik = lik,
                   posterior = posterior, eap = eap, map = map, mle = mle,
                   psd = psd, true = true_theta, score = sum(x), J = J))
    })
  })

  output$birt_plot <- renderPlotly({
    res <- birt_data()
    req(res)

    plotly::plot_ly() |>
      plotly::add_trace(x = res$theta_grid, y = res$prior,
                        type = "scatter", mode = "lines",
                        line = list(color = "#3182bd", width = 2, dash = "dash"),
                        name = "Prior", hoverinfo = "skip") |>
      plotly::add_trace(x = res$theta_grid, y = res$lik,
                        type = "scatter", mode = "lines",
                        line = list(color = "#fd8d3c", width = 2, dash = "dot"),
                        name = "Likelihood", hoverinfo = "skip") |>
      plotly::add_trace(x = res$theta_grid, y = res$posterior,
                        type = "scatter", mode = "lines",
                        fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
                        line = list(color = "#238b45", width = 2.5),
                        name = "Posterior", hoverinfo = "skip") |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = res$true, x1 = res$true,
          y0 = 0, y1 = max(res$posterior) * 1.1,
          line = list(color = "#e31a1c", width = 1.5, dash = "dash")
        )),
        xaxis = list(title = "\u03b8"), yaxis = list(title = "Density"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        annotations = list(list(
          x = res$true, y = max(res$posterior) * 1.05,
          text = paste0("True \u03b8 = ", res$true),
          showarrow = FALSE, font = list(size = 11, color = "#e31a1c")
        )),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$birt_table <- renderTable({
    res <- birt_data(); req(res)
    data.frame(
      Estimate = c("True \u03b8", "MLE", "EAP (posterior mean)", "MAP (posterior mode)",
                    "Posterior SD", "Raw score"),
      Value = c(res$true, round(res$mle, 3), round(res$eap, 3),
                round(res$map, 3), round(res$psd, 3),
                paste0(res$score, " / ", res$J))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 6: Item Fit — Empirical ICC Misfit ──────────────────────────

  ifit_data <- reactiveVal(NULL)

  observeEvent(input$ifit_gen, {
    set.seed(sample(1:10000, 1))
    N <- input$ifit_n; K <- input$ifit_k

    a_params <- runif(K, 0.6, 2.5)
    b_params <- sort(runif(K, -2.5, 2.5))
    theta <- rnorm(N, 0, 1)

    # Generate responses from 2PL
    resp <- matrix(0, N, K)
    for (j in seq_len(K)) {
      p <- 1 / (1 + exp(-a_params[j] * (theta - b_params[j])))
      resp[, j] <- rbinom(N, 1, p)
    }

    ifit_data(list(theta = theta, resp = resp, a = a_params, b = b_params,
                   N = N, K = K))
  })

  output$ifit_item_selector <- renderUI({
    d <- ifit_data(); req(d)
    selectInput(session$ns("ifit_item"), "Inspect item",
                choices = setNames(seq_len(d$K), paste("Item", seq_len(d$K))),
                selected = 1)
  })

  # Compute binned observed proportions
  ifit_binned <- reactive({
    d <- ifit_data(); req(d, input$ifit_item)
    j <- as.integer(input$ifit_item)
    n_bins <- input$ifit_bins
    theta <- d$theta
    responses <- d$resp[, j]

    # Inject misfit if toggled
    if (isTRUE(input$ifit_misfit)) {
      set.seed(42 + j)
      N <- d$N
      a_j <- d$a[j]; b_j <- d$b[j]
      if (input$ifit_misfit_type == "guess") {
        # Excess guessing: low-ability examinees guess correctly ~40% of the time
        p_misfit <- 0.40 + (1 - 0.40) / (1 + exp(-a_j * (theta - b_j)))
        responses <- rbinom(N, 1, p_misfit)
      } else if (input$ifit_misfit_type == "low_a") {
        # Much lower discrimination than assumed
        p_misfit <- 1 / (1 + exp(-0.3 * (theta - b_j)))
        responses <- rbinom(N, 1, p_misfit)
      } else if (input$ifit_misfit_type == "bimodal") {
        # Item compromise: top 20% get it right almost always
        p_normal <- 1 / (1 + exp(-a_j * (theta - b_j)))
        boost <- ifelse(theta > quantile(theta, 0.80), 0.95, p_normal)
        responses <- rbinom(N, 1, boost)
      }
    }

    # Bin by theta
    breaks <- quantile(theta, probs = seq(0, 1, length.out = n_bins + 1))
    breaks[1] <- breaks[1] - 0.01
    bin <- cut(theta, breaks = breaks, labels = FALSE)

    obs_p <- tapply(responses, bin, mean, na.rm = TRUE)
    obs_n <- tapply(responses, bin, length)
    bin_mid <- tapply(theta, bin, mean, na.rm = TRUE)
    se <- sqrt(obs_p * (1 - obs_p) / obs_n)

    list(bin_mid = as.numeric(bin_mid), obs_p = as.numeric(obs_p),
         se = as.numeric(se), obs_n = as.numeric(obs_n), item = j)
  })

  output$ifit_icc_plot <- plotly::renderPlotly({
    d <- ifit_data(); req(d)
    bd <- ifit_binned(); req(bd)
    j <- bd$item
    a_j <- d$a[j]; b_j <- d$b[j]

    theta_seq <- seq(-4, 4, length.out = 200)
    p_expected <- 1 / (1 + exp(-a_j * (theta_seq - b_j)))

    plotly::plot_ly() |>
      plotly::add_trace(x = theta_seq, y = p_expected, type = "scatter", mode = "lines",
                        name = "Expected ICC", line = list(color = "#268bd2", width = 2.5)) |>
      plotly::add_trace(x = bd$bin_mid, y = bd$obs_p, type = "scatter", mode = "markers",
                        name = "Observed",
                        marker = list(color = "#dc322f", size = 10, symbol = "circle"),
                        error_y = list(type = "data", array = 1.96 * bd$se,
                                       color = "#dc322f", thickness = 1.5)) |>
      plotly::layout(
        xaxis = list(title = "\u03b8 (Ability)", zeroline = FALSE),
        yaxis = list(title = "P(Correct)", range = c(-0.05, 1.05)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        title = list(text = sprintf("Item %d  (a = %.2f, b = %.2f)", j, a_j, b_j),
                     font = list(size = 14)),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ifit_params_table <- renderTable({
    d <- ifit_data(); req(d)
    data.frame(
      Item = seq_len(d$K),
      a = round(d$a, 2),
      b = round(d$b, 2)
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$ifit_fit_table <- renderTable({
    d <- ifit_data(); req(d)
    bd <- ifit_binned(); req(bd)
    j <- bd$item
    a_j <- d$a[j]; b_j <- d$b[j]

    # Compute chi-square-like fit statistic (S-X²)
    p_exp <- 1 / (1 + exp(-a_j * (bd$bin_mid - b_j)))
    chi_sq <- sum(bd$obs_n * (bd$obs_p - p_exp)^2 / (p_exp * (1 - p_exp)), na.rm = TRUE)
    df <- length(bd$bin_mid) - 2
    p_val <- pchisq(chi_sq, df = max(df, 1), lower.tail = FALSE)

    # Infit / outfit (simplified)
    theta <- d$theta; resp <- d$resp[, j]
    p_i <- 1 / (1 + exp(-a_j * (theta - b_j)))
    resid <- resp - p_i
    var_i <- p_i * (1 - p_i)
    z_sq <- resid^2 / var_i
    outfit <- mean(z_sq, na.rm = TRUE)
    infit <- sum(resid^2, na.rm = TRUE) / sum(var_i, na.rm = TRUE)

    data.frame(
      Statistic = c("S-X\u00b2", "df", "p-value", "Infit MNSQ", "Outfit MNSQ"),
      Value = c(sprintf("%.2f", chi_sq), as.character(df), sprintf("%.4f", p_val),
                sprintf("%.3f", infit), sprintf("%.3f", outfit))
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Tab 7: Model Comparison server ──────────────────────────────────

  mcmp_data <- reactiveVal(NULL)

  # Vectorised negative log-likelihood helpers (avoid per-call overhead)
  .nll <- function(resp_j, theta, a, b, cc = 0) {
    p <- cc + (1 - cc) / (1 + exp(-a * (theta - b)))
    -sum(resp_j * log(pmax(p, 1e-10)) + (1 - resp_j) * log(pmax(1 - p, 1e-10)))
  }

  observeEvent(input$mcmp_run, {
    withProgress(message = "Running parameter recovery...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    N <- input$mcmp_n; K <- input$mcmp_k
    true_mod <- input$mcmp_true_model

    b_true <- sort(runif(K, -2.5, 2.5))
    a_true <- if (true_mod == "1PL") rep(1, K) else runif(K, 0.5, 2.5)
    c_true <- if (true_mod == "3PL") runif(K, 0.05, 0.30) else rep(0, K)

    theta <- rnorm(N, 0, 1)

    resp <- matrix(0, N, K)
    for (j in seq_len(K)) {
      p <- c_true[j] + (1 - c_true[j]) / (1 + exp(-a_true[j] * (theta - b_true[j])))
      resp[, j] <- rbinom(N, 1, p)
    }

    # Good initial b from observed proportion correct
    p_obs <- colMeans(resp)
    b_init <- -qnorm(pmax(pmin(p_obs, 0.99), 0.01))

    # --- Fit 1PL: single pass, one optim per item ---
    fit_1pl <- tryCatch({
      b_1pl <- vapply(seq_len(K), function(j) {
        optimise(function(bj) .nll(resp[, j], theta, 1, bj),
                 lower = -5, upper = 5)$minimum
      }, numeric(1))
      loglik <- sum(vapply(seq_len(K), function(j) -.nll(resp[, j], theta, 1, b_1pl[j]), numeric(1)))
      list(a = rep(1, K), b = b_1pl, c = rep(0, K), loglik = loglik, npar = K)
    }, error = function(e) NULL)

    # --- Fit 2PL: single pass ---
    fit_2pl <- tryCatch({
      a_2pl <- numeric(K); b_2pl <- numeric(K)
      for (j in seq_len(K)) {
        opt <- optim(c(1, b_init[j]), function(par) .nll(resp[, j], theta, max(par[1], 0.1), par[2]),
                     method = "L-BFGS-B", lower = c(0.1, -5), upper = c(5, 5))
        a_2pl[j] <- max(opt$par[1], 0.1); b_2pl[j] <- opt$par[2]
      }
      loglik <- sum(vapply(seq_len(K), function(j) -.nll(resp[, j], theta, a_2pl[j], b_2pl[j]), numeric(1)))
      list(a = a_2pl, b = b_2pl, c = rep(0, K), loglik = loglik, npar = 2 * K)
    }, error = function(e) NULL)

    # --- Fit 3PL: single pass, warm-start from 2PL ---
    fit_3pl <- tryCatch({
      a_3pl <- numeric(K); b_3pl <- numeric(K); c_3pl <- numeric(K)
      for (j in seq_len(K)) {
        a0 <- if (!is.null(fit_2pl)) fit_2pl$a[j] else 1
        b0 <- if (!is.null(fit_2pl)) fit_2pl$b[j] else b_init[j]
        opt <- optim(c(a0, b0, 0.15), function(par) {
          .nll(resp[, j], theta, max(par[1], 0.1), par[2], min(max(par[3], 0.001), 0.5))
        }, method = "L-BFGS-B", lower = c(0.1, -5, 0.001), upper = c(5, 5, 0.5))
        a_3pl[j] <- max(opt$par[1], 0.1); b_3pl[j] <- opt$par[2]
        c_3pl[j] <- min(max(opt$par[3], 0.001), 0.5)
      }
      loglik <- sum(vapply(seq_len(K), function(j) -.nll(resp[, j], theta, a_3pl[j], b_3pl[j], c_3pl[j]), numeric(1)))
      list(a = a_3pl, b = b_3pl, c = c_3pl, loglik = loglik, npar = 3 * K)
    }, error = function(e) NULL)

    mcmp_data(list(
      true_mod = true_mod, N = N, K = K, theta = theta,
      a_true = a_true, b_true = b_true, c_true = c_true,
      fit_1pl = fit_1pl, fit_2pl = fit_2pl, fit_3pl = fit_3pl
    ))
    })
  })

  output$mcmp_item_selector <- renderUI({
    d <- mcmp_data(); req(d)
    selectInput(session$ns("mcmp_item"), "Inspect item",
                choices = setNames(seq_len(d$K), paste("Item", seq_len(d$K))),
                selected = 1)
  })

  output$mcmp_ic_table <- renderTable({
    d <- mcmp_data(); req(d)
    fits <- list("1PL" = d$fit_1pl, "2PL" = d$fit_2pl, "3PL" = d$fit_3pl)
    rows <- lapply(names(fits), function(nm) {
      f <- fits[[nm]]; if (is.null(f)) return(NULL)
      aic <- -2 * f$loglik + 2 * f$npar
      bic <- -2 * f$loglik + f$npar * log(d$N)
      data.frame(Model = nm, LogLik = round(f$loglik, 1),
                 Parameters = f$npar, AIC = round(aic, 1), BIC = round(bic, 1))
    })
    tab <- do.call(rbind, rows)
    best_aic <- which.min(tab$AIC)
    best_bic <- which.min(tab$BIC)
    tab$AIC <- sprintf("%.1f", tab$AIC)
    tab$BIC <- sprintf("%.1f", tab$BIC)
    tab$AIC[best_aic] <- paste0(tab$AIC[best_aic], " *")
    tab$BIC[best_bic] <- paste0(tab$BIC[best_bic], " *")
    tab
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$mcmp_lrt_table <- renderTable({
    d <- mcmp_data(); req(d)
    f1 <- d$fit_1pl; f2 <- d$fit_2pl; f3 <- d$fit_3pl
    req(f1, f2, f3)

    chi_12 <- 2 * (f2$loglik - f1$loglik)
    df_12 <- f2$npar - f1$npar
    p_12 <- pchisq(max(chi_12, 0), df_12, lower.tail = FALSE)

    chi_23 <- 2 * (f3$loglik - f2$loglik)
    df_23 <- f3$npar - f2$npar
    p_23 <- pchisq(max(chi_23, 0), df_23, lower.tail = FALSE)

    data.frame(
      Comparison = c("1PL vs 2PL", "2PL vs 3PL"),
      Delta_Chi_sq = c(sprintf("%.2f", chi_12), sprintf("%.2f", chi_23)),
      df = c(df_12, df_23),
      p_value = c(sprintf("%.4f", p_12), sprintf("%.4f", p_23)),
      Decision = c(
        if (p_12 < 0.05) "2PL preferred" else "1PL sufficient",
        if (p_23 < 0.05) "3PL preferred" else "2PL sufficient"
      )
    )
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$mcmp_icc_plot <- renderPlotly({
    d <- mcmp_data(); req(d, input$mcmp_item)
    j <- as.integer(input$mcmp_item)
    theta_seq <- seq(-4, 4, length.out = 300)

    p_true <- d$c_true[j] + (1 - d$c_true[j]) /
      (1 + exp(-d$a_true[j] * (theta_seq - d$b_true[j])))

    p <- plot_ly() |>
      add_trace(x = theta_seq, y = p_true, type = "scatter", mode = "lines",
                name = paste0("True (", d$true_mod, ")"),
                line = list(color = "#002b36", width = 3, dash = "dot"))

    models <- list("1PL" = d$fit_1pl, "2PL" = d$fit_2pl, "3PL" = d$fit_3pl)
    colors <- c("1PL" = "#2aa198", "2PL" = "#268bd2", "3PL" = "#d33682")
    for (nm in names(models)) {
      f <- models[[nm]]; if (is.null(f)) next
      p_fit <- f$c[j] + (1 - f$c[j]) / (1 + exp(-f$a[j] * (theta_seq - f$b[j])))
      p <- p |> add_trace(x = theta_seq, y = p_fit, type = "scatter", mode = "lines",
                          name = nm, line = list(color = colors[nm], width = 2))
    }

    p |> layout(
      xaxis = list(title = "\u03b8 (Ability)", zeroline = FALSE),
      yaxis = list(title = "P(Correct)", range = c(-0.05, 1.05)),
      title = list(text = sprintf("Item %d \u2014 True: a=%.2f, b=%.2f, c=%.2f",
                                  j, d$a_true[j], d$b_true[j], d$c_true[j]),
                   font = list(size = 14)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
      margin = list(t = 40)
    ) |> config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "IRT Models", list(irt_items, pirt_result, mirt_data, nom_data, birt_data, ifit_data, mcmp_data))
  })
}
