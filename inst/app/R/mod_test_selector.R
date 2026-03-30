# ===========================================================================
# Module: What Test Should I Use? — Interactive decision tree
# ===========================================================================

# ── Decision-tree data structure ──────────────────────────────────────────
# Each node is a list with:
#   question  – text shown to the user
#   choices   – named list: label → next node ID  (for question nodes)
#   result    – present only on leaf nodes (recommendation)

tree_nodes <- list(

  # ── Step 1: Goal ──────────────────────────────────────────────────────
  goal = list(
    question = "What is your primary goal?",
    choices = list(
      "Compare groups"                      = "compare_outcome",
      "Examine relationships"               = "relate_types",
      "Predict an outcome"                  = "predict_outcome",
      "Reduce dimensions / find structure"  = "structure_goal",
      "Assess measurement quality"          = "measurement_goal",
      "Assess agreement between raters"     = "agreement_goal",
      "Test distribution or model fit"      = "fit_goal",
      "Determine sample size / power"       = "rec_power"
    )
  ),

  # ── Compare groups branch ─────────────────────────────────────────────
  compare_outcome = list(
    question = "What type is your outcome (dependent) variable?",
    choices = list(
      "Continuous (interval / ratio)"  = "compare_ngroups",
      "Categorical / counts"           = "compare_cat_design",
      "Time-to-event (survival)"       = "compare_survival"
    )
  ),

  compare_cat_design = list(
    question = "Are the groups independent or paired?",
    choices = list(
      "Independent groups"               = "rec_chisq_compare",
      "Paired / before-after (2\u00d72)"  = "rec_mcnemar"
    )
  ),

  compare_survival = list(
    question = "What do you need?",
    choices = list(
      "Compare survival curves between groups" = "rec_logrank",
      "Model survival with predictors"         = "rec_cox"
    )
  ),

  compare_ngroups = list(
    question = "How many groups are you comparing?",
    choices = list(
      "Two groups"                       = "compare_two_design",
      "Three or more groups"             = "compare_multi",
      "Repeated measures / within-subjects" = "compare_repeated"
    )
  ),

  compare_two_design = list(
    question = "Are the two groups independent or paired/matched?",
    choices = list(
      "Independent (different participants)" = "compare_two_normal",
      "Paired / matched / within-subjects"   = "compare_paired_normal"
    )
  ),

  compare_two_normal = list(
    question = "Can you assume approximate normality (or n > 30 per group)?",
    choices = list(
      "Yes, approximately normal"          = "rec_indep_ttest",
      "No, or very small samples / ordinal" = "rec_mann_whitney"
    )
  ),

  compare_paired_normal = list(
    question = "Can you assume approximate normality of the differences?",
    choices = list(
      "Yes"  = "rec_paired_ttest",
      "No"   = "rec_wilcoxon"
    )
  ),

  compare_multi = list(
    question = "Any additional considerations?",
    choices = list(
      "Simple comparison of 3+ group means"         = "compare_multi_normal",
      "Need to control for a covariate"             = "rec_ancova",
      "Multiple outcome variables simultaneously"   = "rec_manova"
    )
  ),

  compare_multi_normal = list(
    question = "Can you assume normality and equal variances?",
    choices = list(
      "Yes"  = "rec_anova",
      "No"   = "rec_kruskal"
    )
  ),

  compare_repeated = list(
    question = "What best describes your design?",
    choices = list(
      "Simple repeated measures (same subjects, all conditions)"       = "compare_rm_normal",
      "Mixed design (both between- and within-subjects factors)"       = "rec_mixed_anova",
      "Nested / clustered data (e.g. students within schools)"         = "rec_multilevel_compare"
    )
  ),

  compare_rm_normal = list(
    question = "Can you assume normality and sphericity?",
    choices = list(
      "Yes, or close enough"                   = "rec_rm_anova",
      "No, or ordinal / small samples"         = "rec_friedman"
    )
  ),

  # ── Relationships branch ──────────────────────────────────────────────
  relate_types = list(
    question = "What types of variables are you examining?",
    choices = list(
      "Both continuous"                      = "rec_correlation",
      "Both categorical"                     = "rec_chisq_assoc",
      "One categorical, one continuous"      = "rec_point_biserial",
      "Testing mediation or moderation"      = "rec_medmod",
      "Testing equivalence (not just difference)" = "rec_equivalence"
    )
  ),

  # ── Prediction branch ────────────────────────────────────────────────
  predict_outcome = list(
    question = "What type is your outcome variable?",
    choices = list(
      "Continuous"                          = "predict_continuous",
      "Binary (yes/no, pass/fail)"          = "rec_logistic",
      "Count (number of events)"            = "rec_poisson",
      "Ordinal (ordered categories)"        = "rec_ordinal",
      "Nominal with 3+ categories"          = "rec_multinomial",
      "Time-to-event (survival)"            = "rec_cox",
      "Time series (values over time)"      = "rec_timeseries",
      "Best prediction, interpretability less important" = "rec_ml"
    )
  ),

  predict_continuous = list(
    question = "Is your data nested or clustered?",
    choices = list(
      "No, standard design"                        = "rec_linear_reg",
      "Yes, nested / longitudinal / clustered"     = "rec_multilevel_pred"
    )
  ),

  # ── Structure branch ─────────────────────────────────────────────────
  structure_goal = list(
    question = "What are you trying to do?",
    choices = list(
      "Reduce many variables to fewer components/factors" = "rec_pca_efa",
      "Group similar observations into clusters"          = "rec_clustering",
      "Test a theoretical structural model"               = "rec_sem"
    )
  ),

  # ── Agreement branch ─────────────────────────────────────────────────
  agreement_goal = list(
    question = "What type of ratings are you comparing?",
    choices = list(
      "Categorical ratings (e.g. diagnoses, pass/fail)" = "agreement_cat_raters",
      "Continuous or ordinal ratings (e.g. scores)"     = "rec_icc"
    )
  ),

  agreement_cat_raters = list(
    question = "How many raters?",
    choices = list(
      "Two raters"           = "rec_cohens_kappa",
      "Three or more raters" = "rec_fleiss_kappa"
    )
  ),

  # ── Goodness-of-fit / distribution testing branch ───────────────────
  fit_goal = list(
    question = "What do you want to test?",
    choices = list(
      "Does my data follow a specific distribution (e.g. normal)?"  = "rec_gof_distribution",
      "Does my categorical data match expected proportions?"        = "rec_gof_chisq",
      "Does my model fit the data adequately?"                      = "rec_model_fit"
    )
  ),

  # ── Measurement branch ───────────────────────────────────────────────
  measurement_goal = list(
    question = "What aspect of measurement are you interested in?",
    choices = list(
      "Item analysis and reliability"     = "rec_item_reliability",
      "Item response theory (IRT)"        = "rec_irt",
      "Test fairness and DIF"             = "rec_dif"
    )
  ),

  # ══════════════════════════════════════════════════════════════════════
  # LEAF NODES — Recommendations
  # ══════════════════════════════════════════════════════════════════════

  rec_indep_ttest = list(result = list(
    test = "Independent-Samples t-test (Welch's)",
    description = "Compares the means of two independent groups on a continuous outcome. Welch's version does not assume equal variances and is generally preferred.",
    assumptions = c(
      "Independent observations",
      "Continuous outcome variable",
      "Approximately normal distributions in each group (robust with n > 30)"
    ),
    alternative = "Mann-Whitney U test (nonparametric)",
    module = "Mean Comparisons"
  )),

  rec_mann_whitney = list(result = list(
    test = "Mann-Whitney U Test",
    description = "Nonparametric test comparing the distributions (or medians) of two independent groups. Does not require normality.",
    assumptions = c(
      "Independent observations",
      "Ordinal or continuous outcome",
      "Similarly shaped distributions (for median interpretation)"
    ),
    alternative = "Independent-samples t-test (if normality holds)",
    module = "Corrections & Robustness"
  )),

  rec_paired_ttest = list(result = list(
    test = "Paired-Samples t-test",
    description = "Compares the mean difference between two related measurements (e.g. pre- vs. post-test on the same participants).",
    assumptions = c(
      "Paired/matched observations",
      "Differences are approximately normally distributed",
      "Continuous outcome"
    ),
    alternative = "Wilcoxon signed-rank test (nonparametric)",
    module = "Mean Comparisons"
  )),

  rec_wilcoxon = list(result = list(
    test = "Wilcoxon Signed-Rank Test",
    description = "Nonparametric alternative to the paired t-test. Tests whether the median difference between pairs is zero.",
    assumptions = c(
      "Paired observations",
      "Ordinal or continuous outcome",
      "Symmetrically distributed differences (for median interpretation)"
    ),
    alternative = "Paired t-test (if normality holds)",
    module = "Corrections & Robustness"
  )),

  rec_anova = list(result = list(
    test = "One-Way ANOVA",
    description = "Tests whether the means of three or more independent groups differ on a continuous outcome.",
    assumptions = c(
      "Independent observations",
      "Normally distributed residuals",
      "Homogeneity of variances (Levene's test)",
      "Continuous outcome"
    ),
    alternative = "Kruskal-Wallis test (nonparametric); Welch's ANOVA if variances unequal",
    module = "Mean Comparisons"
  )),

  rec_kruskal = list(result = list(
    test = "Kruskal-Wallis Test",
    description = "Nonparametric alternative to one-way ANOVA. Tests whether the distributions of three or more groups differ.",
    assumptions = c(
      "Independent observations",
      "Ordinal or continuous outcome",
      "Similarly shaped distributions across groups"
    ),
    alternative = "One-way ANOVA (if normality and equal variances hold)",
    module = "Corrections & Robustness"
  )),

  rec_ancova = list(result = list(
    test = "ANCOVA (Analysis of Covariance)",
    description = "Compares group means while statistically controlling for one or more continuous covariates.",
    assumptions = c(
      "All ANOVA assumptions",
      "Linear relationship between covariate and outcome",
      "Homogeneity of regression slopes (covariate effect is similar across groups)"
    ),
    alternative = "Robust ANCOVA or multilevel model",
    module = "Mean Comparisons"
  )),

  rec_manova = list(result = list(
    test = "MANOVA (Multivariate ANOVA)",
    description = "Tests whether group means differ across multiple outcome variables simultaneously, protecting against inflated Type I error from running multiple ANOVAs.",
    assumptions = c(
      "Independent observations",
      "Multivariate normality",
      "Homogeneity of variance-covariance matrices",
      "No severe multicollinearity among outcomes"
    ),
    alternative = "Separate ANOVAs with correction; discriminant analysis",
    module = "Mean Comparisons"
  )),

  rec_rm_anova = list(result = list(
    test = "Repeated-Measures ANOVA",
    description = "Tests whether the mean of a continuous outcome changes across conditions or time points within the same participants.",
    assumptions = c(
      "Continuous outcome",
      "Sphericity (equal variances of differences; test with Mauchly's)",
      "Normally distributed residuals"
    ),
    alternative = "Friedman test (nonparametric); mixed-effects model (more flexible)",
    module = "Mean Comparisons"
  )),

  rec_multilevel_compare = list(result = list(
    test = "Multilevel / Mixed-Effects Model",
    description = "Accounts for the hierarchical or nested structure of data (e.g. students within classrooms, repeated measures within subjects) by modelling both fixed effects and random effects.",
    assumptions = c(
      "Correctly specified nesting structure",
      "Normally distributed residuals at each level",
      "Normally distributed random effects"
    ),
    alternative = "GEE (population-averaged); cluster-robust standard errors",
    module = "Multilevel Models"
  )),

  rec_chisq_compare = list(result = list(
    test = "Chi-Square Test of Independence",
    description = "Tests whether two categorical variables are associated. Used when comparing the distribution of a categorical outcome across groups.",
    assumptions = c(
      "Independent observations",
      "Expected cell counts \u2265 5 in most cells",
      "Categorical variables with defined levels"
    ),
    alternative = "Fisher's exact test (small samples); logistic regression (covariates)",
    module = "Categorical & Association"
  )),

  rec_correlation = list(result = list(
    test = "Pearson or Spearman Correlation",
    description = "Measures the strength and direction of the linear (Pearson) or monotonic (Spearman) association between two continuous variables.",
    assumptions = c(
      "Pearson: bivariate normality, linear relationship, no extreme outliers",
      "Spearman: monotonic relationship, ordinal or continuous data"
    ),
    alternative = "Kendall's tau (small samples, many ties); partial correlation (control for confounders)",
    module = "Categorical & Association"
  )),

  rec_chisq_assoc = list(result = list(
    test = "Chi-Square Test of Independence",
    description = "Tests whether two categorical variables are independent of each other in a contingency table.",
    assumptions = c(
      "Independent observations",
      "Expected cell counts \u2265 5 in most cells"
    ),
    alternative = "Fisher's exact test (small expected counts); log-linear models (complex tables)",
    module = "Categorical & Association"
  )),

  rec_point_biserial = list(result = list(
    test = "Point-Biserial Correlation / Independent t-test",
    description = "Equivalent to a Pearson correlation between a dichotomous and a continuous variable. Mathematically identical to the independent t-test.",
    assumptions = c(
      "One naturally dichotomous variable",
      "Continuous variable approximately normal in each group",
      "Independent observations"
    ),
    alternative = "Logistic regression (if the categorical variable is the outcome)",
    module = "Categorical & Association"
  )),

  rec_medmod = list(result = list(
    test = "Mediation / Moderation Analysis",
    description = "Mediation examines whether the effect of X on Y is transmitted through a mediator M. Moderation tests whether the effect of X on Y depends on the level of a moderator W.",
    assumptions = c(
      "Correct causal ordering (mediation)",
      "No unmeasured confounders (strong assumption)",
      "Linear relationships (or correctly specified nonlinear forms)"
    ),
    alternative = "SEM for complex mediation; interaction terms in regression for moderation",
    module = "Structural Models"
  )),

  rec_linear_reg = list(result = list(
    test = "Linear Regression (OLS)",
    description = "Models the relationship between one or more predictors and a continuous outcome. Produces coefficients, R\u00b2, and significance tests.",
    assumptions = c(
      "Linear relationship between predictors and outcome",
      "Independent residuals",
      "Homoscedasticity (constant variance of residuals)",
      "Normally distributed residuals (for inference)"
    ),
    alternative = "Robust regression (outliers); Ridge/Lasso (multicollinearity/selection)",
    module = "Regression Core"
  )),

  rec_logistic = list(result = list(
    test = "Logistic Regression",
    description = "Models the probability of a binary outcome as a function of one or more predictors using the logit link function.",
    assumptions = c(
      "Binary outcome",
      "Independent observations",
      "Linear relationship between predictors and log-odds",
      "No severe multicollinearity"
    ),
    alternative = "Probit regression; decision tree / random forest (nonlinear patterns)",
    module = "Regression Core"
  )),

  rec_poisson = list(result = list(
    test = "Poisson Regression",
    description = "Models count data (number of events) as a function of predictors using a log link function.",
    assumptions = c(
      "Count outcome (non-negative integers)",
      "Mean equals variance (equidispersion)",
      "Independent observations",
      "Log-linear relationship"
    ),
    alternative = "Negative binomial regression (overdispersion); zero-inflated models (excess zeros)",
    module = "Regression Core"
  )),

  rec_ordinal = list(result = list(
    test = "Ordinal Regression (Proportional Odds)",
    description = "Models an ordered categorical outcome (e.g. Likert scale) using cumulative logits.",
    assumptions = c(
      "Ordered categorical outcome",
      "Proportional odds assumption (parallel slopes)",
      "Independent observations"
    ),
    alternative = "Multinomial regression (if proportional odds violated); ordinal forest",
    module = "Extended Models"
  )),

  rec_multinomial = list(result = list(
    test = "Multinomial Logistic Regression",
    description = "Models a nominal outcome with three or more unordered categories as a function of predictors.",
    assumptions = c(
      "Nominal (unordered) outcome with 3+ categories",
      "Independence of irrelevant alternatives (IIA)",
      "Independent observations"
    ),
    alternative = "Discriminant analysis; nested logit (if IIA is violated)",
    module = "Extended Models"
  )),

  rec_multilevel_pred = list(result = list(
    test = "Multilevel / Mixed-Effects Model",
    description = "Accounts for nested or longitudinal data structure when predicting a continuous outcome, modelling random variation at each level.",
    assumptions = c(
      "Correctly specified nesting structure",
      "Normally distributed residuals at each level",
      "Normally distributed random effects"
    ),
    alternative = "GEE; fixed-effects model; cluster-robust SEs",
    module = "Multilevel Models"
  )),

  rec_ml = list(result = list(
    test = "Machine Learning Methods",
    description = "When prediction accuracy matters more than interpretability, methods such as random forests, gradient boosting, SVM, or neural networks can capture complex nonlinear patterns.",
    assumptions = c(
      "Sufficient sample size for the chosen method",
      "Proper train/test split or cross-validation",
      "Feature engineering suited to the algorithm"
    ),
    alternative = "Regularised regression (interpretable); ensemble methods",
    module = "Machine Learning"
  )),

  rec_pca_efa = list(result = list(
    test = "PCA / Exploratory Factor Analysis",
    description = "PCA finds linear combinations of variables that capture maximal variance. EFA uncovers latent factors that explain correlations among observed variables.",
    assumptions = c(
      "EFA: multivariate normality (for ML estimation), sufficient correlations (Bartlett's test)",
      "PCA: continuous or near-continuous variables, adequate sample size",
      "Both: KMO > 0.6 for sampling adequacy"
    ),
    alternative = "CFA (if you have a hypothesised structure); ICA (non-Gaussian sources)",
    module = "Dimension Reduction"
  )),

  rec_clustering = list(result = list(
    test = "Cluster Analysis",
    description = "Groups observations into clusters based on similarity. Common methods include K-means (partitioning), hierarchical clustering, and model-based clustering.",
    assumptions = c(
      "Variables on comparable scales (standardise if needed)",
      "Meaningful distance metric chosen",
      "K-means: roughly spherical, equal-sized clusters"
    ),
    alternative = "DBSCAN (arbitrary shapes); mixture models (probabilistic assignment)",
    module = "Clustering & Classification"
  )),

  rec_sem = list(result = list(
    test = "Structural Equation Modelling (SEM)",
    description = "Tests a hypothesised network of relationships among observed and latent variables simultaneously, combining measurement models (CFA) with structural paths.",
    assumptions = c(
      "Multivariate normality (for ML estimation)",
      "Sufficient sample size (often n > 200)",
      "Correctly specified model (theory-driven)"
    ),
    alternative = "Path analysis (no latent variables); PLS-SEM (small samples, exploratory)",
    module = "Structural Models"
  )),

  rec_item_reliability = list(result = list(
    test = "Item Analysis & Reliability",
    description = "Evaluates item quality (difficulty, discrimination, item-total correlations) and scale reliability (Cronbach's \u03b1, McDonald's \u03c9).",
    assumptions = c(
      "\u03b1: essentially tau-equivalent items (equal factor loadings)",
      "\u03c9: congeneric model (unequal loadings allowed)",
      "Sufficient number of items and sample size"
    ),
    alternative = "IRT-based reliability (test information function); generalisability theory",
    module = "Test & Item Quality"
  )),

  rec_irt = list(result = list(
    test = "Item Response Theory (IRT)",
    description = "Models the probability of item responses as a function of latent ability and item parameters (difficulty, discrimination, guessing).",
    assumptions = c(
      "Unidimensionality (or correct dimensionality specification)",
      "Local independence",
      "Correct model chosen (1PL, 2PL, 3PL, or polytomous)"
    ),
    alternative = "CTT (simpler); cognitive diagnostic models (multidimensional skills)",
    module = "IRT Models"
  )),

  rec_dif = list(result = list(
    test = "Differential Item Functioning (DIF)",
    description = "Tests whether items function differently across groups (e.g. gender, ethnicity) after controlling for overall ability. Identifies potentially biased items.",
    assumptions = c(
      "Well-fitting IRT or CTT model as the baseline",
      "Meaningful grouping variable",
      "Sufficient sample size per group"
    ),
    alternative = "Measurement invariance via CFA; item parameter drift analysis",
    module = "Fairness & Bias"
  )),

  # ── New leaf nodes ──────────────────────────────────────────────────

  rec_mcnemar = list(result = list(
    test = "McNemar's Test",
    description = "Tests whether the proportions of a dichotomous outcome change between two related measurements (e.g. before vs. after treatment). It focuses on the discordant pairs — cases that switched category.",
    assumptions = c(
      "Paired/matched observations",
      "Dichotomous outcome (2\u00d72 table)",
      "Sufficient discordant pairs (generally \u2265 10)"
    ),
    alternative = "Exact McNemar test (small samples); Cochran's Q test (\u2265 3 time points)",
    module = "Categorical & Association"
  )),

  rec_logrank = list(result = list(
    test = "Log-Rank Test (Kaplan-Meier)",
    description = "Compares survival curves between two or more groups. The Kaplan-Meier estimator plots the survival function; the log-rank test determines whether the curves differ significantly.",
    assumptions = c(
      "Independent censoring (dropout unrelated to outcome)",
      "Non-informative censoring",
      "Proportional hazards (roughly parallel survival curves on log scale)"
    ),
    alternative = "Wilcoxon (Breslow) test (weights early events more); Cox regression (with covariates)",
    module = "Time Series"
  )),

  rec_cox = list(result = list(
    test = "Cox Proportional Hazards Regression",
    description = "Models the effect of predictors on the hazard (instantaneous risk) of an event occurring. Semi-parametric: no assumption on the baseline hazard shape.",
    assumptions = c(
      "Proportional hazards (check with Schoenfeld residuals)",
      "Independent censoring",
      "Linear relationship between predictors and log-hazard",
      "No influential outliers"
    ),
    alternative = "Accelerated failure time models; parametric survival (Weibull, exponential); time-varying coefficients",
    module = "Time Series"
  )),

  rec_timeseries = list(result = list(
    test = "Time Series Analysis (ARIMA / Exponential Smoothing)",
    description = "Models and forecasts values observed sequentially over time. ARIMA handles trends and autocorrelation; exponential smoothing captures level, trend, and seasonality.",
    assumptions = c(
      "Regularly spaced time points",
      "Stationarity (or made stationary via differencing)",
      "Residuals are white noise (no remaining autocorrelation)"
    ),
    alternative = "VAR (multivariate); GARCH (volatility); Prophet (flexible seasonality); state-space models",
    module = "Time Series"
  )),

  rec_friedman = list(result = list(
    test = "Friedman Test",
    description = "Nonparametric alternative to repeated-measures ANOVA. Tests whether the distributions of three or more related groups differ by ranking values within each subject.",
    assumptions = c(
      "Repeated measures or matched groups",
      "Ordinal or continuous outcome",
      "\u2265 3 conditions or time points"
    ),
    alternative = "Repeated-measures ANOVA (if normality holds); Quade test (few treatments, many subjects)",
    module = "Corrections & Robustness"
  )),

  rec_mixed_anova = list(result = list(
    test = "Mixed-Design ANOVA (Split-Plot)",
    description = "Handles designs with both between-subjects and within-subjects factors simultaneously. Tests main effects of each factor and their interaction.",
    assumptions = c(
      "Normality of residuals",
      "Sphericity for within-subjects factor (Mauchly's test)",
      "Homogeneity of variances for between-subjects factor",
      "Homogeneity of covariance matrices"
    ),
    alternative = "Linear mixed-effects model (more flexible, handles missing data); robust ANOVA methods",
    module = "Mean Comparisons"
  )),

  rec_equivalence = list(result = list(
    test = "TOST (Two One-Sided Tests) for Equivalence",
    description = "Tests whether two groups are practically equivalent rather than merely 'not significantly different.' You specify an equivalence margin (\u0394); if the confidence interval falls entirely within [\u2212\u0394, +\u0394], equivalence is concluded.",
    assumptions = c(
      "Pre-specified equivalence margin (based on domain knowledge)",
      "Same assumptions as the underlying test (e.g. t-test assumptions)",
      "Adequate sample size (equivalence tests need more power than difference tests)"
    ),
    alternative = "Non-inferiority test (one-sided); Bayesian estimation (ROPE)",
    module = "Bayes & Power"
  )),

  rec_cohens_kappa = list(result = list(
    test = "Cohen's Kappa",
    description = "Measures agreement between two raters classifying items into categorical groups, correcting for agreement expected by chance alone. Ranges from \u22121 (complete disagreement) to 1 (perfect agreement).",
    assumptions = c(
      "Exactly two raters",
      "Same set of categories used by both raters",
      "Independent ratings",
      "Nominal or ordinal categories (weighted kappa for ordinal)"
    ),
    alternative = "Gwet's AC1 (robust to prevalence and marginal problems); weighted kappa (ordinal categories)",
    module = "Inter-Rater Reliability"
  )),

  rec_fleiss_kappa = list(result = list(
    test = "Fleiss' Kappa",
    description = "Extends Cohen's kappa to three or more raters. Measures the agreement among multiple raters assigning categorical ratings, corrected for chance.",
    assumptions = c(
      "Three or more raters",
      "Same set of categories for all raters",
      "Each item rated by the same number of raters",
      "Independent ratings"
    ),
    alternative = "Krippendorff's alpha (handles missing raters, different scales); Light's kappa (average pairwise)",
    module = "Inter-Rater Reliability"
  )),

  rec_icc = list(result = list(
    test = "Intraclass Correlation Coefficient (ICC)",
    description = "Measures agreement or consistency among two or more raters on continuous or ordinal measurements. Multiple forms (ICC(1,1), ICC(2,1), ICC(3,1), etc.) depending on the design.",
    assumptions = c(
      "Continuous or ordinal ratings",
      "Normally distributed ratings (approximately)",
      "Correct ICC form chosen for the study design (random vs. fixed raters, single vs. average measures)"
    ),
    alternative = "Concordance correlation coefficient (Lin's CCC); Bland-Altman plot (visual agreement for two raters)",
    module = "Inter-Rater Reliability"
  )),

  rec_gof_distribution = list(result = list(
    test = "Shapiro-Wilk / Kolmogorov-Smirnov / Anderson-Darling",
    description = "Tests whether a sample comes from a specified distribution. Shapiro-Wilk is most powerful for normality testing. K-S and A-D test against any continuous distribution.",
    assumptions = c(
      "Independent observations",
      "Continuous data",
      "K-S: parameters must be specified (not estimated from data) unless using Lilliefors correction"
    ),
    alternative = "Q-Q plot (visual); Shapiro-Wilk (best for normality); Jarque-Bera (based on skewness/kurtosis)",
    module = "Assumption Violations"
  )),

  rec_gof_chisq = list(result = list(
    test = "Chi-Square Goodness-of-Fit Test",
    description = "Tests whether observed categorical frequencies match expected proportions (e.g. equal distribution, theoretical model, population values).",
    assumptions = c(
      "Independent observations",
      "Categorical data with defined expected proportions",
      "Expected cell counts \u2265 5 in each category"
    ),
    alternative = "Exact multinomial test (small samples); G-test (log-likelihood ratio)",
    module = "Categorical & Association"
  )),

  rec_model_fit = list(result = list(
    test = "Model Fit Indices (AIC, BIC, \u03c7\u00b2, RMSEA, CFI, etc.)",
    description = "Evaluates how well a statistical model fits the observed data. Different fit statistics are used for different model types: AIC/BIC for comparing models, \u03c7\u00b2/RMSEA/CFI/TLI for SEM/CFA, deviance for GLMs.",
    assumptions = c(
      "Appropriate fit index chosen for the model type",
      "SEM: RMSEA < .06, CFI/TLI > .95, SRMR < .08 are common thresholds",
      "AIC/BIC: lower is better; only valid for comparing models on same data"
    ),
    alternative = "Cross-validation (predictive models); posterior predictive checks (Bayesian)",
    module = "Diagnostics"
  )),

  rec_power = list(result = list(
    test = "Power Analysis / Sample Size Planning",
    description = "Determines the minimum sample size needed to detect an effect of a given size with desired power (usually 80% or 90%), or calculates the power of an existing study. Should be done before data collection.",
    assumptions = c(
      "Pre-specified effect size (from pilot data, literature, or minimum meaningful difference)",
      "Chosen significance level (\u03b1, typically .05)",
      "Chosen power level (1 \u2212 \u03b2, typically .80 or .90)",
      "Correct test identified for the planned analysis"
    ),
    alternative = "Simulation-based power analysis (complex designs); Bayesian sample size planning",
    module = "Bayes & Power"
  ))
)

