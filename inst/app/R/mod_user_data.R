# ===========================================================================
# Module: User Data Upload — Upload CSV, explore, and run basic analyses
# ===========================================================================

# ── UI ──────────────────────────────────────────────────────────────────
user_data_ui <- function(id) {
  ns <- NS(id)
  nav_panel_hidden(
  value = "Your Data",
  navset_card_underline(

    # ── Tab 1: Upload & Preview ─────────────────────────────────────────
    nav_panel(
      "Upload & Preview",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          fileInput(ns("ud_file"), "Upload CSV / TSV / Excel file",
                    accept = c(".csv", ".tsv", ".txt", ".xlsx", ".xls")),
          checkboxInput(ns("ud_header"), "First row is header", value = TRUE),
          conditionalPanel(ns = ns, 
            "output.ud_is_csv",
            selectInput(ns("ud_sep"), "Separator",
                        choices = c("Comma" = ",", "Semicolon" = ";",
                                    "Tab" = "\t", "Space" = " "),
                        selected = ","),
            selectInput(ns("ud_dec"), "Decimal mark",
                        choices = c("Period (.)" = ".", "Comma (,)" = ","),
                        selected = ".")
          ),
          conditionalPanel(ns = ns, 
            "!output.ud_is_csv",
            uiOutput(ns("ud_sheet_select"))
          ),
          tags$hr(),
          uiOutput(ns("ud_dim_info")),
          tags$hr(),
          downloadButton(ns("ud_download_clean"), "Download cleaned data",
                         class = "btn-outline-success w-100")
        ),
        explanation_box(
          tags$strong("Upload Your Own Data"),
          tags$p("Upload a CSV, TSV, or Excel file to explore it interactively. The app will
                  detect column types automatically and provide summaries, visualizations,
                  and basic statistical tests."),
          tags$p("Supported formats: comma-separated (.csv), semicolon-separated,
                  tab-separated (.tsv/.txt), and Excel (.xlsx/.xls). For Excel files, you
                  can select which sheet to import. The file should have one row per observation
                  and one column per variable."),
          tags$p(tags$strong("Privacy note:"), " Your data stays in your browser session
                  and is never uploaded to any external server. It is discarded when you
                  close the app or upload a new file."),
          guide = tags$ol(
            tags$li("Click 'Browse' and select a CSV or TSV file from your computer."),
            tags$li("Adjust separator and header settings if needed."),
            tags$li("Preview the first rows and check that columns were parsed correctly."),
            tags$li("Navigate to the other tabs to explore, visualize, or test your data.")
          )
        ),
        card(
          full_screen = TRUE,
          card_header("Data Preview (first 100 rows)"),
          div(style = "overflow-x: auto;", tableOutput(ns("ud_preview")))
        )
      )
    ),

    # ── Tab 2: Summary ──────────────────────────────────────────────────
    nav_panel(
      "Summary",
      layout_sidebar(
        sidebar = sidebar(
          width = 280,
          uiOutput(ns("ud_summary_col_select")),
          tags$hr(),
          tags$small(class = "text-muted",
            "Select columns to include in the summary. Numeric columns get
             descriptive statistics; categorical columns get frequency counts.")
        ),
        card(
          full_screen = TRUE,
          card_header("Descriptive Statistics"),
          div(style = "overflow-x: auto;", tableOutput(ns("ud_desc_stats")))
        ),
        card(
          full_screen = TRUE,
          card_header("Missing Values"),
          plotly::plotlyOutput(ns("ud_missing_plot"), height = "300px")
        )
      )
    ),

    # ── Tab 3: Visualize ────────────────────────────────────────────────
    nav_panel(
      "Visualize",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("ud_plot_type"), "Plot type",
            choices = c("Histogram", "Boxplot", "Scatter", "Bar chart",
                        "Correlation matrix")),
          uiOutput(ns("ud_viz_controls")),
          actionButton(ns("ud_plot_go"), "Update plot", class = "btn-success w-100")
        ),
        card(
          full_screen = TRUE,
          card_header("Visualization"),
          plotly::plotlyOutput(ns("ud_viz_plot"), height = "500px")
        )
      )
    ),

    # ── Tab 4: Quick Test ───────────────────────────────────────────────
    nav_panel(
      "Quick Test",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("ud_test_type"), "Test",
            choices = c("T-test (2 groups)" = "ttest",
                        "Wilcoxon rank-sum" = "wilcox",
                        "One-way ANOVA" = "anova",
                        "Correlation" = "cor",
                        "Chi-square test" = "chisq",
                        "Cohen's Kappa" = "kappa")),
          uiOutput(ns("ud_test_controls")),
          actionButton(ns("ud_test_go"), "Run test", class = "btn-success w-100")
        ),
        explanation_box(
          tags$strong("Quick Statistical Tests"),
          tags$p("Run common statistical tests on your uploaded data. Select the
                  appropriate test, choose the relevant columns, and review the results."),
          tags$p("These are exploratory analyses \u2014 results should be interpreted
                  with caution, especially if you run many tests on the same dataset
                  (multiple comparisons problem)."),
          tags$p("Before running any test, consider whether its assumptions are met. The
                  t-test assumes approximately normal sampling distributions and independent
                  observations. The chi-square test requires expected cell counts of at least 5.
                  Correlation tests assume bivariate relationships. Violating these assumptions
                  may invalidate the results."),
          tags$p("If you need more rigorous analysis, consider using the full R environment to
                  fit models with proper diagnostics. These quick tests are designed for initial
                  exploration and hypothesis generation, not for final reporting or publication.")
        ),
        card(
          full_screen = TRUE,
          card_header("Test Results"),
          uiOutput(ns("ud_test_result"))
        )
      )
    )
  )
)

# ── Server ──────────────────────────────────────────────────────────────
}

