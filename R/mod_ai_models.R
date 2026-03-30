# Module: AI & Large Language Models
# 4 tabs: Tokenization · Attention Mechanism · Temperature & Sampling · Training & Scaling

# ── Helpers ───────────────────────────────────────────────────────────────────
ai_tokenize <- function(text) {
  tokens <- unlist(strsplit(trimws(text), "\\s+|(?=[[:punct:]])|(?<=[[:punct:]])", perl = TRUE))
  tokens <- tokens[nchar(tokens) > 0]
  tokens
}

ai_get_bigrams <- function(word) {
  w <- tolower(gsub("[^a-z]", "", word))
  if (nchar(w) < 2) return(character(0))
  sapply(seq_len(nchar(w) - 1), function(i) substr(w, i, i + 1))
}

ai_jaccard <- function(a, b) {
  bi_a <- ai_get_bigrams(a);  bi_b <- ai_get_bigrams(b)
  if (length(bi_a) == 0 || length(bi_b) == 0) return(0)
  length(intersect(bi_a, bi_b)) / length(union(bi_a, bi_b))
}

ai_softmax <- function(x, temp = 1) {
  x <- x / temp
  x <- x - max(x)
  ex <- exp(x);  ex / sum(ex)
}

ai_compute_attention <- function(tokens, temp = 1.0) {
  n   <- length(tokens)
  sim <- matrix(0, n, n)
  for (i in seq_len(n))
    for (j in seq_len(n))
      sim[i, j] <- ai_jaccard(tokens[i], tokens[j]) + 0.15 * (i == j)
  t(apply(sim, 1, function(row) ai_softmax(row, temp)))
}

ai_generate_data <- function(type = "xor", n = 300, seed = 42) {
  set.seed(seed)
  if (type == "XOR") {
    x1 <- runif(n, -1, 1);  x2 <- runif(n, -1, 1)
    y  <- as.numeric((x1 > 0) == (x2 > 0))
  } else if (type == "Circles") {
    theta <- runif(n, 0, 2 * pi)
    r     <- c(runif(n / 2, 0, 0.45), runif(n / 2, 0.60, 1))
    x1    <- r * cos(theta);  x2 <- r * sin(theta)
    y     <- as.numeric(r > 0.52)
  } else {
    t_seq <- seq(0, 3.5 * pi, length.out = n / 2)
    noise <- 0.12
    x1 <- c(t_seq / 10 * cos(t_seq) + rnorm(n / 2, 0, noise),
            -t_seq / 10 * cos(t_seq) + rnorm(n / 2, 0, noise))
    x2 <- c(t_seq / 10 * sin(t_seq) + rnorm(n / 2, 0, noise),
            -t_seq / 10 * sin(t_seq) + rnorm(n / 2, 0, noise))
    y  <- c(rep(0, n / 2), rep(1, n / 2))
  }
  data.frame(x1 = x1, x2 = x2, y = factor(y))
}

ai_sim_loss <- function(epochs, hidden, data_type, seed = 7) {
  set.seed(seed + hidden * 3 + match(data_type, c("XOR","Circles","Spirals")) * 7)
  complexity <- c(XOR = 1.2, Circles = 1.5, Spirals = 2.2)[data_type]
  start <- 0.70 * complexity + abs(rnorm(1, 0, 0.05))
  final <- max(0.02, 0.30 * complexity / hidden + abs(rnorm(1, 0, 0.01)))
  t <- seq(0, 1, length.out = epochs)
  loss <- start * exp(-4.5 * t) + final +
          rnorm(epochs, 0, 0.03) * exp(-3 * t)
  pmax(loss, final * 0.85)
}

# Preset next-token scenarios
ai_scenarios <- list(
  "The quick brown fox ___" = list(
    tokens = c("jumps","leaps","runs","sprints","flies",
               "sleeps","sits","barks","hides","dreams"),
    logits = c(3.6, 2.9, 2.5, 2.1, 1.7, 0.8, 0.5, 0.2, -0.3, -0.9)
  ),
  "The weather today is ___" = list(
    tokens = c("sunny","warm","cold","cloudy","perfect",
               "rainy","beautiful","awful","mild","stormy"),
    logits = c(3.1, 2.8, 2.4, 2.2, 1.9, 1.5, 1.2, 0.4, 0.2, -0.2)
  ),
  "She opened the ___" = list(
    tokens = c("door","window","box","letter","book",
               "bag","drawer","envelope","jar","fridge"),
    logits = c(3.8, 2.6, 2.3, 2.1, 1.8, 1.4, 1.1, 0.9, 0.5, 0.3)
  )
)

# ── Toy word embeddings (2D, pre-generated to illustrate semantic clustering) ─
.ai_embeddings <- local({
  set.seed(6214)
  mk <- function(words, cx, cy, sx = 0.32, sy = 0.22) {
    n <- length(words)
    data.frame(word = words,
               x    = round(cx + rnorm(n, 0, sx), 3),
               y    = round(cy + rnorm(n, 0, sy), 3),
               stringsAsFactors = FALSE)
  }
  rbind(
    cbind(mk(c("king","queen","prince","princess","crown","throne","palace","royal","knight","noble"),        3.6, 3.1), category = "Royalty"),
    cbind(mk(c("man","woman","boy","girl","father","mother","brother","sister","child","person"),             3.1, 1.1), category = "People"),
    cbind(mk(c("dog","cat","fish","bird","rabbit","parrot","horse","hamster","puppy","kitten"),              -2.6, 3.1), category = "Pets"),
    cbind(mk(c("lion","tiger","elephant","wolf","bear","fox","deer","eagle","shark","whale"),                -2.6, 4.8), category = "Wildlife"),
    cbind(mk(c("bread","rice","pasta","apple","banana","pizza","cake","soup","cheese","milk"),               -2.6,-2.6), category = "Food"),
    cbind(mk(c("computer","phone","internet","software","code","algorithm","robot","network","server","chip"), 3.6,-3.1), category = "Technology"),
    cbind(mk(c("france","germany","italy","england","spain","japan","china","india","russia","brazil"),        1.1,-3.6), category = "Countries"),
    cbind(mk(c("football","tennis","swimming","running","cycling","basketball","soccer","golf","boxing","rugby"),-1.1,-3.6), category = "Sports"),
    cbind(mk(c("happy","sad","angry","fear","love","joy","hope","anger","peace","grief"),                     0.1, 4.6), category = "Emotions"),
    cbind(mk(c("physics","chemistry","biology","science","research","experiment","theory","hypothesis","math","statistics"), 1.1, 2.6), category = "Science")
  )
})

