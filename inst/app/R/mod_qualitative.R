# ===========================================================================
# Module: Text Analysis
# 5 tabs: Word Cloud · N-gram Analysis · Sentiment Analysis ·
#         Readability · Concordance (KWIC)
# Requires: wordcloud, tidytext  (textdata for AFINN lexicon)
# ===========================================================================

# ── Default example text ────────────────────────────────────────────────────
.qual_default_text <- paste(
  "Statistics is a powerful and beautiful discipline that helps us understand",
  "the world through data. It can be challenging and complex, but also deeply",
  "rewarding. Good statistical thinking allows us to make better decisions,",
  "avoid misleading conclusions, and communicate findings honestly.",
  "Poor statistics can be dangerous and deceptive. Confounded studies,",
  "p-hacking, and misinterpreted results have caused real harm in medicine,",
  "policy, and science. Yet the solution is not to abandon quantitative methods",
  "but to learn them better. With careful design, honest reporting, and",
  "appropriate skepticism, statistics remains one of our most valuable tools",
  "for learning from experience and improving human welfare.",
  "Every dataset tells a story — and statistics helps us read it faithfully.",
  "Uncertainty is not a weakness of the discipline; it is its greatest strength.",
  "Acknowledging what we do not know is the first step toward genuine discovery.",
  "Bad data and sloppy analysis produce false confidence, not knowledge.",
  "Rigorous methods, transparent reporting, and open science build trust and progress."
)

# ── Default Passage B (machine learning — contrasts with the statistics text) ─
.qual_default_text_b <- paste(
  "Machine learning algorithms discover patterns in data without explicit programming.",
  "Deep neural networks learn hierarchical feature representations through gradient descent.",
  "Overfitting occurs when a model memorises training examples rather than generalising.",
  "Cross-validation partitions data into folds to estimate out-of-sample performance.",
  "Feature engineering transforms raw inputs into representations useful for learning.",
  "Ensemble methods combine weak learners to build more accurate and robust models.",
  "Regularisation penalises model complexity to reduce variance and improve generalisation.",
  "Hyperparameter tuning searches for the configuration that minimises validation loss.",
  "Transfer learning reuses representations learned on one task to accelerate another.",
  "Evaluation on held-out test data provides an unbiased estimate of model performance."
)

# ── Minimal built-in stopword list ───────────────────────────────────────────
.qual_stopwords <- c(
  "a", "an", "the", "and", "but", "or", "for", "nor", "on", "at", "to",
  "from", "by", "with", "in", "of", "is", "are", "was", "were", "be",
  "been", "being", "have", "has", "had", "do", "does", "did", "will",
  "would", "could", "should", "may", "might", "shall", "can", "it", "its",
  "this", "that", "these", "those", "i", "me", "my", "we", "our", "you",
  "your", "he", "she", "they", "them", "not", "no", "so", "as", "if",
  "then", "than", "about", "into", "through", "also", "more", "other",
  "such", "up", "out", "all", "one", "their", "there", "which", "who",
  "what", "how", "when", "where", "why", "both", "each", "any", "just",
  "s", "t", "re", "ve", "ll", "d"
)

# ── Shared tokeniser ─────────────────────────────────────────────────────────
.qual_tokenize <- function(txt, remove_stop = TRUE) {
  words <- tolower(txt)
  words <- gsub("[^a-z ]", " ", words)
  words <- unlist(strsplit(words, "\\s+"))
  words <- words[nzchar(words)]
  if (remove_stop) words <- words[!words %in% .qual_stopwords]
  words
}

# ── Syllable counter (vowel-group heuristic) ─────────────────────────────────
.count_syllables <- function(word) {
  w <- tolower(gsub("[^a-z]", "", word))
  if (nchar(w) == 0L) return(1L)
  m <- gregexpr("[aeiou]+", w, perl = TRUE)[[1L]]
  n <- if (m[1L] == -1L) 0L else length(m)
  # subtract silent trailing 'e' (cake, more, etc.) — but not "ee", "oe"
  if (nchar(w) > 2L && grepl("e$", w) && !grepl("[aeiou]e$", w)) n <- n - 1L
  max(1L, as.integer(n))
}

# ── Sentence splitter ─────────────────────────────────────────────────────────
.count_sentences <- function(txt) {
  sents <- unlist(strsplit(txt, "[.!?]+(?=\\s|$)", perl = TRUE))
  sents <- sents[nzchar(trimws(sents))]
  max(1L, length(sents))
}

# ── Flesch Reading Ease label ─────────────────────────────────────────────────
.fre_label <- function(score) {
  if      (score >= 90) "Very Easy"
  else if (score >= 80) "Easy"
  else if (score >= 70) "Fairly Easy"
  else if (score >= 60) "Standard"
  else if (score >= 50) "Fairly Difficult"
  else if (score >= 30) "Difficult"
  else                  "Very Confusing"
}

