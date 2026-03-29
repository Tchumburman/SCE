# Module: Dimension Reduction (consolidated)

# ── UI ──────────────────────────────────────────────────────────────────
dim_reduction_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Dimension Reduction",
  icon = icon("compress"),
  navset_card_underline(
    nav_panel(
      "Factor Analysis / PCA",
  navset_card_underline(
    nav_panel(
      "PCA",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("pca_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
          sliderInput(ns("pca_vars"), "Number of variables", min = 4, max = 15, value = 8),
          sliderInput(ns("pca_factors"), "True underlying factors", min = 2, max = 5, value = 3),
          actionButton(ns("pca_go"), "Generate & run PCA", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Principal Component Analysis"),
            tags$p("PCA is a dimensionality reduction technique that transforms correlated
                    variables into a smaller set of uncorrelated components. The first
                    component captures the most variance, the second captures the most
                    remaining variance (orthogonal to the first), and so on."),
            tags$p("The scree plot (eigenvalues per component) helps decide how many
                    components to retain \u2014 look for the \u201celbow\u201d where values level off,
                    or use Kaiser\u2019s criterion (eigenvalue > 1). The biplot shows both
                    observations and variable loadings in the PC1-PC2 space."),
            tags$p("PCA is often confused with factor analysis, but they serve different purposes.
                    PCA is a data reduction technique that maximises variance explained by each
                    component. Factor analysis assumes a latent variable model where observed
                    variables are caused by underlying factors. In practice, PCA is preferred
                    for dimensionality reduction before modelling, while factor analysis is
                    preferred when the goal is to identify interpretable latent constructs."),
            tags$p("Before running PCA, variables should be standardised (mean = 0, SD = 1) unless
                    they are on the same scale. Without standardisation, variables with larger
                    variances dominate the first components regardless of their substantive
                    importance. The proportion of total variance explained by the retained
                    components indicates how much information is preserved in the reduced
                    representation."),
            guide = tags$ol(
              tags$li("Set sample size, number of variables, and true underlying factors."),
              tags$li("Click 'Generate & run PCA'."),
              tags$li("Scree plot: count how many components are above the red dashed line (Kaiser criterion) or identify the elbow."),
              tags$li("Loading plot: shows which variables load on the first 3 components. Strong loadings indicate the variable is well-represented by that component."),
              tags$li("Biplot: points are observations; red arrows are variables. Variables pointing the same direction are positively correlated.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Scree Plot"),
                 plotly::plotlyOutput(ns("pca_scree"), height = "380px")),
            card(full_screen = TRUE, card_header("Component Loadings"),
                 plotly::plotlyOutput(ns("pca_loadings"), height = "380px"))
          ),
          card(full_screen = TRUE, card_header("Biplot (PC1 vs PC2)"),
               plotly::plotlyOutput(ns("pca_biplot"), height = "450px"))
        )
      )
    ),
    nav_panel(
      "Factor Analysis",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("fa_n"), "Sample size", min = 50, max = 1000, value = 200, step = 50),
          sliderInput(ns("fa_vars"), "Number of variables", min = 4, max = 15, value = 9),
          sliderInput(ns("fa_k"), "Number of factors to extract", min = 2, max = 5, value = 3),
          sliderInput(ns("fa_crossload"), "Cross-loading strength", min = 0, max = 0.4,
                      value = 0.05, step = 0.05),
          selectInput(ns("fa_rotation"), "Rotation",
                      choices = c("none", "varimax", "promax", "oblimin")),
          actionButton(ns("fa_go"), "Generate & run FA", class = "btn-success w-100")
        ),
        fillable = FALSE,
        div(
          explanation_box(
            tags$strong("Exploratory Factor Analysis"),
            tags$p("EFA aims to discover latent factors that explain the correlations
                    among observed variables. Unlike PCA (which is purely mathematical),
                    EFA assumes a generative model: latent factors cause the observed
                    variables. The initial unrotated solution is mathematically correct
                    but hard to interpret; rotation makes the loading pattern cleaner."),
            tags$p(
              tags$b("No rotation:"), " initial solution — loadings are spread across factors.", tags$br(),
              tags$b("Varimax:"), " orthogonal rotation — factors stay uncorrelated, each variable loads strongly on one factor.", tags$br(),
              tags$b("Promax:"), " oblique rotation — allows factors to correlate; raises varimax loadings to a power to sharpen pattern.", tags$br(),
              tags$b("Oblimin:"), " oblique rotation — directly minimizes cross-loadings using a different criterion than promax."
            ),
            tags$p(class = "text-muted", "Tip: increase 'Cross-loading strength' to
                    0.2+ to see meaningful differences between promax and oblimin. With
                    simple structure, both oblique rotations converge to near-identical
                    solutions."),
            tags$p("A critical distinction between PCA and EFA: PCA decomposes total variance
                    (including unique/error variance), while EFA models only shared variance
                    (communalities). EFA is appropriate when you believe latent constructs
                    cause the observed correlations; PCA is appropriate when you simply want
                    to summarise the data in fewer dimensions. In practice, with many variables
                    and strong correlations, PCA and EFA often yield similar results."),
            tags$p("When choosing the number of factors, combine multiple criteria: parallel
                    analysis, scree plot inspection, interpretability of the rotated solution,
                    and theoretical expectations. No single rule is definitive. Factor solutions
                    should be cross-validated on independent samples when possible."),
            guide = tags$ol(
              tags$li("Set sample size, number of variables, and factors to extract."),
              tags$li("Adjust cross-loading strength: 0 = perfect simple structure; 0.3+ = complex."),
              tags$li("Choose a rotation method."),
              tags$li("Click 'Generate & run FA'."),
              tags$li("Heatmap: green = positive loading, red = negative. Ideally each variable loads strongly on exactly one factor."),
              tags$li("Loading space: variables as points in Factor 1 vs Factor 2 space. Rotated axes show how rotation re-orients the factor space."),
              tags$li("Diagram: lines connect factors (circles) to variables (boxes). Width = loading magnitude.")
            )
          ),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE, card_header("Factor Loadings Heatmap"),
                 plotly::plotlyOutput(ns("fa_heatmap"), height = "420px")),
            card(full_screen = TRUE, card_header("Loading Space (F1 vs F2)"),
                 plotly::plotlyOutput(ns("fa_loading_space"), height = "420px"))
          ),
          card(full_screen = TRUE, card_header("Factor Diagram"),
               plotly::plotlyOutput(ns("fa_diagram"), height = "420px"))
        )
      )
    )
  )
    ),

    nav_panel(
      "MDS",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("mds_data"), "Dataset",
        choices = c("Simulated clusters" = "clusters",
                    "European cities (distances)" = "eurodist",
                    "Random high-dimensional" = "random_hd"),
        selected = "clusters"
      ),
      conditionalPanel(ns = ns, "input.mds_data == 'clusters'",
        sliderInput(ns("mds_k"), "Number of clusters", min = 2, max = 6, value = 3, step = 1),
        sliderInput(ns("mds_dim"), "Original dimensions", min = 3, max = 20, value = 5, step = 1),
        sliderInput(ns("mds_n"), "Points per cluster", min = 15, max = 100, value = 30, step = 5)
      ),
      conditionalPanel(ns = ns, "input.mds_data == 'random_hd'",
        sliderInput(ns("mds_hd_dim"), "Original dimensions", min = 5, max = 50, value = 10, step = 5),
        sliderInput(ns("mds_hd_n"), "Number of points", min = 20, max = 200, value = 60, step = 10)
      ),
      selectInput(ns("mds_method"), "MDS method",
        choices = c("Classical (metric) MDS" = "classical",
                    "Non-metric MDS (isoMDS)" = "nonmetric"),
        selected = "classical"
      ),
      actionButton(ns("mds_run"), "Run MDS", icon = icon("play"),
                   class = "btn-success w-100 mt-2")
    ),

    explanation_box(
      tags$strong("Multidimensional Scaling (MDS)"),
      tags$p("MDS takes a distance (or dissimilarity) matrix and produces a
              low-dimensional representation that preserves pairwise distances
              as well as possible. It is useful when you have only dissimilarity
              data (e.g., perceived similarity ratings) rather than variable-by-observation
              data. MDS can also be applied to any distance metric, not just Euclidean."),
      tags$ul(
        tags$li(tags$strong("Classical (metric) MDS"), " \u2014 eigenvalue-based decomposition of the
                doubly-centred distance matrix. Equivalent to PCA when distances are Euclidean.
                Preserves actual distance values."),
        tags$li(tags$strong("Non-metric MDS"), " \u2014 preserves only the rank order of distances,
                not their exact values. This is more flexible and appropriate when the
                dissimilarity measure is ordinal (e.g., subjective ratings).")
      ),
      tags$p("The Shepard diagram (original vs. MDS distances) is the key diagnostic:
              points should fall close to a monotone curve (non-metric) or the identity
              line (metric). The stress value quantifies misfit \u2014 Kruskal\u2019s rule
              of thumb suggests stress < 0.05 is excellent, < 0.10 is good, and > 0.20
              is poor. Low-dimensional MDS solutions (2D) are most useful for visualisation
              but may not capture all the structure in the data."),
      tags$p("MDS is widely used in psychology (perceptual maps), ecology (community
              composition), and marketing (brand positioning). Its strength is that it
              requires only a dissimilarity matrix, not raw data, making it applicable
              to subjective judgements, genetic distances, or any other pairwise measure.
              When raw data are available, PCA or t-SNE may be more appropriate."),
      guide = tags$ol(
        tags$li("Choose a dataset and MDS method."),
        tags$li("The left plot shows the 2D MDS solution."),
        tags$li("The right plot (Shepard diagram) shows how well original vs. MDS distances correspond."),
        tags$li("Try different data and see how well structure is preserved in 2D.")
      )
    ),

    layout_column_wrap(
      width = 1 / 2,
      card(full_screen = TRUE, card_header("MDS Solution (2D)"),
           plotlyOutput(ns("mds_scatter"), height = "400px")),
      card(full_screen = TRUE, card_header("Shepard Diagram"),
           plotlyOutput(ns("mds_shepard"), height = "400px"))
    )
  )
    ),

    nav_panel(
      "Correspondence Analysis",
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      selectInput(ns("ca_data"), "Dataset",
        choices = c("Hair \u00d7 Eye Color" = "hair",
                    "Simulated survey" = "survey",
                    "Custom contingency" = "custom"),
        selected = "hair"
      ),
      conditionalPanel(ns = ns, "input.ca_data == 'custom'",
        sliderInput(ns("ca_rows"), "Number of row categories", min = 3, max = 8, value = 4),
        sliderInput(ns("ca_cols"), "Number of col categories", min = 3, max = 8, value = 4),
        sliderInput(ns("ca_n"), "Total count", min = 100, max = 2000, value = 500, step = 100)
      ),
      actionButton(ns("ca_go"), "Analyze", class = "btn-success w-100 mt-2")
    ),
    explanation_box(
      tags$strong("Correspondence Analysis"),
      tags$p("Correspondence analysis (CA) is a dimensionality reduction technique
              specifically designed for contingency tables (cross-tabulations of
              categorical variables). It decomposes the chi-square statistic into
              orthogonal dimensions and visualises the associations between row and
              column categories in a low-dimensional biplot."),
      tags$p("In the biplot, row and column categories that are close together are more
              strongly associated than expected under independence. Categories near the
              origin have profiles close to the average (marginal) profile. The total
              inertia equals the chi-square statistic divided by n, so it measures the
              overall strength of association in the table."),
      tags$p("CA is particularly valuable in the social sciences, ecology, and market
              research for exploring relationships in large cross-tabulations that would
              be difficult to interpret from the raw numbers alone. Multiple correspondence
              analysis (MCA) extends the technique to more than two categorical variables
              simultaneously."),
      guide = tags$ol(
        tags$li("Choose a dataset or create a custom contingency table."),
        tags$li("Click 'Analyze' to run correspondence analysis."),
        tags$li("In the biplot, row categories (\u25cf) and column categories (\u25b2) that are near each other are associated."),
        tags$li("Check the inertia table to see how much association each dimension captures.")
      )
    ),
    layout_column_wrap(
      width = 1,
      card(full_screen = TRUE, card_header("CA Biplot"),
           plotlyOutput(ns("ca_biplot"), height = "450px")),
      card(card_header("Dimension Summary"), tableOutput(ns("ca_inertia")))
    )
  )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

dim_reduction_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  # -- PCA --
  pca_result <- reactiveVal(NULL)
  
  observeEvent(input$pca_go, {
    withProgress(message = "Running PCA...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$pca_n; p <- input$pca_vars; k <- input$pca_factors
    factors <- matrix(rnorm(n * k), n, k)
    loadings <- matrix(runif(p * k, 0.3, 0.9) * sample(c(-1, 1), p * k, replace = TRUE),
                       p, k)
    for (j in seq_len(p)) {
      primary <- ((j - 1) %% k) + 1
      loadings[j, ] <- loadings[j, ] * 0.2
      loadings[j, primary] <- runif(1, 0.6, 0.95)
    }
    noise <- matrix(rnorm(n * p, 0, 0.5), n, p)
    data <- factors %*% t(loadings) + noise
    colnames(data) <- paste0("V", seq_len(p))

    pc <- prcomp(data, scale. = TRUE)
    pca_result(list(pc = pc, data = data))
    })
  })
  
  output$pca_scree <- plotly::renderPlotly({
    res <- pca_result()
    req(res)
    eig <- res$pc$sdev^2
    df <- data.frame(Component = seq_along(eig), Eigenvalue = eig)

    plotly::plot_ly() |>
      plotly::add_trace(
        data = df, x = ~Component, y = ~Eigenvalue,
        type = "scatter", mode = "lines+markers",
        line = list(color = "#238b45", width = 2),
        marker = list(color = "#238b45", size = 8),
        name = "Eigenvalue",
        hoverinfo = "text",
        text = paste0("PC", df$Component, "<br>Eigenvalue: ", round(df$Eigenvalue, 3))
      ) |>
      plotly::layout(
        shapes = list(list(
          type = "line", x0 = 0.5, x1 = max(df$Component) + 0.5,
          y0 = 1, y1 = 1, xref = "x", yref = "y",
          line = list(color = "#e31a1c", width = 1.5, dash = "dash")
        )),
        annotations = list(list(
          x = max(df$Component) * 0.95, y = 1.15,
          text = "Kaiser criterion = 1", showarrow = FALSE,
          font = list(color = "#e31a1c", size = 11),
          xref = "x", yref = "y"
        )),
        xaxis = list(title = "Component", dtick = 1),
        yaxis = list(title = "Eigenvalue"),
        showlegend = FALSE,
        margin = list(t = 30)
      )
  })
  
  output$pca_loadings <- plotly::renderPlotly({
    res <- pca_result()
    req(res)
    nc <- min(3, ncol(res$pc$rotation))
    ld <- res$pc$rotation[, 1:nc, drop = FALSE]
    df <- as.data.frame(ld)
    df$Variable <- rownames(df)
    df_long <- reshape(df, direction = "long", varying = names(df)[names(df) != "Variable"],
                       v.names = "Loading", timevar = "PC", times = colnames(ld))
    df_long$PC <- factor(df_long$PC)
    df_long$Color <- ifelse(df_long$Loading > 0, "#238b45", "#e31a1c")

    pcs <- unique(df_long$PC)
    subplots <- lapply(pcs, function(pc) {
      d <- df_long[df_long$PC == pc, ]
      colors <- ifelse(d$Loading > 0, "#238b45", "#e31a1c")
      hover <- paste0(d$Variable, "<br>", pc, ": ", round(d$Loading, 3))
      plot_ly() |>
        add_bars(y = d$Variable, x = d$Loading, orientation = "h",
                 text = hover, textposition = "none", hoverinfo = "text",
                 marker = list(color = colors), showlegend = FALSE) |>
        layout(
          yaxis = list(title = "", categoryorder = "array",
                       categoryarray = rev(d$Variable)),
          xaxis = list(title = "Loading"),
          annotations = list(
            list(x = 0.5, y = 1.05, xref = "paper", yref = "paper",
                 text = pc, showarrow = FALSE, font = list(size = 11))
          )
        )
    })
    subplot(subplots, nrows = 1, shareY = TRUE, titleX = TRUE)
  })
  
  output$pca_biplot <- plotly::renderPlotly({
    res <- pca_result()
    req(res)
    scores <- as.data.frame(res$pc$x[, 1:2])
    ld <- as.data.frame(res$pc$rotation[, 1:2])
    ld$Variable <- rownames(ld)
    scale_factor <- max(abs(scores)) / max(abs(ld[, 1:2])) * 0.8

    var_pct1 <- round(res$pc$sdev[1]^2 / sum(res$pc$sdev^2) * 100, 1)
    var_pct2 <- round(res$pc$sdev[2]^2 / sum(res$pc$sdev^2) * 100, 1)

    # Build arrow shapes
    arrows <- lapply(seq_len(nrow(ld)), function(i) {
      list(
        x = ld$PC1[i] * scale_factor, y = ld$PC2[i] * scale_factor,
        ax = 0, ay = 0,
        xref = "x", yref = "y", axref = "x", ayref = "y",
        showarrow = TRUE, arrowhead = 3, arrowsize = 1,
        arrowcolor = "#e31a1c", arrowwidth = 1.5, text = ""
      )
    })
    # Arrow labels
    labels <- lapply(seq_len(nrow(ld)), function(i) {
      list(
        x = ld$PC1[i] * scale_factor * 1.12,
        y = ld$PC2[i] * scale_factor * 1.12,
        text = ld$Variable[i], showarrow = FALSE,
        font = list(color = "#e31a1c", size = 10),
        xref = "x", yref = "y"
      )
    })

    plotly::plot_ly() |>
      plotly::add_markers(
        x = scores$PC1, y = scores$PC2,
        marker = list(color = "#00441b", size = 4, opacity = 0.3),
        name = "Observations", showlegend = FALSE,
        hoverinfo = "text",
        text = paste0("PC1: ", round(scores$PC1, 2), "<br>PC2: ", round(scores$PC2, 2))
      ) |>
      plotly::layout(
        xaxis = list(title = paste0("PC1 (", var_pct1, "%)")),
        yaxis = list(title = paste0("PC2 (", var_pct2, "%)")),
        annotations = c(arrows, labels),
        showlegend = FALSE,
        margin = list(t = 30)
      )
  })
  
  # -- Factor Analysis --
  fa_result <- reactiveVal(NULL)
  # Store unrotated loadings for the loading space plot
  fa_unrotated <- reactiveVal(NULL)
  
  observeEvent(input$fa_go, {
    withProgress(message = "Running factor analysis...", value = 0.1, {
    set.seed(sample(1:10000, 1))
    n <- input$fa_n; p <- input$fa_vars; k <- input$fa_k
    cl <- input$fa_crossload
    factors <- matrix(rnorm(n * k), n, k)
    loadings_mat <- matrix(0, p, k)
    for (j in seq_len(p)) {
      primary <- ((j - 1) %% k) + 1
      loadings_mat[j, primary] <- runif(1, 0.5, 0.9)
      for (f in seq_len(k)) {
        if (f != primary) loadings_mat[j, f] <- runif(1, -cl, cl)
      }
    }
    noise <- matrix(rnorm(n * p, 0, 0.4), n, p)
    data <- factors %*% t(loadings_mat) + noise
    colnames(data) <- paste0("V", seq_len(p))

    rotation <- input$fa_rotation
    rot <- if (rotation == "none") "none" else rotation
    if (rot %in% c("oblimin", "promax")) {
      if (requireNamespace("GPArotation", quietly = TRUE)) {
        library(GPArotation)
      }
    }

    # Get unrotated solution for loading space comparison
    fit_unrot <- tryCatch(
      factanal(data, factors = k, rotation = "none", scores = "regression"),
      error = function(e) NULL
    )
    fa_unrotated(fit_unrot)

    fit <- tryCatch(
      factanal(data, factors = k, rotation = rot, scores = "regression"),
      error = function(e) { message("FA error: ", e$message); NULL }
    )
    fa_result(list(fit = fit, data = data, k = k, rotation = rotation))
    })
  })
  
  output$fa_heatmap <- plotly::renderPlotly({
    res <- fa_result()
    req(res, res$fit)
    ld <- as.data.frame(unclass(res$fit$loadings))
    vars <- rownames(ld)
    facs <- colnames(ld)
    
    # Build matrix for heatmap
    z_mat <- as.matrix(ld)
    hover_text <- matrix(
      paste0(rep(vars, times = length(facs)), " \u2192 ",
             rep(facs, each = length(vars)), "<br>Loading: ",
             round(as.vector(z_mat), 3)),
      nrow = length(vars), ncol = length(facs)
    )
    
    plotly::plot_ly(
      x = facs, y = vars, z = z_mat,
      type = "heatmap", xgap = 2, ygap = 2,
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
      zmin = -1, zmax = 1,
      hoverinfo = "text", text = hover_text,
      colorbar = list(title = "Loading")
    ) |>
      # Overlay text annotations
      plotly::layout(
        title = list(text = paste0("Rotation: ", res$rotation), font = list(size = 13)),
        xaxis = list(title = ""), yaxis = list(title = "", autorange = "reversed"),
        annotations = lapply(seq_len(nrow(z_mat)), function(i) {
          lapply(seq_len(ncol(z_mat)), function(j) {
            list(x = facs[j], y = vars[i],
                 text = round(z_mat[i, j], 2),
                 font = list(size = 10, color = if (abs(z_mat[i,j]) > 0.5) "white" else "#333"),
                 showarrow = FALSE, xref = "x", yref = "y")
          })
        }) |> unlist(recursive = FALSE),
        margin = list(t = 40, l = 60)
      )
  })
  
  output$fa_loading_space <- plotly::renderPlotly({
    res <- fa_result()
    fit_unrot <- fa_unrotated()
    req(res, res$fit, fit_unrot)
    req(res$k >= 2)
    
    # Unrotated loadings (Factor 1 vs Factor 2)
    ld_unrot <- unclass(fit_unrot$loadings)[, 1:2, drop = FALSE]
    # Rotated loadings
    ld_rot <- unclass(res$fit$loadings)[, 1:2, drop = FALSE]
    vars <- rownames(ld_rot)
    
    # Assign colors by primary factor
    k <- res$k
    primary_fac <- apply(abs(unclass(res$fit$loadings)), 1, which.max)
    fac_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e")
    pt_colors <- fac_colors[primary_fac]
    
    p <- plotly::plot_ly()
    
    if (res$rotation != "none") {
      # Show unrotated positions as faded points
      p <- p |> plotly::add_markers(
        x = ld_unrot[, 1], y = ld_unrot[, 2],
        marker = list(color = "grey70", size = 7, opacity = 0.4,
                      symbol = "diamond"),
        name = "Unrotated",
        hoverinfo = "text",
        text = paste0(vars, " (unrotated)<br>F1: ", round(ld_unrot[,1], 3),
                      "<br>F2: ", round(ld_unrot[,2], 3))
      )
      # Draw light connecting lines from unrotated to rotated
      for (i in seq_len(nrow(ld_rot))) {
        p <- p |> plotly::add_trace(
          x = c(ld_unrot[i, 1], ld_rot[i, 1]),
          y = c(ld_unrot[i, 2], ld_rot[i, 2]),
          type = "scatter", mode = "lines",
          line = list(color = "grey80", width = 0.8, dash = "dot"),
          showlegend = FALSE, hoverinfo = "none"
        )
      }
    }
    
    # Rotated positions as colored points with variable labels
    for (fi in seq_len(k)) {
      idx <- which(primary_fac == fi)
      if (length(idx) == 0) next
      p <- p |> plotly::add_markers(
        x = ld_rot[idx, 1], y = ld_rot[idx, 2],
        marker = list(color = fac_colors[fi], size = 10, opacity = 0.85,
                      line = list(width = 1, color = "#333333")),
        name = paste("Factor", fi),
        hoverinfo = "text",
        text = paste0(vars[idx], "<br>F1: ", round(ld_rot[idx, 1], 3),
                      "<br>F2: ", round(ld_rot[idx, 2], 3))
      )
    }
    
    # Build axis shapes and rotation indicator
    shapes <- list(
      # Unrotated axes (grey)
      list(type = "line", x0 = -1.1, x1 = 1.1, y0 = 0, y1 = 0,
           xref = "x", yref = "y",
           line = list(color = "grey80", width = 1, dash = "dash")),
      list(type = "line", x0 = 0, x1 = 0, y0 = -1.1, y1 = 1.1,
           xref = "x", yref = "y",
           line = list(color = "grey80", width = 1, dash = "dash"))
    )
    
    axis_annots <- list()
    
    if (res$rotation != "none") {
      # Compute rotation angle from transformation matrix
      # For varimax/promax/oblimin, the rotation matrix transforms unrotated -> rotated
      # We can estimate it via: L_rot = L_unrot %*% T, so T = solve(L_unrot) %*% L_rot (least squares)
      T_est <- tryCatch({
        qr.solve(ld_unrot, ld_rot)
      }, error = function(e) diag(2))
      
      # Draw rotated axes through origin using first two columns of T
      ax1 <- T_est[, 1] / sqrt(sum(T_est[, 1]^2)) * 1.1
      ax2 <- T_est[, 2] / sqrt(sum(T_est[, 2]^2)) * 1.1
      
      shapes <- c(shapes, list(
        list(type = "line", x0 = -ax1[1], x1 = ax1[1],
             y0 = -ax1[2], y1 = ax1[2],
             xref = "x", yref = "y",
             line = list(color = "#e31a1c", width = 2)),
        list(type = "line", x0 = -ax2[1], x1 = ax2[1],
             y0 = -ax2[2], y1 = ax2[2],
             xref = "x", yref = "y",
             line = list(color = "#2171b5", width = 2))
      ))
      
      axis_annots <- list(
        list(x = ax1[1], y = ax1[2], text = "F1'", showarrow = FALSE,
             font = list(color = "#e31a1c", size = 12, family = "Arial Black"),
             xref = "x", yref = "y", xshift = 10, yshift = 5),
        list(x = ax2[1], y = ax2[2], text = "F2'", showarrow = FALSE,
             font = list(color = "#2171b5", size = 12, family = "Arial Black"),
             xref = "x", yref = "y", xshift = 10, yshift = 5)
      )
    }
    
    p |> plotly::layout(
      title = list(text = if (res$rotation == "none") "Unrotated Loading Space"
                   else paste0("Rotation: ", res$rotation, " (red/blue = rotated axes)"),
                   font = list(size = 13)),
      xaxis = list(title = "Factor 1 loading", range = c(-1.2, 1.2), zeroline = FALSE),
      yaxis = list(title = "Factor 2 loading", range = c(-1.2, 1.2), zeroline = FALSE,
                   scaleanchor = "x", scaleratio = 1),
      shapes = shapes,
      annotations = axis_annots,
      legend = list(orientation = "h", x = 0.5, xanchor = "center",
                    y = -0.22, yanchor = "top",
                    font = list(size = 11),
                    bgcolor = "rgba(255,255,255,0.8)"),
      margin = list(b = 100, t = 50)
    )
  })
  
  output$fa_diagram <- plotly::renderPlotly({
    res <- fa_result()
    req(res, res$fit)
    ld <- unclass(res$fit$loadings)
    k <- res$k
    p <- nrow(ld)
    
    shapes <- list()
    annotations <- list()
    
    # Factor positions (top row)
    f_x <- seq(2, 8, length.out = k)
    f_y <- rep(8, k)
    # Variable positions (bottom row)
    v_x <- seq(1, 9, length.out = p)
    v_y <- rep(2, p)
    
    # Draw connections (only loadings > 0.25)
    for (j in seq_len(p)) {
      for (f in seq_len(k)) {
        if (abs(ld[j, f]) > 0.25) {
          col <- if (ld[j, f] > 0) "#238b45" else "#e31a1c"
          w <- abs(ld[j, f]) * 4
          shapes[[length(shapes) + 1]] <- list(
            type = "line",
            x0 = f_x[f], y0 = f_y[f] - 0.55,
            x1 = v_x[j], y1 = v_y[j] + 0.5,
            xref = "x", yref = "y",
            line = list(color = col, width = w),
            opacity = 0.7
          )
        }
      }
    }
    
    # Factor circles
    for (f in seq_len(k)) {
      shapes[[length(shapes) + 1]] <- list(
        type = "circle",
        x0 = f_x[f] - 0.5, y0 = f_y[f] - 0.5,
        x1 = f_x[f] + 0.5, y1 = f_y[f] + 0.5,
        xref = "x", yref = "y",
        fillcolor = "#e5f5f9", opacity = 0.9,
        line = list(color = "#006d2c", width = 2)
      )
      annotations[[length(annotations) + 1]] <- list(
        x = f_x[f], y = f_y[f], text = paste0("<b>F", f, "</b>"),
        font = list(size = 14, color = "#006d2c"),
        showarrow = FALSE, xref = "x", yref = "y"
      )
    }
    
    # Variable rectangles
    for (j in seq_len(p)) {
      shapes[[length(shapes) + 1]] <- list(
        type = "rect",
        x0 = v_x[j] - 0.4, y0 = v_y[j] - 0.4,
        x1 = v_x[j] + 0.4, y1 = v_y[j] + 0.4,
        xref = "x", yref = "y",
        fillcolor = "#f7fcfd", opacity = 0.9,
        line = list(color = "#00441b", width = 1.5)
      )
      annotations[[length(annotations) + 1]] <- list(
        x = v_x[j], y = v_y[j], text = paste0("<b>V", j, "</b>"),
        font = list(size = 10, color = "#00441b"),
        showarrow = FALSE, xref = "x", yref = "y"
      )
    }
    
    # Legend text
    annotations[[length(annotations) + 1]] <- list(
      x = 5, y = 0.5, showarrow = FALSE, xref = "x", yref = "y",
      text = "<span style='color:#238b45'>\u2501 Positive</span> &nbsp;&nbsp; <span style='color:#e31a1c'>\u2501 Negative</span> &nbsp;&nbsp; Width = |loading|",
      font = list(size = 11, color = "#666666")
    )
    
    plotly::plot_ly(type = "scatter", mode = "none") |>
      plotly::layout(
        title = list(text = paste0("Factor Diagram (", res$rotation, ")"),
                     font = list(size = 14)),
        shapes = shapes, annotations = annotations,
        xaxis = list(range = c(0, 10), showgrid = FALSE, zeroline = FALSE,
                     showticklabels = FALSE, title = ""),
        yaxis = list(range = c(-0.2, 9.5), showgrid = FALSE, zeroline = FALSE,
                     showticklabels = FALSE, title = ""),
        showlegend = FALSE,
        margin = list(t = 40)
      )
  })
  


  mds_result <- reactiveVal(NULL)

  observeEvent(input$mds_run, {
    withProgress(message = "Computing multidimensional scaling...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    data_type <- input$mds_data

    if (data_type == "clusters") {
      k   <- input$mds_k
      p   <- input$mds_dim
      n   <- input$mds_n
      centers <- matrix(rnorm(k * p, sd = 3), k, p)
      df_list <- lapply(seq_len(k), function(j) {
        mat <- matrix(rnorm(n * p, mean = 0, sd = 0.8), n, p)
        mat <- sweep(mat, 2, centers[j, ], "+")
        data.frame(mat, cluster = factor(j))
      })
      df <- do.call(rbind, df_list)
      labels <- NULL
      group <- df$cluster
      dmat <- dist(df[, 1:p])

    } else if (data_type == "eurodist") {
      dmat <- eurodist
      labels <- attr(eurodist, "Labels")
      group <- NULL

    } else {
      p <- input$mds_hd_dim
      n <- input$mds_hd_n
      mat <- matrix(rnorm(n * p), n, p)
      dmat <- dist(mat)
      labels <- NULL
      group <- NULL
    }

    # Run MDS
    if (input$mds_method == "classical") {
      fit <- cmdscale(dmat, k = 2)
      stress <- NULL
    } else {
      fit <- MASS::isoMDS(dmat, k = 2, trace = FALSE)
      stress <- fit$stress
      fit <- fit$points
    }

    # Original vs MDS distances for Shepard diagram
    orig_d <- as.vector(dmat)
    mds_d  <- as.vector(dist(fit))

    mds_result(list(coords = fit, labels = labels, group = group,
                    orig_d = orig_d, mds_d = mds_d, stress = stress,
                    method = input$mds_method))
    })
  })

  output$mds_scatter <- renderPlotly({
    req(mds_result())
    r <- mds_result()
    df <- data.frame(x = r$coords[, 1], y = r$coords[, 2])

    sub <- if (!is.null(r$stress)) paste0(r$method, " \u2014 stress = ", round(r$stress, 2)) else r$method

    if (!is.null(r$group)) {
      df$group <- r$group
      cols <- if (nlevels(df$group) <= 8) {
        RColorBrewer::brewer.pal(max(3, nlevels(df$group)), "Set2")[seq_len(nlevels(df$group))]
      } else {
        grDevices::hcl.colors(nlevels(df$group), "Set2")
      }

      p <- plotly::plot_ly()
      for (g in levels(df$group)) {
        gd <- df[df$group == g, ]
        hover_txt <- paste0("Cluster ", g,
                            "<br>Dim1 = ", round(gd$x, 3),
                            "<br>Dim2 = ", round(gd$y, 3))
        p <- p |>
          plotly::add_markers(
            x = gd$x, y = gd$y,
            marker = list(color = cols[as.integer(g)], size = 6, opacity = 0.7,
                          line = list(width = 0.5, color = "#FFFFFF")),
            hoverinfo = "text", text = hover_txt,
            name = paste0("Cluster ", g), showlegend = TRUE
          )
      }

    } else if (!is.null(r$labels)) {
      df$label <- r$labels
      hover_txt <- paste0(df$label,
                          "<br>Dim1 = ", round(df$x, 3),
                          "<br>Dim2 = ", round(df$y, 3))
      p <- plotly::plot_ly() |>
        plotly::add_markers(
          x = df$x, y = df$y,
          marker = list(color = "#238b45", size = 6,
                        line = list(width = 0.5, color = "#FFFFFF")),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        ) |>
        plotly::add_text(
          x = df$x, y = df$y, text = df$label,
          textposition = "top center",
          textfont = list(size = 10, color = "#00441b"),
          hoverinfo = "none", showlegend = FALSE
        )

    } else {
      hover_txt <- paste0("Dim1 = ", round(df$x, 3),
                          "<br>Dim2 = ", round(df$y, 3))
      p <- plotly::plot_ly() |>
        plotly::add_markers(
          x = df$x, y = df$y,
          marker = list(color = "#238b45", size = 6, opacity = 0.7,
                        line = list(width = 0.5, color = "#FFFFFF")),
          hoverinfo = "text", text = hover_txt,
          showlegend = FALSE
        )
    }

    # Force equal axes
    rng_x <- range(df$x, na.rm = TRUE)
    rng_y <- range(df$y, na.rm = TRUE)
    span <- max(diff(rng_x), diff(rng_y)) / 2 * 1.1
    cx <- mean(rng_x); cy <- mean(rng_y)

    p |> plotly::layout(
      xaxis = list(title = "Dimension 1",
                   range = c(cx - span, cx + span),
                   scaleanchor = "y", scaleratio = 1),
      yaxis = list(title = "Dimension 2",
                   range = c(cy - span, cy + span)),
      annotations = list(
        list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
             text = sub, showarrow = FALSE, font = list(size = 13))
      ),
      margin = list(t = 40)
    ) |> plotly::config(displayModeBar = FALSE)
  })

  output$mds_shepard <- renderPlotly({
    req(mds_result())
    r <- mds_result()
    df <- data.frame(orig = r$orig_d, mds = r$mds_d)
    if (nrow(df) > 5000) df <- df[sample(nrow(df), 5000), ]

    rho <- cor(df$orig, df$mds, method = "spearman")

    hover_txt <- paste0("Original = ", round(df$orig, 3),
                        "<br>MDS = ", round(df$mds, 3))

    # Reference line (identity)
    rng <- range(c(df$orig, df$mds))

    plotly::plot_ly() |>
      plotly::add_markers(
        x = df$orig, y = df$mds,
        marker = list(color = "#238b45", size = 3, opacity = 0.2,
                      line = list(width = 0)),
        hoverinfo = "text", text = hover_txt,
        showlegend = FALSE
      ) |>
      plotly::add_trace(
        x = rng, y = rng,
        type = "scatter", mode = "lines",
        line = list(color = "#e31a1c", width = 2, dash = "dash"),
        hoverinfo = "none", showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "Original Distance"),
        yaxis = list(title = "MDS Distance"),
        annotations = list(
          list(x = 0.5, y = 1.08, xref = "paper", yref = "paper",
               text = paste0("Spearman \u03c1 = ", round(rho, 3)),
               showarrow = FALSE, font = list(size = 13))
        ),
        margin = list(t = 40)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  ca_data <- reactiveVal(NULL)

  observeEvent(input$ca_go, {
    withProgress(message = "Running correspondence analysis...", value = 0.1, {
    set.seed(sample.int(10000, 1))
    tbl <- switch(input$ca_data,
      "hair" = {
        m <- matrix(c(68,119,26,7, 20,84,17,94, 15,54,14,10, 5,29,14,16),
                     nrow = 4, byrow = TRUE,
                     dimnames = list(Hair = c("Black","Brown","Red","Blond"),
                                     Eye = c("Brown","Hazel","Green","Blue")))
        m
      },
      "survey" = {
        rows <- c("Strongly Agree","Agree","Neutral","Disagree","Strongly Disagree")
        cols <- c("18-25","26-35","36-45","46-55","56+")
        m <- matrix(sample(10:100, 25), nrow = 5,
                     dimnames = list(Opinion = rows, Age = cols))
        m
      },
      "custom" = {
        nr <- input$ca_rows; nc <- input$ca_cols; ntot <- input$ca_n
        probs <- runif(nr * nc); probs <- probs / sum(probs)
        counts <- as.integer(rmultinom(1, ntot, probs))
        m <- matrix(counts, nrow = nr,
                     dimnames = list(Row = paste0("R", seq_len(nr)),
                                     Col = paste0("C", seq_len(nc))))
        m
      }
    )

    # Simple CA via SVD of standardized residuals
    n_tot <- sum(tbl)
    P <- tbl / n_tot
    r <- rowSums(P); c_mar <- colSums(P)
    Dr <- diag(1 / sqrt(r)); Dc <- diag(1 / sqrt(c_mar))
    S <- Dr %*% (P - outer(r, c_mar)) %*% Dc
    sv <- svd(S)

    row_coords <- Dr %*% sv$u[, 1:2] * rep(sv$d[1:2], each = nrow(tbl))
    col_coords <- Dc %*% sv$v[, 1:2] * rep(sv$d[1:2], each = ncol(tbl))
    rownames(row_coords) <- rownames(tbl)
    rownames(col_coords) <- colnames(tbl)

    inertia <- sv$d^2
    total_inertia <- sum(inertia)
    ndim <- min(length(inertia), 5)

    ca_data(list(row_coords = row_coords, col_coords = col_coords,
                 inertia = inertia[seq_len(ndim)],
                 total_inertia = total_inertia))
    })
  })

  output$ca_biplot <- renderPlotly({
    res <- ca_data()
    req(res)
    rc <- res$row_coords; cc <- res$col_coords
    pct1 <- round(res$inertia[1] / res$total_inertia * 100, 1)
    pct2 <- round(res$inertia[2] / res$total_inertia * 100, 1)

    plotly::plot_ly() |>
      plotly::add_markers(
        x = rc[, 1], y = rc[, 2],
        marker = list(color = "#3182bd", size = 10, symbol = "circle"),
        name = "Row categories",
        hoverinfo = "text",
        text = paste0(rownames(rc), "<br>Dim1 = ", round(rc[, 1], 3),
                       "<br>Dim2 = ", round(rc[, 2], 3))
      ) |>
      plotly::add_text(x = rc[, 1], y = rc[, 2],
                        text = rownames(rc),
                        textposition = "top center",
                        textfont = list(color = "#3182bd", size = 11),
                        showlegend = FALSE, hoverinfo = "skip") |>
      plotly::add_markers(
        x = cc[, 1], y = cc[, 2],
        marker = list(color = "#e31a1c", size = 10, symbol = "triangle-up"),
        name = "Column categories",
        hoverinfo = "text",
        text = paste0(rownames(cc), "<br>Dim1 = ", round(cc[, 1], 3),
                       "<br>Dim2 = ", round(cc[, 2], 3))
      ) |>
      plotly::add_text(x = cc[, 1], y = cc[, 2],
                        text = rownames(cc),
                        textposition = "bottom center",
                        textfont = list(color = "#e31a1c", size = 11),
                        showlegend = FALSE, hoverinfo = "skip") |>
      plotly::layout(
        xaxis = list(title = paste0("Dim 1 (", pct1, "%)")),
        yaxis = list(title = paste0("Dim 2 (", pct2, "%)")),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 0,
               y0 = min(c(rc[,2], cc[,2])) * 1.2, y1 = max(c(rc[,2], cc[,2])) * 1.2,
               line = list(color = "grey80", width = 1)),
          list(type = "line",
               x0 = min(c(rc[,1], cc[,1])) * 1.2, x1 = max(c(rc[,1], cc[,1])) * 1.2,
               y0 = 0, y1 = 0,
               line = list(color = "grey80", width = 1))
        ),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.12),
        margin = list(t = 30)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  output$ca_inertia <- renderTable({
    res <- ca_data(); req(res)
    pct <- res$inertia / res$total_inertia * 100
    data.frame(
      Dimension = seq_along(res$inertia),
      Inertia = round(res$inertia, 4),
      `% Explained` = round(pct, 1),
      `Cumulative %` = round(cumsum(pct), 1),
      check.names = FALSE
    )
  }, striped = TRUE, hover = TRUE, width = "100%")
  # Auto-run simulations on first load

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Dimension Reduction", list(pca_result, fa_result, fa_unrotated, mds_result, ca_data))
  })
}
