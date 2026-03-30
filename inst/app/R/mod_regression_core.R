# Module: Regression Core (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
regression_core_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Regression Core",
  icon = icon("chart-line"),
  navset_card_underline(
    nav_panel(
      "OLS Regression",
  navset_card_underline(
    # ---- Tab 1: Simulated Data -------------------------------------------
    nav_panel(
      "Simulated Data",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          sliderInput(ns("ols_n"), "Number of points", min = 10, max = 1000, value = 30),
          sliderInput(ns("ols_noise"), "Noise level (\u03c3)", min = 0.5, max = 10, value = 3, step = 0.5),
          sliderInput(ns("ols_slope"), "True slope", min = -3, max = 3, value = 1, step = 0.25),
          sliderInput(ns("ols_intercept"), "True intercept", min = -5, max = 5, value = 2, step = 0.5),
          actionButton(ns("ols_new"), "New data", class = "btn-success w-100 mb-2"),
          tags$hr(),
          selectInput(ns("ols_model"), "Model type",
                      choices = c("Linear", "Quadratic", "Cubic", "Logarithmic", "None (points only)")),
          checkboxInput(ns("ols_residuals"), "Show residual lines", value = TRUE),
          checkboxInput(ns("ols_mean_line"), "Show mean line (\u0233)", value = FALSE),
          checkboxInput(ns("ols_resid_plot"), "Show residual plot", value = FALSE),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
                 "Click on the plot to add a point. Use this to see how outliers
                  affect the regression line."),
          actionButton(ns("ols_undo"), "Undo last point", class = "btn-outline-secondary w-100 mb-2"),
          actionButton(ns("ols_clear_added"), "Clear added points", class = "btn-outline-danger w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Ordinary Least Squares Regression"),
            tags$p("OLS regression finds the best-fitting line (or curve) by minimising
                    the sum of squared residuals \u2014 the vertical distances from each data
                    point to the fitted line. Mathematically, it minimises \u2211(y\u1d62 \u2212 \u0177\u1d62)\u00b2.
                    It is the foundation of most regression analysis, and under the
                    Gauss-Markov conditions it is the Best Linear Unbiased Estimator (BLUE)."),
            tags$p("R\u00b2 (coefficient of determination) measures the proportion of variance
                    in Y explained by the model. Comparing the regression line to the mean
                    line (\u0233) illustrates this: R\u00b2 = 1 \u2212 SS_res / SS_tot. An R\u00b2
                    of 0.70 means the model accounts for 70% of the variability in Y."),
            tags$p("Key assumptions: linearity (the relationship is linear in the parameters),
                    independence of errors, homoscedasticity (constant error variance), and
                    normality of errors (for inference). Violations of these assumptions do not
                    bias the coefficient estimates but can make standard errors, p-values, and
                    confidence intervals unreliable. The Diagnostics module explores these issues
                    in detail."),
            guide = tags$ol(
              tags$li("Click 'New data' to generate points with the specified slope, intercept, and noise."),
              tags$li("Choose a model type: Linear, Quadratic, Cubic, Logarithmic, or None (points only)."),
              tags$li("Toggle 'Show residual lines' to see the vertical distances being minimized."),
              tags$li("Toggle 'Show mean line' to compare the regression to the simplest possible model."),
              tags$li("Click directly on the plot to add an outlier point \u2014 watch how the line shifts."),
              tags$li("Use 'Undo' or 'Clear added points' to remove them. Toggle 'Show residual plot' to check for patterns.")
            )
          ),
          card(full_screen = TRUE, card_header("Scatter & Fit"),
               plotOutput(ns("ols_plot"), height = "450px", click = "ols_click")),
          conditionalPanel(ns = ns, 
            "input.ols_resid_plot",
            card(full_screen = TRUE, card_header("Residual Plot"),
                 plotly::plotlyOutput(ns("ols_resid"), height = "320px"))
          )
        )
      )
    ),

    # ---- Tab 2: Manual Data Entry ----------------------------------------
    nav_panel(
      "Manual Data",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
                 "Enter up to 30 X and Y values, separated by commas, spaces, or newlines."),
          textAreaInput(ns("ols_man_x"), "X values",
                        placeholder = "e.g. 1, 2, 3, 4, 5", rows = 3),
          textAreaInput(ns("ols_man_y"), "Y values",
                        placeholder = "e.g. 2.1, 3.8, 5.2, 7.0, 8.5", rows = 3),
          actionButton(ns("ols_man_apply"), "Apply data", class = "btn-success w-100 mb-2"),
          uiOutput(ns("ols_man_msg")),
          tags$hr(),
          selectInput(ns("ols_man_model"), "Model type",
                      choices = c("Linear", "Quadratic", "Cubic", "Logarithmic", "None (points only)")),
          checkboxInput(ns("ols_man_residuals"), "Show residual lines", value = TRUE),
          checkboxInput(ns("ols_man_mean_line"), "Show mean line (\u0233)", value = FALSE),
          checkboxInput(ns("ols_man_resid_plot"), "Show residual plot", value = FALSE),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
                 "Click on the plot to add extra points."),
          actionButton(ns("ols_man_undo"), "Undo last point", class = "btn-outline-secondary w-100 mb-2"),
          actionButton(ns("ols_man_clear_added"), "Clear added points", class = "btn-outline-danger w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Manual Data \u2014 OLS Regression"),
            tags$p("Enter your own X and Y data to explore regression concepts with
                    real numbers. All the same tools are available: model fitting,
                    residual diagnostics, the mean line comparison, and click-to-add
                    points for outlier analysis."),
            tags$p("This tab is useful for building intuition about influence and leverage.
                    Try adding an outlier far from the rest of the data and observe how
                    the regression line shifts. Points that are extreme in X (high leverage)
                    and far from the fitted line (large residual) have the most influence
                    on the regression coefficients. A single influential point can dramatically
                    change the slope and intercept."),
            tags$p("Comparing the regression line to the mean line (toggle \u201cShow mean line\u201d)
                    illustrates what regression achieves: it explains variance in Y beyond
                    what is captured by the overall mean. R\u00b2 is the proportional reduction
                    in squared error from using the regression line instead of the mean line.
                    When R\u00b2 is low, the regression line is barely better than the flat mean."),
            tags$p("The residual plot (toggle \u201cShow residual plot\u201d) is one of the most
                    important diagnostic tools. Patterns in the residuals \u2014 curvature,
                    fanning, or clustering \u2014 indicate model misspecification that the
                    R\u00b2 value alone cannot reveal."),
            guide = tags$ol(
              tags$li("Type X values in the first box and matching Y values in the second box (same number of values)."),
              tags$li("Click 'Apply data' to load them into the plot."),
              tags$li("Choose a model type and toggle diagnostics just like the Simulated tab."),
              tags$li("Click on the plot to add extra points and observe how they affect the fit.")
            )
          ),
          card(card_header("Data Preview"), tableOutput(ns("ols_man_table"))),
          card(full_screen = TRUE, card_header("Scatter & Fit"),
               plotOutput(ns("ols_man_plot"), height = "450px", click = "ols_man_click")),
          conditionalPanel(ns = ns, 
            "input.ols_man_resid_plot",
            card(full_screen = TRUE, card_header("Residual Plot"),
                 plotly::plotlyOutput(ns("ols_man_resid"), height = "320px"))
          )
        )
      )
    )
  )
    ),

    nav_panel(
      "GLM",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("glm_family"), "Model Family",
                  choices = c("Logistic (Binomial)" = "binomial",
                              "Poisson" = "poisson",
                              "Gaussian (Linear)" = "gaussian")),
      tags$hr(),
      tags$h6("Data Generation"),
      sliderInput(ns("glm_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
      sliderInput(ns("glm_b0"), "Intercept (\u03b20)", min = -3, max = 3, value = -1, step = 0.25),
      sliderInput(ns("glm_b1"), "Slope (\u03b21)", min = -3, max = 3, value = 1.5, step = 0.25),
      actionButton(ns("glm_go"), "Generate & Fit", class = "btn-success w-100 mb-2"),
      actionButton(ns("glm_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    fillable = FALSE,
    div(
      explanation_box(
        tags$strong("Generalized Linear Models (GLM)"),
        tags$p("GLM extends linear regression to handle non-normal response variables.
                A GLM has three components: (1) a ", tags$em("random component"), " specifying
                the distribution of Y (Normal, Binomial, Poisson, etc.), (2) a ",
                tags$em("systematic component"), " (the linear predictor \u03b7 = X\u03b2), and
                (3) a ", tags$em("link function"), " g() connecting the mean of Y to the linear
                predictor: g(\u03bc) = \u03b7."),
        tags$p("Logistic regression models binary outcomes (success/failure) using the logit
                link: log(p/(1\u2212p)) = X\u03b2. Coefficients are log-odds ratios; exponentiating
                gives odds ratios. Poisson regression models count data using the log link:
                log(\u03bc) = X\u03b2. Coefficients represent log-rate ratios."),
        tags$p("GLM coefficients are estimated via maximum likelihood, not OLS. Goodness-of-fit
                is assessed using deviance (analogous to residual sum of squares) and the AIC.
                For logistic regression, classification metrics (accuracy, ROC curves) complement
                the model summary. For Poisson regression, overdispersion (variance exceeding
                the mean) is a common problem that requires a quasi-Poisson or negative binomial
                model instead."),
        guide = tags$ol(
          tags$li("Choose a model family (Logistic, Poisson, or Gaussian)."),
          tags$li("Set the intercept and slope to control the true relationship."),
          tags$li("Click 'Generate & Fit' to simulate data and fit the GLM."),
          tags$li("The top plot shows data with the fitted curve and confidence band."),
          tags$li("The bottom panel shows the model summary with coefficient estimates, SEs, and p-values."),
          tags$li("Compare families to see how the link function changes the relationship shape.")
        )
      ),
      card(
        full_screen = TRUE,
        card_header("Data & Fitted Model"),
        plotly::plotlyOutput(ns("glm_plot"), height = "480px")
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(
          card_header("Model Summary"),
          div(style = "font-size: 1.05rem;",
              tableOutput(ns("glm_summary")))
        ),
        card(
          card_header("Deviance & Fit Statistics"),
          uiOutput(ns("glm_deviance"))
        )
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(full_screen = TRUE, card_header("Residuals vs Fitted"),
             plotly::plotlyOutput(ns("glm_diag1"), height = "320px")),
        card(full_screen = TRUE, card_header("Normal Q-Q"),
             plotly::plotlyOutput(ns("glm_diag2"), height = "320px"))
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(full_screen = TRUE, card_header("Scale-Location"),
             plotly::plotlyOutput(ns("glm_diag3"), height = "320px")),
        card(full_screen = TRUE, card_header("Cook's Distance"),
             plotly::plotlyOutput(ns("glm_diag4"), height = "320px"))
      )
    )
  )
    ),

    nav_panel(
      "Bayesian Regression",
  layout_sidebar(
    sidebar = sidebar(
      width = 310,
      tags$h6("True Model: Y = \u03b20 + \u03b21\u00b7X + \u03b5"),
      sliderInput(ns("breg_true_b0"), "True intercept (\u03b20)", min = -5, max = 5, value = 2, step = 0.5),
      sliderInput(ns("breg_true_b1"), "True slope (\u03b21)", min = -5, max = 5, value = 1.5, step = 0.25),
      sliderInput(ns("breg_sigma"), "Noise (\u03c3)", min = 0.5, max = 5, value = 1.5, step = 0.25),
      sliderInput(ns("breg_n"), "Sample size", min = 10, max = 500, value = 30, step = 10),
      tags$hr(),
      tags$h6("Prior on \u03b2 (Normal)"),
      sliderInput(ns("breg_prior_mean"), "Prior mean for \u03b21",
                  min = -5, max = 5, value = 0, step = 0.25),
      sliderInput(ns("breg_prior_sd"), "Prior SD for \u03b21",
                  min = 0.1, max = 10, value = 10, step = 0.1),
      tags$hr(),
      actionButton(ns("breg_go"), "Generate & Compare", class = "btn-success w-100 mb-2"),
      actionButton(ns("breg_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    fillable = FALSE,
      explanation_box(
        tags$strong("Bayesian vs. Frequentist Regression"),
        tags$p("Frequentist regression (OLS) estimates coefficients by minimizing the sum of
                squared residuals. The result is a single point estimate with a confidence
                interval based on repeated-sampling logic."),
        tags$p("Bayesian regression treats coefficients as random variables with prior
                distributions. After observing data, Bayes' theorem updates the prior to
                a posterior distribution. With a wide (vague) prior, the Bayesian and
                frequentist results nearly coincide. With a strong (informative) prior,
                the posterior is pulled toward the prior — especially when data is scarce."),
        tags$p("Try a small sample with a strong prior to see the approaches diverge,
                then increase the sample size to watch them converge."),
        guide = tags$ol(
          tags$li("Set the true intercept, slope, and noise level for the data-generating process."),
          tags$li("Choose a sample size — small sizes highlight prior influence."),
          tags$li("Set the prior mean and SD for the slope (\u03b21). A large SD = vague prior; small SD = strong prior."),
          tags$li("Click 'Generate & Compare' to simulate data and fit both models."),
          tags$li("The scatter plot shows data with both fitted lines overlaid."),
          tags$li("The posterior vs. sampling distribution plot shows how uncertainty is represented differently."),
          tags$li("The summary table compares point estimates, intervals, and interval widths.")
        )
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(
          full_screen = TRUE,
          card_header("Data & Fitted Lines"),
          plotly::plotlyOutput(ns("breg_scatter"), height = "400px")
        ),
        card(
          full_screen = TRUE,
          card_header("Slope (\u03b21): Prior, Likelihood & Posterior"),
          plotly::plotlyOutput(ns("breg_posterior"), height = "400px")
        )
      ),
      layout_column_wrap(
        width = 1 / 2,
        card(
          card_header("Comparison Table"),
          uiOutput(ns("breg_table"))
        ),
        card(
          full_screen = TRUE,
          card_header("Posterior Predictive vs. Frequentist CI"),
          plotly::plotlyOutput(ns("breg_predict"), height = "380px")
        )
      )
  )
    ),

    nav_panel(
      "MLE",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("mle_dist"), "Distribution",
                  choices = c("Normal (estimate \u03bc)", "Binomial (estimate p)",
                              "Poisson (estimate \u03bb)")),
      conditionalPanel(ns = ns, 
        "input.mle_dist === 'Normal (estimate \\u03bc)'",
        sliderInput(ns("mle_true_mu"), "True \u03bc", min = -5, max = 5, value = 2, step = 0.5),
        sliderInput(ns("mle_true_sigma"), "Known \u03c3", min = 0.5, max = 5, value = 1, step = 0.25)
      ),
      conditionalPanel(ns = ns, 
        "input.mle_dist === 'Binomial (estimate p)'",
        sliderInput(ns("mle_true_p"), "True p", min = 0.05, max = 0.95, value = 0.6, step = 0.05)
      ),
      conditionalPanel(ns = ns, 
        "input.mle_dist === 'Poisson (estimate \\u03bb)'",
        sliderInput(ns("mle_true_lambda"), "True \u03bb", min = 0.5, max = 10, value = 3, step = 0.5)
      ),
      sliderInput(ns("mle_n"), "Sample size", min = 5, max = 500, value = 20),
      actionButton(ns("mle_go"), "Generate sample & show likelihood", class = "btn-success w-100 mb-2"),
      actionButton(ns("mle_reset"), "Reset", class = "btn-outline-secondary w-100")
    ),
    explanation_box(
      tags$strong("Maximum Likelihood Estimation"),
      tags$p("Maximum Likelihood Estimation (MLE) answers the question: given the
              data I observed, what parameter value makes these data most probable?
              The likelihood function L(\u03b8) computes the joint probability of all
              observations as a function of the unknown parameter \u03b8. We work with
              the log-likelihood \u2113(\u03b8) = \u2211 log f(x\u1d62|\u03b8) because
              sums are easier to optimise and numerically more stable than products."),
      tags$p("The MLE is the value of \u03b8 that maximises \u2113(\u03b8). It has several
              desirable asymptotic properties: ", tags$em("consistency"), " (converges to the true
              value as n \u2192 \u221e), ", tags$em("efficiency"), " (achieves the smallest possible
              variance among consistent estimators), and ", tags$em("asymptotic normality"),
              " (the sampling distribution of the MLE approaches a Normal distribution,
              enabling Wald-type confidence intervals and hypothesis tests)."),
      tags$p("MLE is the estimation method underlying GLMs, survival models, mixed-effects
              models, and many other modern statistical techniques. The curvature of the
              log-likelihood at its peak determines the standard error: a sharply peaked
              log-likelihood means precise estimation, while a flat peak means substantial
              uncertainty. The observed Fisher information matrix formalises this
              relationship."),
      guide = tags$ol(
        tags$li("Choose a distribution: Normal (estimate \u03bc), Binomial (estimate p), or Poisson (estimate \u03bb)."),
        tags$li("Set the true parameter value and sample size."),
        tags$li("Click 'Generate sample & show likelihood'."),
        tags$li("The left plot shows the log-likelihood curve \u2014 the red dashed line marks the MLE (peak); the green dotted line marks the true value."),
        tags$li("The right plot shows the actual data."),
        tags$li("Try increasing n \u2014 notice the log-likelihood curve becomes sharper (more precise estimate).")
      )
    ),
    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Log-Likelihood Function"),
           plotlyOutput(ns("mle_loglik_plot"), height = "380px")),
      card(full_screen = TRUE, card_header("Sample Data"),
           plotlyOutput(ns("mle_data_plot"), height = "380px"))
    ),
    card(card_header("MLE Result"), uiOutput(ns("mle_result")))
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

regression_core_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ---- Shared helpers ----------------------------------------------------

  fit_ols_model <- function(df, model_type) {
    if (is.null(model_type) || model_type == "None (points only)") return(NULL)
    switch(model_type,
      "Linear"      = lm(y ~ x, data = df),
      "Quadratic"   = lm(y ~ x + I(x^2), data = df),
      "Cubic"       = lm(y ~ x + I(x^2) + I(x^3), data = df),
      "Logarithmic" = lm(y ~ log(pmax(x, 0.001)), data = df),
      lm(y ~ x, data = df)
    )
  }

  # Reactive dark mode flag
  is_dark <- reactive({ isTRUE(session$userData$dark_mode) })

  build_ols_plot <- function(df, fit, model_name, show_residuals, show_mean_line, dark = FALSE) {
    ybar <- mean(df$y)
    pt_col <- if (dark) "#2aa198" else "#073642"
    line_col <- if (dark) "#2aa198" else "#268bd2"
    resid_col <- if (dark) "#2aa198" else "#2aa198"
    bg_col <- "transparent"
    text_col <- if (dark) "#93a1a1" else "#073642"

    p <- ggplot(df, aes(x, y)) +
      geom_point(aes(shape = source), size = 2.8, color = pt_col, alpha = 0.8) +
      scale_shape_manual(values = c("original" = 16, "added" = 17),
                         labels = c("original" = "Original", "added" = "Added"),
                         guide = if (any(df$source == "added")) "legend" else "none")

    if (!is.null(fit)) {
      df$fitted <- fitted(fit)
      df$resid  <- residuals(fit)

      x_seq <- seq(min(df$x), max(df$x), length.out = 300)
      pred_df <- data.frame(x = x_seq)
      pred_df$y <- predict(fit, newdata = pred_df)
      p <- p + geom_line(data = pred_df, aes(x, y),
                          color = line_col, linewidth = 1.2)

      if (show_residuals) {
        seg_df <- data.frame(x = df$x, y = df$y, yend = df$fitted)
        p <- p +
          geom_segment(data = seg_df, aes(x = x, xend = x, y = y, yend = yend),
                       color = resid_col, linewidth = 0.5, alpha = 0.6)
      }

      r2 <- summary(fit)$r.squared
      sse <- sum(df$resid^2)
      n_added <- sum(df$source == "added")
      sub_text <- paste0(
        model_name, " fit",
        "   |   R\u00b2 = ", round(r2, 3),
        "   |   SSR = ", round(sse, 1)
      )
      if (n_added > 0) sub_text <- paste0(sub_text, "   |   ", n_added, " added point(s)")
    } else {
      sub_text <- "No model \u2014 points only"
      n_added <- sum(df$source == "added")
      if (n_added > 0) sub_text <- paste0(sub_text, "   |   ", n_added, " added point(s)")
    }

    if (show_mean_line) {
      p <- p +
        geom_hline(yintercept = ybar, color = "#e31a1c", linewidth = 0.9,
                   linetype = "dashed") +
        annotate("label", x = min(df$x), y = ybar,
                 label = paste0("  \u0233 = ", round(ybar, 2)),
                 hjust = 0, vjust = -0.4, size = 4, color = "#e31a1c",
                 fill = "#e5f5f9", label.size = 0)
    }

    p + labs(x = "x", y = "y", subtitle = sub_text, shape = NULL) +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = if (any(df$source == "added")) "top" else "none",
        plot.background = element_rect(fill = bg_col, color = NA),
        panel.background = element_rect(fill = bg_col, color = NA),
        text = element_text(color = text_col),
        axis.text = element_text(color = text_col),
        panel.grid = element_line(color = if (dark) "grey30" else "grey90")
      )
  }

  build_resid_plotly <- function(df, fit) {
    rdf <- data.frame(fitted = fitted(fit), resid = residuals(fit),
                      source = df$source)
    plotly::plot_ly() |>
      plotly::add_markers(
        x = rdf$fitted, y = rdf$resid,
        marker = list(
          color = ifelse(rdf$source == "added", "#e31a1c", "#00441b"),
          size = 5, opacity = 0.6,
          symbol = ifelse(rdf$source == "added", "triangle-up", "circle")
        ),
        showlegend = FALSE,
        hoverinfo = "text",
        text = paste0("Fitted: ", round(rdf$fitted, 2),
                      "<br>Residual: ", round(rdf$resid, 2))
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = min(rdf$fitted), x1 = max(rdf$fitted),
          y0 = 0, y1 = 0, xref = "x", yref = "y",
          line = list(color = "grey50", width = 1, dash = "dash")
        )),
        xaxis = list(title = "Fitted values"),
        yaxis = list(title = "Residuals"),
        margin = list(t = 20)
      )
  }

  combine_base_added <- function(base, added) {
    if (nrow(added) > 0) {
      df <- rbind(base, added)
      df$source <- c(rep("original", nrow(base)), rep("added", nrow(added)))
    } else {
      df <- base
      df$source <- "original"
    }
    df
  }

  # ---- Tab 1: Simulated Data --------------------------------------------

  ols_base <- reactiveVal(NULL)
  ols_added <- reactiveVal(data.frame(x = numeric(0), y = numeric(0)))

  generate_ols <- function() {
    set.seed(sample(1:10000, 1))
    n <- input$ols_n
    x <- runif(n, 0, 10)
    y <- input$ols_intercept + input$ols_slope * x + rnorm(n, 0, input$ols_noise)
    data.frame(x = x, y = y)
  }

  observeEvent(input$ols_new, {
    ols_base(generate_ols())
    ols_added(data.frame(x = numeric(0), y = numeric(0)))
  })

  observe({
    if (is.null(ols_base())) ols_base(generate_ols())
  })

  observeEvent(input$ols_click, {
    pt <- input$ols_click
    req(pt$x, pt$y)
    ols_added(rbind(ols_added(), data.frame(x = pt$x, y = pt$y)))
  })

  observeEvent(input$ols_undo, {
    added <- ols_added()
    if (nrow(added) > 0) ols_added(added[-nrow(added), , drop = FALSE])
  })

  observeEvent(input$ols_clear_added, {
    ols_added(data.frame(x = numeric(0), y = numeric(0)))
  })

  ols_data <- reactive({
    base <- ols_base()
    req(base)
    combine_base_added(base, ols_added())
  })

  ols_fit <- reactive({
    df <- ols_data(); req(df)
    fit_ols_model(df, input$ols_model)
  })

  output$ols_plot <- renderPlot(bg = "transparent", {
    df <- ols_data(); req(df)
    build_ols_plot(df, ols_fit(), input$ols_model,
                   input$ols_residuals, input$ols_mean_line, dark = is_dark())
  })

  output$ols_resid <- plotly::renderPlotly({
    fit <- ols_fit(); req(fit)
    build_resid_plotly(ols_data(), fit)
  })

  # ---- Tab 2: Manual Data ------------------------------------------------

  ols_man_base <- reactiveVal(NULL)
  ols_man_added <- reactiveVal(data.frame(x = numeric(0), y = numeric(0)))

  parse_vals <- function(txt) {
    txt <- trimws(txt)
    if (nchar(txt) == 0) return(numeric(0))
    vals <- strsplit(txt, "[,\\s]+", perl = TRUE)[[1]]
    suppressWarnings(as.numeric(vals))
  }

  observeEvent(input$ols_man_apply, {
    xv <- parse_vals(input$ols_man_x)
    yv <- parse_vals(input$ols_man_y)

    if (length(xv) == 0 || length(yv) == 0) {
      output$ols_man_msg <- renderUI(
        tags$p(style = "color: #e31a1c; font-size: 0.85rem;",
               icon("triangle-exclamation"), " Enter at least 2 X and Y values."))
      ols_man_base(NULL)
      return()
    }
    if (length(xv) != length(yv)) {
      output$ols_man_msg <- renderUI(
        tags$p(style = "color: #e31a1c; font-size: 0.85rem;",
               icon("triangle-exclamation"),
               sprintf(" X has %d values but Y has %d \u2014 they must match.",
                       length(xv), length(yv))))
      ols_man_base(NULL)
      return()
    }
    if (any(is.na(xv)) || any(is.na(yv))) {
      output$ols_man_msg <- renderUI(
        tags$p(style = "color: #e31a1c; font-size: 0.85rem;",
               icon("triangle-exclamation"), " All values must be numeric."))
      ols_man_base(NULL)
      return()
    }
    if (length(xv) < 2) {
      output$ols_man_msg <- renderUI(
        tags$p(style = "color: #e31a1c; font-size: 0.85rem;",
               icon("triangle-exclamation"), " Need at least 2 data points."))
      ols_man_base(NULL)
      return()
    }
    if (length(xv) > 30) {
      output$ols_man_msg <- renderUI(
        tags$p(style = "color: #e31a1c; font-size: 0.85rem;",
               icon("triangle-exclamation"), " Maximum 30 data points."))
      ols_man_base(NULL)
      return()
    }

    ols_man_base(data.frame(x = xv, y = yv))
    ols_man_added(data.frame(x = numeric(0), y = numeric(0)))
    output$ols_man_msg <- renderUI(
      tags$p(style = "color: #238b45; font-size: 0.85rem;",
             icon("check"), sprintf(" Loaded %d data points.", length(xv))))
  })

  observeEvent(input$ols_man_click, {
    pt <- input$ols_man_click
    req(pt$x, pt$y)
    total <- nrow(ols_man_base() %||% data.frame()) + nrow(ols_man_added())
    if (total >= 30) return()
    ols_man_added(rbind(ols_man_added(), data.frame(x = pt$x, y = pt$y)))
  })

  observeEvent(input$ols_man_undo, {
    added <- ols_man_added()
    if (nrow(added) > 0) ols_man_added(added[-nrow(added), , drop = FALSE])
  })

  observeEvent(input$ols_man_clear_added, {
    ols_man_added(data.frame(x = numeric(0), y = numeric(0)))
  })

  ols_man_data <- reactive({
    base <- ols_man_base()
    req(base)
    combine_base_added(base, ols_man_added())
  })

  ols_man_fit <- reactive({
    df <- ols_man_data(); req(df)
    fit_ols_model(df, input$ols_man_model)
  })

  output$ols_man_table <- renderTable({
    base <- ols_man_base()
    req(base)
    out <- base
    out$Obs <- seq_len(nrow(out))
    out <- out[, c("Obs", "x", "y")]
    names(out) <- c("#", "X", "Y")
    out
  }, hover = TRUE, spacing = "s", digits = 3)

  output$ols_man_plot <- renderPlot(bg = "transparent", {
    df <- ols_man_data(); req(df)
    build_ols_plot(df, ols_man_fit(), input$ols_man_model,
                   input$ols_man_residuals, input$ols_man_mean_line, dark = is_dark())
  })

  output$ols_man_resid <- plotly::renderPlotly({
    fit <- ols_man_fit(); req(fit)
    build_resid_plotly(ols_man_data(), fit)
  })

  glm_result <- reactiveVal(NULL)
  
  observeEvent(input$glm_reset, {
    updateSliderInput(session, "glm_b0", value = -1)
    updateSliderInput(session, "glm_b1", value = 1.5)
    updateSliderInput(session, "glm_n", value = 200)
    updateSelectInput(session, "glm_family", selected = "binomial")
    glm_result(NULL)
  })
  
  observeEvent(input$glm_go, {
    set.seed(sample(1:10000, 1))
    n  <- input$glm_n
    b0 <- input$glm_b0
    b1 <- input$glm_b1
    x  <- runif(n, -3, 3)
    eta <- b0 + b1 * x

    fam <- input$glm_family
    if (fam == "binomial") {
      p <- plogis(eta)
      y <- rbinom(n, 1, p)
    } else if (fam == "poisson") {
      mu <- exp(eta)
      y <- rpois(n, lambda = pmin(mu, 100))
    } else {
      y <- eta + rnorm(n)
    }

    df <- data.frame(x = x, y = y)
    fit <- glm(y ~ x, data = df, family = fam)
    glm_result(list(data = df, fit = fit, family = fam))
  })
  
  output$glm_plot <- plotly::renderPlotly({
    res <- glm_result()
    req(res)

    df <- res$data
    fit <- res$fit
    fam <- res$family

    x_seq <- seq(min(df$x), max(df$x), length.out = 300)
    # Compute CIs on the link scale, then back-transform
    pred_link <- predict(fit, newdata = data.frame(x = x_seq), type = "link", se.fit = TRUE)
    lo_link <- pred_link$fit - 1.96 * pred_link$se.fit
    hi_link <- pred_link$fit + 1.96 * pred_link$se.fit
    inv_link <- family(fit)$linkinv
    pred_df <- data.frame(x = x_seq,
                          y  = inv_link(pred_link$fit),
                          lo = inv_link(lo_link),
                          hi = inv_link(hi_link))

    family_label <- c(binomial = "Logistic Regression",
                      poisson = "Poisson Regression",
                      gaussian = "Linear Regression (Gaussian)")

    # Jitter y for binomial
    y_plot <- if (fam == "binomial") df$y + runif(nrow(df), -0.03, 0.03) else df$y

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$x, y = y_plot,
        marker = list(color = "#00441b", size = 4, opacity = 0.3),
        showlegend = FALSE,
        hoverinfo = "text",
        text = paste0("x: ", round(df$x, 2), "<br>y: ", df$y)
      ) |>
      plotly::add_ribbons(
        x = pred_df$x, ymin = pred_df$lo, ymax = pred_df$hi,
        fillcolor = "rgba(35,139,69,0.12)", line = list(width = 0),
        showlegend = FALSE, hoverinfo = "none", name = "95% CI"
      ) |>
      plotly::add_lines(
        x = pred_df$x, y = pred_df$y,
        line = list(color = "#238b45", width = 2.5),
        name = "Fitted", hoverinfo = "text",
        text = paste0("x: ", round(pred_df$x, 2),
                      "<br>\u0177: ", round(pred_df$y, 3))
      ) |>
      plotly::layout(
        title = list(text = family_label[fam], font = list(size = 14)),
        xaxis = list(title = "x"),
        yaxis = list(title = "Response"),
        showlegend = FALSE,
        margin = list(t = 40)
      )
  })
  
  output$glm_summary <- renderTable({
    res <- glm_result()
    req(res)
    s <- summary(res$fit)
    coefs <- as.data.frame(s$coefficients)
    coefs$Term <- rownames(coefs)
    coefs <- coefs[, c("Term", "Estimate", "Std. Error",
                        names(coefs)[3], names(coefs)[4])]
    coefs[[4]] <- round(coefs[[4]], 3)
    coefs[[3]] <- round(coefs[[3]], 4)
    coefs[[2]] <- round(coefs[[2]], 4)
    names(coefs)[5] <- "p-value"
    coefs$`p-value` <- format.pval(coefs$`p-value`, digits = 4)
    coefs
  }, hover = TRUE, spacing = "m")
  
  output$glm_deviance <- renderUI({
    res <- glm_result()
    req(res)
    fit <- res$fit
    null_dev <- fit$null.deviance
    res_dev  <- fit$deviance
    null_df  <- fit$df.null
    res_df   <- fit$df.residual
    aic_val  <- AIC(fit)
    bic_val  <- BIC(fit)
    pseudo_r2 <- 1 - res_dev / null_dev

    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$table(class = "table table-sm mb-2",
        tags$tr(tags$td(tags$strong("Null deviance")),
                tags$td(round(null_dev, 2), " on ", null_df, " df")),
        tags$tr(tags$td(tags$strong("Residual deviance")),
                tags$td(round(res_dev, 2), " on ", res_df, " df")),
        tags$tr(tags$td(tags$strong("AIC")), tags$td(round(aic_val, 2))),
        tags$tr(tags$td(tags$strong("BIC")), tags$td(round(bic_val, 2))),
        tags$tr(tags$td(tags$strong("Pseudo R\u00b2")),
                tags$td(round(pseudo_r2, 4),
                         tags$span(class = "text-muted ms-2",
                                   "(1 \u2212 Residual/Null deviance)")))
      ),
      if (fit$family$family != "gaussian") {
        dev_test_stat <- null_dev - res_dev
        dev_test_df   <- null_df - res_df
        dev_p <- pchisq(dev_test_stat, dev_test_df, lower.tail = FALSE)
        tags$p(tags$strong("Deviance test: "),
               "\u0394D = ", round(dev_test_stat, 2),
               ", df = ", dev_test_df,
               ", p = ", format.pval(dev_p, 4))
      }
    )
  })
  
  # ---- Diagnostic plots (4 individual plotly plots) ----
  
  output$glm_diag1 <- plotly::renderPlotly({
    res <- glm_result(); req(res)
    fit <- res$fit
    fv <- fitted(fit); rd <- residuals(fit, type = "deviance")
    lo <- lowess(fv, rd)
    
    plotly::plot_ly() |>
      plotly::add_markers(x = fv, y = rd,
        marker = list(color = "#238b45", size = 4, opacity = 0.35),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Fitted: ", round(fv, 3), "<br>Resid: ", round(rd, 3))) |>
      plotly::add_lines(x = lo$x, y = lo$y,
        line = list(color = "#e31a1c", width = 1.5),
        showlegend = FALSE, hoverinfo = "none") |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = min(fv), x1 = max(fv),
                           y0 = 0, y1 = 0, xref = "x", yref = "y",
                           line = list(color = "grey50", dash = "dash", width = 1))),
        xaxis = list(title = "Fitted values"),
        yaxis = list(title = "Deviance residuals"),
        margin = list(t = 10))
  })
  
  output$glm_diag2 <- plotly::renderPlotly({
    res <- glm_result(); req(res)
    sr <- rstandard(res$fit)
    qq <- qqnorm(sr, plot.it = FALSE)
    qq_line <- {
      q <- quantile(sr, c(0.25, 0.75), na.rm = TRUE)
      qn <- qnorm(c(0.25, 0.75))
      slope <- diff(q) / diff(qn); int <- q[1] - slope * qn[1]
      list(int = int, slope = slope)
    }
    
    plotly::plot_ly() |>
      plotly::add_markers(x = qq$x, y = qq$y,
        marker = list(color = "#238b45", size = 4, opacity = 0.35),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Theoretical: ", round(qq$x, 2), "<br>Sample: ", round(qq$y, 2))) |>
      plotly::add_lines(
        x = range(qq$x), y = qq_line$int + qq_line$slope * range(qq$x),
        line = list(color = "#e31a1c", width = 1.5),
        showlegend = FALSE, hoverinfo = "none") |>
      plotly::layout(
        xaxis = list(title = "Theoretical quantiles"),
        yaxis = list(title = "Std. residuals"),
        margin = list(t = 10))
  })
  
  output$glm_diag3 <- plotly::renderPlotly({
    res <- glm_result(); req(res)
    fit <- res$fit
    fv <- fitted(fit); sr <- rstandard(fit)
    sqrt_sr <- sqrt(abs(sr))
    lo <- lowess(fv, sqrt_sr)
    
    plotly::plot_ly() |>
      plotly::add_markers(x = fv, y = sqrt_sr,
        marker = list(color = "#238b45", size = 4, opacity = 0.35),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Fitted: ", round(fv, 3), "<br>\u221a|Std.Resid|: ", round(sqrt_sr, 3))) |>
      plotly::add_lines(x = lo$x, y = lo$y,
        line = list(color = "#e31a1c", width = 1.5),
        showlegend = FALSE, hoverinfo = "none") |>
      plotly::layout(
        xaxis = list(title = "Fitted values"),
        yaxis = list(title = "\u221a|Std. residuals|"),
        margin = list(t = 10))
  })
  
  output$glm_diag4 <- plotly::renderPlotly({
    res <- glm_result(); req(res)
    cooks <- cooks.distance(res$fit)
    n <- length(cooks)
    threshold <- 4 / n
    
    plotly::plot_ly() |>
      plotly::add_trace(
        x = seq_along(cooks), y = cooks, type = "bar",
        marker = list(color = ifelse(cooks > threshold, "#e31a1c", "#238b45"),
                      line = list(width = 0)),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("Obs: ", seq_along(cooks), "<br>Cook's D: ", round(cooks, 4))) |>
      plotly::layout(
        shapes = list(list(type = "line", x0 = 0, x1 = n,
                           y0 = threshold, y1 = threshold,
                           xref = "x", yref = "y",
                           line = list(color = "#e31a1c", dash = "dash", width = 1))),
        annotations = list(list(
          x = n * 0.9, y = threshold, text = paste0("4/n = ", round(threshold, 3)),
          showarrow = FALSE, font = list(color = "#e31a1c", size = 10),
          xref = "x", yref = "y", yshift = 10)),
        xaxis = list(title = "Observation"),
        yaxis = list(title = "Cook's distance"),
        margin = list(t = 10))
  })
  

  breg_data <- reactiveVal(NULL)
  
  observeEvent(input$breg_reset, {
    updateSliderInput(session, "breg_true_b0", value = 2)
    updateSliderInput(session, "breg_true_b1", value = 1.5)
    updateSliderInput(session, "breg_sigma", value = 1.5)
    updateSliderInput(session, "breg_n", value = 30)
    updateSliderInput(session, "breg_prior_mean", value = 0)
    updateSliderInput(session, "breg_prior_sd", value = 10)
    breg_data(NULL)
  })
  
  observeEvent(input$breg_go, {
    set.seed(sample(1:10000, 1))
    n <- input$breg_n
    b0 <- input$breg_true_b0
    b1 <- input$breg_true_b1
    sig <- input$breg_sigma

    x <- runif(n, -3, 3)
    y <- b0 + b1 * x + rnorm(n, 0, sig)
    df <- data.frame(x = x, y = y)

    # Frequentist fit
    freq_fit <- lm(y ~ x, data = df)
    freq_coefs <- summary(freq_fit)$coefficients
    freq_ci <- confint(freq_fit)

    # Bayesian conjugate normal update for slope
    prior_mu <- input$breg_prior_mean
    prior_sd <- input$breg_prior_sd
    prior_var <- prior_sd^2

    b1_hat <- coef(freq_fit)["x"]
    b0_hat <- coef(freq_fit)["(Intercept)"]
    sigma_hat <- summary(freq_fit)$sigma
    lik_var <- sigma_hat^2 / sum((x - mean(x))^2)

    post_var <- 1 / (1 / prior_var + 1 / lik_var)
    post_mu  <- post_var * (prior_mu / prior_var + b1_hat / lik_var)
    post_sd  <- sqrt(post_var)

    # Intercept posterior (vague prior)
    lik_var_b0 <- sigma_hat^2 * (1/n + mean(x)^2 / sum((x - mean(x))^2))
    prior_var_b0 <- 100^2
    post_var_b0 <- 1 / (1 / prior_var_b0 + 1 / lik_var_b0)
    post_mu_b0  <- post_var_b0 * (0 / prior_var_b0 + b0_hat / lik_var_b0)
    post_sd_b0  <- sqrt(post_var_b0)

    breg_data(list(
      df = df, freq_fit = freq_fit,
      freq_coefs = freq_coefs, freq_ci = freq_ci,
      b1_hat = b1_hat, b0_hat = b0_hat, sigma_hat = sigma_hat,
      prior_mu = prior_mu, prior_sd = prior_sd,
      lik_var = lik_var,
      post_mu = post_mu, post_sd = post_sd,
      post_mu_b0 = post_mu_b0, post_sd_b0 = post_sd_b0,
      true_b0 = b0, true_b1 = b1
    ))
  })
  
  output$breg_scatter <- plotly::renderPlotly({
    res <- breg_data()
    req(res)

    df <- res$df
    x_seq <- seq(min(df$x), max(df$x), length.out = 200)

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$x, y = df$y,
        marker = list(color = "#00441b", size = 5, opacity = 0.4),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("x: ", round(df$x, 2), "<br>y: ", round(df$y, 2))
      ) |>
      plotly::add_lines(
        x = x_seq, y = res$true_b0 + res$true_b1 * x_seq,
        line = list(color = "grey40", width = 2, dash = "dash"),
        name = "True line"
      ) |>
      plotly::add_lines(
        x = x_seq, y = res$b0_hat + res$b1_hat * x_seq,
        line = list(color = "#e31a1c", width = 2),
        name = "Frequentist (OLS)"
      ) |>
      plotly::add_lines(
        x = x_seq, y = res$post_mu_b0 + res$post_mu * x_seq,
        line = list(color = "#238b45", width = 2),
        name = "Bayesian (posterior)"
      ) |>
      plotly::layout(
        xaxis = list(title = "X"), yaxis = list(title = "Y"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top", font = list(size = 11)),
        margin = list(b = 70, t = 20)
      )
  })
  
  output$breg_posterior <- plotly::renderPlotly({
    res <- breg_data()
    req(res)

    theta <- seq(min(res$prior_mu - 4 * res$prior_sd, res$post_mu - 4 * res$post_sd),
                 max(res$prior_mu + 4 * res$prior_sd, res$post_mu + 4 * res$post_sd),
                 length.out = 500)

    prior_d <- dnorm(theta, res$prior_mu, res$prior_sd)
    lik_d_raw <- dnorm(theta, res$b1_hat, sqrt(res$lik_var))
    post_d <- dnorm(theta, res$post_mu, res$post_sd)
    lik_d <- lik_d_raw * max(post_d) / max(lik_d_raw)

    # 95% credible interval shading
    ci_lo <- qnorm(0.025, res$post_mu, res$post_sd)
    ci_hi <- qnorm(0.975, res$post_mu, res$post_sd)
    shade_idx <- theta >= ci_lo & theta <= ci_hi

    p <- plotly::plot_ly() |>
      plotly::add_lines(x = theta, y = prior_d,
        line = list(color = "#999999", width = 1.5, dash = "dash"),
        name = "Prior") |>
      plotly::add_lines(x = theta, y = lik_d,
        line = list(color = "#e31a1c", width = 1.5, dash = "dot"),
        name = "Likelihood (scaled)") |>
      plotly::add_lines(x = theta, y = post_d,
        line = list(color = "#238b45", width = 2),
        name = "Posterior")

    if (any(shade_idx)) {
      p <- p |> plotly::add_trace(
        x = theta[shade_idx], y = post_d[shade_idx],
        type = "scatter", mode = "none",
        fill = "tozeroy", fillcolor = "rgba(35,139,69,0.15)",
        showlegend = FALSE, hoverinfo = "none"
      )
    }

    p |> plotly::layout(
      shapes = list(list(
        type = "line", x0 = res$true_b1, x1 = res$true_b1,
        y0 = 0, y1 = max(post_d) * 1.05,
        xref = "x", yref = "y",
        line = list(color = "grey40", width = 1.5, dash = "dash")
      )),
      annotations = list(list(
        x = res$true_b1, y = max(post_d) * 0.95,
        text = paste0("True \u03b21 = ", res$true_b1),
        showarrow = FALSE, font = list(color = "grey40", size = 10),
        xref = "x", yref = "y", xanchor = "left", xshift = 5
      )),
      xaxis = list(title = "\u03b21 (slope)"),
      yaxis = list(title = "Density"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.15, yanchor = "top", font = list(size = 11)),
      margin = list(b = 70, t = 20)
    )
  })
  
  output$breg_table <- renderUI({
    res <- breg_data()
    req(res)

    fc <- res$freq_coefs; fci <- res$freq_ci
    f_est <- fc["x", "Estimate"]; f_lo <- fci["x", 1]; f_hi <- fci["x", 2]
    b_est <- res$post_mu; b_sd <- res$post_sd
    b_lo <- qnorm(0.025, b_est, b_sd); b_hi <- qnorm(0.975, b_est, b_sd)
    f_b0 <- fc["(Intercept)", "Estimate"]; f_b0_lo <- fci["(Intercept)", 1]; f_b0_hi <- fci["(Intercept)", 2]
    b_b0 <- res$post_mu_b0; b_b0_lo <- qnorm(0.025, b_b0, res$post_sd_b0); b_b0_hi <- qnorm(0.975, b_b0, res$post_sd_b0)

    make_row <- function(param, true_val, f_e, f_l, f_h, b_e, b_l, b_h) {
      tags$tr(
        tags$td(tags$strong(param)), tags$td(true_val),
        tags$td(paste0(round(f_e, 3), "  [", round(f_l, 3), ", ", round(f_h, 3), "]")),
        tags$td(round(f_h - f_l, 3)),
        tags$td(paste0(round(b_e, 3), "  [", round(b_l, 3), ", ", round(b_h, 3), "]")),
        tags$td(round(b_h - b_l, 3))
      )
    }

    div(
      style = "padding: 10px; font-size: 0.9rem;",
      tags$table(class = "table table-sm",
        tags$thead(tags$tr(
          tags$th("Param"), tags$th("True"),
          tags$th("Frequentist [95% CI]"), tags$th("Width"),
          tags$th("Bayesian [95% CrI]"), tags$th("Width")
        )),
        tags$tbody(
          make_row("\u03b20", res$true_b0, f_b0, f_b0_lo, f_b0_hi, b_b0, b_b0_lo, b_b0_hi),
          make_row("\u03b21", res$true_b1, f_est, f_lo, f_hi, b_est, b_lo, b_hi)
        )
      ),
      tags$p(class = "text-muted mt-2",
        "Frequentist: 95% confidence interval. Bayesian: 95% credible interval."),
      tags$p(class = "text-muted",
        paste0("Prior on \u03b21: N(", res$prior_mu, ", ", round(res$prior_sd, 1),
               "\u00b2). Residual \u03c3\u0302 = ", round(res$sigma_hat, 3), "."))
    )
  })
  
  output$breg_predict <- plotly::renderPlotly({
    res <- breg_data()
    req(res)
    df <- res$df

    x_seq <- seq(min(df$x) - 0.5, max(df$x) + 0.5, length.out = 150)

    # Frequentist prediction interval
    freq_pred <- predict(res$freq_fit, newdata = data.frame(x = x_seq),
                          interval = "prediction", level = 0.95)

    # Bayesian posterior predictive
    pred_var <- res$post_sd_b0^2 + (x_seq^2) * res$post_sd^2 + res$sigma_hat^2
    bayes_mean <- res$post_mu_b0 + res$post_mu * x_seq
    bayes_lo <- bayes_mean - 1.96 * sqrt(pred_var)
    bayes_hi <- bayes_mean + 1.96 * sqrt(pred_var)

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$x, y = df$y,
        marker = list(color = "#00441b", size = 4, opacity = 0.35),
        showlegend = FALSE, hoverinfo = "text",
        text = paste0("x: ", round(df$x, 2), "<br>y: ", round(df$y, 2))
      ) |>
      plotly::add_ribbons(
        x = x_seq, ymin = freq_pred[, "lwr"], ymax = freq_pred[, "upr"],
        fillcolor = "rgba(227,26,28,0.1)", line = list(width = 0),
        name = "Freq. 95% PI"
      ) |>
      plotly::add_lines(
        x = x_seq, y = freq_pred[, "fit"],
        line = list(color = "#e31a1c", width = 1.5),
        name = "Frequentist", showlegend = FALSE
      ) |>
      plotly::add_ribbons(
        x = x_seq, ymin = bayes_lo, ymax = bayes_hi,
        fillcolor = "rgba(35,139,69,0.1)", line = list(width = 0),
        name = "Bayes 95% PI"
      ) |>
      plotly::add_lines(
        x = x_seq, y = bayes_mean,
        line = list(color = "#238b45", width = 1.5),
        name = "Bayesian", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "X"), yaxis = list(title = "Y"),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top", font = list(size = 11)),
        margin = list(b = 70, t = 20)
      )
  })
  

  mle_data <- reactiveVal(NULL)

  observeEvent(input$mle_reset, mle_data(NULL))

  observeEvent(input$mle_go, {
    set.seed(sample(1:10000, 1))
    n <- input$mle_n
    dist <- input$mle_dist

    if (dist == "Normal (estimate \u03bc)") {
      x <- rnorm(n, input$mle_true_mu, input$mle_true_sigma)
      mle_data(list(dist = "normal", x = x, sigma = input$mle_true_sigma,
                    true_par = input$mle_true_mu))
    } else if (dist == "Binomial (estimate p)") {
      x <- rbinom(n, 1, input$mle_true_p)
      mle_data(list(dist = "binomial", x = x, true_par = input$mle_true_p))
    } else {
      x <- rpois(n, input$mle_true_lambda)
      mle_data(list(dist = "poisson", x = x, true_par = input$mle_true_lambda))
    }
  })

  output$mle_loglik_plot <- renderPlotly({
    res <- mle_data()
    req(res)
    x <- res$x

    if (res$dist == "normal") {
      sigma <- res$sigma
      par_seq <- seq(mean(x) - 3 * sigma / sqrt(length(x)),
                     mean(x) + 3 * sigma / sqrt(length(x)), length.out = 500)
      ll <- sapply(par_seq, function(mu) sum(dnorm(x, mu, sigma, log = TRUE)))
      mle_val <- mean(x)
      par_name <- "\u03bc"
    } else if (res$dist == "binomial") {
      par_seq <- seq(0.01, 0.99, length.out = 500)
      ll <- sapply(par_seq, function(p) sum(dbinom(x, 1, p, log = TRUE)))
      mle_val <- mean(x)
      par_name <- "p"
    } else {
      par_seq <- seq(0.1, max(mean(x) * 2, 1), length.out = 500)
      ll <- sapply(par_seq, function(lam) sum(dpois(x, lam, log = TRUE)))
      mle_val <- mean(x)
      par_name <- "\u03bb"
    }

    hover_txt <- paste0(par_name, " = ", round(par_seq, 4),
                        "<br>LL = ", round(ll, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = par_seq, y = ll,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = mle_val, x1 = mle_val,
               y0 = min(ll), y1 = max(ll),
               line = list(color = "#e31a1c", width = 2, dash = "dash")),
          list(type = "line", x0 = res$true_par, x1 = res$true_par,
               y0 = min(ll), y1 = max(ll),
               line = list(color = "#006d2c", width = 2, dash = "dot"))
        ),
        xaxis = list(title = par_name),
        yaxis = list(title = "Log-Likelihood"),
        annotations = list(
          list(x = mle_val, y = max(ll), yanchor = "bottom",
               text = paste0("MLE = ", round(mle_val, 3)),
               showarrow = TRUE, arrowhead = 2, ay = -30,
               font = list(color = "#e31a1c", size = 13),
               bgcolor = "#e5f5f9", bordercolor = "#e31a1c"),
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Red dashed = MLE; Green dotted = true ",
                             par_name, " = ", res$true_par),
               showarrow = FALSE, font = list(size = 12))
        ),
        margin = list(t = 45)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mle_data_plot <- renderPlotly({
    res <- mle_data()
    req(res)

    if (res$dist == "normal") {
      brks <- seq(min(res$x) - 0.5, max(res$x) + 0.5, length.out = 26)
      h <- hist(res$x, breaks = brks, plot = FALSE)
      dens <- h$density

      x_norm <- seq(min(res$x), max(res$x), length.out = 200)
      y_norm <- dnorm(x_norm, mean(res$x), res$sigma)

      hover_txt <- paste0("Bin: ", round(h$mids, 2), "<br>Density: ", round(dens, 4))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = h$mids, y = dens,
          marker = list(color = "#99d8c9", line = list(color = "white", width = 0.5)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE, width = diff(brks)[1]
        ) |>
        plotly::add_trace(
          x = x_norm, y = y_norm,
          type = "scatter", mode = "lines",
          line = list(color = "#238b45", width = 2),
          hoverinfo = "skip", showlegend = FALSE
        ) |>
        plotly::layout(
          xaxis = list(title = "x"), yaxis = list(title = "Density"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = paste0("n = ", length(res$x)),
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40), bargap = 0.02
        ) |> plotly::config(displayModeBar = FALSE)
    } else {
      tbl <- table(factor(res$x, levels = min(res$x):max(res$x)))
      vals <- as.integer(names(tbl))
      counts <- as.integer(tbl)
      hover_txt <- paste0("Value: ", vals, "<br>Count: ", counts)

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = vals, y = counts,
          marker = list(color = "#99d8c9", line = list(color = "white", width = 0.5)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          xaxis = list(title = "Value"), yaxis = list(title = "Count"),
          annotations = list(
            list(x = 0.5, y = 1.06, xref = "paper", yref = "paper",
                 text = paste0("n = ", length(res$x)),
                 showarrow = FALSE, font = list(size = 13))
          ),
          margin = list(t = 40), bargap = 0.1
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$mle_result <- renderUI({
    res <- mle_data()
    req(res)
    mle_val <- mean(res$x)
    se <- if (res$dist == "normal") {
      res$sigma / sqrt(length(res$x))
    } else if (res$dist == "binomial") {
      sqrt(mle_val * (1 - mle_val) / length(res$x))
    } else {
      sqrt(mle_val / length(res$x))
    }
    ci_lo <- mle_val - 1.96 * se
    ci_hi <- mle_val + 1.96 * se
    if (res$dist == "binomial") {
      ci_lo <- max(ci_lo, 0)
      ci_hi <- min(ci_hi, 1)
    }

    div(
      style = "padding: 10px; font-size: 0.95rem;",
      tags$p(tags$strong("MLE: "), round(mle_val, 4)),
      tags$p(tags$strong("True value: "), res$true_par),
      tags$p(tags$strong("Standard Error: "), round(se, 4)),
      tags$p(tags$strong("95% Wald CI: "),
             paste0("[", round(ci_lo, 3), ", ", round(ci_hi, 3), "]")),
      tags$p(tags$strong("n = "), length(res$x))
    )
  })
  # Auto-run simulations on first load
  })
}
