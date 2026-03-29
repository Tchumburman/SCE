# ===========================================================================
# Statistical Concepts Explorer — Modular version
# All module files in R/ are sourced automatically by Shiny.
# ===========================================================================

# Packages are loaded in global.R (before R/ modules are sourced)

# ---------------------------------------------------------------------------
# Welcome page (kept here because it wires into the main navbar)
# ---------------------------------------------------------------------------
welcome_ui <- nav_panel_hidden(
  value = "Welcome",
  class = "p-4",
  div(
    style = "max-width: 850px; margin: auto;",
    div(
      style = "text-align: center; margin-bottom: 1.5rem;",
      tags$img(src = "logo.png", height = "120px",
               style = "border-radius: 12px; margin-bottom: 0.75rem;"),
      tags$h2("Statistical Concepts Explorer", class = "mb-1"),
      tags$p(class = "text-muted", style = "font-size: 0.9rem;",
        "\u00a9 Psycholo.ge \u2014 Everything About Psychology")
    ),
    tags$p(class = "lead",
      "An interactive tool for building intuition about core ideas in
       statistics. Click a group below to see what's inside, or use
       the navigation bar above to jump directly to any concept."
    ),
    tags$hr(),
    accordion(
      id = "welcome_groups", open = FALSE, multiple = TRUE,

      # --- General Concepts ---
      accordion_panel(
        title = tagList(icon("lightbulb"), tags$strong(" General Concepts")),
        value = "general",
        tags$p(class = "text-muted mb-3",
          "Cross-cutting statistical concepts that are important across all domains."),
        layout_column_wrap(width = 1 / 2,
          nav_card("eye-slash", "Data Quality",
            "Missing data mechanisms (MCAR/MAR/MNAR), outlier detection, and censored data handling.",
            "Data Quality"),
          nav_card("fill-drip", "Multiple Imputation",
            "MCAR/MAR/MNAR mechanisms, MICE process with convergence diagnostics, Rubin\u2019s pooling rules, and imputation quality checks.",
            "Multiple Imputation"),
          nav_card("arrows-split-up-and-left", "Statistical Phenomena",
            "Simpson's paradox, regression to the mean, and causal inference with propensity scores.",
            "Statistical Phenomena"),
          nav_card("wand-magic-sparkles", "Data Preparation",
            "Data transformations (log, sqrt, Box-Cox) and time series decomposition.",
            "Data Preparation"),
          nav_card("palette", "Visualization Principles",
            "Chart chooser, perceptual ranking (Cleveland & McGill), misleading graph techniques, and best practices.",
            "Visualization Principles"),
          nav_card("chess", "Game Theory",
            "Classic 2\u00d72 games, Nash equilibrium, iterated PD, evolutionary dynamics, TSP, stable matching, university admission, and exam timetabling (graph colouring).",
            "Game Theory"),
          nav_card("infinity", "Information Theory",
            "Shannon entropy, KL divergence, mutual information, and cross-entropy loss \u2014 the information-theoretic foundations of statistics and ML.",
            "Information Theory"),
          nav_card("satellite-dish", "Signal Detection Theory",
            "d', criterion, hit/false-alarm rates, ROC curves, response bias (\u03b2 and c), and why d' beats percent correct.",
            "Signal Detection Theory"),
          nav_card("users-between-lines", "Interrater Reliability",
            "Cohen's \u03ba, weighted \u03ba, and the prevalence paradox \u2014 how to measure agreement between raters correctly.",
            "Interrater Reliability"),
          nav_card("file-word", "Text Analysis",
            "Word clouds, n-gram phrase analysis, readability metrics (Flesch, FK Grade, Gunning Fog), concordance (KWIC), and lexicon-based sentiment analysis (Bing & AFINN).",
            "Text Analysis")
        )
      ),

      # --- Distributions ---
      accordion_panel(
        title = tagList(icon("chart-area"), tags$strong(" Distributions")),
        value = "distributions",
        tags$p(class = "text-muted mb-3",
          "Explore the shape and properties of probability distributions,
           and see how the Central Limit Theorem connects them all."),
        layout_column_wrap(width = 1 / 2,
          nav_card("chart-area", "Distribution Shapes",
            "Normal distribution, t/F/Chi-Square/Binomial/Poisson, and QQ plots for normality assessment.",
            "Distribution Shapes"),
          nav_card("layer-group", "Sampling Theorems",
            "Central Limit Theorem and Law of Large Numbers \u2014 watch convergence in action.",
            "Sampling Theorems"),
          nav_card("list-ol", "Data Summary",
            "Descriptive statistics (mean, median, SD, skewness) and probability (Bayes' rule, birthday problem).",
            "Data Summary")
        )
      ),

      # --- Sampling ---
      accordion_panel(
        title = tagList(icon("object-group"), tags$strong(" Sampling & Design")),
        value = "sampling",
        tags$p(class = "text-muted mb-3",
          "Understand how samples are drawn from populations, how experiments are designed,
           and how design choices affect statistical power."),
        layout_column_wrap(width = 1 / 2,
          nav_card("object-group", "Sampling",
            "Sample size effects, sampling methods (SRS, stratified, cluster), and sample size calculators.",
            "Sampling"),
          nav_card("flask", "Experimental Design",
            "Randomisation methods, factorial designs with interactions, blocking, repeated measures, and design comparison.",
            "Experimental Design"),
          nav_card("clipboard-list", "Survey Methodology",
            "Sampling designs (SRS, stratified, cluster), design effects, survey weighting, and complex survey SEs.",
            "Survey Methodology"),
          nav_card("flask", "Clinical Trials",
            "Randomisation methods, blinding & bias domains, adaptive designs (SSR, RAR), and CONSORT reporting flow.",
            "Clinical Trials")
        )
      ),

      # --- Inference ---
      accordion_panel(
        title = tagList(icon("scale-balanced"), tags$strong(" Inference")),
        value = "inference",
        tags$p(class = "text-muted mb-3",
          "Learn how to draw conclusions about populations from samples \u2014 confidence intervals,
           hypothesis tests, and Bayesian updating."),
        layout_column_wrap(width = 1 / 2,
          nav_card("not-equal", "Mean Comparisons",
            "T-test, ANOVA, repeated measures, ANCOVA, and MANOVA for comparing group means.",
            "Mean Comparisons"),
          nav_card("arrows-left-right", "Confidence & Resampling",
            "CI coverage simulation and bootstrapping for standard errors and confidence intervals.",
            "Confidence & Resampling"),
          nav_card("table-cells", "Categorical & Association",
            "Chi-square tests, correlation (Pearson/Spearman/Kendall), and goodness-of-fit tests.",
            "Categorical & Association"),
          nav_card("chart-pie", "Bayesian & Power",
            "Beta-Binomial Bayesian updating and power analysis with null vs. alternative distributions.",
            "Bayesian & Power"),
          nav_card("clone", "Corrections & Robustness",
            "Multiple comparison corrections, nonparametric tests, and effect size visualization.",
            "Corrections & Robustness"),
          nav_card("heart-pulse", "Specialized Inference",
            "Survival analysis (Kaplan-Meier, Cox) and meta-analysis (forest plots, I\u00b2).",
            "Specialized Inference"),
          nav_card("triangle-exclamation", "Assumption Violations",
            "See how violating normality, equal variance, independence, and linearity affects test validity. Compare robust alternatives.",
            "Assumption Violations"),
          nav_card("scale-unbalanced", "Causal Inference",
            "DAGs & confounding, propensity score matching, DiD, regression discontinuity, instrumental variables, and sensitivity analysis (E-values, fragility index).",
            "Causal Inference"),
          nav_card("ruler-combined", "Effect Size Explorer",
            "Convert between d/r/OR/\u03b7\u00b2, visualize overlap, and calculate Number Needed to Treat.",
            "Effect Size Explorer"),
          nav_card("dice", "Monte Carlo & Simulation",
            "Permutation tests, p-value behaviour, Monte Carlo estimation (\u03c0, integrals), and power simulation.",
            "Monte Carlo & Simulation"),
          nav_card("chart-pie", "Bayesian Workflow",
            "Prior sensitivity, MCMC intuition (Metropolis-Hastings), posterior predictive checks, credible vs. confidence intervals, and Bayesian model comparison (Bayes factors, LOO-CV, WAIC).",
            "Bayesian Workflow"),
          nav_card("wand-magic-sparkles", "p-Hacking Simulator",
            "Garden of forking paths, many-analysts simulation, and p-curve diagnostics. See how analytic flexibility inflates false positives.",
            "p-Hacking Simulator"),
          nav_card("forward", "Sequential Testing",
            "Wald SPRT, group-sequential designs with O\u2019Brien-Fleming/Pocock boundaries, alpha-spending, and always-valid e-value tests.",
            "Sequential Testing"),
          nav_card("bolt", "Power: Complex Designs",
            "Power for clustered/multilevel designs, mediation indirect effects, interaction tests, and longitudinal growth curves.",
            "Power: Complex Designs"),
          nav_card("unlock", "Replication & Open Science",
            "Replication crisis, pre-registration vs. HARKing, publication bias & funnel plots, R-Index, and excess significance tests.",
            "Replication & Open Science"),
          nav_card("circle-exclamation", "Type I & II Errors",
            "Visualize \u03b1 (Type I), \u03b2 (Type II), and power as overlapping distributions. Explore power curves and the 2\u00d72 decision table with false discovery rates.",
            "Type I & II Errors")
        )
      ),

      # --- Modeling ---
      accordion_panel(
        title = tagList(icon("chart-line"), tags$strong(" Modeling")),
        value = "modeling",
        tags$p(class = "text-muted mb-3",
          "Fit models to data \u2014 from ordinary least squares through generalized linear models
           and maximum likelihood estimation."),
        layout_column_wrap(width = 1 / 2,
          nav_card("chart-line", "Regression Core",
            "OLS, GLM (logistic/Poisson), Bayesian regression, and maximum likelihood estimation.",
            "Regression Core"),
          nav_card("triangle-exclamation", "Model Diagnostics",
            "Assumption violations (non-linearity, heteroscedasticity) and regularization (Ridge/Lasso/Elastic Net).",
            "Model Diagnostics"),
          nav_card("sitemap", "Multilevel Models",
            "Random intercepts/slopes, ICC & variance components, growth curves, three-level models, and model comparison.",
            "Multilevel Models"),
          nav_card("layer-group", "Extended Models",
            "Mixed/multilevel models, robust regression, and multinomial/ordinal regression.",
            "Extended Models"),
          nav_card("arrows-split-up-and-left", "Mediation & Moderation",
            "Indirect effects, simple slopes, Johnson-Neyman intervals, and moderated mediation.",
            "Mediation & Moderation"),
          nav_card("chart-line", "Time Series",
            "Autocorrelation & stationarity, decomposition (STL), ARIMA modeling, and forecasting with accuracy evaluation.",
            "Time Series"),
          nav_card("hashtag", "Count Data Models",
            "Poisson & negative binomial regression, zero-inflated models (ZIP/ZINB), hurdle models, and cross-model comparison.",
            "Count Data Models"),
          nav_card("wave-square", "GAMs",
            "Penalised regression splines, basis functions, GAM vs. linear regression, and multiple smooth terms.",
            "GAMs"),
          nav_card("chart-bar", "Quantile Regression",
            "Conditional quantile estimation, the pinball loss function, heterogeneous effects, and the quantile process plot.",
            "Quantile Regression"),
          nav_card("people-arrows", "GEE",
            "Population-averaged models for clustered data, working correlation structures, sandwich SEs, and GEE vs. mixed model comparison.",
            "GEE")
        )
      ),

      # --- Multivariate ---
      accordion_panel(
        title = tagList(icon("project-diagram"), tags$strong(" Multivariate")),
        value = "multivariate",
        tags$p(class = "text-muted mb-3",
          "Explore techniques for data with many variables \u2014 factor analysis, clustering,
           and structural equation modeling."),
        layout_column_wrap(width = 1 / 2,
          nav_card("project-diagram", "Dimension Reduction",
            "Factor Analysis/PCA, multidimensional scaling, and correspondence analysis.",
            "Dimension Reduction"),
          nav_card("circle-nodes", "Clustering & Classification",
            "Cluster validation (elbow/silhouette/gap), hierarchical clustering, and discriminant analysis.",
            "Clustering & Classification"),
          nav_card("diagram-project", "Structural Models",
            "SEM with path diagrams and fit indices, plus network analysis with centrality measures.",
            "Structural Models"),
          nav_card("object-ungroup", "Latent Class Analysis",
            "LCA basics with EM visualisation, model selection (BIC/AIC/entropy), Gaussian mixture models, and LCA vs. k-means comparison.",
            "Latent Class Analysis"),
          nav_card("chart-line", "Growth Mixture Models",
            "Trajectory class simulation, class-varying growth patterns, and BIC/entropy-based model selection.",
            "Growth Mixture Models")
        )
      ),

      # --- Machine Learning ---
      accordion_panel(
        title = tagList(icon("robot"), tags$strong(" Machine Learning")),
        value = "ml",
        tags$p(class = "text-muted mb-3",
          "Visualize how different algorithms learn decision boundaries and cluster data in two dimensions."),
        layout_column_wrap(width = 1 / 2,
          nav_card("robot", "ML Algorithms",
            "Decision trees, random forests, KNN, SVM, neural networks, K-means, and architecture diagrams.",
            "Machine Learning"),
          nav_card("chart-area", "Model Evaluation",
            "Bias-variance tradeoff, cross-validation, ROC/PR curves, and gradient descent optimization.",
            "Model Evaluation"),
          nav_card("microchip", "AI & LLMs",
            "Tokenisation, self-attention, temperature & sampling, and neural network training — step inside how modern AI actually works.",
            "AI & LLMs")
        )
      ),

      # --- Psychometrics ---
      accordion_panel(
        title = tagList(icon("brain"), tags$strong(" Psychometrics")),
        value = "psychometrics",
        tags$p(class = "text-muted mb-3",
          "Comprehensive tools for educational and psychological measurement \u2014 from
           classical test theory through modern IRT, adaptive testing, and validity analysis."),
        layout_column_wrap(width = 1 / 2,
          nav_card("wave-square", "IRT Models",
            "Unidimensional (1/2/3PL), polytomous (GRM/PCM/RSM), multidimensional, nominal response, Bayesian IRT, empirical item fit diagnostics, and 1PL vs 2PL vs 3PL model comparison.", "IRT Models"),
          nav_card("stairs", "Rasch Family",
            "Rasch model with Wright maps, Many-Facet Rasch for rater effects, testlet models, and Guttman Scalogram.", "Rasch Family"),
          nav_card("microscope", "Test & Item Quality",
            "Item analysis, reliability (\u03b1/\u03c9), dimensionality, scale development, and test-retest/alternate-forms reliability.", "Test & Item Quality"),
          nav_card("ruler-combined", "Scoring & Reporting",
            "CTT scaling, score conversions (z/T/percentile), SEM comparison (CTT vs IRT), classification, and IRT scoring methods (MLE vs WLE vs EAP).", "Scoring & Reporting"),
          nav_card("scale-balanced", "Fairness & Bias",
            "DIF detection, prediction bias (Cleary model), person fit statistics, item parameter drift, and Differential Test Functioning (DTF).", "Fairness & Bias"),
          nav_card("link", "Equating & Linking",
            "Linear/equipercentile equating, IRT linking (Mean/Sigma, Stocking-Lord), vertical scaling, and concordance tables with SEE.", "Equating & Linking"),
          nav_card("robot", "Adaptive Testing",
            "CAT simulation, computerized classification testing (SPRT), and automated test assembly.", "Adaptive Testing"),
          nav_card("check-double", "Validity & Measurement",
            "MTMM validity evidence, CFA with measurement invariance, criterion validity with ROC analysis, and formative vs. reflective models.", "Validity & Measurement"),
          nav_card("brain", "Advanced Models",
            "Cognitive diagnostic (DINA), generalizability theory, and automatic item generation.", "Advanced Models"),
          nav_card("dice-d20", "Large-Scale Assessment",
            "Plausible values/JK/BRR, standard setting (Angoff/Bookmark), response time modeling, booklet equating, trend linking across cycles, adaptive design (MSAT) at population level, and survey sampling & weighting.", "Large-Scale Assessment")
        )
      ),

    ),
    tags$hr(),
    # Quiz card
    card(
      class = "border-info mb-3 nav-card-hover",
      style = "cursor: pointer;",
      onclick = "Shiny.setInputValue('go_to_page', 'Quiz', {priority: 'event'});",
      card_body(
        class = "d-flex align-items-center gap-3 py-3",
        div(icon("spell-check", class = "fa-2x text-info")),
        div(
          tags$h5(class = "mb-1", "Test Your Knowledge"),
          tags$p(class = "mb-0 text-muted",
            "Take a quiz with randomized questions spanning all topics. Great for review and self-assessment.")
        ),
        div(class = "ms-auto", icon("arrow-right", class = "text-info fa-lg"))
      )
    ),
    # "Not sure which test?" card — opens modal
    card(
      class = "border-success mb-4 nav-card-hover",
      style = "cursor: pointer;",
      onclick = "document.getElementById('ts_open').click();",
      card_body(
        class = "d-flex align-items-center gap-3 py-3",
        div(icon("signs-post", class = "fa-2x text-success")),
        div(
          tags$h5(class = "mb-1", "Not sure which test to use?"),
          tags$p(class = "mb-0 text-muted",
            "Answer a few questions about your data and design, and we'll recommend the right method.")
        ),
        div(class = "ms-auto", icon("arrow-right", class = "text-success fa-lg"))
      )
    ),
    tags$hr(),
    div(
      style = "text-align: center; padding: 1rem 0; color: #6c757d; font-size: 0.85rem;",
      tags$img(src = "logo.png", height = "40px",
               style = "border-radius: 6px; vertical-align: middle; margin-right: 8px;"),
      "Developed by ",
      tags$a(href = "https://psycholo.ge", target = "_blank",
             style = "color: #268bd2; font-weight: 600; text-decoration: none;",
             "Psycholo.ge"),
      " \u2014 Everything About Psychology"
    )
  )
)

# ---------------------------------------------------------------------------
# Assemble UI
# ---------------------------------------------------------------------------
ui <- page_navbar(
  id = "main_nav",
  title = tags$a(
    icon("house"),
    href = "#",
    style = "text-decoration: none; color: inherit; cursor: pointer; font-size: 1.3rem;",
    onclick = "Shiny.setInputValue('go_to_page', 'Welcome', {priority: 'event'}); window.scrollTo(0, 0); return false;"
  ),
  theme = theme_app,
  fillable = FALSE,
  header = tagList(
    tags$head(
      tags$link(rel = "stylesheet", href = "style.css"),
      tags$script(src = "app.js")
    ),
  div(class = "guided-mode-banner",
    icon("graduation-cap"),
    " Guided Learning Mode — Explanations are expanded automatically. Click the ",
    icon("graduation-cap"),
    " icon to turn off."
  )
  ),
  welcome_ui,
  nav_menu("General", icon = icon("lightbulb"),
    data_quality_ui("data_quality"), phenomena_ui("phenomena"), data_prep_ui("data_prep"),
    dataviz_ui("dataviz"), game_theory_ui("game_theory"), information_theory_ui("information_theory"), mice_ui("mice"), sdt_ui("sdt"),
    interrater_ui("interrater"), qualitative_ui("qualitative")),
  nav_menu("Distributions", icon = icon("chart-area"),
    distribution_shapes_ui("distribution_shapes"), sampling_theorems_ui("sampling_theorems"), data_summary_ui("data_summary")),
  nav_menu("Sampling & Design", icon = icon("object-group"),
    sampling_ui("sampling"), experimental_design_ui("experimental_design"), survey_ui("survey"), clinical_trials_ui("clinical_trials")),
  nav_menu("Inference", icon = icon("scale-balanced"),
    mean_comparisons_ui("mean_comparisons"), ci_resampling_ui("ci_resampling"), categorical_assoc_ui("categorical_assoc"),
    bayes_power_ui("bayes_power"), corrections_ui("corrections"), specialized_inference_ui("specialized_inference"),
    assumption_violations_ui("assumption_violations"), causal_inference_ui("causal_inference"), effect_size_ui("effect_size"),
    monte_carlo_ui("monte_carlo"), bayesian_workflow_ui("bayesian_workflow"), phacking_ui("phacking"),
    sequential_testing_ui("sequential_testing"), complex_power_ui("complex_power"), open_science_ui("open_science"),
    type12_error_ui("type12_error")),
  nav_menu("Modeling", icon = icon("chart-line"),
    regression_core_ui("regression_core"), diagnostics_ui("diagnostics"), multilevel_ui("multilevel"), extended_models_ui("extended_models"),
    mediation_moderation_ui("mediation_moderation"), time_series_ui("time_series"), count_models_ui("count_models"), gam_ui("gam"),
    quantile_reg_ui("quantile_reg"), gee_ui("gee")),
  nav_menu("Multivariate", icon = icon("project-diagram"),
    dim_reduction_ui("dim_reduction"), clustering_ui("clustering"), structural_ui("structural"), lca_ui("lca"),
    growth_mixture_ui("growth_mixture")),
  nav_menu("Machine Learning", icon = icon("robot"),
    ml_ui("ml"), ml_evaluation_ui("ml_evaluation"), ai_models_ui("ai_models")),
  nav_menu("Psychometrics", icon = icon("brain"),
    irt_models_ui("irt_models"), rasch_family_ui("rasch_family"), test_quality_ui("test_quality"), scoring_ui("scoring"),
    mod_fairness_ui("mod_fairness"), mod_equating_linking_ui("mod_equating_linking"), mod_adaptive_ui("mod_adaptive"),
    mod_validity_meas_ui("mod_validity_meas"), mod_advanced_psych_ui("mod_advanced_psych"), mod_large_scale_ui("mod_large_scale")),
  user_data_ui("user_data"),
  references_ui("references"),
  quiz_ui("quiz"),
  nav_item(
    actionButton(
      "quiz_open", label = NULL,
      icon = icon("spell-check"),
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "Knowledge Check Quiz"
    )
  ),
  nav_item(
    actionButton(
      "ud_open", label = NULL,
      icon = icon("upload"),
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "Upload & explore your data"
    )
  ),
  nav_item(
    actionButton(
      "ts_open", label = NULL,
      icon = icon("signs-post"),
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "What Test Should I Use?"
    )
  ),
  nav_item(
    actionButton(
      "refs_open", label = NULL,
      icon = icon("book"),
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "References"
    )
  ),
  nav_item(
    tags$button(
      id = "guided_toggle", type = "button",
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "Toggle guided learning mode",
      onclick = "
        var on = document.body.classList.toggle('guided-mode');
        this.innerHTML = on
          ? '<i class=\"fa fa-graduation-cap text-success\"></i>'
          : '<i class=\"fa fa-graduation-cap\"></i>';
        Shiny.setInputValue('guided_mode', on, {priority: 'event'});
        // Open or collapse all explanation accordions
        document.querySelectorAll('.border-info .accordion-collapse').forEach(function(el) {
          var bsCollapse = bootstrap.Collapse.getOrCreateInstance(el, {toggle: false});
          if (on) { bsCollapse.show(); } else { bsCollapse.hide(); }
        });
      ",
      tags$i(class = "fa fa-graduation-cap")
    )
  ),
  nav_item(
    tags$button(
      id = "dark_toggle", type = "button",
      class = "btn btn-link nav-link p-1",
      style = "font-size: 1.25rem; text-decoration: none;",
      title = "Toggle dark mode",
      onclick = "
        var html = document.documentElement;
        var dark = html.getAttribute('data-bs-theme') === 'dark';
        html.setAttribute('data-bs-theme', dark ? 'light' : 'dark');
        this.innerHTML = dark ? '<i class=\"fa fa-moon\"></i>' : '<i class=\"fa fa-sun\"></i>';
        Shiny.setInputValue('dark_mode', !dark, {priority: 'event'});
      ",
      tags$i(class = "fa fa-moon")
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
server <- function(input, output, session) {


  # Share dark mode state with all modules via session$userData
  observe({ session$userData$dark_mode <- isTRUE(input$dark_mode) })

  # Broadcast active module for memory reclamation
  observe({ session$userData$active_module <- input$main_nav })

  # Navigate to a page when a welcome card is clicked
  observeEvent(input$go_to_page, {
    nav_select("main_nav", input$go_to_page)
  })

  # --- Navigation helpers for hidden panels ---
  observeEvent(input$quiz_open,  nav_select("main_nav", "Quiz"))
  observeEvent(input$ud_open,    nav_select("main_nav", "Your Data"))
  observeEvent(input$refs_open,  nav_select("main_nav", "References"))

  # Test Selector (modal — always available)
  observeEvent(input$ts_open, {
    showModal(modalDialog(
      test_selector_ui("test_selector"),
      title = NULL,
      size = "xl",
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  test_selector_server("test_selector", session)

  # --- Lazy module server initialization ---
  # Each module server is started only once, the first time the user
  # navigates to its tab.  This avoids setting up observers, reactive
  # values, and simulations for modules that are never visited.

  # Lookup: nav_panel value -> list(fn, id) or list(fn, id, extra_args)
  module_registry <- list(
    "Distribution Shapes"       = list(fn = distribution_shapes_server, id = "distribution_shapes"),
    "Sampling Theorems"         = list(fn = sampling_theorems_server,   id = "sampling_theorems"),
    "Data Summary"              = list(fn = data_summary_server,        id = "data_summary"),
    "Sampling"                  = list(fn = sampling_server,            id = "sampling"),
    "Experimental Design"       = list(fn = experimental_design_server, id = "experimental_design"),
    "Mean Comparisons"          = list(fn = mean_comparisons_server,    id = "mean_comparisons"),
    "Confidence & Resampling"   = list(fn = ci_resampling_server,       id = "ci_resampling"),
    "Categorical & Association" = list(fn = categorical_assoc_server,   id = "categorical_assoc"),
    "Bayesian & Power"          = list(fn = bayes_power_server,         id = "bayes_power"),
    "Corrections & Robustness"  = list(fn = corrections_server,         id = "corrections"),
    "Specialized Inference"     = list(fn = specialized_inference_server, id = "specialized_inference"),
    "Regression Core"           = list(fn = regression_core_server,     id = "regression_core"),
    "Model Diagnostics"         = list(fn = diagnostics_server,         id = "diagnostics"),
    "Multilevel Models"         = list(fn = multilevel_server,          id = "multilevel"),
    "Extended Models"           = list(fn = extended_models_server,     id = "extended_models"),
    "Mediation & Moderation"    = list(fn = mediation_moderation_server, id = "mediation_moderation"),
    "Dimension Reduction"       = list(fn = dim_reduction_server,       id = "dim_reduction"),
    "Clustering & Classification" = list(fn = clustering_server,        id = "clustering"),
    "Structural Models"         = list(fn = structural_server,          id = "structural"),
    "Machine Learning"          = list(fn = ml_server,                  id = "ml"),
    "Model Evaluation"          = list(fn = ml_evaluation_server,       id = "ml_evaluation"),
    "AI & LLMs"                 = list(fn = ai_models_server,           id = "ai_models"),
    "IRT Models"                = list(fn = irt_models_server,          id = "irt_models"),
    "Rasch Family"              = list(fn = rasch_family_server,        id = "rasch_family"),
    "Test & Item Quality"       = list(fn = test_quality_server,        id = "test_quality"),
    "Scoring & Reporting"       = list(fn = scoring_server,             id = "scoring"),
    "Fairness & Bias"           = list(fn = mod_fairness_server,        id = "mod_fairness"),
    "Equating & Linking"        = list(fn = mod_equating_linking_server, id = "mod_equating_linking"),
    "Adaptive Testing"          = list(fn = mod_adaptive_server,        id = "mod_adaptive"),
    "Validity & Measurement"    = list(fn = mod_validity_meas_server,   id = "mod_validity_meas"),
    "Advanced Models"           = list(fn = mod_advanced_psych_server,  id = "mod_advanced_psych"),
    "Large-Scale Assessment"    = list(fn = mod_large_scale_server,     id = "mod_large_scale"),
    "Assumption Violations"     = list(fn = assumption_violations_server, id = "assumption_violations"),
    "Data Quality"              = list(fn = data_quality_server,        id = "data_quality"),
    "Statistical Phenomena"     = list(fn = phenomena_server,           id = "phenomena"),
    "Data Preparation"          = list(fn = data_prep_server,           id = "data_prep"),
    "Time Series"               = list(fn = time_series_server,         id = "time_series"),
    "Causal Inference"          = list(fn = causal_inference_server,    id = "causal_inference"),
    "Effect Size Explorer"      = list(fn = effect_size_server,         id = "effect_size"),
    "Monte Carlo & Simulation"  = list(fn = monte_carlo_server,         id = "monte_carlo"),
    "Bayesian Workflow"         = list(fn = bayesian_workflow_server,   id = "bayesian_workflow"),
    "p-Hacking Simulator"      = list(fn = phacking_server,            id = "phacking"),
    "Sequential Testing"        = list(fn = sequential_testing_server,  id = "sequential_testing"),
    "Power: Complex Designs"    = list(fn = complex_power_server,       id = "complex_power"),
    "Replication & Open Science" = list(fn = open_science_server,       id = "open_science"),
    "Type I & II Errors"        = list(fn = type12_error_server,        id = "type12_error"),
    "Survey Methodology"        = list(fn = survey_server,              id = "survey"),
    "Clinical Trials"           = list(fn = clinical_trials_server,     id = "clinical_trials"),
    "Visualization Principles"  = list(fn = dataviz_server,             id = "dataviz"),
    "Game Theory"               = list(fn = game_theory_server,         id = "game_theory"),
    "Information Theory"        = list(fn = information_theory_server,  id = "information_theory"),
    "Multiple Imputation"       = list(fn = mice_server,                id = "mice"),
    "Signal Detection Theory"   = list(fn = sdt_server,                 id = "sdt"),
    "Interrater Reliability"    = list(fn = interrater_server,          id = "interrater"),
    "Text Analysis"             = list(fn = qualitative_server,         id = "qualitative"),
    "Latent Class Analysis"     = list(fn = lca_server,                 id = "lca"),
    "Growth Mixture Models"     = list(fn = growth_mixture_server,      id = "growth_mixture"),
    "Count Data Models"         = list(fn = count_models_server,        id = "count_models"),
    "GAMs"                      = list(fn = gam_server,                 id = "gam"),
    "Quantile Regression"       = list(fn = quantile_reg_server,        id = "quantile_reg"),
    "GEE"                       = list(fn = gee_server,                 id = "gee"),
    "Your Data"                 = list(fn = user_data_server,           id = "user_data"),
    "References"                = list(fn = references_server,          id = "references"),
    "Quiz"                      = list(fn = quiz_server,                id = "quiz", extra = list(session))
  )

  initialised <- character(0)

  observeEvent(input$main_nav, {
    tab <- input$main_nav
    if (tab %in% initialised) return()
    entry <- module_registry[[tab]]
    if (is.null(entry)) return()
    # Mark as initialised before calling (prevents double-init on rapid clicks)
    initialised <<- c(initialised, tab)
    if (!is.null(entry$extra)) {
      do.call(entry$fn, c(list(entry$id), entry$extra))
    } else {
      entry$fn(entry$id)
    }
  })


}

shinyApp(ui, server)