ai_cosine_sim_2d <- function(v1, v2) {
  d <- sum(v1 * v2) / (sqrt(sum(v1^2)) * sqrt(sum(v2^2)))
  if (is.nan(d) || is.na(d)) NA_real_ else d
}

# ── BPE algorithm helpers ─────────────────────────────────────────────────────
.bpe_default_text <- paste(
  "low lower lowest new newer newest old older oldest",
  "talk talked talking walk walked walking play played playing",
  "run running runner fast faster fastest slow slower slowest"
)

bpe_init_corpus <- function(text) {
  words <- tolower(gsub("[^a-z ]", " ", text))
  words <- unlist(strsplit(words, "\\s+"))
  words <- words[nzchar(words)]
  freq  <- table(words)
  segs  <- lapply(names(freq), function(w) c(unlist(strsplit(w, "")), "</w>"))
  list(segs = segs, freq = as.integer(freq), words = names(freq))
}

bpe_count_pairs <- function(segs, freq) {
  counts <- list()
  for (i in seq_along(segs)) {
    s <- segs[[i]]; f <- freq[i]
    if (length(s) < 2) next
    for (j in seq_len(length(s) - 1L)) {
      k <- paste(s[j], s[j + 1L], sep = "\x01")
      counts[[k]] <- (counts[[k]] %||% 0L) + f
    }
  }
  counts
}

bpe_merge_pair <- function(segs, a, b) {
  merged <- paste0(a, b)
  lapply(segs, function(s) {
    out <- character(0L); i <- 1L
    while (i <= length(s)) {
      if (i < length(s) && s[i] == a && s[i + 1L] == b) {
        out <- c(out, merged); i <- i + 2L
      } else {
        out <- c(out, s[i]); i <- i + 1L
      }
    }
    out
  })
}

bpe_run <- function(text, n_merges = 20L) {
  corp  <- bpe_init_corpus(text)
  segs  <- corp$segs; freq <- corp$freq
  # Track total token count across corpus (weighted by word frequency)
  tok_count <- function(s, f) sum(lengths(s) * f)
  merge_rows <- vector("list", n_merges)
  tcounts    <- integer(n_merges + 1L)
  tcounts[1L] <- tok_count(segs, freq)
  for (step in seq_len(n_merges)) {
    pairs <- bpe_count_pairs(segs, freq)
    if (length(pairs) == 0L) break
    best  <- names(which.max(unlist(pairs)))
    ab    <- strsplit(best, "\x01")[[1L]]
    merge_rows[[step]] <- list(
      Step = step, Pair = paste(ab[1L], "+", ab[2L]),
      Merged = paste0(ab[1L], ab[2L]), Frequency = pairs[[best]]
    )
    segs <- bpe_merge_pair(segs, ab[1L], ab[2L])
    tcounts[step + 1L] <- tok_count(segs, freq)
  }
  merge_rows <- Filter(Negate(is.null), merge_rows)
  n_done <- length(merge_rows)
  list(
    final   = setNames(segs, corp$words),
    freq    = setNames(freq, corp$words),
    log     = merge_rows,
    tcounts = tcounts[seq_len(n_done + 1L)]
  )
}

