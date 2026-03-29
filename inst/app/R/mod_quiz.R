# ===========================================================================
# Module: Quiz & Knowledge Check
# Interactive multiple-choice quiz spanning all topic areas
# ===========================================================================

# ---------------------------------------------------------------------------
# Question bank
# ---------------------------------------------------------------------------
quiz_questions <- list(

  # --- Distributions ---
  list(
    category = "Distributions",
    question = "As degrees of freedom increase, the t-distribution:",
    choices = c("Becomes more spread out",
                "Approaches the standard normal distribution",
                "Becomes more skewed",
                "Develops heavier tails"),
    correct = 2,
    explanation = "With increasing df, the t-distribution converges to the standard normal (z) distribution. At df > 30, they are nearly indistinguishable."
  ),
  list(
    category = "Distributions",
    question = "Which distribution is most appropriate for modeling count data (e.g., number of events per time period)?",
    choices = c("Normal", "Poisson", "Uniform", "Beta"),
    correct = 2,
    explanation = "The Poisson distribution models the number of events occurring in a fixed interval of time or space, assuming events occur independently at a constant rate."
  ),
  list(
    category = "Distributions",
    question = "A Q-Q plot shows points falling along a straight line. This suggests:",
    choices = c("The data has outliers",
                "The data follows the reference distribution",
                "The sample size is too small",
                "The data is bimodal"),
    correct = 2,
    explanation = "In a Q-Q plot, points following the diagonal reference line indicate the sample quantiles match the theoretical quantiles, suggesting the data follows that distribution."
  ),

  # --- Central Limit Theorem ---
  list(
    category = "Sampling",
    question = "The Central Limit Theorem states that:",
    choices = c("All populations are normally distributed",
                "Sample means are approximately normal for large samples, regardless of population shape",
                "Larger samples always have smaller means",
                "The sample distribution equals the population distribution"),
    correct = 2,
    explanation = "The CLT says that the distribution of sample means approaches normality as sample size increases, even if the population itself is non-normal. This is why many inferential procedures work."
  ),
  list(
    category = "Sampling",
    question = "Stratified sampling is preferred over simple random sampling when:",
    choices = c("The population is homogeneous",
                "You want the cheapest possible design",
                "The population has identifiable subgroups that differ on the variable of interest",
                "You cannot identify members of the population"),
    correct = 3,
    explanation = "Stratified sampling ensures representation of key subgroups and can reduce sampling variability when strata differ meaningfully on the outcome."
  ),

  # --- Inference ---
  list(
    category = "Inference",
    question = "A p-value of 0.03 means:",
    choices = c("There is a 3% chance the null hypothesis is true",
                "There is a 97% chance the alternative is true",
                "If the null were true, there is a 3% chance of observing data this extreme or more extreme",
                "The effect size is 0.03"),
    correct = 3,
    explanation = "The p-value is the probability of observing the test statistic (or more extreme) assuming the null hypothesis is true. It is NOT the probability that H0 is true."
  ),
  list(
    category = "Inference",
    question = "Which of the following increases statistical power?",
    choices = c("Using a smaller sample size",
                "Using a more stringent alpha level (e.g., 0.001)",
                "Increasing the sample size",
                "Using a two-tailed test instead of one-tailed"),
    correct = 3,
    explanation = "Larger samples give more precise estimates of the population parameter, making it easier to detect a true effect. More stringent alpha, two-tailed tests, and smaller samples all reduce power."
  ),
  list(
    category = "Inference",
    question = "A 95% confidence interval for a mean does NOT mean:",
    choices = c("If we repeated the study many times, about 95% of intervals would contain the true mean",
                "There is a 95% probability that the true mean falls in this specific interval",
                "The interval was constructed using a procedure that captures the true mean 95% of the time",
                "We are using a method with a 5% error rate in the long run"),
    correct = 2,
    explanation = "A specific CI either contains the true parameter or it doesn't -- it's not random. The 95% refers to the long-run coverage rate of the procedure, not the probability for any single interval."
  ),
  list(
    category = "Inference",
    question = "When conducting multiple hypothesis tests, the Bonferroni correction:",
    choices = c("Increases the power of each test",
                "Divides the significance level by the number of tests",
                "Eliminates the need for effect sizes",
                "Only applies to non-parametric tests"),
    correct = 2,
    explanation = "Bonferroni adjusts alpha by dividing by the number of tests (alpha/m), controlling the family-wise error rate. It is conservative -- it reduces Type I error but also reduces power."
  ),

  # --- Modeling ---
  list(
    category = "Modeling",
    question = "In multiple regression, multicollinearity refers to:",
    choices = c("Non-linear relationships between predictors and outcome",
                "High correlation among predictor variables",
                "Heteroscedastic residuals",
                "Non-normal residuals"),
    correct = 2,
    explanation = "Multicollinearity occurs when predictors are highly correlated with each other, inflating standard errors and making individual coefficient estimates unstable."
  ),
  list(
    category = "Modeling",
    question = "R-squared tells you:",
    choices = c("Whether the model is correctly specified",
                "The proportion of variance in the outcome explained by the model",
                "Whether the coefficients are statistically significant",
                "The causal effect of X on Y"),
    correct = 2,
    explanation = "R-squared measures the proportion of total variance in Y that is accounted for by the predictors. It does not indicate causation, model correctness, or significance."
  ),
  list(
    category = "Modeling",
    question = "Logistic regression is appropriate when the outcome variable is:",
    choices = c("Continuous and normally distributed",
                "A count variable",
                "Binary (0/1 or yes/no)",
                "Ordinal with many levels"),
    correct = 3,
    explanation = "Logistic regression models the log-odds of a binary outcome as a linear function of predictors. For counts use Poisson regression; for ordinal outcomes use ordinal regression."
  ),

  # --- Assumptions ---
  list(
    category = "Assumptions",
    question = "Which assumption violation is generally MOST damaging to statistical tests?",
    choices = c("Mild non-normality",
                "Violation of independence",
                "Slightly unequal variances with equal sample sizes",
                "A single outlier in a large sample"),
    correct = 2,
    explanation = "Independence violations (e.g., clustered data treated as independent) can massively inflate Type I error rates. Most tests are more robust to mild non-normality or slight variance heterogeneity."
  ),
  list(
    category = "Assumptions",
    question = "Welch's t-test is generally preferred over Student's t-test because:",
    choices = c("It assumes equal variances",
                "It is more powerful when variances are equal",
                "It controls Type I error well whether or not variances are equal",
                "It doesn't require normally distributed data"),
    correct = 3,
    explanation = "Welch's t-test adjusts degrees of freedom for unequal variances. It performs nearly as well as Student's t when variances are equal, but much better when they're not."
  ),
  list(
    category = "Assumptions",
    question = "A residual plot showing a funnel shape (wider spread at higher fitted values) suggests:",
    choices = c("Non-linearity",
                "Heteroscedasticity (non-constant variance)",
                "Perfect model fit",
                "Multicollinearity"),
    correct = 2,
    explanation = "A funnel pattern in residuals indicates the variance of errors increases with the fitted values -- a violation of the homoscedasticity assumption."
  ),

  # --- Effect Sizes ---
  list(
    category = "Inference",
    question = "A Cohen's d of 0.8 is conventionally considered:",
    choices = c("Small", "Medium", "Large", "Very large"),
    correct = 3,
    explanation = "Cohen's benchmarks: d = 0.2 (small), d = 0.5 (medium), d = 0.8 (large). These are rough guidelines -- practical significance depends on context."
  ),

  # --- Psychometrics ---
  list(
    category = "Psychometrics",
    question = "In Item Response Theory, the discrimination parameter (a) represents:",
    choices = c("Item difficulty",
                "How well the item differentiates between high and low ability",
                "The probability of guessing correctly",
                "The item's reliability"),
    correct = 2,
    explanation = "The a parameter controls the steepness of the item characteristic curve. Higher discrimination means the item better separates examinees of different ability levels."
  ),
  list(
    category = "Psychometrics",
    question = "Cronbach's alpha is a measure of:",
    choices = c("Test validity",
                "Internal consistency reliability",
                "Inter-rater reliability",
                "Test-retest reliability"),
    correct = 2,
    explanation = "Cronbach's alpha estimates internal consistency -- the degree to which items measure the same construct. It is NOT a measure of unidimensionality or validity."
  ),
  list(
    category = "Psychometrics",
    question = "Differential Item Functioning (DIF) occurs when:",
    choices = c("An item is too difficult",
                "An item functions differently for groups matched on the trait being measured",
                "An item has low discrimination",
                "An item has a high guessing parameter"),
    correct = 2,
    explanation = "DIF means an item has different measurement properties (difficulty, discrimination) for different groups (e.g., gender, ethnicity) after controlling for the overall trait level."
  ),

  # --- Machine Learning ---
  list(
    category = "Machine Learning",
    question = "Overfitting occurs when a model:",
    choices = c("Is too simple to capture the data pattern",
                "Performs well on training data but poorly on new data",
                "Has too few parameters",
                "Uses too much regularization"),
    correct = 2,
    explanation = "Overfitting means the model has learned noise in the training data rather than the true signal, resulting in poor generalization to unseen data."
  ),
  list(
    category = "Machine Learning",
    question = "Cross-validation is used primarily to:",
    choices = c("Increase the training set size",
                "Estimate how well a model will perform on new, unseen data",
                "Find the best features",
                "Speed up model training"),
    correct = 2,
    explanation = "Cross-validation provides a more reliable estimate of out-of-sample performance by repeatedly training and testing on different subsets of the data."
  ),

  # --- Multivariate ---
  list(
    category = "Multivariate",
    question = "The primary goal of Principal Component Analysis (PCA) is to:",
    choices = c("Test group differences",
                "Reduce dimensionality while preserving maximum variance",
                "Identify causal relationships",
                "Classify observations into groups"),
    correct = 2,
    explanation = "PCA finds orthogonal linear combinations (components) of the original variables that capture the most variance, allowing dimensionality reduction."
  ),
  list(
    category = "Multivariate",
    question = "In cluster analysis, the 'elbow method' helps determine:",
    choices = c("Which variables to include",
                "The optimal number of clusters",
                "Whether clusters are normally distributed",
                "The significance of cluster differences"),
    correct = 2,
    explanation = "The elbow method plots within-cluster sum of squares against the number of clusters. The 'elbow' -- where the rate of decrease sharply changes -- suggests the optimal k."
  ),

  # --- Experimental Design ---
  list(
    category = "Design",
    question = "Random assignment in experiments is important because it:",
    choices = c("Ensures equal sample sizes",
                "Guarantees a significant result",
                "Balances confounding variables across groups (on average)",
                "Eliminates the need for statistical tests"),
    correct = 3,
    explanation = "Randomization distributes both known and unknown confounders approximately equally across groups, providing the basis for causal inference."
  ),
  list(
    category = "Design",
    question = "A within-subjects design typically has MORE power than a between-subjects design because:",
    choices = c("It uses more participants",
                "It eliminates between-subject variability from the error term",
                "It avoids practice effects",
                "It doesn't require random assignment"),
    correct = 2,
    explanation = "Each participant serves as their own control, so individual differences don't contribute to the error term. This reduces the denominator of the F-ratio, increasing power."
  ),

  # --- General Concepts ---
  list(
    category = "General",
    question = "Simpson's paradox occurs when:",
    choices = c("A relationship reverses after accounting for a confounding variable",
                "Two variables are perfectly correlated",
                "The sample is too small",
                "Missing data biases results"),
    correct = 1,
    explanation = "Simpson's paradox is when a trend that appears in several groups reverses when the groups are combined. It highlights the importance of considering confounding variables."
  ),
  list(
    category = "General",
    question = "Missing data that is 'Missing At Random' (MAR) means:",
    choices = c("Data is missing completely randomly",
                "Missingness depends on observed variables but not on the missing values themselves",
                "The missing values can be ignored safely",
                "Missingness depends on the missing values"),
    correct = 2,
    explanation = "MAR means missingness is related to observed data but not to the unobserved values. For example, older participants might skip questions more often, but their would-be answers aren't systematically different conditional on age."
  ),
  list(
    category = "General",
    question = "Regression to the mean refers to:",
    choices = c("All scores eventually become average",
                "Extreme scores on one measurement tend to be less extreme on a subsequent measurement",
                "The regression line always passes through zero",
                "All predictors eventually become non-significant"),
    correct = 2,
    explanation = "Regression to the mean is a statistical phenomenon: extreme observations are partly due to random variation, so repeat measurements tend to be closer to the overall mean."
  ),

  # =====================================================================
  # EXPANDED ITEM BANK
  # =====================================================================


  # --- Distributions (additional) ---
  list(
    category = "Distributions",
    question = "The chi-square distribution is:",
    choices = c("Symmetric around zero",
                "Always right-skewed, approaching normality with more df",
                "Always left-skewed",
                "Bounded between 0 and 1"),
    correct = 2,
    explanation = "The chi-square distribution is the sum of squared standard normals. It is right-skewed for small df and approaches normality as df increases, and only takes non-negative values."
  ),
  list(
    category = "Distributions",
    question = "The F-distribution is used primarily to:",
    choices = c("Compare two population means",
                "Compare two or more variances or test overall model significance",
                "Test whether data are normally distributed",
                "Estimate confidence intervals for proportions"),
    correct = 2,
    explanation = "The F-distribution is the ratio of two independent chi-square variables divided by their df. It is used in ANOVA (comparing group means via variance ratios) and regression (overall F-test)."
  ),
  list(
    category = "Distributions",
    question = "The binomial distribution assumes all of the following EXCEPT:",
    choices = c("Fixed number of trials",
                "Two possible outcomes per trial",
                "Trials are independent",
                "The probability of success changes across trials"),
    correct = 4,
    explanation = "The binomial requires a fixed number of independent trials, each with exactly two outcomes and a constant probability of success across all trials."
  ),
  list(
    category = "Distributions",
    question = "Which distribution would you use to model the time until the next event in a Poisson process?",
    choices = c("Normal", "Binomial", "Exponential", "Chi-square"),
    correct = 3,
    explanation = "The exponential distribution models waiting times between events in a Poisson process. If events occur at a constant rate, the time between consecutive events follows an exponential distribution."
  ),
  list(
    category = "Distributions",
    question = "Skewness measures:",
    choices = c("How peaked or flat a distribution is",
                "The asymmetry of a distribution",
                "The spread of data around the mean",
                "The proportion of outliers"),
    correct = 2,
    explanation = "Skewness quantifies asymmetry. Positive skew means a longer right tail; negative skew means a longer left tail. A perfectly symmetric distribution has skewness of zero."
  ),
  list(
    category = "Distributions",
    question = "Kurtosis primarily describes:",
    choices = c("The center of a distribution",
                "Whether a distribution is skewed",
                "The heaviness of the tails relative to a normal distribution",
                "The number of modes"),
    correct = 3,
    explanation = "Kurtosis measures tail heaviness. High kurtosis (leptokurtic) means heavier tails and more extreme outliers than a normal distribution. It is NOT simply about 'peakedness'."
  ),

  # --- Sampling (additional) ---
  list(
    category = "Sampling",
    question = "The standard error of the mean decreases when:",
    choices = c("The population mean increases",
                "The sample size increases",
                "The sample mean increases",
                "The confidence level increases"),
    correct = 2,
    explanation = "The standard error = SD / sqrt(n). As n increases, the standard error shrinks, meaning our estimate of the population mean becomes more precise."
  ),
  list(
    category = "Sampling",
    question = "Cluster sampling differs from stratified sampling in that:",
    choices = c("Clusters are internally homogeneous",
                "All clusters are sampled",
                "Only some clusters are selected, and all members within selected clusters are sampled",
                "Each individual is assigned to exactly one stratum"),
    correct = 3,
    explanation = "In cluster sampling, you randomly select entire clusters and sample everyone within them. In stratified sampling, you sample from every stratum. Clusters are ideally internally heterogeneous."
  ),
  list(
    category = "Sampling",
    question = "Selection bias in sampling occurs when:",
    choices = c("The sample size is too small",
                "Some members of the population are more likely to be included than others",
                "The measurement instrument is unreliable",
                "Participants drop out of a study"),
    correct = 2,
    explanation = "Selection bias arises when the sampling procedure systematically favors certain population members, making the sample unrepresentative of the target population."
  ),
  list(
    category = "Sampling",
    question = "The Law of Large Numbers states that:",
    choices = c("Large samples are always normally distributed",
                "The sample mean converges to the population mean as sample size grows",
                "Large populations require larger samples",
                "Variance increases with sample size"),
    correct = 2,
    explanation = "The LLN guarantees that as n grows, the sample average approaches the expected value (population mean). This is distinct from the CLT, which describes the shape of the sampling distribution."
  ),

  # --- Inference (additional) ---
  list(
    category = "Inference",
    question = "Type II error occurs when:",
    choices = c("You reject a true null hypothesis",
                "You fail to reject a false null hypothesis",
                "Your sample size is too large",
                "You use the wrong statistical test"),
    correct = 2,
    explanation = "Type II error (false negative) means failing to detect a real effect. Its probability is beta, and power = 1 - beta is the probability of correctly rejecting a false null."
  ),
  list(
    category = "Inference",
    question = "Statistical significance (p < 0.05) guarantees:",
    choices = c("The effect is practically important",
                "The null hypothesis is false",
                "Neither practical importance nor that the null is false",
                "The study was well designed"),
    correct = 3,
    explanation = "Statistical significance means the observed result is unlikely under the null hypothesis, but it says nothing about effect size, practical relevance, or whether the null is actually false."
  ),
  list(
    category = "Inference",
    question = "A paired t-test is appropriate when:",
    choices = c("Two independent groups are compared",
                "Observations in the two groups are naturally matched or from the same subjects",
                "The data are not normally distributed",
                "Sample sizes are unequal"),
    correct = 2,
    explanation = "The paired t-test is used when observations come in matched pairs (e.g., before/after on the same subjects), so the test analyzes the differences within pairs."
  ),
  list(
    category = "Inference",
    question = "The Kruskal-Wallis test is the nonparametric alternative to:",
    choices = c("Paired t-test",
                "Chi-square test",
                "One-way ANOVA",
                "Pearson correlation"),
    correct = 3,
    explanation = "The Kruskal-Wallis test compares distributions across three or more independent groups using ranks, making it robust to non-normality. It is the rank-based analog of one-way ANOVA."
  ),
  list(
    category = "Inference",
    question = "Bootstrapping is useful because it:",
    choices = c("Eliminates the need for data",
                "Always produces narrower confidence intervals",
                "Estimates the sampling distribution without parametric assumptions",
                "Only works with normally distributed data"),
    correct = 3,
    explanation = "Bootstrapping resamples from the observed data with replacement to approximate the sampling distribution. It requires minimal distributional assumptions and works for complex statistics."
  ),
  list(
    category = "Inference",
    question = "ANOVA partitions total variability into:",
    choices = c("Mean and variance",
                "Between-group and within-group variability",
                "Population and sample variability",
                "Systematic and random effects"),
    correct = 2,
    explanation = "ANOVA decomposes total sum of squares into between-group SS (due to group differences) and within-group SS (due to individual variation). The F-ratio compares these components."
  ),
  list(
    category = "Inference",
    question = "The Holm-Bonferroni correction is preferred over Bonferroni because it:",
    choices = c("Controls a different error rate",
                "Is uniformly more powerful while still controlling family-wise error",
                "Doesn't require independent tests",
                "Only works with two comparisons"),
    correct = 2,
    explanation = "Holm's step-down procedure is strictly more powerful than the standard Bonferroni correction while maintaining the same family-wise error rate control. It should generally be preferred."
  ),
  list(
    category = "Inference",
    question = "Bayesian inference differs from frequentist inference primarily in that it:",
    choices = c("Never uses p-values or significance levels",
                "Updates prior beliefs with observed data to form posterior distributions",
                "Only works with large samples",
                "Assumes all parameters are fixed"),
    correct = 2,
    explanation = "Bayesian inference combines prior distributions (existing knowledge) with the likelihood of observed data via Bayes' theorem to produce posterior distributions for parameters."
  ),

  # --- Modeling (additional) ---
  list(
    category = "Modeling",
    question = "In regression, heteroscedasticity means:",
    choices = c("Predictors are correlated with each other",
                "The variance of residuals changes across levels of the predictor",
                "The relationship between X and Y is non-linear",
                "Residuals are autocorrelated"),
    correct = 2,
    explanation = "Heteroscedasticity violates the constant-variance assumption. It doesn't bias coefficient estimates but makes standard errors (and thus p-values and CIs) unreliable."
  ),
  list(
    category = "Modeling",
    question = "Ridge regression differs from ordinary least squares (OLS) by adding:",
    choices = c("An L1 penalty that can shrink coefficients to exactly zero",
                "An L2 penalty that shrinks coefficients toward zero but not to zero",
                "More predictor variables",
                "A transformation of the outcome variable"),
    correct = 2,
    explanation = "Ridge regression adds a penalty proportional to the sum of squared coefficients (L2). This shrinks estimates toward zero, reducing variance at the cost of some bias, but doesn't produce exact zeros."
  ),
  list(
    category = "Modeling",
    question = "The Lasso is particularly useful when you want to:",
    choices = c("Include all predictors in the model",
                "Perform automatic variable selection by shrinking some coefficients to zero",
                "Handle non-linear relationships",
                "Estimate random effects"),
    correct = 2,
    explanation = "Lasso (L1 penalty) can shrink coefficients to exactly zero, effectively performing variable selection. This produces sparse, interpretable models when many predictors are irrelevant."
  ),
  list(
    category = "Modeling",
    question = "AIC (Akaike Information Criterion) balances:",
    choices = c("Bias and variance",
                "Sensitivity and specificity",
                "Model fit and model complexity",
                "Type I and Type II error"),
    correct = 3,
    explanation = "AIC = -2*log-likelihood + 2*k, where k is the number of parameters. It penalizes complexity to prevent overfitting. Lower AIC indicates a better balance of fit and parsimony."
  ),
  list(
    category = "Modeling",
    question = "In a multilevel model, the Intraclass Correlation Coefficient (ICC) represents:",
    choices = c("The correlation between two predictors",
                "The proportion of total variance attributable to the grouping variable",
                "The reliability of the outcome measure",
                "The effect size of the treatment"),
    correct = 2,
    explanation = "ICC = between-group variance / total variance. It indicates how much observations within the same group resemble each other. High ICC means clustering matters and multilevel modeling is warranted."
  ),
  list(
    category = "Modeling",
    question = "Poisson regression is appropriate for modeling:",
    choices = c("Binary outcomes",
                "Continuous outcomes with constant variance",
                "Count data (non-negative integers)",
                "Ordinal outcomes"),
    correct = 3,
    explanation = "Poisson regression models count outcomes using a log link function. It assumes the mean equals the variance (equidispersion). When variance exceeds the mean, negative binomial regression is often preferred."
  ),
  list(
    category = "Modeling",
    question = "Cook's distance measures:",
    choices = c("The normality of residuals",
                "The influence of each observation on the overall regression results",
                "Multicollinearity among predictors",
                "The goodness of fit of the model"),
    correct = 2,
    explanation = "Cook's distance quantifies how much all fitted values change when a single observation is removed. High Cook's D indicates an influential point that disproportionately affects the model."
  ),

  # --- Assumptions (additional) ---
  list(
    category = "Assumptions",
    question = "The Shapiro-Wilk test assesses:",
    choices = c("Homogeneity of variance",
                "Independence of observations",
                "Whether data follow a normal distribution",
                "Linearity of relationships"),
    correct = 3,
    explanation = "The Shapiro-Wilk test is a formal test of normality. However, with large samples it detects trivial deviations, so visual methods (Q-Q plots, histograms) are often more informative."
  ),
  list(
    category = "Assumptions",
    question = "Levene's test is used to assess:",
    choices = c("Normality",
                "Independence",
                "Equality of variances across groups",
                "Linearity"),
    correct = 3,
    explanation = "Levene's test compares variances across groups by testing whether the absolute deviations from group means (or medians) differ. It is more robust to non-normality than Bartlett's test."
  ),
  list(
    category = "Assumptions",
    question = "When the normality assumption is violated with a large sample (n > 100), the t-test is usually:",
    choices = c("Completely invalid",
                "Still reasonably reliable due to the Central Limit Theorem",
                "More powerful than nonparametric alternatives",
                "Biased in its parameter estimates"),
    correct = 2,
    explanation = "The CLT ensures that the sampling distribution of the mean is approximately normal for large n, so the t-test remains valid. However, with heavy-tailed distributions, rank-based tests may have better power."
  ),
  list(
    category = "Assumptions",
    question = "Autocorrelation in residuals is most concerning in:",
    choices = c("Cross-sectional survey data",
                "Time series and longitudinal data",
                "Randomized controlled trials",
                "Cluster-randomized designs"),
    correct = 2,
    explanation = "Autocorrelation means residuals at adjacent time points are correlated. This violates independence, inflates Type I error, and is especially common in time series and repeated-measures data."
  ),
  list(
    category = "Assumptions",
    question = "The design effect in cluster sampling equals 1 + (m - 1) * ICC, where m is the cluster size. If ICC = 0.10 and m = 20, the design effect is:",
    choices = c("1.10", "2.90", "3.00", "2.00"),
    correct = 2,
    explanation = "Design effect = 1 + (20 - 1) * 0.10 = 1 + 1.90 = 2.90. This means the effective sample size is only about 1/2.90 = 34.5% of the nominal sample size."
  ),

  # --- Psychometrics (additional) ---
  list(
    category = "Psychometrics",
    question = "In the Rasch model, all items have:",
    choices = c("Different difficulty and discrimination parameters",
                "Equal discrimination and no guessing parameter",
                "Equal difficulty parameters",
                "A guessing parameter of 0.25"),
    correct = 2,
    explanation = "The Rasch model constrains all items to have equal discrimination (a = 1) and no guessing (c = 0). Only difficulty (b) varies across items. This provides specific objectivity."
  ),
  list(
    category = "Psychometrics",
    question = "A Wright map (person-item map) displays:",
    choices = c("Item discrimination values",
                "Person abilities and item difficulties on the same scale",
                "Test reliability across score ranges",
                "Factor loadings"),
    correct = 2,
    explanation = "Wright maps place persons and items on a common logit scale, making it easy to see which items are well-targeted to the sample's ability range and where gaps exist."
  ),
  list(
    category = "Psychometrics",
    question = "Omega (coefficient omega) is generally preferred over Cronbach's alpha because:",
    choices = c("It is always larger than alpha",
                "It doesn't assume tau-equivalence (equal factor loadings)",
                "It requires fewer items",
                "It works with any number of factors"),
    correct = 2,
    explanation = "Alpha assumes tau-equivalence (all items load equally on the factor). When loadings differ (congeneric items), alpha underestimates reliability. With multidimensional data, alpha can overestimate single-factor reliability. Omega uses the actual factor model and is more accurate in both cases."
  ),
  list(
    category = "Psychometrics",
    question = "In Computerized Adaptive Testing (CAT), items are selected based on:",
    choices = c("Random sampling from the item pool",
                "The order they appear in the item bank",
                "Maximum information at the current ability estimate",
                "Difficulty level from easiest to hardest"),
    correct = 3,
    explanation = "CAT selects items that provide the most information at the examinee's current estimated ability level, maximizing measurement precision with fewer items."
  ),
  list(
    category = "Psychometrics",
    question = "A test information function (TIF) in IRT tells you:",
    choices = c("The content validity of the test",
                "How precisely the test measures at each ability level",
                "The number of items needed",
                "The pass/fail cut score"),
    correct = 2,
    explanation = "The TIF is the sum of item information functions. Higher information means more precise measurement (lower standard error) at that ability level. It shows where the test measures best."
  ),
  list(
    category = "Psychometrics",
    question = "Measurement invariance testing determines whether:",
    choices = c("A test has good internal consistency",
                "A measurement instrument functions the same way across groups",
                "Items have acceptable difficulty levels",
                "The test has sufficient length"),
    correct = 2,
    explanation = "Measurement invariance uses increasingly restrictive CFA models to test whether factor structure, loadings, and intercepts are equivalent across groups. It is essential for meaningful group comparisons."
  ),

  # --- Machine Learning (additional) ---
  list(
    category = "Machine Learning",
    question = "The bias-variance tradeoff means that:",
    choices = c("Reducing bias always improves predictions",
                "Increasing model complexity reduces bias but increases variance",
                "Simple models always outperform complex ones",
                "Variance is irrelevant for prediction accuracy"),
    correct = 2,
    explanation = "More complex models fit training data better (lower bias) but are more sensitive to the specific training sample (higher variance). The optimal model balances both sources of error."
  ),
  list(
    category = "Machine Learning",
    question = "In a Random Forest, individual trees are made diverse by:",
    choices = c("Using different algorithms for each tree",
                "Bootstrap sampling and random feature subsets at each split",
                "Pruning each tree differently",
                "Using different outcome variables"),
    correct = 2,
    explanation = "Random Forest combines bagging (bootstrap samples) with random feature selection at each split. This decorrelates trees and reduces variance of the ensemble compared to a single tree."
  ),
  list(
    category = "Machine Learning",
    question = "An ROC curve plots:",
    choices = c("Precision vs. recall",
                "True positive rate vs. false positive rate",
                "Sensitivity vs. specificity",
                "Both B and C are correct"),
    correct = 4,
    explanation = "ROC plots TPR (sensitivity) vs. FPR (1 - specificity) at various classification thresholds. 'True positive rate vs. false positive rate' and 'sensitivity vs. 1-specificity' are equivalent descriptions."
  ),
  list(
    category = "Machine Learning",
    question = "K-fold cross-validation with k = 10 means:",
    choices = c("The model is trained on 10% of the data",
                "The data is split into 10 parts; each part serves as the test set once",
                "10 different models are compared",
                "Training is repeated 10 times on the full dataset"),
    correct = 2,
    explanation = "In 10-fold CV, the data is partitioned into 10 equal folds. The model is trained on 9 folds and tested on the remaining fold, rotating through all 10 folds. Results are averaged."
  ),
  list(
    category = "Machine Learning",
    question = "Gradient descent optimization works by:",
    choices = c("Randomly searching for the best parameters",
                "Exhaustively trying all possible parameter values",
                "Iteratively adjusting parameters in the direction that reduces the loss function",
                "Solving an equation analytically"),
    correct = 3,
    explanation = "Gradient descent computes the gradient (direction of steepest increase) of the loss function with respect to parameters, then takes a step in the opposite direction to reduce the loss."
  ),
  list(
    category = "Machine Learning",
    question = "Feature scaling (standardization/normalization) is especially important for:",
    choices = c("Decision trees",
                "KNN and SVM algorithms",
                "Random forests",
                "Naive Bayes"),
    correct = 2,
    explanation = "KNN and SVM rely on distances between observations. If features are on very different scales, the algorithm will be dominated by the feature with the largest range. Trees are scale-invariant."
  ),

  # --- Multivariate (additional) ---
  list(
    category = "Multivariate",
    question = "In factor analysis, a factor loading represents:",
    choices = c("The variance explained by each factor",
                "The correlation between an observed variable and a latent factor",
                "The number of factors to retain",
                "The communality of a variable"),
    correct = 2,
    explanation = "Factor loadings are the correlations (or regression weights) between observed variables and latent factors. High loadings indicate the variable is a strong indicator of that factor."
  ),
  list(
    category = "Multivariate",
    question = "The Kaiser criterion retains factors with eigenvalues:",
    choices = c("Greater than zero",
                "Greater than 1",
                "Greater than the average eigenvalue",
                "In the top 50%"),
    correct = 2,
    explanation = "The Kaiser criterion retains factors with eigenvalues > 1, reasoning that a factor should explain at least as much variance as a single standardized variable. It often over-extracts factors."
  ),
  list(
    category = "Multivariate",
    question = "In Structural Equation Modeling (SEM), the RMSEA indicates:",
    choices = c("The proportion of variance explained",
                "The discrepancy between the model and the data per degree of freedom",
                "Whether the model is identified",
                "The reliability of latent variables"),
    correct = 2,
    explanation = "RMSEA measures approximate fit per df. Values below 0.05 indicate close fit; 0.05-0.08 acceptable fit; above 0.10 poor fit. It penalizes model complexity, unlike the chi-square test."
  ),
  list(
    category = "Multivariate",
    question = "The silhouette coefficient for clustering ranges from:",
    choices = c("0 to 1",
                "-1 to 1",
                "0 to infinity",
                "-infinity to infinity"),
    correct = 2,
    explanation = "Silhouette values range from -1 (likely assigned to wrong cluster) to +1 (well-matched to own cluster). Values near 0 indicate the observation is on the boundary between clusters."
  ),

  # --- Experimental Design (additional) ---
  list(
    category = "Design",
    question = "An interaction effect in a factorial design means:",
    choices = c("The main effects are not significant",
                "The effect of one factor depends on the level of another factor",
                "The factors are confounded",
                "The sample sizes are unequal"),
    correct = 2,
    explanation = "An interaction means the factors do not act independently. Graphically, interaction appears as non-parallel lines in an interaction plot."
  ),
  list(
    category = "Design",
    question = "Blocking in experimental design is used to:",
    choices = c("Increase the number of treatment groups",
                "Reduce variability by grouping similar experimental units",
                "Eliminate the need for randomization",
                "Increase sample size"),
    correct = 2,
    explanation = "Blocking groups similar units together and randomizes treatments within blocks. This removes between-block variability from the error term, increasing precision and power."
  ),
  list(
    category = "Design",
    question = "External validity refers to:",
    choices = c("Whether the study measures what it claims to measure",
                "Whether results can be generalized to other populations and settings",
                "Whether the statistical analysis was correct",
                "Whether confounds were eliminated"),
    correct = 2,
    explanation = "External validity concerns the generalizability of findings beyond the specific study context. Internal validity (causal conclusions within the study) and external validity are both important but can trade off."
  ),
  list(
    category = "Design",
    question = "A counterbalanced design is used in within-subjects experiments to control for:",
    choices = c("Individual differences",
                "Order effects (practice, fatigue, carryover)",
                "Sampling bias",
                "Measurement error"),
    correct = 2,
    explanation = "Counterbalancing varies the order of conditions across participants so that order effects are distributed equally. This prevents order from being confounded with the treatment effect."
  ),

  # --- General Concepts (additional) ---
  list(
    category = "General",
    question = "A confounding variable is one that:",
    choices = c("Is always measured in the study",
                "Is related to both the independent and dependent variable",
                "Only affects the independent variable",
                "Can always be controlled by random assignment"),
    correct = 2,
    explanation = "A confounder is associated with both the predictor and the outcome, creating a spurious association or masking a true one. Randomization helps but cannot guarantee balance on all confounders."
  ),
  list(
    category = "General",
    question = "The ecological fallacy occurs when:",
    choices = c("Conclusions about individuals are drawn from group-level data",
                "Environmental factors are ignored",
                "Sample sizes are too small",
                "The study lacks a control group"),
    correct = 1,
    explanation = "The ecological fallacy assumes that relationships observed at an aggregate level apply to individuals. Group-level correlations can be very different from individual-level correlations."
  ),
  list(
    category = "General",
    question = "MCAR (Missing Completely At Random) means:",
    choices = c("Missingness depends on observed variables",
                "Missingness depends on the missing values themselves",
                "The probability of being missing is the same for all observations",
                "Data can be safely deleted without bias"),
    correct = 3,
    explanation = "MCAR means missingness is unrelated to any variable (observed or unobserved). Under MCAR, complete-case analysis is unbiased (though less efficient). MCAR is the strongest and rarest assumption."
  ),
  list(
    category = "General",
    question = "The Box-Cox transformation is used to:",
    choices = c("Standardize variables to mean 0 and SD 1",
                "Find the power transformation that best normalizes the data",
                "Convert categorical variables to numeric",
                "Remove outliers"),
    correct = 2,
    explanation = "Box-Cox finds the optimal power lambda such that y^lambda (or log y when lambda = 0) best approximates normality. It is useful for stabilizing variance and improving linearity."
  ),
  list(
    category = "General",
    question = "Propensity score matching is used to:",
    choices = c("Increase sample size",
                "Reduce confounding in observational studies by matching treated and control units",
                "Test for effect modification",
                "Estimate the reliability of a measure"),
    correct = 2,
    explanation = "Propensity scores estimate the probability of receiving treatment given covariates. Matching on propensity scores creates groups that are balanced on observed confounders, approximating a randomized experiment."
  ),
  list(
    category = "General",
    question = "Survivorship bias occurs when:",
    choices = c("Participants die during the study",
                "Only successful or surviving cases are analyzed, ignoring those that dropped out or failed",
                "The study runs for too long",
                "Mortality rates are used as an outcome"),
    correct = 2,
    explanation = "Survivorship bias arises when analysis is restricted to cases that 'survived' some selection process. Classic example: studying only successful companies to find success factors, ignoring failed companies with the same traits."
  ),

  # =====================================================================
  # EXPANDED ITEM BANK — ROUND 2
  # =====================================================================

  # --- Distributions ---
  list(
    category = "Distributions",
    question = "The normal distribution is fully characterized by which two parameters?",
    choices = c("Skewness and kurtosis",
                "Mean and standard deviation",
                "Median and interquartile range",
                "Mode and range"),
    correct = 2,
    explanation = "The normal distribution is defined entirely by its mean (center) and standard deviation (spread). All other properties (symmetry, specific quantiles) follow from these two parameters."
  ),
  list(
    category = "Distributions",
    question = "If X follows a standard normal distribution, then X-squared follows a:",
    choices = c("Normal distribution",
                "t-distribution with 1 df",
                "Chi-square distribution with 1 df",
                "F-distribution with 1 and 1 df"),
    correct = 3,
    explanation = "The chi-square distribution with k degrees of freedom is defined as the sum of k independent squared standard normal variables. So a single squared Z gives chi-square(1)."
  ),
  list(
    category = "Distributions",
    question = "The median of a right-skewed distribution is typically:",
    choices = c("Greater than the mean",
                "Equal to the mean",
                "Less than the mean",
                "Equal to the mode"),
    correct = 3,
    explanation = "In a right-skewed distribution, the long right tail pulls the mean upward, so the mean exceeds the median. The mode is typically the smallest of the three."
  ),
  list(
    category = "Distributions",
    question = "A Bernoulli distribution is a special case of the binomial distribution where:",
    choices = c("p = 0.5",
                "n = 1 (a single trial)",
                "The outcomes are continuous",
                "There are more than two outcomes"),
    correct = 2,
    explanation = "The Bernoulli distribution models a single binary trial (success/failure). The binomial is the sum of n independent Bernoulli trials with the same probability of success."
  ),
  list(
    category = "Distributions",
    question = "The 68-95-99.7 rule applies to which distribution?",
    choices = c("Any symmetric distribution",
                "The normal distribution",
                "The t-distribution",
                "Any unimodal distribution"),
    correct = 2,
    explanation = "The empirical rule states that approximately 68%, 95%, and 99.7% of data fall within 1, 2, and 3 standard deviations of the mean, respectively, specifically for normal distributions."
  ),

  # --- Sampling ---
  list(
    category = "Sampling",
    question = "Non-response bias occurs when:",
    choices = c("The survey questions are poorly worded",
                "People who don't respond differ systematically from those who do",
                "The sample size is too small",
                "The population is too large to sample"),
    correct = 2,
    explanation = "If non-respondents have different characteristics than respondents (e.g., sicker patients are less likely to complete a health survey), the resulting sample is biased regardless of the original sampling method."
  ),
  list(
    category = "Sampling",
    question = "Convenience sampling is problematic because:",
    choices = c("It always produces small samples",
                "It is too expensive",
                "The sample may not be representative of the target population",
                "It requires a sampling frame"),
    correct = 3,
    explanation = "Convenience samples (e.g., college students, social media followers) are drawn from easily accessible groups, which may differ systematically from the target population on key variables."
  ),
  list(
    category = "Sampling",
    question = "If you quadruple the sample size, the standard error of the mean is:",
    choices = c("Quartered",
                "Halved",
                "Unchanged",
                "Doubled"),
    correct = 2,
    explanation = "SE = SD/sqrt(n). If n is multiplied by 4, sqrt(n) doubles, so SE is halved. Reducing SE further requires increasingly large sample sizes — this is the law of diminishing returns."
  ),
  list(
    category = "Sampling",
    question = "Systematic sampling involves:",
    choices = c("Selecting every kth element from a list after a random start",
                "Dividing the population into subgroups and sampling from each",
                "Randomly selecting clusters",
                "Selecting participants based on convenience"),
    correct = 1,
    explanation = "In systematic sampling, you select every kth element (e.g., every 10th person) from an ordered list, starting from a randomly chosen point. It approximates SRS if the list has no periodic patterns."
  ),

  # --- Inference ---
  list(
    category = "Inference",
    question = "The null hypothesis in a chi-square test of independence states that:",
    choices = c("The two variables are correlated",
                "The observed frequencies equal the expected frequencies under independence",
                "The sample size is sufficient",
                "The variables are normally distributed"),
    correct = 2,
    explanation = "The chi-square test of independence tests whether two categorical variables are associated. The null hypothesis is that they are independent — observed cell counts match what we'd expect by chance."
  ),
  list(
    category = "Inference",
    question = "Effect size is important because:",
    choices = c("It determines the p-value",
                "It quantifies the magnitude of a result, independent of sample size",
                "It replaces the need for hypothesis testing",
                "It is always larger than 1"),
    correct = 2,
    explanation = "P-values conflate effect size with sample size — a tiny effect can be 'significant' with enough data. Effect sizes tell you how large or meaningful the difference or relationship actually is."
  ),
  list(
    category = "Inference",
    question = "A one-tailed test is appropriate when:",
    choices = c("You want more power",
                "You have a strong directional hypothesis specified before data collection",
                "The data are skewed",
                "You have a large sample"),
    correct = 2,
    explanation = "One-tailed tests are justified only when you have a pre-specified directional prediction and are genuinely uninterested in effects in the other direction. They should not be used post hoc to get smaller p-values."
  ),
  list(
    category = "Inference",
    question = "The Mann-Whitney U test is the nonparametric alternative to:",
    choices = c("Paired t-test",
                "One-way ANOVA",
                "Independent samples t-test",
                "Chi-square test"),
    correct = 3,
    explanation = "The Mann-Whitney U (also called Wilcoxon rank-sum) test compares two independent groups using ranks rather than means. It tests whether one group tends to have larger values than the other."
  ),
  list(
    category = "Inference",
    question = "Eta-squared in ANOVA represents:",
    choices = c("The probability of a Type I error",
                "The proportion of total variance explained by the grouping variable",
                "The number of groups",
                "The within-group variance"),
    correct = 2,
    explanation = "Eta-squared = SS_between / SS_total. It is an effect size measure showing what fraction of total variability is attributable to group differences. Partial eta-squared is more common in factorial designs."
  ),
  list(
    category = "Inference",
    question = "Fisher's exact test is preferred over the chi-square test when:",
    choices = c("The sample size is very large",
                "Expected cell counts are small (below 5)",
                "There are more than two groups",
                "The variables are ordinal"),
    correct = 2,
    explanation = "The chi-square test relies on a large-sample approximation that breaks down with small expected frequencies. Fisher's exact test computes exact probabilities and is appropriate for small samples."
  ),

  # --- Modeling ---
  list(
    category = "Modeling",
    question = "The VIF (Variance Inflation Factor) measures:",
    choices = c("How much the variance of a coefficient is inflated due to collinearity",
                "The overall fit of the model",
                "Heteroscedasticity in residuals",
                "The influence of individual observations"),
    correct = 1,
    explanation = "VIF quantifies how much the variance of a regression coefficient increases due to correlation with other predictors. VIF > 5 or 10 is commonly flagged as problematic multicollinearity."
  ),
  list(
    category = "Modeling",
    question = "Adjusted R-squared differs from R-squared in that it:",
    choices = c("Is always larger",
                "Penalizes for the number of predictors in the model",
                "Can only increase when variables are added",
                "Measures predictive accuracy on new data"),
    correct = 2,
    explanation = "R-squared never decreases when predictors are added, even useless ones. Adjusted R-squared includes a penalty for model complexity, and can decrease if an added predictor doesn't improve fit sufficiently."
  ),
  list(
    category = "Modeling",
    question = "In logistic regression, the odds ratio for a predictor represents:",
    choices = c("The probability of the outcome",
                "The multiplicative change in odds for a one-unit increase in the predictor",
                "The slope of the regression line",
                "The proportion of variance explained"),
    correct = 2,
    explanation = "The odds ratio = exp(beta). An OR of 2 means the odds of the outcome double for each one-unit increase in the predictor. OR > 1 indicates a positive association; OR < 1 indicates negative."
  ),
  list(
    category = "Modeling",
    question = "BIC (Bayesian Information Criterion) differs from AIC in that BIC:",
    choices = c("Does not penalize for complexity",
                "Applies a stronger penalty for the number of parameters, especially with large n",
                "Is always smaller than AIC",
                "Only works for Bayesian models"),
    correct = 2,
    explanation = "BIC penalty = k * ln(n) vs. AIC penalty = 2k. For n > 8, BIC penalizes complexity more heavily, favoring simpler models. BIC is consistent (selects the true model asymptotically) while AIC tends to overfit."
  ),
  list(
    category = "Modeling",
    question = "An interaction term in regression (X1 * X2) means:",
    choices = c("X1 and X2 are added separately",
                "The effect of X1 on Y depends on the value of X2",
                "X1 and X2 are perfectly correlated",
                "The model is non-linear in parameters"),
    correct = 2,
    explanation = "An interaction term allows the slope of one predictor to vary across levels of another. The model is still linear in parameters (Y = b0 + b1*X1 + b2*X2 + b3*X1*X2) even though the relationship with individual predictors is not additive."
  ),
  list(
    category = "Modeling",
    question = "Elastic Net regression combines:",
    choices = c("Ridge and Lasso penalties",
                "Forward and backward selection",
                "OLS and robust regression",
                "Linear and nonlinear terms"),
    correct = 1,
    explanation = "Elastic Net uses a weighted combination of L1 (Lasso) and L2 (Ridge) penalties. This allows both variable selection (from L1) and handling of correlated predictors (from L2)."
  ),
  list(
    category = "Modeling",
    question = "Maximum Likelihood Estimation (MLE) finds parameter values that:",
    choices = c("Minimize the sum of squared residuals",
                "Maximize the probability of observing the collected data",
                "Minimize prediction error on new data",
                "Maximize the prior probability"),
    correct = 2,
    explanation = "MLE selects parameters that make the observed data most probable under the assumed model. It is the foundation for logistic regression, Poisson regression, and many other models beyond OLS."
  ),

  # --- Assumptions ---
  list(
    category = "Assumptions",
    question = "Homoscedasticity can be assessed visually by examining:",
    choices = c("A histogram of the outcome variable",
                "A plot of residuals vs. fitted values",
                "A Q-Q plot",
                "A bar chart of group means"),
    correct = 2,
    explanation = "In a residuals vs. fitted plot, homoscedasticity appears as a constant band of scatter. A funnel shape (widening or narrowing) indicates heteroscedasticity."
  ),
  list(
    category = "Assumptions",
    question = "The Durbin-Watson test detects:",
    choices = c("Non-normality of residuals",
                "Multicollinearity among predictors",
                "Autocorrelation in residuals",
                "Outliers in the data"),
    correct = 3,
    explanation = "Durbin-Watson tests for first-order autocorrelation in regression residuals. Values near 2 indicate no autocorrelation; values near 0 indicate positive autocorrelation; near 4 indicate negative."
  ),
  list(
    category = "Assumptions",
    question = "Robust standard errors (sandwich estimators) are used when:",
    choices = c("The sample size is very small",
                "Residuals show heteroscedasticity or clustering",
                "The model has too many predictors",
                "The outcome is binary"),
    correct = 2,
    explanation = "Robust (heteroscedasticity-consistent) standard errors provide valid inference even when the constant-variance assumption fails. They correct the SEs without changing the coefficient estimates."
  ),
  list(
    category = "Assumptions",
    question = "The assumption of linearity in regression can be checked with:",
    choices = c("A scatter plot of residuals vs. each predictor",
                "Cronbach's alpha",
                "A chi-square test",
                "The Kolmogorov-Smirnov test"),
    correct = 1,
    explanation = "Plotting residuals against each predictor (or fitted values) reveals whether systematic curvature exists. If linearity holds, residuals should show no pattern — just random scatter around zero."
  ),

  # --- Psychometrics ---
  list(
    category = "Psychometrics",
    question = "The 3PL IRT model adds which parameter compared to the 2PL?",
    choices = c("A difficulty parameter",
                "A discrimination parameter",
                "A guessing (pseudo-chance) parameter",
                "An upper asymptote parameter"),
    correct = 3,
    explanation = "The 3PL adds a lower asymptote (guessing) parameter c, representing the probability of a correct response for very low-ability examinees. 1PL has only difficulty; 2PL adds discrimination."
  ),
  list(
    category = "Psychometrics",
    question = "Item-total correlation is used to identify items that:",
    choices = c("Are too easy",
                "Do not discriminate well between high and low scorers",
                "Have DIF",
                "Are too time-consuming"),
    correct = 2,
    explanation = "Low item-total correlations indicate an item is not aligned with what the rest of the test measures. Items with negative or near-zero correlations are candidates for removal or revision."
  ),
  list(
    category = "Psychometrics",
    question = "The standard error of measurement (SEM) in CTT is calculated as:",
    choices = c("SD * sqrt(reliability)",
                "SD * sqrt(1 - reliability)",
                "Mean / sqrt(n)",
                "SD / sqrt(n)"),
    correct = 2,
    explanation = "SEM = SD * sqrt(1 - rxx), where rxx is reliability. Higher reliability means smaller SEM and more precise individual scores. Unlike IRT, CTT assumes SEM is constant across all score levels."
  ),
  list(
    category = "Psychometrics",
    question = "The Graded Response Model (GRM) is used for items with:",
    choices = c("Dichotomous responses only",
                "Ordered polytomous response categories",
                "Nominal (unordered) response categories",
                "Continuous responses"),
    correct = 2,
    explanation = "The GRM extends the 2PL to items with ordered categories (e.g., Likert scales). It models the probability of responding in each category as a function of ability using cumulative boundary curves."
  ),
  list(
    category = "Psychometrics",
    question = "Test equating is necessary when:",
    choices = c("A test is administered to the same group twice",
                "Different forms of a test need to yield comparable scores",
                "Items are being field-tested",
                "The test is too long"),
    correct = 2,
    explanation = "Equating adjusts scores from different test forms so they can be used interchangeably. It requires the forms to measure the same construct at similar difficulty, and uses common items or common examinees as anchors."
  ),
  list(
    category = "Psychometrics",
    question = "Generalizability theory extends classical test theory by:",
    choices = c("Using IRT models instead of CTT",
                "Partitioning error variance into multiple sources (facets) simultaneously",
                "Eliminating the need for reliability estimates",
                "Using only binary items"),
    correct = 2,
    explanation = "G-theory uses ANOVA-based variance decomposition to separate error into distinct facets (e.g., raters, occasions, items). This gives more nuanced reliability information than a single CTT coefficient."
  ),

  # --- Machine Learning ---
  list(
    category = "Machine Learning",
    question = "Regularization in machine learning serves to:",
    choices = c("Speed up training time",
                "Increase model complexity",
                "Prevent overfitting by constraining model parameters",
                "Ensure the data are normally distributed"),
    correct = 3,
    explanation = "Regularization adds a penalty for large parameter values, discouraging the model from fitting noise. Common forms include L1 (Lasso), L2 (Ridge), and dropout (for neural networks)."
  ),
  list(
    category = "Machine Learning",
    question = "In a confusion matrix, precision is defined as:",
    choices = c("TP / (TP + FN)",
                "TP / (TP + FP)",
                "TN / (TN + FP)",
                "(TP + TN) / Total"),
    correct = 2,
    explanation = "Precision = TP / (TP + FP) — of all positive predictions, how many are actually positive. Recall (sensitivity) = TP / (TP + FN) — of all actual positives, how many were detected."
  ),
  list(
    category = "Machine Learning",
    question = "Bagging (Bootstrap Aggregating) reduces prediction error primarily by:",
    choices = c("Reducing bias",
                "Reducing variance through averaging multiple models",
                "Increasing model complexity",
                "Removing outliers from the data"),
    correct = 2,
    explanation = "Bagging trains multiple models on bootstrap samples and averages their predictions. This reduces variance (instability) while keeping bias roughly the same, leading to better overall prediction."
  ),
  list(
    category = "Machine Learning",
    question = "The AUC (Area Under the ROC Curve) ranges from:",
    choices = c("-1 to 1",
                "0 to 1",
                "0 to infinity",
                "-infinity to infinity"),
    correct = 2,
    explanation = "AUC ranges from 0 to 1. AUC = 0.5 means the model performs no better than random guessing; AUC = 1.0 means perfect discrimination. AUC below 0.5 indicates predictions worse than chance."
  ),
  list(
    category = "Machine Learning",
    question = "Support Vector Machines (SVM) find the decision boundary that:",
    choices = c("Minimizes the number of support vectors",
                "Maximizes the margin between classes",
                "Minimizes the total distance to all points",
                "Passes through the class centroids"),
    correct = 2,
    explanation = "SVM finds the hyperplane that maximizes the margin (distance) between the nearest points of different classes (the support vectors). Larger margins generally lead to better generalization."
  ),
  list(
    category = "Machine Learning",
    question = "Boosting algorithms (e.g., XGBoost) improve performance by:",
    choices = c("Training models in parallel on random subsets",
                "Sequentially fitting models that focus on previously misclassified cases",
                "Using only the best-performing features",
                "Increasing the learning rate over time"),
    correct = 2,
    explanation = "Boosting builds models sequentially, with each new model giving more weight to observations the previous models got wrong. This primarily reduces bias, complementing bagging which reduces variance."
  ),

  # --- Multivariate ---
  list(
    category = "Multivariate",
    question = "Oblique rotation in factor analysis differs from orthogonal rotation in that it:",
    choices = c("Produces uncorrelated factors",
                "Allows factors to be correlated",
                "Always produces a better fit",
                "Requires normally distributed data"),
    correct = 2,
    explanation = "Orthogonal rotations (e.g., varimax) constrain factors to be uncorrelated. Oblique rotations (e.g., promax, oblimin) allow correlations between factors, which is often more realistic."
  ),
  list(
    category = "Multivariate",
    question = "Parallel analysis determines the number of factors by comparing eigenvalues to:",
    choices = c("The Kaiser criterion of 1.0",
                "Eigenvalues from random data of the same dimensions",
                "The total variance",
                "Factor loadings"),
    correct = 2,
    explanation = "Parallel analysis generates many random datasets with the same n and p, computes their eigenvalues, and retains factors only when actual eigenvalues exceed the 95th percentile of random eigenvalues."
  ),
  list(
    category = "Multivariate",
    question = "In SEM, a latent variable is:",
    choices = c("A variable that is directly measured",
                "An unobserved construct inferred from observed indicators",
                "A variable with missing data",
                "A categorical predictor"),
    correct = 2,
    explanation = "Latent variables represent theoretical constructs (e.g., intelligence, anxiety) that cannot be measured directly but are inferred from multiple observed indicators through the measurement model."
  ),
  list(
    category = "Multivariate",
    question = "The scree plot helps determine the number of factors by showing:",
    choices = c("Factor loadings for each variable",
                "Eigenvalues plotted in descending order, looking for an 'elbow'",
                "The correlation matrix",
                "Communalities for each variable"),
    correct = 2,
    explanation = "The scree plot displays eigenvalues in descending order. The 'elbow' — where the curve levels off — suggests the transition from meaningful factors to noise. Factors above the elbow are retained."
  ),
  list(
    category = "Multivariate",
    question = "Communality in factor analysis represents:",
    choices = c("The total variance in the dataset",
                "The proportion of a variable's variance explained by the retained factors",
                "The correlation between factors",
                "The number of factors"),
    correct = 2,
    explanation = "Communality is the sum of squared loadings for a variable across all retained factors. High communality means the factors account for most of that variable's variance; low communality means it is poorly represented."
  ),

  # --- Design ---
  list(
    category = "Design",
    question = "A Latin square design controls for:",
    choices = c("One nuisance factor",
                "Two nuisance factors simultaneously",
                "Three or more nuisance factors",
                "No nuisance factors"),
    correct = 2,
    explanation = "A Latin square balances treatments across two blocking factors (rows and columns). Each treatment appears exactly once in each row and column, controlling for both nuisance variables."
  ),
  list(
    category = "Design",
    question = "Statistical power is affected by all of the following EXCEPT:",
    choices = c("Sample size",
                "Effect size",
                "The name of the statistical test used",
                "Alpha level"),
    correct = 3,
    explanation = "Power depends on sample size (larger = more power), effect size (larger = more power), alpha level (larger = more power), and the specific test's efficiency. The name or label of the test is irrelevant."
  ),
  list(
    category = "Design",
    question = "A matched-pairs design is most useful when:",
    choices = c("There are many treatment conditions",
                "Individual differences are a large source of variability",
                "The outcome is categorical",
                "Blinding is impossible"),
    correct = 2,
    explanation = "Matching pairs subjects on key characteristics and assigning one of each pair to treatment vs. control removes between-pair variability, increasing power when individual differences are large."
  ),
  list(
    category = "Design",
    question = "In a 2x3 factorial design, there are:",
    choices = c("5 conditions",
                "6 conditions",
                "8 conditions",
                "23 conditions"),
    correct = 2,
    explanation = "A 2x3 factorial crosses 2 levels of one factor with 3 levels of another, yielding 2*3 = 6 unique conditions. Each participant (or unit) is assigned to one of these 6 cells."
  ),

  # --- General ---
  list(
    category = "General",
    question = "Correlation does not imply causation because:",
    choices = c("Correlations are always weak",
                "A third variable could cause both, or the direction could be reversed",
                "Correlation only works with normal data",
                "Causation requires a p-value below 0.01"),
    correct = 2,
    explanation = "Observed correlations can be driven by confounding variables, reverse causation, or coincidence. Establishing causation typically requires experimental manipulation, temporal precedence, and ruling out alternative explanations."
  ),
  list(
    category = "General",
    question = "Publication bias refers to:",
    choices = c("Authors publishing too many papers",
                "The tendency for studies with significant results to be published more often",
                "Journals rejecting all qualitative research",
                "Plagiarism in academic publishing"),
    correct = 2,
    explanation = "Publication bias creates a distorted literature where significant findings are overrepresented. This inflates apparent effect sizes and can make ineffective interventions appear effective."
  ),
  list(
    category = "General",
    question = "The Bonferroni correction becomes very conservative when:",
    choices = c("The sample size is large",
                "The number of comparisons is large",
                "The effect sizes are large",
                "The data are normally distributed"),
    correct = 2,
    explanation = "With many comparisons, Bonferroni divides alpha by a large number, making each individual test very stringent. This greatly reduces power. Alternatives like Holm or FDR control are often preferred."
  ),
  list(
    category = "General",
    question = "The False Discovery Rate (FDR) controls:",
    choices = c("The probability of any false positive",
                "The expected proportion of false positives among rejected hypotheses",
                "The total number of Type II errors",
                "The overall significance level"),
    correct = 2,
    explanation = "FDR (e.g., Benjamini-Hochberg procedure) controls the expected proportion of false discoveries among all discoveries. It is less conservative than FWER control (Bonferroni) and more powerful with many tests."
  ),
  list(
    category = "General",
    question = "Multiple imputation handles missing data by:",
    choices = c("Deleting all rows with missing values",
                "Replacing missing values with the mean",
                "Creating several plausible datasets, analyzing each, and pooling results",
                "Using only complete cases"),
    correct = 3,
    explanation = "Multiple imputation generates m complete datasets reflecting uncertainty about missing values, analyzes each separately, then pools estimates using Rubin's rules. This preserves variability and produces valid standard errors."
  ),
  list(
    category = "General",
    question = "Multivariate outliers can be detected using:",
    choices = c("Univariate histograms only",
                "Mahalanobis distance",
                "The mean of each variable",
                "Cronbach's alpha"),
    correct = 2,
    explanation = "Mahalanobis distance measures how far an observation is from the centroid of the data in multivariate space, accounting for correlations. Points may be multivariate outliers even if they look normal on each variable individually."
  ),
  list(
    category = "General",
    question = "An intention-to-treat (ITT) analysis:",
    choices = c("Only includes participants who completed the treatment",
                "Analyzes participants according to their assigned group regardless of compliance",
                "Removes dropouts from the analysis",
                "Is only used in observational studies"),
    correct = 2,
    explanation = "ITT preserves the benefits of randomization by analyzing everyone as assigned, even if they didn't complete treatment. It provides a pragmatic estimate of effectiveness and avoids bias from differential dropout."
  ),

  # --- Mediation & Moderation ---
  list(
    category = "Mediation & Moderation",
    question = "In mediation analysis, the indirect effect is calculated as:",
    choices = c("c - c'",
                "a * b",
                "a + b",
                "Both A and B are equivalent in linear models"),
    correct = 4,
    explanation = "The indirect effect can be computed either as a*b (product of paths) or as c - c' (difference between total and direct effects). In linear models, these are mathematically equivalent."
  ),
  list(
    category = "Mediation & Moderation",
    question = "Bootstrap confidence intervals are preferred over the Sobel test for mediation because:",
    choices = c("They are easier to compute",
                "The sampling distribution of the indirect effect is often skewed, violating the Sobel test's normality assumption",
                "They always give narrower intervals",
                "They don't require any assumptions"),
    correct = 2,
    explanation = "The product a*b is often non-normally distributed, especially in small samples. The Sobel test assumes normality of a*b, while bootstrap CIs make no such assumption and better capture the skewed shape."
  ),
  list(
    category = "Mediation & Moderation",
    question = "Full mediation occurs when:",
    choices = c("The direct effect (c') is significant and the indirect is not",
                "Both a and b paths are non-significant",
                "The indirect effect (a*b) is significant and the direct effect (c') is approximately zero",
                "The total effect (c) equals zero"),
    correct = 3,
    explanation = "Full mediation means X affects Y entirely through M — the indirect effect is significant while the direct effect is negligible. Partial mediation means both direct and indirect paths are significant."
  ),
  list(
    category = "Mediation & Moderation",
    question = "Moderation (interaction) is present when:",
    choices = c("A mediator explains the relationship between X and Y",
                "The effect of X on Y differs depending on the level of another variable",
                "X and Y are not correlated",
                "The sample size is large enough"),
    correct = 2,
    explanation = "Moderation means the relationship between X and Y is conditional on a third variable W. Statistically, this is tested via the interaction term X*W in regression."
  ),
  list(
    category = "Mediation & Moderation",
    question = "In simple slopes analysis, the effect of X on Y is typically probed at:",
    choices = c("W = 0 only",
                "Every observed value of W",
                "The mean of W and one SD above and below the mean",
                "The minimum and maximum of W"),
    correct = 3,
    explanation = "The conventional approach probes the conditional effect of X at W = mean, mean + 1 SD, and mean - 1 SD. This is sometimes called 'pick-a-point' analysis."
  ),
  list(
    category = "Mediation & Moderation",
    question = "The Johnson-Neyman technique improves on simple slopes by:",
    choices = c("Using a larger sample",
                "Finding the exact moderator values where the conditional effect becomes significant",
                "Eliminating the need for an interaction term",
                "Testing mediation instead of moderation"),
    correct = 2,
    explanation = "Instead of probing at arbitrary W values (like mean +/- 1 SD), the J-N technique identifies the precise W value(s) where the conditional effect transitions from significant to non-significant."
  ),
  list(
    category = "Mediation & Moderation",
    question = "The index of moderated mediation tests whether:",
    choices = c("The total effect is significant",
                "The indirect effect significantly varies across levels of the moderator",
                "The moderator is normally distributed",
                "The mediator and moderator are correlated"),
    correct = 2,
    explanation = "The index of moderated mediation equals a_mod * b (where a_mod is the interaction in the M model). If its bootstrap CI excludes zero, the strength of mediation significantly depends on the moderator."
  ),
  list(
    category = "Mediation & Moderation",
    question = "Why should predictors be centered before testing interactions?",
    choices = c("It reduces multicollinearity and makes main effects interpretable at the mean of the other variable",
                "It eliminates the interaction effect",
                "It is required for the F-test to be valid",
                "It changes the interaction coefficient"),
    correct = 1,
    explanation = "Centering reduces correlation between main effects and the interaction term, and makes main effect coefficients interpretable as effects at the mean of the other predictor (rather than at zero, which may be meaningless)."
  ),

# --- Causal Inference ---
  list(
    category = "Causal Inference",
    question = "In a DAG, what happens when you condition on a collider?",
    choices = c("It removes confounding bias",
                "It opens a spurious path between the collider's parents",
                "It blocks the causal path",
                "It has no effect on the estimates"),
    correct = 2,
    explanation = "A collider blocks a path by default. Conditioning on (adjusting for) a collider opens a spurious association between its parent nodes, introducing bias rather than removing it."
  ),
  list(
    category = "Causal Inference",
    question = "The back-door criterion requires that the adjustment set:",
    choices = c("Includes all available covariates",
                "Blocks all back-door paths from treatment to outcome without opening new paths through colliders",
                "Contains only variables measured before treatment",
                "Includes the outcome variable"),
    correct = 2,
    explanation = "Pearl's back-door criterion states that a set of variables Z is sufficient for causal identification if Z blocks every path from X to Y that contains an arrow into X, and Z does not include any descendant of X."
  ),
  list(
    category = "Causal Inference",
    question = "What is the key assumption of propensity score methods?",
    choices = c("Treatment effects are constant across individuals",
                "The outcome is normally distributed",
                "There are no unmeasured confounders (ignorability/conditional independence)",
                "The propensity score must follow a logistic distribution"),
    correct = 3,
    explanation = "Propensity score methods assume that, conditional on measured covariates, treatment assignment is independent of potential outcomes. If unmeasured confounders exist, propensity score methods will still produce biased estimates."
  ),
  list(
    category = "Causal Inference",
    question = "In a Love plot, what does a standardized mean difference below 0.1 after matching indicate?",
    choices = c("The treatment effect is small",
                "The matching achieved good covariate balance between groups",
                "The sample size is too small",
                "The propensity score model is misspecified"),
    correct = 2,
    explanation = "A Love plot shows absolute standardized mean differences (SMD) for each covariate before and after matching. SMDs below 0.1 indicate that the groups are well-balanced on that covariate, suggesting successful matching."
  ),
  list(
    category = "Causal Inference",
    question = "The key identifying assumption of difference-in-differences is:",
    choices = c("Treatment is randomly assigned",
                "The outcome is stationary over time",
                "Parallel trends: both groups would have followed the same trajectory without treatment",
                "No spillover effects between groups"),
    correct = 3,
    explanation = "DiD assumes that in the absence of treatment, the treatment and control groups would have experienced the same change over time (parallel trends). This assumption is untestable but can be assessed with pre-treatment data."
  ),
  list(
    category = "Causal Inference",
    question = "In a regression discontinuity design, what does the LATE estimate?",
    choices = c("The average treatment effect for all units",
                "The treatment effect for units at the cutoff of the running variable",
                "The treatment effect for the treated group only",
                "The intent-to-treat effect across the full sample"),
    correct = 2,
    explanation = "In a sharp RDD, the local average treatment effect (LATE) is the causal effect at the cutoff. It applies to units near the threshold, not to the entire population, making it a local rather than global estimate."
  ),
  list(
    category = "Causal Inference",
    question = "Why is the first-stage F-statistic important in instrumental variables analysis?",
    choices = c("It tests whether the outcome model is significant",
                "It measures the strength of the instrument — weak instruments (F < 10) lead to biased and unreliable IV estimates",
                "It determines if the exclusion restriction holds",
                "It checks for heteroscedasticity in the errors"),
    correct = 2,
    explanation = "The first-stage F-statistic tests whether the instrument is sufficiently correlated with the endogenous variable (relevance condition). The rule of thumb is F > 10; below this, 2SLS estimates can be more biased than OLS and confidence intervals have poor coverage."
  ),
  list(
    category = "Causal Inference",
    question = "Which three conditions must a valid instrument satisfy?",
    choices = c("Relevance, independence, and exclusion restriction",
                "Normality, homoscedasticity, and linearity",
                "Balance, overlap, and positivity",
                "Consistency, exchangeability, and positivity"),
    correct = 1,
    explanation = "A valid instrument must be (1) relevant — correlated with the endogenous variable, (2) independent — uncorrelated with unmeasured confounders, and (3) satisfy the exclusion restriction — it affects the outcome only through the endogenous variable."
  ),
  list(
    category = "Causal Inference",
    question = "In a difference-in-differences regression Y = b0 + b1*Treat + b2*Post + b3*(Treat*Post), which coefficient is the DiD estimate?",
    choices = c("b0 (intercept)",
                "b1 (treatment group indicator)",
                "b2 (post-period indicator)",
                "b3 (interaction term)"),
    correct = 4,
    explanation = "The interaction term b3 captures the differential change in the treatment group relative to the control group from pre to post — this is the DiD estimator of the treatment effect."
  ),
  list(
    category = "Causal Inference",
    question = "Why should you avoid using high-order polynomials in regression discontinuity designs?",
    choices = c("They always underfit the data near the cutoff",
                "They can create artificial jumps at the cutoff and are sensitive to observations far from the cutoff",
                "They violate the exclusion restriction",
                "They are computationally too expensive"),
    correct = 2,
    explanation = "Gelman and Imbens (2019) showed that high-order polynomial RD estimators are noisy, can produce misleading confidence intervals, and are sensitive to data far from the cutoff. Local linear regression within a bandwidth is preferred."
  ),

# --- Time Series ---
  list(
    category = "Time Series",
    question = "A stationary time series has which property?",
    choices = c("Its values are always positive",
                "Its mean, variance, and autocorrelation structure do not change over time",
                "It has no autocorrelation",
                "It always reverts to zero"),
    correct = 2,
    explanation = "Stationarity means the statistical properties of the series (mean, variance, autocovariance) are constant over time. This does not mean values are constant — just that the generating process is stable."
  ),
  list(
    category = "Time Series",
    question = "For an AR(1) process, the PACF typically shows:",
    choices = c("Gradual exponential decay",
                "A single significant spike at lag 1, then cuts off",
                "Significant spikes at all lags",
                "No significant spikes at any lag"),
    correct = 2,
    explanation = "The PACF of an AR(p) process cuts off after lag p. For AR(1), there is one significant spike at lag 1 and all higher lags are near zero. The ACF, by contrast, decays exponentially."
  ),
  list(
    category = "Time Series",
    question = "What does differencing a time series accomplish?",
    choices = c("It removes autocorrelation entirely",
                "It transforms a non-stationary series into a stationary one by removing trends or unit roots",
                "It doubles the length of the series",
                "It smooths out random noise"),
    correct = 2,
    explanation = "First differencing (Y_t - Y_{t-1}) removes a linear trend or unit root, often converting a non-stationary series to a stationary one. This is the 'd' in ARIMA(p,d,q)."
  ),
  list(
    category = "Time Series",
    question = "In STL decomposition, what are the three components?",
    choices = c("Mean, variance, and skewness",
                "Trend, seasonal, and remainder",
                "AR, MA, and differencing",
                "Level, slope, and curvature"),
    correct = 2,
    explanation = "STL (Seasonal-Trend decomposition using LOESS) decomposes a time series into Trend (long-term movement), Seasonal (repeating pattern), and Remainder (residual noise). It assumes an additive model: Y = T + S + R."
  ),
  list(
    category = "Time Series",
    question = "The Augmented Dickey-Fuller (ADF) test's null hypothesis is:",
    choices = c("The series is stationary",
                "The series has a unit root (is non-stationary)",
                "The series has no autocorrelation",
                "The series is normally distributed"),
    correct = 2,
    explanation = "The ADF test has H0: the series has a unit root (non-stationary). A small p-value leads to rejecting H0, providing evidence that the series is stationary."
  ),
  list(
    category = "Time Series",
    question = "In ARIMA(p,d,q), what does the 'q' parameter represent?",
    choices = c("The number of autoregressive terms",
                "The number of times the series is differenced",
                "The number of moving average (lagged forecast error) terms",
                "The seasonal period"),
    correct = 3,
    explanation = "In ARIMA(p,d,q), p = AR order (past values), d = differencing order, and q = MA order (past forecast errors). The MA component models short-term shocks that persist for q periods."
  ),
  list(
    category = "Time Series",
    question = "Why should forecast prediction intervals widen over time?",
    choices = c("Because the model becomes less accurate as it learns",
                "Because uncertainty accumulates — errors compound as we forecast further ahead",
                "Because the seasonal pattern gets stronger",
                "They should not widen; constant intervals are correct"),
    correct = 2,
    explanation = "Each step-ahead forecast depends on the previous forecast, so errors propagate and accumulate. The further ahead we forecast, the more uncertain we are, and prediction intervals should reflect this growing uncertainty."
  ),
  list(
    category = "Time Series",
    question = "A naive forecast uses which value as its prediction?",
    choices = c("The mean of the entire series",
                "The last observed value",
                "The median of the last 10 observations",
                "A random draw from the series distribution"),
    correct = 2,
    explanation = "The naive forecast sets all future values equal to the last observed value. It serves as an important benchmark — if a complex model cannot beat the naive forecast, the added complexity is not justified."
  ),
  list(
    category = "Time Series",
    question = "When both ACF and PACF show gradual decay, this suggests:",
    choices = c("White noise",
                "A pure AR process",
                "A pure MA process",
                "A mixed ARMA process (both AR and MA components needed)"),
    correct = 4,
    explanation = "For a pure AR(p), ACF decays and PACF cuts off. For a pure MA(q), ACF cuts off and PACF decays. When both decay gradually, neither a pure AR nor pure MA is sufficient — an ARMA(p,q) model with both components is indicated."
  ),
  list(
    category = "Time Series",
    question = "What is MAPE and when does it fail?",
    choices = c("Mean Absolute Percentage Error; it fails when actual values are zero or near zero",
                "Maximum Absolute Prediction Error; it fails with seasonal data",
                "Minimum Average Prediction Error; it fails with trending data",
                "Mean Adjusted Proportional Error; it fails with large samples"),
    correct = 1,
    explanation = "MAPE = mean(|error / actual|) * 100. It provides a scale-free accuracy measure as a percentage. However, it becomes undefined or extremely large when actual values are zero or close to zero, and it asymmetrically penalises positive vs. negative errors."
  ),

# --- Effect Size ---
  list(
    category = "Effect Size",
    question = "Cohen's d of 0.5 means the two group means differ by:",
    choices = c("0.5 raw score points",
                "Half a standard deviation",
                "50% of the control group mean",
                "5 percentage points"),
    correct = 2,
    explanation = "Cohen's d expresses the mean difference in standard deviation units. A d of 0.5 means the means are half a pooled standard deviation apart, regardless of the original measurement scale."
  ),
  list(
    category = "Effect Size",
    question = "The overlap coefficient (OVL) at d = 0 is:",
    choices = c("0%",
                "50%",
                "100%",
                "Cannot be determined"),
    correct = 3,
    explanation = "When d = 0 the two distributions are identical, so they overlap completely (100%). As d increases, overlap decreases — at d = 2, OVL is approximately 32%."
  ),
  list(
    category = "Effect Size",
    question = "The Probability of Superiority (Common Language Effect Size) represents:",
    choices = c("The p-value of a t-test",
                "The probability that a random person from Group 2 scores higher than a random person from Group 1",
                "The proportion of variance explained",
                "The percentage of the sample above the mean"),
    correct = 2,
    explanation = "The CLES (Probability of Superiority) is the probability that a randomly selected individual from the higher-scoring group will score higher than a randomly selected individual from the lower-scoring group. At d = 0, PS = 50%."
  ),
  list(
    category = "Effect Size",
    question = "To convert Cohen's d to a correlation r, which formula is used?",
    choices = c("r = d / \u221a(d\u00b2 + 4)",
                "r = d / 2",
                "r = d\u00b2 / (1 + d\u00b2)",
                "r = 1 / d"),
    correct = 1,
    explanation = "The conversion formula r = d / \u221a(d\u00b2 + 4) assumes equal group sizes and normal distributions. A d of 0.5 converts to r \u2248 0.24, and a d of 0.8 converts to r \u2248 0.37."
  ),
  list(
    category = "Effect Size",
    question = "Number Needed to Treat (NNT) is calculated as:",
    choices = c("1 / (CER \u2212 EER), where CER is the control event rate and EER is the experimental event rate",
                "Cohen's d divided by the sample size",
                "The odds ratio minus 1",
                "The p-value times the sample size"),
    correct = 1,
    explanation = "NNT = 1 / ARR, where ARR (Absolute Risk Reduction) = CER \u2212 EER. It tells you how many patients need to be treated for one additional patient to benefit. Lower NNT = more effective treatment."
  ),
  list(
    category = "Effect Size",
    question = "Why does the same Cohen's d produce different NNTs at different base rates?",
    choices = c("Because Cohen's d is not a valid effect size measure",
                "Because the absolute risk reduction depends on where on the normal curve the shift occurs",
                "Because NNT only works with binary outcomes",
                "It doesn't — NNT is always the same for a given d"),
    correct = 2,
    explanation = "A shift of d standard deviations produces a larger absolute change in event rates when the base rate is near 50% (the steepest part of the normal curve) than when it is very high or very low. Hence the same d gives different NNTs at different CERs."
  ),
  list(
    category = "Effect Size",
    question = "Cohen's benchmarks (small = 0.2, medium = 0.5, large = 0.8) should be used:",
    choices = c("As strict cutoffs for interpreting all effect sizes",
                "Only when field-specific benchmarks are not available, and with caution",
                "Only in psychology research",
                "Never — they have been disproven"),
    correct = 2,
    explanation = "Cohen himself described these benchmarks as rough guidelines when no other frame of reference exists. In practice, effect sizes should be interpreted relative to the specific domain, the practical significance of the outcome, and comparable findings in the literature."
  ),
  list(
    category = "Effect Size",
    question = "The relationship between \u03b7\u00b2 (eta-squared) and Cohen's d for two groups is approximately:",
    choices = c("\u03b7\u00b2 = d\u00b2 / (d\u00b2 + 4)",
                "\u03b7\u00b2 = d / 2",
                "\u03b7\u00b2 = d\u00b2",
                "\u03b7\u00b2 = 1 \u2212 d"),
    correct = 1,
    explanation = "For two equal-sized groups, \u03b7\u00b2 \u2248 d\u00b2 / (d\u00b2 + 4). This means a 'medium' d of 0.5 corresponds to \u03b7\u00b2 \u2248 0.06 (6% variance explained), and a 'large' d of 0.8 corresponds to \u03b7\u00b2 \u2248 0.14."
  ),

# --- Monte Carlo & Simulation ---
  list(
    category = "Monte Carlo",
    question = "In a permutation test, the p-value is calculated as:",
    choices = c("The probability of the null hypothesis being true",
                "The proportion of permuted test statistics as extreme as or more extreme than the observed statistic",
                "1 minus the power of the test",
                "The standard error divided by the test statistic"),
    correct = 2,
    explanation = "The permutation p-value is the fraction of times the reshuffled data produces a test statistic at least as extreme as the one actually observed. This directly estimates the probability of the data under the null hypothesis of no group difference."
  ),
  list(
    category = "Monte Carlo",
    question = "Under the null hypothesis (no true effect), p-values follow which distribution?",
    choices = c("Normal(0, 1)",
                "Uniform(0, 1)",
                "Chi-squared with 1 df",
                "Exponential with rate 1"),
    correct = 2,
    explanation = "Under H0, p-values are uniformly distributed between 0 and 1. This means exactly \u03b1% of p-values will fall below any threshold \u03b1 by chance alone \u2014 this is the definition of the Type I error rate."
  ),
  list(
    category = "Monte Carlo",
    question = "Monte Carlo estimation error decreases at what rate as sample size n increases?",
    choices = c("1/n (linearly)",
                "1/\u221an (square root)",
                "1/n\u00b2 (quadratically)",
                "log(n)/n"),
    correct = 2,
    explanation = "MC estimation error shrinks proportionally to 1/\u221an. This means to halve the error, you need to quadruple the number of samples. This rate is dimension-independent, which is why MC methods excel in high-dimensional problems."
  ),
  list(
    category = "Monte Carlo",
    question = "The main advantage of permutation tests over parametric tests is:",
    choices = c("They always have more power",
                "They require no distributional assumptions about the data",
                "They give smaller p-values",
                "They work only with large samples"),
    correct = 2,
    explanation = "Permutation tests are distribution-free \u2014 they don't assume normality, equal variances, or any other parametric form. They're valid for any data distribution, which makes them especially useful with skewed, heavy-tailed, or small-sample data."
  ),
  list(
    category = "Monte Carlo",
    question = "When estimating \u03c0 by dropping random points in a unit square, the estimate is:",
    choices = c("2 \u00d7 (points inside circle / total points)",
                "4 \u00d7 (points inside quarter-circle / total points)",
                "(points inside circle / total points)\u00b2",
                "Total points / points inside circle"),
    correct = 2,
    explanation = "A quarter-circle of radius 1 inscribed in a unit square has area \u03c0/4. The fraction of uniform random points landing inside the quarter-circle estimates \u03c0/4, so we multiply by 4 to estimate \u03c0."
  ),
  list(
    category = "Monte Carlo",
    question = "Simulation-based power analysis is preferred over analytic formulas when:",
    choices = c("The sample size is very large",
                "The test involves complex designs, non-normal data, or has no closed-form power solution",
                "You want to compute power for a t-test",
                "The effect size is unknown"),
    correct = 2,
    explanation = "While analytic power formulas exist for simple tests (t-test, ANOVA), simulation-based power works for any test \u2014 including mixed models, non-parametric tests, multi-stage designs, and situations with missing data or non-normal distributions."
  ),
  list(
    category = "Monte Carlo",
    question = "In the p-value distribution under the alternative hypothesis (real effect), p-values tend to:",
    choices = c("Be uniformly distributed",
                "Pile up near 1",
                "Pile up near 0",
                "Follow a normal distribution"),
    correct = 3,
    explanation = "When a real effect exists, the test statistic tends to be large, producing small p-values. The proportion of p-values below \u03b1 equals the power of the test. Larger effects and sample sizes push more p-values toward zero."
  ),
  list(
    category = "Monte Carlo",
    question = "A permutation test assumes which property of the data under the null hypothesis?",
    choices = c("Normality",
                "Equal variances",
                "Exchangeability \u2014 group labels are interchangeable",
                "Independence of all observations"),
    correct = 3,
    explanation = "Permutation tests assume that under H0, the group labels are arbitrary and can be freely shuffled. This exchangeability assumption is weaker than normality or equal variances, making permutation tests broadly applicable."
  ),

# --- Bayesian Workflow ---
  list(
    category = "Bayesian Workflow",
    question = "In Bayesian inference, the posterior distribution is proportional to:",
    choices = c("The likelihood only",
                "The prior only",
                "The likelihood multiplied by the prior",
                "The p-value multiplied by the effect size"),
    correct = 3,
    explanation = "Bayes' theorem states: Posterior \u221d Likelihood \u00d7 Prior. The posterior combines what we believed before seeing data (prior) with the evidence from the data (likelihood)."
  ),
  list(
    category = "Bayesian Workflow",
    question = "With a flat (uniform) prior and a large sample, the Bayesian posterior will:",
    choices = c("Always differ dramatically from the frequentist estimate",
                "Be dominated by the prior",
                "Closely approximate the likelihood, giving similar results to frequentist methods",
                "Be bimodal"),
    correct = 3,
    explanation = "With a flat prior, the posterior is proportional to the likelihood alone. With large samples, the likelihood becomes highly concentrated, and the posterior closely matches the MLE and its confidence interval."
  ),
  list(
    category = "Bayesian Workflow",
    question = "In the Metropolis-Hastings algorithm, what happens when the proposal SD is too small?",
    choices = c("The chain explores quickly but has high rejection rates",
                "The chain takes tiny steps, has high acceptance rates, but explores slowly (poor mixing)",
                "The chain immediately converges",
                "The posterior becomes biased"),
    correct = 2,
    explanation = "A small proposal SD means most proposals are close to the current value and get accepted, but the chain moves slowly through parameter space. This results in high autocorrelation and low effective sample size."
  ),
  list(
    category = "Bayesian Workflow",
    question = "The purpose of burn-in in MCMC is to:",
    choices = c("Speed up computation",
                "Reduce autocorrelation",
                "Discard early samples before the chain has converged to the stationary distribution",
                "Increase the acceptance rate"),
    correct = 3,
    explanation = "MCMC chains may start far from the high-probability region of the posterior. Burn-in discards these initial transient samples so that the remaining samples better represent the target posterior distribution."
  ),
  list(
    category = "Bayesian Workflow",
    question = "A posterior predictive check asks:",
    choices = c("Whether the prior is correct",
                "Whether data simulated from the fitted model look like the observed data",
                "Whether the MCMC chain has converged",
                "Whether the p-value is significant"),
    correct = 2,
    explanation = "PPC generates replicated datasets from the posterior predictive distribution. If the model fits well, these replications should be statistically indistinguishable from the observed data on key summary statistics."
  ),
  list(
    category = "Bayesian Workflow",
    question = "A 95% Bayesian credible interval means:",
    choices = c("If we repeated the experiment many times, 95% of intervals would contain the true value",
                "There is a 95% posterior probability that the parameter falls within the interval, given the data and prior",
                "The p-value is less than 0.05",
                "95% of the data falls within the interval"),
    correct = 2,
    explanation = "A credible interval has a direct probabilistic interpretation: given the observed data and prior, there is a 95% probability the parameter is in the interval. This is the interpretation people often (incorrectly) give to frequentist confidence intervals."
  ),
  list(
    category = "Bayesian Workflow",
    question = "Prior sensitivity analysis is important because:",
    choices = c("It proves the prior is correct",
                "It checks whether conclusions change under different reasonable prior choices",
                "It eliminates the need for data",
                "It maximises the posterior probability"),
    correct = 2,
    explanation = "Prior sensitivity analysis examines whether the posterior and substantive conclusions are robust to different prior specifications. If conclusions change dramatically with different reasonable priors, the data may be insufficient or the prior choice is too influential."
  ),
  list(
    category = "Bayesian Workflow",
    question = "The optimal acceptance rate for a 1-dimensional Metropolis-Hastings sampler is approximately:",
    choices = c("5%",
                "23%",
                "44%",
                "95%"),
    correct = 3,
    explanation = "For a 1-dimensional target, the theoretically optimal acceptance rate is about 44%. For higher-dimensional targets, it drops to about 23%. These rates balance exploration speed with acceptance frequency."
  ),

  # ── p-Hacking & Researcher Degrees of Freedom ─────────────
  list(
    category = "p-Hacking",
    question = "Researcher degrees of freedom refer to:",
    choices = c("The sample size minus the number of estimated parameters",
                "The many defensible analytic choices researchers make that inflate false positive rates",
                "The degrees of freedom in a chi-squared test",
                "The number of researchers on a project"),
    correct = 2,
    explanation = "Researcher degrees of freedom are the legitimate-seeming decisions made during analysis (outcome choice, exclusion criteria, covariates, test selection, transformations). Each decision creates a 'fork' in the analysis pipeline, and exploring multiple forks inflates the false positive rate."
  ),
  list(
    category = "p-Hacking",
    question = "A right-skewed p-curve (more values near 0 than near .05) suggests:",
    choices = c("The results are likely p-hacked",
                "The null hypothesis is true",
                "The findings contain genuine evidential value",
                "The sample sizes were too small"),
    correct = 3,
    explanation = "When a true effect exists, p-values cluster near 0 (right-skewed p-curve). When results come from p-hacking with no real effect, p-values cluster near .05 (flat or left-skewed). A right-skewed p-curve is evidence of a genuine underlying effect."
  ),
  list(
    category = "p-Hacking",
    question = "Pre-registration helps address p-hacking by:",
    choices = c("Increasing statistical power",
                "Making the data publicly available",
                "Committing to a single analysis plan before seeing the data",
                "Requiring larger sample sizes"),
    correct = 3,
    explanation = "Pre-registration locks in the analysis plan (hypotheses, variables, exclusion criteria, statistical tests) before data collection or analysis. This ensures there is only one path through the 'garden of forking paths', keeping the false positive rate at its nominal level."
  ),
  list(
    category = "p-Hacking",
    question = "If a researcher tries 5 independent tests on null data, the probability of at least one p < .05 is approximately:",
    choices = c("5%",
                "12%",
                "23%",
                "50%"),
    correct = 3,
    explanation = "With 5 independent tests at \u03b1 = .05, the probability of at least one false positive is 1 \u2212 (0.95)^5 \u2248 22.6%. This is the multiple comparisons problem: each additional test increases the familywise error rate."
  ),
  list(
    category = "p-Hacking",
    question = "A multiverse analysis addresses analytic flexibility by:",
    choices = c("Running only the most powerful test",
                "Reporting results across all defensible analysis pipelines",
                "Using Bayesian instead of frequentist methods",
                "Increasing the significance threshold to .01"),
    correct = 2,
    explanation = "A multiverse analysis systematically runs every defensible combination of analytic choices and reports the distribution of results. This transparency shows whether conclusions are robust or depend on specific arbitrary decisions."
  ),
  list(
    category = "p-Hacking",
    question = "Which of the following is NOT a form of p-hacking?",
    choices = c("Stopping data collection when p < .05",
                "Trying multiple outcome variables and reporting only the significant one",
                "Pre-registering a hypothesis and running the planned analysis",
                "Removing outliers until the result becomes significant"),
    correct = 3,
    explanation = "Pre-registering and executing the planned analysis is the antithesis of p-hacking. All other options involve data-contingent decisions that inflate the false positive rate by exploiting analytic flexibility."
  ),
  list(
    category = "p-Hacking",
    question = "Simonsohn et al. (2014) showed that even a small number of researcher degrees of freedom can inflate the false positive rate from 5% to:",
    choices = c("6-8%",
                "10-15%",
                "Over 50%",
                "Exactly 100%"),
    correct = 3,
    explanation = "Simonsohn, Nelson, and Simmons (2014) demonstrated that common analytic flexibility (e.g., choosing between two outcome variables, optionally including a covariate, optionally removing outliers) can inflate the false positive rate to over 50%, even with just a few degrees of freedom."
  ),
  list(
    category = "p-Hacking",
    question = "HARKing (Hypothesizing After Results are Known) is problematic because it:",
    choices = c("Reduces statistical power",
                "Presents exploratory findings as if they were confirmatory, inflating confidence in false positives",
                "Violates assumptions of normality",
                "Increases Type II error rates"),
    correct = 2,
    explanation = "HARKing disguises post-hoc hypotheses as a priori predictions. This is misleading because the probability of 'predicting' a pattern after seeing the data is 100%, whereas the significance test assumes the hypothesis was specified in advance."
  ),

  # ── Missing Data & Imputation ─────────────────────────────
  list(
    category = "Missing Data",
    question = "Multiple imputation is preferred over single imputation (e.g., mean imputation) primarily because it:",
    choices = c("Runs faster and uses less memory",
                "Creates a single best-guess completed dataset",
                "Properly accounts for uncertainty due to missing values via Rubin's rules",
                "Guarantees unbiased estimates under MNAR"),
    correct = 3,
    explanation = "Multiple imputation creates several plausible completed datasets, analyses each, and combines results using Rubin's rules. This correctly propagates the additional uncertainty introduced by imputation, unlike single imputation methods which treat imputed values as known."
  ),
  list(
    category = "Missing Data",
    question = "Mean imputation tends to:",
    choices = c("Overestimate correlations between variables",
                "Attenuate (shrink) correlations and underestimate variance",
                "Produce unbiased estimates under all mechanisms",
                "Increase the standard errors of estimates"),
    correct = 2,
    explanation = "Replacing missing values with the mean adds points at the center of the distribution, reducing variability and pulling correlations toward zero. It also underestimates standard errors because the imputed values carry no real information but are treated as observed data."
  ),
  list(
    category = "Missing Data",
    question = "Under which missing data mechanism are standard imputation methods (MI, regression) most likely to be biased?",
    choices = c("MCAR",
                "MAR",
                "MNAR",
                "All mechanisms produce equal bias"),
    correct = 3,
    explanation = "Under MNAR (Missing Not At Random), missingness depends on the unobserved values themselves. Standard imputation methods condition on observed data, so they cannot correct for the systematic pattern in what is missing. Only specialised models (e.g., selection models, pattern mixture models) can attempt to address MNAR."
  ),
  list(
    category = "Missing Data",
    question = "Rubin's rules for combining multiply imputed estimates involve:",
    choices = c("Averaging the point estimates and combining within- and between-imputation variance",
                "Taking the median of all imputed datasets",
                "Selecting the imputation with the best model fit",
                "Using only the first imputed dataset for efficiency"),
    correct = 1,
    explanation = "Rubin's rules average the point estimates across imputations (Q̄) and compute the total variance as the sum of the average within-imputation variance (Ū) and a scaled between-imputation variance ((1 + 1/m)B), properly reflecting both sampling and imputation uncertainty."
  ),
  list(
    category = "Missing Data",
    question = "Listwise deletion (complete-case analysis) is unbiased under:",
    choices = c("MAR only",
                "MNAR only",
                "MCAR only",
                "All missing data mechanisms"),
    correct = 3,
    explanation = "Listwise deletion discards all cases with any missing values. Under MCAR, the complete cases are a random subsample of the full data, so estimates are unbiased (though less efficient). Under MAR or MNAR, the complete cases are a non-random subset, introducing bias."
  ),

  # ── Survey Methodology ──────────────────────────────────
  list(
    category = "Survey Methodology",
    question = "In a cluster sampling design, the design effect (DEFF) is approximately:",
    choices = c("1 + m × ICC",
                "1 + (m − 1) × ICC",
                "m × ICC",
                "ICC / m"),
    correct = 2,
    explanation = "The classic DEFF formula for cluster sampling is DEFF = 1 + (m − 1) × ICC, where m is the cluster size and ICC is the intra-class correlation. As either m or ICC increases, the design effect grows."
  ),
  list(
    category = "Survey Methodology",
    question = "Stratified sampling typically produces standard errors that are:",
    choices = c("Larger than SRS because it adds complexity",
                "The same as SRS since overall n is identical",
                "Smaller than SRS because within-stratum variability is reduced",
                "Unpredictable without knowing the population size"),
    correct = 3,
    explanation = "Stratified sampling groups similar units together, reducing within-stratum variance. Because each stratum is sampled independently, the overall SE is typically smaller than an SRS of the same total size."
  ),
  list(
    category = "Survey Methodology",
    question = "The effective sample size under survey weighting equals:",
    choices = c("n × mean(weights)",
                "n / (1 + CV(weights)²)",
                "n × DEFF",
                "n − number of unique weights"),
    correct = 2,
    explanation = "Highly variable weights inflate variance. The effective sample size is approximately n / (1 + CV(w)²), where CV(w) is the coefficient of variation of the weights. More variable weights mean a smaller effective sample."
  ),
  list(
    category = "Survey Methodology",
    question = "Post-stratification weighting adjusts the sample to match:",
    choices = c("The theoretical normal distribution",
                "Known population proportions across strata",
                "A uniform distribution of weights",
                "The mean of the outcome variable"),
    correct = 2,
    explanation = "Post-stratification reweights the sample so that the weighted cell proportions match known population proportions (e.g., from census data), correcting for over- or under-representation of subgroups."
  ),
  list(
    category = "Survey Methodology",
    question = "Ignoring cluster structure when computing standard errors typically leads to:",
    choices = c("Overestimated SEs (conservative results)",
                "Underestimated SEs (liberal results / too many false positives)",
                "No effect on SEs, only on point estimates",
                "Correct SEs if the sample is large enough"),
    correct = 2,
    explanation = "Individuals within clusters tend to be correlated. Ignoring this positive ICC makes the data appear to carry more independent information than it actually does, leading to underestimated standard errors and inflated Type I error rates."
  ),
  list(
    category = "Survey Methodology",
    question = "Raking (iterative proportional fitting) is useful when:",
    choices = c("You have full cross-tabulated population counts for all variables",
                "You only have marginal population totals for each variable separately",
                "The sample is a perfect SRS with no weighting needed",
                "The ICC is zero"),
    correct = 2,
    explanation = "Raking adjusts weights to match population marginal totals for multiple dimensions simultaneously, even when cross-tabulated population counts are unavailable. It iteratively adjusts each dimension until convergence."
  ),
  list(
    category = "Survey Methodology",
    question = "With ICC = 0.10 and cluster size m = 50, the design effect is:",
    choices = c("1.49",
                "5.90",
                "6.00",
                "50.10"),
    correct = 2,
    explanation = "DEFF = 1 + (m − 1) × ICC = 1 + 49 × 0.10 = 5.90. This means you would need nearly 6 times as many observations as an SRS to achieve the same precision."
  ),
  list(
    category = "Survey Methodology",
    question = "Which variance estimation method is most commonly used in design-based survey analysis?",
    choices = c("Bootstrap",
                "Taylor-series linearisation",
                "Maximum likelihood",
                "Bayesian posterior sampling"),
    correct = 2,
    explanation = "Taylor-series linearisation (also called the delta method) is the default variance estimation method in most survey software. It approximates the variance of complex statistics using the first-order Taylor expansion."
  ),
  list(
    category = "Survey Methodology",
    question = "A multi-stage design combines which two approaches?",
    choices = c("Random and systematic sampling",
                "Cluster and stratified sampling",
                "Convenience and quota sampling",
                "Snowball and purposive sampling"),
    correct = 2,
    explanation = "Multi-stage designs typically stratify at the first stage (e.g., by region) and then cluster-sample within strata (e.g., select schools within regions, then students within schools). This balances efficiency with cost reduction."
  ),
  list(
    category = "Survey Methodology",
    question = "Trimming extreme survey weights is done to:",
    choices = c("Eliminate bias entirely",
                "Increase the total sample size",
                "Reduce variance inflation at the cost of some bias",
                "Make all weights exactly equal"),
    correct = 3,
    explanation = "Extremely large weights increase the variance of estimates. Trimming (capping) these weights reduces variance but introduces a small amount of bias, since the trimmed units are no longer fully representative. It is a bias-variance trade-off."
  ),

  # ── Data Visualization ──────────────────────────────────
  list(
    category = "Data Visualization",
    question = "According to Cleveland and McGill's perceptual ranking, the most accurately perceived visual encoding is:",
    choices = c("Colour saturation",
                "Area",
                "Angle/slope",
                "Position along a common scale"),
    correct = 4,
    explanation = "Cleveland and McGill (1984) found that position along a common scale (as in bar charts and dot plots) is decoded most accurately, followed by length, angle/slope, area, volume, and finally colour saturation."
  ),
  list(
    category = "Data Visualization",
    question = "The main problem with dual y-axes in a chart is:",
    choices = c("They make the chart too complex to render",
                "The creator can independently scale the axes to create spurious apparent correlations",
                "They only work with categorical data",
                "Colour-blind readers cannot interpret them"),
    correct = 2,
    explanation = "With dual y-axes, the creator controls both scales independently. By stretching or compressing one axis relative to the other, almost any two series can be made to appear correlated, regardless of any actual relationship."
  ),
  list(
    category = "Data Visualization",
    question = "Tufte's 'data-ink ratio' principle recommends:",
    choices = c("Using as many colours as possible to make data stand out",
                "Maximising the proportion of ink devoted to non-redundant data representation",
                "Always using 3D effects for emphasis",
                "Filling all available whitespace with annotations"),
    correct = 2,
    explanation = "The data-ink ratio = (data ink) / (total ink). Tufte advocates maximising this ratio by removing 'chart junk' — non-essential gridlines, borders, backgrounds, and decorative elements that do not encode data."
  ),
  list(
    category = "Data Visualization",
    question = "Small multiples (faceting) are preferred over a single overlaid plot because they:",
    choices = c("Use less screen space",
                "Avoid overplotting and make each group independently readable",
                "Always produce higher resolution",
                "Require fewer colours"),
    correct = 2,
    explanation = "Small multiples separate groups into individual panels with a shared scale, eliminating overplotting and making each group's pattern clear. The trade-off is more screen space, but readability improves substantially."
  ),
  list(
    category = "Data Visualization",
    question = "Why are pie charts generally discouraged for quantitative comparisons?",
    choices = c("They cannot show more than two categories",
                "Humans judge angles and areas poorly compared to aligned lengths",
                "They require special software to create",
                "They always distort the total"),
    correct = 2,
    explanation = "Pie charts encode data as angles, which sit near the bottom of Cleveland and McGill's perceptual ranking. Comparing two slices of similar size is much harder than comparing two bars of similar height, especially with more than 3-4 categories."
  ),
  list(
    category = "Data Visualization",
    question = "Approximately what percentage of men have some form of colour vision deficiency?",
    choices = c("0.5%",
                "2%",
                "8%",
                "25%"),
    correct = 3,
    explanation = "Roughly 8% of men (and about 0.5% of women) have some form of colour vision deficiency, most commonly red-green (protanopia or deuteranopia). This makes colour-blind safe palettes essential for accessible visualisation."
  ),
  list(
    category = "Data Visualization",
    question = "A truncated y-axis is misleading because it:",
    choices = c("Always starts at a negative number",
                "Removes data points from the chart",
                "Exaggerates small differences by compressing the visible range",
                "Violates copyright laws"),
    correct = 3,
    explanation = "When the y-axis doesn't start at zero (or at an appropriate baseline), small absolute differences appear visually large. A 1% change can look dramatic if the axis spans 98% to 100% instead of 0% to 100%."
  ),
  list(
    category = "Data Visualization",
    question = "Which chart type is best for showing the distribution of a continuous variable?",
    choices = c("Pie chart",
                "Histogram or density plot",
                "Scatter plot",
                "Stacked bar chart"),
    correct = 2,
    explanation = "Histograms bin continuous data and show frequency per bin, revealing shape, center, spread, and modality. Density plots are a smoothed alternative. Scatter plots show bivariate relationships, not univariate distributions."
  ),
  list(
    category = "Data Visualization",
    question = "When encoding a quantitative variable as circle size (bubble chart), the perceived difference is distorted because:",
    choices = c("Circles cannot represent negative values",
                "Area scales as the square of the radius, so 2× the value looks like 4× the size",
                "Colour and size cannot be used together",
                "Bubble charts always overlap"),
    correct = 2,
    explanation = "If you double the radius to represent 2× the value, the area quadruples (πr²). Even when using area-proportional scaling, humans tend to underestimate size differences in circles compared to length differences in bars."
  ),
  list(
    category = "Data Visualization",
    question = "The Okabe-Ito colour palette is specifically designed to be:",
    choices = c("Maximally saturated for print media",
                "Distinguishable for people with colour vision deficiencies",
                "Compatible only with dark backgrounds",
                "Limited to exactly two colours"),
    correct = 2,
    explanation = "The Okabe-Ito palette was designed to remain distinguishable under the most common forms of colour vision deficiency (protanopia and deuteranopia). It is one of several recommended colour-blind safe palettes, along with viridis and ColorBrewer."
  ),

  # ── Game Theory ─────────────────────────────────────────
  list(
    category = "Game Theory",
    question = "In the one-shot Prisoner's Dilemma, the Nash equilibrium is:",
    choices = c("Both cooperate",
                "Both defect",
                "One cooperates, the other defects",
                "There is no Nash equilibrium"),
    correct = 2,
    explanation = "In the one-shot Prisoner's Dilemma, defection strictly dominates cooperation for both players. Regardless of what the other player does, each player is better off defecting. Thus (Defect, Defect) is the unique Nash equilibrium, even though (Cooperate, Cooperate) yields higher payoffs for both."
  ),
  list(
    category = "Game Theory",
    question = "A Nash equilibrium is defined as a strategy profile where:",
    choices = c("Both players receive the highest possible payoff",
                "No player can improve their payoff by unilaterally changing their strategy",
                "Players always cooperate",
                "The game has a unique solution"),
    correct = 2,
    explanation = "A Nash equilibrium is a set of strategies (one per player) such that no player benefits from changing their strategy while the others keep theirs fixed. It does not require optimal joint outcomes — the Prisoner's Dilemma equilibrium is Pareto-inferior."
  ),
  list(
    category = "Game Theory",
    question = "In Axelrod's iterated Prisoner's Dilemma tournaments, which strategy consistently performed well?",
    choices = c("Always Defect",
                "Random",
                "Tit-for-Tat",
                "Grudger"),
    correct = 3,
    explanation = "Tit-for-Tat — cooperate first, then mirror the opponent's last move — won Axelrod's tournaments. It succeeds by being nice (never defects first), retaliatory (punishes defection), forgiving (returns to cooperation), and clear (easy for opponents to understand)."
  ),
  list(
    category = "Game Theory",
    question = "A zero-sum game is one where:",
    choices = c("Both players always receive zero payoff",
                "One player's gain is exactly the other player's loss",
                "Cooperation is always the best strategy",
                "There are no Nash equilibria"),
    correct = 2,
    explanation = "In a zero-sum game, the sum of payoffs across players is constant (typically zero). Matching Pennies is a classic example: if one player wins +1, the other loses -1. Zero-sum games are purely competitive with no room for mutual benefit."
  ),
  list(
    category = "Game Theory",
    question = "An Evolutionarily Stable Strategy (ESS) is:",
    choices = c("Any strategy that wins in a single round",
                "A strategy that, once adopted by most of the population, cannot be invaded by a rare mutant",
                "A strategy that maximizes average payoff across all possible opponents",
                "The same as a Nash equilibrium in all cases"),
    correct = 2,
    explanation = "An ESS (Maynard Smith, 1982) is a strategy that resists invasion by rare alternative strategies. Every ESS corresponds to a Nash equilibrium, but not every Nash equilibrium is an ESS. The ESS concept is central to evolutionary biology and behavioral ecology."
  ),
  list(
    category = "Game Theory",
    question = "In the Hawk-Dove (Chicken) game, the mixed-strategy Nash equilibrium predicts:",
    choices = c("All players become Hawks",
                "All players become Doves",
                "A stable proportion of Hawks and Doves coexist in the population",
                "Players randomly switch between cooperating and fighting"),
    correct = 3,
    explanation = "In Hawk-Dove, neither pure population is stable: a population of all Doves can be invaded by Hawks, and a population of all Hawks suffers costly fights. The mixed ESS yields a stable ratio where the average payoff of Hawk equals Dove."
  ),
  list(
    category = "Game Theory",
    question = "The Stag Hunt game illustrates the tension between:",
    choices = c("Selfishness and altruism",
                "Risk dominance and payoff dominance",
                "Zero-sum and positive-sum outcomes",
                "Sequential and simultaneous moves"),
    correct = 2,
    explanation = "The Stag Hunt has two pure Nash equilibria: (Stag, Stag) is payoff-dominant (highest joint payoff) but risky, while (Hare, Hare) is risk-dominant (safe regardless of the other player). This game models the challenge of social cooperation under uncertainty."
  ),
  list(
    category = "Game Theory",
    question = "A dominant strategy is one that:",
    choices = c("Beats every other strategy in head-to-head play",
                "Yields the highest payoff regardless of what the other player does",
                "Is only optimal against a specific opponent strategy",
                "Requires knowledge of the opponent's choice"),
    correct = 2,
    explanation = "A dominant strategy gives a player a weakly or strictly higher payoff than any alternative, no matter what the opponent does. In the Prisoner's Dilemma, Defect is a dominant strategy for both players. Not all games have dominant strategies."
  ),
  list(
    category = "Game Theory",
    question = "Nash's existence theorem (1950) guarantees that:",
    choices = c("Every game has a pure-strategy Nash equilibrium",
                "Every finite game has at least one Nash equilibrium (possibly in mixed strategies)",
                "Cooperative outcomes are always achievable",
                "Zero-sum games have unique solutions"),
    correct = 2,
    explanation = "Nash proved that every game with a finite number of players and strategies has at least one Nash equilibrium when mixed (randomized) strategies are allowed. This is one of the foundational results of game theory, for which Nash received the Nobel Prize in Economics (1994)."
  ),
  list(
    category = "Game Theory",
    question = "In the replicator dynamics model, a strategy's frequency in the population grows when:",
    choices = c("It is chosen by the majority",
                "Its average payoff exceeds the population's average payoff",
                "It has the lowest variance in payoffs",
                "It cooperates more than other strategies"),
    correct = 2,
    explanation = "The replicator equation states that a strategy's growth rate is proportional to the difference between its fitness (average payoff) and the population's mean fitness. Strategies earning above-average payoffs expand; those below average shrink."
  ),
  # --- Information Theory ---
  list(
    category = "Information Theory",
    question = "Shannon entropy H(X) is maximised when:",
    choices = c("All outcomes are certain",
                "All outcomes are equally probable",
                "One outcome has probability 1",
                "The variance of X is minimised"),
    correct = 2,
    explanation = "Entropy measures average uncertainty. It is highest when all outcomes are equally likely, because no single outcome is more predictable than another. A certain outcome (probability 1) gives entropy of zero."
  ),
  list(
    category = "Information Theory",
    question = "KL divergence D_KL(P || Q) is:",
    choices = c("Always symmetric: D_KL(P||Q) = D_KL(Q||P)",
                "Always non-negative, and equals zero only when P = Q",
                "Equivalent to the correlation between P and Q",
                "Defined only for continuous distributions"),
    correct = 2,
    explanation = "KL divergence is non-negative (by Gibbs inequality) and equals zero if and only if the two distributions are identical. It is not symmetric — D_KL(P||Q) generally differs from D_KL(Q||P)."
  ),
  list(
    category = "Information Theory",
    question = "The cross-entropy H(P, Q) between the true distribution P and a model Q satisfies:",
    choices = c("H(P, Q) = H(P) always",
                "H(P, Q) = H(P) + D_KL(P || Q)",
                "H(P, Q) = D_KL(P || Q) only",
                "H(P, Q) is always less than H(P)"),
    correct = 2,
    explanation = "Cross-entropy equals the true entropy H(P) plus the KL divergence from P to Q. Minimising cross-entropy with respect to Q is therefore equivalent to minimising KL divergence, which is why cross-entropy is used as a loss function in machine learning."
  ),
  list(
    category = "Information Theory",
    question = "What does a mutual information of I(X; Y) = 0 imply?",
    choices = c("X and Y are perfectly correlated",
                "X and Y are independent",
                "X causes Y",
                "X and Y have the same distribution"),
    correct = 2,
    explanation = "Mutual information quantifies how much knowing one variable reduces uncertainty about the other. I(X; Y) = 0 means knowing X gives no information about Y, i.e., they are statistically independent."
  ),
  list(
    category = "Information Theory",
    question = "In the context of machine learning, minimising cross-entropy loss H(P, Q) is equivalent to:",
    choices = c("Maximising the prior probability of the model parameters",
                "Maximising the likelihood of the observed data under Q",
                "Minimising the variance of predictions",
                "Maximising mutual information between inputs and labels"),
    correct = 2,
    explanation = "Cross-entropy loss equals the negative log-likelihood up to a constant. Minimising it is equivalent to maximum likelihood estimation, since the true label distribution P is fixed and only the KL divergence term (which involves Q) changes."
  ),
  list(
    category = "Information Theory",
    question = "The entropy of a fair coin flip is approximately:",
    choices = c("0 bits", "0.5 bits", "1 bit", "2 bits"),
    correct = 3,
    explanation = "A fair coin has two equally likely outcomes, each with probability 0.5. Shannon entropy = -2 x (0.5 x log2(0.5)) = 1 bit. One bit is the maximum entropy for a binary variable."
  ),
  list(
    category = "Information Theory",
    question = "Which continuous distribution has maximum entropy for a given variance?",
    choices = c("Uniform distribution",
                "Exponential distribution",
                "Normal (Gaussian) distribution",
                "Laplace distribution"),
    correct = 3,
    explanation = "Among all continuous distributions with a fixed mean and variance, the normal distribution has the highest differential entropy. This makes it the least informative (most uncertain) distribution consistent with those two constraints — a key justification for its widespread use."
  ),
  list(
    category = "Information Theory",
    question = "Bits of information gained from observing a rare event (probability p close to 0) is:",
    choices = c("Close to 0 (nearly no information)",
                "Exactly 1 bit regardless of p",
                "Very high — rare events carry more information",
                "Undefined for very small p"),
    correct = 3,
    explanation = "Self-information is defined as -log2(p). As p approaches 0, -log2(p) approaches infinity. Rare events are surprising and therefore highly informative. Common events carry little information because they are expected."
  ),

  # --- Signal Detection Theory ---
  list(
    category = "Signal Detection Theory",
    question = "In Signal Detection Theory, d-prime (d') measures:",
    choices = c("The observer's response bias",
                "The discriminability between signal and noise, independent of bias",
                "The probability of a correct response",
                "The likelihood ratio at the decision criterion"),
    correct = 2,
    explanation = "d' is the distance between the signal and noise distribution means, standardised by their common standard deviation. It captures sensitivity independently of how liberal or conservative the observer's response criterion is."
  ),
  list(
    category = "Signal Detection Theory",
    question = "An observer with d' = 0 is:",
    choices = c("Highly sensitive and conservative",
                "Unable to distinguish signal from noise at all",
                "Perfectly accurate but extremely biased",
                "Performing at ceiling"),
    correct = 2,
    explanation = "When d' = 0 the signal and noise distributions completely overlap. The observer cannot do better than chance — any hit rate above 0.5 is offset by an equally elevated false alarm rate."
  ),
  list(
    category = "Signal Detection Theory",
    question = "A conservative response bias (high criterion c) leads to:",
    choices = c("High hit rate and high false alarm rate",
                "Low hit rate and low false alarm rate",
                "High hit rate and low false alarm rate",
                "No change in hit or false alarm rate"),
    correct = 2,
    explanation = "A high (conservative) criterion means the observer requires strong evidence before saying 'yes'. This reduces both hit rate and false alarm rate simultaneously. The observer says 'yes' less often overall, regardless of whether a signal is present."
  ),
  list(
    category = "Signal Detection Theory",
    question = "The Area Under the ROC Curve (AUC) in SDT equals:",
    choices = c("The hit rate minus the false alarm rate",
                "Phi(d' / sqrt(2)), where Phi is the standard normal CDF",
                "d' / 4",
                "1 minus the false alarm rate"),
    correct = 2,
    explanation = "For equal-variance normal distributions, AUC = Phi(d'/sqrt(2)). It equals the probability that a randomly chosen signal observation has higher evidence than a randomly chosen noise observation — a threshold-free sensitivity measure."
  ),
  list(
    category = "Signal Detection Theory",
    question = "Why is d' preferred over percent correct as a measure of sensitivity?",
    choices = c("Percent correct is harder to compute",
                "d' is always higher than percent correct",
                "Percent correct conflates sensitivity with response bias",
                "d' is independent of sample size"),
    correct = 3,
    explanation = "Percent correct depends on how often the observer says 'yes', not just on their true sensitivity. A biased observer can achieve the same percent correct as a sensitive observer through different mechanisms. d' separates these components."
  ),
  list(
    category = "Signal Detection Theory",
    question = "In the unequal-variance SDT model, the slope of the z-ROC curve equals:",
    choices = c("d'",
                "The ratio of signal to noise standard deviations (s = sigma_s / sigma_n)",
                "The criterion c",
                "AUC"),
    correct = 2,
    explanation = "When the signal distribution has a different standard deviation from the noise distribution, the z-ROC (ROC in z-score space) is a straight line with slope s = sigma_signal / sigma_noise. A slope less than 1 means the signal distribution is narrower than the noise distribution."
  ),
  list(
    category = "Signal Detection Theory",
    question = "In an eyewitness identification study, an administrator who knows which person is the suspect is likely to produce:",
    choices = c("Higher d' but unchanged bias",
                "Unchanged d' but more liberal bias (lower criterion)",
                "Lower d' and more conservative bias",
                "Higher AUC but lower hit rate"),
    correct = 2,
    explanation = "Knowing the suspect's identity can cue the witness toward a 'yes' response through subtle behavioural cues (administrator effect), increasing the false alarm rate and producing a more liberal bias. True discriminability (d') is unchanged since memory accuracy is fixed, but criterion c decreases."
  ),

  # --- Count Data Models ---
  list(
    category = "Count Data Models",
    question = "Overdispersion in count data means:",
    choices = c("There are too many observations",
                "The observed variance exceeds the mean, violating the Poisson assumption",
                "The counts are not integers",
                "The model has too many predictors"),
    correct = 2,
    explanation = "The Poisson distribution assumes variance = mean. Overdispersion occurs when the observed variance is greater than the mean, which is very common with real count data. The negative binomial model adds a dispersion parameter to accommodate this."
  ),
  list(
    category = "Count Data Models",
    question = "A zero-inflated Poisson (ZIP) model is appropriate when:",
    choices = c("All counts are zero",
                "There is a structural process generating excess zeros in addition to the usual count process",
                "The mean count is less than 1",
                "The count data are overdispersed with no excess zeros"),
    correct = 2,
    explanation = "ZIP models mix two processes: a binary process generating 'structural' zeros (e.g., non-participants) and a Poisson process generating counts including 'sampling' zeros. This is distinct from overdispersion, which does not involve a separate zero-generating mechanism."
  ),
  list(
    category = "Count Data Models",
    question = "The key difference between a hurdle model and a zero-inflated model is:",
    choices = c("Hurdle models cannot include covariates",
                "Hurdle models treat all zeros identically from a single barrier process; ZIP/ZINB mixes structural and sampling zeros",
                "Hurdle models only apply to binary outcomes",
                "Zero-inflated models do not allow negative counts"),
    correct = 2,
    explanation = "In a hurdle model, all zeros come from the binary 'hurdle' part — there is no ambiguity between structural and sampling zeros. In ZIP/ZINB, some zeros come from a point mass and others from the count distribution, making the two types of zeros indistinguishable at the observation level."
  ),
  list(
    category = "Count Data Models",
    question = "The dispersion statistic (Pearson chi-squared / df) for a well-fitting Poisson model should be approximately:",
    choices = c("0", "1", "Greater than 2", "Equal to the mean count"),
    correct = 2,
    explanation = "For a correctly specified Poisson model, the Pearson chi-squared divided by degrees of freedom should be close to 1. Values substantially greater than 1 indicate overdispersion; values less than 1 indicate underdispersion (rare in practice)."
  ),
  list(
    category = "Count Data Models",
    question = "In a rootogram, a bar that 'hangs' below the zero line indicates:",
    choices = c("The model overpredicts counts at that value",
                "The model underpredicts counts at that value",
                "The count is exactly as expected",
                "The data contain negative values"),
    correct = 1,
    explanation = "A rootogram suspends bars from their expected value (the model prediction). Bars that hang below the zero baseline mean the observed count is less than expected — the model overpredicts at that count value. Bars above the line indicate underprediction."
  ),
  list(
    category = "Count Data Models",
    question = "Why might a negative binomial model fit as well as a ZIP model even when zero-inflation seems present?",
    choices = c("Negative binomial models always outperform ZIP models",
                "Negative binomial variance can generate many zeros through overdispersion without a separate structural zero mechanism",
                "ZIP and NB models are mathematically identical",
                "The negative binomial cannot produce zeros"),
    correct = 2,
    explanation = "The NB variance (lambda + lambda^2/theta) grows large with small theta, producing highly right-skewed distributions with many zeros. This overdispersion can mimic zero-inflation, making the two models difficult to distinguish without large samples or theoretical justification for a structural zero process."
  ),
  list(
    category = "Count Data Models",
    question = "Which model would you use for count data where the zero/non-zero decision has a clear substantive interpretation (e.g., whether a person smoked at all vs. how many cigarettes they smoked)?",
    choices = c("Poisson regression",
                "Negative binomial regression",
                "Hurdle model",
                "Zero-inflated Poisson"),
    correct = 3,
    explanation = "The hurdle model explicitly separates the decision to participate (zero vs. non-zero) from the count among participants. This matches the scenario perfectly: Part 1 models whether someone smokes; Part 2 models how many cigarettes among smokers."
  ),

  # --- GAMs ---
  list(
    category = "GAMs",
    question = "In a Generalised Additive Model (GAM), the effective degrees of freedom (EDF) for a smooth term indicates:",
    choices = c("The number of observations used in fitting the smooth",
                "The complexity (wiggliness) of the estimated smooth function",
                "The percentage of variance explained by that term",
                "The number of knots placed on the predictor"),
    correct = 2,
    explanation = "EDF measures the complexity of the fitted smooth. EDF = 1 corresponds to a linear relationship. Higher EDF values indicate more complex, nonlinear shapes. The GAM penalty shrinks EDF toward 1 (linearity) during fitting."
  ),
  list(
    category = "GAMs",
    question = "The smoothing penalty in a GAM primarily controls:",
    choices = c("The number of basis functions",
                "The trade-off between goodness of fit and wiggliness (smoothness)",
                "The distribution family of the response",
                "Whether the model is additive or multiplicative"),
    correct = 2,
    explanation = "The penalty parameter lambda controls how much the smooth is penalised for wiggliness (integrated squared second derivative). Large lambda = very smooth; lambda = 0 = interpolating spline. REML or GCV is typically used to estimate lambda from the data."
  ),
  list(
    category = "GAMs",
    question = "Concurvity in a GAM is analogous to which problem in linear regression?",
    choices = c("Heteroscedasticity",
                "Multicollinearity",
                "Non-normality of residuals",
                "Influential outliers"),
    correct = 2,
    explanation = "Concurvity occurs when one smooth term can be approximated by a combination of the other smooth terms in the model. Like multicollinearity, it inflates standard errors and makes individual smooth estimates unstable, but it is based on the estimated functions rather than the raw predictors."
  ),
  list(
    category = "GAMs",
    question = "When should you use a tensor product smooth te(x1, x2) instead of separate smooth terms s(x1) + s(x2)?",
    choices = c("Whenever x1 and x2 are both continuous",
                "When the two predictors are measured on the same scale",
                "When the effect of x1 depends on the level of x2 (interaction on the smooth functions)",
                "Only when the sample size is greater than 1000"),
    correct = 3,
    explanation = "Separate smooths assume the marginal effect of x1 is the same regardless of x2 (additivity). A tensor product smooth te(x1, x2) allows the nonlinear effect of x1 to vary with x2, capturing smooth interactions. It is scale-invariant, unlike the isotropic s(x1, x2) smooth."
  ),
  list(
    category = "GAMs",
    question = "GAMs differ from polynomial regression in that:",
    choices = c("GAMs can only model nonlinear effects",
                "GAMs use spline basis functions with a penalty that avoids overfitting at the extremes",
                "GAMs require the outcome to be binary",
                "Polynomial regression always fits better than a GAM"),
    correct = 2,
    explanation = "Polynomial regression uses global basis functions that can behave erratically outside the data range. GAMs use local basis functions (splines) with a smoothing penalty that prevents overfitting. This makes GAMs more stable and flexible for most real-world nonlinear effects."
  ),
  list(
    category = "GAMs",
    question = "In the mgcv R package, setting select = TRUE in gam() enables:",
    choices = c("Automatic selection of the response distribution",
                "A double-penalty approach that can shrink smooth terms entirely to zero (variable selection)",
                "Cross-validation instead of REML for smoothing parameter estimation",
                "Stepwise selection of predictor variables"),
    correct = 2,
    explanation = "The double-penalty approach adds an extra penalty to the null space of each smooth, allowing terms with insufficient evidence to be removed from the model entirely. This achieves automatic variable selection within the GAM framework without separate model comparison steps."
  ),
  list(
    category = "GAMs",
    question = "The additivity assumption in a GAM states that:",
    choices = c("All predictor effects are linear",
                "The response is the sum of independent smooth functions of each predictor",
                "Residuals must follow a normal distribution",
                "The model must include an intercept"),
    correct = 2,
    explanation = "Additivity means the overall effect is the sum of each predictor's smooth effect: y = f1(x1) + f2(x2) + ... + error. This means the effect of x1 does not depend on x2. Interactions require additional terms such as tensor product smooths."
  ),

  # --- Quantile Regression ---
  list(
    category = "Quantile Regression",
    question = "Quantile regression at tau = 0.5 estimates:",
    choices = c("The mean of Y given X",
                "The conditional median of Y given X",
                "The conditional variance of Y given X",
                "The interquartile range of Y"),
    correct = 2,
    explanation = "At tau = 0.5, quantile regression minimises the sum of absolute residuals, yielding the conditional median. Unlike OLS, this is robust to outliers in the outcome because large errors are penalised linearly, not quadratically."
  ),
  list(
    category = "Quantile Regression",
    question = "The loss function used in quantile regression (the check function / pinball loss) for residual u at quantile tau is:",
    choices = c("u^2",
                "tau * u if u >= 0, (tau - 1) * u if u < 0",
                "|u| / tau",
                "max(0, u - tau)"),
    correct = 2,
    explanation = "The asymmetric pinball loss penalises positive residuals by tau and negative residuals by (1 - tau). At tau = 0.5 this becomes the absolute value loss (equally penalises under and over-prediction), yielding the median."
  ),
  list(
    category = "Quantile Regression",
    question = "If the quantile process plot shows beta(tau) increasing monotonically from low to high tau, this indicates:",
    choices = c("The predictor has no effect on the outcome distribution",
                "The predictor effect is constant across the outcome distribution (no heteroscedasticity)",
                "The predictor increases the upper tail more than the lower tail (heterogeneous effects)",
                "The model is misspecified"),
    correct = 3,
    explanation = "A rising beta(tau) means the predictor has a larger positive effect at higher quantiles than lower quantiles. This is a classic sign of heteroscedasticity: the predictor not only shifts the distribution but also stretches the upper tail. OLS would estimate only the average slope across all quantiles."
  ),
  list(
    category = "Quantile Regression",
    question = "Compared to OLS, a key advantage of quantile regression is:",
    choices = c("It always produces smaller standard errors",
                "It provides a complete picture of how predictors affect the entire conditional distribution",
                "It requires fewer assumptions about the predictor variables",
                "It can be estimated using ordinary least squares"),
    correct = 2,
    explanation = "OLS estimates a single conditional mean. Quantile regression estimates effects at any quantile of the conditional distribution, revealing whether predictors affect the location, spread, or shape of the distribution differently — information that is invisible to OLS."
  ),
  list(
    category = "Quantile Regression",
    question = "Quantile regression is particularly useful when:",
    choices = c("All quantile slopes are identical (parallel quantile lines)",
                "The residuals are normally distributed and homoscedastic",
                "The outcome is binary",
                "The treatment effect varies across the outcome distribution (e.g., low vs. high achievers)"),
    correct = 4,
    explanation = "When effects are heterogeneous — for example, a training intervention that helps struggling students more than advanced ones — quantile regression captures this directly. OLS would report only the average effect, masking the differential impact."
  ),
  list(
    category = "Quantile Regression",
    question = "Parallel quantile lines in a quantile process plot indicate:",
    choices = c("Strong interaction effects between predictors",
                "The predictor shifts the entire conditional distribution by the same amount at every quantile (location shift only)",
                "The predictor affects only the mean, not the variance",
                "The model has converged to the OLS solution"),
    correct = 2,
    explanation = "Parallel quantile lines mean beta(tau) is constant across tau. The predictor shifts the entire distribution uniformly, with no effect on spread or shape. In this case, OLS and quantile regression give consistent estimates and OLS is more efficient."
  ),

  # --- GEE ---
  list(
    category = "GEE",
    question = "GEE estimates population-averaged (marginal) effects. This means:",
    choices = c("Effects are averaged across all possible values of the outcome",
                "The coefficient represents the effect of X on the average person in the population, marginalised over random effects",
                "The model controls for all individual-level differences",
                "Coefficients are always smaller than in mixed models"),
    correct = 2,
    explanation = "Population-averaged (marginal) effects answer: 'What is the average effect of X in the population?' This differs from subject-specific effects (conditional on random effects), which answer: 'What is the effect of X for a specific individual?'"
  ),
  list(
    category = "GEE",
    question = "GEE produces valid inference even with a misspecified working correlation because:",
    choices = c("The working correlation does not affect parameter estimates",
                "The robust (sandwich) standard error remains consistent regardless of working correlation structure",
                "GEE automatically detects and corrects misspecification",
                "A misspecified correlation increases power"),
    correct = 2,
    explanation = "The robust (Huber-White sandwich) SE is consistent for any working correlation structure, as long as the mean model is correctly specified. This is GEE's key robustness property. Model-based SEs are only valid when the working correlation is correctly specified."
  ),
  list(
    category = "GEE",
    question = "Which missing data mechanism is required for GEE estimates to be valid?",
    choices = c("MNAR (Missing Not At Random)",
                "MCAR (Missing Completely At Random)",
                "MAR (Missing At Random)",
                "GEE is valid under any missing data mechanism"),
    correct = 2,
    explanation = "GEE requires MCAR for valid inference with complete-case analysis. If dropout is related to observed outcomes (MAR), GEE estimates can be biased. Mixed models with ML estimation are valid under MAR; weighted GEE can recover validity under MAR with correct weighting."
  ),
  list(
    category = "GEE",
    question = "For a linear outcome (identity link), how do GEE population-averaged effects compare to mixed model subject-specific effects?",
    choices = c("GEE estimates are always larger",
                "They are approximately equal",
                "Mixed model estimates are always smaller",
                "They differ by a factor equal to the ICC"),
    correct = 2,
    explanation = "For linear models, marginalising over the random effects distribution does not change the regression coefficient. Therefore, GEE (PA) and mixed model (SS) estimates are approximately equal for continuous outcomes with an identity link."
  ),
  list(
    category = "GEE",
    question = "QIC (Quasi-likelihood under Independence Criterion) is used in GEE to:",
    choices = c("Select the response distribution family",
                "Choose the optimal working correlation structure",
                "Test whether the independence assumption is met",
                "Estimate the between-cluster variance"),
    correct = 2,
    explanation = "QIC is the GEE analogue of AIC. It is computed under the independence working correlation but rewards efficiency gains from a better-fitting working correlation structure, making it the standard criterion for selecting among working correlation structures in GEE."
  ),
  list(
    category = "GEE",
    question = "The exchangeable working correlation structure is most appropriate when:",
    choices = c("Observations within a cluster are ordered in time and correlation decays with lag",
                "All observations within a cluster are interchangeable (e.g., siblings or members of the same school)",
                "There is no correlation within clusters",
                "The cluster sizes are very large"),
    correct = 2,
    explanation = "Exchangeable (compound symmetry) assumes every pair of observations within a cluster has the same correlation alpha, regardless of their ordering. This is natural for cross-sectional cluster data (e.g., students in schools, patients in clinics) where no natural ordering exists."
  ),

  # --- Sequential Testing ---
  list(
    category = "Sequential Testing",
    question = "The main problem with 'peeking' (testing at multiple time points with a fixed alpha) is:",
    choices = c("It reduces the sample size needed",
                "It inflates the Type I error rate far above the nominal alpha level",
                "It makes the test less powerful",
                "It requires non-parametric methods"),
    correct = 2,
    explanation = "Each peek at the data provides another opportunity to cross the significance threshold by chance. With 5 equally-spaced looks using alpha = 0.05, the actual Type I error rate is approximately 14%. Sequential testing methods (SPRT, group-sequential, e-values) control this inflation."
  ),
  list(
    category = "Sequential Testing",
    question = "In the Sequential Probability Ratio Test (SPRT), the test stops when:",
    choices = c("The p-value drops below 0.05",
                "The likelihood ratio exceeds 1/beta (reject H0) or falls below alpha (accept H0)",
                "A fixed sample size is reached",
                "The effect size exceeds Cohen's d = 0.5"),
    correct = 2,
    explanation = "The SPRT computes the cumulative likelihood ratio of H1 versus H0. The test stops and rejects H0 when the ratio exceeds 1/beta, or accepts H0 when it falls below alpha. This provides exact error control (alpha, beta) with the smallest expected sample size."
  ),
  list(
    category = "Sequential Testing",
    question = "The O'Brien-Fleming boundary for a group-sequential trial is characterised by:",
    choices = c("A flat (constant) critical value across all interim looks",
                "A very stringent early stopping threshold that relaxes toward the final look",
                "A lenient early threshold that becomes more stringent over time",
                "Equal alpha spending at each interim look"),
    correct = 2,
    explanation = "O'Brien-Fleming boundaries require very strong evidence to stop early (conservative early critical values) but become less stringent near the final analysis, preserving most of the study's power at the end. This is in contrast to Pocock boundaries, which use a constant (equal) critical value at each look."
  ),
  list(
    category = "Sequential Testing",
    question = "An alpha-spending function in group-sequential designs:",
    choices = c("Increases the total Type I error budget across all looks",
                "Distributes the total alpha budget across interim looks in a pre-specified way",
                "Eliminates the need for interim analyses",
                "Applies only to Bayesian sequential tests"),
    correct = 2,
    explanation = "The alpha-spending function determines how much of the total Type I error budget is 'spent' at each interim look. The total spent across all looks cannot exceed alpha. This allows flexible timing of interim analyses without pre-specifying the exact look times."
  ),
  list(
    category = "Sequential Testing",
    question = "E-values (anytime-valid tests) guarantee valid Type I error control because:",
    choices = c("They are always greater than 1 under the null hypothesis",
                "They satisfy E[E | H0] <= 1 for any stopping rule, allowing optional stopping",
                "They are equivalent to Bonferroni-corrected p-values",
                "They require a fixed maximum sample size"),
    correct = 2,
    explanation = "E-values are non-negative quantities with expected value at most 1 under H0, for any stopping rule. Markov's inequality then guarantees that P(E >= 1/alpha | H0) <= alpha. This makes them valid for continuous monitoring without inflating Type I error."
  ),
  list(
    category = "Sequential Testing",
    question = "Compared to the O'Brien-Fleming boundary, the Pocock boundary for group-sequential trials:",
    choices = c("Requires stronger evidence to stop early but is more lenient at the final analysis",
                "Uses a constant critical value across all looks, making early stopping easier",
                "Controls only the Type II error rate",
                "Is only valid for one-sided tests"),
    correct = 2,
    explanation = "The Pocock boundary applies the same critical value at every look. This makes early stopping easier (lower threshold) than O'Brien-Fleming, but requires a more stringent threshold at the final analysis to maintain the overall alpha level. It 'spends' alpha more evenly across looks."
  ),

  # --- Clinical Trials ---
  list(
    category = "Clinical Trials",
    question = "Block randomisation (vs. simple randomisation) is primarily used to:",
    choices = c("Increase statistical power by reducing sample size",
                "Ensure treatment arm balance throughout the trial, especially in small samples",
                "Blind participants to treatment assignment",
                "Eliminate the need for stratification"),
    correct = 2,
    explanation = "Simple randomisation can produce severely unequal arm sizes by chance, especially in small trials. Block randomisation guarantees that within every block of b participants, exactly b/2 receive each treatment. This maintains balance as enrolment progresses, which is important if trial recruitment stops early."
  ),
  list(
    category = "Clinical Trials",
    question = "Allocation concealment in a clinical trial refers to:",
    choices = c("Blinding participants to which treatment they receive",
                "Preventing investigators from knowing upcoming assignments before a participant is enrolled",
                "Using a sealed envelope to record the primary outcome",
                "Concealing the study hypothesis from participants"),
    correct = 2,
    explanation = "Allocation concealment prevents selection bias at enrolment: investigators who know the next assignment could selectively enrol or delay patients to influence arm composition. It is distinct from blinding (which conceals assignment after enrolment). Methods include centralised randomisation and sequentially numbered opaque sealed envelopes."
  ),
  list(
    category = "Clinical Trials",
    question = "The intention-to-treat (ITT) principle states that participants should be analysed:",
    choices = c("Only if they completed the full treatment course",
                "According to the treatment they actually received, regardless of allocation",
                "According to the treatment they were randomised to, regardless of compliance",
                "Only if their outcomes were measured at all follow-up points"),
    correct = 3,
    explanation = "ITT preserves the balance created by randomisation by keeping all participants in their assigned groups. Excluding non-compliers (per-protocol analysis) can introduce selection bias comparable to a non-randomised study, because compliance is often related to prognosis."
  ),
  list(
    category = "Clinical Trials",
    question = "Response-Adaptive Randomisation (RAR) in a clinical trial:",
    choices = c("Changes the primary endpoint during the trial based on interim results",
                "Increases allocation probability to the arm showing better interim outcomes",
                "Assigns patients to arms based on their prognostic factors",
                "Stops the trial early if the control arm performs better"),
    correct = 2,
    explanation = "RAR dynamically updates allocation ratios so that more patients are assigned to the arm with better interim outcomes. This reduces expected exposure to the inferior treatment but introduces statistical complexity: the allocation is no longer independent of outcomes, which can bias standard test statistics."
  ),
  list(
    category = "Clinical Trials",
    question = "Performance bias in a clinical trial arises from:",
    choices = c("Differential dropout between treatment and control arms",
                "Participants or care providers changing behaviour because they know the treatment allocation",
                "Outcome assessors rating outcomes differently based on arm assignment",
                "Selective outcome reporting based on significance"),
    correct = 2,
    explanation = "Performance bias occurs when knowledge of the treatment allocation changes how participants or care providers behave, independent of the treatment's true effect. Blinding participants and care providers prevents performance bias; blinding outcome assessors separately prevents detection bias."
  ),
  list(
    category = "Clinical Trials",
    question = "The CONSORT flow diagram is designed to:",
    choices = c("Report the statistical analysis plan for the trial",
                "Track the flow of participants from screening through analysis, showing exclusions at each stage",
                "Summarise the adverse event profile of each treatment arm",
                "Display the randomisation sequence"),
    correct = 2,
    explanation = "The CONSORT flow diagram transparently documents how many participants were screened, enrolled, randomised, allocated to each arm, followed up, and analysed. It makes attrition and exclusions visible, helping readers assess the risk of attrition bias."
  ),
  list(
    category = "Clinical Trials",
    question = "Blinded sample size re-estimation (SSR) in an adaptive trial:",
    choices = c("Requires unblinding the data to adjust the sample size",
                "Uses pooled (blinded) interim data to update variance assumptions without inflating Type I error",
                "Can only increase, never decrease, the planned sample size",
                "Requires a pre-specified alpha-spending function"),
    correct = 2,
    explanation = "Blinded SSR uses the pooled outcome variance from interim data (without knowing treatment arm differences) to check whether the original variance assumption was correct and adjust n accordingly. Because no information about treatment differences is used, the Type I error rate is not inflated, unlike unblinded SSR."
  ),
  list(
    category = "Clinical Trials",
    question = "The estimand framework (ICH E9 addendum) requires trialists to specify:",
    choices = c("The exact statistical test to be used in the primary analysis",
                "How intercurrent events (dropout, crossover, rescue medication) will be handled in defining the treatment effect",
                "The minimum detectable effect size for the trial",
                "The number of interim analyses and stopping rules"),
    correct = 2,
    explanation = "The estimand is the precise quantity the trial aims to estimate. The ICH E9 addendum requires trialists to define the population, variable, summary measure, and how intercurrent events are handled (e.g., as a treatment policy or hypothetical strategy) before analysis begins, resolving ambiguity between ITT and per-protocol approaches."
  ),

  # --- Complex Power ---
  list(
    category = "Complex Power",
    question = "In a cluster-randomised trial, the intraclass correlation (ICC) represents:",
    choices = c("The correlation between treatment and outcome",
                "The proportion of total variance due to between-cluster differences",
                "The reliability of the outcome measure",
                "The correlation between repeated measurements on the same individual"),
    correct = 2,
    explanation = "ICC = between-cluster variance / (between-cluster + within-cluster variance). A high ICC means individuals within the same cluster are more similar to each other than to individuals in other clusters, reducing the effective sample size and therefore the power of the trial."
  ),
  list(
    category = "Complex Power",
    question = "The design effect (DEFF) in a cluster-randomised study is approximately:",
    choices = c("1 + (n - 1) x ICC, where n is the cluster size",
                "ICC x total N",
                "1 / ICC",
                "n x ICC"),
    correct = 1,
    explanation = "DEFF = 1 + (n - 1) x ICC, where n is the number of observations per cluster. It tells you how many times larger the simple random sample size must be inflated to achieve the same power. With ICC = 0.05 and cluster size 20, DEFF = 1.95 — nearly double the required n."
  ),
  list(
    category = "Complex Power",
    question = "For detecting a mediation indirect effect (a x b), power is lower than for detecting the total effect because:",
    choices = c("The indirect effect is always smaller than the total effect",
                "The indirect effect is a product of two paths, each with its own sampling variability",
                "Mediation analyses require a larger alpha level",
                "Bootstrapping reduces statistical power compared to parametric tests"),
    correct = 2,
    explanation = "The indirect effect ab = a x b is the product of two regression coefficients. Even if both a and b are moderate, the product has higher relative variance than either path alone. Power for detecting ab is therefore substantially lower than power for detecting a or b individually, especially in small samples."
  ),
  list(
    category = "Complex Power",
    question = "In a longitudinal power analysis, increasing the number of time points T (while holding n fixed) primarily helps detect:",
    choices = c("Mean differences at a single time point",
                "Slope (rate of change) differences between groups",
                "Between-subject variance",
                "Measurement error"),
    correct = 2,
    explanation = "More time points increase the variance of the time variable (Var(time)), which directly reduces the variance of the slope estimate. For detecting cross-sectional mean differences, only the final measurement matters, but for slope detection, the full growth curve pattern is utilised."
  ),
  list(
    category = "Complex Power",
    question = "Testing a three-way interaction (A x B x C) requires a much larger sample than a two-way interaction because:",
    choices = c("Three-way interactions involve three separate hypothesis tests",
                "Effect sizes for higher-order interactions are typically much smaller, requiring more power",
                "Three-way ANOVA uses a different alpha level",
                "Higher-order interactions violate the normality assumption"),
    correct = 2,
    explanation = "Higher-order interactions represent finer-grained moderation effects that tend to be small. Variance in the interaction term is also partitioned into smaller portions at each level. As a rule of thumb, detecting a three-way interaction requires 4-16x more participants than detecting a main effect of the same true effect size."
  ),
  list(
    category = "Complex Power",
    question = "In a cluster-randomised trial, recruiting more clusters (increasing k) versus recruiting more participants per cluster (increasing n) is preferred because:",
    choices = c("More participants per cluster always increases power more than more clusters",
                "Power is more sensitive to the number of clusters than to cluster size, especially when ICC is high",
                "Larger clusters reduce the between-cluster variance",
                "Regulatory agencies require a minimum number of clusters"),
    correct = 2,
    explanation = "With high ICC, within-cluster observations are redundant — they carry similar information. Additional clusters add truly independent information. Power increases much faster with more clusters than with more within-cluster observations. This is the practical implication of the design effect formula."
  ),

  # --- Replication & Open Science ---
  list(
    category = "Replication & Open Science",
    question = "Publication bias in the scientific literature primarily occurs because:",
    choices = c("Researchers are incentivised to exaggerate effect sizes",
                "Statistically significant results are more likely to be submitted and accepted for publication",
                "Journals only publish results from well-funded institutions",
                "Researchers do not pre-register their studies"),
    correct = 2,
    explanation = "Positive, statistically significant results are more likely to be written up, submitted, and accepted than null results. This creates a biased literature that overstates effect sizes and underestimates replication failure rates."
  ),
  list(
    category = "Replication & Open Science",
    question = "HARKing (Hypothesising After Results are Known) is problematic because:",
    choices = c("It violates statistical power assumptions",
                "It presents post-hoc hypotheses as a priori predictions, inflating apparent confirmatory evidence",
                "It increases the Type II error rate",
                "It requires a larger sample size"),
    correct = 2,
    explanation = "HARKing occurs when researchers generate hypotheses after seeing the data but present them as predictions. This converts exploratory findings into apparent confirmatory evidence, inflating Type I error and contributing to an irreproducible literature."
  ),
  list(
    category = "Replication & Open Science",
    question = "Pre-registration of a study primarily protects against:",
    choices = c("Measurement error in the outcome variable",
                "Selective reporting and p-hacking by committing to hypotheses and analysis plan before data collection",
                "Insufficient statistical power",
                "Confounding from unmeasured variables"),
    correct = 2,
    explanation = "Pre-registration creates a timestamped record of the hypothesis, design, and analysis plan before data collection. It separates confirmatory (pre-registered) from exploratory (post-hoc) analyses, making selective outcome reporting and undisclosed flexibility transparent."
  ),
  list(
    category = "Replication & Open Science",
    question = "The p-curve diagnostic detects p-hacking because:",
    choices = c("P-hacked results produce a left-skewed p-curve (many p-values near 0)",
                "Under a true effect, significant p-values should be right-skewed (concentrated near 0); p-hacking produces a flat or left-skewed distribution near 0.05",
                "P-values should be uniformly distributed under H1",
                "P-curve measures the variance of published effect sizes"),
    correct = 2,
    explanation = "When there is a true effect, significant p-values are concentrated near zero (right-skewed). P-hacking tends to produce a spike of p-values just below 0.05 (a left-skewed p-curve near the boundary). A flat or left-skewed p-curve suggests the literature may lack evidential value or contains widespread p-hacking."
  ),
  list(
    category = "Replication & Open Science",
    question = "The R-Index for a set of studies is calculated as:",
    choices = c("The proportion of studies that successfully replicated",
                "Mean power of significant studies minus the inflation rate (excess success rate)",
                "The ratio of effect sizes across independent replications",
                "The number of statistically significant results divided by total studies"),
    correct = 2,
    explanation = "R-Index = mean power - inflation rate, where inflation rate = success rate - mean power. A high R-Index (close to 1) suggests an honest literature where observed success rates match statistical power. Low or negative R-Index indicates the literature is likely inflated by selective reporting."
  ),
  list(
    category = "Replication & Open Science",
    question = "The trim-and-fill method for correcting publication bias:",
    choices = c("Removes outlying studies and refits the meta-analysis",
                "Imputes missing studies on the opposite side of the funnel plot to restore symmetry, then recalculates the pooled estimate",
                "Weights studies by their replication success rate",
                "Estimates the true effect using only pre-registered studies"),
    correct = 2,
    explanation = "Trim-and-fill identifies and imputes the 'missing' studies that would restore funnel plot symmetry, then uses the augmented dataset to estimate the unbiased effect. It assumes asymmetry is entirely due to publication bias, which may not hold if true heterogeneity causes the asymmetry."
  ),
  list(
    category = "Replication & Open Science",
    question = "The GRIM test (Granularity-Related Inconsistency of Means) can detect:",
    choices = c("Whether a study has sufficient statistical power",
                "Whether a reported mean is arithmetically possible given the sample size and scale",
                "Whether the effect size is practically significant",
                "Whether two studies are measuring the same construct"),
    correct = 2,
    explanation = "For integer-valued data (e.g., Likert scales), only certain means are arithmetically possible for a given n. If a reported mean cannot be produced by any integer-valued dataset of that size, the reported mean must contain an error. GRIM can be applied from summary statistics alone, without access to raw data."
  ),
  list(
    category = "Replication & Open Science",
    question = "A funnel plot in meta-analysis that shows asymmetry (small studies with unusually large effects) is consistent with:",
    choices = c("High statistical heterogeneity across studies",
                "Publication bias or small-study effects",
                "A large true effect size",
                "Perfect replication of the primary study"),
    correct = 2,
    explanation = "Asymmetric funnels — where small, imprecise studies cluster toward one side — are consistent with selective publication of small studies only when they show large effects. However, true heterogeneity, systematic differences between small and large studies, and chance can also cause asymmetry."
  ),

  # --- Missing Data additions (MICE) ---
  list(
    category = "Missing Data",
    question = "In MICE (Multivariate Imputation by Chained Equations), how many imputed datasets (m) are generally recommended?",
    choices = c("Always exactly 5",
                "At least as many as the percentage of incomplete cases (e.g., m >= 40 for 40% missing)",
                "m = 1 is sufficient if the imputation model is correct",
                "m = 100 regardless of the amount of missing data"),
    correct = 2,
    explanation = "The old default of m = 5 was derived for moderate missingness. A better guideline is m >= percentage of missing cases. More imputations reduce Monte Carlo error in the pooled estimate and standard errors. With modern hardware, m = 50-100 is feasible and recommended for high missingness."
  ),
  list(
    category = "Missing Data",
    question = "Rubin's rules for combining multiply imputed results pool:",
    choices = c("The raw data from each imputed dataset before analysis",
                "The parameter estimates and within-imputation and between-imputation variances across m datasets",
                "Only the largest and smallest estimates to form a range",
                "The p-values from each analysis using Fisher's method"),
    correct = 2,
    explanation = "Rubin's rules combine: (1) the average of the m estimates as the pooled estimate, and (2) the total variance = within-imputation variance + (1 + 1/m) x between-imputation variance. The between-imputation variance captures uncertainty about the missing data, increasing standard errors appropriately."
  ),
  list(
    category = "Missing Data",
    question = "Predictive mean matching (PMM) in multiple imputation is preferred over parametric imputation because:",
    choices = c("PMM is faster to compute",
                "PMM imputes from actual observed values, preserving the distributional shape of the variable",
                "PMM requires fewer iterations to converge",
                "PMM works only for normally distributed variables"),
    correct = 2,
    explanation = "PMM finds observed values whose predicted value is closest to the predicted value for the missing case, then donates an observed value. This ensures imputed values are always plausible (within the observed range) and preserves the distribution better than drawing from a parametric model."
  ),
  list(
    category = "Missing Data",
    question = "Convergence in MICE can be assessed using:",
    choices = c("The AIC of the imputation model",
                "Trace plots of the imputed means and variances across iterations, which should show random mixing (no trends)",
                "The proportion of missing data before and after imputation",
                "Chi-squared tests comparing observed and imputed distributions"),
    correct = 2,
    explanation = "Well-converged MICE chains mix freely: the trace plot of the imputed mean (or SD) across iterations should look like white noise with no upward/downward drift or periodic patterns. Trends suggest the chains have not converged and more iterations are needed."
  )
)

