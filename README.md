# Statistical Concepts Explorer — v1.2.1

An interactive Shiny application for building intuition about statistical concepts through visualization and simulation. Built with [bslib](https://rstudio.github.io/bslib/) (Bootstrap 5) and [plotly](https://plotly.com/r/) for a modern, responsive interface with dark/light mode support.

Developed by [Psycholo.ge](https://psycholo.ge) — Everything About Psychology.

---

## Features

- **65 interactive modules** across 8 topic areas (~56,000 lines of R)
- **436 interactive plots** powered by ggplot2 and plotly
- **306 quiz questions** with explanations for self-assessment
- **Dark/light mode** with Solarized-themed styling and instant client-side toggle
- **Guided learning mode** that auto-expands educational explanations
- **Statistical test selector** — answer questions about your data to get method recommendations
- **User data upload** — explore your own CSV/Excel data within the app

## Topic Areas

| Area | Modules | Topics |
|------|---------|--------|
| **General Concepts** | 10 | Data quality, multiple imputation, statistical phenomena, data preparation, visualization principles, game theory, information theory, signal detection, interrater reliability, text analysis |
| **Distributions** | 3 | Distribution shapes (Normal, t, F, χ², Binomial, Poisson), CLT, Law of Large Numbers, descriptive statistics |
| **Sampling & Design** | 4 | Sampling methods, experimental design, survey methodology, clinical trials |
| **Inference** | 16 | Mean comparisons, CIs, bootstrapping, Bayesian updating, power analysis, corrections, causal inference, effect sizes, Monte Carlo, sequential testing, p-hacking, open science |
| **Modeling** | 10 | Regression (OLS, GLM, Bayesian), diagnostics, multilevel, mediation/moderation, time series, count models, GAMs, quantile regression, GEE |
| **Multivariate** | 5 | Factor analysis/PCA, clustering, SEM, latent class analysis, growth mixture models |
| **Machine Learning** | 3 | Decision trees, random forests, KNN, SVM, neural networks, model evaluation, AI/LLM internals |
| **Psychometrics** | 10 | IRT (1–3PL, polytomous, MIRT), Rasch, reliability, scoring, fairness/DIF, equating, CAT, validity, large-scale assessment |

## Requirements

**R version**: 4.4.0 or later recommended.

**Required packages** (install before first run):

```r
install.packages(c(
  "shiny", "bslib", "ggplot2", "plotly",
  "lavaan", "MASS", "GPArotation", "rpart", "randomForest",
  "class", "e1071", "nnet", "RColorBrewer", "gridExtra",
  "glmnet", "lme4", "cluster", "scales", "readxl",
  "forecast", "wordcloud", "tidytext"
))
```

Additional packages used via `::` (install if the relevant module throws an error):

```r
install.packages(c("splines", "survival", "igraph"))
```

(`splines` and `grDevices` ship with base R and do not need installation.)

## Running the App

Open the project in RStudio and run:

```r
shiny::runApp("Statistical_Concepts_Explorer")
```

Or from within the project directory:

```r
shiny::runApp()
```

The app launches in your default browser. Use the navigation bar to browse topic areas, or start from the welcome page which provides an overview of all modules.

## Project Structure

```
Statistical_Concepts_Explorer/
├── app.R              # Main UI assembly (navbar, welcome page, server wiring)
├── global.R           # Package loading (runs before R/ modules are sourced)
├── R/                 # 67 module files, auto-sourced by Shiny
│   ├── 00_topic_metadata.R  # Difficulty ratings & related topics for all modules
│   ├── helpers.R      # Shared UI components (nav_card, explanation_box, etc.)
│   ├── mod_*.R        # One file per module (UI + server functions)
│   └── ...
├── www/
│   └── logo.png       # App logo
├── manifest.json      # Deployment manifest
└── rsconnect/         # Deployment configuration
```

Each module file (`mod_*.R`) defines a `*_ui()` and `*_server()` function pair using Shiny's `moduleServer()` pattern with proper namespace isolation (`NS()`). Modules are self-contained: each generates its own simulated data, builds its own plots, and renders its own educational text.

## Architecture Notes

- **No external data files** — all data is generated via simulation within each module, making the app fully self-contained.
- **Button-gated computation** — expensive simulations are triggered by action buttons rather than re-running on every slider change. Modules auto-fire once on load via `session$onFlushed()`.
- **Client-side dark mode** — theme switching is handled entirely in JavaScript by toggling `data-bs-theme` on the `<html>` element, with plotly charts restyled via `Plotly.relayout()`.
- **Guided learning mode** — a `MutationObserver` watches for tab changes and auto-expands explanation accordions when guided mode is active.
- **Responsive navbar** — collapses at 1400px (xxl breakpoint) with pinned utility icons (quiz, upload, test selector, references, guided mode, dark mode) that remain visible outside the hamburger menu.

## Changelog

### v1.2.1

- **Topic difficulty ratings** — each topic card and module page shows a 1–5 difficulty scale (Introductory → Expert) with color-coded dots
- **Related topics** — "See also" links on welcome page cards and "Related" pills inside each module page for easy cross-navigation
- **"Don't know where to start?"** — collapsible beginner learning path on the welcome page suggesting 7 foundational topics in order
- Centralized topic metadata (`R/00_topic_metadata.R`) for difficulty and cross-references across all 61 topics

## License

© Psycholo.ge — All rights reserved.
