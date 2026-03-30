# ---------------------------------------------------------------------------
# Topic metadata: difficulty (1-5) and related topics
# Keyed by the nav_panel target value (used for navigation).
# ---------------------------------------------------------------------------

topic_meta <- list(

  # ── General Concepts ─────────────────────────────────────────────────────
  "Data Quality" = list(
    difficulty = 2,
    related = c("Multiple Imputation", "Data Preparation", "Assumption Violations")
  ),
  "Multiple Imputation" = list(
    difficulty = 4,
    related = c("Data Quality", "Bayesian Workflow", "Monte Carlo & Simulation")
  ),
  "Statistical Phenomena" = list(
    difficulty = 3,
    related = c("Causal Inference", "Regression Core", "Visualization Principles")
  ),
  "Data Preparation" = list(
    difficulty = 2,
    related = c("Data Quality", "Distribution Shapes", "Model Diagnostics")
  ),
  "Visualization Principles" = list(
    difficulty = 1,
    related = c("Data Summary", "Distribution Shapes", "Statistical Phenomena")
  ),
  "Game Theory" = list(
    difficulty = 3,
    related = c("Monte Carlo & Simulation", "Bayesian & Power", "Information Theory")
  ),
  "Information Theory" = list(
    difficulty = 4,
    related = c("Bayesian Workflow", "Machine Learning", "Model Evaluation")
  ),
  "Signal Detection Theory" = list(
    difficulty = 3,
    related = c("Type I & II Errors", "Bayesian & Power", "Model Evaluation")
  ),
  "Interrater Reliability" = list(
    difficulty = 2,
    related = c("Categorical & Association", "Test & Item Quality", "Fairness & Bias")
  ),
  "Text Analysis" = list(
    difficulty = 2,
    related = c("Visualization Principles", "Dimension Reduction", "Clustering & Classification")
  ),


  # ── Distributions ────────────────────────────────────────────────────────
  "Distribution Shapes" = list(
    difficulty = 1,
    related = c("Data Summary", "Sampling Theorems", "Assumption Violations")
  ),
  "Sampling Theorems" = list(
    difficulty = 2,
    related = c("Distribution Shapes", "Sampling", "Confidence & Resampling")
  ),
  "Data Summary" = list(
    difficulty = 1,
    related = c("Distribution Shapes", "Visualization Principles", "Bayesian & Power")
  ),

  # ── Sampling & Design ───────────────────────────────────────────────────
  "Sampling" = list(
    difficulty = 2,
    related = c("Sampling Theorems", "Survey Methodology", "Experimental Design")
  ),
  "Experimental Design" = list(
    difficulty = 3,
    related = c("Sampling", "Mean Comparisons", "Power: Complex Designs")
  ),
  "Survey Methodology" = list(
    difficulty = 3,
    related = c("Sampling", "Confidence & Resampling", "Clinical Trials")
  ),
  "Clinical Trials" = list(
    difficulty = 4,
    related = c("Experimental Design", "Sequential Testing", "Causal Inference")
  ),

  # ── Inference ────────────────────────────────────────────────────────────
  "Mean Comparisons" = list(
    difficulty = 2,
    related = c("Assumption Violations", "Corrections & Robustness", "Effect Size Explorer")
  ),
  "Confidence & Resampling" = list(
    difficulty = 2,
    related = c("Sampling Theorems", "Monte Carlo & Simulation", "Bayesian & Power")
  ),
  "Categorical & Association" = list(
    difficulty = 2,
    related = c("Mean Comparisons", "Interrater Reliability", "Effect Size Explorer")
  ),
  "Bayesian & Power" = list(
    difficulty = 3,
    related = c("Bayesian Workflow", "Type I & II Errors", "Confidence & Resampling")
  ),
  "Corrections & Robustness" = list(
    difficulty = 3,
    related = c("Mean Comparisons", "Assumption Violations", "p-Hacking Simulator")
  ),
  "Specialized Inference" = list(
    difficulty = 4,
    related = c("Regression Core", "Clinical Trials", "Replication & Open Science")
  ),
  "Assumption Violations" = list(
    difficulty = 3,
    related = c("Mean Comparisons", "Model Diagnostics", "Corrections & Robustness")
  ),
  "Causal Inference" = list(
    difficulty = 5,
    related = c("Statistical Phenomena", "Regression Core", "Experimental Design")
  ),
  "Effect Size Explorer" = list(
    difficulty = 2,
    related = c("Mean Comparisons", "Bayesian & Power", "Replication & Open Science")
  ),
  "Monte Carlo & Simulation" = list(
    difficulty = 3,
    related = c("Confidence & Resampling", "Bayesian Workflow", "Power: Complex Designs")
  ),
  "Bayesian Workflow" = list(
    difficulty = 4,
    related = c("Bayesian & Power", "Monte Carlo & Simulation", "Information Theory")
  ),
  "p-Hacking Simulator" = list(
    difficulty = 3,
    related = c("Replication & Open Science", "Corrections & Robustness", "Type I & II Errors")
  ),
  "Sequential Testing" = list(
    difficulty = 4,
    related = c("Clinical Trials", "Bayesian Workflow", "Type I & II Errors")
  ),
  "Power: Complex Designs" = list(
    difficulty = 4,
    related = c("Multilevel Models", "Experimental Design", "Mediation & Moderation")
  ),
  "Replication & Open Science" = list(
    difficulty = 2,
    related = c("p-Hacking Simulator", "Effect Size Explorer", "Specialized Inference")
  ),
  "Type I & II Errors" = list(
    difficulty = 2,
    related = c("Bayesian & Power", "Signal Detection Theory", "p-Hacking Simulator")
  ),

  # ── Modeling ─────────────────────────────────────────────────────────────
  "Regression Core" = list(
    difficulty = 3,
    related = c("Model Diagnostics", "Extended Models", "Mean Comparisons")
  ),
  "Model Diagnostics" = list(
    difficulty = 3,
    related = c("Regression Core", "Assumption Violations", "GAMs")
  ),
  "Multilevel Models" = list(
    difficulty = 4,
    related = c("Extended Models", "GEE", "Power: Complex Designs")
  ),
  "Extended Models" = list(
    difficulty = 4,
    related = c("Regression Core", "Multilevel Models", "Count Data Models")
  ),
  "Mediation & Moderation" = list(
    difficulty = 3,
    related = c("Regression Core", "Structural Models", "Causal Inference")
  ),
  "Time Series" = list(
    difficulty = 3,
    related = c("Regression Core", "Data Preparation", "GAMs")
  ),
  "Count Data Models" = list(
    difficulty = 3,
    related = c("Regression Core", "Extended Models", "Model Diagnostics")
  ),
  "GAMs" = list(
    difficulty = 4,
    related = c("Regression Core", "Model Diagnostics", "Quantile Regression")
  ),
  "Quantile Regression" = list(
    difficulty = 3,
    related = c("Regression Core", "GAMs", "Model Diagnostics")
  ),
  "GEE" = list(
    difficulty = 4,
    related = c("Multilevel Models", "Extended Models", "Survey Methodology")
  ),

  # ── Multivariate ─────────────────────────────────────────────────────────
  "Dimension Reduction" = list(
    difficulty = 3,
    related = c("Clustering & Classification", "Structural Models", "Test & Item Quality")
  ),
  "Clustering & Classification" = list(
    difficulty = 3,
    related = c("Dimension Reduction", "Machine Learning", "Latent Class Analysis")
  ),
  "Structural Models" = list(
    difficulty = 4,
    related = c("Dimension Reduction", "Mediation & Moderation", "Validity & Measurement")
  ),
  "Latent Class Analysis" = list(
    difficulty = 4,
    related = c("Clustering & Classification", "Growth Mixture Models", "Dimension Reduction")
  ),
  "Growth Mixture Models" = list(
    difficulty = 5,
    related = c("Latent Class Analysis", "Multilevel Models", "Structural Models")
  ),

  # ── Machine Learning ─────────────────────────────────────────────────────
  "Machine Learning" = list(
    difficulty = 3,
    related = c("Model Evaluation", "Clustering & Classification", "Regression Core")
  ),
  "Model Evaluation" = list(
    difficulty = 3,
    related = c("Machine Learning", "Signal Detection Theory", "Model Diagnostics")
  ),
  "AI & LLMs" = list(
    difficulty = 4,
    related = c("Machine Learning", "Information Theory", "Model Evaluation")
  ),

  # ── Psychometrics ────────────────────────────────────────────────────────
  "IRT Models" = list(
    difficulty = 4,
    related = c("Rasch Family", "Test & Item Quality", "Scoring & Reporting")
  ),
  "Rasch Family" = list(
    difficulty = 4,
    related = c("IRT Models", "Test & Item Quality", "Fairness & Bias")
  ),
  "Test & Item Quality" = list(
    difficulty = 2,
    related = c("IRT Models", "Scoring & Reporting", "Interrater Reliability")
  ),
  "Scoring & Reporting" = list(
    difficulty = 3,
    related = c("IRT Models", "Test & Item Quality", "Equating & Linking")
  ),
  "Fairness & Bias" = list(
    difficulty = 4,
    related = c("IRT Models", "Rasch Family", "Validity & Measurement")
  ),
  "Equating & Linking" = list(
    difficulty = 5,
    related = c("IRT Models", "Scoring & Reporting", "Large-Scale Assessment")
  ),
  "Adaptive Testing" = list(
    difficulty = 4,
    related = c("IRT Models", "Sequential Testing", "Large-Scale Assessment")
  ),
  "Validity & Measurement" = list(
    difficulty = 3,
    related = c("Structural Models", "Test & Item Quality", "Fairness & Bias")
  ),
  "Advanced Models" = list(
    difficulty = 5,
    related = c("IRT Models", "Latent Class Analysis", "Adaptive Testing")
  ),
  "Large-Scale Assessment" = list(
    difficulty = 5,
    related = c("Equating & Linking", "Survey Methodology", "Adaptive Testing")
  )
)

# Difficulty label lookup
difficulty_labels <- c(
  "Introductory",
  "Beginner",
  "Intermediate",
  "Advanced",
  "Expert"
)