# ---------------------------------------------------------------------------
# UI — uses static inputs (not rendered inside renderUI) to avoid reset bugs
# ---------------------------------------------------------------------------
quiz_ui <- function(id) {
  ns <- NS(id)
  nav_panel_hidden(
  value = "Quiz",
  div(
    class = "p-4",
    style = "max-width: 800px; margin: auto;",
    div(
      class = "d-flex justify-content-between align-items-center mb-3",
      tags$h3(icon("spell-check"), " Knowledge Check"),
      actionButton(ns("quiz_reset"), "New Quiz", icon = icon("rotate"), class = "btn-success")
    ),
    tags$p(class = "text-muted mb-3",
      "Test your understanding of statistical concepts covered in the app.
       Questions are drawn randomly across all topic areas."),

    # Category filter
    div(class = "mb-3",
      selectInput(ns("quiz_category"), "Filter by Topic",
        choices = c("All Topics",
                    sort(unique(sapply(quiz_questions, `[[`, "category")))),
        selected = "All Topics", width = "250px")
    ),

    # Progress bar
    div(class = "mb-3",
      div(class = "d-flex justify-content-between mb-1",
        tags$small(class = "text-muted", textOutput(ns("quiz_progress_text"), inline = TRUE)),
        tags$small(class = "text-muted", textOutput(ns("quiz_score_text"), inline = TRUE))
      ),
      div(class = "progress", style = "height: 8px;",
        div(id = ns("quiz_progress_bar"), class = "progress-bar bg-success",
            role = "progressbar", style = "width: 0%;")
      )
    ),

    # Question area (dynamic)
    uiOutput(ns("quiz_question_ui")),

    # Static answer radio buttons — always present, updated by server
    div(id = ns("quiz_answer_wrap"),
      radioButtons(ns("quiz_answer"), NULL,
        choices = c("A" = "1", "B" = "2", "C" = "3", "D" = "4"),
        selected = character(0))
    ),

    # Feedback area
    uiOutput(ns("quiz_feedback_ui")),

    # Static buttons — always present, shown/hidden via server
    div(class = "d-flex justify-content-end gap-2 mt-3",
      div(id = ns("quiz_submit_wrap"),
        actionButton(ns("quiz_submit"), "Check Answer",
                     class = "btn-success", icon = icon("check"))
      ),
      div(id = ns("quiz_next_wrap"), style = "display: none;",
        actionButton(ns("quiz_next"), "Next Question",
                     class = "btn-success", icon = icon("arrow-right"))
      )
    ),

    # Results card (shown after all questions)
    uiOutput(ns("quiz_results_ui"))
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
}

quiz_server <- function(id, parent_session) {
  moduleServer(id, function(input, output, session) {

  quiz_state <- reactiveValues(
    questions = NULL,
    current = 1,
    score = 0,
    total = 0,
    submitted = FALSE,
    finished = FALSE
  )

  # Initialize or reset quiz
  init_quiz <- function() {
    cat_filter <- input$quiz_category
    if (is.null(cat_filter) || cat_filter == "All Topics") {
      pool <- quiz_questions
    } else {
      pool <- Filter(function(q) q$category == cat_filter, quiz_questions)
    }
    n_q <- min(10, length(pool))
    quiz_state$questions <- sample(pool, n_q)
    quiz_state$current <- 1
    quiz_state$score <- 0
    quiz_state$total <- n_q
    quiz_state$submitted <- FALSE
    quiz_state$finished <- FALSE
    # Reset radio + show/hide
    updateRadioButtons(session, "quiz_answer", selected = character(0))
    # Show answer area + submit, hide next + results
    session$sendCustomMessage("run_js", sprintf(
      "document.getElementById('%s').style.display='block';
       document.getElementById('%s').style.display='block';
       document.getElementById('%s').style.display='none';",
      session$ns("quiz_answer_wrap"), session$ns("quiz_submit_wrap"), session$ns("quiz_next_wrap")))
  }

  observeEvent(input$quiz_reset, { init_quiz() })

  observeEvent(input$quiz_category, {
    init_quiz()
  }, ignoreInit = TRUE)

  observe({
    if (is.null(quiz_state$questions)) init_quiz()
  })

  # Update question text and radio labels when current question changes
  observe({
    req(quiz_state$questions, !quiz_state$finished)
    q <- quiz_state$questions[[quiz_state$current]]
    labels <- paste0(LETTERS[seq_along(q$choices)], ". ", q$choices)
    updateRadioButtons(session, "quiz_answer",
      choiceNames = labels,
      choiceValues = as.character(seq_along(q$choices)),
      selected = character(0))
  })

  output$quiz_progress_text <- renderText({
    req(quiz_state$questions)
    paste0("Question ", min(quiz_state$current, quiz_state$total),
           " of ", quiz_state$total)
  })

  output$quiz_score_text <- renderText({
    req(quiz_state$questions)
    answered <- max(0, quiz_state$current - 1 + as.integer(quiz_state$submitted))
    paste0("Score: ", quiz_state$score, " / ", answered)
  })

  # Question header
  output$quiz_question_ui <- renderUI({
    req(quiz_state$questions, !quiz_state$finished)
    q <- quiz_state$questions[[quiz_state$current]]

    card(
      class = "mb-3",
      card_header(
        class = "d-flex justify-content-between",
        tags$span(icon("circle-question"), " ", q$category),
        tags$span(class = "badge bg-info",
                  paste0(quiz_state$current, "/", quiz_state$total))
      ),
      card_body(
        tags$h5(class = "mb-0", q$question)
      )
    )
  })

  # Feedback after submission
  output$quiz_feedback_ui <- renderUI({
    req(quiz_state$submitted)
    q <- quiz_state$questions[[quiz_state$current]]
    user_ans <- isolate(input$quiz_answer)
    is_correct <- (!is.null(user_ans) && as.integer(user_ans) == q$correct)

    tags$div(
      class = if (is_correct) "alert alert-success mt-2" else "alert alert-danger mt-2",
      tags$strong(
        if (is_correct)
          tagList(icon("circle-check"), " Correct!  ")
        else
          tagList(icon("circle-xmark"),
                  paste0(" Incorrect. The answer is ",
                         LETTERS[q$correct], ". "))
      ),
      q$explanation
    )
  })

  # Submit answer
  observeEvent(input$quiz_submit, {
    req(input$quiz_answer)
    q <- quiz_state$questions[[quiz_state$current]]
    is_correct <- (as.integer(input$quiz_answer) == q$correct)
    if (is_correct) quiz_state$score <- quiz_state$score + 1
    quiz_state$submitted <- TRUE

    # Update button label for last question
    next_label <- if (quiz_state$current >= quiz_state$total) "See Results" else "Next Question"

    # Hide submit, show next, disable radio
    session$sendCustomMessage("run_js", sprintf(
      "document.getElementById('%s').style.display='none';
       document.getElementById('%s').style.display='block';
       document.querySelector('#%s .btn').innerHTML =
         '<i class=\"fa fa-arrow-right\"></i> %s';
       document.querySelectorAll('#%s input[type=radio]').forEach(
         function(r){ r.disabled = true; });",
      session$ns("quiz_submit_wrap"), session$ns("quiz_next_wrap"),
      session$ns("quiz_next_wrap"), next_label, session$ns("quiz_answer_wrap")
    ))

    # Update progress bar
    session$sendCustomMessage("run_js", sprintf(
      "document.getElementById('%s').style.width = '%s%%';",
      session$ns("quiz_progress_bar"), round(100 * quiz_state$current / quiz_state$total)
    ))
  })

  # Next question
  observeEvent(input$quiz_next, {
    if (quiz_state$current < quiz_state$total) {
      quiz_state$current <- quiz_state$current + 1
      quiz_state$submitted <- FALSE

      # Reset radio, re-enable, show submit, hide next
      updateRadioButtons(session, "quiz_answer", selected = character(0))
      session$sendCustomMessage("run_js", sprintf(
        "document.getElementById('%s').style.display='block';
         document.getElementById('%s').style.display='none';
         document.querySelectorAll('#%s input[type=radio]').forEach(
           function(r){ r.disabled = false; });",
        session$ns("quiz_submit_wrap"), session$ns("quiz_next_wrap"), session$ns("quiz_answer_wrap")))
    } else {
      quiz_state$finished <- TRUE
      # Hide question UI elements
      session$sendCustomMessage("run_js", sprintf(
        "document.getElementById('%s').style.display='none';
         document.getElementById('%s').style.display='none';
         document.getElementById('%s').style.display='none';",
        session$ns("quiz_answer_wrap"), session$ns("quiz_submit_wrap"), session$ns("quiz_next_wrap")))
    }
  })

  # Results
  output$quiz_results_ui <- renderUI({
    req(quiz_state$finished)
    score <- quiz_state$score
    total <- quiz_state$total
    pct <- round(100 * score / total)

    grade_class <- if (pct >= 80) "success" else if (pct >= 60) "warning" else "danger"
    grade_icon <- if (pct >= 80) "trophy" else if (pct >= 60) "star-half-stroke" else "rotate-left"
    grade_msg <- if (pct >= 80) "Excellent! You have a strong understanding of these concepts."
                 else if (pct >= 60) "Good effort! Review the explanations for questions you missed."
                 else "Keep studying! Consider using Guided Learning Mode to review the explanations."

    tagList(
      card(
        class = paste0("border-", grade_class, " mt-3"),
        card_header(
          class = paste0("bg-", grade_class, " text-white"),
          tags$h4(class = "mb-0", icon(grade_icon), " Quiz Complete!")
        ),
        card_body(
          class = "text-center py-4",
          tags$h1(class = paste0("text-", grade_class, " mb-2"),
                  paste0(score, " / ", total)),
          tags$h4(class = "text-muted", paste0(pct, "%")),
          tags$p(class = "lead mt-3", grade_msg),
          div(class = "progress mt-3", style = "height: 20px;",
            div(class = paste0("progress-bar bg-", grade_class),
                role = "progressbar",
                style = paste0("width: ", pct, "%;"),
                paste0(pct, "%"))
          )
        ),
        card_footer(
          class = "d-flex justify-content-center gap-3",
          actionButton(session$ns("quiz_reset2"), "Try Again",
                       class = "btn-success", icon = icon("rotate")),
          actionButton(session$ns("quiz_back_home"), "Back to Home",
                       class = "btn-outline-secondary", icon = icon("house"))
        )
      )
    )
  })

  observeEvent(input$quiz_reset2, { init_quiz() })
  observeEvent(input$quiz_back_home, {
    nav_select("main_nav", "Welcome", session = parent_session)
  })
  })
}
