
# ---------------------------------------------------------------------------
# Shared helpers: theme, UI components, utility functions
# ---------------------------------------------------------------------------
library(shiny)
library(bslib)
library(ggplot2)
library(plotly)

# ── Global ggplot theme with transparent backgrounds ─────────────────
theme_set(
  theme_minimal(base_size = 13) +
    theme(
      plot.background  = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent", colour = NA),
      legend.background = element_rect(fill = "transparent", colour = NA),
      legend.key        = element_rect(fill = "transparent", colour = NA)
    )
)

# ── Solarized Light theme (default) with Solarized Dark override ──────
# Solarized palette:
#   base03  #002b36   base3  #fdf6e3
#   base02  #073642   base2  #eee8d5
#   base01  #586e75   base1  #93a1a1
#   base00  #657b83   base0  #839496
#   Accents: yellow #b58900, orange #cb4b16, red #dc322f,
#            magenta #d33682, violet #6c71c4, blue #268bd2,
#            cyan #2aa198, green #859900

theme_app <- bs_theme(
  version = 5,
  bg = "#fdf6e3", fg = "#657b83",
  primary = "#268bd2", success = "#2aa198", info = "#2aa198",
  warning = "#b58900", danger = "#dc322f",
  "navbar-bg" = "#073642",
  "body-color" = "#657b83",
  "headings-color" = "#073642"
) |>
  bs_add_rules('
    /* ---- Solarized Dark overrides via Bootstrap 5 color-mode ---- */
    [data-bs-theme="dark"] {
      --bs-body-bg: #002b36;
      --bs-body-color: #839496;
      --bs-emphasis-color: #fdf6e3;
      --bs-secondary-bg: #073642;
      --bs-tertiary-bg: #073642;

      --bs-primary-rgb: 38, 139, 210;
      --bs-link-color-rgb: 38, 139, 210;
      --bs-link-hover-color-rgb: 108, 113, 196;

      --bs-card-bg: #073642;
      --bs-card-border-color: rgba(147, 161, 161, 0.20);
      --bs-card-cap-bg: #073642;
    }

    /* navbar */
    [data-bs-theme="dark"] .navbar { background-color: #073642 !important; }

    /* sidebar */
    [data-bs-theme="dark"] .sidebar { background-color: #073642 !important; color: #839496 !important; }
    [data-bs-theme="dark"] .sidebar .form-label,
    [data-bs-theme="dark"] .sidebar label { color: #93a1a1 !important; }

    /* form controls */
    [data-bs-theme="dark"] .form-control,
    [data-bs-theme="dark"] .form-select {
      background-color: #002b36 !important;
      color: #839496 !important;
      border-color: rgba(147, 161, 161, 0.25) !important;
    }

    /* accordions */
    [data-bs-theme="dark"] .accordion-button {
      background-color: #073642 !important;
      color: #93a1a1 !important;
    }
    [data-bs-theme="dark"] .accordion-button:not(.collapsed) {
      background-color: rgba(38, 139, 210, 0.15) !important;
      color: #268bd2 !important;
    }
    [data-bs-theme="dark"] .accordion-body { background-color: #073642; }

    /* cards (explanation box) */
    [data-bs-theme="dark"] .border-info { border-color: rgba(42, 161, 152, 0.40) !important; }

    /* buttons */
    [data-bs-theme="dark"] .btn-success {
      background-color: #2aa198 !important;
      border-color: #2aa198 !important;
    }

    /* text helpers */
    [data-bs-theme="dark"] .text-muted { color: #586e75 !important; }
    [data-bs-theme="dark"] .lead { color: #93a1a1; }

    /* sliders */
    [data-bs-theme="dark"] .irs--shiny .irs-bar { background: #2aa198; }
    [data-bs-theme="dark"] .irs--shiny .irs-single { background: #268bd2; }

    /* dropdown menus */
    [data-bs-theme="dark"] .dropdown-menu {
      background-color: #073642 !important;
      border-color: rgba(147, 161, 161, 0.20) !important;
    }
    [data-bs-theme="dark"] .dropdown-item { color: #839496 !important; }
    [data-bs-theme="dark"] .dropdown-item:hover,
    [data-bs-theme="dark"] .dropdown-item:focus {
      background-color: rgba(38, 139, 210, 0.18) !important;
      color: #268bd2 !important;
    }

    /* code / verbatim output */
    [data-bs-theme="dark"] pre,
    [data-bs-theme="dark"] code {
      background-color: #002b36 !important;
      color: #2aa198 !important;
    }

    [data-bs-theme="dark"] hr { border-color: rgba(147, 161, 161, 0.20); }
  ')

# Clickable card for welcome page — navigates to a tab on click
nav_card <- function(icon_name, title, description, target) {
  tags$div(
    style = "cursor: pointer;",
    onclick = sprintf(
      "Shiny.setInputValue('go_to_page', '%s', {priority: 'event'}); setTimeout(function(){ document.querySelectorAll('.dropdown-menu.show').forEach(function(m){ m.classList.remove('show'); m.parentElement.querySelector('.dropdown-toggle').classList.remove('show'); m.parentElement.querySelector('.dropdown-toggle').setAttribute('aria-expanded','false'); }); window.scrollTo(0, 0); var tp = document.querySelector('.tab-pane.active'); if(tp) tp.scrollTop = 0; }, 150);",
      target
    ),
    card(
      class = "h-100 nav-card-hover",
      card_header(tagList(icon(icon_name), paste0(" ", title))),
      card_body(description)
    )
  )
}

# Explanation box with optional collapsible guide

explanation_box <- function(..., guide = NULL) {
  guide_el <- if (!is.null(guide)) {
    accordion(
      class = "mt-2",
      open = FALSE,
      accordion_panel(
        title = tagList(icon("circle-question"), " Step-by-step guide"),
        value = "guide",
        guide
      )
    )
  }

  # Extract the title from the first argument (tags$strong) for the header
  dots <- list(...)
  title_el <- if (length(dots) > 0 &&
                  inherits(dots[[1]], "shiny.tag") &&
                  dots[[1]]$name == "strong") {
    dots[[1]]
  } else {
    tags$strong("Explanation")
  }

  accordion(
    class = "border-info mb-3",
    open = FALSE,
    accordion_panel(
      title = tagList(icon("circle-info"), " ", title_el),
      value = "explanation",
      div(
        style = "font-size: 0.95rem;",
        tagList(dots[-1]),
        guide_el
      )
    )
  )
}

# Format lmer model summary as HTML tables
fmt_lmer_html <- function(fit) {
  s <- summary(fit)

  # Fixed effects table
  fe <- as.data.frame(s$coefficients)
  fe_rows <- vapply(seq_len(nrow(fe)), function(i) {
    est <- fe[i, "Estimate"]
    se  <- fe[i, "Std. Error"]
    tv  <- fe[i, "t value"]
    sprintf(
      "<tr><td>%s</td><td>%.3f</td><td>%.3f</td><td>%.2f</td></tr>",
      rownames(fe)[i], est, se, tv
    )
  }, character(1))

  fe_html <- paste0(
    '<div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">Fixed Effects</div>',
    '<table class="table table-sm table-striped mb-3" style="font-size: 0.9rem;">',
    "<thead><tr><th>Term</th><th>Estimate</th><th>SE</th><th>t</th></tr></thead>",
    "<tbody>", paste(fe_rows, collapse = ""), "</tbody></table>"
  )

  # Random effects table
  vc <- as.data.frame(lme4::VarCorr(fit))
  re_rows <- vapply(seq_len(nrow(vc)), function(i) {
    grp  <- vc$grp[i]
    var1 <- if (is.na(vc$var1[i])) "" else vc$var1[i]
    var2 <- if (is.na(vc$var2[i])) "" else vc$var2[i]
    vari <- vc$vcov[i]
    sdev <- vc$sdcor[i]
    label <- if (grp == "Residual") "Residual"
             else if (nchar(var2) > 0) paste0(grp, ": Corr(", var1, ", ", var2, ")")
             else if (nchar(var1) > 0) paste0(grp, ": ", var1)
             else grp
    sprintf(
      "<tr><td>%s</td><td>%.4f</td><td>%.4f</td></tr>",
      label, vari, sdev
    )
  }, character(1))

  re_html <- paste0(
    '<div class="fw-bold mb-1" style="color: var(--bs-emphasis-color);">Random Effects</div>',
    '<table class="table table-sm table-striped mb-3" style="font-size: 0.9rem;">',
    "<thead><tr><th>Group / Term</th><th>Variance</th><th>Std. Dev.</th></tr></thead>",
    "<tbody>", paste(re_rows, collapse = ""), "</tbody></table>"
  )

  # Model info
  n_obs <- nrow(s$residuals %||% fit@frame)
  grps <- paste(
    vapply(names(s$ngrps), function(g) sprintf("%s: %d", g, s$ngrps[g]), character(1)),
    collapse = " | "
  )
  info_html <- sprintf(
    '<small class="text-muted">Observations: %d | Groups: %s</small>',
    n_obs, grps
  )

  paste0('<div style="padding: 0.5rem;">', fe_html, re_html, info_html, "</div>")
}

# Population sampler for CLT and Sample Size Effect pages
rpop <- function(n, dist) {
  switch(dist,
    "Normal"                = rnorm(n, 10, 3),
    "Uniform"               = runif(n, 0, 20),
    "Exponential"           = rexp(n, rate = 0.2),
    "Right-skewed (Gamma)"  = rgamma(n, shape = 2, rate = 0.5),
    rnorm(n)
  )
}
