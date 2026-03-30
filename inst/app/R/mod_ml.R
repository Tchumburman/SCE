# Module: ml

# UI
ml_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Machine Learning",
  icon = icon("robot"),
  navset_card_underline(
    nav_panel(
      "Decision Trees & Random Forest",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ml_rf_n"), "Sample size", min = 100, max = 1000, value = 300, step = 50),
          sliderInput(ns("ml_rf_noise"), "Noise level", min = 0.1, max = 2, value = 0.5, step = 0.1),
          sliderInput(ns("ml_rf_trees"), "Number of trees (forest)", min = 1, max = 100, value = 10, step = 1),
          actionButton(ns("ml_rf_go"), "Generate & classify", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Decision Trees & Random Forests"),
            tags$p("A decision tree classifies data by asking a series of yes/no questions
                    about the features, splitting the space into axis-aligned rectangular regions.
                    Each split is chosen to maximise the separation between classes (using criteria
                    like Gini impurity or information gain). Trees are highly interpretable but
                    prone to overfitting: a deep tree can memorise noise in the training data,
                    producing complex boundaries that do not generalise."),
            tags$p("A random forest addresses overfitting by building many trees (typically
                    hundreds), each trained on a bootstrap sample of the data and a random
                    subset of features at each split. Predictions are combined by majority vote.
                    The randomisation decorrelates the trees, reducing variance while maintaining
                    low bias. Random forests are among the most reliable \u201cout-of-the-box\u201d
                    classifiers \u2014 they perform well with minimal tuning."),
            tags$p("Compare the decision boundaries: individual trees produce jagged, axis-aligned
                    boundaries, while the forest\u2019s aggregated boundary is smoother and more
                    robust. The trade-off is interpretability: a single tree is easy to explain,
                    but a forest of 500 trees is a black box."),
            guide = tags$ol(
              tags$li("Set sample size, noise level, and number of trees for the forest."),
              tags$li("Click 'Generate & classify'."),
              tags$li("Left: random forest boundary \u2014 smoother and more flexible."),
              tags$li("Right: single decision tree boundary \u2014 notice the sharp rectangular splits."),
              tags$li("Try increasing noise to see when the tree overfits. Try 1 tree in the forest vs. 50+ to see the ensemble effect.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Random Forest Boundary"),
                 plotly::plotlyOutput(ns("ml_rf_plot"), height = "500px")),
            card(full_screen = TRUE, card_header("Single Decision Tree Boundary"),
                 plotly::plotlyOutput(ns("ml_tree_plot"), height = "500px"))
          )
        )
      )
    ),
    nav_panel(
      "KNN & SVM",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ml_knn_n"), "Sample size", min = 100, max = 500, value = 200, step = 50),
          sliderInput(ns("ml_knn_k"), "K (neighbors)", min = 1, max = 30, value = 5),
          selectInput(ns("ml_svm_kernel"), "SVM Kernel",
                      choices = c("linear", "radial", "polynomial")),
          actionButton(ns("ml_knn_go"), "Generate & classify", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("K-Nearest Neighbors & Support Vector Machines"),
            tags$p(tags$b("KNN"), " is the simplest classifier: to predict a new point,
                    find its K nearest neighbors in the training data and take a
                    majority vote. K=1 perfectly fits the training data (overfits);
                    larger K produces smoother boundaries. KNN makes no assumptions
                    about the data's shape."),
            tags$p(tags$b("SVM"), " finds the decision boundary that maximises the margin
                    (gap) between classes. Points closest to the boundary are \u201csupport
                    vectors\u201d \u2014 the boundary depends only on these points, making SVM
                    robust to outliers far from the boundary. The kernel trick (RBF, polynomial)
                    allows SVMs to learn nonlinear boundaries by implicitly mapping data to a
                    higher-dimensional space."),
            tags$p("Both algorithms have key hyperparameters. For KNN: K (number of neighbours)
                    and the distance metric. For SVM: the cost parameter C (controlling the
                    trade-off between margin width and misclassification) and the kernel
                    parameters (e.g., \u03b3 for the RBF kernel). These should be tuned via
                    cross-validation, not chosen arbitrarily."),
            guide = tags$ol(
              tags$li("Set sample size and K for KNN."),
              tags$li("Choose an SVM kernel: linear (straight boundary), radial (flexible curves), polynomial (curved boundary)."),
              tags$li("Click 'Generate & classify'."),
              tags$li("Compare the two boundaries. Try K=1 (very wiggly) vs. K=20 (very smooth)."),
              tags$li("Try 'linear' SVM on XOR data \u2014 it will fail because the data isn't linearly separable. Switch to 'radial' to see the improvement.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("KNN Decision Boundary"),
                 plotly::plotlyOutput(ns("ml_knn_plot"), height = "500px")),
            card(full_screen = TRUE, card_header("SVM Decision Boundary"),
                 plotly::plotlyOutput(ns("ml_svm_plot"), height = "500px"))
          )
        )
      )
    ),
    nav_panel(
      "Neural Network",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ml_nn_n"), "Sample size", min = 100, max = 500, value = 200, step = 50),
          sliderInput(ns("ml_nn_hidden"), "Hidden neurons", min = 1, max = 20, value = 5),
          selectInput(ns("ml_nn_data"), "Data pattern",
                      choices = c("Two spirals", "Concentric circles", "XOR", "Linear")),
          actionButton(ns("ml_nn_go"), "Generate & train", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Neural Networks"),
            tags$p("A neural network learns complex decision boundaries by composing
                    layers of simple nonlinear functions. Each hidden neuron computes a
                    weighted sum of inputs, applies an activation function, and passes
                    the result forward. With enough hidden neurons, a single-layer network
                    can approximate any decision boundary \u2014 but too many neurons risk
                    overfitting."),
            tags$p("The key hyperparameters are the number of hidden neurons and the
                    decay (weight regularisation). More neurons allow more complex boundaries
                    but increase the risk of overfitting. Regularisation penalises large weights,
                    acting like Ridge regression for the network parameters."),
            tags$p("This demo uses a single hidden layer. Real deep learning uses many
                    layers (hence \u201cdeep\u201d), enabling hierarchical feature learning where
                    early layers detect simple patterns and later layers combine them into
                    complex abstractions. Even this simple one-layer network can approximate
                    remarkably complex decision boundaries."),
            guide = tags$ol(
              tags$li("Set sample size and number of hidden neurons."),
              tags$li("Choose a data pattern: 'Two spirals' and 'Concentric circles' are hardest; 'Linear' is easiest."),
              tags$li("Click 'Generate & train'."),
              tags$li("The colored background shows the decision surface; points show true labels."),
              tags$li("Try 1-2 hidden neurons on spirals \u2014 the network can't learn the pattern. Increase to 10-20 to see it succeed."),
              tags$li("Try many neurons (20) on 'Linear' data \u2014 the boundary may look unnecessarily complex (overfitting).")
            )
          ),
          card(full_screen = TRUE, card_header("Neural Network Decision Surface"),
               plotly::plotlyOutput(ns("ml_nn_plot"), height = "550px"))
        )
      )
    ),
    nav_panel(
      "K-Means Clustering",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("ml_km_n"), "Points per cluster", min = 30, max = 200, value = 80, step = 10),
          sliderInput(ns("ml_km_k"), "True clusters", min = 2, max = 6, value = 3),
          sliderInput(ns("ml_km_kfit"), "K to fit", min = 2, max = 8, value = 3),
          sliderInput(ns("ml_km_spread"), "Cluster spread", min = 0.3, max = 3, value = 1, step = 0.1),
          actionButton(ns("ml_km_go"), "Generate & cluster", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("K-Means Clustering"),
            tags$p("K-means is an unsupervised algorithm that partitions data into K
                    clusters by minimizing within-cluster variance. The algorithm: (1)
                    randomly initialize K centroids, (2) assign each point to the nearest
                    centroid, (3) update centroids to the mean of assigned points, (4)
                    repeat until convergence."),
            tags$p("K-means converges to a local minimum, not necessarily the global optimum.
                    Different random initialisations can produce different clusterings. Running
                    the algorithm multiple times with different starts (the default in most
                    software) and selecting the best solution mitigates this issue."),
            tags$p("K-means assumes spherical, roughly equal-sized clusters. It struggles with
                    elongated, overlapping, or unequal-sized clusters. The result depends on
                    the choice of K: too few clusters merge distinct groups; too many split
                    natural clusters. The Cluster Validation tab covers methods for choosing K.
                    The \u201cX\u201d marks show the fitted centroids."),
            guide = tags$ol(
              tags$li("Set the number of true clusters, points per cluster, and cluster spread."),
              tags$li("Set 'K to fit' \u2014 try matching the true number first, then deliberately over/underfit."),
              tags$li("Click 'Generate & cluster'."),
              tags$li("Left: true cluster labels. Right: K-means assignments with centroids marked as X."),
              tags$li("Try K to fit > true clusters \u2014 watch how natural clusters get split."),
              tags$li("Try K to fit < true clusters \u2014 distinct clusters get merged.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("True Clusters"),
                 plotly::plotlyOutput(ns("ml_km_true"), height = "500px")),
            card(full_screen = TRUE, card_header("K-Means Result"),
                 plotly::plotlyOutput(ns("ml_km_fit"), height = "500px"))
          )
        )
      )
    ),
    nav_panel(
      "Algorithm Diagrams",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("ml_diag_type"), "Algorithm",
                      choices = c("Decision Tree", "Random Forest", "Neural Network",
                                  "KNN", "SVM", "K-Means Clustering")),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'Decision Tree'",
            sliderInput(ns("ml_diag_depth"), "Tree depth", min = 1, max = 6, value = 3, step = 1)
          ),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'Random Forest'",
            sliderInput(ns("ml_diag_ntrees"), "Number of trees", min = 2, max = 10, value = 3, step = 1),
            actionButton(ns("ml_diag_rf_regen"), "Regenerate", class = "btn-outline-primary w-100 mt-1")
          ),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'Neural Network'",
            sliderInput(ns("ml_diag_nn_hidden"), "Hidden neurons", min = 2, max = 16, value = 4, step = 1),
            sliderInput(ns("ml_diag_nn_inputs"), "Input features", min = 2, max = 10, value = 2, step = 1)
          ),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'KNN'",
            sliderInput(ns("ml_diag_knn_k"), "K (neighbors)", min = 1, max = 11, value = 5, step = 2),
            sliderInput(ns("ml_diag_knn_n"), "Data points", min = 20, max = 60, value = 30, step = 5)
          ),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'SVM'",
            selectInput(ns("ml_diag_svm_kernel"), "Kernel",
                        choices = c("Linear", "Radial (RBF)", "Polynomial"))
          ),
          conditionalPanel(ns = ns, 
            "input.ml_diag_type === 'K-Means Clustering'",
            sliderInput(ns("ml_diag_km_k"), "K (clusters)", min = 2, max = 6, value = 3, step = 1),
            sliderInput(ns("ml_diag_km_nper"), "Points per cluster", min = 10, max = 40, value = 20, step = 5)
          )
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Algorithm Architecture Diagrams"),
            tags$p("These diagrams show the internal structure of each algorithm:"),
            tags$p(
              tags$b("Decision Tree:"), " A flowchart of binary splits. Each internal node tests a feature;
                      leaves contain class predictions. Deeper trees capture more complexity.", tags$br(),
              tags$b("Random Forest:"), " Multiple independent trees that each vote on the final prediction.
                      Diversity comes from random subsets of data and features.", tags$br(),
              tags$b("Neural Network:"), " Layers of interconnected neurons. Inputs feed into a hidden layer
                      (with activation functions), which feeds into the output layer.", tags$br(),
              tags$b("KNN:"), " Classifies a query point by majority vote of its K nearest neighbors.
                      Closer neighbors have more influence; the boundary adapts to local structure.", tags$br(),
              tags$b("SVM:"), " Finds the hyperplane that maximizes the margin between classes.
                      Support vectors are the closest points to the boundary. Kernels enable non-linear boundaries.", tags$br(),
              tags$b("K-Means:"), " Partitions data into K clusters by iteratively assigning points to the nearest
                      centroid and updating centroids to the cluster mean."
            ),
            tags$p("Understanding algorithm architecture helps build intuition about when each
                    method is appropriate. Tree-based methods handle non-linear relationships
                    and interactions naturally without explicit specification. Neural networks
                    are highly flexible but require large datasets and careful tuning. KNN is
                    simple but suffers in high dimensions (curse of dimensionality). SVMs excel
                    with clear margins between classes but are less interpretable than trees."),
            tags$p("The diagrams also reveal the trade-off between interpretability and flexibility.
                    A single decision tree is easy to explain to stakeholders but may underfit.
                    A random forest or neural network achieves better predictive performance but
                    operates as a \u201cblack box.\u201d The choice depends on whether the primary
                    goal is prediction accuracy or insight into the data-generating process."),
            guide = tags$ol(
              tags$li("Select an algorithm to visualize."),
              tags$li("Adjust the structure parameters (depth, number of trees, hidden neurons, K, kernel, etc.)."),
              tags$li("The diagram updates automatically to show the architecture."),
              tags$li("Hover over data points for details (class, distance, cluster assignment).")
            )
          ),
          card(full_screen = TRUE, card_header("Algorithm Structure"),
               plotly::plotlyOutput(ns("ml_diagram_plot"), height = "600px"),
               uiOutput(ns("ml_diag_summary")))
        )
      )
    )
  )
)