# ── UI ────────────────────────────────────────────────────────────────────────
ai_models_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "AI & LLMs",
  icon = icon("microchip"),
  navset_card_underline(

    # ── Tab 1: Tokenization ───────────────────────────────────────────────────
    nav_panel(
      "Tokenization",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          tags$label(class = "form-label fw-bold", "Enter any text:"),
          textAreaInput(ns("ai_text"),
            label    = NULL,
            value    = "Large language models learn to predict the next token from billions of text examples.",
            rows     = 5,
            width    = "100%"),
          tags$hr(),
          checkboxInput(ns("ai_lower"), "Lowercase all tokens", value = TRUE),
          checkboxInput(ns("ai_stop"),  "Hide common stop words", value = FALSE)
        ),
        explanation_box(
          tags$strong("Tokenization — Turning Text into Numbers"),
          tags$p("Before any AI model can process language, text must be converted into
                  tokens — discrete units the model can work with. Modern LLMs use
                  subword tokenisation (Byte-Pair Encoding, BPE) rather than whole words,
                  so rare words get split: \"unhappiness\" → [\"un\", \"happiness\"],
                  while common words stay whole. GPT-4 uses ~100,000 tokens in its
                  vocabulary."),
          tags$p("Why subword? It balances vocabulary size against coverage.
                  A word-level vocabulary explodes with proper nouns and morphological
                  variants. A character-level vocabulary is tiny but sequences become
                  very long, making the model's job harder. Subword sits in between:
                  common words are one token; rare words compose from familiar pieces."),
          tags$p("The token frequency chart reveals the Zipfian distribution of language:
                  a handful of tokens appear very frequently while most appear rarely.
                  This is a universal property of natural language and explains why
                  simple compression-based tokenisation (like BPE) works so well."),
          tags$p("The tokeniser choice has surprising downstream effects on model behaviour.
                  The same string can tokenise differently across models: 'ChatGPT' might
                  become [\"Chat\", \"G\", \"PT\"] in one vocabulary and [\"Chat\", \"GPT\"]
                  in another. Numbers, punctuation, code symbols, and non-Latin scripts
                  are often split into many short tokens, making those domains harder for
                  models trained predominantly on English prose. This is why LLMs
                  sometimes struggle with letter-counting, arithmetic, or morphologically
                  rich languages \u2014 the token boundaries don\u2019t align with the units the
                  task requires."),
          guide = tags$ol(
            tags$li("Type or paste any text in the sidebar."),
            tags$li("Each token gets a coloured chip — colour intensity reflects frequency."),
            tags$li("The bar chart shows the frequency distribution across tokens."),
            tags$li("Toggle 'Hide stop words' to see content words only.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(card_header("Tokens"), uiOutput(ns("ai_token_chips"))),
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Token Frequency Distribution"),
                 plotlyOutput(ns("ai_token_freq"), height = "280px")),
            card(card_header("Statistics"), uiOutput(ns("ai_token_stats")))
          )
        )
      )
    ),

    # ── Tab 2: BPE Tokenizer ──────────────────────────────────────────────────
    nav_panel(
      "BPE Tokenizer",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          tags$label(class = "form-label fw-bold", "Training text:"),
          textAreaInput(ns("bpe_text"), NULL,
            value  = .bpe_default_text,
            rows   = 5,
            width  = "100%",
            resize = "vertical"),
          tags$hr(),
          sliderInput(ns("bpe_merges"), "Merge steps", 1L, 30L, 15L, 1L),
          actionButton(ns("bpe_run"), "Run BPE",
                       icon = icon("play"), class = "btn-primary w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Byte-Pair Encoding \u2014 How LLM Vocabularies Are Built"),
          tags$p("Real LLMs don\u2019t split text on spaces and punctuation.
                  They use a data-driven algorithm called",
                  tags$strong("Byte-Pair Encoding (BPE)"), "to build a vocabulary
                  of subword pieces from a training corpus. The algorithm is simple:"),
          tags$ol(
            tags$li("Start with a character-level vocabulary: every word is split
                     into individual characters, plus a special end-of-word marker ",
                     tags$code("</w>"), "."),
            tags$li("Count every adjacent symbol pair across the whole corpus."),
            tags$li("Merge the most frequent pair into a single new symbol."),
            tags$li("Repeat until the target vocabulary size is reached.")
          ),
          tags$p("After enough merges, common morphemes like ",
                  tags$code("ing"), ", ", tags$code("ed"), ", or ", tags$code("est"),
                  " emerge as single tokens. Common whole words stay intact;
                  rare or novel words decompose into familiar subword pieces.
                  This is why GPT models can handle words they have never seen before \u2014
                  they combine smaller units encountered during training."),
          tags$p("Each merge step reduces the total number of tokens in the corpus:
                  every occurrence of the pair gets replaced by the single merged symbol.
                  The chart tracks this compression \u2014 it always falls, showing that
                  fewer and fewer symbols are needed to represent the same text."),
          guide = tags$ol(
            tags$li("Edit the training text or use the default morphology example."),
            tags$li("Drag the Merge steps slider, then click Run BPE."),
            tags$li("The Merge Log shows which pair was combined at each step and its frequency."),
            tags$li("The bottom panel shows the final subword segmentation of every unique word.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Merge Log"),
                 div(style = "max-height: 340px; overflow-y: auto;",
                     tableOutput(ns("bpe_table")))),
            card(full_screen = TRUE,
                 card_header("Vocabulary Size Over Steps"),
                 plotlyOutput(ns("bpe_vocab_plot"), height = "300px"))
          ),
          card(card_header("Final Subword Segmentation"),
               uiOutput(ns("bpe_tokens_ui")))
        )
      )
    ),

    # ── Tab 3: Attention Mechanism ────────────────────────────────────────────
    nav_panel(
      "Attention Mechanism",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          selectInput(ns("ai_sent"), "Example sentence",
            choices = c(
              "The cat sat on the mat",
              "The bank by the river is steep",
              "She said that she would come back",
              "The model learned to predict the next word"
            )),
          tags$small(class = "text-muted", "or type a custom sentence (5–12 words):"),
          textInput(ns("ai_custom_sent"), NULL, value = "", placeholder = "Type here…"),
          tags$hr(),
          sliderInput(ns("ai_attn_temp"), "Attention temperature",
                      0.1, 3.0, 1.0, 0.1),
          sliderInput(ns("ai_attn_head"), "Simulated head (random offset)",
                      1, 8, 1, 1)
        ),
        explanation_box(
          tags$strong("Self-Attention — How Tokens Talk to Each Other"),
          tags$p("The Transformer's key innovation is self-attention: every token can
                  directly look at every other token and decide how much to borrow from
                  it. For each token, three vectors are computed:"),
          tags$ul(
            tags$li(tags$strong("Query (Q)"), " — what information is this token looking for?"),
            tags$li(tags$strong("Key (K)"),   " — what information does this token offer?"),
            tags$li(tags$strong("Value (V)"), " — what information does this token actually pass on?")
          ),
          tags$p("The attention weight from token i to token j is softmax(Qᵢ · Kⱼ / √d).
                  High weight means token i borrows heavily from token j's Value vector.
                  In a sentence like \"The bank by the river\", attention on \"bank\"
                  should weight \"river\" highly to resolve the word's meaning."),
          tags$p("Real LLMs have many attention heads in parallel, each learning
                  to attend to different relationships (syntax, coreference, semantics).
                  Temperature controls how peaked (focused) or diffuse the attention
                  distribution is — low temperature forces near-exclusive attention;
                  high temperature spreads it broadly."),
          tags$p("One subtle challenge: the attention formula is inherently
                  order-agnostic \u2014 if you shuffle the words in a sentence, the
                  attention weights shuffle identically, producing the same
                  representations. To inject word order, Transformers add a",
                  tags$strong("positional encoding"), "to each token embedding before
                  computing Q, K, and V. The original Transformer (Vaswani et al., 2017)
                  used fixed sinusoidal encodings. Modern LLMs use learned rotary
                  position embeddings (RoPE) or ALiBi, which generalise better to
                  sequences longer than those seen during training."),
          guide = tags$ol(
            tags$li("Pick an example sentence or type your own."),
            tags$li("Each row = a query token; each column = a key token. Darker = higher weight."),
            tags$li("Lower temperature → sharper, more focused attention patterns."),
            tags$li("Change the head number to simulate different attention patterns.")
          )
        ),
        card(full_screen = TRUE,
             card_header("Self-Attention Weight Matrix"),
             plotlyOutput(ns("ai_attn_heatmap"), height = "440px"))
      )
    ),

    # ── Tab 3: Temperature & Sampling ─────────────────────────────────────────
    nav_panel(
      "Temperature & Sampling",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          selectInput(ns("ai_scenario"), "Prediction scenario",
                      choices = names(ai_scenarios)),
          tags$hr(),
          sliderInput(ns("ai_temp"), "Temperature", 0.1, 2.5, 1.0, 0.05),
          tags$hr(),
          sliderInput(ns("ai_topk"), "Top-k (0 = disabled)", 0, 10, 3, 1),
          sliderInput(ns("ai_topp"), "Top-p / nucleus (1.0 = disabled)", 0.5, 1.0, 0.9, 0.05)
        ),
        explanation_box(
          tags$strong("Temperature & Sampling Strategies"),
          tags$p("LLMs output a probability distribution over the vocabulary at each step.
                  Sampling strategies control how the next token is chosen from that
                  distribution — the choice profoundly affects output quality and creativity."),
          tags$ul(
            tags$li(tags$strong("Temperature"), " scales the logits before softmax.
                     T < 1: distribution sharpens (more predictable, repetitive).
                     T = 1: raw model probabilities. T > 1: distribution flattens
                     (more surprising, potentially incoherent)."),
            tags$li(tags$strong("Greedy"), " always picks the top token. Fast but
                     repetitive — models get stuck in loops."),
            tags$li(tags$strong("Top-k"), " restricts sampling to the k highest-probability
                     tokens. Prevents sampling very unlikely words."),
            tags$li(tags$strong("Top-p (nucleus)"), " samples from the smallest set whose
                     cumulative probability exceeds p. Adapts to the shape of the
                     distribution — narrower when one token dominates.")
          ),
          tags$p("Most production LLMs use top-p = 0.9 with temperature ≈ 0.7–1.0.
                  The greedy token is shown in green, top-k candidates in blue,
                  and the top-p nucleus is outlined."),
          tags$p("A fourth strategy not shown interactively here is",
                  tags$strong("beam search"), ": maintain the top-k most probable
                  partial sequences in parallel, expanding each at every step, and
                  return the highest-scoring complete sequence at the end.
                  Beam search is deterministic and coherent but tends toward generic,
                  high-frequency outputs \u2014 it dominated early neural machine translation
                  systems but was largely abandoned in open-ended LLM generation in
                  favour of stochastic sampling, which produces more varied and
                  natural-sounding text."),
          guide = tags$ol(
            tags$li("Choose a prediction scenario."),
            tags$li("Drag temperature and watch probabilities redistribute."),
            tags$li("Set top-k = 3 and top-p = 0.9 to see typical LLM settings.")
          )
        ),
        layout_column_wrap(
          width = 1,
          card(full_screen = TRUE,
               card_header("Next-Token Probability Distribution"),
               plotlyOutput(ns("ai_temp_dist"), height = "360px")),
          card(card_header("Cumulative Probability (for top-p)"),
               plotlyOutput(ns("ai_cum_dist"), height = "240px"))
        )
      )
    ),

    # ── Tab 4: Training & Scaling ─────────────────────────────────────────────
    nav_panel(
      "Training & Scaling",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          tags$p(class = "text-muted small",
            "Train a small neural network on a 2D classification task and
             watch the loss decrease and decision boundary form."),
          selectInput(ns("ai_dataset"), "Dataset",
            choices = c("XOR", "Circles", "Spirals")),
          sliderInput(ns("ai_hidden"), "Hidden units (network size)", 2, 64, 8, 2),
          sliderInput(ns("ai_epochs"), "Training epochs", 50, 500, 200, 50),
          actionButton(ns("ai_train"), "Train network",
                       icon = icon("play"), class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Training Dynamics & Scaling Laws"),
          tags$p("Every parameter in a neural network \u2014 and GPT-4 has an estimated
                  1.8 trillion \u2014 exists because gradient descent found a value that
                  reduces prediction error on training data. The process is
                  conceptually simple even at that scale: a", tags$strong("forward pass"),
                  "computes predictions and loss, a", tags$strong("backward pass"),
                  "(backpropagation) computes the gradient of that loss with respect
                  to every weight, and an", tags$strong("optimiser step"), "nudges each
                  weight in the direction that reduces the loss. Modern LLMs train
                  for weeks on thousands of GPUs, but each individual update follows
                  exactly the same mathematics shown here."),
          tags$p("Neural networks learn by minimising a loss function through
                  gradient descent. At each step, the gradient of the loss with
                  respect to each weight is computed via backpropagation, and
                  weights are nudged in the direction that reduces the loss."),
          tags$p("The", tags$strong("loss curve"), "shows how well the network
                  fits the training data over time. It typically drops steeply
                  early on and flattens as the network converges. A larger network
                  (more hidden units) can fit more complex boundaries but risks
                  overfitting if data is limited."),
          tags$p(tags$strong("Scaling laws"), "(Kaplan et al., 2020; Hoffmann et al., 2022)
                  show that LLM performance follows predictable power laws with
                  model size (parameters), dataset size (tokens), and compute
                  (FLOPs). This means you can extrapolate how much a larger model
                  will improve before training it — a crucial insight for planning
                  GPT-4 scale experiments. The Chinchilla paper (2022) showed that
                  most models are undertrained: optimal compute splits roughly
                  equally between parameters and training tokens."),
          guide = tags$ol(
            tags$li("Choose a dataset — Spirals are hardest; XOR is a classic non-linearity test."),
            tags$li("Increase hidden units: the decision boundary becomes more complex."),
            tags$li("Click Train and observe the loss curve and decision boundary."),
            tags$li("Compare the scaling chart: more parameters → lower loss, with diminishing returns.")
          )
        ),
        layout_column_wrap(
          width = 1,
          layout_column_wrap(
            width = 1 / 2,
            card(full_screen = TRUE,
                 card_header("Training Loss Curve"),
                 plotlyOutput(ns("ai_loss_curve"), height = "300px")),
            card(full_screen = TRUE,
                 card_header("Decision Boundary"),
                 plotlyOutput(ns("ai_boundary"), height = "300px"))
          ),
          card(full_screen = TRUE,
               card_header("Scaling Laws — Illustrative"),
               plotlyOutput(ns("ai_scaling"), height = "280px"))
        )
      )
    ),

    # ── Tab 5: Embeddings & Semantic Space ────────────────────────────────────
    nav_panel(
      "Embeddings",
      layout_sidebar(
        sidebar = sidebar(
          width = 310,
          tags$label(class = "form-label fw-bold", "Compare two words:"),
          div(class = "d-flex gap-2",
            textInput(ns("ai_w1"), NULL, value = "king",  width = "100%",
                      placeholder = "Word 1"),
            textInput(ns("ai_w2"), NULL, value = "queen", width = "100%",
                      placeholder = "Word 2")
          ),
          actionButton(ns("ai_sim_go"), "Compute similarity",
                       icon  = icon("arrows-left-right"),
                       class = "btn-primary w-100 mb-2"),
          tags$hr(),
          tags$label(class = "form-label fw-bold", "Nearest neighbors:"),
          textInput(ns("ai_nn_word"), NULL, value = "dog",
                    placeholder = "Enter any word\u2026"),
          sliderInput(ns("ai_nn_k"), "Top k", 3, 10, 5, 1),
          actionButton(ns("ai_nn_go"), "Find neighbors",
                       icon  = icon("circle-nodes"),
                       class = "btn-outline-primary w-100 mb-2"),
          tags$hr(),
          tags$label(class = "form-label fw-bold", "Show categories:"),
          checkboxGroupInput(ns("ai_embed_cats"), NULL,
            choices  = c("Royalty","People","Pets","Wildlife","Food",
                         "Technology","Countries","Sports","Emotions","Science"),
            selected = c("Royalty","People","Pets","Wildlife","Food",
                         "Technology","Countries","Sports","Emotions","Science"))
        ),
        div(
          explanation_box(
            tags$strong("Word Embeddings \u2014 Meaning as Geometry"),
            tags$p("The key insight behind every LLM is that words can be represented as
                    points in a high-dimensional vector space \u2014 typically 300 to 4,096
                    dimensions \u2014 where semantic similarity becomes geometric proximity.
                    This representation is called a ", tags$strong("word embedding"), "."),
            tags$p("Embeddings are learned, not hand-crafted. During training the model
                    adjusts each word\u2019s position so that words appearing in similar contexts
                    end up close together. \u2018dog\u2019 and \u2018cat\u2019 cluster near each other;
                    \u2018king\u2019 and \u2018queen\u2019 form a separate cluster; \u2018football\u2019 and
                    \u2018tennis\u2019 are far from both. Distance in the space encodes meaning."),
            tags$p("A famous property of good embeddings is that",
                   tags$strong("vector arithmetic preserves semantic relationships"),
                   ": king \u2212 man + woman \u2248 queen. The gender direction is consistent
                    across the space, as is the royalty direction. This geometry allows
                    models to reason by analogy."),
            tags$p("Because we cannot visualise 300+ dimensions, we use PCA to project
                    to 2D. This demo uses a toy vocabulary with pre-generated 2D coordinates
                    designed to show the clustering principle. Real embeddings are richer,
                    but the structure is the same."),
            guide = tags$ol(
              tags$li("Hover over any point to see the word label."),
              tags$li("Type two words and click Compute similarity \u2014 1.0 = identical direction, 0 = unrelated, \u22121 = opposite."),
              tags$li("Enter a word and click Find neighbors to see its closest words."),
              tags$li("Toggle categories to focus on specific clusters.")
            )
          ),
          layout_column_wrap(
            width = 1,
            card(full_screen = TRUE,
                 card_header("Word Embedding Space (2D Projection)"),
                 plotlyOutput(ns("ai_embed_plot"), height = "460px")),
            layout_column_wrap(
              width = 1 / 2,
              card(card_header("Cosine Similarity"),  uiOutput(ns("ai_sim_ui"))),
              card(card_header("Nearest Neighbors"), tableOutput(ns("ai_nn_table")))
            )
          )
        )
      )
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
}

ai_models_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  stop_words <- c("a","an","the","and","or","but","in","on","at","to","for",
                   "of","is","it","as","be","by","was","are","with","from",
                   "that","this","his","her","their","our","we","he","she",
                   "they","you","i","me","my","your","its","do","did","has",
                   "have","had","not","so","if","up","out","about","into",
                   "would","could","will","can","just","what","how","who")

  # ── Tab 1: Tokenization ─────────────────────────────────────────────────────
  tokens_r <- reactive({
    req(input$ai_text)
    toks <- ai_tokenize(input$ai_text)
    if (input$ai_lower) toks <- tolower(toks)
    if (input$ai_stop)  toks <- toks[!toks %in% stop_words]
    toks
  })

  output$ai_token_chips <- renderUI({
    toks <- tokens_r()
    if (length(toks) == 0) return(tags$p(class="text-muted", "No tokens yet."))
    freq <- table(toks)
    max_f <- max(freq)
    chips <- lapply(toks, function(t) {
      f   <- as.integer(freq[t])
      alp <- 0.25 + 0.75 * (f - 1) / max(max_f - 1, 1)
      tags$span(
        t,
        style = sprintf(
          paste0("display:inline-block;margin:3px;padding:3px 8px;border-radius:12px;",
                 "font-size:0.85rem;background:rgba(38,139,210,%.2f);",
                 "color:%s;border:1px solid rgba(38,139,210,0.5);"),
          alp, if (alp > 0.5) "#fdf6e3" else "#073642"
        ),
        title = paste0(t, " (×", f, ")")
      )
    })
    div(style = "line-height:2.2;", tagList(chips))
  })

  output$ai_token_freq <- renderPlotly({
    toks <- tokens_r()
    if (length(toks) == 0) return(plotly_empty())
    freq <- sort(table(toks), decreasing = TRUE)
    df   <- data.frame(token = names(freq), n = as.integer(freq),
                       stringsAsFactors = FALSE)
    df   <- head(df, 25)
    plot_ly(df, x = ~n, y = ~reorder(token, n), type = "bar",
            orientation = "h",
            marker = list(color = "#268bd2")) |>
      layout(
        xaxis = list(title = "Count"),
        yaxis = list(title = ""),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83"), margin = list(l = 10)
      )
  })

  output$ai_token_stats <- renderUI({
    toks <- tokens_r()
    raw  <- ai_tokenize(input$ai_text)
    uniq <- length(unique(toks))
    tags$table(
      class = "table table-sm",
      tags$tbody(
        tags$tr(tags$td("Total tokens"), tags$td(class="fw-bold", length(raw))),
        tags$tr(tags$td("After filtering"), tags$td(length(toks))),
        tags$tr(tags$td("Unique types"),  tags$td(class="fw-bold text-primary", uniq)),
        tags$tr(tags$td("Type/token ratio"),
                tags$td(sprintf("%.2f", uniq / max(length(toks), 1)))),
        tags$tr(tags$td("Characters"),
                tags$td(nchar(input$ai_text))),
        tags$tr(tags$td("Avg token length"),
                tags$td(sprintf("%.1f", mean(nchar(toks)))))
      )
    )
  })

  # ── Tab 2: BPE Tokenizer ────────────────────────────────────────────────────
  bpe_r <- eventReactive(input$bpe_run, {
    req(nzchar(trimws(input$bpe_text)))
    bpe_run(input$bpe_text, n_merges = as.integer(input$bpe_merges))
  })

  output$bpe_table <- renderTable({
    res <- bpe_r()
    req(res)
    if (length(res$log) == 0)
      return(data.frame(Message = "No merges \u2014 try more steps or longer text."))
    do.call(rbind, lapply(res$log, function(r) as.data.frame(r, stringsAsFactors = FALSE)))
  }, striped = TRUE, hover = TRUE, bordered = FALSE)

  output$bpe_vocab_plot <- renderPlotly({
    res <- bpe_r()
    req(res)
    df  <- data.frame(step   = seq_along(res$tcounts) - 1L,
                      tokens = res$tcounts)
    plot_ly(df, x = ~step, y = ~tokens,
            type = "scatter", mode = "lines+markers",
            line   = list(color = "#268bd2", width = 2),
            marker = list(color = "#268bd2", size = 7),
            hovertemplate = "Step %{x}<br>Total tokens: %{y}<extra></extra>") |>
      layout(
        xaxis = list(title = "Merge step"),
        yaxis = list(title = "Total tokens in corpus"),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  output$bpe_tokens_ui <- renderUI({
    res <- bpe_r()
    req(res)
    req(length(res$final) > 0)
    items <- lapply(seq_along(res$final), function(i) {
      segs  <- gsub("</w>", "", res$final[[i]])
      chips <- lapply(segs, function(s) {
        tags$span(
          s,
          style = paste0(
            "display:inline-block;margin:2px 3px;padding:2px 8px;",
            "border-radius:4px;font-size:0.83rem;font-family:monospace;",
            "background:rgba(38,139,210,0.15);",
            "border:1px solid rgba(38,139,210,0.35);"
          )
        )
      })
      tags$div(
        class = "d-flex align-items-center gap-2 mb-1",
        tags$span(class = "fw-bold",
                  style = "min-width:100px;font-size:0.85rem;font-family:monospace;",
                  names(res$final)[i]),
        tags$span("\u2192", class = "text-muted"),
        tagList(chips),
        tags$span(class = "text-muted small",
                  sprintf("\u00d7%d", res$freq[i]))
      )
    })
    div(style = "max-height: 320px; overflow-y: auto; padding-top: 4px;",
        tagList(items))
  })

  # ── Tab 3: Attention ────────────────────────────────────────────────────────
  attn_tokens_r <- reactive({
    sent <- if (nchar(trimws(input$ai_custom_sent)) > 3)
               input$ai_custom_sent else input$ai_sent
    toks <- strsplit(trimws(sent), "\\s+")[[1]]
    toks[nchar(toks) > 0][seq_len(min(length(toks), 14))]
  })

  output$ai_attn_heatmap <- renderPlotly({
    toks <- attn_tokens_r()
    req(length(toks) >= 2)
    temp <- input$ai_attn_temp
    head <- input$ai_attn_head

    set.seed(head * 13)
    attn <- ai_compute_attention(toks, temp)
    # Add head-specific noise to simulate different heads
    noise <- matrix(abs(rnorm(length(attn), 0, 0.08 * (head - 1))),
                    nrow = nrow(attn))
    attn <- t(apply(attn + noise, 1, function(r) ai_softmax(r, temp)))

    n    <- length(toks)
    toks_rev <- rev(toks)

    plot_ly(
      x = toks, y = toks_rev,
      z = attn[n:1, ],
      type = "heatmap",
      colorscale = list(c(0,"#002b36"), c(0.4,"#073642"),
                        c(0.7,"#268bd2"), c(1,"#2aa198")),
      hovertemplate = "Query: %{y}<br>Key: %{x}<br>Weight: %{z:.3f}<extra></extra>",
      xgap = 2, ygap = 2,
      showscale = TRUE
    ) |>
      layout(
        xaxis = list(title = "Key (token attended to)",
                     tickangle = -30, tickfont = list(size = 12)),
        yaxis = list(title = "Query (token attending)",
                     tickfont = list(size = 12)),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83"),
        annotations = list(list(
          x = 0.5, y = 1.07, xref = "paper", yref = "paper",
          text = sprintf("Head %d | Temp = %.1f", head, temp),
          showarrow = FALSE, font = list(size = 12, color = "#93a1a1")
        ))
      )
  })

  # ── Tab 3: Temperature & Sampling ───────────────────────────────────────────
  sampling_r <- reactive({
    sc     <- ai_scenarios[[input$ai_scenario]]
    tokens <- sc$tokens
    logits <- sc$logits
    temp   <- input$ai_temp
    k      <- input$ai_topk
    p      <- input$ai_topp

    probs  <- ai_softmax(logits, temp)
    ord    <- order(probs, decreasing = TRUE)

    # top-k mask
    in_topk <- if (k > 0) seq_along(probs) %in% ord[seq_len(min(k, length(probs)))]
               else rep(TRUE, length(probs))

    # top-p mask
    cum_probs <- cumsum(probs[ord])
    topk_idx  <- ord[cum_probs <= p]
    if (length(topk_idx) == 0) topk_idx <- ord[1]
    in_topp   <- seq_along(probs) %in% topk_idx

    list(tokens = tokens, logits = logits, probs = probs,
         in_topk = in_topk, in_topp = in_topp, ord = ord)
  })

  output$ai_temp_dist <- renderPlotly({
    s      <- sampling_r()
    tokens <- s$tokens
    probs  <- s$probs
    ord    <- order(probs, decreasing = TRUE)

    colors <- sapply(seq_along(tokens), function(i) {
      if (i == ord[1])   "#2aa198"      # greedy (top)
      else if (s$in_topk[i] && s$in_topp[i]) "#268bd2"   # in both
      else if (s$in_topk[i]) "#6c71c4"  # top-k only
      else if (s$in_topp[i]) "#859900"  # top-p only
      else "#586e75"                     # excluded
    })

    df <- data.frame(
      token = tokens, prob = probs, color = colors,
      stringsAsFactors = FALSE
    )
    df <- df[order(df$prob, decreasing = TRUE), ]

    plot_ly(df, x = ~prob, y = ~reorder(token, prob),
            type = "bar", orientation = "h",
            marker = list(color = df$color)) |>
      layout(
        xaxis = list(title = "Probability", tickformat = ".0%", range = c(0, 1)),
        yaxis = list(title = ""),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83"),
        annotations = list(
          list(x=0.98, y=0.98, xref="paper", yref="paper", showarrow=FALSE,
               align="right", font=list(size=11, color="#93a1a1"),
               text=paste0(
                 "<b style='color:#2aa198'>■</b> Greedy  ",
                 "<b style='color:#268bd2'>■</b> top-k & top-p  ",
                 "<b style='color:#859900'>■</b> top-p only  ",
                 "<b style='color:#586e75'>■</b> excluded"
               ))
        )
      )
  })

  output$ai_cum_dist <- renderPlotly({
    s      <- sampling_r()
    probs  <- s$probs
    ord    <- order(probs, decreasing = TRUE)
    cum    <- cumsum(probs[ord])
    p_thr  <- input$ai_topp

    df <- data.frame(
      rank  = seq_along(cum),
      token = s$tokens[ord],
      cum   = cum
    )

    plot_ly(df, x = ~rank, y = ~cum, type = "scatter", mode = "lines+markers",
            text = ~token,
            hovertemplate = "#%{x}: %{text}<br>Cumulative p = %{y:.3f}<extra></extra>",
            line = list(color = "#268bd2", width = 2),
            marker = list(color = "#268bd2", size = 7)) |>
      add_segments(x = 1, xend = length(cum), y = p_thr, yend = p_thr,
                   line = list(color = "#dc322f", dash = "dash", width = 1.5),
                   name = sprintf("p = %.2f", p_thr), inherit = FALSE) |>
      layout(
        xaxis = list(title = "Token rank (by probability)"),
        yaxis = list(title = "Cumulative probability", range = c(0, 1.05),
                     tickformat = ".0%"),
        showlegend = FALSE,
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  # ── Tab 4: Training & Scaling ────────────────────────────────────────────────
  trained_r <- eventReactive(input$ai_train, {
    dt     <- input$ai_dataset
    hidden <- input$ai_hidden
    epochs <- input$ai_epochs

    df <- ai_generate_data(dt, n = 300)

    fit <- nnet::nnet(
      y ~ x1 + x2, data = df, size = hidden,
      maxit = epochs, trace = FALSE, decay = 0.005,
      MaxNWts = 5000
    )

    # Decision boundary grid
    rng1 <- range(df$x1);  rng2 <- range(df$x2)
    pad  <- 0.2
    g1   <- seq(rng1[1] - pad, rng1[2] + pad, length.out = 120)
    g2   <- seq(rng2[1] - pad, rng2[2] + pad, length.out = 120)
    grid <- expand.grid(x1 = g1, x2 = g2)
    grid$pred <- as.numeric(predict(fit, grid, type = "class"))

    loss_df <- data.frame(
      epoch = seq_len(epochs),
      loss  = ai_sim_loss(epochs, hidden, dt)
    )

    list(df = df, grid = grid, loss_df = loss_df,
         g1 = g1, g2 = g2, fit = fit)
  })

  output$ai_loss_curve <- renderPlotly({
    res <- trained_r()
    req(res)
    plot_ly(res$loss_df, x = ~epoch, y = ~loss,
            type = "scatter", mode = "lines",
            line = list(color = "#268bd2", width = 2)) |>
      layout(
        xaxis = list(title = "Epoch"),
        yaxis = list(title = "Training loss", rangemode = "tozero"),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  output$ai_boundary <- renderPlotly({
    res <- trained_r()
    req(res)
    df  <- res$df
    g   <- res$grid

    n1 <- length(res$g1);  n2 <- length(res$g2)
    z  <- matrix(g$pred, nrow = n2, ncol = n1)

    col0 <- df[df$y == "0", ];  col1 <- df[df$y == "1", ]

    plot_ly() |>
      add_heatmap(x = res$g1, y = res$g2, z = z,
                  colorscale = list(c(0,"#073642"), c(1,"#268bd2")),
                  showscale = FALSE, opacity = 0.55) |>
      add_markers(data = col0, x = ~x1, y = ~x2, name = "Class 0",
                  marker = list(color = "#2aa198", size = 5, opacity = 0.8)) |>
      add_markers(data = col1, x = ~x1, y = ~x2, name = "Class 1",
                  marker = list(color = "#dc322f", size = 5, opacity = 0.8)) |>
      layout(
        xaxis = list(title = "x₁"),
        yaxis = list(title = "x₂"),
        legend = list(orientation = "h", y = -0.18),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        font = list(color = "#657b83")
      )
  })

  output$ai_scaling <- renderPlotly({
    params <- 10^seq(6, 12, length.out = 200)

    # Loss as function of parameters N and training tokens D
    # Simplified power-law form inspired by Kaplan et al. (2020) & Chinchilla (2022)
    # L(N, D) = A·N^(-α) + B·D^(-β) + L0  (schematic constants, not exact fits)
    loss_fn <- function(N, D) {
      6.944 * N^(-0.079) + 177.5 * D^(-0.268) + 1.8
    }

    # Models: (N = parameters, D = training tokens used)
    models <- list(
      list(name = "GPT-2 (117M, ~100B tokens)",   N = 117e6, D = 1e11),
      list(name = "GPT-3 (175B, ~300B tokens)",   N = 175e9, D = 3e11),
      list(name = "Chinchilla (70B, ~1.4T tokens)",N = 70e9,  D = 1.4e12),
      list(name = "GPT-4 (~1T, ~2T tokens est.)", N = 1e12,  D = 2e12)
    )

    # Three training-data lines
    datasets  <- c(1e10, 1e11, 1e12)
    ds_labels <- c("10B training tokens", "100B training tokens", "1T training tokens")
    ds_colors <- c("#586e75", "#268bd2", "#2aa198")

    p <- plot_ly()
    for (i in seq_along(datasets)) {
      p <- add_lines(p, x = params, y = loss_fn(params, datasets[i]),
                     name = ds_labels[i],
                     line = list(color = ds_colors[i], width = 2))
    }
    for (m in models) {
      p <- add_markers(p, x = m$N, y = loss_fn(m$N, m$D),
                       name = m$name,
                       marker = list(size = 11, symbol = "diamond"),
                       text  = m$name,
                       hovertemplate = paste0("%{text}<br>Loss: %{y:.2f}<extra></extra>"))
    }

    layout(p,
      xaxis = list(title = "Model parameters", type = "log",
                   tickvals = 10^c(6,7,8,9,10,11,12),
                   ticktext = c("1M","10M","100M","1B","10B","100B","1T")),
      yaxis = list(title = "Loss (lower = better)", range = c(2.0, 4.6)),
      legend = list(orientation = "h", y = -0.30, font = list(size = 10)),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = "#657b83"),
      annotations = list(list(
        x = 0.5, y = 1.06, xref = "paper", yref = "paper", showarrow = FALSE,
        font = list(size = 11, color = "#93a1a1"),
        text = "Schematic inspired by Kaplan et al. (2020) & Hoffmann et al. (2022)"
      ))
    )
  })

  # ── Tab 5: Embeddings ────────────────────────────────────────────────────────

  embed_df_r <- reactive({
    cats <- input$ai_embed_cats
    if (is.null(cats) || length(cats) == 0) .ai_embeddings
    else .ai_embeddings[.ai_embeddings$category %in% cats, ]
  })

  output$ai_embed_plot <- renderPlotly({
    df  <- embed_df_r()
    req(nrow(df) > 0)
    w1  <- trimws(tolower(input$ai_w1))
    w2  <- trimws(tolower(input$ai_w2))
    sel <- intersect(c(w1, w2), df$word)

    cat_cols <- c(
      Royalty    = "#268bd2", People     = "#2aa198", Pets       = "#859900",
      Wildlife   = "#b58900", Food       = "#cb4b16", Technology = "#6c71c4",
      Countries  = "#d33682", Sports     = "#dc322f", Emotions   = "#93a1a1",
      Science    = "#586e75"
    )

    base <- df[!df$word %in% sel, ]

    p <- plot_ly(base,
      x = ~x, y = ~y, text = ~word,
      color  = ~category, colors = cat_cols,
      type   = "scatter", mode = "markers",
      marker = list(size = 9, opacity = 0.82),
      hovertemplate = "<b>%{text}</b><extra></extra>"
    )

    if (length(sel) > 0) {
      hi <- df[df$word %in% sel, ]
      p  <- add_markers(p, data = hi, x = ~x, y = ~y, text = ~word,
                        name = "Selected", inherit = FALSE,
                        marker = list(color = "#dc322f", size = 16,
                                      symbol = "star",
                                      line   = list(color = "white", width = 2)),
                        hovertemplate = "<b>%{text}</b> \u2605<extra></extra>")
    }

    layout(p,
      xaxis = list(title = "Embedding dim 1",
                   zeroline = FALSE, showgrid = FALSE, showticklabels = FALSE),
      yaxis = list(title = "Embedding dim 2",
                   zeroline = FALSE, showgrid = FALSE, showticklabels = FALSE),
      legend  = list(orientation = "h", y = -0.22, font = list(size = 10)),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = "#657b83")
    )
  })

  sim_result_r <- eventReactive(input$ai_sim_go, {
    w1 <- trimws(tolower(input$ai_w1))
    w2 <- trimws(tolower(input$ai_w2))
    e  <- .ai_embeddings
    r1 <- e[e$word == w1, c("x", "y")]
    r2 <- e[e$word == w2, c("x", "y")]
    miss <- c(if (nrow(r1) == 0) w1, if (nrow(r2) == 0) w2)
    if (length(miss) > 0)
      return(list(error = paste("Not in vocabulary:", paste(miss, collapse = ", "))))
    s  <- ai_cosine_sim_2d(unlist(r1), unlist(r2))
    list(w1 = w1, w2 = w2, sim = s,
         c1 = e$category[e$word == w1],
         c2 = e$category[e$word == w2])
  })

  output$ai_sim_ui <- renderUI({
    res <- sim_result_r()
    if (!is.null(res$error))
      return(div(class = "alert alert-warning mt-1",
                 icon("triangle-exclamation"), " ", res$error))
    s     <- res$sim
    theme <- if (s > 0.7) "success" else if (s > 0.3) "primary" else if (s > 0) "info" else "warning"
    tagList(
      value_box(
        title    = paste0("\u201c", res$w1, "\u201d  vs  \u201c", res$w2, "\u201d"),
        value    = sprintf("%.3f", s),
        showcase = icon("arrows-left-right"),
        theme    = theme,
        height   = "130px",
        p(class = "small", sprintf("Categories: %s / %s", res$c1, res$c2))
      ),
      tags$p(class = "text-muted small mt-2",
        "Cosine similarity \u2014 1.0 = identical direction, 0 = orthogonal, \u22121 = opposite.")
    )
  })

  nn_result_r <- eventReactive(input$ai_nn_go, {
    word <- trimws(tolower(input$ai_nn_word))
    e    <- .ai_embeddings
    if (!word %in% e$word)
      return(list(error = paste("Not in vocabulary:", word)))
    v    <- unlist(e[e$word == word, c("x", "y")])
    sims <- sapply(seq_len(nrow(e)), function(i) {
      if (e$word[i] == word) return(-Inf)
      ai_cosine_sim_2d(v, unlist(e[i, c("x", "y")]))
    })
    top <- order(sims, decreasing = TRUE)[seq_len(input$ai_nn_k)]
    list(
      word  = word,
      table = data.frame(
        Neighbor   = e$word[top],
        Category   = e$category[top],
        Similarity = sprintf("%.3f", sims[top]),
        stringsAsFactors = FALSE
      )
    )
  })

  output$ai_nn_table <- renderTable({
    res <- nn_result_r()
    if (!is.null(res$error)) return(data.frame(Message = res$error))
    res$table
  }, striped = TRUE, hover = TRUE, bordered = FALSE)
  })
}
