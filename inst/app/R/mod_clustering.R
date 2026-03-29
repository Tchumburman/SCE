# Module: Clustering & Classification (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
clustering_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Clustering & Classification",
  icon = icon("circle-nodes"),
  navset_card_underline(
    nav_panel(
      "Cluster Validation",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("clv_true_k"), "True number of clusters", min = 2, max = 8, value = 3, step = 1),
      sliderInput(ns("clv_n"), "Points per cluster", min = 20, max = 200, value = 60, step = 10),
      sliderInput(ns("clv_spread"), "Cluster spread (\u03c3)", min = 0.3, max = 2, value = 0.7, step = 0.1),
      sliderInput(ns("clv_max_k"), "Max k to evaluate", min = 3, max = 15, value = 10, step = 1),
      actionButton(ns("clv_run"), "Generate & evaluate", icon = icon("dice"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("How Many Clusters?"),
      tags$p("Choosing k for k-means is one of the most common unsupervised learning
              decisions, and there is no single definitive answer. These validation
              methods provide complementary perspectives:"),
      tags$ul(
        tags$li(tags$strong("Elbow method"), " \u2014 plots within-cluster sum of squares (WSS) vs. k. The
                \u201celbow\u201d is where adding another cluster no longer substantially reduces WSS.
                In practice, the elbow can be ambiguous, especially with overlapping clusters."),
        tags$li(tags$strong("Silhouette"), " \u2014 for each point, compares its average distance to
                points in the same cluster versus the nearest other cluster. Values range from
                \u22121 (misclassified) to +1 (well-clustered). The average silhouette width
                across all points summarises overall clustering quality."),
        tags$li(tags$strong("Gap statistic"), " \u2014 compares the observed WSS to the expected WSS
                under a null reference distribution (uniform random data). The optimal k is where the gap
                is largest, formally identified using the \u201cone standard error\u201d rule.")
      ),
      tags$p("These methods often agree but not always. When they disagree, consider the
              substantive context: are the clusters interpretable and useful? Clustering is
              fundamentally exploratory, so external validation (e.g., do clusters predict
              an outcome not used in clustering?) is valuable when possible."),
      tags$p("It is also important to remember that k-means assumes roughly spherical,
              equally-sized clusters. When the true cluster shapes are elongated, unequal in
              size, or have different densities, k-means may produce misleading solutions.
              In such cases, consider Gaussian mixture models or density-based methods like
              DBSCAN as alternatives."),
      tags$p("Always visualise the final cluster assignments alongside the validation metrics.
              A solution that looks good numerically but produces uninterpretable clusters
              is rarely useful in practice. Domain knowledge should guide the final choice of k."),
      guide = tags$ol(
        tags$li("Generate clustered data and see all three metrics plotted."),
        tags$li("Increase spread to make clusters harder to separate — watch the metrics degrade."),
        tags$li("The silhouette plot (bottom) shows how well-assigned individual points are.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("True Clusters"), plotlyOutput(ns("clv_scatter"), height = "340px")),
      card(full_screen = TRUE, card_header("Elbow Plot (WSS)"), plotlyOutput(ns("clv_elbow"), height = "340px")),
      card(full_screen = TRUE, card_header("Average Silhouette Width"), plotlyOutput(ns("clv_silhouette"), height = "340px")),
      card(full_screen = TRUE, card_header("Silhouette Plot (k = optimal)"), plotlyOutput(ns("clv_sil_detail"), height = "340px"))
    )
  )
    ),

    nav_panel(
      "Hierarchical Clustering",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("hc_n"), "n per cluster", min = 15, max = 80, value = 30, step = 5),
      sliderInput(ns("hc_k"), "True clusters", min = 2, max = 6, value = 3, step = 1),
      sliderInput(ns("hc_sep"), "Cluster separation", min = 1, max = 6,
                  value = 3, step = 0.5),
      selectInput(ns("hc_method"), "Linkage method",
        choices = c("Ward's (ward.D2)" = "ward.D2",
                    "Complete" = "complete",
                    "Average (UPGMA)" = "average",
                    "Single" = "single"),
        selected = "ward.D2"
      ),
      sliderInput(ns("hc_cut_k"), "Cut into k clusters", min = 2, max = 6, value = 3, step = 1),
      actionButton(ns("hc_go"), "Cluster", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Hierarchical Clustering"),
      tags$p("Agglomerative hierarchical clustering builds a tree (dendrogram)
              by starting with each observation as its own cluster and iteratively
              merging the two closest clusters until all observations belong to a
              single group. The linkage method defines how \u201ccloseness\u201d is
              measured between clusters."),
      tags$p(
        tags$b("Ward\u2019s method:"), " merges clusters that produce the smallest increase in
                total within-cluster variance. Tends to produce compact, roughly equal-sized
                clusters. Generally recommended as a default.", tags$br(),
        tags$b("Complete linkage:"), " uses the maximum distance between any two points in the
                clusters. Produces compact clusters but is sensitive to outliers.", tags$br(),
        tags$b("Average linkage:"), " uses the mean distance between all pairs. A compromise
                between single and complete.", tags$br(),
        tags$b("Single linkage:"), " uses the minimum distance. Can find irregularly shaped
                clusters but is prone to \u201cchaining\u201d (merging clusters via thin bridges
                of points)."
      ),
      tags$p("The dendrogram provides a complete hierarchy that can be cut at any height
              to produce different numbers of clusters. This is an advantage over k-means,
              which requires specifying k in advance. However, hierarchical clustering is
              computationally expensive for large datasets (O(n\u00b2) memory and O(n\u00b3) time)."),
      guide = tags$ol(
        tags$li("Set the number of true clusters and separation."),
        tags$li("Choose a linkage method."),
        tags$li("Click 'Cluster' and examine the dendrogram and scatter plot."),
        tags$li("Try different linkage methods \u2014 single linkage produces 'chaining'; Ward tends to give round clusters.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Dendrogram"),
           plotOutput(ns("hc_dendro"), height = "350px")),
      card(full_screen = TRUE, card_header("Cluster Assignments"),
           plotlyOutput(ns("hc_scatter"), height = "380px"))
    )
  )
    ),

    nav_panel(
      "Discriminant Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      sliderInput(ns("da_n"), "n per group", min = 30, max = 200, value = 80, step = 10),
      sliderInput(ns("da_sep"), "Group separation", min = 0.5, max = 4,
                  value = 2, step = 0.25),
      selectInput(ns("da_method"), "Method",
        choices = c("LDA (Linear)" = "lda", "QDA (Quadratic)" = "qda"),
        selected = "lda"
      ),
      checkboxInput(ns("da_unequal_cov"), "Unequal covariances (favors QDA)", value = FALSE),
      actionButton(ns("da_go"), "Run", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Discriminant Analysis"),
      tags$p("Discriminant analysis finds optimal boundaries to separate known groups based
              on predictor variables. It can be used both for classification (predicting group
              membership) and for understanding which variables best distinguish groups."),
      tags$ul(
        tags$li(tags$strong("LDA (Linear):"), " Assumes equal covariance matrices across all groups,
                producing linear decision boundaries. The discriminant functions are linear
                combinations of the predictors that maximise between-group separation relative
                to within-group variability."),
        tags$li(tags$strong("QDA (Quadratic):"), " Allows each group to have its own covariance matrix,
                producing curved decision boundaries. More flexible than LDA but requires more
                data to estimate the additional parameters reliably.")
      ),
      tags$p("LDA is closely related to MANOVA: both decompose variability into between-group
              and within-group components. LDA also produces dimension-reduced projections
              (discriminant scores) that can be used for visualisation, similar to PCA but
              optimised for group separation rather than total variance."),
      tags$p("When covariances truly differ, QDA will outperform LDA. When they are equal
              (or nearly so), LDA is more parsimonious and often generalises better to new
              data. Box\u2019s M test can assess equality of covariance matrices, though it
              is sensitive to non-normality."),
      guide = tags$ol(
        tags$li("Set group size and separation."),
        tags$li("Toggle 'Unequal covariances' to see when QDA beats LDA."),
        tags$li("Click 'Run' and examine the decision boundary and classification accuracy.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("Decision Boundary"),
           plotlyOutput(ns("da_plot"), height = "440px")),
      card(card_header("Classification Results"), tableOutput(ns("da_table")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

clustering_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  clv_data <- reactiveVal(NULL)

  observeEvent(input$clv_run, {
    set.seed(sample.int(10000, 1))
    true_k <- input$clv_true_k
    n_per  <- input$clv_n
    sig    <- input$clv_spread
    max_k  <- input$clv_max_k

    angles <- seq(0, 2 * pi, length.out = true_k + 1)[-(true_k + 1)]
    radius <- 3
    centers <- cbind(radius * cos(angles), radius * sin(angles))

    df_list <- lapply(seq_len(true_k), function(j) {
      data.frame(
        x = rnorm(n_per, centers[j, 1], sig),
        y = rnorm(n_per, centers[j, 2], sig),
        true_cluster = factor(j)
      )
    })
    df <- do.call(rbind, df_list)
    mat <- as.matrix(df[, 1:2])

    wss <- sapply(1:max_k, function(k) {
      km <- kmeans(mat, k, nstart = 10)
      km$tot.withinss
    })

    avg_sil <- sapply(2:max_k, function(k) {
      km <- kmeans(mat, k, nstart = 10)
      sil <- cluster::silhouette(km$cluster, dist(mat))
      mean(sil[, 3])
    })

    opt_k <- which.max(avg_sil) + 1
    km_opt <- kmeans(mat, opt_k, nstart = 10)
    sil_opt <- cluster::silhouette(km_opt$cluster, dist(mat))

    clv_data(list(df = df, mat = mat, wss = wss, avg_sil = avg_sil,
                  max_k = max_k, true_k = true_k, opt_k = opt_k,
                  sil_opt = sil_opt, km_opt = km_opt))
  })

  output$clv_scatter <- renderPlotly({
    req(clv_data())
    df <- clv_data()$df
    true_k <- clv_data()$true_k
    palette <- RColorBrewer::brewer.pal(max(3, true_k), "Set2")

    p <- plotly::plot_ly()
    for (cl in seq_len(true_k)) {
      gd <- df[df$true_cluster == cl, ]
      hover_txt <- paste0("Cluster: ", cl,
                          "<br>x = ", round(gd$x, 3),
                          "<br>y = ", round(gd$y, 3))
      p <- p |>
        plotly::add_markers(
          x = gd$x, y = gd$y,
          marker = list(color = palette[cl], size = 5, opacity = 0.6,
                        line = list(width = 0.5, color = "#FFFFFF")),
          hoverinfo = "text", text = hover_txt,
          name = paste0("Cluster ", cl)
        )
    }
    p |> plotly::layout(
      xaxis = list(title = "x"),
      yaxis = list(title = "y", scaleanchor = "x", scaleratio = 1),
      annotations = list(
        list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
             text = paste0(true_k, " true clusters"),
             showarrow = FALSE, font = list(size = 13))
      ),
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.15, yanchor = "top"),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$clv_elbow <- renderPlotly({
    req(clv_data())
    cd <- clv_data()
    ks <- 1:cd$max_k

    hover_txt <- paste0("k = ", ks,
                        "<br>WSS = ", round(cd$wss, 2),
                        ifelse(ks == cd$true_k, "<br>\u2b50 True k", ""))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = ks, y = cd$wss,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 7),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cd$true_k, y = cd$wss[cd$true_k],
        marker = list(color = "#e31a1c", size = 12,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("True k = ", cd$true_k, "<br>WSS = ", round(cd$wss[cd$true_k], 2)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "k"),
        yaxis = list(title = "Total Within-Cluster SS"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Red dot = true k (", cd$true_k, ")"),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$clv_silhouette <- renderPlotly({
    req(clv_data())
    cd <- clv_data()
    ks <- 2:cd$max_k

    hover_txt <- paste0("k = ", ks,
                        "<br>Avg Silhouette = ", round(cd$avg_sil, 3),
                        ifelse(ks == cd$opt_k, "<br>\u2b50 Optimal", ""))

    plotly::plot_ly() |>
      plotly::add_trace(
        x = ks, y = cd$avg_sil,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 7),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = cd$opt_k, y = cd$avg_sil[cd$opt_k - 1],
        marker = list(color = "#e31a1c", size = 12,
                      line = list(width = 2, color = "#FFFFFF")),
        hoverinfo = "text",
        text = paste0("Optimal k = ", cd$opt_k,
                      "<br>Avg Sil = ", round(cd$avg_sil[cd$opt_k - 1], 3)),
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "k"),
        yaxis = list(title = "Average Silhouette Width"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Optimal k = ", cd$opt_k),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$clv_sil_detail <- renderPlotly({
    req(clv_data())
    cd <- clv_data()
    sil <- cd$sil_opt

    sil_df <- data.frame(
      cluster = factor(sil[, 1]),
      sil_width = sil[, 3]
    )
    sil_df <- sil_df[order(sil_df$cluster, -sil_df$sil_width), ]
    sil_df$idx <- seq_len(nrow(sil_df))
    mean_sil <- mean(sil_df$sil_width)

    palette <- RColorBrewer::brewer.pal(max(3, cd$opt_k), "Set2")
    colors <- palette[as.integer(sil_df$cluster)]

    hover_txt <- paste0("Observation ", sil_df$idx,
                        "<br>Cluster: ", sil_df$cluster,
                        "<br>Silhouette: ", round(sil_df$sil_width, 3))

    plotly::plot_ly() |>
      plotly::add_bars(textposition = "none",
        x = sil_df$idx, y = sil_df$sil_width,
        marker = list(color = colors, line = list(width = 0)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::layout(
        shapes = list(
          list(type = "line", x0 = 0, x1 = nrow(sil_df),
               y0 = mean_sil, y1 = mean_sil,
               line = list(color = "#e31a1c", width = 2, dash = "dash"))
        ),
        xaxis = list(title = "Observations (sorted)"),
        yaxis = list(title = "Silhouette Width",
                     range = c(min(sil_df$sil_width) - 0.05, 1)),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("k = ", cd$opt_k, ",  avg = ", round(mean_sil, 3)),
               showarrow = FALSE, font = list(size = 13))
        ),
        bargap = 0, margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  hc_data <- reactiveVal(NULL)

  observeEvent(input$hc_go, {
    n <- input$hc_n; k <- input$hc_k; sep <- input$hc_sep
    method <- input$hc_method; cut_k <- input$hc_cut_k
    set.seed(sample.int(10000, 1))

    # Generate cluster centers in 2D
    centers <- matrix(rnorm(k * 2, sd = sep), ncol = 2)
    x <- do.call(rbind, lapply(seq_len(k), function(i) {
      MASS::mvrnorm(n, mu = centers[i, ], Sigma = diag(1, 2))
    }))
    true_label <- rep(seq_len(k), each = n)

    hc_fit <- hclust(dist(x), method = method)
    assignments <- cutree(hc_fit, k = cut_k)

    hc_data(list(x = x, true = true_label, hc = hc_fit, assigned = assignments,
                 cut_k = cut_k))
  })

  output$hc_dendro <- renderPlot(bg = "transparent", {
    res <- hc_data(); req(res)
    dark <- isTRUE(session$userData$dark_mode)
    fg_col <- if (dark) "#839496" else "#657b83"
    axis_col <- if (dark) "#586e75" else "#93a1a1"
    par(bg = "transparent", fg = fg_col,
        col.axis = axis_col, col.lab = fg_col, col.main = fg_col)
    plot(res$hc, labels = FALSE, main = "", xlab = "", sub = "",
         hang = -1)
    # Draw cut line
    h <- sort(res$hc$height, decreasing = TRUE)[res$cut_k - 1]
    abline(h = h, col = "#e31a1c", lty = 2, lwd = 2)
    rect.hclust(res$hc, k = res$cut_k, border = 2:(res$cut_k + 1))
  })

  output$hc_scatter <- renderPlotly({
    res <- hc_data()
    req(res)
    cols <- RColorBrewer::brewer.pal(max(3, res$cut_k), "Set2")

    plotly::plot_ly(
      x = res$x[, 1], y = res$x[, 2],
      color = factor(res$assigned),
      colors = cols[seq_len(res$cut_k)],
      type = "scatter", mode = "markers",
      marker = list(size = 6, opacity = 0.6),
      hoverinfo = "text",
      text = paste0("Cluster: ", res$assigned, "<br>True: ", res$true,
                     "<br>x1 = ", round(res$x[, 1], 2),
                     "<br>x2 = ", round(res$x[, 2], 2))
    ) |>
      plotly::layout(
        xaxis = list(title = "Dimension 1"),
        yaxis = list(title = "Dimension 2"),
        legend = list(title = list(text = "Assigned Cluster")),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  da_data <- reactiveVal(NULL)

  observeEvent(input$da_go, {
    n <- input$da_n; sep <- input$da_sep
    method <- input$da_method; uneq <- input$da_unequal_cov
    set.seed(sample.int(10000, 1))

    if (uneq) {
      S1 <- matrix(c(1, 0.3, 0.3, 1), 2)
      S2 <- matrix(c(2, -0.8, -0.8, 2), 2)
    } else {
      S1 <- S2 <- matrix(c(1, 0.3, 0.3, 1), 2)
    }
    x1 <- MASS::mvrnorm(n, mu = c(-sep / 2, 0), Sigma = S1)
    x2 <- MASS::mvrnorm(n, mu = c(sep / 2, 0), Sigma = S2)
    dat <- data.frame(
      x = c(x1[, 1], x2[, 1]),
      y = c(x1[, 2], x2[, 2]),
      group = factor(rep(c("A", "B"), each = n))
    )

    # Fit model
    fit <- if (method == "lda") MASS::lda(group ~ x + y, data = dat)
           else MASS::qda(group ~ x + y, data = dat)
    preds <- predict(fit)$class
    acc <- mean(preds == dat$group)

    # Grid for boundary
    xr <- range(dat$x) + c(-0.5, 0.5)
    yr <- range(dat$y) + c(-0.5, 0.5)
    grid <- expand.grid(x = seq(xr[1], xr[2], length.out = 100),
                         y = seq(yr[1], yr[2], length.out = 100))
    grid$pred <- predict(fit, newdata = grid)$class

    da_data(list(dat = dat, grid = grid, preds = preds, acc = acc,
                 method = method, xr = xr, yr = yr))
  })

  output$da_plot <- renderPlotly({
    res <- da_data()
    req(res)
    grid <- res$grid; dat <- res$dat
    grid_mat <- matrix(as.integer(grid$pred == "B"), nrow = 100)

    plotly::plot_ly() |>
      plotly::add_contour(
        x = seq(res$xr[1], res$xr[2], length.out = 100),
        y = seq(res$yr[1], res$yr[2], length.out = 100),
        z = grid_mat,
        contours = list(start = 0.5, end = 0.5, size = 1,
                        coloring = "none",
                        showlabels = FALSE),
        line = list(color = "grey40", width = 2, dash = "dash"),
        showscale = FALSE, hoverinfo = "skip", showlegend = FALSE
      ) |>
      plotly::add_markers(
        x = dat$x[dat$group == "A"], y = dat$y[dat$group == "A"],
        marker = list(color = "#3182bd", size = 5, opacity = 0.5),
        name = "Group A", hoverinfo = "text",
        text = paste0("A<br>x = ", round(dat$x[dat$group == "A"], 2),
                       "<br>y = ", round(dat$y[dat$group == "A"], 2))
      ) |>
      plotly::add_markers(
        x = dat$x[dat$group == "B"], y = dat$y[dat$group == "B"],
        marker = list(color = "#e31a1c", size = 5, opacity = 0.5),
        name = "Group B", hoverinfo = "text",
        text = paste0("B<br>x = ", round(dat$x[dat$group == "B"], 2),
                       "<br>y = ", round(dat$y[dat$group == "B"], 2))
      ) |>
      plotly::layout(
        xaxis = list(title = "X1"), yaxis = list(title = "X2"),
        annotations = list(list(
          x = 0.5, y = 1.05, xref = "paper", yref = "paper",
          text = paste0(toupper(res$method), " | Accuracy: ", round(res$acc * 100, 1), "%"),
          showarrow = FALSE, font = list(size = 13)
        )),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.1),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$da_table <- renderTable({
    res <- da_data(); req(res)
    dat <- res$dat
    cm <- table(Predicted = res$preds, Actual = dat$group)
    as.data.frame.matrix(cm)
  }, striped = TRUE, hover = TRUE, width = "100%", rownames = TRUE)
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Clustering & Classification", list(clv_data, hc_data, da_data))
  })
}