# Server
}

ml_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  # Helper: generate 2-class data
  ml_gen_data <- function(n, noise = 0.5, pattern = "circles") {
    if (pattern == "Two spirals") {
      t <- seq(0.5, 3 * pi, length.out = n / 2)
      x1 <- c(t * cos(t), -t * cos(t)) + rnorm(n, 0, noise)
      x2 <- c(t * sin(t), -t * sin(t)) + rnorm(n, 0, noise)
      y <- factor(rep(c("A", "B"), each = n / 2))
    } else if (pattern == "Concentric circles") {
      theta <- runif(n, 0, 2 * pi)
      r <- c(runif(n / 2, 0, 1), runif(n / 2, 1.5, 2.5))
      x1 <- r * cos(theta) + rnorm(n, 0, noise * 0.3)
      x2 <- r * sin(theta) + rnorm(n, 0, noise * 0.3)
      y <- factor(rep(c("A", "B"), each = n / 2))
    } else if (pattern == "XOR") {
      x1 <- runif(n, -2, 2)
      x2 <- runif(n, -2, 2)
      y <- factor(ifelse(x1 * x2 > 0, "A", "B"))
      x1 <- x1 + rnorm(n, 0, noise * 0.3)
      x2 <- x2 + rnorm(n, 0, noise * 0.3)
    } else {
      x1 <- rnorm(n)
      x2 <- x1 * 0.5 + rnorm(n, 0, noise)
      y <- factor(ifelse(x1 + x2 > 0, "A", "B"))
    }
    data.frame(x1 = x1, x2 = x2, y = y)
  }
  
  # Decision boundary helper -- returns plotly
  ml_boundary_plotly <- function(model, data, title_text, predict_fn = NULL) {
    x1_seq <- seq(min(data$x1) - 0.5, max(data$x1) + 0.5, length.out = 75)
    x2_seq <- seq(min(data$x2) - 0.5, max(data$x2) + 0.5, length.out = 75)
    grid <- expand.grid(x1 = x1_seq, x2 = x2_seq)
    if (is.null(predict_fn)) {
      grid$pred <- predict(model, grid, type = "class")
    } else {
      grid$pred <- predict_fn(model, grid)
    }
    
    pred_num <- ifelse(grid$pred == "A", 0, 1)
    z_mat <- matrix(pred_num, nrow = length(x1_seq), ncol = length(x2_seq))
    
    data_a <- data[data$y == "A", ]
    data_b <- data[data$y == "B", ]
    
    plotly::plot_ly() |>
      plotly::add_heatmap(
        x = x1_seq, y = x2_seq, z = t(z_mat),
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
        ),
        opacity = 0.4, showscale = FALSE,
        hoverinfo = "text",
        text = t(matrix(
          paste0("Predicted: ", grid$pred),
          nrow = length(x1_seq), ncol = length(x2_seq)
        )),
        showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = data_a$x1, y = data_a$x2,
        marker = list(color = "#006d2c", size = 6, opacity = 0.7,
                      line = list(width = 0.5, color = "#FFFFFF")),
        name = "Class A",
        legendgroup = "A",
        hoverinfo = "text",
        text = paste0("True: A<br>X1: ", round(data_a$x1, 2),
                       "<br>X2: ", round(data_a$x2, 2))
      ) |>
      plotly::add_markers(
        x = data_b$x1, y = data_b$x2,
        marker = list(color = "#e31a1c", size = 6, opacity = 0.7,
                      line = list(width = 0.5, color = "#FFFFFF")),
        name = "Class B",
        legendgroup = "B",
        hoverinfo = "text",
        text = paste0("True: B<br>X1: ", round(data_b$x1, 2),
                       "<br>X2: ", round(data_b$x2, 2))
      ) |>
      # Invisible traces for region legend entries
      plotly::add_markers(
        x = c(NA), y = c(NA),
        marker = list(color = "#99d8c9", size = 12, symbol = "square", opacity = 0.5),
        name = "Region A", legendgroup = "regA",
        showlegend = TRUE, hoverinfo = "none"
      ) |>
      plotly::add_markers(
        x = c(NA), y = c(NA),
        marker = list(color = "#fdd0a2", size = 12, symbol = "square", opacity = 0.5),
        name = "Region B", legendgroup = "regB",
        showlegend = TRUE, hoverinfo = "none"
      ) |>
      plotly::layout(
        title = list(text = title_text, font = list(size = 14)),
        xaxis = list(title = "X1"),
        yaxis = list(title = "X2"),
        legend = list(
          orientation = "h", x = 0.5, xanchor = "center",
          y = -0.15, yanchor = "top",
          font = list(size = 12),
          bgcolor = "rgba(255,255,255,0.8)",
          bordercolor = "#cccccc", borderwidth = 1,
          itemsizing = "constant"
        ),
        margin = list(b = 80)
      )
  }
  
  # -- Decision Tree / Random Forest --
  ml_rf_data <- reactiveVal(NULL)
  
  observeEvent(input$ml_rf_go, {
    withProgress(message = "Training decision tree & random forest...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    dat <- ml_gen_data(input$ml_rf_n, input$ml_rf_noise, "Concentric circles")
    tree_fit <- rpart::rpart(y ~ x1 + x2, data = dat, method = "class",
                             control = rpart::rpart.control(maxdepth = 5))
    rf_fit <- tryCatch({
      randomForest::randomForest(y ~ x1 + x2, data = dat,
                                 ntree = input$ml_rf_trees)
    }, error = function(e) NULL)
    ml_rf_data(list(data = dat, tree = tree_fit, rf = rf_fit))
    })
  })
  
  output$ml_tree_plot <- plotly::renderPlotly({
    res <- ml_rf_data()
    req(res)
    ml_boundary_plotly(res$tree, res$data, "Single Decision Tree")
  })
  
  output$ml_rf_plot <- plotly::renderPlotly({
    res <- ml_rf_data()
    req(res, res$rf)
    ml_boundary_plotly(res$rf, res$data,
                       paste0("Random Forest (", input$ml_rf_trees, " trees)"))
  })
  
  # -- KNN & SVM --
  ml_knn_data <- reactiveVal(NULL)
  
  observeEvent(input$ml_knn_go, {
    withProgress(message = "Fitting KNN & SVM...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    dat <- ml_gen_data(input$ml_knn_n, 0.5, "XOR")

    knn_predict <- function(model, newdata) {
      class::knn(model$train[, 1:2], newdata[, 1:2], model$cl, k = model$k)
    }
    knn_model <- list(train = dat[, c("x1", "x2")], cl = dat$y, k = input$ml_knn_k)

    svm_fit <- tryCatch(
      e1071::svm(y ~ x1 + x2, data = dat, kernel = input$ml_svm_kernel),
      error = function(e) NULL
    )
    ml_knn_data(list(data = dat, knn = knn_model, svm = svm_fit,
                     knn_predict = knn_predict))
    })
  })
  
  output$ml_knn_plot <- plotly::renderPlotly({
    res <- ml_knn_data()
    req(res)
    ml_boundary_plotly(res$knn, res$data,
                       paste0("KNN (K = ", res$knn$k, ")"),
                       predict_fn = res$knn_predict)
  })
  
  output$ml_svm_plot <- plotly::renderPlotly({
    res <- ml_knn_data()
    req(res, res$svm)
    ml_boundary_plotly(res$svm, res$data,
                       paste0("SVM (", input$ml_svm_kernel, " kernel)"))
  })
  
  # -- Neural Network --
  ml_nn_data <- reactiveVal(NULL)
  
  observeEvent(input$ml_nn_go, {
    withProgress(message = "Training neural network...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    dat <- ml_gen_data(input$ml_nn_n, 0.5, input$ml_nn_data)
    nn_fit <- tryCatch(
      nnet::nnet(y ~ x1 + x2, data = dat, size = input$ml_nn_hidden,
                 decay = 0.01, maxit = 500, trace = FALSE),
      error = function(e) NULL
    )
    ml_nn_data(list(data = dat, nn = nn_fit))
    })
  })
  
  output$ml_nn_plot <- plotly::renderPlotly({
    res <- ml_nn_data()
    req(res, res$nn)
    ml_boundary_plotly(res$nn, res$data,
                       paste0("Neural Network (", input$ml_nn_hidden, " hidden neurons)"))
  })
  
  # -- K-Means --
  ml_km_data <- reactiveVal(NULL)
  
  observeEvent(input$ml_km_go, {
    withProgress(message = "Running k-means clustering...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$ml_km_n; k_true <- input$ml_km_k; sp <- input$ml_km_spread
    centers <- matrix(rnorm(k_true * 2, 0, 3), k_true, 2)
    dat <- do.call(rbind, lapply(seq_len(k_true), function(i) {
      data.frame(x1 = rnorm(n, centers[i, 1], sp),
                 x2 = rnorm(n, centers[i, 2], sp),
                 true_cluster = factor(i))
    }))
    km <- kmeans(dat[, 1:2], centers = input$ml_km_kfit, nstart = 10)
    dat$km_cluster <- factor(km$cluster)
    ml_km_data(list(data = dat, km = km))
    })
  })
  
  output$ml_km_true <- plotly::renderPlotly({
    res <- ml_km_data()
    req(res)
    
    cluster_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02")
    k_true <- length(unique(res$data$true_cluster))
    
    p <- plotly::plot_ly()
    for (i in seq_len(k_true)) {
      sub <- res$data[res$data$true_cluster == i, ]
      p <- p |> plotly::add_markers(
        x = sub$x1, y = sub$x2,
        marker = list(color = cluster_colors[i], size = 5, opacity = 0.6,
                      line = list(width = 0.5, color = "#FFFFFF")),
        name = paste("Cluster", i),
        hoverinfo = "text",
        text = paste0("True Cluster: ", i,
                      "<br>X1: ", round(sub$x1, 2),
                      "<br>X2: ", round(sub$x2, 2))
      )
    }
    p |> plotly::layout(
      title = list(text = paste0(k_true, " true clusters"), font = list(size = 14)),
      xaxis = list(title = "X1"), yaxis = list(title = "X2"),
      legend = list(
        orientation = "h", x = 0.5, xanchor = "center",
        y = -0.15, yanchor = "top",
        font = list(size = 12),
        bgcolor = "rgba(255,255,255,0.8)",
        bordercolor = "#cccccc", borderwidth = 1
      ),
      margin = list(b = 80)
    )
  })
  
  output$ml_km_fit <- plotly::renderPlotly({
    res <- ml_km_data()
    req(res)
    centroids <- as.data.frame(res$km$centers)
    names(centroids) <- c("x1", "x2")
    
    cluster_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e",
                        "#e6ab02", "#a6761d", "#666666")
    k_fit <- nrow(centroids)
    
    p <- plotly::plot_ly()
    for (i in seq_len(k_fit)) {
      sub <- res$data[res$data$km_cluster == i, ]
      p <- p |> plotly::add_markers(
        x = sub$x1, y = sub$x2,
        marker = list(color = cluster_colors[i], size = 5, opacity = 0.6,
                      line = list(width = 0.5, color = "#FFFFFF")),
        name = paste("Cluster", i),
        hoverinfo = "text",
        text = paste0("K-Means Cluster: ", i,
                      "<br>X1: ", round(sub$x1, 2),
                      "<br>X2: ", round(sub$x2, 2))
      )
    }
    # Add centroids
    p <- p |> plotly::add_markers(
      x = centroids$x1, y = centroids$x2,
      marker = list(color = "black", size = 14, symbol = "x-thin",
                    line = list(width = 3, color = "black")),
      name = "Centroid",
      hoverinfo = "text",
      text = paste0("Centroid<br>X1: ", round(centroids$x1, 2),
                    "<br>X2: ", round(centroids$x2, 2))
    )
    p |> plotly::layout(
      title = list(text = paste0("K = ", k_fit, " fitted"), font = list(size = 14)),
      xaxis = list(title = "X1"), yaxis = list(title = "X2"),
      legend = list(
        orientation = "h", x = 0.5, xanchor = "center",
        y = -0.15, yanchor = "top",
        font = list(size = 12),
        bgcolor = "rgba(255,255,255,0.8)",
        bordercolor = "#cccccc", borderwidth = 1
      ),
      margin = list(b = 80)
    )
  })
  
  # -- Algorithm Diagrams (plotly) --

  # Random forest seed (regenerate button)
  rf_diag_seed <- reactiveVal(3719)
  observeEvent(input$ml_diag_rf_regen, {
    rf_diag_seed(sample(1:10000, 1))
  })

  # KNN interactive query point
  knn_query <- reactiveVal(c(0.50, 0.50))

  # Reset query when switching away or changing KNN params

  observeEvent(input$ml_diag_type, { knn_query(c(0.50, 0.50)) })
  observeEvent(input$ml_diag_knn_n, { knn_query(c(0.50, 0.50)) })

  # Update query point on click (only when KNN is active)
  observeEvent(input$ml_knn_click, {
    if (identical(input$ml_diag_type, "KNN")) {
      cx <- input$ml_knn_click$x
      cy <- input$ml_knn_click$y
      if (is.numeric(cx) && is.numeric(cy) &&
          cx >= 0 && cx <= 1 && cy >= 0 && cy <= 1) {
        knn_query(c(cx, cy))
      }
    }
  })

  output$ml_diagram_plot <- plotly::renderPlotly({
    diag_type <- input$ml_diag_type

    if (diag_type == "Decision Tree") {
      ml_draw_tree_plotly(input$ml_diag_depth %||% 3)
    } else if (diag_type == "Random Forest") {
      ml_draw_forest_plotly(input$ml_diag_ntrees %||% 3, seed = rf_diag_seed())
    } else if (diag_type == "Neural Network") {
      ml_draw_nn_plotly(input$ml_diag_nn_inputs %||% 2, input$ml_diag_nn_hidden %||% 4)
    } else if (diag_type == "KNN") {
      q <- knn_query()
      ml_draw_knn_plotly(input$ml_diag_knn_k %||% 5, input$ml_diag_knn_n %||% 30,
                         qx = q[1], qy = q[2])
    } else if (diag_type == "SVM") {
      ml_draw_svm_plotly(input$ml_diag_svm_kernel %||% "Linear")
    } else if (diag_type == "K-Means Clustering") {
      ml_draw_kmeans_plotly(input$ml_diag_km_k %||% 3, input$ml_diag_km_nper %||% 20)
    }
  })
  
  # -- Dynamic summary text below diagram --
  output$ml_diag_summary <- renderUI({
    diag_type <- input$ml_diag_type
    txt <- if (diag_type == "Decision Tree") {
      d <- input$ml_diag_depth %||% 3
      n_leaves <- 2^d
      n_splits <- n_leaves - 1
      paste0("A depth-", d, " binary tree with ", n_splits,
             " split nodes and ", n_leaves, " leaf nodes. ",
             "Each split tests one feature; deeper trees can model more complex boundaries ",
             "but risk overfitting.")
    } else if (diag_type == "Random Forest") {
      nt <- input$ml_diag_ntrees %||% 3
      paste0("An ensemble of ", nt,
             " independent decision trees, each trained on a random bootstrap sample ",
             "with a random subset of features. The final prediction is the majority vote ",
             "across all trees, reducing variance compared to a single tree.")
    } else if (diag_type == "Neural Network") {
      ni <- input$ml_diag_nn_inputs %||% 2
      nh <- input$ml_diag_nn_hidden %||% 4
      params <- (ni * nh + nh) + (nh * 2 + 2)
      paste0("A feedforward network with ", ni, " input features, ",
             nh, " hidden neurons, and 2 output classes. ",
             "Total trainable parameters: ", params,
             " (", ni * nh + nh, " input\u2192hidden + ",
             nh * 2 + 2, " hidden\u2192output, including biases).")
    } else if (diag_type == "KNN") {
      k <- input$ml_diag_knn_k %||% 5
      n <- input$ml_diag_knn_n %||% 30
      q <- knn_query()
      paste0("K = ", k, " nearest neighbors among ", n, " data points. ",
             "Query at (", round(q[1], 2), ", ", round(q[2], 2), "). ",
             "KNN is a lazy learner \u2014 no model is trained; classification depends ",
             "entirely on proximity at prediction time. Click the plot to move the query.")
    } else if (diag_type == "SVM") {
      kern <- input$ml_diag_svm_kernel %||% "Linear"
      kern_desc <- if (kern == "Linear") {
        "The linear kernel finds a straight decision boundary (hyperplane) maximizing the margin between classes."
      } else if (kern == "Radial (RBF)") {
        "The RBF kernel implicitly maps points into a higher-dimensional space, enabling a curved boundary that adapts to local density."
      } else {
        "The polynomial kernel fits a curved boundary by computing dot products raised to a polynomial degree."
      }
      paste0(kern, " SVM with 20 points per class. ", kern_desc,
             " Support vectors (labeled SV) are the critical points that define the boundary.")
    } else if (diag_type == "K-Means Clustering") {
      k <- input$ml_diag_km_k %||% 3
      nper <- input$ml_diag_km_nper %||% 20
      paste0("K-means with K = ", k, " clusters and ", k * nper, " total points (",
             nper, " per cluster). ",
             "The algorithm iterates between assigning points to the nearest centroid ",
             "and updating centroids to the cluster mean until convergence.")
    } else { "" }

    if (nzchar(txt)) {
      div(style = "padding: 10px 14px 6px; color: #444; font-size: 0.88rem; line-height: 1.5;",
          tags$p(style = "margin: 0;", txt))
    }
  })

  # --- Plotly diagram helpers ---

  ml_draw_tree_plotly <- function(depth) {
    shapes <- list()
    annotations <- list()

    set.seed(4821)
    node_list <- list()

    hw <- max(0.015, 0.04 * (0.75 ^ (depth - 1)))
    hh <- max(0.012, 0.025 * (0.8 ^ (depth - 1)))
    y_step <- min(0.2, 0.85 / depth)

    collect_nodes <- function(x, y, level, max_depth, x_span) {
      if (level > max_depth) return()
      is_leaf <- (level == max_depth)
      node_col <- if (is_leaf) sample(c("#99d8c9", "#fdd0a2"), 1) else "#e0e0e0"
      label <- if (is_leaf) {
        sample(c("A", "B"), 1)
      } else {
        paste0("X", sample(1:2, 1), "<", round(runif(1, -2, 2), 1))
      }
      node_list[[length(node_list) + 1]] <<- list(
        x = x, y = y, hw = hw, hh = hh, col = node_col, label = label,
        is_leaf = is_leaf, level = level
      )
      if (!is_leaf) {
        child_offset <- x_span / 2
        child_y <- y - y_step
        node_list[[length(node_list) + 1]] <<- list(
          type = "edge", x0 = x, y0 = y - hh, x1 = x - child_offset,
          y1 = child_y + hh, branch = "Y"
        )
        node_list[[length(node_list) + 1]] <<- list(
          type = "edge", x0 = x, y0 = y - hh, x1 = x + child_offset,
          y1 = child_y + hh, branch = "N"
        )
        collect_nodes(x - child_offset, child_y, level + 1, max_depth, child_offset)
        collect_nodes(x + child_offset, child_y, level + 1, max_depth, child_offset)
      }
    }
    collect_nodes(0.5, 0.93, 1, depth, 0.25)

    # Separate nodes and edges; collect hover data for nodes
    hover_nodes <- list()
    for (item in node_list) {
      if (!is.null(item$type) && item$type == "edge") {
        edge_col <- if (item$branch == "Y") "#238b45" else "#e31a1c"
        shapes[[length(shapes) + 1]] <- list(
          type = "line", x0 = item$x0, y0 = item$y0, x1 = item$x1, y1 = item$y1,
          xref = "x", yref = "y",
          line = list(color = edge_col, width = 2)
        )
        mid_x <- (item$x0 + item$x1) / 2
        mid_y <- (item$y0 + item$y1) / 2
        off_x <- if (item$branch == "Y") -0.015 else 0.015
        annotations[[length(annotations) + 1]] <- list(
          x = mid_x + off_x, y = mid_y, text = item$branch,
          font = list(size = max(8, 11 - depth), color = edge_col),
          showarrow = FALSE, xref = "x", yref = "y"
        )
      } else if (is.null(item$type)) {
        shapes[[length(shapes) + 1]] <- list(
          type = "rect",
          x0 = item$x - item$hw, y0 = item$y - item$hh,
          x1 = item$x + item$hw, y1 = item$y + item$hh,
          xref = "x", yref = "y",
          fillcolor = item$col, opacity = 0.85,
          line = list(color = "#333333", width = 1.5)
        )
        font_size <- if (item$is_leaf) max(9, 13 - depth) else max(7, 12 - item$level)
        annotations[[length(annotations) + 1]] <- list(
          x = item$x, y = item$y, text = item$label,
          font = list(size = font_size, color = "#333333",
                      family = if (item$is_leaf) "Arial Black" else "Arial"),
          showarrow = FALSE, xref = "x", yref = "y"
        )
        hover_nodes[[length(hover_nodes) + 1]] <- item
      }
    }

    annotations[[length(annotations) + 1]] <- list(
      x = 0.75, y = 0.04, xref = "x", yref = "y", showarrow = FALSE,
      text = "\u25A0 Class A &nbsp; \u25A0 Class B &nbsp; \u25A0 Split &nbsp; | &nbsp; <i>Hover nodes</i>",
      font = list(size = 11, color = "#333333")
    )

    # Hoverable marker traces over each node
    nd <- data.frame(
      x = sapply(hover_nodes, `[[`, "x"),
      y = sapply(hover_nodes, `[[`, "y"),
      label = sapply(hover_nodes, `[[`, "label"),
      is_leaf = sapply(hover_nodes, `[[`, "is_leaf"),
      level = sapply(hover_nodes, `[[`, "level")
    )
    nd$node_type <- ifelse(nd$is_leaf, "Leaf (prediction)", "Split node")
    nd$hover <- paste0(
      "<b>", nd$label, "</b>",
      "<br>Type: ", nd$node_type,
      "<br>Depth: ", nd$level, " / ", depth
    )

    p <- plotly::plot_ly()
    # Split nodes
    splits <- nd[!nd$is_leaf, ]
    if (nrow(splits) > 0) {
      p <- p |> plotly::add_markers(
        x = splits$x, y = splits$y,
        marker = list(color = "rgba(0,0,0,0)", size = max(14, 30 - depth * 3),
                      line = list(width = 0)),
        hoverinfo = "text", text = splits$hover,
        showlegend = FALSE
      )
    }
    # Leaf nodes
    leaves <- nd[nd$is_leaf, ]
    if (nrow(leaves) > 0) {
      p <- p |> plotly::add_markers(
        x = leaves$x, y = leaves$y,
        marker = list(color = "rgba(0,0,0,0)", size = max(14, 30 - depth * 3),
                      line = list(width = 0)),
        hoverinfo = "text", text = leaves$hover,
        showlegend = FALSE
      )
    }

    p |> plotly::layout(
      title = list(text = paste0("Decision Tree (depth = ", depth, ")"),
                   font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.05, 1.05), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    )
  }
  
  ml_draw_forest_plotly <- function(n_trees, seed = 3719) {
    shapes <- list()
    annotations <- list()

    sc <- min(1, 3 / n_trees)
    root_hw <- max(0.015, 0.035 * sc)
    leaf_hw <- max(0.012, 0.025 * sc)
    leaf2_hw <- max(0.01, 0.018 * sc)
    root_hh <- 0.025; leaf_hh <- 0.022; leaf2_hh <- 0.018
    leaf_off <- max(0.02, 0.05 * sc)
    leaf2_off <- max(0.012, 0.025 * sc)

    tree_centers <- seq(0.5 / n_trees, 1 - 0.5 / n_trees, length.out = n_trees) * 0.84 + 0.08

    set.seed(seed)
    # Collect per-tree info for hover
    tree_votes <- character(n_trees)

    for (t in seq_len(n_trees)) {
      cx <- tree_centers[t]
      tree_top <- 0.82

      shapes[[length(shapes) + 1]] <- list(
        type = "rect", x0 = cx - root_hw, y0 = tree_top - root_hh,
        x1 = cx + root_hw, y1 = tree_top + root_hh,
        xref = "x", yref = "y", fillcolor = "#e0e0e0", opacity = 0.9,
        line = list(color = "#333333", width = 1.2)
      )
      annotations[[length(annotations) + 1]] <- list(
        x = cx, y = tree_top, text = paste0("<b>T", t, "</b>"),
        font = list(size = max(7, round(11 * sc)), color = "#333333"),
        showarrow = FALSE, xref = "x", yref = "y"
      )

      lx <- cx - leaf_off; rx <- cx + leaf_off
      ly <- tree_top - 0.17

      leaf_preds <- character(0)
      for (side_x in c(lx, rx)) {
        shapes[[length(shapes) + 1]] <- list(
          type = "line", x0 = cx, y0 = tree_top - root_hh,
          x1 = side_x, y1 = ly + leaf_hh,
          xref = "x", yref = "y", line = list(color = "#666666", width = 1)
        )
        leaf_col <- sample(c("#99d8c9", "#fdd0a2"), 1)
        shapes[[length(shapes) + 1]] <- list(
          type = "rect", x0 = side_x - leaf_hw, y0 = ly - leaf_hh,
          x1 = side_x + leaf_hw, y1 = ly + leaf_hh,
          xref = "x", yref = "y", fillcolor = leaf_col, opacity = 0.85,
          line = list(color = "#333333", width = 1)
        )
        for (side2 in c(side_x - leaf2_off, side_x + leaf2_off)) {
          sy <- ly - 0.14
          shapes[[length(shapes) + 1]] <- list(
            type = "line", x0 = side_x, y0 = ly - leaf_hh,
            x1 = side2, y1 = sy + leaf2_hh,
            xref = "x", yref = "y", line = list(color = "#666666", width = 0.8)
          )
          l2_col <- sample(c("#99d8c9", "#fdd0a2"), 1)
          leaf_preds <- c(leaf_preds, if (l2_col == "#99d8c9") "A" else "B")
          shapes[[length(shapes) + 1]] <- list(
            type = "rect", x0 = side2 - leaf2_hw, y0 = sy - leaf2_hh,
            x1 = side2 + leaf2_hw, y1 = sy + leaf2_hh,
            xref = "x", yref = "y", fillcolor = l2_col, opacity = 0.85,
            line = list(color = "#333333", width = 0.5)
          )
        }
      }
      tree_votes[t] <- if (sum(leaf_preds == "A") >= sum(leaf_preds == "B")) "A" else "B"

      arrow_y_start <- ly - 0.17
      shapes[[length(shapes) + 1]] <- list(
        type = "line", x0 = cx, y0 = arrow_y_start, x1 = cx, y1 = 0.22,
        xref = "x", yref = "y",
        line = list(color = "#238b45", width = 2, dash = "dot")
      )
      annotations[[length(annotations) + 1]] <- list(
        x = cx, y = 0.22, ax = cx, ay = arrow_y_start,
        xref = "x", yref = "y", axref = "x", ayref = "y",
        showarrow = TRUE, arrowhead = 3, arrowsize = 1.2,
        arrowcolor = "#238b45", arrowwidth = 2, text = ""
      )
    }

    # Majority vote box — color matches the winning class
    final_pred <- if (sum(tree_votes == "A") >= sum(tree_votes == "B")) "A" else "B"
    vote_fill   <- if (final_pred == "A") "#d1f0e4" else "#fde5c8"
    vote_border <- if (final_pred == "A") "#238b45" else "#d48a3a"
    vote_text   <- if (final_pred == "A") "#006d2c" else "#a66520"
    shapes[[length(shapes) + 1]] <- list(
      type = "rect", x0 = 0.15, y0 = 0.07, x1 = 0.85, y1 = 0.2,
      xref = "x", yref = "y", fillcolor = vote_fill, opacity = 0.9,
      line = list(color = vote_border, width = 2)
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.5, y = 0.135, text = "<b>Majority Vote \u2192 Final Prediction</b>",
      font = list(size = 13, color = vote_text),
      showarrow = FALSE, xref = "x", yref = "y"
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.5, y = 0.97, showarrow = FALSE, xref = "x", yref = "y",
      text = "<i>Each tree trained on random bootstrap sample + random features &nbsp;| &nbsp; Hover trees</i>",
      font = list(size = 11, color = "#666666")
    )
    root_hover <- paste0(
      "<b>Tree ", seq_len(n_trees), "</b>",
      "<br>Majority leaf vote: ", tree_votes,
      "<br>4 leaf nodes (depth 2)",
      "<br>Trained on bootstrap sample ", seq_len(n_trees)
    )

    p <- plotly::plot_ly() |>
      plotly::add_markers(
        x = tree_centers, y = rep(0.82, n_trees),
        marker = list(color = "rgba(0,0,0,0)", size = max(16, 28 * sc),
                      line = list(width = 0)),
        hoverinfo = "text", text = root_hover,
        showlegend = FALSE
      ) |>
      # Hoverable marker on vote box
      plotly::add_markers(
        x = 0.5, y = 0.135,
        marker = list(color = "rgba(0,0,0,0)", size = 30,
                      line = list(width = 0)),
        hoverinfo = "text",
        text = paste0("<b>Majority Vote</b>",
                      "<br>Votes: ", sum(tree_votes == "A"), " A vs ",
                      sum(tree_votes == "B"), " B",
                      "<br>Ensemble prediction: ", final_pred),
        showlegend = FALSE
      )

    p |> plotly::layout(
      title = list(text = paste0("Random Forest (", n_trees, " trees)"),
                   font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.05, 1.05), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    )
  }
  
  ml_draw_nn_plotly <- function(n_inputs, n_hidden) {
    shapes <- list()
    annotations <- list()

    layer_x <- c(0.15, 0.5, 0.85)
    layers <- c(n_inputs, n_hidden, 2)
    layer_names <- c("Input", "Hidden", "Output")
    layer_colors <- c("#a6cee3", "#b2df8a", "#fb9a99")
    node_r <- max(0.012, min(0.028, 0.4 / max(layers)))

    node_positions <- list()
    for (l in seq_along(layers)) {
      n <- layers[l]
      spacing <- min(0.1, 0.85 / (n + 1))
      total_h <- (n - 1) * spacing
      start_y <- 0.52 + total_h / 2
      ys <- seq(start_y, start_y - total_h, length.out = n)
      node_positions[[l]] <- data.frame(x = rep(layer_x[l], n), y = ys)
    }

    # Draw connections and store weights per neuron
    set.seed(7712)
    total_params <- 0
    # in_weights[[l]][[j]] = vector of weights feeding into node j of layer l
    in_weights <- list(list(), vector("list", n_hidden), vector("list", 2))
    for (l in 1:(length(layers) - 1)) {
      from <- node_positions[[l]]
      to <- node_positions[[l + 1]]
      for (i in seq_len(nrow(from))) {
        for (j in seq_len(nrow(to))) {
          w <- runif(1, 0.15, 0.6)
          total_params <- total_params + 1
          in_weights[[l + 1]][[j]] <- c(in_weights[[l + 1]][[j]], w)
          shapes[[length(shapes) + 1]] <- list(
            type = "line",
            x0 = from$x[i] + node_r, y0 = from$y[i],
            x1 = to$x[j] - node_r, y1 = to$y[j],
            xref = "x", yref = "y",
            line = list(color = sprintf("rgba(100,100,100,%.2f)", w),
                        width = w * 3)
          )
        }
      }
    }
    # Add biases
    total_params <- total_params + n_hidden + 2

    # Draw node shapes and labels (annotations)
    for (l in seq_along(layers)) {
      pos <- node_positions[[l]]
      for (i in seq_len(nrow(pos))) {
        shapes[[length(shapes) + 1]] <- list(
          type = "circle",
          x0 = pos$x[i] - node_r, y0 = pos$y[i] - node_r,
          x1 = pos$x[i] + node_r, y1 = pos$y[i] + node_r,
          xref = "x", yref = "y",
          fillcolor = layer_colors[l], opacity = 0.9,
          line = list(color = "#333333", width = 1.5)
        )
        label <- if (l == 1) paste0("X", i) else if (l == 2) paste0("H", i) else c("A", "B")[i]
        font_sz <- if (n_hidden > 10) 8 else if (n_hidden > 6) 9 else 11
        annotations[[length(annotations) + 1]] <- list(
          x = pos$x[i], y = pos$y[i], text = paste0("<b>", label, "</b>"),
          font = list(size = font_sz, color = "#333333"),
          showarrow = FALSE, xref = "x", yref = "y"
        )
      }
      annotations[[length(annotations) + 1]] <- list(
        x = layer_x[l], y = 0.05, text = paste0("<b>", layer_names[l], "</b>"),
        font = list(size = 12, color = "#333333"),
        showarrow = FALSE, xref = "x", yref = "y"
      )
    }

    annotations[[length(annotations) + 1]] <- list(
      x = 0.5, y = 0.01, showarrow = FALSE, xref = "x", yref = "y",
      text = "<i>Hidden: sigmoid/ReLU activation &nbsp;|&nbsp; Output: softmax &nbsp;|&nbsp; Hover neurons</i>",
      font = list(size = 10, color = "#666666")
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.5, y = 0.98, showarrow = FALSE, xref = "x", yref = "y",
      text = "<i>Line thickness/opacity \u221d connection weight magnitude</i>",
      font = list(size = 10, color = "#666666")
    )

    # Hoverable marker traces for each layer
    activation_labels <- c("none (raw features)", "sigmoid / ReLU", "softmax")
    n_in_connections <- list(
      rep(0L, layers[1]),
      rep(layers[1], layers[2]),
      rep(layers[2], layers[3])
    )
    n_out_connections <- list(
      rep(layers[2], layers[1]),
      rep(layers[3], layers[2]),
      rep(0L, layers[3])
    )

    p <- plotly::plot_ly()
    for (l in seq_along(layers)) {
      pos <- node_positions[[l]]
      labels <- if (l == 1) paste0("X", seq_len(nrow(pos)))
                else if (l == 2) paste0("H", seq_len(nrow(pos)))
                else c("A", "B")
      hover <- paste0(
        "<b>", labels, "</b>",
        "<br>Layer: ", layer_names[l], " (", l, "/3)",
        "<br>Incoming connections: ", n_in_connections[[l]],
        "<br>Outgoing connections: ", n_out_connections[[l]],
        "<br>Activation: ", activation_labels[l]
      )
      p <- p |> plotly::add_markers(
        x = pos$x, y = pos$y,
        marker = list(color = "rgba(0,0,0,0)",
                      size = max(14, node_r * 600),
                      line = list(width = 0)),
        hoverinfo = "text", text = hover,
        showlegend = FALSE
      )
    }

    p |> plotly::layout(
      title = list(
        text = paste0("Neural Network (", n_inputs, " inputs, ", n_hidden,
                      " hidden, 2 outputs)"),
        font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = "",
                   scaleanchor = "y", scaleratio = 1),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    )
  }

  # ---- KNN Diagram ----
  ml_draw_knn_plotly <- function(k, n_points, qx = 0.50, qy = 0.50) {
    set.seed(6138)
    n_a <- floor(n_points / 2)
    n_b <- n_points - n_a
    pts <- data.frame(
      x = c(rnorm(n_a, 0.35, 0.14), rnorm(n_b, 0.65, 0.14)),
      y = c(rnorm(n_a, 0.55, 0.14), rnorm(n_b, 0.45, 0.14)),
      cls = rep(c("A", "B"), c(n_a, n_b))
    )
    pts$x <- pmin(pmax(pts$x, 0.05), 0.95)
    pts$y <- pmin(pmax(pts$y, 0.10), 0.90)

    dists <- sqrt((pts$x - qx)^2 + (pts$y - qy)^2)
    nn_idx <- order(dists)[seq_len(min(k, nrow(pts)))]
    radius <- max(dists[nn_idx]) * 1.05
    nn_classes <- pts$cls[nn_idx]
    vote_a <- sum(nn_classes == "A")
    vote_b <- sum(nn_classes == "B")
    pred <- if (vote_a >= vote_b) "A" else "B"

    pts$is_nn <- seq_len(nrow(pts)) %in% nn_idx
    pts$dist <- round(dists, 3)
    pts$role <- ifelse(pts$is_nn, "Neighbor", "Background")

    shapes <- list()
    annotations <- list()

    # Radius circle
    shapes[[length(shapes) + 1]] <- list(
      type = "circle",
      x0 = qx - radius, y0 = qy - radius,
      x1 = qx + radius, y1 = qy + radius,
      xref = "x", yref = "y",
      line = list(color = "#238b45", width = 2, dash = "dash"),
      fillcolor = "rgba(35,139,69,0.06)"
    )

    # Lines from query to K neighbors
    for (i in nn_idx) {
      col <- if (pts$cls[i] == "A") "#006d2c" else "#e31a1c"
      shapes[[length(shapes) + 1]] <- list(
        type = "line", x0 = qx, y0 = qy,
        x1 = pts$x[i], y1 = pts$y[i],
        xref = "x", yref = "y",
        line = list(color = col, width = 1.5, dash = "dot")
      )
    }

    # Build plotly with marker traces for hover
    col_map <- c(A = "#006d2c", B = "#e31a1c")
    fill_map <- c(A = "#99d8c9", B = "#fdd0a2")

    p <- plotly::plot_ly()

    for (cls in c("A", "B")) {
      # Neighbors
      nn_sub <- pts[pts$cls == cls & pts$is_nn, ]
      if (nrow(nn_sub) > 0) {
        p <- p |> plotly::add_markers(
          x = nn_sub$x, y = nn_sub$y,
          marker = list(color = col_map[cls], size = 12, opacity = 0.95,
                        line = list(width = 2, color = "#FFFFFF")),
          name = paste0("Neighbor (", cls, ")"),
          hoverinfo = "text",
          text = paste0("Class: ", cls, "<br>Role: Neighbor",
                        "<br>Distance to query: ", nn_sub$dist,
                        "<br>Rank: ", match(which(pts$cls == cls & pts$is_nn),
                                            nn_idx)),
          showlegend = FALSE
        )
      }
      # Background points
      bg_sub <- pts[pts$cls == cls & !pts$is_nn, ]
      if (nrow(bg_sub) > 0) {
        p <- p |> plotly::add_markers(
          x = bg_sub$x, y = bg_sub$y,
          marker = list(color = fill_map[cls], size = 8, opacity = 0.6,
                        line = list(width = 1, color = col_map[cls])),
          name = paste0("Class ", cls),
          hoverinfo = "text",
          text = paste0("Class: ", cls, "<br>Role: Not a neighbor",
                        "<br>Distance to query: ", bg_sub$dist),
          showlegend = FALSE
        )
      }
    }

    # Query point
    p <- p |> plotly::add_markers(
      x = qx, y = qy,
      marker = list(color = "#ffff00", size = 16, opacity = 0.95,
                    symbol = "star", line = list(width = 2, color = "#333333")),
      name = "Query",
      hoverinfo = "text",
      text = paste0("Query point<br>Prediction: ", pred,
                    "<br>Votes: ", vote_a, " A vs ", vote_b, " B"),
      showlegend = FALSE
    )

    # Vote annotation
    pred_col <- if (pred == "A") "#006d2c" else "#e31a1c"
    annotations[[length(annotations) + 1]] <- list(
      x = 0.50, y = 0.03, showarrow = FALSE, xref = "x", yref = "y",
      text = paste0("<b>Vote: ", vote_a, " A vs ", vote_b, " B \u2192 Predict ",
                    pred, "</b>"),
      font = list(size = 13, color = pred_col)
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.50, y = 0.97, showarrow = FALSE, xref = "x", yref = "y",
      text = paste0("<i>K = ", k, " nearest neighbors \u2014 click anywhere to move query point</i>"),
      font = list(size = 10, color = "#666666")
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.82, y = 0.93, showarrow = FALSE, xref = "x", yref = "y",
      text = "\u25CF Class A &nbsp; \u25CF Class B &nbsp; \u2605 Query",
      font = list(size = 10, color = "#333333")
    )

    p |> plotly::layout(
      title = list(text = paste0("K-Nearest Neighbors (K = ", k, ")"),
                   font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = "",
                   scaleanchor = "y", scaleratio = 1),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    ) |> plotly::config(edits = list(shapePosition = FALSE)) |>
      htmlwidgets::onRender(sprintf("
        function(el) {
          el.on('plotly_click', function(data) {
            if (data.points && data.points.length > 0) {
              var pt = data.points[0];
              Shiny.setInputValue('%s', {x: pt.x, y: pt.y}, {priority: 'event'});
            }
          });
        }
      ", session$ns("ml_knn_click")))
  }

  # ---- SVM Diagram ----
  ml_draw_svm_plotly <- function(kernel) {
    set.seed(5293)
    shapes <- list()
    annotations <- list()

    n <- 20
    ax <- runif(n, 0.10, 0.42); ay <- runif(n, 0.15, 0.50)
    bx <- runif(n, 0.58, 0.90); by <- runif(n, 0.50, 0.85)
    dist_a <- dist_b <- rep(NA_real_, n)

    if (kernel == "Linear") {
      margin <- 0.10
      # Hyperplane
      shapes[[length(shapes) + 1]] <- list(
        type = "line", x0 = 0.0, y0 = 0.08, x1 = 0.92, y1 = 1.0,
        xref = "x", yref = "y",
        line = list(color = "#333333", width = 3)
      )
      # Upper margin
      shapes[[length(shapes) + 1]] <- list(
        type = "line", x0 = 0.0, y0 = 0.08 + margin, x1 = 0.92, y1 = 1.0 + margin,
        xref = "x", yref = "y",
        line = list(color = "#666666", width = 1.5, dash = "dash")
      )
      # Lower margin
      shapes[[length(shapes) + 1]] <- list(
        type = "line", x0 = 0.0, y0 = 0.08 - margin, x1 = 0.92, y1 = 1.0 - margin,
        xref = "x", yref = "y",
        line = list(color = "#666666", width = 1.5, dash = "dash")
      )

      dist_a <- (ay - ax - 0.08) / sqrt(2)
      dist_b <- (by - bx - 0.08) / sqrt(2)
      sv_a <- order(abs(dist_a))[1:2]
      sv_b <- order(abs(dist_b))[1:2]

      annotations[[length(annotations) + 1]] <- list(
        x = 0.78, y = 0.72, showarrow = FALSE, xref = "x", yref = "y",
        text = "<b>Hyperplane</b>", textangle = -45,
        font = list(size = 11, color = "#333333")
      )
      annotations[[length(annotations) + 1]] <- list(
        x = 0.25, y = 0.55, showarrow = FALSE, xref = "x", yref = "y",
        text = "Margin", textangle = -45,
        font = list(size = 10, color = "#666666")
      )
    } else {
      is_rbf <- (kernel == "Radial (RBF)")
      t_seq <- seq(0.05, 0.95, length.out = 80)
      if (is_rbf) {
        curve_y <- 0.52 + 0.18 * sin(t_seq * pi * 2.2) + (t_seq - 0.5) * 0.3
      } else {
        curve_y <- 0.25 + 1.2 * (t_seq - 0.5)^2 + 0.2
      }
      for (i in seq_len(length(t_seq) - 1)) {
        shapes[[length(shapes) + 1]] <- list(
          type = "line", x0 = t_seq[i], y0 = curve_y[i],
          x1 = t_seq[i + 1], y1 = curve_y[i + 1],
          xref = "x", yref = "y",
          line = list(color = "#333333", width = 3)
        )
      }

      ax <- runif(n, 0.10, 0.90)
      ay <- sapply(ax, function(xi) {
        ci <- approx(t_seq, curve_y, xout = xi)$y
        runif(1, max(0.08, ci - 0.35), ci - 0.06)
      })
      bx <- runif(n, 0.10, 0.90)
      by <- sapply(bx, function(xi) {
        ci <- approx(t_seq, curve_y, xout = xi)$y
        runif(1, ci + 0.06, min(0.95, ci + 0.35))
      })

      dist_a <- sapply(seq_len(n), function(i) {
        ci <- approx(t_seq, curve_y, xout = ax[i])$y
        ay[i] - ci
      })
      dist_b <- sapply(seq_len(n), function(i) {
        ci <- approx(t_seq, curve_y, xout = bx[i])$y
        by[i] - ci
      })
      sv_a <- order(abs(dist_a))[1:2]
      sv_b <- order(abs(dist_b))[1:2]

      kname <- if (is_rbf) "RBF" else "Polynomial"
      annotations[[length(annotations) + 1]] <- list(
        x = 0.50, y = 0.97, showarrow = FALSE, xref = "x", yref = "y",
        text = paste0("<i>", kname, " kernel maps data into higher-dimensional space</i>"),
        font = list(size = 10, color = "#666666")
      )
    }

    # Build traces with hover
    is_sv_a <- seq_len(n) %in% sv_a
    is_sv_b <- seq_len(n) %in% sv_b

    p <- plotly::plot_ly()

    # Class A: support vectors
    if (any(is_sv_a)) {
      p <- p |> plotly::add_markers(
        x = ax[is_sv_a], y = ay[is_sv_a],
        marker = list(color = "#006d2c", size = 14, opacity = 0.95,
                      line = list(width = 2.5, color = "#FFFFFF")),
        name = "SV (A)", hoverinfo = "text",
        text = paste0("Class: A<br>Support Vector<br>Dist to boundary: ",
                      round(abs(dist_a[is_sv_a]), 3)),
        showlegend = FALSE
      )
    }
    # Class A: regular
    if (any(!is_sv_a)) {
      p <- p |> plotly::add_markers(
        x = ax[!is_sv_a], y = ay[!is_sv_a],
        marker = list(color = "#99d8c9", size = 9, opacity = 0.7,
                      line = list(width = 1, color = "#006d2c")),
        name = "Class A", hoverinfo = "text",
        text = paste0("Class: A<br>Dist to boundary: ",
                      round(abs(dist_a[!is_sv_a]), 3)),
        showlegend = FALSE
      )
    }
    # Class B: support vectors
    if (any(is_sv_b)) {
      p <- p |> plotly::add_markers(
        x = bx[is_sv_b], y = by[is_sv_b],
        marker = list(color = "#e31a1c", size = 14, opacity = 0.95,
                      line = list(width = 2.5, color = "#FFFFFF")),
        name = "SV (B)", hoverinfo = "text",
        text = paste0("Class: B<br>Support Vector<br>Dist to boundary: ",
                      round(abs(dist_b[is_sv_b]), 3)),
        showlegend = FALSE
      )
    }
    # Class B: regular
    if (any(!is_sv_b)) {
      p <- p |> plotly::add_markers(
        x = bx[!is_sv_b], y = by[!is_sv_b],
        marker = list(color = "#fdd0a2", size = 9, opacity = 0.7,
                      line = list(width = 1, color = "#e31a1c")),
        name = "Class B", hoverinfo = "text",
        text = paste0("Class: B<br>Dist to boundary: ",
                      round(abs(dist_b[!is_sv_b]), 3)),
        showlegend = FALSE
      )
    }

    # SV labels
    for (i in sv_a) {
      annotations[[length(annotations) + 1]] <- list(
        x = ax[i], y = ay[i] + 0.035, showarrow = FALSE, xref = "x", yref = "y",
        text = "SV", font = list(size = 8, color = "#006d2c")
      )
    }
    for (i in sv_b) {
      annotations[[length(annotations) + 1]] <- list(
        x = bx[i], y = by[i] + 0.035, showarrow = FALSE, xref = "x", yref = "y",
        text = "SV", font = list(size = 8, color = "#e31a1c")
      )
    }

    annotations[[length(annotations) + 1]] <- list(
      x = 0.50, y = 0.03, showarrow = FALSE, xref = "x", yref = "y",
      text = "\u25CF Class A &nbsp; \u25CF Class B &nbsp; <b>SV</b> = Support Vector &nbsp; | &nbsp; <i>Hover for details</i>",
      font = list(size = 10, color = "#333333")
    )

    p |> plotly::layout(
      title = list(text = paste0("Support Vector Machine (", kernel, ")"),
                   font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = "",
                   scaleanchor = "y", scaleratio = 1),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    )
  }

  # ---- K-Means Clustering Diagram ----
  ml_draw_kmeans_plotly <- function(k, n_per) {
    set.seed(8472)
    shapes <- list()
    annotations <- list()

    cluster_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02")

    angles <- seq(0, 2 * pi, length.out = k + 1)[-(k + 1)]
    cx <- 0.50 + 0.22 * cos(angles)
    cy <- 0.52 + 0.22 * sin(angles)

    pts <- do.call(rbind, lapply(seq_len(k), function(i) {
      data.frame(
        x = pmin(pmax(rnorm(n_per, cx[i], 0.08), 0.05), 0.95),
        y = pmin(pmax(rnorm(n_per, cy[i], 0.08), 0.08), 0.92),
        true_cluster = i
      )
    }))

    km <- kmeans(pts[, 1:2], centers = k, nstart = 5)
    pts$assigned <- km$cluster
    centroids <- as.data.frame(km$centers)
    names(centroids) <- c("x", "y")

    # Distance from each point to its assigned centroid
    pts$dist_to_centroid <- round(sqrt(
      (pts$x - centroids$x[pts$assigned])^2 +
      (pts$y - centroids$y[pts$assigned])^2
    ), 3)

    # Assignment lines (shapes — no hover needed)
    for (i in seq_len(nrow(pts))) {
      ci <- pts$assigned[i]
      shapes[[length(shapes) + 1]] <- list(
        type = "line",
        x0 = pts$x[i], y0 = pts$y[i],
        x1 = centroids$x[ci], y1 = centroids$y[ci],
        xref = "x", yref = "y",
        line = list(color = paste0(cluster_colors[ci], "55"), width = 0.8)
      )
    }

    # Centroid X markers (shapes)
    for (ci in seq_len(k)) {
      r <- 0.018
      cx_i <- centroids$x[ci]; cy_i <- centroids$y[ci]
      shapes[[length(shapes) + 1]] <- list(
        type = "line",
        x0 = cx_i - r, y0 = cy_i - r, x1 = cx_i + r, y1 = cy_i + r,
        xref = "x", yref = "y",
        line = list(color = "#000000", width = 3.5)
      )
      shapes[[length(shapes) + 1]] <- list(
        type = "line",
        x0 = cx_i - r, y0 = cy_i + r, x1 = cx_i + r, y1 = cy_i - r,
        xref = "x", yref = "y",
        line = list(color = "#000000", width = 3.5)
      )
    }

    # Build traces with hover
    p <- plotly::plot_ly()

    for (ci in seq_len(k)) {
      sub <- pts[pts$assigned == ci, ]
      p <- p |> plotly::add_markers(
        x = sub$x, y = sub$y,
        marker = list(color = cluster_colors[ci], size = 8, opacity = 0.7,
                      line = list(width = 1, color = "#FFFFFF")),
        name = paste0("Cluster ", ci),
        hoverinfo = "text",
        text = paste0("Assigned cluster: ", ci,
                      "<br>True cluster: ", sub$true_cluster,
                      "<br>Dist to centroid: ", sub$dist_to_centroid,
                      "<br>Position: (", round(sub$x, 2), ", ",
                      round(sub$y, 2), ")"),
        showlegend = FALSE
      )
    }

    # Centroid markers (hoverable trace on top of the X shapes)
    cluster_sizes <- as.integer(km$size)
    p <- p |> plotly::add_markers(
      x = centroids$x, y = centroids$y,
      marker = list(color = "#000000", size = 14, symbol = "x",
                    line = list(width = 3, color = "#000000")),
      name = "Centroid",
      hoverinfo = "text",
      text = paste0("Centroid ", seq_len(k),
                    "<br>Position: (", round(centroids$x, 3), ", ",
                    round(centroids$y, 3), ")",
                    "<br>Cluster size: ", cluster_sizes),
      showlegend = FALSE
    )

    # Centroid labels
    for (ci in seq_len(k)) {
      annotations[[length(annotations) + 1]] <- list(
        x = centroids$x[ci], y = centroids$y[ci] + 0.04,
        showarrow = FALSE, xref = "x", yref = "y",
        text = paste0("<b>C", ci, "</b>"),
        font = list(size = 11, color = cluster_colors[ci])
      )
    }

    annotations[[length(annotations) + 1]] <- list(
      x = 0.50, y = 0.97, showarrow = FALSE, xref = "x", yref = "y",
      text = "<i>1. Initialize centroids &nbsp;\u2192&nbsp; 2. Assign points &nbsp;\u2192&nbsp; 3. Update centroids &nbsp;\u2192&nbsp; Repeat</i>",
      font = list(size = 10, color = "#666666")
    )

    legend_parts <- paste0(
      sapply(seq_len(k), function(i) paste0("\u25CF Cluster ", i)),
      collapse = " &nbsp; "
    )
    annotations[[length(annotations) + 1]] <- list(
      x = 0.50, y = 0.03, showarrow = FALSE, xref = "x", yref = "y",
      text = paste0(legend_parts, " &nbsp; \u2716 Centroid &nbsp; | &nbsp; <i>Hover for details</i>"),
      font = list(size = 10, color = "#333333")
    )

    p |> plotly::layout(
      title = list(text = paste0("K-Means Clustering (K = ", k, ")"),
                   font = list(size = 15)),
      shapes = shapes, annotations = annotations,
      xaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = "",
                   scaleanchor = "y", scaleratio = 1),
      yaxis = list(range = c(-0.02, 1.02), showgrid = FALSE, zeroline = FALSE,
                   showticklabels = FALSE, title = ""),
      showlegend = FALSE
    )
  }
  # Auto-run simulations on first load


  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Machine Learning", list(ml_rf_data, ml_knn_data, ml_nn_data, ml_km_data))
  })
}