# ── UI ────────────────────────────────────────────────────────────────────────
qualitative_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Text Analysis",
  icon = icon("file-word"),
  navset_card_underline(

    # ── Tab 1: Word Cloud ─────────────────────────────────────────────────────
    nav_panel(
      "Word Cloud",
      layout_sidebar(
        sidebar = sidebar(
          width = 290,
          tags$label("Input text", class = "form-label fw-bold"),
          textAreaInput(ns("wc_text"), NULL,
                        value = .qual_default_text,
                        rows = 9, resize = "vertical",
                        placeholder = "Paste any text here\u2026"),
          tags$hr(),
          sliderInput(ns("wc_max_words"), "Max words displayed", 20, 200, 80, 10),
          sliderInput(ns("wc_min_freq"),  "Min word frequency",   1,  10,  1,  1),
          checkboxInput(ns("wc_stopwords"), "Remove common stopwords", value = TRUE),
          selectInput(ns("wc_palette"), "Colour palette",
                      choices  = c("Dark2", "Set2", "Set3", "Blues", "Greens",
                                   "Oranges", "Purples", "RdYlBu"),
                      selected = "Dark2"),
          actionButton(ns("wc_go"), "Generate cloud", icon = icon("cloud"),
                       class = "btn-primary w-100 mt-2")
        ),
        div(
          explanation_box(
            tags$strong("Word Cloud"),
            tags$p("Not all research data arrives in tidy rows and columns.
                    Open-ended survey questions, interview transcripts, focus group notes,
                    social media posts, patient narratives, and product reviews are
                    inherently unstructured \u2014 rich in meaning but resistant to the spreadsheet.
                    This module introduces two foundational methods for turning words into numbers."),
            tags$p("The Word Cloud tab starts with the simplest possible question: which words appear most often?
                    Paste any text, strip out grammatical function words
                    (stopwords like \u2018the\u2019, \u2018and\u2019, \u2018is\u2019), and the remaining content words are
                    counted and drawn as a frequency-weighted cloud.
                    Bigger words dominate the text; smaller words are rarer.
                    You control the maximum number of words shown, the minimum frequency
                    needed to appear, and the colour palette."),
            tags$p("Word clouds are deliberately simple. They ignore grammar, order, and context.
                    The phrase \u2018not satisfied\u2019 looks identical to \u2018satisfied\u2019 in a word cloud.
                    Think of them as a first orientation to an unfamiliar corpus, not a conclusion.
                    For a richer picture of emotional tone, switch to the Sentiment Analysis tab."),
            guide = tags$ol(
              tags$li("Paste your own text in the box, or use the default example."),
              tags$li("Adjust Max words and Min frequency to control density."),
              tags$li("Toggle stopword removal to hide function words (the, and, is\u2026)."),
              tags$li("Choose a colour palette and click Generate cloud.")
            )
          ),
          uiOutput(ns("wc_word_count_ui")),
          plotOutput(ns("wc_plot"), height = "480px"),
          uiOutput(ns("wc_freq_table_ui"))
        )
      )
    ),

    # ── Tab 2: N-gram Analysis ────────────────────────────────────────────────
    nav_panel(
      "N-gram Analysis",
      layout_sidebar(
        sidebar = sidebar(
          width = 290,
          checkboxInput(ns("ng_compare"), "Compare two passages", value = FALSE),
          tags$label("Input text", class = "form-label fw-bold"),
          textAreaInput(ns("ng_text"), NULL,
                        value       = .qual_default_text,
                        rows        = 7,
                        resize      = "vertical",
                        placeholder = "Paste any text here\u2026"),
          conditionalPanel(ns = ns, 
            "input.ng_compare",
            tags$label("Passage B", class = "form-label fw-bold mt-2"),
            textAreaInput(ns("ng_text_b"), NULL,
                          value       = .qual_default_text_b,
                          rows        = 5,
                          resize      = "vertical",
                          placeholder = "Paste second passage here\u2026")
          ),
          tags$hr(),
          radioButtons(ns("ng_n"), "N-gram size",
                       choices  = c("Bigrams (2 words)"  = "2",
                                    "Trigrams (3 words)" = "3"),
                       selected = "2", inline = TRUE),
          sliderInput(ns("ng_top"),  "Top n-grams to show", 5, 25, 15, 1),
          checkboxInput(ns("ng_stop"), "Remove stopwords first", value = TRUE),
          actionButton(ns("ng_go"), "Analyse", icon = icon("magnifying-glass"),
                       class = "btn-primary w-100 mt-2")
        ),
        div(
          explanation_box(
            tags$strong("N-gram Analysis"),
            tags$p("A single word is a unigram; two consecutive words form a",
                    tags$strong("bigram"), "; three form a",
                    tags$strong("trigram"), ".
                    Counting n-grams captures local word-order patterns that a
                    word cloud cannot: where a word cloud tells you
                    \u2018statistics\u2019 is common, bigram analysis might reveal
                    \u2018statistical thinking\u2019 or \u2018rigorous methods\u2019
                    as the recurrent phrases."),
            tags$p("N-grams are the backbone of early language models
                    (an n-gram model predicted the next word from the previous n\u22121 words)
                    and remain useful today for keyword extraction,
                    phrase identification, and corpus comparison."),
            tags$p(tags$strong("Compare mode"), " pastes two passages side by side.
                    The resulting", tags$strong("butterfly chart"), "places Passage A
                    bars extending left and Passage B bars extending right, both
                    normalised to percentage of total n-grams so passages of different
                    lengths are directly comparable.
                    Phrases exclusive to one passage have a bar on only one side;
                    shared phrases have bars on both \u2014 their relative lengths show
                    which passage uses them more heavily."),
            tags$p("When stopword removal is on, common function words are stripped ",
                    tags$em("before"), " n-grams are formed, surfacing content-rich phrases."),
            guide = tags$ol(
              tags$li("Single mode: paste text, pick n-gram size, click Analyse."),
              tags$li("Compare mode: tick \u201cCompare two passages\u201d and fill in Passage B."),
              tags$li("The butterfly chart sorts phrases by how much Passage B favours them relative to A."),
              tags$li("Toggle stopword removal to surface content phrases vs. grammatical patterns.")
            )
          ),
          uiOutput(ns("ng_panel_ui"))
        )
      )
    ),

    # ── Tab 3: Readability ────────────────────────────────────────────────────
    nav_panel(
      "Readability",
      layout_sidebar(
        sidebar = sidebar(
          width = 290,
          tags$label("Input text", class = "form-label fw-bold"),
          textAreaInput(ns("rl_text"), NULL,
                        value       = .qual_default_text,
                        rows        = 9,
                        resize      = "vertical",
                        placeholder = "Paste any text here\u2026"),
          tags$hr(),
          actionButton(ns("rl_go"), "Analyse readability",
                       icon = icon("magnifying-glass"),
                       class = "btn-primary w-100 mt-2")
        ),
        div(
          style = "overflow-y: auto; max-height: calc(100vh - 120px); padding-right: 4px;",
          explanation_box(
            tags$strong("Readability Metrics"),
            tags$p("Readability formulas estimate how easy a text is to read based on
                    measurable surface features: sentence length, word length, and syllable
                    count. They were developed to match textbooks and government documents to
                    appropriate reading levels, and are now widely used in UX writing, health
                    communication, and plain-language research."),
            tags$p("Three formulas are reported here:"),
            tags$ul(
              tags$li(tags$strong("Flesch Reading Ease"), " (Flesch, 1948) \u2014
                      score from 0 to 100. Higher = easier.
                      Formula: 206.835 \u2212 1.015 \u00d7 (words \u00f7 sentences)
                      \u2212 84.6 \u00d7 (syllables \u00f7 words).
                      Scores \u2265 60 are considered readable for most adults."),
              tags$li(tags$strong("Flesch\u2013Kincaid Grade Level"), " converts the
                      same surface statistics into a U.S. school-grade estimate.
                      Grade 8\u20139 is the benchmark for general public communication."),
              tags$li(tags$strong("Gunning Fog Index"), " (Gunning, 1952) penalises
                      \u2018complex words\u2019 (3+ syllables).
                      Score 12 = high-school level; above 17 = college-level.")
            ),
            tags$p("Syllable counting uses a vowel-group heuristic rather than a
                    dictionary, so scores are approximations. Use them comparatively
                    (e.g., before vs. after simplifying a draft) rather than as
                    absolute benchmarks."),
            guide = tags$ol(
              tags$li("Paste your text and click Analyse readability."),
              tags$li("Flesch Reading Ease \u2265 60: accessible to most adults."),
              tags$li("FK Grade \u2264 12, Fog \u2264 12: suitable for broad audiences."),
              tags$li("Type\u2013token ratio closer to 1.0 means more varied vocabulary.")
            )
          ),
          uiOutput(ns("rl_vbox_ui")),
          uiOutput(ns("rl_table_ui"))
        )
      )
    ),

    # ── Tab 4: Concordance (KWIC) ─────────────────────────────────────────────
    nav_panel(
      "Concordance",
      layout_sidebar(
        sidebar = sidebar(
          width = 290,
          tags$label("Input text", class = "form-label fw-bold"),
          textAreaInput(ns("kw_text"), NULL,
                        value       = .qual_default_text,
                        rows        = 7,
                        resize      = "vertical",
                        placeholder = "Paste any text here\u2026"),
          tags$hr(),
          textInput(ns("kw_word"), "Search keyword",
                    value       = "statistics",
                    placeholder = "Enter a word\u2026"),
          sliderInput(ns("kw_window"), "Context window (words each side)", 3, 10, 5, 1),
          checkboxInput(ns("kw_ci"), "Case-insensitive", value = TRUE),
          actionButton(ns("kw_go"), "Find",
                       icon = icon("magnifying-glass"),
                       class = "btn-primary w-100 mt-2")
        ),
        div(
          explanation_box(
            tags$strong("Concordance / Key Word In Context (KWIC)"),
            tags$p("A concordance shows every occurrence of a keyword in its surrounding
                    context \u2014 the classic",
                    tags$strong("Key Word In Context (KWIC)"), "format.
                    Each hit is displayed as: [left context] |",
                    tags$strong("keyword"), "| [right context]."),
            tags$p("KWIC was one of the first computational text-analysis methods,
                    introduced by Hans Peter Luhn at IBM in 1960. It remains the
                    fundamental tool in corpus linguistics: you can immediately see
                    whether a word is used positively or negatively, formally or
                    informally, in isolation or as part of a fixed phrase."),
            tags$p("For example, searching \u2018statistics\u2019 in the default text
                    reveals the various contexts in which the word appears \u2014 sometimes
                    as a discipline, sometimes as a practice, qualified as good or poor.
                    This contextual reading is impossible from a frequency count alone."),
            guide = tags$ol(
              tags$li("Paste your text and type a keyword to search for."),
              tags$li("Adjust the context window to show more or fewer surrounding words."),
              tags$li("Toggle case-insensitive to match regardless of capitalisation."),
              tags$li("Click Find to display all concordance lines.")
            )
          ),
          uiOutput(ns("kw_result_ui"))
        )
      )
    ),

    # ── Tab 5: Sentiment Analysis ─────────────────────────────────────────────
    nav_panel(
      "Sentiment Analysis",
      layout_sidebar(
        sidebar = sidebar(
          width = 290,
          tags$label("Input text", class = "form-label fw-bold"),
          textAreaInput(ns("sa_text"), NULL,
                        value = .qual_default_text,
                        rows = 9, resize = "vertical",
                        placeholder = "Paste any text here\u2026"),
          tags$hr(),
          selectInput(ns("sa_lexicon"), "Sentiment lexicon",
                      choices  = c("Bing (positive / negative)" = "bing",
                                   "AFINN (\u22125 to +5)"       = "afinn"),
                      selected = "bing"),
          sliderInput(ns("sa_top_n"), "Top words to display", 5, 30, 15, 1),
          actionButton(ns("sa_go"), "Analyse sentiment", icon = icon("magnifying-glass"),
                       class = "btn-primary w-100 mt-2")
        ),
        div(
          style = "overflow-y: auto; max-height: calc(100vh - 120px); padding-right: 4px;",
          explanation_box(
            tags$strong("Sentiment Analysis"),
            tags$p("Where a word cloud asks which words appear, sentiment analysis asks what
                    those words mean emotionally. It moves from frequency to valence \u2014 from
                    counting to evaluating. The approach used here is lexicon-based scoring:
                    every word in your text is looked up in a hand-curated dictionary where
                    human raters have pre-assigned an emotional weight.
                    Matched words contribute to an overall sentiment score; unmatched words
                    are simply skipped."),
            tags$p("Two lexicons are available, each with a different philosophy:"),
            tags$ul(
              tags$li(tags$strong("Bing"), " (Liu & Hu, 2004) takes a binary stance \u2014
                      every word is either positive or negative, nothing in between.
                      The lexicon covers roughly 6,800 English words.
                      Net sentiment = #positive words \u2212 #negative words.
                      It is the right choice when you need a simple, interpretable signal
                      and do not need to distinguish mild from strong language."),
              tags$li(tags$strong("AFINN"), " (Nielsen, 2011) is more granular.
                      Each word receives an integer score from \u22125
                      (strongly negative: \u2018catastrophe\u2019, \u2018worthless\u2019)
                      to +5 (strongly positive: \u2018outstanding\u2019, \u2018superb\u2019).
                      The total AFINN score sums all matched word scores; the mean word
                      score normalises for text length.
                      Note: AFINN requires the ", tags$em("textdata"), " package.")
            ),
            tags$p("The bar chart ranks the words that drove the overall score the most,
                    with positive contributions on the right and negative on the left."),
            tags$p("All lexicon methods share the same fundamental limitations.
                    Negation is invisible: \u2018not helpful\u2019 and \u2018helpful\u2019 score identically.
                    Sarcasm, irony, and domain-specific jargon are not captured.
                    These results are best treated as a quantitative first pass that
                    directs attention, not as a substitute for careful reading."),
            guide = tags$ol(
              tags$li("Paste or edit text in the input box."),
              tags$li("Choose Bing for a positive/negative split, or AFINN for graded scores."),
              tags$li("Adjust the number of top words shown in the bar chart."),
              tags$li("Click Analyse sentiment to score the text.")
            )
          ),
          uiOutput(ns("sa_summary_ui")),
          plotOutput(ns("sa_plot"), height = "420px")
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

qualitative_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ── Word Cloud ─────────────────────────────────────────────────────────────

  wc_words <- eventReactive(input$wc_go, {
    req(nzchar(trimws(input$wc_text)))
    .qual_tokenize(input$wc_text, remove_stop = input$wc_stopwords)
  })

  output$wc_word_count_ui <- renderUI({
    words <- wc_words()
    req(words)
    freq  <- table(words)
    freq  <- freq[freq >= input$wc_min_freq]
    n_shown <- min(input$wc_max_words, length(freq))
    tags$p(
      class = "text-muted mb-2",
      style = "font-size: 0.85rem;",
      sprintf("Unique words \u2265 min frequency: %d  \u2022  Displaying up to: %d",
              length(freq), n_shown)
    )
  })

  output$wc_plot <- renderPlot({
    words <- wc_words()
    req(length(words) > 0)
    freq_tbl <- sort(table(words), decreasing = TRUE)
    freq_tbl <- freq_tbl[freq_tbl >= input$wc_min_freq]
    req(length(freq_tbl) > 0)
    n_colors <- min(8, max(3, RColorBrewer::brewer.pal.info[input$wc_palette, "maxcolors"]))
    pal <- RColorBrewer::brewer.pal(n_colors, input$wc_palette)
    par(bg = NA)
    wordcloud::wordcloud(
      words        = names(freq_tbl),
      freq         = as.integer(freq_tbl),
      max.words    = input$wc_max_words,
      min.freq     = input$wc_min_freq,
      colors       = pal,
      random.order = FALSE,
      rot.per      = 0.25,
      scale        = c(4, 0.4)
    )
  }, bg = "transparent")

  output$wc_freq_table_ui <- renderUI({
    words <- wc_words()
    req(length(words) > 0)
    freq_tbl <- sort(table(words), decreasing = TRUE)
    freq_tbl <- freq_tbl[freq_tbl >= input$wc_min_freq]
    freq_tbl <- head(freq_tbl, input$wc_max_words)
    req(length(freq_tbl) > 0)

    total   <- sum(freq_tbl)
    max_cnt <- as.integer(freq_tbl[1L])

    rows <- lapply(seq_along(freq_tbl), function(i) {
      cnt  <- as.integer(freq_tbl[i])
      pct  <- round(100 * cnt / total, 1)
      bar_w <- round(100 * cnt / max_cnt)
      tags$tr(
        tags$td(class = "text-muted text-end pe-2",
                style = "width:2.5rem; font-size:0.8rem;", i),
        tags$td(class = "fw-semibold",
                style = "width:7rem;",     names(freq_tbl)[i]),
        tags$td(class = "text-end pe-2",
                style = "width:3.5rem;",   cnt),
        tags$td(style = "width:4rem; font-size:0.8rem; color:#6c757d;",
                sprintf("%.1f%%", pct)),
        tags$td(
          style = "min-width:120px;",
          tags$div(
            style = sprintf(
              paste0("height:10px;border-radius:3px;",
                     "background:#268bd2;width:%d%%;",
                     "transition:width 0.3s ease;"),
              bar_w
            )
          )
        )
      )
    })

    card(
      class = "mt-3",
      card_header(
        class = "d-flex justify-content-between align-items-center py-2",
        tags$span(icon("table"), " Frequency Table"),
        tags$span(class = "text-muted small",
                  sprintf("%d words shown", length(freq_tbl)))
      ),
      div(
        style = "max-height: 320px; overflow-y: auto;",
        tags$table(
          class = "table table-sm table-hover mb-0",
          tags$thead(
            tags$tr(
              tags$th(class = "text-end pe-2", "#"),
              tags$th("Word"),
              tags$th(class = "text-end pe-2", "Count"),
              tags$th("%"),
              tags$th("Frequency")
            )
          ),
          tags$tbody(rows)
        )
      )
    )
  })

  # ── N-gram Analysis ────────────────────────────────────────────────────────

  ng_result <- eventReactive(input$ng_go, {
    req(nzchar(trimws(input$ng_text)))
    n     <- as.integer(input$ng_n)
    words <- .qual_tokenize(input$ng_text, remove_stop = input$ng_stop)
    if (length(words) < n) return(NULL)
    grams <- sapply(seq_len(length(words) - n + 1L),
                    function(i) paste(words[i:(i + n - 1L)], collapse = " "))
    freq  <- sort(table(grams), decreasing = TRUE)
    top_n <- min(input$ng_top, length(freq))
    df    <- as.data.frame(freq[seq_len(top_n)], stringsAsFactors = FALSE)
    colnames(df) <- c("phrase", "freq")
    df
  })

  output$ng_count_ui <- renderUI({
    df <- ng_result()
    req(df)
    if (is.null(df) || nrow(df) == 0) return(NULL)
    n_label <- if (input$ng_n == "2") "bigrams" else "trigrams"
    tags$p(
      class = "text-muted mb-2",
      style = "font-size: 0.85rem;",
      sprintf("Showing top %d %s", nrow(df), n_label)
    )
  })

  output$ng_plot <- renderPlot({
    df <- ng_result()
    req(df)
    if (is.null(df) || nrow(df) == 0) {
      plot.new()
      text(0.5, 0.5, "Not enough words to form n-grams.\nTry turning off stopword removal.",
           cex = 1.1, col = "grey50", adj = 0.5)
      return(invisible(NULL))
    }
    dark     <- isTRUE(session$userData$dark_mode)
    text_col <- if (dark) "#839496" else "#657b83"
    n_label  <- if (input$ng_n == "2") "Bigrams" else "Trigrams"
    df$phrase <- reorder(df$phrase, df$freq)
    ggplot(df, aes(x = freq, y = phrase)) +
      geom_col(fill = "#268bd2") +
      labs(title = paste("Top", nrow(df), n_label),
           x = "Frequency", y = NULL) +
      theme(
        text       = element_text(colour = text_col),
        axis.text  = element_text(colour = text_col),
        axis.title = element_text(colour = text_col),
        plot.title = element_text(colour = text_col),
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  }, bg = "transparent")

  # ── N-gram panel switcher ────────────────────────────────────────────────────
  output$ng_panel_ui <- renderUI({
    if (isTRUE(input$ng_compare)) {
      tagList(
        uiOutput(session$ns("ng_compare_summary_ui")),
        plotOutput(session$ns("ng_compare_plot"), height = "550px")
      )
    } else {
      tagList(
        uiOutput(session$ns("ng_count_ui")),
        plotOutput(session$ns("ng_plot"), height = "480px")
      )
    }
  })

  # ── N-gram comparison reactive ───────────────────────────────────────────────
  ng_compare_r <- eventReactive(input$ng_go, {
    req(isTRUE(input$ng_compare))
    req(nzchar(trimws(input$ng_text)), nzchar(trimws(input$ng_text_b)))
    n <- as.integer(input$ng_n)

    make_ngrams <- function(txt) {
      words <- .qual_tokenize(txt, remove_stop = input$ng_stop)
      if (length(words) < n) return(table(character(0)))
      grams <- sapply(seq_len(length(words) - n + 1L),
                      function(i) paste(words[i:(i + n - 1L)], collapse = " "))
      table(grams)
    }

    tbl_a <- make_ngrams(input$ng_text)
    tbl_b <- make_ngrams(input$ng_text_b)

    k      <- input$ng_top
    top_a  <- names(sort(tbl_a, decreasing = TRUE))[seq_len(min(k, length(tbl_a)))]
    top_b  <- names(sort(tbl_b, decreasing = TRUE))[seq_len(min(k, length(tbl_b)))]
    phrases <- union(top_a, top_b)
    if (length(phrases) == 0L) return(NULL)

    total_a <- max(1L, sum(tbl_a))
    total_b <- max(1L, sum(tbl_b))

    cnt_a <- as.integer(tbl_a[phrases]); cnt_a[is.na(cnt_a)] <- 0L
    cnt_b <- as.integer(tbl_b[phrases]); cnt_b[is.na(cnt_b)] <- 0L

    df <- data.frame(
      phrase = phrases,
      cnt_a  = cnt_a,  cnt_b  = cnt_b,
      norm_a = 100 * cnt_a / total_a,
      norm_b = 100 * cnt_b / total_b,
      group  = ifelse(cnt_a > 0 & cnt_b > 0, "shared",
               ifelse(cnt_a > 0, "a_only", "b_only")),
      stringsAsFactors = FALSE
    )
    # Sort: B-exclusive top, A-exclusive bottom
    df[order(df$norm_b - df$norm_a), ]
  })

  output$ng_compare_summary_ui <- renderUI({
    df <- ng_compare_r()
    req(!is.null(df))
    div(class = "d-flex gap-3 mb-3 flex-wrap",
      value_box(title = "Passage A only",
                value    = sum(df$group == "a_only"),
                showcase = icon("arrow-left"),       theme = "primary", height = "90px"),
      value_box(title = "Shared phrases",
                value    = sum(df$group == "shared"),
                showcase = icon("arrows-left-right"), theme = "success", height = "90px"),
      value_box(title = "Passage B only",
                value    = sum(df$group == "b_only"),
                showcase = icon("arrow-right"),       theme = "info",    height = "90px")
    )
  })

  output$ng_compare_plot <- renderPlot({
    df <- ng_compare_r()
    req(!is.null(df), nrow(df) > 0)

    dark     <- isTRUE(session$userData$dark_mode)
    text_col <- if (dark) "#839496" else "#657b83"
    n_label  <- if (input$ng_n == "2") "Bigram" else "Trigram"

    df$phrase_f <- factor(df$phrase, levels = df$phrase)

    df_long <- rbind(
      data.frame(phrase = df$phrase_f, x = -df$norm_a, passage = "Passage A",
                 stringsAsFactors = FALSE),
      data.frame(phrase = df$phrase_f, x =  df$norm_b, passage = "Passage B",
                 stringsAsFactors = FALSE)
    )
    df_long <- df_long[df_long$x != 0, ]
    x_max   <- max(abs(df_long$x), na.rm = TRUE) * 1.12

    ggplot(df_long, aes(x = x, y = phrase, fill = passage)) +
      geom_col() +
      geom_vline(xintercept = 0, linewidth = 0.5, colour = "grey50") +
      scale_fill_manual(
        values = c("Passage A" = "#268bd2", "Passage B" = "#2aa198")
      ) +
      scale_x_continuous(
        limits = c(-x_max, x_max),
        labels = function(x) paste0(abs(round(x, 1)), "%")
      ) +
      labs(
        title = paste(n_label, "comparison \u2014 % of n-grams in each passage"),
        x     = "\u2190 Passage A  |  Passage B \u2192",
        y     = NULL, fill = NULL
      ) +
      theme(
        legend.position  = "top",
        text             = element_text(colour = text_col),
        axis.text        = element_text(colour = text_col),
        axis.title       = element_text(colour = text_col),
        plot.title       = element_text(colour = text_col),
        legend.text      = element_text(colour = text_col),
        plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA)
      )
  }, bg = "transparent")

  # ── Readability ──────────────────────────────────────────────────────────────

  rl_result <- eventReactive(input$rl_go, {
    req(nzchar(trimws(input$rl_text)))
    words_raw <- .qual_tokenize(input$rl_text, remove_stop = FALSE)
    n_words   <- length(words_raw)
    req(n_words > 0)
    n_sents   <- .count_sentences(input$rl_text)
    n_chars   <- nchar(gsub("\\s", "", input$rl_text))
    syllables <- vapply(words_raw, .count_syllables, integer(1L))
    n_sylls   <- sum(syllables)
    n_complex <- sum(syllables >= 3L)
    n_unique  <- length(unique(tolower(words_raw)))
    ttr       <- n_unique / n_words

    fre <- max(0, min(100, 206.835 - 1.015 * (n_words / n_sents) -
                           84.6  * (n_sylls  / n_words)))
    fkg <- max(0, 0.39 * (n_words / n_sents) +
                  11.8 * (n_sylls / n_words) - 15.59)
    fog <- 0.4 * (n_words / n_sents + 100 * n_complex / n_words)

    list(
      n_words = n_words, n_sents = n_sents, n_chars = n_chars,
      n_sylls = n_sylls, n_complex = n_complex, n_unique = n_unique,
      avg_sent  = round(n_words / n_sents, 1),
      avg_syll  = round(n_sylls / n_words, 2),
      ttr       = round(ttr, 3),
      fre       = round(fre, 1),
      fkg       = round(fkg, 1),
      fog       = round(fog, 1),
      fre_label = .fre_label(fre)
    )
  })

  output$rl_vbox_ui <- renderUI({
    r <- rl_result()
    req(r)
    fre_theme <- if (r$fre >= 60) "success" else if (r$fre >= 40) "warning" else "danger"
    div(class = "d-flex gap-3 mb-3 flex-wrap",
      value_box(title = "Words",
                value = format(r$n_words, big.mark = ","),
                showcase = icon("font"),      theme = "primary",  height = "110px"),
      value_box(title = "Sentences",
                value = r$n_sents,
                showcase = icon("paragraph"), theme = "primary",  height = "110px"),
      value_box(title = "Avg words / sentence",
                value = r$avg_sent,
                showcase = icon("ruler"),     theme = "info",     height = "110px"),
      value_box(title = "Reading Ease",
                value = r$fre,
                showcase = icon("book-open"), theme = fre_theme,  height = "110px",
                p(class = "small", r$fre_label))
    )
  })

  output$rl_table_ui <- renderUI({
    r <- rl_result()
    req(r)
    mk <- function(label, value, note = "") {
      tags$tr(
        tags$td(label),
        tags$td(class = "fw-bold text-end pe-3", value),
        tags$td(class = "text-muted small", note)
      )
    }
    tags$table(
      class = "table table-sm table-striped mt-2",
      tags$thead(tags$tr(
        tags$th("Metric"),
        tags$th(class = "text-end pe-3", "Value"),
        tags$th("Note")
      )),
      tags$tbody(
        mk("Characters (no spaces)",   format(r$n_chars,   big.mark = ",")),
        mk("Syllables",                format(r$n_sylls,   big.mark = ",")),
        mk("Complex words (3+ syll.)", format(r$n_complex, big.mark = ",")),
        mk("Unique words",             format(r$n_unique,  big.mark = ",")),
        mk("Type\u2013token ratio",    sprintf("%.3f", r$ttr),
           "Unique \u00f7 total words; higher = more varied vocabulary"),
        mk("Avg syllables / word",     sprintf("%.2f", r$avg_syll)),
        mk("Flesch Reading Ease",      sprintf("%.1f", r$fre),
           sprintf("%s  (0 = hardest, 100 = easiest)", r$fre_label)),
        mk("FK Grade Level",           sprintf("%.1f", r$fkg),
           "U.S. school grade; \u2264 12 recommended for general audiences"),
        mk("Gunning Fog Index",        sprintf("%.1f", r$fog),
           "12 = high school; \u2264 17 = college")
      )
    )
  })

  # ── Concordance (KWIC) ───────────────────────────────────────────────────────

  kw_result <- eventReactive(input$kw_go, {
    req(nzchar(trimws(input$kw_word)), nzchar(trimws(input$kw_text)))
    keyword <- trimws(input$kw_word)
    window  <- input$kw_window
    ci      <- isTRUE(input$kw_ci)

    # Tokenise preserving original capitalisation for display
    raw <- unlist(strsplit(gsub("[^a-zA-Z0-9'\u2019 ]", " ", input$kw_text), "\\s+"))
    raw <- raw[nzchar(raw)]

    targets  <- if (ci) tolower(raw)     else raw
    kw_match <- if (ci) tolower(keyword) else keyword
    hits <- which(targets == kw_match)

    if (length(hits) == 0L)
      return(list(found = FALSE, keyword = keyword))

    rows <- lapply(hits, function(i) {
      li <- if (i > 1L) seq(max(1L, i - window), i - 1L) else integer(0L)
      ri <- if (i < length(raw)) seq(i + 1L, min(length(raw), i + window)) else integer(0L)
      list(
        left    = paste(raw[li], collapse = " "),
        keyword = raw[i],
        right   = paste(raw[ri], collapse = " ")
      )
    })
    list(found = TRUE, keyword = keyword, n = length(hits), rows = rows)
  })

  output$kw_result_ui <- renderUI({
    res <- kw_result()
    if (is.null(res)) return(NULL)
    if (!res$found) {
      return(div(class = "alert alert-info mt-2",
                 icon("circle-info"),
                 sprintf(' \u201c%s\u201d not found. Check spelling or toggle case-insensitive.',
                         res$keyword)))
    }
    header <- tags$p(
      class = "text-muted small mb-3",
      sprintf('%d occurrence%s of \u201c%s\u201d',
              res$n, if (res$n == 1L) "" else "s", res$keyword)
    )
    rows <- lapply(res$rows, function(r) {
      tags$div(
        class = "d-flex gap-0 mb-1 align-items-baseline border-bottom pb-1",
        tags$span(
          style = paste0(
            "text-align:right;min-width:240px;max-width:240px;overflow:hidden;",
            "white-space:nowrap;text-overflow:ellipsis;direction:rtl;",
            "color:#6c757d;font-family:monospace;font-size:0.83rem;padding-right:6px;"
          ),
          r$left
        ),
        tags$span(
          style = paste0(
            "font-weight:bold;color:#268bd2;white-space:nowrap;",
            "font-family:monospace;font-size:0.83rem;padding:0 6px;",
            "background:rgba(38,139,210,0.10);border-radius:3px;"
          ),
          r$keyword
        ),
        tags$span(
          style = paste0(
            "color:#6c757d;font-family:monospace;font-size:0.83rem;",
            "overflow:hidden;white-space:nowrap;text-overflow:ellipsis;",
            "padding-left:6px;"
          ),
          r$right
        )
      )
    })
    div(style = "max-height: 500px; overflow-y: auto;",
        header, tagList(rows))
  })

  # ── Sentiment Analysis ─────────────────────────────────────────────────────

  sa_result <- eventReactive(input$sa_go, {
    req(nzchar(trimws(input$sa_text)))
    words   <- .qual_tokenize(input$sa_text, remove_stop = FALSE)
    word_df <- data.frame(word = words, stringsAsFactors = FALSE)
    if (input$sa_lexicon == "bing") {
      if (!requireNamespace("tidytext", quietly = TRUE))
        return(list(error = "Please install the 'tidytext' package to use this feature."))
      lex    <- tidytext::get_sentiments("bing")
      merged <- merge(word_df, lex, by = "word")
      list(type = "bing", data = merged)
    } else {
      if (!requireNamespace("tidytext",  quietly = TRUE))
        return(list(error = "Please install the 'tidytext' package."))
      if (!requireNamespace("textdata", quietly = TRUE))
        return(list(error = paste(
          "The AFINN lexicon requires the 'textdata' package.",
          "Install it with: install.packages('textdata'), then re-run."
        )))
      lex <- tryCatch(tidytext::get_sentiments("afinn"), error = function(e) NULL)
      if (is.null(lex))
        return(list(error = "Run get_sentiments('afinn') in the console once to download it."))
      merged <- merge(word_df, lex, by = "word")
      list(type = "afinn", data = merged)
    }
  })

  output$sa_summary_ui <- renderUI({
    res <- sa_result()
    if (!is.null(res$error))
      return(div(class = "alert alert-warning mt-2",
                 icon("triangle-exclamation"), " ", res$error))
    if (nrow(res$data) == 0)
      return(div(class = "alert alert-info mt-2",
                 icon("circle-info"),
                 " No sentiment-bearing words found. Try a different lexicon or a longer passage."))
    if (res$type == "bing") {
      n_pos <- sum(res$data$sentiment == "positive")
      n_neg <- sum(res$data$sentiment == "negative")
      net   <- n_pos - n_neg
      div(class = "d-flex gap-3 mb-3 flex-wrap",
        value_box(title = "Positive words",  value = n_pos,
                  showcase = icon("thumbs-up"),      theme = "success", height = "100px"),
        value_box(title = "Negative words",  value = n_neg,
                  showcase = icon("thumbs-down"),    theme = "danger",  height = "100px"),
        value_box(title = "Net sentiment",   value = sprintf("%+d", net),
                  showcase = icon("scale-balanced"),
                  theme = if (net >= 0) "primary" else "warning", height = "100px")
      )
    } else {
      total <- sum(res$data$value)
      n_sc  <- nrow(res$data)
      avg   <- if (n_sc > 0) round(total / n_sc, 2) else 0
      div(class = "d-flex gap-3 mb-3 flex-wrap",
        value_box(title = "Scored words",     value = n_sc,
                  showcase = icon("list-check"), theme = "primary", height = "100px"),
        value_box(title = "Total AFINN score", value = sprintf("%+d", total),
                  showcase = icon("sigma"),
                  theme = if (total >= 0) "success" else "danger", height = "100px"),
        value_box(title = "Mean word score",   value = sprintf("%+.2f", avg),
                  showcase = icon("chart-bar"), theme = "info", height = "100px")
      )
    }
  })

  output$sa_plot <- renderPlot({
    res <- sa_result()
    req(is.null(res$error), nrow(res$data) > 0)
    top_n    <- input$sa_top_n
    dark     <- isTRUE(session$userData$dark_mode)
    text_col <- if (dark) "#839496" else "#657b83"
    dark_theme <- theme(
      text        = element_text(colour = text_col),
      axis.text   = element_text(colour = text_col),
      axis.title  = element_text(colour = text_col),
      plot.title  = element_text(colour = text_col),
      legend.text = element_text(colour = text_col)
    )
    if (res$type == "bing") {
      contrib <- aggregate(list(n = res$data$word),
                           by  = list(word = res$data$word, sentiment = res$data$sentiment),
                           FUN = length)
      pos_top <- head(contrib[contrib$sentiment == "positive", ][
        order(-contrib[contrib$sentiment == "positive", "n"]), ], top_n)
      neg_top <- head(contrib[contrib$sentiment == "negative", ][
        order(-contrib[contrib$sentiment == "negative", "n"]), ], top_n)
      plot_df <- rbind(pos_top, neg_top)
      plot_df$n_signed <- ifelse(plot_df$sentiment == "positive", plot_df$n, -plot_df$n)
      plot_df$word     <- reorder(plot_df$word, plot_df$n_signed)
      ggplot(plot_df, aes(x = n_signed, y = word, fill = sentiment)) +
        geom_col() +
        geom_vline(xintercept = 0, linewidth = 0.4, colour = "grey50") +
        scale_fill_manual(values = c(positive = "#2aa198", negative = "#dc322f"),
                          labels = c(positive = "Positive", negative = "Negative")) +
        labs(title = "Top sentiment-bearing words \u2014 Bing lexicon",
             x = "Word count  (positive \u2192, \u2190 negative)", y = NULL, fill = NULL) +
        theme(legend.position = "top") + dark_theme
    } else {
      contrib <- aggregate(list(total_score = res$data$value),
                           by  = list(word = res$data$word), FUN = sum)
      contrib <- contrib[order(-abs(contrib$total_score)), ]
      contrib <- head(contrib, top_n * 2)
      contrib$sign <- ifelse(contrib$total_score >= 0, "positive", "negative")
      contrib$word <- reorder(contrib$word, contrib$total_score)
      ggplot(contrib, aes(x = total_score, y = word, fill = sign)) +
        geom_col() +
        geom_vline(xintercept = 0, linewidth = 0.4, colour = "grey50") +
        scale_fill_manual(values = c(positive = "#2aa198", negative = "#dc322f"),
                          guide  = "none") +
        labs(title = "Top sentiment contributions \u2014 AFINN lexicon",
             x = "Total score  (frequency \u00d7 AFINN value)", y = NULL) +
        dark_theme
    }
  }, bg = "transparent")
  })
}
