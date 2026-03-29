# Module: Model Evaluation (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
ml_evaluation_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Model Evaluation",
  icon = icon("chart-area"),
  navset_card_underline(
    nav_panel(
      "Bias-Variance",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      tags$strong("True function: sin(x) + noise"),
      sliderInput(ns("bv_n_train"), "Training set size", min = 15, max = 200, value = 40, step = 5),
      sliderInput(ns("bv_noise"), "Noise level (\u03c3)", min = 0.1, max = 2, value = 0.5, step = 0.1),
      sliderInput(ns("bv_degree"), "Polynomial degree", min = 1, max = 20, value = 3, step = 1),
      sliderInput(ns("bv_n_sims"), "Number of simulations", min = 10, max = 200, value = 50, step = 10),
      actionButton(ns("bv_run"), "Run simulation", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("The Bias-Variance Tradeoff"),
      tags$p("A model that is too simple (high bias) will underfit, systematically
              missing the true signal. A model that is too complex (high variance) will
              overfit, fitting noise that does not generalise. The expected prediction error
              decomposes as: Error = Bias\u00b2 + Variance + Irreducible noise."),
      tags$p("This decomposition is central to machine learning. Bias measures how far the
              average prediction (over many training sets) is from the truth. Variance
              measures how much predictions fluctuate across different training sets.
              The irreducible noise is the inherent randomness that no model can capture."),
      tags$p("The sweet spot is a model complex enough to capture the true pattern but
              simple enough to remain stable across samples. Regularisation, cross-validation,
              and ensemble methods are all strategies for managing this trade-off. In practice,
              we cannot observe bias and variance separately \u2014 we estimate their combined
              effect through test-set error or cross-validation."),
      guide = tags$ol(
        tags$li("Set a polynomial degree and run the simulation."),
        tags$li("Low degrees (1-2): the fits are consistent but miss the curve (high bias)."),
        tags$li("High degrees (15+): the fits wiggle wildly between samples (high variance)."),
        tags$li("The bottom plot shows training and test error as a function of model complexity.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Fitted Curves Across Simulations"),
           plotlyOutput(ns("bv_fits_plot"), height = "380px")),
      card(full_screen = TRUE, card_header("Training vs. Test Error by Complexity"),
           plotlyOutput(ns("bv_error_plot"), height = "380px"))
    )
  )
    ),

    nav_panel(
      "Cross-Validation",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("cv_n"), "Sample size", min = 30, max = 300, value = 100, step = 10),
      sliderInput(ns("cv_k"), "Number of folds (k)", min = 2, max = 20, value = 5, step = 1),
      sliderInput(ns("cv_repeats"), "Repeats (for repeated CV)", min = 1, max = 20, value = 1, step = 1),
      selectInput(ns("cv_method"), "CV method",
        choices = c("k-Fold" = "kfold",
                    "Leave-One-Out (LOO)" = "loo",
                    "Repeated k-Fold" = "repeated"),
        selected = "kfold"
      ),
      sliderInput(ns("cv_degree"), "Polynomial degree to fit", min = 1, max = 15, value = 3, step = 1),
      actionButton(ns("cv_run"), "Run CV", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Cross-Validation"),
      tags$p("Cross-validation estimates how well a model generalizes by
              repeatedly splitting data into training and validation sets.
              Unlike a single train/test split, CV uses all data for both
              training and evaluation."),
      tags$ul(
        tags$li(tags$strong("k-Fold"), " \u2014 split data into k equal parts; each part serves as the
                validation set once while the remaining k\u22121 parts form the training set.
                k = 5 or 10 is most common \u2014 a good balance between bias and variance
                of the error estimate."),
        tags$li(tags$strong("LOO (Leave-One-Out)"), " \u2014 k = n; each observation is validated
                against a model trained on all others. Nearly unbiased but can have high
                variance and is computationally expensive for large n."),
        tags$li(tags$strong("Repeated k-Fold"), " \u2014 repeats the k-fold procedure multiple times
                with different random splits, then averages. This reduces the variability of
                the CV estimate at the cost of more computation.")
      ),
      tags$p("Cross-validation serves two purposes: model ", tags$em("selection"), " (choosing among
              candidate models) and model ", tags$em("assessment"), " (estimating the chosen model\u2019s
              generalisation error). Using the same CV for both can produce optimistic estimates
              \u2014 nested CV (an outer loop for assessment, an inner loop for selection) addresses
              this but is computationally demanding."),
      tags$p("The choice of k involves a bias-variance trade-off. Small k (e.g., 2) uses less
              data for training, so the error estimate is biased upward (pessimistic). Large k
              (approaching LOO) reduces bias but increases variance because the training sets
              overlap substantially. In practice, k = 5 or 10 provides a good compromise and
              is the standard choice in most machine learning applications."),
      guide = tags$ol(
        tags$li("The top plot shows how folds are assigned (colored blocks)."),
        tags$li("Each fold's validation MSE is shown as a bar."),
        tags$li("Change the polynomial degree and re-run to compare CV errors across model complexities.")
      )
    ),

    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Fold Assignments"),
           plotlyOutput(ns("cv_folds_plot"), height = "250px")),
      layout_column_wrap(
        width = 1 / 2,
        card(full_screen = TRUE, card_header("Per-Fold Validation Error"),
             plotlyOutput(ns("cv_fold_errors"), height = "340px")),
        card(full_screen = TRUE, card_header("CV Error by Model Complexity"),
             plotlyOutput(ns("cv_complexity"), height = "340px"))
      )
    )
  )
    ),

    nav_panel(
      "ROC / PR Curves",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("roc_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
      sliderInput(ns("roc_d"), "Class separation (d)", min = 0, max = 3, value = 1.5, step = 0.1),
      sliderInput(ns("roc_prev"), "Prevalence (% positive)", min = 5, max = 50, value = 30, step = 5),
      sliderInput(ns("roc_threshold"), "Classification threshold", min = 0, max = 1, value = 0.5, step = 0.01),
      actionButton(ns("roc_gen"), "Generate data", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("ROC & Precision-Recall Curves"),
      tags$p("When a classifier outputs a continuous score, a threshold must be
              chosen to make binary predictions. Different thresholds trade off
              sensitivity (recall) and specificity."),
      tags$ul(
        tags$li(tags$strong("ROC curve"), " \u2014 plots True Positive Rate (sensitivity) vs. False
                Positive Rate (1 \u2212 specificity) across all thresholds. The AUC (Area Under
                the Curve) summarises overall discrimination: 0.5 = random, 1.0 = perfect.
                AUC is equivalent to the probability that a randomly chosen positive case
                scores higher than a randomly chosen negative case."),
        tags$li(tags$strong("PR curve"), " \u2014 plots Precision (positive predictive value) vs.
                Recall (sensitivity). More informative than ROC when classes are heavily
                imbalanced (e.g., rare disease detection), because it focuses on the
                positive class rather than the abundant negatives.")
      ),
      tags$p("A common pitfall: a model with high AUC may still be poor at the specific
              operating point you need. Always examine the full curve and choose a threshold
              based on the relative costs of false positives and false negatives in your
              application. In clinical screening, high sensitivity (low miss rate) is
              typically prioritised; in spam filtering, high precision (low false alarm
              rate) may be preferred."),
      tags$p("When comparing two models, a higher AUC generally indicates better overall
              discrimination, but the curves may cross, meaning one model is better at low
              thresholds and another at high thresholds. In such cases, the choice depends
              on the operating point required by the application. Statistical tests (e.g.,
              DeLong test) can assess whether AUC differences are significant."),
      guide = tags$ol(
        tags$li("Move the threshold slider to see how the confusion matrix, ROC point, and PR point change."),
        tags$li("Increase class separation (d) to improve discrimination (higher AUC)."),
        tags$li("Decrease prevalence to see how PR curves are more sensitive to class imbalance than ROC curves.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Score Distributions"), plotlyOutput(ns("roc_scores"), height = "300px")),
      card(full_screen = TRUE, card_header("Confusion Matrix"), tableOutput(ns("roc_cm"))),
      card(full_screen = TRUE, card_header("ROC Curve"), plotlyOutput(ns("roc_roc_plot"), height = "360px")),
      card(full_screen = TRUE, card_header("Precision-Recall Curve"), plotlyOutput(ns("roc_pr_plot"), height = "360px"))
    )
  )
    ),

    nav_panel(
      "Gradient Descent",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("gd_surface"), "Loss surface",
        choices = c("Quadratic (convex)" = "quadratic",
                    "Rosenbrock (narrow valley)" = "rosenbrock",
                    "Beale (multiple saddle points)" = "beale"),
        selected = "quadratic"
      ),
      sliderInput(ns("gd_lr"), "Learning rate (\u03b7)", min = 0.0001, max = 0.5, value = 0.01, step = 0.001),
      sliderInput(ns("gd_steps"), "Number of steps", min = 5, max = 500, value = 100, step = 5),
      sliderInput(ns("gd_start_x"), "Start x", min = -3, max = 3, value = 2.5, step = 0.1),
      sliderInput(ns("gd_start_y"), "Start y", min = -3, max = 3, value = 2.5, step = 0.1),
      actionButton(ns("gd_run"), "Run gradient descent", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Gradient Descent"),
      tags$p("Gradient descent is the workhorse optimization algorithm for machine learning.
              At each step it moves in the direction of steepest descent (negative gradient),
              scaled by the learning rate \u03b7."),
      tags$p("If \u03b7 is too small, convergence is slow \u2014 the algorithm takes many
              tiny steps. If \u03b7 is too large, the algorithm overshoots the minimum and
              may diverge entirely. The shape of the loss surface also matters: narrow
              valleys cause oscillation, and saddle points can trap the algorithm."),
      tags$p("Variants like ", tags$em("momentum"), " (accumulating velocity from previous gradients),
              ", tags$em("Adam"), " (adaptive per-parameter learning rates), and ", tags$em("learning
              rate schedules"), " (decreasing \u03b7 over time) address these challenges.
              Stochastic gradient descent (SGD) uses random mini-batches rather than the
              full dataset, introducing noise that can help escape local minima and
              saddle points."),
      tags$p("Understanding gradient descent is essential because it underlies the training
              of nearly all modern machine learning models \u2014 from logistic regression
              through deep neural networks. The loss surface visualisation helps build
              intuition for why hyperparameter tuning matters."),
      guide = tags$ol(
        tags$li("Start with the quadratic surface and a moderate learning rate."),
        tags$li("Watch the path converge to the minimum."),
        tags$li("Increase \u03b7 to see overshooting and possible divergence."),
        tags$li("Try the Rosenbrock surface to see how narrow valleys slow convergence.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("Contour Plot with Descent Path"),
           plotlyOutput(ns("gd_contour"), height = "420px")),
      card(full_screen = TRUE, card_header("Loss over Steps"),
           plotlyOutput(ns("gd_loss_curve"), height = "420px"))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

ml_evaluation_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  sim_results <- reactiveVal(NULL)

  observeEvent(input$bv_run, {
    set.seed(sample.int(10000, 1))
    n     <- input$bv_n_train
    sig   <- input$bv_noise
    n_sim <- input$bv_n_sims
    max_d <- 20

    true_fn <- function(x) sin(2 * x)

    x_test <- seq(-3, 3, length.out = 200)
    y_test_true <- true_fn(x_test)

    chosen_d <- input$bv_degree
    fitted_curves <- matrix(NA, nrow = length(x_test), ncol = n_sim)

    train_mse <- matrix(NA, nrow = n_sim, ncol = max_d)
    test_mse  <- matrix(NA, nrow = n_sim, ncol = max_d)

    for (s in seq_len(n_sim)) {
      x_tr <- runif(n, -3, 3)
      y_tr <- true_fn(x_tr) + rnorm(n, 0, sig)
      y_te <- y_test_true + rnorm(length(x_test), 0, sig)

      for (d in seq_len(max_d)) {
        m <- lm(y_tr ~ poly(x_tr, degree = d, raw = TRUE))
        pred_tr <- predict(m)
        pred_te <- predict(m, newdata = data.frame(x_tr = x_test))
        train_mse[s, d] <- mean((y_tr - pred_tr)^2)
        test_mse[s, d]  <- mean((y_te - pred_te)^2)

        if (d == chosen_d) fitted_curves[, s] <- pred_te
      }
    }

    sim_results(list(
      x_test = x_test, y_test_true = y_test_true,
      fitted_curves = fitted_curves,
      train_mse = colMeans(train_mse),
      test_mse  = colMeans(test_mse),
      chosen_d = chosen_d, max_d = max_d
    ))
  })

  output$bv_fits_plot <- renderPlotly({
    req(sim_results())
    sr <- sim_results()
    n_sim <- ncol(sr$fitted_curves)
    mean_fit <- rowMeans(sr$fitted_curves, na.rm = TRUE)

    p <- plotly::plot_ly()

    # Individual simulation fits (capped at 50)
    for (s in seq_len(min(n_sim, 50))) {
      p <- p |>
        plotly::add_trace(
          x = sr$x_test, y = sr$fitted_curves[, s],
          type = "scatter", mode = "lines",
          line = list(color = "rgba(35,139,69,0.12)", width = 1),
          hoverinfo = "none", showlegend = FALSE
        )
    }

    # True function
    hover_true <- paste0("x = ", round(sr$x_test, 2),
                         "<br>True f(x) = ", round(sr$y_test_true, 3))
    hover_mean <- paste0("x = ", round(sr$x_test, 2),
                         "<br>Mean fit = ", round(mean_fit, 3),
                         "<br>Bias = ", round(mean_fit - sr$y_test_true, 3))

    p |>
      plotly::add_trace(
        x = sr$x_test, y = sr$y_test_true,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2.5, dash = "dash"),
        hoverinfo = "text", text = hover_true,
        name = "True function", showlegend = TRUE
      ) |>
      plotly::add_trace(
        x = sr$x_test, y = mean_fit,
        type = "scatter", mode = "lines",
        line = list(color = "#00441b", width = 2.5),
        hoverinfo = "text", text = hover_mean,
        name = "Mean fit", showlegend = TRUE
      ) |>
      plotly::layout(
        xaxis = list(title = "x"),
        yaxis = list(title = "y", range = c(-3, 3)),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Degree ", sr$chosen_d, " polynomial  (",
                             min(n_sim, 50), " fits shown)"),
               showarrow = FALSE, font = list(size = 13))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$bv_error_plot <- renderPlotly({
    req(sim_results())
    sr <- sim_results()

    degrees <- seq_len(sr$max_d)
    opt_deg <- which.min(sr$test_mse)

    hover_train <- paste0("Degree = ", degrees,
                          "<br>Train MSE = ", round(sr$train_mse, 4))
    hover_test  <- paste0("Degree = ", degrees,
                          "<br>Test MSE = ", round(sr$test_mse, 4),
                          if_else(degrees == opt_deg, "<br>\u2b50 Optimal", ""))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = degrees, y = sr$train_mse,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 6),
        hoverinfo = "text", text = hover_train,
        name = "Training", showlegend = TRUE
      ) |>
      plotly::add_trace(
        x = degrees, y = sr$test_mse,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#e31a1c", width = 2),
        marker = list(color = "#e31a1c", size = 6),
        hoverinfo = "text", text = hover_test,
        name = "Test", showlegend = TRUE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = sr$chosen_d, x1 = sr$chosen_d,
               y0 = 0, y1 = max(sr$test_mse) * 1.05,
               line = list(color = "grey40", width = 1.5, dash = "dash"))
        ),
        xaxis = list(title = "Model Complexity (Polynomial Degree)"),
        yaxis = list(title = "Mean Squared Error",
                     range = c(0, max(sr$test_mse) * 1.1)),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = "Training error always decreases; test error has a U-shape",
               showarrow = FALSE, font = list(size = 12))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })


  cv_data <- reactiveVal(NULL)

  observeEvent(input$cv_run, {
    set.seed(sample.int(10000, 1))
    n <- input$cv_n

    x <- sort(runif(n, -3, 3))
    y <- sin(2 * x) + rnorm(n, 0, 0.5)
    df <- data.frame(x = x, y = y, idx = seq_len(n))

    method <- input$cv_method
    k <- if (method == "loo") n else input$cv_k
    reps <- if (method == "repeated") input$cv_repeats else 1
    degree <- input$cv_degree

    all_fold_mse <- c()
    fold_ids <- sample(rep(seq_len(k), length.out = n))

    for (r in seq_len(reps)) {
      if (r > 1) fold_ids <- sample(rep(seq_len(k), length.out = n))
      fold_mse <- numeric(k)
      for (f in seq_len(k)) {
        val_idx <- which(fold_ids == f)
        train <- df[-val_idx, ]
        val   <- df[val_idx, ]
        m <- lm(y ~ poly(x, degree, raw = TRUE), data = train)
        pred <- predict(m, newdata = val)
        fold_mse[f] <- mean((val$y - pred)^2)
      }
      all_fold_mse <- c(all_fold_mse, fold_mse)
    }

    cv_by_degree <- sapply(1:15, function(d) {
      fold_ids_d <- sample(rep(seq_len(min(k, 10)), length.out = n))
      mse_d <- sapply(seq_len(min(k, 10)), function(f) {
        val_idx <- which(fold_ids_d == f)
        train <- df[-val_idx, ]
        val   <- df[val_idx, ]
        m <- lm(y ~ poly(x, d, raw = TRUE), data = train)
        pred <- predict(m, newdata = val)
        mean((val$y - pred)^2)
      })
      mean(mse_d)
    })

    cv_data(list(
      df = df, fold_ids = fold_ids, k = k,
      all_fold_mse = all_fold_mse, reps = reps,
      cv_by_degree = cv_by_degree, degree = degree,
      method = method
    ))
  })

  output$cv_folds_plot <- renderPlotly({
    req(cv_data())
    cd <- cv_data()

    if (cd$k > 30) {
      fold_col <- cd$fold_ids %% 10
      hover_txt <- paste0("Obs ", cd$df$idx, "<br>Fold ", cd$fold_ids)
      palette <- RColorBrewer::brewer.pal(10, "Set3")

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = cd$df$idx, y = rep(1, nrow(cd$df)),
          marker = list(color = palette[fold_col + 1],
                        line = list(width = 0)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          xaxis = list(title = "Observation Index"),
          yaxis = list(title = "", showticklabels = FALSE, showgrid = FALSE),
          annotations = list(
            list(x = 0.5, y = 1.15, xref = "paper", yref = "paper",
                 text = paste0("LOO: each of ", cd$k, " observations is its own fold"),
                 showarrow = FALSE, font = list(size = 13))
          ),
          bargap = 0, margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    } else {
      k_eff <- cd$k
      palette <- if (k_eff <= 12) {
        RColorBrewer::brewer.pal(max(3, k_eff), "Set3")[seq_len(k_eff)]
      } else {
        grDevices::hcl.colors(k_eff, "Set3")
      }

      hover_txt <- paste0("Obs ", cd$df$idx,
                          "<br>Fold ", cd$fold_ids,
                          "<br>x = ", round(cd$df$x, 3),
                          "<br>y = ", round(cd$df$y, 3))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = cd$df$idx, y = rep(1, nrow(cd$df)),
          marker = list(color = palette[cd$fold_ids],
                        line = list(width = 0)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          xaxis = list(title = "Observation Index"),
          yaxis = list(title = "", showticklabels = FALSE, showgrid = FALSE),
          annotations = list(
            list(x = 0.5, y = 1.15, xref = "paper", yref = "paper",
                 text = paste0(cd$k, "-fold cross-validation"),
                 showarrow = FALSE, font = list(size = 13))
          ),
          bargap = 0, margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$cv_fold_errors <- renderPlotly({
    req(cv_data())
    cd <- cv_data()
    mean_mse <- mean(cd$all_fold_mse)

    if (cd$k > 30) {
      brks <- seq(min(cd$all_fold_mse), max(cd$all_fold_mse), length.out = 31)
      h <- hist(cd$all_fold_mse, breaks = brks, plot = FALSE)

      hover_txt <- paste0("SE: [", round(h$breaks[-length(h$breaks)], 3), ", ",
                          round(h$breaks[-1], 3), ")",
                          "<br>Count: ", h$counts)

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = h$mids, y = h$counts, width = diff(h$breaks)[1],
          marker = list(color = "rgba(35,139,69,0.7)",
                        line = list(color = "white", width = 1)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = mean_mse, x1 = mean_mse,
                 y0 = 0, y1 = max(h$counts) * 1.05,
                 line = list(color = "#e31a1c", width = 2, dash = "dash"))
          ),
          xaxis = list(title = "Squared Error"),
          yaxis = list(title = "Count"),
          annotations = list(
            list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
                 text = paste0("LOO CV Error = ", round(mean_mse, 4)),
                 showarrow = FALSE, font = list(size = 13))
          ),
          bargap = 0.05, margin = list(t = 40)
        ) |> plotly::config(displayModeBar = FALSE)
    } else {
      fold_nums <- seq_along(cd$all_fold_mse)
      hover_txt <- paste0("Fold ", fold_nums,
                          "<br>MSE = ", round(cd$all_fold_mse, 4),
                          "<br>Mean = ", round(mean_mse, 4))

      plotly::plot_ly() |>
        plotly::add_bars(textposition = "none",
          x = fold_nums, y = cd$all_fold_mse,
          marker = list(color = "rgba(35,139,69,0.7)",
                        line = list(color = "white", width = 1)),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::layout(
          shapes = list(
            list(type = "line", x0 = 0.5, x1 = max(fold_nums) + 0.5,
                 y0 = mean_mse, y1 = mean_mse,
                 line = list(color = "#e31a1c", width = 2, dash = "dash"))
          ),
          xaxis = list(title = if (cd$reps > 1) "Fold (across repeats)" else "Fold"),
          yaxis = list(title = "Validation MSE"),
          annotations = list(
            list(x = max(fold_nums) * 0.8, y = mean_mse,
                 text = paste0("Mean = ", round(mean_mse, 4)),
                 showarrow = TRUE, arrowhead = 2, ax = 30, ay = -25,
                 font = list(color = "#e31a1c", size = 12))
          ),
          margin = list(t = 30)
        ) |> plotly::config(displayModeBar = FALSE)
    }
  })

  output$cv_complexity <- renderPlotly({
    req(cv_data())
    cd <- cv_data()
    degrees <- 1:15
    opt_deg <- which.min(cd$cv_by_degree)

    hover_txt <- paste0("Degree = ", degrees,
                        "<br>CV MSE = ", round(cd$cv_by_degree, 4),
                        ifelse(degrees == opt_deg, "<br>\u2b50 Optimal", ""))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = degrees, y = cd$cv_by_degree,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 6),
        hoverinfo = "text", text = hover_txt,
        name = "CV MSE", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cd$degree, y = cd$cv_by_degree[cd$degree],
        marker = list(color = "#e31a1c", size = 10,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Current: degree ", cd$degree,
                      "<br>CV MSE = ", round(cd$cv_by_degree[cd$degree], 4)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Polynomial Degree"),
        yaxis = list(title = "CV Mean Squared Error"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Red dot = current degree (", cd$degree, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })


  dat <- reactiveVal(NULL)

  observeEvent(input$roc_gen, {
    set.seed(sample.int(10000, 1))
    n    <- input$roc_n
    prev <- input$roc_prev / 100
    d    <- input$roc_d

    n_pos <- round(n * prev)
    n_neg <- n - n_pos

    score_neg <- rnorm(n_neg, 0, 1)
    score_pos <- rnorm(n_pos, d, 1)

    all_scores <- c(score_neg, score_pos)
    prob_scores <- pnorm(all_scores, mean = d / 2, sd = 1)

    df <- data.frame(
      truth = factor(c(rep("Negative", n_neg), rep("Positive", n_pos)),
                     levels = c("Negative", "Positive")),
      score = prob_scores
    )

    thresholds <- sort(unique(c(seq(0, 1, by = 0.005), df$score)))
    roc_pts <- t(sapply(thresholds, function(thr) {
      pred <- ifelse(df$score >= thr, "Positive", "Negative")
      tp <- sum(pred == "Positive" & df$truth == "Positive")
      fp <- sum(pred == "Positive" & df$truth == "Negative")
      fn <- sum(pred == "Negative" & df$truth == "Positive")
      tn <- sum(pred == "Negative" & df$truth == "Negative")
      tpr <- tp / max(tp + fn, 1)
      fpr <- fp / max(fp + tn, 1)
      prec <- tp / max(tp + fp, 1)
      c(thr = thr, fpr = fpr, tpr = tpr, prec = prec, recall = tpr)
    }))
    roc_df <- as.data.frame(roc_pts)

    ord <- order(roc_df$fpr, roc_df$tpr)
    roc_sorted <- roc_df[ord, ]
    auc <- sum(diff(roc_sorted$fpr) * (roc_sorted$tpr[-1] + roc_sorted$tpr[-nrow(roc_sorted)]) / 2)

    dat(list(df = df, roc_df = roc_df, auc = abs(auc)))
  })

  output$roc_scores <- renderPlotly({
    req(dat())
    df <- dat()$df
    thr <- input$roc_threshold

    neg_scores <- df$score[df$truth == "Negative"]
    pos_scores <- df$score[df$truth == "Positive"]

    plotly::plot_ly() |>
      plotly::add_histogram(
        x = neg_scores, name = "Negative",
        marker = list(color = "rgba(49,130,189,0.6)",
                      line = list(color = "white", width = 0.5)),
        nbinsx = 40,
        hovertemplate = "Score: %{x:.3f}<br>Count: %{y}<extra>Negative</extra>"
      ) |>
      plotly::add_histogram(
        x = pos_scores, name = "Positive",
        marker = list(color = "rgba(227,26,28,0.6)",
                      line = list(color = "white", width = 0.5)),
        nbinsx = 40,
        hovertemplate = "Score: %{x:.3f}<br>Count: %{y}<extra>Positive</extra>"
      ) |>
      plotly::layout(
        barmode = "overlay",
        shapes = list(
          list(type = "line", x0 = thr, x1 = thr,
               y0 = 0, y1 = 1, yref = "paper",
               line = list(color = "#00441b", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Predicted Score"),
        yaxis = list(title = "Count"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Threshold = ", thr),
               showarrow = FALSE, font = list(size = 13))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.18, yanchor = "top"),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$roc_cm <- renderTable({
    req(dat())
    df <- dat()$df
    thr <- input$roc_threshold
    pred <- factor(ifelse(df$score >= thr, "Predicted +", "Predicted \u2212"),
                   levels = c("Predicted +", "Predicted \u2212"))
    truth_lbl <- ifelse(df$truth == "Positive", "Actual +", "Actual \u2212")
    cm <- table(pred, truth_lbl)
    as.data.frame.matrix(cm)
  }, rownames = TRUE, striped = TRUE, bordered = TRUE)

  output$roc_roc_plot <- renderPlotly({
    req(dat())
    roc_df <- dat()$roc_df
    thr <- input$roc_threshold
    idx <- which.min(abs(roc_df$thr - thr))
    cur <- roc_df[idx, ]

    hover_txt <- paste0("Threshold = ", round(roc_df$thr, 3),
                        "<br>FPR = ", round(roc_df$fpr, 3),
                        "<br>TPR = ", round(roc_df$tpr, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = roc_df$fpr, y = roc_df$tpr,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        name = "ROC", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cur$fpr, y = cur$tpr,
        marker = list(color = "#e31a1c", size = 12,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Current threshold = ", round(thr, 3),
                      "<br>FPR = ", round(cur$fpr, 3),
                      "<br>TPR = ", round(cur$tpr, 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, y0 = 0, y1 = 1,
               line = list(color = "grey60", width = 1, dash = "dot"))
        ),
        annotations = list(
          list(x = 0.6, y = 0.2,
               text = paste0("AUC = ", round(dat()$auc, 3)),
               showarrow = FALSE,
               font = list(size = 14, color = "#00441b"),
               bgcolor = "#e8f5e9", bordercolor = "#00441b")
        ),
        xaxis = list(title = "False Positive Rate", range = c(0, 1)),
        yaxis = list(title = "True Positive Rate", range = c(0, 1),
                     scaleanchor = "x", scaleratio = 1),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$roc_pr_plot <- renderPlotly({
    req(dat())
    roc_df <- dat()$roc_df
    thr <- input$roc_threshold
    idx <- which.min(abs(roc_df$thr - thr))
    cur <- roc_df[idx, ]
    prev <- mean(dat()$df$truth == "Positive")

    hover_txt <- paste0("Threshold = ", round(roc_df$thr, 3),
                        "<br>Recall = ", round(roc_df$recall, 3),
                        "<br>Precision = ", round(roc_df$prec, 3))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = roc_df$recall, y = roc_df$prec,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        name = "PR", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cur$recall, y = cur$prec,
        marker = list(color = "#e31a1c", size = 12,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Current threshold = ", round(thr, 3),
                      "<br>Recall = ", round(cur$recall, 3),
                      "<br>Precision = ", round(cur$prec, 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0, x1 = 1, y0 = prev, y1 = prev,
               line = list(color = "grey60", width = 1, dash = "dot"))
        ),
        annotations = list(
          list(x = 0.1, y = prev + 0.04,
               text = paste0("Baseline (prev = ", round(prev, 2), ")"),
               showarrow = FALSE, font = list(size = 11, color = "grey50"))
        ),
        xaxis = list(title = "Recall (Sensitivity)", range = c(0, 1)),
        yaxis = list(title = "Precision", range = c(0, 1)),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })


  gd_result <- reactiveVal(NULL)

  observeEvent(input$gd_run, {
    surface <- input$gd_surface
    lr    <- input$gd_lr
    steps <- input$gd_steps
    px    <- input$gd_start_x
    py    <- input$gd_start_y

    if (surface == "quadratic") {
      loss_fn <- function(x, y) x^2 + 3 * y^2
      grad_fn <- function(x, y) c(2 * x, 6 * y)
      xrng <- c(-4, 4); yrng <- c(-4, 4)
    } else if (surface == "rosenbrock") {
      loss_fn <- function(x, y) (1 - x)^2 + 100 * (y - x^2)^2
      grad_fn <- function(x, y) c(-2 * (1 - x) - 400 * x * (y - x^2),
                                   200 * (y - x^2))
      xrng <- c(-3, 3); yrng <- c(-3, 3)
    } else {
      loss_fn <- function(x, y) (1.5 - x + x * y)^2 + (2.25 - x + x * y^2)^2 + (2.625 - x + x * y^3)^2
      grad_fn <- function(x, y) {
        dx <- 2 * (1.5 - x + x * y) * (-1 + y) +
              2 * (2.25 - x + x * y^2) * (-1 + y^2) +
              2 * (2.625 - x + x * y^3) * (-1 + y^3)
        dy <- 2 * (1.5 - x + x * y) * x +
              2 * (2.25 - x + x * y^2) * 2 * x * y +
              2 * (2.625 - x + x * y^3) * 3 * x * y^2
        c(dx, dy)
      }
      xrng <- c(-4, 4); yrng <- c(-4, 4)
    }

    path <- matrix(NA, steps + 1, 2)
    path[1, ] <- c(px, py)
    losses <- numeric(steps + 1)
    losses[1] <- loss_fn(px, py)

    for (i in seq_len(steps)) {
      g <- grad_fn(path[i, 1], path[i, 2])
      g_norm <- sqrt(sum(g^2))
      if (g_norm > 100) g <- g * 100 / g_norm
      path[i + 1, ] <- path[i, ] - lr * g
      path[i + 1, 1] <- max(min(path[i + 1, 1], xrng[2] * 2), xrng[1] * 2)
      path[i + 1, 2] <- max(min(path[i + 1, 2], yrng[2] * 2), yrng[1] * 2)
      losses[i + 1] <- loss_fn(path[i + 1, 1], path[i + 1, 2])
    }

    xg <- seq(xrng[1], xrng[2], length.out = 100)
    yg <- seq(yrng[1], yrng[2], length.out = 100)
    zmat <- outer(xg, yg, Vectorize(loss_fn))

    gd_result(list(path = path, losses = losses, xg = xg, yg = yg, zmat = zmat,
                   xrng = xrng, yrng = yrng, surface = surface))
  })

  output$gd_contour <- renderPlotly({
    req(gd_result())
    r <- gd_result()
    path_x <- r$path[, 1]
    path_y <- r$path[, 2]
    n_pts <- length(path_x)

    # Cap z for contour display
    z_cap <- quantile(as.vector(r$zmat), 0.95)
    zmat_vis <- pmin(r$zmat, z_cap)

    hover_path <- paste0("Step ", 0:(n_pts - 1),
                         "<br>\u03b8\u2081 = ", round(path_x, 4),
                         "<br>\u03b8\u2082 = ", round(path_y, 4),
                         "<br>Loss = ", round(r$losses, 4))

    plotly::plot_ly() |>
      plotly::add_contour(
        x = r$xg, y = r$yg, z = t(zmat_vis),
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
        ), showscale = FALSE,
        contours = list(showlabels = FALSE),
        hoverinfo = "none", opacity = 0.6
      ) |>
      plotly::add_trace(
        x = path_x, y = path_y,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#e31a1c", width = 2),
        marker = list(color = "#e31a1c", size = 3),
        hoverinfo = "text", text = hover_path,
        name = "GD path", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = path_x[1], y = path_y[1],
        marker = list(color = "#e31a1c", size = 12, symbol = "triangle-up",
                      line = list(width = 1, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Start<br>\u03b8\u2081 = ", round(path_x[1], 3),
                      "<br>\u03b8\u2082 = ", round(path_y[1], 3)),
        showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = path_x[n_pts], y = path_y[n_pts],
        marker = list(color = "#00441b", size = 12, symbol = "circle",
                      line = list(width = 1, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("End (step ", n_pts - 1, ")",
                      "<br>\u03b8\u2081 = ", round(path_x[n_pts], 4),
                      "<br>\u03b8\u2082 = ", round(path_y[n_pts], 4),
                      "<br>Loss = ", round(r$losses[n_pts], 4)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "\u03b8\u2081", range = r$xrng),
        yaxis = list(title = "\u03b8\u2082", range = r$yrng,
                     scaleanchor = "x", scaleratio = 1),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0(r$surface, " \u2014 \u03b7 = ", input$gd_lr),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$gd_loss_curve <- renderPlotly({
    req(gd_result())
    r <- gd_result()
    steps <- seq_along(r$losses) - 1

    hover_txt <- paste0("Step ", steps,
                        "<br>Loss = ", round(r$losses, 4),
                        "<br>\u03b8\u2081 = ", round(r$path[, 1], 4),
                        "<br>\u03b8\u2082 = ", round(r$path[, 2], 4))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = steps, y = r$losses,
        type = "scatter", mode = "lines",
        line = list(color = "#238b45", width = 2.5),
        hoverinfo = "text", text = hover_txt,
        name = "Loss", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = 0, y = r$losses[1],
        marker = list(color = "#e31a1c", size = 8),
        hoverinfo = "text",
        text = paste0("Start: Loss = ", round(r$losses[1], 4)),
        showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = max(steps), y = r$losses[length(r$losses)],
        marker = list(color = "#00441b", size = 8),
        hoverinfo = "text",
        text = paste0("Final: Loss = ", round(r$losses[length(r$losses)], 4)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Step"),
        yaxis = list(title = "Loss", type = "log"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Final loss = ", round(r$losses[length(r$losses)], 4)),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Model Evaluation", list(sim_results, cv_data, dat, gd_result))
  })
}