# ── Helper: breadcrumb labels for each node ───────────────────────────────
node_labels <- c(
  goal = "Goal",
  compare_outcome = "Outcome type",
  compare_ngroups = "Number of groups",
  compare_two_design = "Design",
  compare_two_normal = "Normality",
  compare_paired_normal = "Normality",
  compare_multi = "Details",
  compare_multi_normal = "Normality",
  compare_repeated = "Design",
  compare_rm_normal = "Normality",
  compare_cat_design = "Design",
  compare_survival = "Survival goal",
  relate_types = "Variable types",
  predict_outcome = "Outcome type",
  predict_continuous = "Data structure",
  structure_goal = "Approach",
  measurement_goal = "Focus",
  agreement_goal = "Rating type",
  agreement_cat_raters = "Number of raters",
  fit_goal = "Fit type"
)


# ══════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════

# Content for the test selector modal (not a nav_panel)
test_selector_ui <- function(id) {
  ns <- NS(id)
  div(
  style = "max-width: 750px; margin: auto;",
  tags$h3(
    icon("signs-post"),
    " What Statistical Test Should I Use?"
  ),
  tags$p(class = "text-muted mb-4",
    "Answer a few questions about your research design and data,",
    "and this tool will recommend the most appropriate statistical method,",
    "with a link to explore it interactively."
  ),
  # Breadcrumb trail
  uiOutput(ns("ts_breadcrumb")),
  # Main decision area
  uiOutput(ns("ts_step")),
  # Navigation buttons
  div(
    class = "mt-3 d-flex gap-2",
    uiOutput(ns("ts_nav_buttons"))
  )
)
}