user_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # Reactive: parsed user data
  ud <- reactiveVal(NULL)
  ud_file_ext <- reactiveVal("csv")

  # Track whether the file is CSV-type (for conditional panel)
  output$ud_is_csv <- reactive({
    ext <- ud_file_ext()
    ext %in% c("csv", "tsv", "txt", "")
  })
  outputOptions(output, "ud_is_csv", suspendWhenHidden = FALSE)

  # When file is selected, detect extension
  observeEvent(input$ud_file, {
    req(input$ud_file)
    ext <- tolower(tools::file_ext(input$ud_file$name))
    ud_file_ext(ext)

    if (ext %in% c("xlsx", "xls")) {
      # For Excel, defer loading until sheet is selected (or load sheet 1)
      tryCatch({
        sheets <- readxl::excel_sheets(input$ud_file$datapath)
        ud_excel_sheets(sheets)
        # Auto-load first sheet
        df <- readxl::read_excel(input$ud_file$datapath, sheet = 1,
                                 col_names = input$ud_header)
        ud(as.data.frame(df))
      }, error = function(e) {
        showNotification(paste("Error reading Excel file:", e$message),
                         type = "error", duration = 8)
      })
    } else {
      ud_excel_sheets(NULL)
      tryCatch({
        df <- read.csv(input$ud_file$datapath,
                       header = input$ud_header,
                       sep = input$ud_sep,
                       dec = input$ud_dec,
                       stringsAsFactors = FALSE,
                       check.names = TRUE)
        ud(df)
      }, error = function(e) {
        showNotification(paste("Error reading file:", e$message),
                         type = "error", duration = 8)
      })
    }
  })

  # Excel sheet selection
  ud_excel_sheets <- reactiveVal(NULL)

  output$ud_sheet_select <- renderUI({
    sheets <- ud_excel_sheets()
    req(sheets)
    selectInput(session$ns("ud_sheet"), "Excel sheet", choices = sheets, selected = sheets[1])
  })

  observeEvent(input$ud_sheet, {
    req(input$ud_file)
    ext <- ud_file_ext()
    if (ext %in% c("xlsx", "xls")) {
      tryCatch({
        df <- readxl::read_excel(input$ud_file$datapath, sheet = input$ud_sheet,
                                 col_names = input$ud_header)
        ud(as.data.frame(df))
      }, error = function(e) {
        showNotification(paste("Error reading sheet:", e$message),
                         type = "error", duration = 8)
      })
    }
  })

  # --- Helpers ---
  ud_numeric_cols <- reactive({
    df <- ud(); req(df)
    names(df)[sapply(df, is.numeric)]
  })

  ud_cat_cols <- reactive({
    df <- ud(); req(df)
    names(df)[!sapply(df, is.numeric)]
  })

  ud_all_cols <- reactive({
    df <- ud(); req(df)
    names(df)
  })

  # ── Upload & Preview ────────────────────────────────────────────────

  output$ud_dim_info <- renderUI({
    df <- ud()
    if (is.null(df)) return(tags$p(class = "text-muted", "No data loaded."))
    n_num <- sum(sapply(df, is.numeric))
    n_cat <- ncol(df) - n_num
    div(
      tags$p(tags$strong(format(nrow(df), big.mark = ",")), " rows \u00d7 ",
             tags$strong(ncol(df)), " columns"),
      tags$p(class = "text-muted mb-0",
             n_num, " numeric, ", n_cat, " categorical")
    )
  })

  output$ud_preview <- renderTable({
    df <- ud(); req(df)
    head(df, 100)
  }, hover = TRUE, spacing = "s", striped = TRUE)

  output$ud_download_clean <- downloadHandler(
    filename = function() {
      paste0("cleaned_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      df <- ud(); req(df)
      write.csv(df, file, row.names = FALSE)
    }
  )

  # ── Summary ─────────────────────────────────────────────────────────

  output$ud_summary_col_select <- renderUI({
    cols <- ud_all_cols()
    req(cols)
    checkboxGroupInput(session$ns("ud_summary_cols"), "Columns to summarize",
                       choices = cols, selected = cols[seq_len(min(10, length(cols)))])
  })

  output$ud_desc_stats <- renderTable({
    df <- ud(); req(df)
    cols <- input$ud_summary_cols
    req(cols)
    df <- df[, cols, drop = FALSE]

    num_cols <- names(df)[sapply(df, is.numeric)]
    if (length(num_cols) == 0) return(data.frame(Message = "No numeric columns selected."))

    do.call(rbind, lapply(num_cols, function(col) {
      x <- df[[col]]
      data.frame(
        Variable = col,
        N = sum(!is.na(x)),
        Missing = sum(is.na(x)),
        Mean = round(mean(x, na.rm = TRUE), 3),
        SD = round(sd(x, na.rm = TRUE), 3),
        Min = round(min(x, na.rm = TRUE), 3),
        Q1 = round(quantile(x, 0.25, na.rm = TRUE), 3),
        Median = round(median(x, na.rm = TRUE), 3),
        Q3 = round(quantile(x, 0.75, na.rm = TRUE), 3),
        Max = round(max(x, na.rm = TRUE), 3),
        Skewness = round(
          mean(((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))^3, na.rm = TRUE), 3),
        check.names = FALSE
      )
    }))
  }, hover = TRUE, spacing = "s", striped = TRUE)

  output$ud_missing_plot <- renderPlotly({
    df <- ud(); req(df)
    cols <- input$ud_summary_cols
    req(cols)
    df <- df[, cols, drop = FALSE]

    miss <- sapply(df, function(x) sum(is.na(x)))
    miss_pct <- round(miss / nrow(df) * 100, 1)
    col_names <- names(miss)

    cols_color <- ifelse(miss == 0, "#238b45", "#e31a1c")

    plotly::plot_ly() |>
      plotly::add_bars(
        y = col_names, x = miss_pct, orientation = "h",
        marker = list(color = cols_color, line = list(color = "white", width = 0.5)),
        text = paste0(miss, " (", miss_pct, "%)"),
        textposition = "auto",
        hovertemplate = "%{y}: %{x:.1f}% missing<extra></extra>",
        showlegend = FALSE
      ) |>
      plotly::layout(
        xaxis = list(title = "% Missing", range = c(0, max(105, max(miss_pct) * 1.1))),
        yaxis = list(title = "", categoryorder = "trace"),
        margin = list(l = 120, t = 10)
      ) |> plotly::config(displayModeBar = FALSE)
  })

  # ── Visualize ───────────────────────────────────────────────────────

  output$ud_viz_controls <- renderUI({
    df <- ud()
    if (is.null(df)) return(tags$p(class = "text-muted", "Upload data first."))

    num <- ud_numeric_cols()
    cat <- ud_cat_cols()
    all <- ud_all_cols()
    pt <- input$ud_plot_type

    controls <- list()

    if (pt == "Histogram") {
      controls <- list(
        selectInput(session$ns("ud_viz_x"), "Variable", choices = num),
        sliderInput(session$ns("ud_viz_bins"), "Bins", min = 5, max = 100, value = 30),
        if (length(cat) > 0)
          selectInput(session$ns("ud_viz_color"), "Color by (optional)",
                      choices = c("(none)" = "", cat))
      )
    } else if (pt == "Boxplot") {
      controls <- list(
        selectInput(session$ns("ud_viz_y"), "Numeric variable", choices = num),
        selectInput(session$ns("ud_viz_group"), "Group by",
                    choices = c("(none)" = "", cat, num))
      )
    } else if (pt == "Scatter") {
      controls <- list(
        selectInput(session$ns("ud_viz_x"), "X variable", choices = num),
        selectInput(session$ns("ud_viz_y"), "Y variable",
                    choices = if (length(num) > 1) num[2:length(num)] else num),
        if (length(cat) > 0)
          selectInput(session$ns("ud_viz_color"), "Color by (optional)",
                      choices = c("(none)" = "", cat))
      )
    } else if (pt == "Bar chart") {
      controls <- list(
        selectInput(session$ns("ud_viz_x"), "Categorical variable", choices = c(cat, num)),
        selectInput(session$ns("ud_viz_color"), "Group by (optional)",
                    choices = c("(none)" = "", cat, num))
      )
    } else if (pt == "Correlation matrix") {
      controls <- list(
        tags$p(class = "text-muted", "Shows correlations among all numeric variables.")
      )
    }

    tagList(controls)
  })

  output$ud_viz_plot <- renderPlotly({
    df <- ud()
    input$ud_plot_go
    req(df)

    isolate({
      pt <- input$ud_plot_type
      num <- ud_numeric_cols()

      if (pt == "Histogram") {
        x_var <- input$ud_viz_x
        req(x_var)
        color_var <- input$ud_viz_color
        if (!is.null(color_var) && color_var != "") {
          p <- plotly::plot_ly(df, x = as.formula(paste0("~`", x_var, "`")),
                               color = as.formula(paste0("~factor(`", color_var, "`)")),
                               type = "histogram", nbinsx = input$ud_viz_bins,
                               opacity = 0.7) |>
            plotly::layout(barmode = "overlay")
        } else {
          p <- plotly::plot_ly(df, x = as.formula(paste0("~`", x_var, "`")),
                               type = "histogram", nbinsx = input$ud_viz_bins,
                               marker = list(color = "rgba(35,139,69,0.7)",
                                             line = list(color = "white", width = 0.5)))
        }
        p |> plotly::layout(
          xaxis = list(title = x_var), yaxis = list(title = "Count"),
          margin = list(t = 20)
        ) |> plotly::config(displayModeBar = FALSE)

      } else if (pt == "Boxplot") {
        y_var <- input$ud_viz_y
        req(y_var)
        group_var <- input$ud_viz_group

        if (!is.null(group_var) && group_var != "") {
          plotly::plot_ly(df,
            y = as.formula(paste0("~`", y_var, "`")),
            x = as.formula(paste0("~factor(`", group_var, "`)")),
            type = "box", color = as.formula(paste0("~factor(`", group_var, "`)")),
            boxpoints = "outliers"
          ) |> plotly::layout(
            xaxis = list(title = group_var), yaxis = list(title = y_var),
            showlegend = FALSE, margin = list(t = 20)
          ) |> plotly::config(displayModeBar = FALSE)
        } else {
          plotly::plot_ly(df,
            y = as.formula(paste0("~`", y_var, "`")),
            type = "box", boxpoints = "outliers",
            marker = list(color = "#238b45"),
            line = list(color = "#238b45")
          ) |> plotly::layout(
            yaxis = list(title = y_var), margin = list(t = 20)
          ) |> plotly::config(displayModeBar = FALSE)
        }

      } else if (pt == "Scatter") {
        x_var <- input$ud_viz_x
        y_var <- input$ud_viz_y
        req(x_var, y_var)
        color_var <- input$ud_viz_color

        if (!is.null(color_var) && color_var != "") {
          plotly::plot_ly(df,
            x = as.formula(paste0("~`", x_var, "`")),
            y = as.formula(paste0("~`", y_var, "`")),
            color = as.formula(paste0("~factor(`", color_var, "`)")),
            type = "scatter", mode = "markers",
            marker = list(size = 5, opacity = 0.7)
          )
        } else {
          plotly::plot_ly(df,
            x = as.formula(paste0("~`", x_var, "`")),
            y = as.formula(paste0("~`", y_var, "`")),
            type = "scatter", mode = "markers",
            marker = list(color = "#238b45", size = 5, opacity = 0.7)
          )
        } |> plotly::layout(
          xaxis = list(title = x_var), yaxis = list(title = y_var),
          margin = list(t = 20)
        ) |> plotly::config(displayModeBar = FALSE)

      } else if (pt == "Bar chart") {
        x_var <- input$ud_viz_x
        req(x_var)
        color_var <- input$ud_viz_color

        if (!is.null(color_var) && color_var != "") {
          counts <- as.data.frame(table(df[[x_var]], df[[color_var]]),
                                  stringsAsFactors = FALSE)
          names(counts) <- c("x", "group", "count")
          plotly::plot_ly(counts, x = ~x, y = ~count, color = ~group,
                          type = "bar") |>
            plotly::layout(barmode = "group",
              xaxis = list(title = x_var), yaxis = list(title = "Count"),
              margin = list(t = 20)
            ) |> plotly::config(displayModeBar = FALSE)
        } else {
          counts <- as.data.frame(table(df[[x_var]]), stringsAsFactors = FALSE)
          names(counts) <- c("x", "count")
          plotly::plot_ly(counts, x = ~x, y = ~count, type = "bar",
                          marker = list(color = "#238b45")) |>
            plotly::layout(
              xaxis = list(title = x_var), yaxis = list(title = "Count"),
              margin = list(t = 20)
            ) |> plotly::config(displayModeBar = FALSE)
        }

      } else if (pt == "Correlation matrix") {
        req(length(num) >= 2)
        num_df <- df[, num, drop = FALSE]
        cor_mat <- cor(num_df, use = "pairwise.complete.obs")

        plotly::plot_ly(
          x = colnames(cor_mat), y = rownames(cor_mat),
          z = cor_mat, type = "heatmap", xgap = 2, ygap = 2,
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
          text = round(cor_mat, 2), texttemplate = "%{text}",
          hovertemplate = "%{x} vs %{y}<br>r = %{z:.3f}<extra></extra>"
        ) |> plotly::layout(
          xaxis = list(title = "", tickangle = -45),
          yaxis = list(title = "", autorange = "reversed"),
          margin = list(l = 100, b = 100, t = 20)
        ) |> plotly::config(displayModeBar = FALSE)
      }
    })
  })

  # ── Quick Test ──────────────────────────────────────────────────────

  output$ud_test_controls <- renderUI({
    df <- ud()
    if (is.null(df)) return(tags$p(class = "text-muted", "Upload data first."))

    num <- ud_numeric_cols()
    cat <- ud_cat_cols()
    all <- ud_all_cols()
    test <- input$ud_test_type

    if (test == "ttest" || test == "wilcox") {
      tagList(
        selectInput(session$ns("ud_test_outcome"), "Numeric outcome", choices = num),
        selectInput(session$ns("ud_test_group"), "Grouping variable (2 levels)", choices = c(cat, num))
      )
    } else if (test == "anova") {
      tagList(
        selectInput(session$ns("ud_test_outcome"), "Numeric outcome", choices = num),
        selectInput(session$ns("ud_test_group"), "Grouping variable", choices = c(cat, num))
      )
    } else if (test == "cor") {
      tagList(
        selectInput(session$ns("ud_test_x"), "Variable X", choices = num),
        selectInput(session$ns("ud_test_y"), "Variable Y",
                    choices = if (length(num) > 1) num[2:length(num)] else num),
        selectInput(session$ns("ud_test_cor_method"), "Method",
                    choices = c("Pearson" = "pearson", "Spearman" = "spearman",
                                "Kendall" = "kendall"))
      )
    } else if (test == "chisq") {
      tagList(
        selectInput(session$ns("ud_test_x"), "Variable 1", choices = c(cat, num)),
        selectInput(session$ns("ud_test_y"), "Variable 2", choices = c(cat, num))
      )
    } else if (test == "kappa") {
      tagList(
        selectInput(session$ns("ud_test_rater1"), "Rater 1 column", choices = c(cat, num)),
        selectInput(session$ns("ud_test_rater2"), "Rater 2 column", choices = c(cat, num)),
        tags$small(class = "text-muted",
          "Both columns must use the same category labels.")
      )
    }
  })

  output$ud_test_result <- renderUI({
    input$ud_test_go
    df <- ud()
    req(df)

    isolate({
      test <- input$ud_test_type

      tryCatch({
        if (test == "ttest") {
          outcome <- input$ud_test_outcome
          group <- input$ud_test_group
          req(outcome, group)
          grp <- factor(df[[group]])
          if (nlevels(grp) != 2) {
            return(div(class = "alert alert-warning",
              "T-test requires exactly 2 groups. Found ", nlevels(grp), " levels in '", group, "'."
            ))
          }
          vals <- split(df[[outcome]], grp)
          res <- t.test(vals[[1]], vals[[2]])
          sig <- if (res$p.value < 0.05) "alert-success" else "alert-secondary"
          d <- abs(diff(sapply(vals, mean, na.rm = TRUE))) /
               sqrt(mean(sapply(vals, var, na.rm = TRUE)))

          div(class = paste("alert", sig),
            tags$h5("Welch Two-Sample T-test"),
            tags$p("Groups: ", paste(levels(grp), collapse = " vs ")),
            tags$p("t = ", round(res$statistic, 3),
                   " | df = ", round(res$parameter, 1),
                   " | p = ", format.pval(res$p.value, digits = 4)),
            tags$p("95% CI for difference: [",
                   round(res$conf.int[1], 3), ", ", round(res$conf.int[2], 3), "]"),
            tags$p("Cohen's d \u2248 ", round(d, 3))
          )

        } else if (test == "wilcox") {
          outcome <- input$ud_test_outcome
          group <- input$ud_test_group
          req(outcome, group)
          grp <- factor(df[[group]])
          if (nlevels(grp) != 2) {
            return(div(class = "alert alert-warning",
              "Wilcoxon test requires exactly 2 groups. Found ", nlevels(grp), " levels."
            ))
          }
          vals <- split(df[[outcome]], grp)
          res <- suppressWarnings(wilcox.test(vals[[1]], vals[[2]]))
          sig <- if (res$p.value < 0.05) "alert-success" else "alert-secondary"
          # rank-biserial r
          n1 <- length(vals[[1]]); n2 <- length(vals[[2]])
          r_rb <- 1 - (2 * res$statistic) / (n1 * n2)

          div(class = paste("alert", sig),
            tags$h5("Wilcoxon Rank-Sum Test"),
            tags$p("Groups: ", paste(levels(grp), collapse = " vs ")),
            tags$p("W = ", round(res$statistic, 1),
                   " | p = ", format.pval(res$p.value, digits = 4)),
            tags$p("Rank-biserial r \u2248 ", round(r_rb, 3))
          )

        } else if (test == "anova") {
          outcome <- input$ud_test_outcome
          group <- input$ud_test_group
          req(outcome, group)
          form <- as.formula(paste0("`", outcome, "` ~ factor(`", group, "`)"))
          res <- summary(aov(form, data = df))[[1]]
          f_val <- res$`F value`[1]
          p_val <- res$`Pr(>F)`[1]
          sig <- if (!is.na(p_val) && p_val < 0.05) "alert-success" else "alert-secondary"
          # eta-squared
          ss_between <- res$`Sum Sq`[1]
          ss_total <- sum(res$`Sum Sq`)
          eta2 <- ss_between / ss_total

          div(class = paste("alert", sig),
            tags$h5("One-Way ANOVA"),
            tags$p("F(", res$Df[1], ", ", res$Df[2], ") = ", round(f_val, 3),
                   " | p = ", format.pval(p_val, digits = 4)),
            tags$p("\u03b7\u00b2 = ", round(eta2, 3))
          )

        } else if (test == "cor") {
          x_var <- input$ud_test_x
          y_var <- input$ud_test_y
          method <- input$ud_test_cor_method
          req(x_var, y_var)
          res <- cor.test(df[[x_var]], df[[y_var]], method = method)
          sig <- if (res$p.value < 0.05) "alert-success" else "alert-secondary"
          label <- paste0(toupper(substring(method, 1, 1)), substring(method, 2))

          ci_text <- if (!is.null(res$conf.int)) {
            paste0("95% CI: [", round(res$conf.int[1], 3), ", ",
                   round(res$conf.int[2], 3), "]")
          } else ""

          div(class = paste("alert", sig),
            tags$h5(paste(label, "Correlation")),
            tags$p("r = ", round(res$estimate, 3),
                   " | p = ", format.pval(res$p.value, digits = 4)),
            if (nchar(ci_text) > 0) tags$p(ci_text)
          )

        } else if (test == "kappa") {
          r1 <- input$ud_test_rater1
          r2 <- input$ud_test_rater2
          req(r1, r2)
          lvls <- sort(unique(c(as.character(df[[r1]]), as.character(df[[r2]]))))
          f1   <- factor(df[[r1]], levels = lvls)
          f2   <- factor(df[[r2]], levels = lvls)
          tbl  <- table(Rater1 = f1, Rater2 = f2)
          n    <- sum(tbl)
          p_o  <- sum(diag(tbl)) / n
          p_e  <- sum(rowSums(tbl) / n * colSums(tbl) / n)
          kval <- (p_o - p_e) / (1 - p_e)
          se   <- sqrt((p_o * (1 - p_o)) / (n * (1 - p_e)^2))
          ci_lo <- kval - 1.96 * se
          ci_hi <- kval + 1.96 * se
          klabel <- if (kval < 0) "Poor" else if (kval < 0.20) "Slight"
                    else if (kval < 0.40) "Fair" else if (kval < 0.60) "Moderate"
                    else if (kval < 0.80) "Substantial" else "Almost Perfect"
          sig <- if (kval >= 0.60) "alert-success" else if (kval >= 0.40) "alert-warning"
                 else "alert-secondary"
          div(class = paste("alert", sig),
            tags$h5("Cohen's \u03ba (Kappa)"),
            tags$p("\u03ba = ", tags$strong(round(kval, 3)),
                   " (", klabel, ")"),
            tags$p("95% CI: [", round(ci_lo, 3), ", ", round(ci_hi, 3), "]"),
            tags$p("Observed agreement: ", scales::percent(p_o, 0.1),
                   " | Chance agreement: ", scales::percent(p_e, 0.1)),
            tags$p("N = ", n, " | Categories: ", paste(lvls, collapse = ", "))
          )
        } else if (test == "chisq") {
          x_var <- input$ud_test_x
          y_var <- input$ud_test_y
          req(x_var, y_var)
          tbl <- table(df[[x_var]], df[[y_var]])
          res <- chisq.test(tbl)
          sig <- if (res$p.value < 0.05) "alert-success" else "alert-secondary"
          # Cramér's V
          n <- sum(tbl)
          k <- min(nrow(tbl), ncol(tbl))
          v <- sqrt(res$statistic / (n * (k - 1)))

          div(class = paste("alert", sig),
            tags$h5("Chi-Squared Test of Independence"),
            tags$p("\u03c7\u00b2(", res$parameter, ") = ", round(res$statistic, 3),
                   " | p = ", format.pval(res$p.value, digits = 4)),
            tags$p("Cram\u00e9r's V = ", round(v, 3))
          )
        }
      }, error = function(e) {
        div(class = "alert alert-danger",
          tags$strong("Error: "), e$message
        )
      })
    })
  })
  })
}
