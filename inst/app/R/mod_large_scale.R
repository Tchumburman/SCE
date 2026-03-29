# Module: Large-Scale Assessment (consolidated)
# Tabs: PV / JK / BRR | Standard Setting | Response Times

# ── UI ──────────────────────────────────────────────────────────────────
mod_large_scale_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Large-Scale Assessment",
  icon = icon("dice-d20"),
  navset_card_underline(

    # ── Tab 1: PV / JK / BRR ─────────────────────────────────────
    nav_panel(
      "PV / JK / BRR",
        navset_card_underline(
          # Tab A: Plausible Values
          nav_panel(
            "Plausible Values",
            layout_sidebar(
              sidebar = sidebar(
                width = 300,
                sliderInput(ns("pv_n"), "Number of examinees", min = 100, max = 2000, value = 500, step = 100),
                sliderInput(ns("pv_items"), "Number of items", min = 10, max = 50, value = 20, step = 5),
                sliderInput(ns("pv_npv"), "Number of plausible values", min = 3, max = 10, value = 5, step = 1),
                sliderInput(ns("pv_reliability"), "Test reliability", min = 0.5, max = 0.95, value = 0.8, step = 0.05),
                actionButton(ns("pv_go"), "Generate & draw PVs", class = "btn-success w-100")
              ),
              explanation_box(
                tags$strong("Plausible Values"),
                tags$p("In large-scale assessments (PISA, TIMSS, PIRLS), individual scores are imprecise
                        because each student answers only a subset of items. Rather than reporting
                        a single point estimate, the assessment draws multiple ",
                       tags$b("plausible values"), " from each student's posterior ability distribution
                        \u2014 random draws that capture measurement uncertainty."),
                tags$p("To estimate a population statistic (e.g., mean), you compute the statistic
                        separately for each set of PVs, then average across PV sets. The variance
                        has two components: (1) within-PV sampling variance and (2) between-PV
                        imputation variance. Ignoring the between-PV component underestimates
                        the total uncertainty."),
          tags$p("Plausible values are multiple imputations of latent ability, drawn from the
                  posterior distribution of \u03b8 given the observed responses and background
                  variables. They are not point estimates of individual ability but rather random
                  draws that, when properly analysed, yield unbiased population-level statistics."),
          tags$p("Using plausible values correctly requires analysing each set separately and
                  then combining results using Rubin\u2019s rules (averaging point estimates,
                  pooling variances with a between-imputation component). This accounts for both
                  sampling error and measurement error in a single framework."),
                guide = tags$ol(
                  tags$li("Set sample size, items, number of PVs, and reliability."),
                  tags$li("Click 'Generate & draw PVs'."),
                  tags$li("Left: the posterior distribution for a randomly selected student, with PV draws marked."),
                  tags$li("Right: population mean estimates from each PV set, showing between-PV variation."),
                  tags$li("Lower reliability \u2192 wider posteriors \u2192 more between-PV variance.")
                )
              ),
              layout_column_wrap(
                width = 1 / 2,
                card(full_screen = TRUE, card_header("Individual Posterior & PV Draws"),
                     plotlyOutput(ns("pv_posterior_plot"), height = "380px")),
                card(full_screen = TRUE, card_header("Population Mean Estimates by PV Set"),
                     plotlyOutput(ns("pv_means_plot"), height = "380px"))
              ),
              card(card_header("Variance Decomposition"), tableOutput(ns("pv_var_table")))
            )
          ),
          # Tab B: Jackknife
          nav_panel(
            "Jackknife",
            layout_sidebar(
              sidebar = sidebar(
                width = 300,
                sliderInput(ns("jk_n"), "Sample size", min = 20, max = 200, value = 50, step = 10),
                selectInput(ns("jk_stat"), "Statistic",
                            choices = c("Mean", "Median", "Variance", "Correlation")),
                selectInput(ns("jk_dist"), "Population distribution",
                            choices = c("Normal", "Skewed (log-normal)", "Heavy-tailed (t, df=3)")),
                actionButton(ns("jk_go"), "Generate & jackknife", class = "btn-success w-100")
              ),
              explanation_box(
                tags$strong("Jackknife Resampling"),
                tags$p("The jackknife estimates the bias and standard error of a statistic by
                        systematically leaving out one observation at a time (or one PSU in
                        complex surveys). For n observations, compute the statistic n times,
                        each time omitting one case. The variability of these leave-one-out
                        estimates provides a standard error estimate."),
                tags$p("In large-scale assessments, the ",
                       tags$b("delete-one-group jackknife (JK1)"), " or ",
                       tags$b("paired jackknife (JK2)"), " are used with stratified designs,
                        where entire primary sampling units (PSUs) are dropped rather than
                        individual students. JK2 pairs adjacent schools within each sampling
                        zone; one school is zeroed out and its partner is double-weighted.
                        This is repeated for each zone, yielding H replicate estimates
                        (75 in pre-2015 TIMSS/PIRLS, 150 from 2015 onward)."),
                tags$p(tags$b("TIMSS and PIRLS"), " (IEA studies) use ", tags$b("JK2"),
                        " as their standard variance estimator. NAEP similarly uses a
                        paired jackknife with 62 replicate strata. JK2 was chosen for
                        these programs because it is computationally straightforward,
                        produces approximately unbiased estimates of sampling variance
                        for means and percentages, and naturally accommodates the
                        stratified two-stage (schools then students) design."),
          tags$p("The jackknife systematically removes one primary sampling unit at a time
                  and re-estimates the statistic, producing a set of pseudo-values.
                  The variance of these pseudo-values estimates the sampling variance.
                  In large-scale assessments, JK2 is preferred over leave-one-student-out
                  jackknife because variance in educational surveys is dominated by
                  between-school (cluster) differences, not between-student differences."),
                guide = tags$ol(
                  tags$li("Set the sample size, statistic, and population distribution."),
                  tags$li("Click 'Generate & jackknife'."),
                  tags$li("Left: the distribution of jackknife pseudo-values, with the full-sample estimate marked."),
                  tags$li("Right: jackknife influence \u2014 how much removing each observation changes the estimate."),
                  tags$li("The table shows the JK estimate, JK standard error, and JK bias estimate.")
                )
              ),
              layout_column_wrap(
                width = 1 / 2,
                card(full_screen = TRUE, card_header("Jackknife Pseudo-Values"),
                     plotlyOutput(ns("jk_pseudo_plot"), height = "380px")),
                card(full_screen = TRUE, card_header("Jackknife Influence (leave-one-out)"),
                     plotlyOutput(ns("jk_influence_plot"), height = "380px"))
              ),
              card(card_header("Jackknife Results"), tableOutput(ns("jk_results_table")))
            )
          ),
          # Tab C: BRR
          nav_panel(
            "BRR",
            layout_sidebar(
              sidebar = sidebar(
                width = 300,
                sliderInput(ns("brr_n_strata"), "Number of strata (paired halves)", min = 4, max = 30, value = 10, step = 2),
                sliderInput(ns("brr_n_per"), "Observations per stratum", min = 20, max = 200, value = 50, step = 10),
                sliderInput(ns("brr_reps"), "Number of BRR replicates", min = 10, max = 200, value = 50, step = 10),
                selectInput(ns("brr_stat"), "Statistic",
                            choices = c("Mean", "Median", "Regression slope")),
                actionButton(ns("brr_go"), "Generate & BRR", class = "btn-success w-100")
              ),
              explanation_box(
                tags$strong("Balanced Repeated Replication (BRR)"),
                tags$p("BRR is a variance estimation method for stratified designs with two
                        PSUs per stratum. It creates replicate weights by systematically
                        selecting one PSU from each stratum according to a Hadamard matrix.
                        Each replicate gives a half-sample estimate; the variance of these
                        estimates approximates the sampling variance."),
                tags$p(tags$b("PISA"), " uses BRR with Fay\u2019s modification (k\u2009=\u20090.5,
                        yielding 80 replicates) as its standard variance estimator.
                        TIMSS and PIRLS use JK2 instead \u2014 see the Jackknife tab.
                        Fay\u2019s method modifies standard BRR by applying a perturbation
                        factor k (0 < k < 1) instead of fully zeroing out one PSU,
                        so replicate weights are never zero. This avoids instability
                        when some replicates produce extreme estimates and is
                        particularly important for nonlinear statistics such as
                        percentiles and regression coefficients."),
          tags$p("BRR creates replicate weights by systematically halving the sample within
                  each stratum: one PSU receives a weight factor of (1\u2009+\u2009k) and its
                  partner receives (1\u2009\u2212\u2009k), where k\u2009=\u20091 in standard BRR and
                  k\u2009=\u20090.5 in PISA\u2019s Fay variant. With H strata a Hadamard matrix
                  ensures balance, limiting the required replicates to a power of 2
                  \u2265\u2009H. Standard BRR requires strata with exactly two PSUs; Fay\u2019s
                  modification relaxes this and improves stability."),
                guide = tags$ol(
                  tags$li("Set the number of strata, observations per stratum, and replicates."),
                  tags$li("Choose a statistic to estimate."),
                  tags$li("Click 'Generate & BRR'."),
                  tags$li("Left: the distribution of BRR replicate estimates compared to the full-sample estimate."),
                  tags$li("Right: how the BRR SE stabilizes as the number of replicates increases."),
                  tags$li("The table shows the full-sample estimate, BRR SE, and 95% CI.")
                )
              ),
              layout_column_wrap(
                width = 1 / 2,
                card(full_screen = TRUE, card_header("BRR Replicate Distribution"),
                     plotlyOutput(ns("brr_dist_plot"), height = "380px")),
                card(full_screen = TRUE, card_header("BRR SE Convergence"),
                     plotlyOutput(ns("brr_conv_plot"), height = "380px"))
              ),
              card(card_header("BRR Results"), tableOutput(ns("brr_results_table")))
            )
          )
        )
    ),

    # ── Tab 2: Standard Setting ──────────────────────────────────
    nav_panel(
      "Standard Setting",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            selectInput(ns("ss_method"), "Method",
              choices = c("Modified Angoff", "Bookmark"),
              selected = "Modified Angoff"
            ),
            sliderInput(ns("ss_n_items"), "Number of test items", min = 10, max = 50, value = 20, step = 5),
            sliderInput(ns("ss_n_judges"), "Number of judges", min = 3, max = 15, value = 6, step = 1),
            sliderInput(ns("ss_judge_var"), "Judge variability (SD)", min = 0.01, max = 0.20, value = 0.08, step = 0.01),
            conditionalPanel(ns = ns, "input.ss_method == 'Bookmark'",
              sliderInput(ns("ss_rp"), "Response probability criterion", min = 0.50, max = 0.80, value = 0.67, step = 0.01)
            ),
            actionButton(ns("ss_run"), "Run standard setting", icon = icon("play"),
                         class = "btn-success w-100 mt-2")
          ),
      
          explanation_box(
            tags$strong("Standard Setting"),
            tags$p("Standard setting determines cut scores on a test to classify examinees
                    into performance levels (e.g., pass/fail, basic/proficient/advanced).
                    Panels of expert judges review items and make judgments."),
            tags$ul(
              tags$li(tags$strong("Modified Angoff"), " \u2014 each judge estimates the probability
                      that a minimally competent examinee would answer each item correctly.
                      The cut score is the sum of these probabilities."),
              tags$li(tags$strong("Bookmark"), " \u2014 items are ordered by difficulty. Each judge
                      places a 'bookmark' at the point where a minimally competent examinee
                      would have a specified probability (e.g., 67%) of answering correctly.")
            ),
          tags$p("Standard setting is the process of determining cut-scores that divide the
                  score scale into performance levels (e.g., Below Basic, Basic, Proficient,
                  Advanced). It is inherently judgmental: panellists (subject-matter experts)
                  make decisions about what examinees at each performance level should know
                  and be able to do. The Angoff method asks panellists to estimate the probability
                  of a borderline examinee answering each item correctly; the Bookmark method
                  has panellists identify the point in an ordered item booklet where mastery begins."),
          tags$p("The validity of standard setting depends heavily on the quality of the panel
                  (expertise, diversity), the clarity of performance level descriptions, and the
                  training process. Multiple rounds with feedback and discussion typically
                  improve convergence and defensibility."),
            guide = tags$ol(
              tags$li("Choose a method and adjust the number of items and judges."),
              tags$li("For Angoff: the heatmap shows each judge's probability ratings. The cut score is the mean of judge totals."),
              tags$li("For Bookmark: items are ordered by difficulty. Each judge's bookmark position is shown."),
              tags$li("Increase judge variability to see more disagreement in the panel.")
            )
          ),
      
          layout_column_wrap(
            width = 1,
            layout_column_wrap(
              width = 1 / 2,
              card(full_screen = TRUE, card_header("Judge Ratings / Bookmarks"),
                   plotOutput(ns("ss_ratings"), height = "400px")),
              card(full_screen = TRUE, card_header("Cut Score Distribution"),
                   plotlyOutput(ns("ss_cutscore"), height = "400px"))
            ),
            card(full_screen = TRUE, card_header("Score Distribution with Cut Score"),
                 plotlyOutput(ns("ss_score_dist"), height = "320px"))
          )
        )
    ),

    # ── Tab 3: Response Times ────────────────────────────────────
    nav_panel(
      "Response Times",
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            tags$strong("Lognormal RT Model"),
            tags$p(class = "text-muted small",
              "log(RT) = \u03b2 + \u03c4/\u03b1 + \u03b5, where \u03b2 = item time intensity,
               \u03c4 = person slowness, \u03b1 = item discrimination"),
            sliderInput(ns("rt_n_persons"), "Number of examinees", min = 50, max = 500, value = 200, step = 50),
            sliderInput(ns("rt_n_items"), "Number of items", min = 5, max = 30, value = 10, step = 1),
            sliderInput(ns("rt_tau_sd"), "Person speed variability (\u03c3\u03c4)", min = 0.1, max = 1.5, value = 0.5, step = 0.1),
            sliderInput(ns("rt_noise"), "Residual SD (\u03c3\u03b5)", min = 0.1, max = 1, value = 0.3, step = 0.05),
            tags$hr(),
            tags$strong("Speed-Accuracy Tradeoff"),
            sliderInput(ns("rt_speed_acc_corr"), "Correlation (speed vs. accuracy)", min = -0.8, max = 0.8, value = -0.3, step = 0.1),
            actionButton(ns("rt_gen"), "Generate data", icon = icon("dice"),
                         class = "btn-success w-100 mt-2")
          ),
      
          explanation_box(
            tags$strong("Response Time Modeling"),
            tags$p("In computerized testing, response times (RTs) carry information about
                    examinee behavior. The lognormal model is the most common framework:
                    log-RTs are decomposed into person speed, item time intensity, and noise."),
            tags$p("The speed-accuracy tradeoff is a key concept: faster examinees may
                    sacrifice accuracy. A negative correlation between speed and ability
                    suggests that rushing hurts performance."),
          tags$p("Response time modelling adds a second source of information to item responses.
                  The lognormal model assumes that log(RT) follows a Normal distribution with
                  person speed (\u03c4) and item time-intensity (\u03b2) parameters. Combined with
                  IRT, this yields a joint model of accuracy and speed that can detect
                  speed-accuracy trade-offs."),
          tags$p("Practical applications include detecting aberrant testing behaviour (e.g.,
                  rapid guessing, pre-knowledge of items), improving ability estimation by
                  incorporating response time information, and understanding test-taking
                  strategies. Items with unusually long average response times may be poorly
                  written or overly complex."),
            guide = tags$ol(
              tags$li("Generate data and explore the RT distributions by item."),
              tags$li("The person speed vs. ability scatter shows the speed-accuracy tradeoff."),
              tags$li("Adjust the correlation slider to see positive, zero, or negative tradeoffs."),
              tags$li("The item-level plot shows time intensity vs. difficulty.")
            )
          ),
      
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Log-RT Distributions by Item"),
                 plotlyOutput(ns("rt_item_dist"), height = "360px")),
            card(full_screen = TRUE, card_header("Speed-Accuracy Tradeoff"),
                 plotlyOutput(ns("rt_speed_acc"), height = "360px")),
            card(full_screen = TRUE, card_header("Item: Time Intensity vs. Difficulty"),
                 plotlyOutput(ns("rt_item_params"), height = "340px")),
            card(full_screen = TRUE, card_header("Person Speed Distribution"),
                 plotlyOutput(ns("rt_person_speed"), height = "340px"))
          )
        )
    ),

    # ── Tab 4: Booklet Equating ──────────────────────────────────
    nav_panel(
      "Booklet Equating",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("be_n_booklets"), "Number of booklets",
                      min = 3, max = 8, value = 4, step = 1),
          sliderInput(ns("be_n_unique"),   "Unique items per booklet",
                      min = 5, max = 20, value = 10, step = 1),
          sliderInput(ns("be_n_anchor"),   "Anchor items (shared across all booklets)",
                      min = 2, max = 15, value = 5, step = 1),
          sliderInput(ns("be_n_students"), "Students per booklet",
                      min = 50, max = 500, value = 200, step = 50),
          sliderInput(ns("be_difficulty_spread"), "Booklet difficulty spread",
                      min = 0.0, max = 1.5, value = 0.6, step = 0.1),
          radioButtons(ns("be_overlap_design"), "Overlap design",
                       choices = c("Common Anchor", "Chain Linking", "BIB Rotation"),
                       selected = "Common Anchor", inline = TRUE),
          actionButton(ns("be_run"), "Run equating",
                       class = "btn-success w-100 mt-2", icon = icon("balance-scale"))
        ),
        explanation_box(
          tags$strong("Booklet Equating via Anchor Items"),
          tags$p("When different groups of students receive different booklets,
                  raw scores are not directly comparable \u2014 one booklet may be
                  harder than another. Equating adjusts scores onto a common scale
                  so that a score of, say, 70% means the same thing regardless of
                  which booklet was taken."),
          tags$p("The key mechanism is ", tags$strong("shared items"), ": items or
                  blocks that appear in more than one booklet. Because the same items
                  are answered by students from different booklet groups, they reveal
                  differences in booklet difficulty and group ability \u2014 allowing
                  scores to be adjusted onto a common scale."),
          tags$p(tags$strong("Linking designs"), " differ in how items are shared:"),
          tags$ul(
            tags$li(tags$strong("Common Anchor:"), " Every booklet contains the same
                    set of anchor items. All booklets are directly linked through this
                    shared core \u2014 a hub-and-spoke structure."),
            tags$li(tags$strong("Chain Linking:"), " Each item block appears in exactly
                    2 adjacent booklets, forming a circular chain. TIMSS uses 14 booklets
                    with 4 blocks each; PIRLS chains 18 booklets via reading passages
                    appearing in 2 positions."),
            tags$li(tags$strong("BIB (Balanced Incomplete Block):"), " Clusters are
                    systematically rotated so that every pair of booklets shares at least
                    one block. This provides redundant links and greater robustness.")
          ),
          tags$p(tags$strong("PISA"), " has evolved its design over cycles. Through 2015,
                  PISA used a rotated booklet design where 30-minute item clusters were
                  allocated across 13 booklets in a BIB-like rotation. From 2018 onward,
                  PISA introduced multistage adaptive testing (MSAT) for reading, expanded
                  to mathematics in 2022 and science in 2025, where testlets are dynamically
                  assigned based on student performance at each stage."),
          tags$p("The mean-sigma method shown here estimates the linear transformation
                  (slope & intercept) needed to place each booklet on the reference
                  scale, using the anchor item statistics as the linking bridge."),
          guide = tags$ol(
            tags$li("Set the number of booklets, unique items per booklet, and anchor items."),
            tags$li("Choose a linking design to see how different item-sharing strategies look."),
            tags$li("Use \u2018Booklet difficulty spread\u2019 to make booklets vary in hardness."),
            tags$li("Top: block linking structure compares three linking designs."),
            tags$li("Middle-left: overlap diagram \u2014 which items are shared vs. unique."),
            tags$li("Middle-right: anchor item difficulty estimates by booklet (should align)."),
            tags$li("Bottom: raw vs. equated score distributions across booklets.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Block Linking Structure"),
               plotOutput(ns("be_chain_plot"), height = "360px")),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Item Overlap Across Booklets"),
                 plotOutput(ns("be_overlap_plot"), height = "380px")),
            card(full_screen = TRUE, card_header("Anchor Item Difficulty by Booklet"),
                 plotlyOutput(ns("be_anchor_plot"), height = "380px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Raw Score Distributions"),
                 plotlyOutput(ns("be_raw_dist"),    height = "300px")),
            card(full_screen = TRUE, card_header("Equated Score Distributions"),
                 plotlyOutput(ns("be_eq_dist"),     height = "300px"))
          )
        )
      )
    ),

    # ── Tab 5: Matrix Sampling ───────────────────────────────────
    nav_panel(
      "Matrix Sampling",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ms_n_items"),    "Total items in pool",
                      min = 20, max = 120, value = 60, step = 5),
          sliderInput(ns("ms_n_booklets"), "Number of booklets",
                      min = 4,  max = 20,  value = 8,  step = 1),
          sliderInput(ns("ms_ipb"),        "Items per booklet",
                      min = 5,  max = 40,  value = 20, step = 1),
          sliderInput(ns("ms_n_students"), "Students to display",
                      min = 20, max = 200, value = 80, step = 10),
          sliderInput(ns("ms_prop_correct"), "Avg. proportion correct",
                      min = 0.30, max = 0.80, value = 0.55, step = 0.05),
          actionButton(ns("ms_run"), "Generate design",
                       class = "btn-success w-100 mt-2", icon = icon("table"))
        ),
        explanation_box(
          tags$strong("Matrix Sampling & Booklet Design"),
          tags$p("Administering the full item pool to every student would be
                  impractical \u2014 tests would take many hours. Instead, large-scale
                  assessments distribute items across \u2018booklets\u2019, each a
                  manageable-length test. Each student completes one booklet."),
          tags$p("This creates a massive missing-data problem: each student has
                  responses for only a fraction of items. The solution is two-pronged:
                  (1) design booklets to share items across forms (enabling equating),
                  and (2) use plausible values to handle the missing ability data."),
          tags$ul(
            tags$li(tags$strong("PISA"), " uses ~13-item clusters combined into
                    2-hour booklets; each cluster appears in multiple booklets."),
            tags$li(tags$strong("TIMSS"), " uses a rotating block design with
                    14 booklets per grade (4 blocks each); each item block appears
                    in exactly 2 booklets, paired with a different block each time."),
            tags$li(tags$strong("PIRLS"), " uses 18 booklets, each containing two
                    reading passages; each passage appears in exactly 2 booklets \u2014
                    once as the first half and once as the second half.")
          ),
          tags$p("Because each block appears in only 2 booklets, the design creates
                  a \u2018chain\u2019 of overlapping links across all booklets rather than
                  a single common anchor set. Any pair of booklets is connected through
                  this chain, allowing all scores to be placed on a common scale."),
          guide = tags$ol(
            tags$li("Set the item pool size, number of booklets, and items per booklet."),
            tags$li("Click \u2018Generate design\u2019 to create a balanced assignment."),
            tags$li("Top-left grid: blue = item included in that booklet."),
            tags$li("Top-right bar chart: how many booklets each item appears in."),
            tags$li("Bottom grid: each row is a student; gray = not administered,
                     light = incorrect, dark = correct. Notice the block structure.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Booklet \u00d7 Item Assignment"),
                 plotOutput(ns("ms_booklet_grid"), height = "380px")),
            card(full_screen = TRUE, card_header("Item Exposure Across Booklets"),
                 plotlyOutput(ns("ms_exposure_plot"), height = "380px"))
          ),
          card(full_screen = TRUE,
               card_header("Student Response Patterns (sorted by booklet)"),
               plotOutput(ns("ms_student_grid"), height = "300px"))
        )
      )
    ),

    # ── Tab 6: Trend Linking ─────────────────────────────────────
    nav_panel(
      "Trend Linking",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("tl_n_cycles"),   "Number of assessment cycles",
                      min = 3, max = 6, value = 4, step = 1),
          sliderInput(ns("tl_n_trend"),    "Trend items per cycle",
                      min = 5, max = 30, value = 15, step = 5),
          sliderInput(ns("tl_drift"),      "Parameter drift magnitude",
                      min = 0.0, max = 0.8, value = 0.3, step = 0.1),
          sliderInput(ns("tl_n_students"), "Students per cycle",
                      min = 100, max = 1000, value = 400, step = 100),
          actionButton(ns("tl_run"), "Run simulation",
                       class = "btn-success w-100 mt-2", icon = icon("chart-line"))
        ),
        explanation_box(
          tags$strong("Trend Linking Across Assessment Cycles"),
          tags$p("Assessments like PISA and TIMSS are administered every 3\u20134 years.
                  Reporting meaningful trends \u2014 \u201creading improved by 5 points since
                  2018\u201d \u2014 requires that scores from each new cycle be placed on the
                  same scale as prior cycles. Without linking, differences in item selection,
                  translation, or population shifts can masquerade as real change."),
          tags$p("The mechanism is ", tags$strong("trend items"), ": a set of identical items
                  repeated verbatim from a previous cycle. Because the same items are
                  administered to new samples, any shift in their estimated difficulty
                  parameters reveals how much the scale has drifted, allowing a correction
                  to be applied."),
          tags$ul(
            tags$li(tags$strong("Mean-sigma linking"), " estimates a linear transformation
                    (slope & intercept) from trend item statistics, then applies it to all
                    scores in the new cycle."),
            tags$li(tags$strong("Parameter drift"), " occurs when item characteristics change
                    \u2014 due to item exposure, curriculum change, or translation artefacts.
                    Drift inflates linking error."),
            tags$li(tags$strong("Error accumulation"), ": when cycles are linked in a chain
                    (A\u2192B\u2192C), errors compound. Larger trend item sets reduce
                    per-step error.")
          ),
          tags$p("The ", tags$strong("drift slider"), " controls how much random noise is
                  added to trend item difficulties each cycle. Higher drift = less stable
                  parameters = larger linking uncertainty."),
          guide = tags$ol(
            tags$li("Set the number of cycles and trend items per cycle."),
            tags$li("Increase \u2018drift magnitude\u2019 to simulate unstable item parameters."),
            tags$li("Top-left: scatter of item difficulties cycle-to-cycle \u2014 tight clustering around the diagonal = stable."),
            tags$li("Top-right: raw vs. linked means \u2014 linking should remove artificial trends."),
            tags$li("Bottom-left: linking SE grows as drift increases or trend items decrease."),
            tags$li("Bottom-right: summary table of per-cycle linking statistics.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Trend Item Parameter Stability"),
                 plotlyOutput(ns("tl_stability_plot"), height = "360px")),
            card(full_screen = TRUE,
                 card_header("Scale Mean Over Cycles: Raw vs. Linked"),
                 plotlyOutput(ns("tl_scale_plot"), height = "360px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Linking SE Accumulation"),
                 plotlyOutput(ns("tl_error_plot"), height = "300px")),
            card(full_screen = TRUE,
                 card_header("Cycle Summary"),
                 div(style = "overflow-y: auto; max-height: 300px;",
                     tableOutput(ns("tl_summary_table"))))
          )
        )
      )
    ),

    # ── Tab 7: Adaptive Design in Large-Scale Assessments ─────────
    nav_panel(
      "Adaptive Design (MSAT)",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("msat_n_groups"),   "Number of country/ability groups",
                      min = 2, max = 5, value = 3, step = 1),
          textInput(ns("msat_group_means"), "Group mean abilities (\u03b8, comma-separated)",
                    value = "-1, 0, 1"),
          sliderInput(ns("msat_n_students"), "Students per group",
                      min = 100, max = 500, value = 200, step = 50),
          sliderInput(ns("msat_items_stage"), "Items per stage",
                      min = 5, max = 20, value = 10, step = 5),
          tags$p(class = "text-muted small mt-2 mb-1",
                 "Routing thresholds (EAP after core stage):"),
          sliderInput(ns("msat_cut_low"),  "Low/Mid cut",
                      min = -2, max = 0, value = -0.5, step = 0.1),
          sliderInput(ns("msat_cut_high"), "Mid/High cut",
                      min =  0, max = 2, value =  0.5, step = 0.1),
          actionButton(ns("msat_run"), "Run simulation",
                       class = "btn-success w-100 mt-2", icon = icon("sitemap"))
        ),
        explanation_box(
          tags$strong("Adaptive Testing Design in Large-Scale Assessments"),
          tags$p("The existing Adaptive Testing module shows how a single examinee is routed
                  through an MST. This tab asks the population-level question: when millions
                  of students from countries with very different average abilities all take
                  the same adaptive instrument, how does routing behave for each group, and
                  how much measurement precision is gained over a fixed design?"),
          tags$p("PISA 2018 introduced multistage adaptive testing (MSAT) for reading, and
                  extended it to mathematics in 2022. Students first complete a \u2018Core\u2019
                  testlet of medium difficulty; their performance routes them to a Stage 2
                  testlet (Low / Medium / High). This ensures low-performing countries receive
                  well-targeted items rather than a test designed for average OECD performance."),
          tags$ul(
            tags$li(tags$strong("Routing distribution"), ": the fraction of students on each
                    path differs dramatically across groups. A country with mean \u03b8 =
                    \u22121 will have most students on the Low path."),
            tags$li(tags$strong("Test Information Function (TIF)"), ": adaptive designs
                    produce higher information (lower SE) at the extremes of the ability
                    scale compared to a fixed medium-difficulty form."),
            tags$li(tags$strong("Design effect"), ": comparing SE(\u03b8) curves for fixed
                    vs. adaptive reveals where each design is more efficient.")
          ),
          guide = tags$ol(
            tags$li("Set group means to represent different countries (e.g., \u22121.5, \u22120.5, 0.5, 1.5)."),
            tags$li("Adjust routing thresholds to see how cut points shift path distributions."),
            tags$li("Top: routing distribution \u2014 each bar stack shows a group\u2019s path allocation."),
            tags$li("Middle-left: TIF comparison between fixed and adaptive designs."),
            tags$li("Middle-right: SE(\u03b8) curves \u2014 adaptive should be lower at extremes."),
            tags$li("Bottom: per-group summary of routing and precision.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Routing Distribution by Group"),
               plotlyOutput(ns("msat_routing_plot"), height = "360px")),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Test Information: Fixed vs. Adaptive"),
                 plotlyOutput(ns("msat_info_plot"), height = "340px")),
            card(full_screen = TRUE,
                 card_header("SE(\u03b8): Fixed vs. Adaptive"),
                 plotlyOutput(ns("msat_se_plot"), height = "340px"))
          ),
          card(full_screen = TRUE,
               card_header("Routing & Precision Summary"),
               div(style = "overflow-y: auto; max-height: 260px;",
                   tableOutput(ns("msat_summary_table"))))
        )
      )
    ),

    # ── Tab 8: Survey Sampling & Weighting ───────────────────────
    nav_panel(
      "Survey Sampling",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("sw_design"), "Sampling design",
                      choices = c("Simple Random (SRS)",
                                  "Stratified",
                                  "Cluster (PPS)",
                                  "Two-Stage (PPS + within)"),
                      selected = "Two-Stage (PPS + within)"),
          sliderInput(ns("sw_n_pop"),       "Population size",
                      min = 1000, max = 20000, value = 5000, step = 500),
          sliderInput(ns("sw_n_strata"),    "Number of strata",
                      min = 2,  max = 10, value = 4,  step = 1),
          sliderInput(ns("sw_n_clusters"),  "Number of schools (clusters)",
                      min = 10, max = 80, value = 30, step = 5),
          sliderInput(ns("sw_cluster_size"),"Students sampled per school",
                      min = 10, max = 60, value = 25, step = 5),
          actionButton(ns("sw_run"), "Draw sample",
                       class = "btn-success w-100 mt-2", icon = icon("users"))
        ),
        explanation_box(
          tags$strong("Survey Sampling & Weighting in Large-Scale Assessments"),
          tags$p("PISA and TIMSS do not sample students at random from the full population.
                  They use ", tags$strong("stratified two-stage cluster sampling"), ": first
                  schools are sampled with probability proportional to size (PPS), then a
                  fixed number of students are sampled within each selected school. This
                  keeps fieldwork costs manageable while still covering the target population."),
          tags$p("Because larger schools have a higher chance of selection, each sampled
                  student carries a ", tags$strong("sampling weight"), " \u2014 the inverse
                  of their probability of inclusion. Weighted estimates correct for the
                  unequal probabilities so that results represent the full population, not
                  just the (biased) sample."),
          tags$ul(
            tags$li(tags$strong("Design effect (DEFF)"), ": clustering inflates variance
                    relative to SRS of the same total n. DEFF = Var(cluster) / Var(SRS).
                    Typical DEFF values in PISA are 2\u20135."),
            tags$li(tags$strong("Intraclass correlation (ICC)"), ": if students within a
                    school are similar (high ICC), clustering causes more information loss
                    and a larger DEFF."),
            tags$li(tags$strong("Stratification"), " reduces variance by ensuring subgroups
                    (e.g., urban/rural, school type) are proportionally represented.")
          ),
          tags$p("The ", tags$strong("JK and BRR methods in Tab 1"), " depend directly on
                  this sampling structure: replicate weights are computed by dropping or
                  halving strata/clusters one at a time."),
          guide = tags$ol(
            tags$li("Choose a sampling design and set population parameters."),
            tags$li("Compare the \u2018Sample vs. Population\u2019 plot \u2014 unweighted sample may be biased."),
            tags$li("Check the weight distribution \u2014 high CV of weights signals design inefficiency."),
            tags$li("DEFF > 1 means clustering costs precision; stratification can partially recover it."),
            tags$li("Bottom table compares all four designs on the same population.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Sample vs. Population Distribution"),
                 plotlyOutput(ns("sw_dist_plot"),   height = "360px")),
            card(full_screen = TRUE,
                 card_header("Sampling Weight Distribution"),
                 plotlyOutput(ns("sw_weight_plot"), height = "360px"))
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Design Effect (DEFF) by Design"),
                 plotlyOutput(ns("sw_deff_plot"),   height = "300px")),
            card(full_screen = TRUE,
                 card_header("Estimation Summary"),
                 div(style = "overflow-y: auto; max-height: 300px;",
                     tableOutput(ns("sw_summary_table"))))
          )
        )
      )
    )

  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

mod_large_scale_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Booklet Equating ───────────────────────────────────────
  be_data <- reactiveVal(NULL)

  observeEvent(input$be_run, {
    withProgress(message = "Running bias estimation...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_bkl    <- input$be_n_booklets
    n_uniq   <- input$be_n_unique
    n_anch   <- input$be_n_anchor
    n_stud   <- input$be_n_students
    diff_spr <- input$be_difficulty_spread

    # Item pool: anchor items + unique items for each booklet
    n_total  <- n_anch + n_bkl * n_uniq
    anchor_idx <- seq_len(n_anch)
    b_items  <- c(
      rnorm(n_anch, 0, 0.5),                          # anchor item difficulties
      unlist(lapply(seq_len(n_bkl), function(bk) {
        rnorm(n_uniq, (bk - (n_bkl + 1) / 2) * diff_spr / (n_bkl - 1 + 1e-9), 0.6)
      }))
    )
    a_items <- runif(n_total, 0.8, 1.8)

    # Booklet item indices
    bkl_idx <- lapply(seq_len(n_bkl), function(bk) {
      uniq_start <- n_anch + (bk - 1) * n_uniq + 1
      c(anchor_idx, seq(uniq_start, uniq_start + n_uniq - 1))
    })
    bkl_length <- n_anch + n_uniq

    # Group abilities: slightly different per booklet (to show equating need)
    group_mu <- seq(-0.4, 0.4, length.out = n_bkl)

    # Simulate responses for each booklet group
    bkl_results <- lapply(seq_len(n_bkl), function(bk) {
      theta  <- rnorm(n_stud, group_mu[bk], 1)
      idx    <- bkl_idx[[bk]]
      b_bkl  <- b_items[idx];  a_bkl <- a_items[idx]
      probs  <- outer(theta, b_bkl, function(th, b) 1 / (1 + exp(-a_bkl * (th - b))))
      resp   <- matrix(rbinom(length(probs), 1, probs), nrow = n_stud)
      raw    <- rowSums(resp)
      # Anchor item sub-scores
      anch_cols <- seq_len(n_anch)
      anchor_p  <- colMeans(resp[, anch_cols, drop = FALSE])
      # Anchor item b estimates via observed proportion: b_hat ~ logit(p) / a
      b_anch_est <- log((1 - anchor_p + 1e-4) / (anchor_p + 1e-4)) / a_items[anchor_idx]
      list(theta = theta, raw = raw, b_anch_est = b_anch_est, group_mu = group_mu[bk])
    })

    # Mean-sigma equating: put each booklet on the reference scale (booklet 1)
    ref_anch_b <- bkl_results[[1]]$b_anch_est
    ref_mean   <- mean(ref_anch_b);  ref_sd <- sd(ref_anch_b)

    eq_results <- lapply(seq_len(n_bkl), function(bk) {
      tgt_b    <- bkl_results[[bk]]$b_anch_est
      tgt_mean <- mean(tgt_b);  tgt_sd <- sd(tgt_b) + 1e-8
      slope    <- ref_sd / tgt_sd
      intercept <- ref_mean - slope * tgt_mean
      raw_eq   <- slope * bkl_results[[bk]]$raw + intercept
      list(raw = bkl_results[[bk]]$raw, eq = raw_eq,
           slope = round(slope, 3), intercept = round(intercept, 3))
    })

    be_data(list(
      n_bkl = n_bkl, n_uniq = n_uniq, n_anch = n_anch,
      bkl_idx = bkl_idx, n_total = n_total, anchor_idx = anchor_idx,
      bkl_results = bkl_results, eq_results = eq_results,
      bkl_length = bkl_length
    ))
    })
  })

  # Chain linking structure diagram (reactive to n_booklets slider only)
  output$be_chain_plot <- renderPlot(bg = "transparent", {
    req(input$be_n_booklets)
    n <- input$be_n_booklets

    # Booklet positions on unit circle, starting from top
    theta_vals <- seq(pi / 2, pi / 2 + 2 * pi * (1 - 1 / n), length.out = n)
    nodes <- data.frame(
      id    = seq_len(n),
      x     = cos(theta_vals),
      y     = sin(theta_vals),
      label = paste0("B", seq_len(n))
    )

    design_lvls <- c("Chain Linking\n(TIMSS / PIRLS)",
                     "Common Anchor\n(Hub-and-Spoke)",
                     "BIB Rotation\n(PISA pre-2018)")

    # ── 1. Chain: each block links adjacent booklet pair (circular) ──────
    chain_from <- seq_len(n)
    chain_to   <- c(seq(2, n), 1L)
    chain_edges <- data.frame(
      x0 = nodes$x[chain_from], y0 = nodes$y[chain_from],
      x1 = nodes$x[chain_to],   y1 = nodes$y[chain_to],
      xm = (nodes$x[chain_from] + nodes$x[chain_to]) / 2 * 1.18,
      ym = (nodes$y[chain_from] + nodes$y[chain_to]) / 2 * 1.18,
      block = paste0("Blk", seq_len(n)),
      design = factor(design_lvls[1], levels = design_lvls)
    )
    nodes_chain <- cbind(nodes, is_hub = FALSE,
                         design = factor(design_lvls[1], levels = design_lvls))

    # ── 2. Common Anchor: central hub connected to all booklets ──────────
    hub <- data.frame(id = 0L, x = 0, y = 0,
                      label = "Anchor\nitems", is_hub = TRUE,
                      design = factor(design_lvls[2], levels = design_lvls))
    anchor_edges <- data.frame(
      x0 = 0, y0 = 0,
      x1 = nodes$x, y1 = nodes$y,
      xm = NA_real_, ym = NA_real_,
      block = paste0("A", seq_len(n)),
      design = factor(design_lvls[2], levels = design_lvls)
    )
    nodes_anchor <- rbind(
      hub,
      cbind(nodes, is_hub = FALSE, design = factor(design_lvls[2], levels = design_lvls))
    )

    # ── 3. BIB Rotation: every pair of booklets shares at least one block ─
    bib_pairs <- expand.grid(i = seq_len(n), j = seq_len(n))
    bib_pairs <- bib_pairs[bib_pairs$i < bib_pairs$j, ]
    bib_edges <- data.frame(
      x0 = nodes$x[bib_pairs$i], y0 = nodes$y[bib_pairs$i],
      x1 = nodes$x[bib_pairs$j], y1 = nodes$y[bib_pairs$j],
      xm = NA_real_, ym = NA_real_,
      block = paste0("Blk", seq_len(nrow(bib_pairs))),
      design = factor(design_lvls[3], levels = design_lvls)
    )
    nodes_bib <- cbind(nodes, is_hub = FALSE,
                       design = factor(design_lvls[3], levels = design_lvls))

    # Combine all
    all_nodes <- rbind(nodes_chain[, names(hub)], nodes_anchor, nodes_bib[, names(hub)])
    all_chain <- chain_edges
    all_anchor <- anchor_edges
    all_bib   <- bib_edges

    # Colour palette
    col_chain  <- "#268bd2"
    col_anchor <- "#2aa198"
    col_bib    <- "#b58900"

    ggplot() +
      # Chain arcs (curved)
      geom_curve(
        data = all_chain,
        aes(x = x0, y = y0, xend = x1, yend = y1),
        curvature = 0.25, linewidth = 1.6,
        color = col_chain, alpha = 0.70
      ) +
      # Chain block labels at midpoints
      geom_label(
        data = all_chain,
        aes(x = xm, y = ym, label = block),
        size = 2.2, fill = col_chain, color = "white",
        fontface = "bold", label.size = 0, label.padding = unit(1.5, "pt")
      ) +
      # Common-anchor spokes (straight)
      geom_segment(
        data = all_anchor,
        aes(x = x0, y = y0, xend = x1, yend = y1),
        linewidth = 1.6, color = col_anchor, alpha = 0.65
      ) +
      # BIB edges (all-pairs, thinner)
      geom_curve(
        data = all_bib,
        aes(x = x0, y = y0, xend = x1, yend = y1),
        curvature = 0.15, linewidth = 0.9,
        color = col_bib, alpha = 0.50
      ) +
      # Booklet nodes
      geom_point(
        data = all_nodes[!all_nodes$is_hub, ],
        aes(x = x, y = y),
        size = 11, shape = 21,
        fill = "#fdf6e3", color = "#657b83", stroke = 1.2
      ) +
      # Hub node (common anchor)
      geom_point(
        data = all_nodes[all_nodes$is_hub, ],
        aes(x = x, y = y),
        size = 16, shape = 22,
        fill = col_anchor, color = "white", stroke = 0
      ) +
      # Node labels
      geom_text(
        data = all_nodes[!all_nodes$is_hub, ],
        aes(x = x, y = y, label = label),
        size = 3.0, color = "#073642", fontface = "bold"
      ) +
      geom_text(
        data = all_nodes[all_nodes$is_hub, ],
        aes(x = x, y = y, label = label),
        size = 2.6, color = "white", fontface = "bold", lineheight = 0.85
      ) +
      facet_wrap(~ design, ncol = 3) +
      coord_equal(xlim = c(-1.55, 1.55), ylim = c(-1.55, 1.55)) +
      labs(
        title = paste0(
          "Three linking designs compared  \u2014  ",
          n, " booklets"
        )
      ) +
      theme_void(base_size = 11) +
      theme(
        strip.text       = element_text(size = 10, colour = "#657b83",
                                        face = "bold", margin = ggplot2::margin(b = 6)),
        plot.title       = element_text(size = 9.5, colour = "#657b83",
                                        hjust = 0.5, margin = ggplot2::margin(b = 8)),
        strip.background = element_blank(),
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  })

  # Item overlap diagram (supports Common Anchor and Chain Linking designs)
  output$be_overlap_plot <- renderPlot(bg = "transparent", {
    req(be_data(), input$be_overlap_design)
    r <- be_data()
    design <- input$be_overlap_design

    n_bkl  <- r$n_bkl
    n_uniq <- r$n_uniq
    n_anch <- r$n_anch
    bkl_names <- paste0("B", seq_len(n_bkl))

    if (design == "Common Anchor") {
      # Original design: shared anchor items + unique items per booklet
      item_names <- seq_len(r$n_total)
      df <- expand.grid(Booklet = bkl_names, Item = item_names)
      in_booklet <- as.integer(mapply(function(bk_str, it) {
        bk <- which(bkl_names == bk_str)
        it %in% r$bkl_idx[[bk]]
      }, df$Booklet, df$Item))
      is_anchor <- df$Item %in% r$anchor_idx

      df$Type <- factor(
        ifelse(in_booklet == 0L, "Not in booklet",
               ifelse(is_anchor, "Anchor (shared)", "Unique")),
        levels = c("Not in booklet", "Unique", "Anchor (shared)")
      )
      n_pool      <- r$n_total
      n_per_bkl   <- n_anch + n_uniq
      pct_shared  <- round(100 * n_anch / n_per_bkl)
      plot_title  <- paste0("Common Anchor: ", n_anch, " anchor items (dark) + ",
                            n_uniq, " unique per booklet (light)")
      plot_caption <- paste0(
        "Item pool: ", n_pool, " items total  \u2022  ",
        n_per_bkl, " items/booklet  \u2022  ",
        pct_shared, "% shared across all booklets"
      )

    } else if (design == "Chain Linking") {
      # Chain Linking: adjacent booklets share a link block, no global anchor
      n_link <- max(2L, round(n_anch / 2))
      link_blocks <- lapply(seq_len(n_bkl), function(k) {
        paste0("L", k, "_", seq_len(n_link))
      })
      unique_blocks <- lapply(seq_len(n_bkl), function(k) {
        paste0("U", k, "_", seq_len(n_uniq))
      })
      bkl_items <- lapply(seq_len(n_bkl), function(k) {
        left_k  <- if (k == 1) n_bkl else k - 1
        c(link_blocks[[left_k]], unique_blocks[[k]], link_blocks[[k]])
      })
      link_items  <- sort(unique(unlist(link_blocks)))
      uniq_items  <- sort(unique(unlist(unique_blocks)))
      all_items   <- c(link_items, uniq_items)
      n_total_chain <- length(all_items)

      df <- expand.grid(Booklet = bkl_names, Item = seq_len(n_total_chain))
      in_booklet <- as.integer(mapply(function(bk_str, it_idx) {
        bk <- which(bkl_names == bk_str)
        all_items[it_idx] %in% bkl_items[[bk]]
      }, df$Booklet, df$Item))
      is_link <- all_items[df$Item] %in% unlist(link_blocks)

      df$Type <- factor(
        ifelse(in_booklet == 0L, "Not in booklet",
               ifelse(is_link, "Chain link", "Unique")),
        levels = c("Not in booklet", "Unique", "Chain link")
      )
      n_per_bkl  <- 2L * n_link + n_uniq
      pct_shared <- round(100 * (2L * n_link) / n_per_bkl)
      plot_title  <- paste0("Chain Linking: ", n_link,
                            " link items per adjacent pair + ",
                            n_uniq, " unique per booklet")
      plot_caption <- paste0(
        "Item pool: ", n_total_chain, " items total  \u2022  ",
        n_per_bkl, " items/booklet  \u2022  ",
        pct_shared, "% shared with neighbours"
      )

    } else {
      # BIB Rotation: every pair of booklets shares a small block of items
      n_shared <- max(1L, round(n_anch / max(1L, n_bkl - 1)))
      pairs <- which(upper.tri(matrix(0, n_bkl, n_bkl)), arr.ind = TRUE)
      shared_blocks <- lapply(seq_len(nrow(pairs)), function(p) {
        paste0("S", pairs[p, 1], "x", pairs[p, 2], "_", seq_len(n_shared))
      })
      unique_blocks <- lapply(seq_len(n_bkl), function(k) {
        paste0("U", k, "_", seq_len(n_uniq))
      })
      bkl_items <- lapply(seq_len(n_bkl), function(k) {
        pair_idx <- which(pairs[, 1] == k | pairs[, 2] == k)
        c(unlist(shared_blocks[pair_idx]), unique_blocks[[k]])
      })
      shared_item_ids <- sort(unique(unlist(shared_blocks)))
      uniq_item_ids   <- sort(unique(unlist(unique_blocks)))
      all_items       <- c(shared_item_ids, uniq_item_ids)
      n_total_bib     <- length(all_items)

      df <- expand.grid(Booklet = bkl_names, Item = seq_len(n_total_bib))
      in_booklet <- as.integer(mapply(function(bk_str, it_idx) {
        bk <- which(bkl_names == bk_str)
        all_items[it_idx] %in% bkl_items[[bk]]
      }, df$Booklet, df$Item))
      is_shared <- all_items[df$Item] %in% shared_item_ids

      df$Type <- factor(
        ifelse(in_booklet == 0L, "Not in booklet",
               ifelse(is_shared, "BIB shared", "Unique")),
        levels = c("Not in booklet", "Unique", "BIB shared")
      )
      n_pairs    <- nrow(pairs)
      n_per_bkl  <- (n_bkl - 1L) * n_shared + n_uniq
      pct_shared <- round(100 * ((n_bkl - 1L) * n_shared) / n_per_bkl)
      plot_title  <- paste0("BIB Rotation: ", n_shared,
                            " shared items per pair \u00d7 ", n_pairs,
                            " pairs + ", n_uniq, " unique per booklet")
      plot_caption <- paste0(
        "Item pool: ", n_total_bib, " items total  \u2022  ",
        n_per_bkl, " items/booklet  \u2022  ",
        pct_shared, "% shared across pairs"
      )
    }

    ggplot(df, aes(x = Item, y = Booklet, fill = Type)) +
      geom_tile(colour = "white", linewidth = 0.35) +
      scale_fill_manual(
        values = c("Not in booklet"  = "#eee8d5",
                   "Unique"          = "#93c4de",
                   "Chain link"      = "#d33682",
                   "BIB shared"      = "#b58900",
                   "Anchor (shared)" = "#268bd2"),
        drop = TRUE, name = NULL
      ) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_discrete(limits = rev, expand = c(0, 0)) +
      labs(x = "Item", y = NULL, title = plot_title, caption = plot_caption) +
      theme_minimal(base_size = 11) +
      theme(
        panel.grid       = element_blank(),
        axis.text        = element_text(colour = "#657b83"),
        axis.title       = element_text(colour = "#657b83"),
        plot.title       = element_text(colour = "#657b83", size = 10),
        plot.caption     = element_text(colour = "#93a1a1", size = 8.5,
                                        hjust = 0.5,
                                        margin = ggplot2::margin(t = 6)),
        legend.text      = element_text(colour = "#657b83"),
        legend.position  = "bottom",
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  })

  # Anchor item difficulty estimates per booklet
  output$be_anchor_plot <- renderPlotly({
    req(be_data())
    r <- be_data()

    bkl_names <- paste0("Booklet ", seq_len(r$n_bkl))
    colors <- grDevices::hcl.colors(r$n_bkl, "Dark2")

    p <- plot_ly()
    for (bk in seq_len(r$n_bkl)) {
      b_est <- r$bkl_results[[bk]]$b_anch_est
      p <- p |>
        add_trace(
          x = seq_len(r$n_anch), y = b_est,
          type = "scatter", mode = "lines+markers",
          name = bkl_names[bk],
          line   = list(color = colors[bk], width = 1.8),
          marker = list(color = colors[bk], size = 7),
          hoverinfo = "text",
          text = paste0(bkl_names[bk],
                        "<br>Anchor item ", seq_len(r$n_anch),
                        "<br>b\u0302 = ", round(b_est, 3))
        )
    }
    p |> layout(
      xaxis = list(title = "Anchor Item Index", dtick = 1),
      yaxis = list(title = "Estimated Difficulty (b\u0302)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.2, yanchor = "top"),
      annotations = list(
        list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
             text = "Lines should track together if anchor items link booklets correctly",
             showarrow = FALSE, font = list(size = 10, color = "#657b83"))
      ),
      margin = list(t = 35, b = 60)
    ) |> config(displayModeBar = FALSE)
  })

  # Raw score distributions
  output$be_raw_dist <- renderPlotly({
    req(be_data())
    r <- be_data()
    colors <- grDevices::hcl.colors(r$n_bkl, "Dark2")
    p <- plot_ly()
    for (bk in seq_len(r$n_bkl)) {
      raw <- r$eq_results[[bk]]$raw
      p <- p |> add_trace(
        x = raw, type = "histogram", nbinsx = 20,
        name = paste0("B", bk),
        marker = list(color = colors[bk], opacity = 0.55,
                      line = list(color = "white", width = 0.5)),
        hovertemplate = paste0("B", bk, " raw: %{x}<br>Count: %{y}<extra></extra>")
      )
    }
    p |> layout(
      barmode = "overlay",
      xaxis = list(title = "Raw Score"),
      yaxis = list(title = "Count"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.25, yanchor = "top"),
      margin = list(b = 55)
    ) |> config(displayModeBar = FALSE)
  })

  # Equated score distributions
  output$be_eq_dist <- renderPlotly({
    req(be_data())
    r <- be_data()
    colors <- grDevices::hcl.colors(r$n_bkl, "Dark2")
    p <- plot_ly()
    for (bk in seq_len(r$n_bkl)) {
      eq <- r$eq_results[[bk]]$eq
      sl <- r$eq_results[[bk]]$slope
      ic <- r$eq_results[[bk]]$intercept
      p <- p |> add_trace(
        x = eq, type = "histogram", nbinsx = 20,
        name = paste0("B", bk),
        marker = list(color = colors[bk], opacity = 0.55,
                      line = list(color = "white", width = 0.5)),
        hovertemplate = paste0("B", bk, " equated: %{x:.2f}<br>Count: %{y}",
                               "<br>slope=", sl, " int=", ic, "<extra></extra>")
      )
    }
    p |> layout(
      barmode = "overlay",
      xaxis = list(title = "Equated Score (Reference Scale)"),
      yaxis = list(title = "Count"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.25, yanchor = "top"),
      annotations = list(
        list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
             text = "Distributions should overlap more after equating",
             showarrow = FALSE, font = list(size = 10, color = "#657b83"))
      ),
      margin = list(t = 30, b = 55)
    ) |> config(displayModeBar = FALSE)
  })

  # ── Matrix Sampling ────────────────────────────────────────
  ms_data <- reactiveVal(NULL)

  observeEvent(input$ms_run, {
    withProgress(message = "Running multi-stage sampling...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_items <- input$ms_n_items
    n_bkl   <- input$ms_n_booklets
    ipb     <- min(input$ms_ipb, n_items)
    n_stud  <- input$ms_n_students
    p_corr  <- input$ms_prop_correct

    # Balanced assignment via cycling: each item appears ~floor/ceiling times
    total_slots <- n_bkl * ipb
    pool <- rep(seq_len(n_items), ceiling(total_slots / n_items))
    pool <- sample(pool)[seq_len(total_slots)]
    book_items <- split(pool, rep(seq_len(n_bkl), each = ipb))
    # Deduplicate within each booklet
    book_items <- lapply(book_items, function(x) unique(x)[seq_len(min(length(unique(x)), ipb))])

    # Binary assignment matrix: rows = booklets, cols = items
    asgn <- matrix(0L, nrow = n_bkl, ncol = n_items)
    for (b in seq_len(n_bkl)) asgn[b, book_items[[b]]] <- 1L

    exposure <- colSums(asgn)   # how many booklets each item appears in

    # Assign students to booklets round-robin; generate responses
    stud_bkl <- rep(seq_len(n_bkl), length.out = n_stud)
    resp_mat <- matrix(NA_integer_, nrow = n_stud, ncol = n_items)
    for (s in seq_len(n_stud)) {
      items_seen <- which(asgn[stud_bkl[s], ] == 1L)
      resp_mat[s, items_seen] <- rbinom(length(items_seen), 1, p_corr)
    }

    ms_data(list(
      asgn = asgn, exposure = exposure,
      resp_mat = resp_mat, stud_bkl = stud_bkl,
      n_items = n_items, n_bkl = n_bkl, ipb = ipb, n_stud = n_stud
    ))
    })
  })

  output$ms_booklet_grid <- renderPlot(bg = "transparent", {
    req(ms_data())
    r <- ms_data()

    # Melt: expand.grid gives Booklet cycling fastest (matches as.vector column-major)
    df <- expand.grid(
      Booklet = paste0("B", seq_len(r$n_bkl)),
      Item    = seq_len(r$n_items)
    )
    df$Status <- factor(
      as.vector(r$asgn),
      levels = c(0L, 1L), labels = c("Excluded", "Included")
    )

    pct_coverage <- round(100 * r$ipb / r$n_items)

    ggplot(df, aes(x = Item, y = Booklet, fill = Status)) +
      geom_tile(colour = "white", linewidth = 0.3) +
      scale_fill_manual(
        values = c("Excluded" = "#eee8d5", "Included" = "#268bd2"), name = NULL
      ) +
      scale_x_continuous(breaks = seq(5, r$n_items, by = 5), expand = c(0, 0)) +
      scale_y_discrete(limits = rev, expand = c(0, 0)) +
      labs(
        x = "Item", y = NULL,
        title = paste0(r$n_bkl, " booklets \u00d7 ", r$n_items, " items  |  ",
                       r$ipb, " items per booklet (", pct_coverage, "% coverage per student)")
      ) +
      theme_minimal(base_size = 11) +
      theme(
        panel.grid    = element_blank(),
        axis.text     = element_text(colour = "#657b83"),
        axis.title    = element_text(colour = "#657b83"),
        plot.title    = element_text(colour = "#657b83", size = 10),
        legend.text   = element_text(colour = "#657b83"),
        legend.position = "bottom",
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  })

  output$ms_exposure_plot <- renderPlotly({
    req(ms_data())
    r    <- ms_data()
    avg  <- mean(r$exposure)
    items <- seq_len(r$n_items)

    plot_ly(
      x = items, y = r$exposure,
      type = "bar",
      marker = list(color = "#268bd2", opacity = 0.75,
                    line = list(color = "white", width = 0.5)),
      hoverinfo = "text",
      text = paste0("Item ", items,
                    "<br>Appears in ", r$exposure, " of ", r$n_bkl, " booklets")
    ) |>
      layout(
        xaxis = list(title = "Item"),
        yaxis = list(title = "Booklets item appears in",
                     range = c(0, r$n_bkl + 0.5)),
        bargap = 0.05,
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = avg, y1 = avg,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = avg,
               text = paste0("Mean = ", round(avg, 1)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(r = 60)
      ) |>
      config(displayModeBar = FALSE)
  })

  output$ms_student_grid <- renderPlot(bg = "transparent", {
    req(ms_data())
    r <- ms_data()

    # Sort students by booklet
    ord  <- order(r$stud_bkl)
    resp <- r$resp_mat[ord, ]
    bkl  <- r$stud_bkl[ord]

    df <- expand.grid(Student = seq_len(r$n_stud), Item = seq_len(r$n_items))
    vals <- as.vector(resp)
    df$Response <- factor(
      ifelse(is.na(vals), "Not admin.",
             ifelse(vals == 1L, "Correct", "Incorrect")),
      levels = c("Not admin.", "Incorrect", "Correct")
    )

    # Booklet boundaries and centre labels
    bkl_starts <- c(which(!duplicated(bkl)), r$n_stud + 1)
    bkl_mid    <- (bkl_starts[-length(bkl_starts)] + bkl_starts[-1] - 1) / 2
    bkl_lbl    <- data.frame(y = bkl_mid, label = paste0("B", seq_len(r$n_bkl)))

    ggplot(df, aes(x = Item, y = Student, fill = Response)) +
      geom_tile(linewidth = 0) +
      geom_hline(yintercept = bkl_starts[-c(1, length(bkl_starts))] - 0.5,
                 colour = "white", linewidth = 0.9) +
      scale_fill_manual(
        values = c("Not admin." = "#eee8d5", "Incorrect" = "#9ecae1",
                   "Correct"    = "#1a6fad"),
        name = NULL
      ) +
      scale_x_continuous(breaks = seq(5, r$n_items, by = 5), expand = c(0, 0)) +
      scale_y_continuous(
        breaks = bkl_lbl$y, labels = bkl_lbl$label,
        expand = c(0, 0)
      ) +
      labs(x = "Item", y = "Booklet",
           title = paste0(r$n_stud, " students  |  Each sees ",
                          round(100 * r$ipb / r$n_items), "% of items")) +
      theme_minimal(base_size = 11) +
      theme(
        panel.grid   = element_blank(),
        axis.text    = element_text(colour = "#657b83", size = 9),
        axis.title   = element_text(colour = "#657b83"),
        plot.title   = element_text(colour = "#657b83", size = 10),
        legend.text  = element_text(colour = "#657b83"),
        legend.position  = "bottom",
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  })

  # ── PV / JK / BRR ──────────────────────────────────────────
  
  # =====================================================================
  # Plausible Values
  # =====================================================================
  pv_result <- reactiveVal(NULL)
  
  observeEvent(input$pv_go, {
    withProgress(message = "Generating plausible values...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$pv_n; k <- input$pv_items
    npv <- input$pv_npv; rel <- input$pv_reliability
    
    # True abilities
    theta_true <- rnorm(n)
    
    # Observed scores with measurement error
    # reliability = var(true) / var(observed) = var(true) / (var(true) + var(error))
    # error_sd = sqrt(var(true) * (1 - rel) / rel)
    # But since var(true) ~ 1:
    error_sd <- sqrt((1 - rel) / rel)
    theta_obs <- theta_true + rnorm(n, 0, error_sd)
    
    # Posterior for each student: given observed score and population prior N(0,1)
    # Posterior mean = (rel * theta_obs + (1 - rel) * 0) = rel * theta_obs
    # Posterior SD = sqrt(rel * (1 - rel))  ... actually:
    # With prior precision = 1 and likelihood precision = 1/error_sd^2
    prior_prec <- 1
    lik_prec <- 1 / error_sd^2
    post_prec <- prior_prec + lik_prec
    post_sd <- sqrt(1 / post_prec)
    post_mean <- (prior_prec * 0 + lik_prec * theta_obs) / post_prec
    
    # Draw plausible values
    pv_matrix <- matrix(NA, n, npv)
    for (m in seq_len(npv)) {
      pv_matrix[, m] <- rnorm(n, post_mean, post_sd)
    }
    
    pv_result(list(
      theta_true = theta_true, theta_obs = theta_obs,
      post_mean = post_mean, post_sd = post_sd,
      pv = pv_matrix, npv = npv, n = n
    ))
    })
  })
  
  output$pv_posterior_plot <- renderPlotly({
    res <- pv_result()
    req(res)

    i <- sample(res$n, 1)
    psd <- res$post_sd
    theta_seq <- seq(res$post_mean[i] - 4 * psd,
                     res$post_mean[i] + 4 * psd, length.out = 300)
    dens <- dnorm(theta_seq, res$post_mean[i], psd)
    true_val <- res$theta_true[i]
    obs_val <- res$theta_obs[i]
    pv_draws <- res$pv[i, ]

    plot_ly() |>
      add_trace(x = theta_seq, y = dens, type = "scatter", mode = "lines",
                fill = "tozeroy", fillcolor = "rgba(178,223,138,0.4)",
                line = list(color = "#238b45", width = 2),
                hoverinfo = "text",
                text = paste0("\u03b8 = ", round(theta_seq, 2), "<br>Density = ", round(dens, 4)),
                showlegend = FALSE) |>
      add_trace(x = pv_draws, y = rep(0, length(pv_draws)),
                type = "scatter", mode = "markers",
                marker = list(color = "#006d2c", size = 10, symbol = "triangle-up"),
                hoverinfo = "text",
                text = paste0("PV draw: ", round(pv_draws, 3)),
                showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Ability (\u03b8)"),
        yaxis = list(title = "Density"),
        shapes = list(
          list(type = "line", x0 = true_val, x1 = true_val, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1.5)),
          list(type = "line", x0 = obs_val, x1 = obs_val, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#2171b5", dash = "dot", width = 1.5))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Student ", i, "  |  \u25bc = PV draws"),
               showarrow = FALSE, font = list(size = 12)),
          list(x = true_val, y = 1.02, yref = "paper",
               text = paste0("True \u03b8 = ", round(true_val, 2)),
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "#e31a1c")),
          list(x = obs_val, y = 0.95, yref = "paper",
               text = paste0("Observed = ", round(obs_val, 2)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#2171b5"))
        ),
        margin = list(t = 40)
      )
  })

  output$pv_means_plot <- renderPlotly({
    res <- pv_result()
    req(res)

    pv_means <- colMeans(res$pv)
    df <- data.frame(pv_set = seq_along(pv_means), mean = pv_means)
    overall <- mean(pv_means)

    true_mean <- mean(res$theta_true)
    hover <- paste0("PV Set ", df$pv_set,
                     "<br>Mean = ", round(df$mean, 4),
                     "<br>Diff from true: ", round(df$mean - true_mean, 4))
    plot_ly() |>
      add_bars(x = df$pv_set, y = df$mean, text = hover, textposition = "none",
               hoverinfo = "text",
               marker = list(color = "#41ae76", opacity = 0.8),
               showlegend = FALSE, width = 0.6) |>
      layout(
        xaxis = list(title = "PV Set"),
        yaxis = list(title = "Estimated Population Mean"),
        bargap = 0.3,
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = overall, y1 = overall,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5)),
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = true_mean, y1 = true_mean,
               line = list(color = "#2171b5", dash = "dot", width = 1.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = overall,
               text = paste0("PV mean = ", round(overall, 3)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c")),
          list(x = 1.02, xref = "paper", y = true_mean,
               text = paste0("True mean = ", round(true_mean, 3)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#2171b5"))
        )
      )
  })
  
  output$pv_var_table <- renderTable({
    res <- pv_result()
    req(res)
    
    pv_means <- colMeans(res$pv)
    overall_mean <- mean(pv_means)
    
    # Within-PV variance (average sampling variance)
    within_var <- mean(sapply(seq_len(res$npv), function(m) {
      var(res$pv[, m]) / res$n
    }))
    
    # Between-PV variance
    between_var <- var(pv_means)
    
    # Total variance (Rubin's rules)
    total_var <- within_var + (1 + 1 / res$npv) * between_var
    
    data.frame(
      Component = c("Within-PV (sampling) variance",
                     "Between-PV (imputation) variance",
                     "Total variance (Rubin's rules)",
                     "Total SE",
                     "% due to measurement uncertainty"),
      Value = c(format(within_var, digits = 4),
                format(between_var, digits = 4),
                format(total_var, digits = 4),
                format(sqrt(total_var), digits = 4),
                paste0(round(100 * (1 + 1 / res$npv) * between_var / total_var, 1), "%"))
    )
  }, hover = TRUE, spacing = "m")
  
  # =====================================================================
  # Jackknife
  # =====================================================================
  jk_result <- reactiveVal(NULL)
  
  observeEvent(input$jk_go, {
    withProgress(message = "Running jackknife resampling...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$jk_n
    
    # Generate data
    x <- switch(input$jk_dist,
      "Normal" = rnorm(n),
      "Skewed (log-normal)" = rlnorm(n, 0, 0.8),
      "Heavy-tailed (t, df=3)" = rt(n, df = 3)
    )
    y <- 0.6 * x + rnorm(n, 0, 0.8)
    
    stat_fn <- switch(input$jk_stat,
      "Mean" = function(d) mean(d$x),
      "Median" = function(d) median(d$x),
      "Variance" = function(d) var(d$x),
      "Correlation" = function(d) cor(d$x, d$y)
    )
    
    dat <- data.frame(x = x, y = y)
    theta_full <- stat_fn(dat)
    
    # Leave-one-out
    theta_loo <- sapply(seq_len(n), function(i) {
      stat_fn(dat[-i, , drop = FALSE])
    })
    
    # Pseudo-values
    pseudo <- n * theta_full - (n - 1) * theta_loo
    
    jk_est <- mean(pseudo)
    jk_se <- sqrt(var(pseudo) / n)
    jk_bias <- (n - 1) * (mean(theta_loo) - theta_full)
    
    jk_result(list(
      theta_full = theta_full, theta_loo = theta_loo,
      pseudo = pseudo, jk_est = jk_est, jk_se = jk_se,
      jk_bias = jk_bias, n = n, stat = input$jk_stat
    ))
    })
  })
  
  output$jk_pseudo_plot <- renderPlotly({
    res <- jk_result()
    req(res)

    full_est <- res$theta_full
    h <- hist(res$pseudo, breaks = 20, plot = FALSE)
    hover <- paste0("Pseudo-value \u2248 ", round(h$mids, 3), "<br>Count: ", h$counts)
    plot_ly() |>
      add_bars(x = h$mids, y = h$counts, text = hover, textposition = "none",
               hoverinfo = "text", width = diff(h$breaks)[1],
               marker = list(color = "#41ae76", opacity = 0.8,
                             line = list(color = "white", width = 0.5)),
               showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Pseudo-value"),
        yaxis = list(title = "Count"),
        bargap = 0.02,
        shapes = list(
          list(type = "line", x0 = full_est, x1 = full_est, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Jackknife pseudo-values for ", res$stat),
               showarrow = FALSE, font = list(size = 12)),
          list(x = full_est, y = 1.02, yref = "paper",
               text = paste0("Full-sample = ", round(full_est, 3)),
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      )
  })

  output$jk_influence_plot <- renderPlotly({
    res <- jk_result()
    req(res)

    influence <- res$theta_full - res$theta_loo
    obs <- seq_len(res$n)
    hover <- paste0("Obs ", obs, "<br>\u0394 = ", round(influence, 4))

    p <- plot_ly()
    # Lollipop stems
    for (i in seq_along(obs)) {
      p <- p |> add_trace(x = rep(obs[i], 2), y = c(0, influence[i]),
                           type = "scatter", mode = "lines",
                           line = list(color = "rgba(35,139,69,0.6)", width = 1.5),
                           showlegend = FALSE, hoverinfo = "skip")
    }
    p |>
      add_trace(x = obs, y = influence, type = "scatter", mode = "markers",
                marker = list(color = "#006d2c", size = 6),
                hoverinfo = "text", text = hover, showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Observation removed"),
        yaxis = list(title = "Influence (\u0394 statistic)"),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = 0, y1 = 0, line = list(color = "grey50", width = 1))
        )
      )
  })
  
  output$jk_results_table <- renderTable({
    res <- jk_result()
    req(res)
    
    data.frame(
      Quantity = c("Full-sample estimate",
                   "Jackknife estimate",
                   "Jackknife SE",
                   "Jackknife bias estimate",
                   "95% CI lower",
                   "95% CI upper"),
      Value = c(round(res$theta_full, 4),
                round(res$jk_est, 4),
                round(res$jk_se, 4),
                round(res$jk_bias, 4),
                round(res$jk_est - 1.96 * res$jk_se, 4),
                round(res$jk_est + 1.96 * res$jk_se, 4))
    )
  }, hover = TRUE, spacing = "m")
  
  # =====================================================================
  # BRR
  # =====================================================================
  brr_result <- reactiveVal(NULL)
  
  observeEvent(input$brr_go, {
    withProgress(message = "Running balanced repeated replication...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n_strata <- input$brr_n_strata
    n_per <- input$brr_n_per
    n_reps <- input$brr_reps
    
    # Generate stratified data: 2 PSUs per stratum
    dat <- do.call(rbind, lapply(seq_len(n_strata), function(h) {
      # Stratum effect
      stratum_eff <- rnorm(1, 0, 1)
      psu1_eff <- rnorm(1, stratum_eff, 0.3)
      psu2_eff <- rnorm(1, stratum_eff, 0.3)
      
      n_half <- n_per %/% 2
      x1 <- rnorm(n_half, psu1_eff, 1)
      x2 <- rnorm(n_half, psu2_eff, 1)
      
      data.frame(
        stratum = h,
        psu = rep(c(1, 2), each = n_half),
        x = c(x1, x2),
        y = c(0.5 * x1 + rnorm(n_half, 0, 0.8),
              0.5 * x2 + rnorm(n_half, 0, 0.8))
      )
    }))
    
    stat_fn <- switch(input$brr_stat,
      "Mean" = function(d) mean(d$x),
      "Median" = function(d) median(d$x),
      "Regression slope" = function(d) {
        if (nrow(d) < 3) return(NA)
        coef(lm(y ~ x, data = d))[2]
      }
    )
    
    theta_full <- stat_fn(dat)
    
    # Generate BRR replicates using random sign-flipping (Fay-like)
    rep_estimates <- sapply(seq_len(n_reps), function(r) {
      # For each stratum, randomly select PSU 1 or PSU 2 to keep (weight = 2)
      signs <- sample(c(1, 2), n_strata, replace = TRUE)
      
      rep_data <- do.call(rbind, lapply(seq_len(n_strata), function(h) {
        stratum_data <- dat[dat$stratum == h, ]
        selected_psu <- signs[h]
        stratum_data[stratum_data$psu == selected_psu, ]
      }))
      
      stat_fn(rep_data)
    })
    
    brr_se <- sqrt(mean((rep_estimates - theta_full)^2))
    
    brr_result(list(
      theta_full = theta_full, rep_estimates = rep_estimates,
      brr_se = brr_se, n_reps = n_reps, stat = input$brr_stat
    ))
    })
  })
  
  output$brr_dist_plot <- renderPlotly({
    res <- brr_result()
    req(res)

    full_est <- res$theta_full
    h <- hist(res$rep_estimates, breaks = 25, plot = FALSE)
    hover <- paste0("Estimate \u2248 ", round(h$mids, 3), "<br>Count: ", h$counts)
    plot_ly() |>
      add_bars(x = h$mids, y = h$counts, text = hover, textposition = "none",
               hoverinfo = "text", width = diff(h$breaks)[1],
               marker = list(color = "#41ae76", opacity = 0.8,
                             line = list(color = "white", width = 0.5)),
               showlegend = FALSE) |>
      layout(
        xaxis = list(title = paste0("Replicate Estimate (", res$stat, ")")),
        yaxis = list(title = "Count"),
        bargap = 0.02,
        shapes = list(
          list(type = "line", x0 = full_est, x1 = full_est, y0 = 0, y1 = 1,
               yref = "paper", line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(res$n_reps, " BRR replicates"),
               showarrow = FALSE, font = list(size = 12)),
          list(x = full_est, y = 1.02, yref = "paper",
               text = paste0("Full-sample = ", round(full_est, 3)),
               showarrow = FALSE, xanchor = "left", yanchor = "bottom",
               font = list(size = 9, color = "#e31a1c"))
        ),
        margin = list(t = 40)
      )
  })

  output$brr_conv_plot <- renderPlotly({
    res <- brr_result()
    req(res)

    cum_se <- sapply(seq_along(res$rep_estimates), function(r) {
      if (r < 2) return(NA)
      sqrt(mean((res$rep_estimates[1:r] - res$theta_full)^2))
    })

    df <- data.frame(reps = seq_along(cum_se), se = cum_se)
    df$text <- paste0("Replicates: ", df$reps,
                      "<br>Cumulative SE: ", round(df$se, 5))

    final_se <- res$brr_se
    plot_ly() |>
      add_trace(x = df$reps, y = df$se, type = "scatter", mode = "lines",
                line = list(color = "#238b45", width = 2),
                hoverinfo = "text", text = df$text, showlegend = FALSE) |>
      layout(
        xaxis = list(title = "Number of Replicates"),
        yaxis = list(title = "Cumulative BRR SE"),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, xref = "paper",
               y0 = final_se, y1 = final_se,
               line = list(color = "#e31a1c", dash = "dash", width = 1.5))
        ),
        annotations = list(
          list(x = 1.02, xref = "paper", y = final_se,
               text = paste0("Final SE = ", round(final_se, 4)),
               showarrow = FALSE, xanchor = "left",
               font = list(size = 9, color = "#e31a1c"))
        )
      )
  })
  
  output$brr_results_table <- renderTable({
    res <- brr_result()
    req(res)
    
    data.frame(
      Quantity = c("Full-sample estimate",
                   "BRR standard error",
                   "Number of replicates",
                   "95% CI lower",
                   "95% CI upper"),
      Value = c(round(res$theta_full, 4),
                round(res$brr_se, 4),
                res$n_reps,
                round(res$theta_full - 1.96 * res$brr_se, 4),
                round(res$theta_full + 1.96 * res$brr_se, 4))
    )
  }, hover = TRUE, spacing = "m")
  

  # ── Standard Setting ───────────────────────────────────────

  ss_result <- reactiveVal(NULL)

  observeEvent(input$ss_run, {
    withProgress(message = "Running stratified sampling...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_items  <- input$ss_n_items
    n_judges <- input$ss_n_judges
    j_var    <- input$ss_judge_var
    method   <- input$ss_method

    # Generate item difficulties (2PL with a ~ 1)
    b <- sort(runif(n_items, -2, 2))
    a <- runif(n_items, 0.8, 1.5)

    if (method == "Modified Angoff") {
      true_p <- 1 / (1 + exp(-a * (0 - b)))
      ratings <- sapply(seq_len(n_judges), function(j) {
        pmin(pmax(true_p + rnorm(n_items, 0, j_var), 0.05), 0.95)
      })
      colnames(ratings) <- paste0("J", seq_len(n_judges))
      rownames(ratings) <- paste0("Item ", seq_len(n_items))
      judge_totals <- colSums(ratings)
      cut_score <- mean(judge_totals)

      ss_result(list(method = method, ratings = ratings, judge_totals = judge_totals,
                     cut_score = cut_score, b = b, a = a, n_items = n_items))
    } else {
      rp <- input$ss_rp
      theta_at_rp <- b + log(rp / (1 - rp)) / a
      true_bookmark <- which.min(abs(theta_at_rp - 0))
      judge_bookmarks <- pmin(pmax(
        round(true_bookmark + rnorm(n_judges, 0, j_var * n_items)),
        1), n_items)
      judge_thetas <- b[judge_bookmarks]
      cut_theta <- mean(judge_thetas)
      cut_score <- sum(1 / (1 + exp(-a * (cut_theta - b))))

      ss_result(list(method = method, bookmarks = judge_bookmarks,
                     judge_thetas = judge_thetas, cut_theta = cut_theta,
                     cut_score = cut_score, b = b, a = a, n_items = n_items,
                     rp = rp))
    }
    })
  })

  output$ss_ratings <- renderPlot(bg = "transparent", {
    req(ss_result())
    r <- ss_result()

    if (r$method == "Modified Angoff") {
      items  <- paste0("Item ", seq_len(r$n_items))
      judges <- colnames(r$ratings)
      df_ang <- data.frame(
        Judge  = factor(rep(judges, each = r$n_items), levels = judges),
        Item   = factor(rep(items, length(judges)),    levels = rev(items)),
        Rating = as.vector(r$ratings)
      )
      ggplot(df_ang, aes(x = Judge, y = Item, fill = Rating)) +
        geom_tile(colour = "white", linewidth = 0.5) +
        geom_text(aes(label = sprintf("%.2f", Rating)), size = 3, colour = "white") +
        scale_fill_gradient2(low = "#fdf6e3", mid = "#268bd2", high = "#073642",
                             midpoint = 0.5, limits = c(0, 1), name = "Rating") +
        scale_x_discrete(expand = c(0, 0)) +
        scale_y_discrete(expand = c(0, 0)) +
        labs(title = "Angoff Probability Ratings", x = NULL, y = NULL) +
        theme_minimal(base_size = 11) +
        theme(panel.grid = element_blank(),
              axis.text.x = element_text(angle = 45, hjust = 1, colour = "#657b83"),
              axis.text.y = element_text(colour = "#657b83"),
              plot.title   = element_text(colour = "#657b83", size = 12),
              legend.title = element_text(colour = "#657b83"),
              legend.text  = element_text(colour = "#657b83"),
              plot.background  = element_rect(fill = "transparent", colour = NA),
              panel.background = element_rect(fill = "transparent", colour = NA))

    } else {
      # Bookmark method — keep as ggplot2 bar+point chart
      bm_df <- data.frame(item = seq_len(r$n_items), b = r$b)
      judge_names <- paste0("J", seq_along(r$bookmarks))
      bm_pts <- data.frame(item = r$bookmarks, b = 0, judge = judge_names)
      ggp <- ggplot(bm_df, aes(x = item, y = b)) +
        geom_col(fill = "#c7e9c0", colour = "#238b45", width = 0.6) +
        geom_hline(yintercept = r$cut_theta, colour = "#dc322f",
                   linetype = "dashed", linewidth = 0.9) +
        geom_point(data = bm_pts, aes(x = item, y = 0, colour = judge),
                   shape = 17, size = 4) +
        scale_colour_brewer(palette = "Set1", name = "Judge") +
        labs(title = paste0("Bookmark Method (RP = ", r$rp, ")"),
             x = "Item (ordered by difficulty)", y = "Difficulty (b)") +
        theme_minimal(base_size = 11) +
        theme(panel.grid.minor = element_blank(),
              axis.text  = element_text(colour = "#657b83"),
              axis.title = element_text(colour = "#657b83"),
              plot.title = element_text(colour = "#657b83", size = 12),
              legend.title = element_text(colour = "#657b83"),
              legend.text  = element_text(colour = "#657b83"),
              plot.background  = element_rect(fill = "transparent", colour = NA),
              panel.background = element_rect(fill = "transparent", colour = NA))
      print(ggp)
      return(invisible(NULL))
    }
  })



  output$ss_cutscore <- renderPlotly({
    req(ss_result())
    r <- ss_result()

    if (r$method == "Modified Angoff") {
      judges <- paste0("J", seq_along(r$judge_totals))
      hover_txt <- paste0(judges,
                          "<br>Sum of ratings = ", round(r$judge_totals, 2))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = judges, y = r$judge_totals,
          marker = list(color = "#238b45", opacity = 0.7),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE, width = 0.6
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line",
                 x0 = -0.5, x1 = length(r$judge_totals) - 0.5,
                 y0 = r$cut_score, y1 = r$cut_score,
                 line = list(color = "#e31a1c", width = 2, dash = "dash"))
          ),
          xaxis = list(title = "Judge"),
          yaxis = list(title = "Sum of Ratings (Angoff cut score)"),
          annotations = list(
            list(x = length(r$judge_totals) - 1, y = r$cut_score,
                 text = paste0("Cut = ", round(r$cut_score, 1)),
                 showarrow = TRUE, arrowhead = 2,
                 font = list(color = "#e31a1c", size = 12),
                 bgcolor = "#fde0dd", bordercolor = "#e31a1c")
          ),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)

    } else {
      judges <- paste0("J", seq_along(r$judge_thetas))
      hover_txt <- paste0(judges,
                          "<br>\u03b8 at bookmark = ", round(r$judge_thetas, 3))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = judges, y = r$judge_thetas,
          marker = list(color = "#238b45", opacity = 0.7),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE, width = 0.6
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line",
                 x0 = -0.5, x1 = length(r$judge_thetas) - 0.5,
                 y0 = r$cut_theta, y1 = r$cut_theta,
                 line = list(color = "#e31a1c", width = 2, dash = "dash"))
          ),
          xaxis = list(title = "Judge"),
          yaxis = list(title = "\u03b8 at Bookmark"),
          annotations = list(
            list(x = length(r$judge_thetas) - 1, y = r$cut_theta,
                 text = paste0("\u03b8 cut = ", round(r$cut_theta, 2)),
                 showarrow = TRUE, arrowhead = 2,
                 font = list(color = "#e31a1c", size = 12),
                 bgcolor = "#fde0dd", bordercolor = "#e31a1c")
          ),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$ss_score_dist <- renderPlotly({
    req(ss_result())
    r <- ss_result()

    n_exam <- 500
    set.seed(sample.int(10000, 1))
    theta_exam <- rnorm(n_exam, 0, 1)
    scores <- sapply(theta_exam, function(th) {
      p <- 1 / (1 + exp(-r$a * (th - r$b)))
      sum(rbinom(r$n_items, 1, p))
    })

    pass_rate <- round(mean(scores >= r$cut_score) * 100, 1)

    # Build histogram manually for plotly
    brks <- seq(min(scores) - 0.5, max(scores) + 0.5, by = 1)
    h <- hist(scores, breaks = brks, plot = FALSE)

    hover_txt <- paste0("Score: ", h$mids,
                        "<br>Count: ", h$counts)

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = h$mids, y = h$counts,
        marker = list(color = "#238b45", opacity = 0.7,
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE, width = 1
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = r$cut_score, x1 = r$cut_score,
               y0 = 0, y1 = max(h$counts) * 1.05,
               line = list(color = "#e31a1c", width = 2.5, dash = "dash"))
        ),
        xaxis = list(title = "Raw Score"),
        yaxis = list(title = "Count"),
        annotations = list(
          list(x = r$cut_score + 1, y = max(h$counts) * 0.9,
               text = paste0("Cut = ", round(r$cut_score, 1),
                             "<br>Pass rate: ", pass_rate, "%"),
               showarrow = TRUE, arrowhead = 2, ax = 40, ay = -20,
               font = list(color = "#e31a1c", size = 12),
               bgcolor = "#fde0dd", bordercolor = "#e31a1c"),
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Simulated score distribution (n = ", n_exam, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40),
        bargap = 0.05
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Response Times ─────────────────────────────────────────

  rt_data <- reactiveVal(NULL)

  observeEvent(input$rt_gen, {
    set.seed(sample.int(10000, 1))
    N <- input$rt_n_persons
    J <- input$rt_n_items
    tau_sd <- input$rt_tau_sd
    sig_e  <- input$rt_noise
    rho    <- input$rt_speed_acc_corr

    # Item parameters
    beta_rt <- sort(runif(J, 2, 5))       # time intensity (log seconds)
    alpha_rt <- runif(J, 0.5, 1.5)        # time discrimination
    b_irt <- runif(J, -2, 2)              # IRT difficulty
    a_irt <- runif(J, 0.8, 2)            # IRT discrimination

    # Person parameters: theta (ability) and tau (slowness), correlated
    Sigma <- matrix(c(1, rho, rho, tau_sd^2), 2, 2)
    persons <- MASS::mvrnorm(N, mu = c(0, 0), Sigma = Sigma)
    theta <- persons[, 1]
    tau   <- persons[, 2]

    # Generate log-RTs
    log_rt_mat <- matrix(NA, N, J)
    accuracy_mat <- matrix(NA, N, J)
    for (j in seq_len(J)) {
      log_rt_mat[, j] <- beta_rt[j] + tau / alpha_rt[j] + rnorm(N, 0, sig_e)
      p <- 1 / (1 + exp(-a_irt[j] * (theta - b_irt[j])))
      accuracy_mat[, j] <- rbinom(N, 1, p)
    }

    # Long format for plotting
    df_long <- data.frame(
      person = rep(seq_len(N), J),
      item = rep(paste0("Item ", seq_len(J)), each = N),
      log_rt = as.vector(log_rt_mat),
      rt = exp(as.vector(log_rt_mat)),
      correct = as.vector(accuracy_mat)
    )
    df_long$item <- factor(df_long$item, levels = paste0("Item ", seq_len(J)))

    rt_data(list(
      df_long = df_long, theta = theta, tau = tau,
      beta_rt = beta_rt, b_irt = b_irt,
      alpha_rt = alpha_rt, a_irt = a_irt,
      N = N, J = J, rho = rho
    ))
  })

  output$rt_item_dist <- renderPlotly({
    req(rt_data())
    df <- rt_data()$df_long

    items <- levels(df$item)
    cols <- grDevices::hcl.colors(length(items), "viridis")

    p <- plotly::plot_ly()
    for (i in seq_along(items)) {
      sub <- df[df$item == items[i], ]
      p <- p |>
        plotly::add_boxplot(
          y = sub$item, x = sub$log_rt,
          orientation = "h",
          marker = list(color = cols[i], outliercolor = cols[i], size = 3),
          line = list(color = cols[i]),
          fillcolor = scales::alpha(cols[i], 0.5),
          name = items[i], showlegend = FALSE,
          hoverinfo = "x"
        )
    }
    p |> plotly::layout(
      xaxis = list(title = "log(Response Time)"),
      yaxis = list(title = "", autorange = "reversed"),
      margin = list(t = 30)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rt_speed_acc <- renderPlotly({
    req(rt_data())
    r <- rt_data()
    speed <- -r$tau
    obs_r <- round(cor(speed, r$theta), 3)

    hover_txt <- paste0("Speed = ", round(speed, 3),
                        "<br>Ability = ", round(r$theta, 3))

    # OLS fit line
    fit <- lm(r$theta ~ speed)
    xr <- range(speed)
    x_line <- seq(xr[1], xr[2], length.out = 100)
    y_line <- predict(fit, newdata = data.frame(speed = x_line))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = speed, y = r$theta,
        marker = list(color = "#238b45", size = 5, opacity = 0.4,
                      line = list(width = 0)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = x_line, y = y_line,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Speed (\u2212\u03c4, higher = faster)"),
        yaxis = list(title = "Ability (\u03b8)"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("r = ", obs_r, "  (set correlation = ", r$rho, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rt_item_params <- renderPlotly({
    req(rt_data())
    r <- rt_data()
    item_labels <- paste0("Item ", seq_len(r$J))
    obs_r <- round(cor(r$b_irt, r$beta_rt), 3)

    hover_txt <- paste0(item_labels,
                        "<br>Difficulty (b) = ", round(r$b_irt, 3),
                        "<br>Time intensity (\u03b2) = ", round(r$beta_rt, 3))

    # Fit line
    fit <- lm(beta ~ b, data = data.frame(beta = r$beta_rt, b = r$b_irt))
    xr <- range(r$b_irt)
    x_line <- seq(xr[1], xr[2], length.out = 50)
    y_line <- predict(fit, newdata = data.frame(b = x_line))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = r$b_irt, y = r$beta_rt,
        marker = list(color = "#238b45", size = 8,
                      line = list(width = 0.5, color = "#FFFFFF")),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_text(
        x = r$b_irt, y = r$beta_rt,
        text = item_labels,
        textposition = "top center",
        textfont = list(size = 9, color = "#00441b"),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = x_line, y = y_line,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2, dash = "dash"),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "IRT Difficulty (b)"),
        yaxis = list(title = "Time Intensity (\u03b2)"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("r = ", obs_r),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$rt_person_speed <- renderPlotly({
    req(rt_data())
    r <- rt_data()
    tau <- r$tau
    tau_sd <- round(sd(tau), 2)

    # Build histogram manually
    brks <- seq(min(tau) - 0.1, max(tau) + 0.1, length.out = 31)
    h <- hist(tau, breaks = brks, plot = FALSE)

    hover_txt <- paste0("\u03c4 \u2248 ", round(h$mids, 2),
                        "<br>Count: ", h$counts)

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = h$mids, y = h$counts,
        marker = list(color = "#238b45", opacity = 0.7,
                      line = list(color = "white", width = 1)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE, width = diff(brks)[1]
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0, x1 = 0,
               y0 = 0, y1 = max(h$counts) * 1.05,
               line = list(color = "#e31a1c", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Person Slowness (\u03c4)"),
        yaxis = list(title = "Count"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("\u03c4 > 0: slower, \u03c4 < 0: faster  (SD = ", tau_sd, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40),
        bargap = 0.05
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Trend Linking ─────────────────────────────────────────────────────
  tl_data <- reactiveVal(NULL)

  observeEvent(input$tl_run, {
    withProgress(message = "Running test linking...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_cycles  <- input$tl_n_cycles
    n_trend   <- input$tl_n_trend
    drift_sd  <- input$tl_drift
    n_stud    <- input$tl_n_students
    n_uniq    <- 20L

    # True ability drift per cycle (small random trend)
    true_drift <- cumsum(c(0, rnorm(n_cycles - 1, 0, 0.15)))

    # Trend item base difficulties
    b_trend_base <- rnorm(n_trend, 0, 0.8)

    # Per-cycle trend item difficulties (drift added each cycle)
    b_trend_cycle <- lapply(seq_len(n_cycles), function(k) {
      b_trend_base + rnorm(n_trend, 0, drift_sd * (k - 1) / max(1, n_cycles - 1))
    })

    # Simulate cycle data
    cycle_results <- lapply(seq_len(n_cycles), function(k) {
      theta  <- rnorm(n_stud, true_drift[k], 1)
      b_all  <- c(b_trend_cycle[[k]], rnorm(n_uniq, 0, 0.7))
      a_all  <- runif(n_trend + n_uniq, 0.8, 1.8)
      probs  <- outer(theta, b_all, function(th, b) 1 / (1 + exp(-a_all * (th - b))))
      resp   <- matrix(rbinom(length(probs), 1, probs), nrow = n_stud)
      raw    <- rowSums(resp)
      # Anchor b estimates from trend items
      p_anch <- colMeans(resp[, seq_len(n_trend), drop = FALSE])
      b_est  <- log((1 - p_anch + 1e-4) / (p_anch + 1e-4)) / a_all[seq_len(n_trend)]
      list(theta = theta, raw = raw, b_est = b_est, true_mu = true_drift[k])
    })

    # Mean-sigma linking: place each cycle on Cycle 1 scale
    ref_mean <- mean(cycle_results[[1]]$b_est)
    ref_sd   <- sd(cycle_results[[1]]$b_est)

    link_results <- lapply(seq_len(n_cycles), function(k) {
      tgt_mean <- mean(cycle_results[[k]]$b_est)
      tgt_sd   <- sd(cycle_results[[k]]$b_est) + 1e-8
      slope     <- ref_sd / tgt_sd
      intercept <- ref_mean - slope * tgt_mean
      linked_raw <- slope * cycle_results[[k]]$raw + intercept
      se_link <- sqrt(2) * ref_sd / (sqrt(n_trend) * tgt_sd)
      list(raw_mean  = mean(cycle_results[[k]]$raw),
           link_mean = mean(linked_raw),
           slope = slope, intercept = intercept,
           se_link = se_link * sqrt(k))  # accumulates
    })

    tl_data(list(
      n_cycles      = n_cycles,
      n_trend       = n_trend,
      cycle_results = cycle_results,
      b_trend_cycle = b_trend_cycle,
      link_results  = link_results,
      true_drift    = true_drift
    ))
    })
  })

  output$tl_stability_plot <- renderPlotly({
    req(tl_data())
    r <- tl_data()
    p <- plot_ly()
    colors <- grDevices::hcl.colors(r$n_cycles - 1, "Dark2")
    for (k in seq_len(r$n_cycles - 1)) {
      p <- add_trace(p,
        x = r$b_trend_cycle[[k]],
        y = r$b_trend_cycle[[k + 1]],
        type = "scatter", mode = "markers",
        name = paste0("C", k, "\u2192C", k + 1),
        marker = list(color = colors[k], size = 6, opacity = 0.7)
      )
    }
    rng <- range(unlist(r$b_trend_cycle))
    p |> add_trace(
      x = rng, y = rng, type = "scatter", mode = "lines",
      line = list(color = "#dc322f", dash = "dash", width = 1.5),
      name = "No drift", showlegend = TRUE
    ) |> layout(
      xaxis = list(title = "Item difficulty (cycle k)"),
      yaxis = list(title = "Item difficulty (cycle k+1)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.18, yanchor = "top"),
      margin = list(t = 30, b = 60)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$tl_scale_plot <- renderPlotly({
    req(tl_data())
    r <- tl_data()
    cycles <- paste0("C", seq_len(r$n_cycles))
    raw_means  <- sapply(r$link_results, `[[`, "raw_mean")
    link_means <- sapply(r$link_results, `[[`, "link_mean")
    plot_ly() |>
      add_trace(x = cycles, y = raw_means,  type = "scatter", mode = "lines+markers",
                name = "Raw mean",    line = list(color = "#93a1a1", dash = "dash")) |>
      add_trace(x = cycles, y = link_means, type = "scatter", mode = "lines+markers",
                name = "Linked mean", line = list(color = "#268bd2", width = 2.5)) |>
      add_trace(x = cycles, y = r$true_drift, type = "scatter", mode = "lines",
                name = "True \u03bc",
                line = list(color = "#dc322f", dash = "dot", width = 1.5)) |>
      layout(
        xaxis = list(title = "Cycle"),
        yaxis = list(title = "Mean score"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 30, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$tl_error_plot <- renderPlotly({
    req(tl_data())
    r <- tl_data()
    ses <- sapply(r$link_results, `[[`, "se_link")
    cycles <- paste0("C", seq_len(r$n_cycles))
    plot_ly(x = cycles, y = round(ses, 4),
            type = "bar",
            marker = list(color = "#b58900"),
            text = round(ses, 4), textposition = "outside") |>
      layout(
        xaxis = list(title = "Cycle"),
        yaxis = list(title = "Cumulative linking SE"),
        margin = list(t = 30, b = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$tl_summary_table <- renderTable({
    req(tl_data())
    r <- tl_data()
    data.frame(
      Cycle         = paste0("C", seq_len(r$n_cycles)),
      `Trend items` = r$n_trend,
      `Raw mean`    = round(sapply(r$link_results, `[[`, "raw_mean"), 3),
      `Linked mean` = round(sapply(r$link_results, `[[`, "link_mean"), 3),
      `True mu`     = round(r$true_drift, 3),
      Slope         = round(sapply(r$link_results, `[[`, "slope"), 3),
      `Linking SE`  = round(sapply(r$link_results, `[[`, "se_link"), 4),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%", digits = 3)

  # ── MSAT Large-Scale ──────────────────────────────────────────────────
  msat_data <- reactiveVal(NULL)

  observeEvent(input$msat_run, {
    withProgress(message = "Running multistage adaptive test...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_groups   <- input$msat_n_groups
    n_stud     <- input$msat_n_students
    ni         <- input$msat_items_stage
    cut_low    <- input$msat_cut_low
    cut_high   <- input$msat_cut_high

    # Parse group means
    grp_means <- tryCatch(
      as.numeric(strsplit(input$msat_group_means, "[,\\s]+")[[1]]),
      error = function(e) seq(-1, 1, length.out = n_groups)
    )
    grp_means <- grp_means[seq_len(n_groups)]
    if (any(is.na(grp_means))) grp_means <- seq(-1, 1, length.out = n_groups)

    # Item pools: core (medium), low, mid, high
    gen_items <- function(n, mu_b) {
      data.frame(a = runif(n, 0.8, 1.8), b = rnorm(n, mu_b, 0.5))
    }
    core_items <- gen_items(ni, 0)
    low_items  <- gen_items(ni, -1.2)
    mid_items  <- gen_items(ni,  0.0)
    high_items <- gen_items(ni,  1.2)
    fixed_items <- gen_items(ni * 2, 0)  # fixed design: same items for all

    p2pl <- function(theta, a, b) 1 / (1 + exp(-a * (theta - b)))

    grp_results <- lapply(seq_len(n_groups), function(g) {
      theta <- rnorm(n_stud, grp_means[g], 1)

      # --- Adaptive design ---
      # Core stage
      core_p   <- sapply(theta, function(th)
        mean(rbinom(ni, 1, p2pl(th, core_items$a, core_items$b))))
      eap_core <- theta + rnorm(n_stud, 0, 0.3)  # noisy EAP after core

      route <- ifelse(eap_core < cut_low, "Low",
               ifelse(eap_core > cut_high, "High", "Mid"))

      # Stage 2: administer appropriate pool, compute SE
      se_adapt <- sapply(seq_len(n_stud), function(i) {
        pool <- switch(route[i], Low = low_items, High = high_items, mid_items)
        info <- sum(pool$a^2 * p2pl(theta[i], pool$a, pool$b) *
                    (1 - p2pl(theta[i], pool$a, pool$b)))
        1 / sqrt(max(info, 0.01))
      })

      # --- Fixed design ---
      se_fixed <- sapply(theta, function(th) {
        info <- sum(fixed_items$a^2 * p2pl(th, fixed_items$a, fixed_items$b) *
                    (1 - p2pl(th, fixed_items$a, fixed_items$b)))
        1 / sqrt(max(info, 0.01))
      })

      list(theta = theta, route = route,
           se_adapt = se_adapt, se_fixed = se_fixed)
    })

    # TIF over theta grid
    theta_grid <- seq(-3, 3, length.out = 80)
    tif_adapt <- sapply(theta_grid, function(th) {
      # Weighted average TIF: 1/3 each path
      paths <- list(low_items, mid_items, high_items)
      mean(sapply(paths, function(pool)
        sum(pool$a^2 * p2pl(th, pool$a, pool$b) * (1 - p2pl(th, pool$a, pool$b)))))
    })
    tif_fixed <- sapply(theta_grid, function(th)
      sum(fixed_items$a^2 * p2pl(th, fixed_items$a, fixed_items$b) *
          (1 - p2pl(th, fixed_items$a, fixed_items$b))))

    msat_data(list(
      n_groups    = n_groups,
      grp_means   = grp_means,
      grp_results = grp_results,
      theta_grid  = theta_grid,
      tif_adapt   = tif_adapt,
      tif_fixed   = tif_fixed,
      cut_low     = cut_low,
      cut_high    = cut_high
    ))
    })
  })

  output$msat_routing_plot <- renderPlotly({
    req(msat_data())
    r <- msat_data()
    paths <- c("Low", "Mid", "High")
    colors <- c(Low = "#268bd2", Mid = "#2aa198", High = "#b58900")
    p <- plot_ly()
    for (path in paths) {
      pcts <- sapply(r$grp_results, function(g)
        round(100 * mean(g$route == path), 1))
      p <- add_trace(p,
        x = paste0("Group ", seq_len(r$n_groups),
                   " (\u03bc=", round(r$grp_means, 1), ")"),
        y = pcts,
        type = "bar", name = paste(path, "path"),
        marker = list(color = colors[[path]])
      )
    }
    p |> layout(
      barmode = "stack",
      xaxis = list(title = "Group"),
      yaxis = list(title = "% students routed", range = c(0, 100)),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.18, yanchor = "top"),
      margin = list(t = 30, b = 70)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$msat_info_plot <- renderPlotly({
    req(msat_data())
    r <- msat_data()
    plot_ly() |>
      add_trace(x = r$theta_grid, y = r$tif_adapt,
                type = "scatter", mode = "lines",
                name = "Adaptive (MSAT)",
                line = list(color = "#268bd2", width = 2.5)) |>
      add_trace(x = r$theta_grid, y = r$tif_fixed,
                type = "scatter", mode = "lines",
                name = "Fixed design",
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      layout(
        xaxis = list(title = "\u03b8 (ability)"),
        yaxis = list(title = "Test Information"),
        shapes = list(
          list(type = "line", x0 = r$cut_low,  x1 = r$cut_low,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#657b83", dash = "dot", width = 1.5)),
          list(type = "line", x0 = r$cut_high, x1 = r$cut_high,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#657b83", dash = "dot", width = 1.5))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 30, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$msat_se_plot <- renderPlotly({
    req(msat_data())
    r <- msat_data()
    se_adapt <- 1 / sqrt(pmax(r$tif_adapt, 0.01))
    se_fixed <- 1 / sqrt(pmax(r$tif_fixed, 0.01))
    plot_ly() |>
      add_trace(x = r$theta_grid, y = se_adapt,
                type = "scatter", mode = "lines",
                name = "Adaptive (MSAT)",
                line = list(color = "#268bd2", width = 2.5)) |>
      add_trace(x = r$theta_grid, y = se_fixed,
                type = "scatter", mode = "lines",
                name = "Fixed design",
                line = list(color = "#dc322f", dash = "dash", width = 2)) |>
      layout(
        xaxis = list(title = "\u03b8 (ability)"),
        yaxis = list(title = "SE(\u03b8)", rangemode = "tozero"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 30, b = 60)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$msat_summary_table <- renderTable({
    req(msat_data())
    r <- msat_data()
    do.call(rbind, lapply(seq_len(r$n_groups), function(g) {
      res <- r$grp_results[[g]]
      data.frame(
        Group             = paste0("Group ", g),
        `Mean theta`      = round(r$grp_means[g], 2),
        `% Low path`      = paste0(round(100 * mean(res$route == "Low"),  1), "%"),
        `% Mid path`      = paste0(round(100 * mean(res$route == "Mid"),  1), "%"),
        `% High path`     = paste0(round(100 * mean(res$route == "High"), 1), "%"),
        `Mean SE (adapt)` = round(mean(res$se_adapt), 3),
        `Mean SE (fixed)` = round(mean(res$se_fixed), 3),
        check.names = FALSE
      )
    }))
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ── Survey Sampling & Weighting ───────────────────────────────────────
  sw_data <- reactiveVal(NULL)

  observeEvent(input$sw_run, {
    withProgress(message = "Computing survey weights...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    n_pop      <- input$sw_n_pop
    n_strata   <- input$sw_n_strata
    n_clusters <- input$sw_n_clusters
    clust_size <- input$sw_cluster_size
    design     <- input$sw_design

    # Generate population in strata
    strata_sizes <- round(rep(n_pop / n_strata, n_strata) +
                          rnorm(n_strata, 0, n_pop / n_strata * 0.1))
    strata_means <- seq(-0.8, 0.8, length.out = n_strata)

    pop <- do.call(rbind, lapply(seq_len(n_strata), function(s) {
      ns <- strata_sizes[s]
      # Schools within stratum
      n_schools_s <- max(3L, round(n_clusters / n_strata))
      school_effect <- rnorm(n_schools_s, strata_means[s], 0.4)
      # Size–ability correlation: larger schools tend to have higher ability.
      # This makes PPS sampling introduce systematic bias that weighting corrects.
      school_sizes <- pmax(10, round(rlnorm(
        n_schools_s,
        meanlog = log(ns / n_schools_s) + 0.45 * school_effect,
        sdlog   = 0.35
      )))
      school_sizes <- round(school_sizes * (ns / sum(school_sizes)))
      do.call(rbind, lapply(seq_len(n_schools_s), function(sch) {
        n_sch <- max(1, school_sizes[sch])
        data.frame(
          stratum = s,
          school  = paste0(s, "_", sch),
          size    = n_sch,
          ability = rnorm(n_sch, school_effect[sch], 0.8)
        )
      }))
    }))

    true_mean <- mean(pop$ability)
    true_sd   <- sd(pop$ability)

    # Helper: sample one design and return results
    sample_design <- function(des) {
      if (des == "Simple Random (SRS)") {
        n_samp <- min(nrow(pop), n_clusters * clust_size)
        idx <- sample(nrow(pop), n_samp)
        samp <- pop[idx, ]
        samp$weight <- nrow(pop) / n_samp
      } else if (des == "Stratified") {
        n_per_s <- max(5L, round(n_clusters * clust_size / n_strata))
        samp <- do.call(rbind, lapply(seq_len(n_strata), function(s) {
          sub <- pop[pop$stratum == s, ]
          idx <- sample(nrow(sub), min(n_per_s, nrow(sub)))
          s_samp <- sub[idx, ]
          s_samp$weight <- nrow(sub) / nrow(s_samp)
          s_samp
        }))
      } else if (des == "Cluster (PPS)") {
        schools <- unique(pop[, c("school", "size")])
        prob <- schools$size / sum(schools$size)
        sel <- sample(nrow(schools), min(n_clusters, nrow(schools)),
                      prob = prob, replace = FALSE)
        sel_schools <- schools$school[sel]
        samp <- pop[pop$school %in% sel_schools, ]
        samp_n <- nrow(samp)
        # Weight = inverse inclusion prob (approx)
        samp$weight <- sapply(samp$school, function(sch) {
          sch_size <- schools$size[schools$school == sch]
          1 / (min(n_clusters, nrow(schools)) * sch_size / sum(schools$size))
        })
      } else {
        # Two-Stage (PPS + within)
        schools <- unique(pop[, c("school", "size")])
        prob <- schools$size / sum(schools$size)
        n_sel_sch <- min(n_clusters, nrow(schools))
        sel <- sample(nrow(schools), n_sel_sch, prob = prob, replace = FALSE)
        sel_schools <- schools$school[sel]
        samp <- do.call(rbind, lapply(sel_schools, function(sch) {
          sub <- pop[pop$school == sch, ]
          n_take <- min(clust_size, nrow(sub))
          idx <- sample(nrow(sub), n_take)
          s_samp <- sub[idx, ]
          pi_sch  <- n_sel_sch * sub$size[1] / sum(schools$size)
          pi_stud <- n_take / nrow(sub)
          s_samp$weight <- 1 / (pi_sch * pi_stud)
          s_samp
        }))
      }
      # Normalize weights so they sum to population size
      samp$weight <- samp$weight * n_pop / sum(samp$weight)

      unw_mean <- mean(samp$ability)
      wt_mean  <- weighted.mean(samp$ability, samp$weight)
      se_wt    <- sqrt(wtd_var(samp$ability, samp$weight) / nrow(samp))

      # DEFF via ICC: DEFF = 1 + (b_bar - 1) * ICC
      # where ICC is estimated from the cluster (school) structure of the sample
      school_ids  <- samp$school
      n_groups    <- length(unique(school_ids))
      n_total     <- nrow(samp)
      n_per_sch   <- as.integer(table(school_ids))
      sch_means   <- tapply(samp$ability, school_ids, mean)
      grand_mean  <- mean(samp$ability)
      ss_between  <- sum(n_per_sch * (sch_means - grand_mean)^2)
      ss_within   <- sum(samp$ability^2) - sum(n_per_sch * sch_means^2)

      deff <- if (n_groups <= 1 || n_total <= n_groups || ss_within <= 0) {
        1
      } else {
        ms_between <- ss_between / (n_groups - 1)
        ms_within  <- ss_within  / (n_total  - n_groups)
        n_bar <- (n_total - sum(n_per_sch^2) / n_total) / (n_groups - 1)
        icc   <- (ms_between - ms_within) /
                 (ms_between + (n_bar - 1) * ms_within)
        icc   <- max(-1 / max(1, n_bar - 1), min(1, icc))
        max(0.1, 1 + (mean(n_per_sch) - 1) * icc)
      }

      list(samp = samp, unw_mean = unw_mean, wt_mean = wt_mean,
           se_wt = se_wt, deff = deff, n = nrow(samp))
    }

    # Weighted variance helper
    wtd_var <- function(x, w) {
      w  <- w / sum(w)
      mu <- sum(w * x)
      sum(w * (x - mu)^2)
    }

    main_result <- sample_design(design)

    # All four designs for comparison table
    all_designs <- c("Simple Random (SRS)", "Stratified",
                     "Cluster (PPS)", "Two-Stage (PPS + within)")
    comparison <- lapply(all_designs, sample_design)
    names(comparison) <- all_designs

    sw_data(list(
      pop         = pop,
      true_mean   = true_mean,
      true_sd     = true_sd,
      design      = design,
      main        = main_result,
      comparison  = comparison,
      wtd_var     = wtd_var
    ))
    })
  })

  output$sw_dist_plot <- renderPlotly({
    req(sw_data())
    r    <- sw_data()
    samp <- r$main$samp
    pop  <- r$pop

    # Common bin grid so all three traces are directly comparable
    x_all <- c(pop$ability, samp$ability)
    brks  <- seq(min(x_all) - 0.15, max(x_all) + 0.15, length.out = 41)
    bw    <- diff(brks)[1]
    mids  <- (brks[-length(brks)] + brks[-1]) / 2

    bin_pop  <- cut(pop$ability,  brks, include.lowest = TRUE)
    bin_samp <- cut(samp$ability, brks, include.lowest = TRUE)

    # Density = count / (n * bin_width)  →  area integrates to 1
    pop_dens <- as.numeric(table(bin_pop))  / (nrow(pop)  * bw)
    unw_dens <- as.numeric(table(bin_samp)) / (nrow(samp) * bw)

    # Weighted density: sum weights per bin, normalise by total weight * bw
    wt_sums <- numeric(length(mids))
    bin_idx  <- as.integer(bin_samp)
    for (j in seq_along(bin_idx)) {
      if (!is.na(bin_idx[j]))
        wt_sums[bin_idx[j]] <- wt_sums[bin_idx[j]] + samp$weight[j]
    }
    wt_dens <- wt_sums / (sum(samp$weight) * bw)

    plot_ly() |>
      add_bars(x = mids, y = pop_dens,
               name = "Population",
               width = bw * 0.96,
               marker = list(color = "#eee8d5", line = list(color = "#93a1a1", width = 0.5)),
               opacity = 0.7, hoverinfo = "none") |>
      add_bars(x = mids, y = unw_dens,
               name = "Unweighted sample",
               width = bw * 0.96,
               marker = list(color = "#dc322f"),
               opacity = 0.6, hoverinfo = "none") |>
      add_bars(x = mids, y = wt_dens,
               name = "Weighted sample",
               width = bw * 0.96,
               marker = list(color = "#268bd2"),
               opacity = 0.6, hoverinfo = "none") |>
      layout(
        barmode = "overlay",
        xaxis = list(title = "Ability (\u03b8)"),
        yaxis = list(title = "Density  (area = 1 for each series)"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 30, b = 70)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$sw_weight_plot <- renderPlotly({
    req(sw_data())
    r <- sw_data()
    w <- r$main$samp$weight
    cv_w <- round(sd(w) / mean(w), 3)
    plot_ly(x = w, type = "histogram",
            marker = list(color = "#2aa198"),
            nbinsx = 30) |>
      layout(
        xaxis = list(title = "Sampling weight"),
        yaxis = list(title = "Count"),
        annotations = list(list(
          x = 0.97, y = 0.97, xref = "paper", yref = "paper",
          text = paste0("Min: ", round(min(w), 1),
                        "  Max: ", round(max(w), 1),
                        "  CV: ", cv_w),
          showarrow = FALSE, bgcolor = "rgba(255,255,255,0.7)",
          font = list(size = 12)
        )),
        margin = list(t = 30, b = 50)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$sw_deff_plot <- renderPlotly({
    req(sw_data())
    r <- sw_data()
    des_names  <- names(r$comparison)
    deff_vals  <- sapply(r$comparison, `[[`, "deff")
    bar_colors <- ifelse(deff_vals > 1, "#dc322f", "#2aa198")
    plot_ly(x = des_names, y = round(deff_vals, 3),
            type = "bar",
            marker = list(color = bar_colors),
            text = round(deff_vals, 3), textposition = "outside") |>
      layout(
        xaxis = list(title = "", tickangle = -20),
        yaxis = list(title = "DEFF  (> 1 = less efficient than SRS)",
                     rangemode = "tozero"),
        shapes = list(list(
          type = "line", x0 = 0, x1 = 1, xref = "paper",
          y0 = 1, y1 = 1,
          line = list(color = "#657b83", dash = "dash", width = 1.5)
        )),
        margin = list(t = 30, b = 100)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$sw_summary_table <- renderTable({
    req(sw_data())
    r <- sw_data()
    do.call(rbind, lapply(names(r$comparison), function(des) {
      res <- r$comparison[[des]]
      ci_lo <- round(res$wt_mean - 1.96 * res$se_wt, 3)
      ci_hi <- round(res$wt_mean + 1.96 * res$se_wt, 3)
      data.frame(
        Design         = des,
        n              = res$n,
        `Est. mean`    = round(res$wt_mean, 3),
        SE             = round(res$se_wt, 4),
        `95% CI`       = paste0("[", ci_lo, ", ", ci_hi, "]"),
        DEFF           = round(res$deff, 3),
        `Effective n`  = round(res$n / max(0.1, res$deff)),
        check.names = FALSE
      )
    }))
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load


  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Large-Scale Assessment", list(be_data, ms_data, pv_result, jk_result, brr_result, ss_result, rt_data, tl_data, msat_data, sw_data))
  })
}
