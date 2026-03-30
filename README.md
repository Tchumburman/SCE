# Statistical Concepts Explorer

**An interactive learning tool for statistics, built entirely in R.**

Statistical Concepts Explorer is a Shiny application that helps students, researchers, and practitioners build intuition about statistical concepts through hands-on visualization and simulation. Every concept comes with interactive controls, real-time plots, and plain-language explanations — no datasets required, everything is generated on the fly.

Whether you're a psychology student encountering ANOVA for the first time, a researcher brushing up on Bayesian methods, or a psychometrician working with IRT models, the app covers the full spectrum from introductory to expert-level topics. Each topic is rated by difficulty (1–5) and linked to related concepts so you always know where to go next.

Developed by [Psycholo.ge](https://psycholo.ge) — Everything About Psychology.

---

## Installation

### Option A: Standalone Installer (no R needed)

The easiest way to get started. The installer bundles its own copy of R and all required packages — just download, install, and run.

**[⬇ Download the installer (v1.2.1)](https://github.com/Tchumburman/SCE/releases/latest)**

1. Go to the [Releases](https://github.com/Tchumburman/SCE/releases/latest) page
2. Download **StatisticalConceptsExplorer_Setup_v1.2.1.exe** (~393 MB)
3. Run the installer — it will create a Start Menu and optional desktop shortcut
4. Launch from the shortcut; the app opens in your default browser

> The installer requires Windows 10 or later. No admin privileges needed — it installs to your user AppData folder.

### Option B: Run from R / RStudio

If you already have R installed, you can run the app directly from source.

**Requirements:** R 4.4.0 or later.

**Step 1.** Clone or download this repository:

```bash
git clone https://github.com/Tchumburman/SCE.git
```

Or click the green **Code** button above → **Download ZIP**, then extract.

**Step 2.** Install required packages (one-time setup):

```r
install.packages(c(
  "shiny", "bslib", "ggplot2", "plotly",
  "lavaan", "MASS", "GPArotation", "rpart", "randomForest",
  "class", "e1071", "nnet", "RColorBrewer", "gridExtra",
  "glmnet", "lme4", "cluster", "scales", "readxl",
  "forecast", "wordcloud", "tidytext"
))
```

Some modules also use these packages via `::` — install them if a module throws an error:

```r
install.packages(c("survival", "igraph"))
```

(`splines` and `grDevices` ship with base R and do not need installation.)

**Step 3.** Run the app:

```r
# From within the project directory:
shiny::runApp()

# Or from a parent directory:
shiny::runApp("SCE")
```

The app launches in your default browser.

---

## What's Inside

### Features

- **65 interactive modules** across 8 topic areas (~56,000 lines of R)
- **436 interactive plots** powered by ggplot2 and plotly
- **306 quiz questions** with explanations for self-assessment
- **Topic difficulty ratings** (1–5) and cross-linked related topics on every page
- **"Don't know where to start?"** — a guided beginner learning path on the welcome page
- **Dark/light mode** with Solarized-themed styling and instant toggle
- **Guided learning mode** that auto-expands educational explanations
- **Statistical test selector** — answer questions about your data to get method recommendations
- **User data upload** — explore your own CSV/Excel data within the app

### Topic Areas

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

---

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
│   ├── app.js         # Client-side JS (dark mode, guided mode, navbar)
│   ├── style.css      # Custom styles
│   └── logo.png       # App logo
├── manifest.json      # Deployment manifest
└── rsconnect/         # Deployment configuration
```

Each module file (`mod_*.R`) defines a `*_ui()` and `*_server()` function pair using Shiny's `moduleServer()` pattern with proper namespace isolation (`NS()`). Modules are self-contained: each generates its own simulated data, builds its own plots, and renders its own educational text.

## Architecture Notes

- **No external data files** — all data is generated via simulation within each module, making the app fully self-contained.
- **Lazy module loading** — module servers are initialized only when the user first visits a tab, keeping startup fast.
- **Button-gated computation** — expensive simulations are triggered by action buttons rather than re-running on every slider change.
- **Client-side dark mode** — theme switching is handled entirely in JavaScript by toggling `data-bs-theme` on the `<html>` element.
- **Guided learning mode** — a `MutationObserver` watches for tab changes and auto-expands explanation accordions when guided mode is active.

## Changelog

### v1.2.1

- **Topic difficulty ratings** — each topic card and module page shows a 1–5 difficulty scale (Introductory → Expert) with color-coded dots
- **Related topics** — "See also" links on welcome page cards and "Related" pills inside each module page for easy cross-navigation
- **"Don't know where to start?"** — collapsible beginner learning path on the welcome page suggesting 7 foundational topics in order
- Centralized topic metadata (`R/00_topic_metadata.R`) for difficulty and cross-references across all 61 topics

## License

© Psycholo.ge — All rights reserved.
