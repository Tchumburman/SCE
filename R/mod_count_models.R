# Module: Count Data Models
# 4 tabs: Poisson & NB · Zero-Inflation · Hurdle Models · Model Comparison

# ── UI ────────────────────────────────────────────────────────────────────────
count_models_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Count Data Models",
  icon = icon("hashtag"),
  navset_card_underline(

    # ── Tab 1: Poisson & Negative Binomial ────────────────────────────────────
    nav_panel(
      "Poisson & Neg. Binomial",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("cnt_lam"), "Mean \u03bb (Poisson / NB mean)", 1, 20, 5, 0.5),
          sliderInput(ns("cnt_theta"), "NB dispersion \u03b8 (larger = less overdispersion)",
                      0.2, 20, 2, 0.2),
          radioButtons(ns("cnt_dist"), "Distribution",
            choices = c("Poisson", "Negative Binomial", "Both"),
            selected = "Both"),
          tags$hr(),
          sliderInput(ns("cnt_n"), "Sample size n", 100, 1000, 400, 100),
          actionButton(ns("cnt_sim_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Poisson & Negative Binomial Regression"),
          tags$p("Count data (number of events in a fixed period/area) are non-negative integers.
                  The Poisson distribution is the natural starting point:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "P(Y = k) = e^\u207b\u03bb \u03bb\u1d4f / k!    E[Y] = Var[Y] = \u03bb"),
          tags$p("Poisson regression (GLM with log link) models log(\u03bb\u1d62) = X\u1d62\u03b2. The key
                  assumption is equidispersion: mean equals variance."),
          tags$p("In practice, count data are often ", tags$strong("overdispersed"), " — variance
                  exceeds the mean. The Negative Binomial adds a dispersion parameter \u03b8:"),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "Var[Y] = \u03bb + \u03bb\u00b2/\u03b8"),
          tags$p("As \u03b8 \u2192 \u221e, NB \u2192 Poisson. Smaller \u03b8 means more overdispersion.
                  Overdispersed data analysed with Poisson regression yields ", tags$em("underestimated"),
                  " standard errors and inflated Type I error."),
          guide = tags$ol(
            tags$li("Set \u03bb (mean count) and \u03b8 (NB dispersion)."),
            tags$li("Compare PMFs: when \u03b8 is large, NB \u2248 Poisson; small \u03b8 gives a heavier right tail."),
            tags$li("Simulate data and compare fitted Poisson vs. NB to see overdispersion diagnostics.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("PMF Comparison"),
               plotlyOutput(ns("cnt_pmf"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Simulated Data: Observed vs. Expected"),
                 plotlyOutput(ns("cnt_obs_exp"), height = "260px")),
            card(card_header("Dispersion Test"),
                 uiOutput(ns("cnt_disp_summary")))
          )
        )
      )
    ),

    # ── Tab 2: Zero-Inflated Models ───────────────────────────────────────────
    nav_panel(
      "Zero-Inflation",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("zi_lam"), "Count process mean \u03bb", 0.5, 10, 3, 0.25),
          sliderInput(ns("zi_pi"), "Zero-inflation proportion \u03c0 (structural zeros)",
                      0, 0.7, 0.3, 0.05),
          radioButtons(ns("zi_base"), "Base count distribution",
            choices = c("Poisson" = "pois", "Negative Binomial" = "nb"),
            selected = "pois", inline = TRUE),
          conditionalPanel(ns = ns, "input.zi_base == 'nb'",
            sliderInput(ns("zi_theta"), "NB dispersion \u03b8", 0.2, 10, 2, 0.2)),
          sliderInput(ns("zi_n"), "Sample size n", 100, 800, 400, 100),
          actionButton(ns("zi_go"), "Simulate & Fit", icon = icon("dice"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Zero-Inflated Models"),
          tags$p("Zero-inflated models handle excess zeros by assuming two processes:"),
          tags$ul(
            tags$li(tags$strong("Structural zeros"), " — from subjects who can never produce the event
                    (e.g., non-drinkers in an alcohol consumption study). Modelled by a binary
                    process with probability \u03c0."),
            tags$li(tags$strong("Count process zeros"), " — ordinary zero counts from subjects who
                    could have the event but happened to have none. Modelled by Poisson or NB.")
          ),
          tags$p(style = "font-family: monospace; background: rgba(0,0,0,0.05); padding: 6px; border-radius: 4px;",
            "P(Y=0) = \u03c0 + (1\u2212\u03c0) \u00d7 P_count(Y=0)\nP(Y=k) = (1\u2212\u03c0) \u00d7 P_count(Y=k),  k > 0"),
          tags$p("Zero-inflated Poisson (ZIP) and Zero-inflated NB (ZINB) use two regression
                  equations: one for the binary inflation part (logistic), one for the count part
                  (log link). The Vuong test compares ZIP/ZINB to standard Poisson/NB."),
          guide = tags$ol(
            tags$li("Set \u03c0 (structural zero rate) and \u03bb (count mean for non-zero process)."),
            tags$li("Notice how the bar at zero grows beyond what Poisson expects."),
            tags$li("Click 'Simulate & Fit' to fit standard Poisson vs. ZIP and compare."),
            tags$li("The rootogram shows fit quality: bars that dip below zero indicate lack of fit.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Observed Counts vs. Poisson vs. ZIP/ZINB Fit"),
               plotlyOutput(ns("zi_rootogram"), height = "320px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Zero Composition"), plotlyOutput(ns("zi_zero_bar"), height = "250px")),
            card(card_header("Model Comparison"), tableOutput(ns("zi_model_table")))
          )
        )
      )
    ),

    # ── Tab 3: Hurdle Models ──────────────────────────────────────────────────
    nav_panel(
      "Hurdle Models",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("hurdle_pi0"), "P(zero) — hurdle probability",
                      0.05, 0.85, 0.4, 0.05),
          sliderInput(ns("hurdle_lam"), "Positive count mean (\u03bb of truncated dist.)",
                      0.5, 10, 3, 0.25),
          sliderInput(ns("hurdle_n"), "Sample size n", 100, 800, 400, 100),
          actionButton(ns("hurdle_go"), "Simulate", icon = icon("dice"),
                       class = "btn-success w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted", style = "font-size: 0.85rem;",
            "Hurdle models treat the zero/non-zero decision separately from the positive count.
             Unlike ZIP, all zeros come from the hurdle process.")
        ),
        explanation_box(
          tags$strong("Hurdle Models"),
          tags$p("Hurdle models (also called two-part models) separate the zero/non-zero decision
                  from the positive count magnitude using two independent models:"),
          tags$ul(
            tags$li(tags$strong("Part 1 — Binary"), ": logistic regression for P(Y = 0) vs. P(Y > 0).
                    The 'hurdle' is the barrier to any positive event."),
            tags$li(tags$strong("Part 2 — Positive count"), ": a truncated Poisson or NB for
                    Y | Y > 0 (only modelling counts \u2265 1).")
          ),
          tags$p("Key contrast with ZIP:"),
          tags$ul(
            tags$li(tags$strong("ZIP"), " mixes a point mass at zero with a full count distribution;
                    structural and sampling zeros are not identifiable from a single observation."),
            tags$li(tags$strong("Hurdle"), " treats all zeros identically; the two parts can be
                    estimated independently; easier to interpret.")
          ),
          tags$p("Hurdle models are preferred when: (a) the zero / non-zero decision has a
                  clear substantive interpretation, or (b) predictors of zeros differ from
                  predictors of count magnitude."),
          guide = tags$ol(
            tags$li("Set P(zero) and the positive count mean."),
            tags$li("The histogram shows the characteristic two-part shape."),
            tags$li("The marginal distribution plot decomposes the zeros from the positive tail.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Hurdle Distribution"),
               plotlyOutput(ns("hurdle_hist"), height = "300px")),
          layout_column_wrap(
            width = 1 / 2,
            card(card_header("Two-Part Decomposition"),
                 plotlyOutput(ns("hurdle_decomp"), height = "260px")),
            card(card_header("Summary Statistics"),
                 tableOutput(ns("hurdle_summary")))
          )
        )
      )
    ),

    # ── Tab 4: Model Comparison ───────────────────────────────────────────────
    nav_panel(
      "Model Comparison",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("mc_n"), "Sample size n", 200, 1000, 500, 100),
          sliderInput(ns("mc_lam"), "True mean \u03bb", 1, 10, 4, 0.5),
          sliderInput(ns("mc_pi"), "True zero-inflation \u03c0", 0, 0.6, 0.25, 0.05),
          sliderInput(ns("mc_theta"), "True NB dispersion \u03b8", 0.5, 10, 2, 0.5),
          selectInput(ns("mc_dgp"), "Data-generating process",
            choices = c("Poisson", "NB", "ZIP", "ZINB", "Hurdle-Poisson"),
            selected = "ZIP"),
          actionButton(ns("mc_go"), "Simulate & Fit All", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Comparing Count Models"),
          tags$p("Fitting the wrong count model inflates standard errors or misses structural zeros.
                  The decision tree:"),
          tags$ul(
            tags$li(tags$strong("Poisson"), " — equidispersed counts, no excess zeros."),
            tags$li(tags$strong("NB"), " — overdispersed counts, no excess zeros."),
            tags$li(tags$strong("ZIP/ZINB"), " — excess zeros from a structural process mixed with sampling zeros."),
            tags$li(tags$strong("Hurdle"), " — all zeros from one barrier; positive counts follow a truncated distribution.")
          ),
          tags$p("Model selection tools:"),
          tags$ul(
            tags$li(tags$strong("AIC/BIC"), " — lower is better; penalises extra parameters."),
            tags$li(tags$strong("Rootogram"), " — visual fit check: perfect fit has bars at zero."),
            tags$li(tags$strong("Pearson \u03c7\u00b2 / dispersion statistic"), " — detects remaining overdispersion.")
          ),
          tags$p("The Vuong test formally compares non-nested count models (e.g., Poisson
                  vs. ZIP) by testing whether the distributions are observationally equivalent
                  given the data. A significant positive Vuong statistic favours the first
                  model; a significant negative statistic favours the second. However, the
                  test has been criticised for inflated Type I error, and it should be
                  treated as supplementary evidence alongside AIC/BIC and rootograms rather
                  than as a definitive decision rule."),
          tags$p("In practice, overdispersion in count data is extremely common, and the
                  choice between NB and zero-inflated models is often more consequential
                  than it appears. A negative binomial model absorbs excess zeros through
                  overdispersion (the NB variance \u03bb + \u03bb\u00b2/\u03b8 can produce
                  many zeros), so it is not always clear that zero-inflation is structurally
                  present. The rootogram is often the clearest diagnostic: if the NB fits
                  the zero count well but the ZIP still shows better AIC, the data likely
                  have a true structural zero process."),
          guide = tags$ol(
            tags$li("Choose a data-generating process. Each model is then fitted to the same data."),
            tags$li("The AIC/BIC table shows which model is preferred."),
            tags$li("The rootograms show where each model fails."),
            tags$li("Try ZIP data: Poisson will have terrible fit; NB partially absorbs zeros.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("AIC / BIC Comparison"),
               plotlyOutput(ns("mc_aic_plot"), height = "280px")),
          card(full_screen = TRUE,
               card_header("Rootograms: Observed vs. Each Model"),
               plotlyOutput(ns("mc_rootogram"), height = "320px"))
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

count_models_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Tab 1 ──────────────────────────────────────────────────────────────────
  cnt_sim <- eventReactive(input$cnt_sim_go, {
    set.seed(sample(9999, 1))
    n <- input$cnt_n; lam <- input$cnt_lam; th <- input$cnt_theta
    y_pois <- rpois(n, lam)
    y_nb   <- MASS::rnegbin(n, mu = lam, theta = th)
    list(y_pois = y_pois, y_nb = y_nb, lam = lam, th = th)
  })

  output$cnt_pmf <- renderPlotly({
    lam  <- input$cnt_lam
    th   <- input$cnt_theta
    dist <- input$cnt_dist
    xmax <- min(qpois(0.9999, lam * 3), 60)
    xs   <- 0:xmax
    p_pois <- dpois(xs, lam)
    p_nb   <- dnbinom(xs, mu = lam, size = th)

    p <- plot_ly()
    if (dist %in% c("Poisson", "Both"))
      p <- p |> add_bars(x = xs - 0.2, y = p_pois, name = "Poisson",
                          marker = list(color = "#268bd2", opacity = 0.8))
    if (dist %in% c("Negative Binomial", "Both"))
      p <- p |> add_bars(x = xs + 0.2, y = p_nb, name = "Neg. Binomial",
                          marker = list(color = "#cb4b16", opacity = 0.8))
    p |> layout(barmode = "overlay",
                xaxis = list(title = "Count k"),
                yaxis = list(title = "P(Y = k)"),
                title = list(text = sprintf("\u03bb = %.1f | NB \u03b8 = %.1f | Var(NB) = %.2f",
                                            lam, th, lam + lam^2 / th),
                             font = list(size = 12)))
  })

  output$cnt_obs_exp <- renderPlotly({
    req(cnt_sim())
    d    <- cnt_sim()
    y    <- d$y_nb
    lam  <- mean(y)
    th   <- tryCatch(MASS::fitdistr(y, "negative binomial")$estimate["size"],
                     error = function(e) 2)
    xmax <- min(max(y), 40)
    xs   <- 0:xmax
    obs  <- tabulate(y + 1, nbins = xmax + 1)
    n    <- length(y)
    exp_pois <- n * dpois(xs, lam)
    exp_nb   <- n * dnbinom(xs, mu = lam, size = th)

    plot_ly() |>
      add_bars(x = xs, y = obs, name = "Observed",
               marker = list(color = "rgba(101,123,131,0.5)")) |>
      add_lines(x = xs, y = exp_pois, name = "Expected (Poisson)",
                line = list(color = "#268bd2", width = 2)) |>
      add_lines(x = xs, y = exp_nb, name = "Expected (NB)",
                line = list(color = "#cb4b16", width = 2, dash = "dash")) |>
      layout(xaxis = list(title = "Count"), yaxis = list(title = "Frequency"))
  })

  output$cnt_disp_summary <- renderUI({
    req(cnt_sim())
    d <- cnt_sim()
    y <- d$y_nb
    m <- mean(y); v <- var(y)
    disp <- v / m
    mkrow <- function(l, val) tags$tr(tags$td(l), tags$td(tags$strong(val)))
    tags$table(class = "table table-sm",
      tags$tbody(
        mkrow("Sample mean", sprintf("%.3f", m)),
        mkrow("Sample variance", sprintf("%.3f", v)),
        mkrow("Dispersion ratio (Var/Mean)", sprintf("%.3f", disp)),
        mkrow("Assessment",
          if (disp < 1.1) "Approximately equidispersed"
          else if (disp < 2) "Mild overdispersion"
          else "Substantial overdispersion — use NB")
      )
    )
  })

  # ── Tab 2: Zero-Inflation ──────────────────────────────────────────────────
  zi_fit <- eventReactive(input$zi_go, {
    set.seed(sample(9999, 1))
    n   <- input$zi_n
    lam <- input$zi_lam
    pi  <- input$zi_pi
    nb  <- input$zi_base == "nb"
    th  <- if (nb) input$zi_theta else Inf

    # Simulate ZIP / ZINB
    is_zero <- rbinom(n, 1, pi)
    if (nb) {
      counts <- MASS::rnegbin(n, mu = lam, theta = th)
    } else {
      counts <- rpois(n, lam)
    }
    y <- ifelse(is_zero == 1, 0L, counts)

    # Fit Poisson
    fit_pois <- glm(y ~ 1, family = poisson)
    lam_pois <- exp(coef(fit_pois))
    exp_pois <- n * dpois(0:max(y), lam_pois)

    # Simple ZIP manual EM
    zip_em <- function(y, max_iter = 100) {
      pi_e  <- mean(y == 0) * 0.5
      lam_e <- mean(y[y > 0])
      for (iter in seq_len(max_iter)) {
        # E
        p0    <- dpois(0, lam_e)
        w_str <- pi_e / (pi_e + (1 - pi_e) * p0)
        w_str[y > 0] <- 0
        # M
        pi_e  <- mean(w_str)
        lam_e <- sum(y * (1 - w_str)) / sum(1 - w_str)
      }
      ll <- sum(log(pi_e + (1 - pi_e) * dpois(0, lam_e)) * (y == 0)) +
            sum(log((1 - pi_e) * dpois(y[y > 0], lam_e)))
      aic <- -2 * ll + 4
      list(pi = pi_e, lam = lam_e, ll = ll, aic = aic)
    }

    zip <- zip_em(y)
    xmax <- min(max(y), 30)
    xs   <- 0:xmax
    p_zip <- ifelse(xs == 0, zip$pi + (1 - zip$pi) * dpois(0, zip$lam),
                    (1 - zip$pi) * dpois(xs, zip$lam))
    exp_zip <- n * p_zip

    ll_pois <- logLik(fit_pois)[1]
    aic_pois <- AIC(fit_pois)

    list(y = y, lam = lam, pi = pi, xs = xs,
         obs = tabulate(y + 1, nbins = xmax + 1),
         exp_pois = exp_pois[seq_along(xs)],
         exp_zip  = exp_zip,
         zip = zip,
         ll_pois = ll_pois, aic_pois = aic_pois)
  })

  output$zi_rootogram <- renderPlotly({
    req(zi_fit())
    d <- zi_fit()
    plot_ly() |>
      add_bars(x = d$xs, y = sqrt(d$obs), name = "Observed (sqrt)",
               marker = list(color = "rgba(101,123,131,0.4)")) |>
      add_lines(x = d$xs, y = sqrt(d$exp_pois), name = "Poisson expected",
                line = list(color = "#dc322f", width = 2)) |>
      add_lines(x = d$xs, y = sqrt(d$exp_zip), name = "ZIP expected",
                line = list(color = "#2aa198", width = 2, dash = "dash")) |>
      layout(xaxis = list(title = "Count k"),
             yaxis = list(title = "\u221a(Frequency) — Rootogram scale"),
             title = list(text = "Rootogram (sqrt scale highlights tail fit)", font = list(size = 12)))
  })

  output$zi_zero_bar <- renderPlotly({
    req(zi_fit())
    d   <- zi_fit()
    obs_zero <- mean(d$y == 0)
    pois_zero <- dpois(0, mean(d$y))
    zip_zero  <- d$zip$pi + (1 - d$zip$pi) * dpois(0, d$zip$lam)
    plot_ly(
      x = c("Observed", "Poisson", "ZIP"),
      y = c(obs_zero, pois_zero, zip_zero),
      type = "bar",
      marker = list(color = c("#657b83","#dc322f","#2aa198"))
    ) |>
      layout(yaxis = list(title = "Proportion of zeros", range = c(0, 1)),
             xaxis = list(title = ""))
  })

  output$zi_model_table <- renderTable({
    req(zi_fit())
    d <- zi_fit()
    data.frame(
      Model = c("Poisson", "ZIP"),
      Pi    = c(NA, round(d$zip$pi, 3)),
      Lambda = c(round(exp(coef(glm(d$y ~ 1, family = poisson))), 3),
                 round(d$zip$lam, 3)),
      AIC   = c(round(d$aic_pois, 2), round(d$zip$aic, 2))
    )
  }, bordered = TRUE, striped = TRUE, na = "—")

  # ── Tab 3: Hurdle ──────────────────────────────────────────────────────────
  hurdle_data <- eventReactive(input$hurdle_go, {
    set.seed(sample(9999, 1))
    n    <- input$hurdle_n
    pi0  <- input$hurdle_pi0
    lam  <- input$hurdle_lam
    # Truncated Poisson for positives
    is_zero <- rbinom(n, 1, pi0)
    # Rejection sampling for truncated Poisson
    pos_count <- integer(sum(is_zero == 0))
    for (i in seq_along(pos_count)) {
      repeat { x <- rpois(1, lam); if (x > 0) break }
      pos_count[i] <- x
    }
    y <- integer(n)
    y[is_zero == 0] <- pos_count
    list(y = y, pi0 = pi0, lam = lam, n = n)
  })

  output$hurdle_hist <- renderPlotly({
    req(hurdle_data())
    d    <- hurdle_data()
    xmax <- min(max(d$y), 25)
    xs   <- 0:xmax
    obs  <- tabulate(d$y + 1, nbins = xmax + 1)
    plot_ly(x = xs, y = obs, type = "bar",
            marker = list(color = ifelse(xs == 0, "#dc322f", "#268bd2")),
            hovertemplate = "k=%{x}: n=%{y}<extra></extra>") |>
      layout(xaxis = list(title = "Count k"),
             yaxis = list(title = "Frequency"),
             title = list(text = sprintf("Hurdle: P(zero)=%.2f, positive mean=%.2f",
                                         d$pi0, d$lam),
                          font = list(size = 12)))
  })

  output$hurdle_decomp <- renderPlotly({
    req(hurdle_data())
    d  <- hurdle_data()
    n0 <- sum(d$y == 0); npos <- sum(d$y > 0)
    plot_ly(
      labels = c("Structural Zeros", "Positive Counts"),
      values = c(n0, npos),
      type   = "pie",
      marker = list(colors = c("#dc322f", "#268bd2")),
      textinfo = "label+percent"
    ) |> layout(showlegend = FALSE)
  })

  output$hurdle_summary <- renderTable({
    req(hurdle_data())
    d <- hurdle_data()
    y <- d$y
    data.frame(
      Statistic = c("n", "n zeros", "P(zero)", "Mean (all)", "Mean (Y>0)", "Variance"),
      Value = c(
        length(y),
        sum(y == 0),
        round(mean(y == 0), 3),
        round(mean(y), 3),
        round(mean(y[y > 0]), 3),
        round(var(y), 3)
      )
    )
  }, bordered = TRUE, striped = TRUE)

  # ── Tab 4: Model Comparison ────────────────────────────────────────────────
  mc_fits <- eventReactive(input$mc_go, {
    withProgress(message = "Fitting count models...", {
      set.seed(sample(9999, 1))
      n   <- input$mc_n; lam <- input$mc_lam
      pi  <- input$mc_pi; th  <- input$mc_theta
      dgp <- input$mc_dgp

      # Simulate from chosen DGP
      y <- switch(dgp,
        "Poisson" = rpois(n, lam),
        "NB"      = MASS::rnegbin(n, mu = lam, theta = th),
        "ZIP"     = {
          iz <- rbinom(n, 1, pi); ys <- rpois(n, lam); ifelse(iz, 0L, ys)
        },
        "ZINB"    = {
          iz <- rbinom(n, 1, pi); ys <- MASS::rnegbin(n, mu = lam, theta = th); ifelse(iz, 0L, ys)
        },
        "Hurdle-Poisson" = {
          iz <- rbinom(n, 1, pi)
          pos <- integer(n)
          for (i in which(iz == 0)) { repeat { x <- rpois(1, lam); if (x > 0) break }; pos[i] <- x }
          pos
        }
      )

      # Fit Poisson
      incProgress(0.2)
      fit_p  <- glm(y ~ 1, family = poisson)
      aic_p  <- AIC(fit_p); bic_p <- BIC(fit_p)

      # Fit NB
      incProgress(0.2)
      fit_nb <- tryCatch(MASS::glm.nb(y ~ 1), error = function(e) NULL)
      aic_nb <- if (!is.null(fit_nb)) AIC(fit_nb) else NA
      bic_nb <- if (!is.null(fit_nb)) BIC(fit_nb) else NA

      incProgress(0.6)

      # Expected counts under each model
      xmax <- min(max(y), 30)
      xs   <- 0:xmax
      obs  <- tabulate(y + 1, nbins = xmax + 1)

      lam_p  <- exp(coef(fit_p)[1])
      exp_p  <- n * dpois(xs, lam_p)
      exp_nb <- if (!is.null(fit_nb)) {
        mu_nb <- exp(coef(fit_nb)[1])
        th_nb <- fit_nb$theta
        n * dnbinom(xs, mu = mu_nb, size = th_nb)
      } else rep(NA, length(xs))

      list(
        y = y, xs = xs, obs = obs,
        exp_p = exp_p, exp_nb = exp_nb,
        results = data.frame(
          Model = c("Poisson", "Neg. Binomial"),
          AIC   = round(c(aic_p, aic_nb), 2),
          BIC   = round(c(bic_p, bic_nb), 2)
        )
      )
    })
  })

  output$mc_aic_plot <- renderPlotly({
    req(mc_fits())
    df <- mc_fits()$results
    df <- df[!is.na(df$AIC), ]
    plot_ly() |>
      add_bars(x = df$Model, y = df$AIC,
               name = "AIC", marker = list(color = "#268bd2")) |>
      add_bars(x = df$Model, y = df$BIC,
               name = "BIC", marker = list(color = "#cb4b16", opacity = 0.7)) |>
      layout(barmode = "group",
             yaxis = list(title = "Information Criterion (lower = better)"),
             xaxis = list(title = ""))
  })

  output$mc_rootogram <- renderPlotly({
    req(mc_fits())
    d <- mc_fits()
    plot_ly() |>
      add_bars(x = d$xs, y = sqrt(d$obs), name = "Observed (sqrt)",
               marker = list(color = "rgba(101,123,131,0.4)")) |>
      add_lines(x = d$xs, y = sqrt(d$exp_p), name = "Poisson",
                line = list(color = "#dc322f", width = 2)) |>
      add_lines(x = d$xs, y = sqrt(d$exp_nb), name = "Neg. Binomial",
                line = list(color = "#268bd2", width = 2, dash = "dash")) |>
      layout(xaxis = list(title = "Count k"),
             yaxis = list(title = "\u221a(Frequency)"))
  })
  })
}
