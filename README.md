# SCE: Statistical Concepts Explorer

An interactive Shiny application for learning statistics, game theory,
data analysis, psychometrics, and machine learning. Features 65+ modules
with guided explanations, interactive simulations, and quizzes.

## Installation

### Option 1: Install from R

Requires R (≥ 4.1.0). Open R or RStudio and run:

```r
# Install the remotes package if you don't have it
install.packages("remotes")

# Download and install SCE from GitHub
remotes::install_github("Tchumburman/SCE")

# Launch the app
library(SCE)
run_app()
```

The app will open in your default browser.

### Option 2: Windows Installer

Download the standalone installer from [Releases](https://github.com/Tchumburman/SCE/releases).
No R installation required — everything is bundled (R-Portable + all packages).

## Features

- **65+ interactive modules** covering statistics, machine learning, psychometrics, game theory, and more
- **Dark/light mode toggle** with Solarized color theming
- **Guided learning mode** with step-by-step explanations and quizzes
- **Your Data module** — upload your own CSV/Excel data and:
  - Explore summaries, visualize distributions, and run quick statistical tests
  - Clean data (filter, recode, handle missing values, transform columns) with full undo support
  - Fit linear or logistic regression with diagnostic plots
  - Generate downloadable HTML reports
- **Progress indicators** on all heavy computations across 20 modules
- **Lazy module loading** and memory reclamation for smooth performance

## Topics Covered

- Descriptive statistics and distributions
- Sampling and experimental design
- Hypothesis testing, confidence intervals, and power analysis
- Regression, GLMs, and multilevel models
- Bayesian analysis and MCMC
- Machine learning (trees, random forests, KNN, SVM, neural networks)
- Factor analysis, SEM, clustering, and dimension reduction
- Psychometrics (IRT, reliability, fairness, CAT)
- Game theory and information theory
- Signal detection, clinical trials, and more

## License

MIT

---
*Developed by [Psycholo.ge](https://psycholo.ge)*