# ══════════════════════════════════════════════════════════════════════════
# Server
# ══════════════════════════════════════════════════════════════════════════

test_selector_server <- function(id, parent_session) {
  moduleServer(id, function(input, output, session) {

  # Reactive values: history is the vector of node IDs visited
  rv <- reactiveValues(
    history = "goal",
    selections = list()
  )

  current_node <- reactive({
    id <- rv$history[length(rv$history)]
    tree_nodes[[id]]
  })

  current_id <- reactive({
    rv$history[length(rv$history)]
  })

  # ── Breadcrumb ──────────────────────────────────────────────────────
  output$ts_breadcrumb <- renderUI({
    if (length(rv$history) <= 1) return(NULL)

    crumbs <- lapply(seq_along(rv$history), function(i) {
      nid <- rv$history[i]
      lbl <- node_labels[nid]
      if (is.na(lbl)) lbl <- nid

      # Add the user's selection if available
      sel <- rv$selections[[nid]]
      if (!is.null(sel)) {
        lbl <- paste0(lbl, ": ", sel)
      }

      if (i < length(rv$history)) {
        tags$span(
          class = "text-muted",
          style = "cursor: pointer; text-decoration: underline;",
          onclick = sprintf(
            "Shiny.setInputValue('%s', %d, {priority: 'event'})", session$ns("ts_jump_to"), i
          ),
          lbl,
          tags$span(class = "mx-1", "\u203A")
        )
      } else {
        tags$span(class = "fw-bold", lbl)
      }
    })

    div(class = "mb-3", style = "font-size: 0.9rem;", tagList(crumbs))
  })

  # ── Jump to breadcrumb ─────────────────────────────────────────────
  observeEvent(input$ts_jump_to, {
    idx <- input$ts_jump_to
    if (idx >= 1 && idx < length(rv$history)) {
      rv$history <- rv$history[1:idx]
    }
  })

  # ── Main step display ──────────────────────────────────────────────
  output$ts_step <- renderUI({
    node <- current_node()

    # ── RESULT node ──
    if (!is.null(node$result)) {
      rec <- node$result
      return(
        card(
          class = "border-success",
          card_header(
            class = "bg-success text-white",
            tagList(icon("check-circle"), tags$strong(paste0("  Recommended: ", rec$test)))
          ),
          card_body(
            tags$p(rec$description),
            tags$h6(icon("list-check"), " Assumptions to check:"),
            tags$ul(lapply(rec$assumptions, tags$li)),
            if (!is.null(rec$alternative)) {
              tagList(
                tags$h6(icon("arrows-rotate"), " Alternative:"),
                tags$p(class = "text-muted", rec$alternative)
              )
            },
            div(
              class = "mt-3 d-flex gap-2 flex-wrap",
              actionButton(session$ns("ts_goto_module"), tagList(icon("arrow-right"), paste0("  Go to ", rec$module)),
                           class = "btn-success"),
              actionButton(session$ns("ts_restart"), tagList(icon("rotate-left"), "  Start over"),
                           class = "btn-outline-secondary")
            )
          )
        )
      )
    }

    # ── QUESTION node ──
    choices <- names(node$choices)
    choice_cards <- lapply(seq_along(choices), function(i) {
      tags$div(
        class = "card mb-2 nav-card-hover",
        style = "cursor: pointer;",
        onclick = sprintf(
          "Shiny.setInputValue('%s', '%s', {priority: 'event'})",
          session$ns("ts_choice"), choices[i]
        ),
        div(
          class = "card-body py-2 px-3 d-flex align-items-center gap-2",
          icon("chevron-right", class = "text-success"),
          tags$span(choices[i])
        )
      )
    })

    card(
      card_header(
        tagList(
          icon("circle-question"),
          tags$strong(paste0("  Step ", length(rv$history), ": ", node$question))
        )
      ),
      card_body(tagList(choice_cards))
    )
  })

  # ── Handle choice selection ────────────────────────────────────────
  observeEvent(input$ts_choice, {
    node <- current_node()
    choice_label <- input$ts_choice
    next_id <- node$choices[[choice_label]]
    if (!is.null(next_id)) {
      rv$selections[[current_id()]] <- choice_label
      rv$history <- c(rv$history, next_id)
    }
  })

  # ── Nav buttons ────────────────────────────────────────────────────
  output$ts_nav_buttons <- renderUI({
    btns <- list()
    if (length(rv$history) > 1) {
      btns <- c(btns, list(
        actionButton(session$ns("ts_back"), tagList(icon("arrow-left"), " Back"),
                     class = "btn-outline-secondary btn-sm")
      ))
    }
    if (length(rv$history) > 1) {
      btns <- c(btns, list(
        actionButton(session$ns("ts_reset"), tagList(icon("rotate-left"), " Reset"),
                     class = "btn-outline-danger btn-sm")
      ))
    }
    tagList(btns)
  })

  # ── Back button ────────────────────────────────────────────────────
  observeEvent(input$ts_back, {
    if (length(rv$history) > 1) {
      rv$history <- rv$history[-length(rv$history)]
    }
  })

  # ── Reset buttons ──────────────────────────────────────────────────
  observeEvent(input$ts_reset, {
    rv$history <- "goal"
    rv$selections <- list()
  })

  observeEvent(input$ts_restart, {
    rv$history <- "goal"
    rv$selections <- list()
  })

  # ── Go to module ───────────────────────────────────────────────────
  observeEvent(input$ts_goto_module, {
    node <- current_node()
    if (!is.null(node$result)) {
      nav_select("main_nav", node$result$module, session = parent_session)
      # Close any open dropdown menus and scroll to top
      shinyjs_code <- "
        setTimeout(function(){
          document.querySelectorAll('.dropdown-menu.show').forEach(function(m){
            m.classList.remove('show');
            m.parentElement.querySelector('.dropdown-toggle').classList.remove('show');
            m.parentElement.querySelector('.dropdown-toggle').setAttribute('aria-expanded','false');
          });
          window.scrollTo(0, 0);
        }, 150);
      "
      session$sendCustomMessage("run_js", shinyjs_code)
    }
  })
  })
}
