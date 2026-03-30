# ===========================================================================
# Module: Game Theory Games
# ===========================================================================

# ── Payoff matrices for classic games ──────────────────────────────────
game_payoffs <- list(
  "Prisoner's Dilemma" = list(
    row_labels = c("Cooperate", "Defect"),
    col_labels = c("Cooperate", "Defect"),
    p1 = matrix(c(3, 0, 5, 1), nrow = 2, byrow = TRUE),
    p2 = matrix(c(3, 5, 0, 1), nrow = 2, byrow = TRUE),
    desc = paste(
      "<b>The Scenario:</b> Two suspects are arrested and interrogated separately.",
      "Each can either <em>Cooperate</em> (stay silent) or <em>Defect</em> (betray the other).",
      "If both stay silent, they each get a light sentence (3 points).",
      "If one betrays while the other stays silent, the betrayer goes free (5 points)",
      "and the silent one gets a harsh sentence (0 points).",
      "If both betray, they each get a moderate sentence (1 point).",
      "<br><br><b>The Dilemma:</b> No matter what the other player does, defecting always gives",
      "a higher individual payoff (5 > 3 if the other cooperates; 1 > 0 if the other defects).",
      "So <em>Defect</em> is a <b>dominant strategy</b> for both players.",
      "The unique Nash equilibrium is (Defect, Defect) with payoffs (1, 1) \u2014 even though",
      "(Cooperate, Cooperate) with payoffs (3, 3) would be better for both.",
      "This tension between individual rationality and collective welfare is the heart of the dilemma.",
      "<br><br><b>Real-world examples:</b> Arms races between nations, firms competing on price,",
      "environmental pollution (each firm benefits from polluting, but all suffer if everyone pollutes),",
      "and open-source contribution (everyone benefits from shared code, but each is tempted to free-ride)."
    )
  ),
  "Chicken (Hawk-Dove)" = list(
    row_labels = c("Swerve", "Straight"),
    col_labels = c("Swerve", "Straight"),
    p1 = matrix(c(3, 1, 5, 0), nrow = 2, byrow = TRUE),
    p2 = matrix(c(3, 5, 1, 0), nrow = 2, byrow = TRUE),
    desc = paste(
      "<b>The Scenario:</b> Two drivers race toward each other on a narrow road.",
      "Each can <em>Swerve</em> (yield) or go <em>Straight</em> (dare).",
      "If both swerve, they share a moderate outcome with mutual respect (3, 3).",
      "If one swerves and the other goes straight, the daring driver wins big (5 points)",
      "while the swerving driver looks weak (1 point).",
      "If both go straight, they crash \u2014 the worst outcome for both (0, 0).",
      "<br><br><b>The Strategy:</b> Unlike the Prisoner\u2019s Dilemma, there is no dominant strategy.",
      "The best choice depends on what the other player does.",
      "There are <b>two pure-strategy Nash equilibria</b>: (Swerve, Straight) and (Straight, Swerve) \u2014",
      "one player yields, the other doesn\u2019t. There is also a <b>mixed-strategy equilibrium</b>",
      "where each player randomises between swerving and going straight.",
      "The game highlights the problem of <em>anti-coordination</em>: both players want to do the",
      "opposite of the other.",
      "<br><br><b>Also known as:</b> The Hawk-Dove game in evolutionary biology (Maynard Smith, 1982),",
      "where Hawks fight and Doves share. Applications include territorial disputes,",
      "corporate brinkmanship, and nuclear deterrence strategy."
    )
  ),
  "Battle of the Sexes" = list(
    row_labels = c("Opera", "Football"),
    col_labels = c("Opera", "Football"),
    p1 = matrix(c(3, 0, 0, 2), nrow = 2, byrow = TRUE),
    p2 = matrix(c(2, 0, 0, 3), nrow = 2, byrow = TRUE),
    desc = paste(
      "<b>The Scenario:</b> Two partners want to spend the evening together but prefer different",
      "activities. Player 1 prefers the <em>Opera</em> and Player 2 prefers <em>Football</em>.",
      "If they coordinate on Opera, Player 1 gets 3 and Player 2 gets 2.",
      "If they coordinate on Football, Player 1 gets 2 and Player 2 gets 3.",
      "If they go to different events, both get 0 (the misery of a lonely evening).",
      "<br><br><b>The Strategy:</b> Both players prefer coordination over miscoordination,",
      "but they disagree on <em>which</em> coordinated outcome is better.",
      "There are <b>two pure-strategy Nash equilibria</b>: (Opera, Opera) and (Football, Football).",
      "Neither player wants to deviate unilaterally from either coordinated outcome.",
      "There is also a <b>mixed-strategy equilibrium</b> where each player randomises,",
      "but this results in frequent miscoordination and lower expected payoffs.",
      "<br><br><b>Real-world examples:</b> Technology standards (VHS vs. Betamax, USB-C vs. Lightning),",
      "international trade agreements where countries prefer different terms but both prefer",
      "agreement over no agreement, and any situation where coordination matters more than",
      "the specific coordinated choice."
    )
  ),
  "Stag Hunt" = list(
    row_labels = c("Stag", "Hare"),
    col_labels = c("Stag", "Hare"),
    p1 = matrix(c(4, 0, 3, 3), nrow = 2, byrow = TRUE),
    p2 = matrix(c(4, 3, 0, 3), nrow = 2, byrow = TRUE),
    desc = paste(
      "<b>The Scenario:</b> Two hunters go into the forest. They can cooperate to hunt a <em>Stag</em>",
      "(which requires both hunters working together) or independently hunt a <em>Hare</em>.",
      "A stag provides a large meal (4 points each if both hunt stag).",
      "A hare provides a smaller but guaranteed meal (3 points, regardless of what the other does).",
      "If you hunt stag alone while the other hunts hare, you get nothing (0 points).",
      "<br><br><b>The Strategy:</b> There are <b>two pure-strategy Nash equilibria</b>:",
      "(Stag, Stag) is <b>payoff-dominant</b> \u2014 it gives the highest total payoff.",
      "(Hare, Hare) is <b>risk-dominant</b> \u2014 it is the safe choice that guarantees 3",
      "regardless of the other player\u2019s action.",
      "The central tension is between trust and safety: hunting stag is optimal <em>if</em> you",
      "trust your partner, but hunting hare protects you against betrayal.",
      "<br><br><b>Key concept:</b> The Stag Hunt models <em>social trust and cooperation</em>.",
      "Unlike the Prisoner\u2019s Dilemma, cooperation (Stag, Stag) <em>is</em> a Nash equilibrium \u2014",
      "the challenge is whether players can coordinate on it rather than falling back to the",
      "safe but inferior outcome. This is Rousseau\u2019s original parable about the foundations",
      "of social cooperation."
    )
  ),
  "Matching Pennies" = list(
    row_labels = c("Heads", "Tails"),
    col_labels = c("Heads", "Tails"),
    p1 = matrix(c(1, -1, -1, 1), nrow = 2, byrow = TRUE),
    p2 = matrix(c(-1, 1, 1, -1), nrow = 2, byrow = TRUE),
    desc = paste(
      "<b>The Scenario:</b> Two players simultaneously reveal a coin showing <em>Heads</em> or <em>Tails</em>.",
      "Player 1 (the Matcher) wins if the coins match; Player 2 (the Mismatcher) wins if they differ.",
      "The winner gains 1 point; the loser loses 1 point.",
      "This is a <b>zero-sum game</b>: one player\u2019s gain is exactly the other\u2019s loss.",
      "<br><br><b>The Strategy:</b> There is <b>no pure-strategy Nash equilibrium</b>.",
      "If Player 1 always plays Heads, Player 2 will play Tails; but then Player 1 should switch",
      "to Tails, and so on. Any predictable pattern can be exploited.",
      "The unique Nash equilibrium is in <b>mixed strategies</b>: each player randomises 50/50.",
      "At this equilibrium, neither player can gain an edge and the expected payoff is 0 for both.",
      "<br><br><b>Real-world examples:</b> Penalty kicks in football (goalkeeper vs. kicker),",
      "military strategy (attacker vs. defender choosing locations), tax auditing (authority",
      "randomly audits, taxpayer randomly evades), and any adversarial situation where",
      "predictability is exploitable."
    )
  )
)

# ── Strategy functions for opponent in classic games ──────────────────
opponent_choice <- function(strategy, history_opp, history_me) {
  n <- length(history_me)
  switch(strategy,
    "always1" = 1L,
    "always2" = 2L,
    "copy"    = if (n == 0) 1L else history_me[n],
    "random"  = sample(1:2, 1),
    1L
  )
}

# ── IPD strategy functions (return 1 = C, 2 = D) ─────────────────────
ipd_strategies <- list(
  "Tit-for-Tat" = function(my_hist, opp_hist) {
    if (length(opp_hist) == 0) return(1L)
    opp_hist[length(opp_hist)]
  },
  "Always Cooperate" = function(my_hist, opp_hist) 1L,
  "Always Defect" = function(my_hist, opp_hist) 2L,
  "Grudger" = function(my_hist, opp_hist) {
    if (any(opp_hist == 2)) 2L else 1L
  },
  "Pavlov" = function(my_hist, opp_hist) {
    if (length(my_hist) == 0) return(1L)
    last_my <- my_hist[length(my_hist)]
    last_opp <- opp_hist[length(opp_hist)]
    if (last_my == last_opp) 1L else 2L
  },
  "Random" = function(my_hist, opp_hist) sample(1:2, 1),
  "Tit-for-Two-Tats" = function(my_hist, opp_hist) {
    n <- length(opp_hist)
    if (n < 2) return(1L)
    if (opp_hist[n] == 2 && opp_hist[n - 1] == 2) 2L else 1L
  }
)

# ── UI ─────────────────────────────────────────────────────────────────
game_theory_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
  "Game Theory",
  icon = icon("chess"),
  navset_card_underline(

    # ================================================================
    # TAB 1: Classic 2x2 Games
    # ================================================================
    nav_panel("Classic Games",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("gt_game"), "Select game",
            choices = names(game_payoffs), selected = "Prisoner's Dilemma"),
          uiOutput(ns("gt_opponent_ui")),
          tags$hr(),
          tags$p(class = "fw-bold mb-2", "Your move:
"),
          layout_column_wrap(width = 1/2,
            actionButton(ns("gt_move1"), "Strategy 1", class = "btn-success w-100",
              style = "font-size: 0.78rem; padding: 6px 4px; white-space: nowrap;"),
            actionButton(ns("gt_move2"), "Strategy 2", class = "btn-danger w-100",
              style = "font-size: 0.78rem; padding: 6px 4px; white-space: nowrap;")
          ),
          uiOutput(ns("gt_move_labels")),
          tags$hr(),
          actionButton(ns("gt_reset"), "Reset game", icon = icon("rotate-left"),
                       class = "btn-outline-secondary w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Classic 2\u00d72 Games"),
          tags$p("Game theory studies strategic interactions where each player's
                  outcome depends on the choices of all players. A 2\u00d72 game is the
                  simplest form: two players, each with two strategies. The payoff
                  matrix shows the reward each player receives for every combination
                  of strategies."),
          tags$p("A Nash equilibrium is a pair of strategies where neither player
                  can improve their payoff by unilaterally changing strategy. Some
                  games have one Nash equilibrium (Prisoner's Dilemma), some have
                  two (Stag Hunt, Chicken), and some have none in pure strategies
                  (Matching Pennies). The tension between individual incentives and
                  collective welfare is the central theme of game theory."),
          tags$p("Play against the computer using different opponent strategies.
                  Notice how Tit-for-Tat (mirroring your last move) can sustain
                  cooperation, while Always Defect forces a race to the bottom."),
          guide = tags$ol(
            tags$li("Select a game and opponent strategy."),
            tags$li("Click your move — the payoff matrix highlights the outcome."),
            tags$li("Watch the cumulative score evolve over rounds."),
            tags$li("Try different strategies against Tit-for-Tat: consistent cooperation, occasional defection, or alternating.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(card_header("Payoff Matrix"), uiOutput(ns("gt_payoff_table"))),
          card(full_screen = TRUE, card_header("Cumulative Scores"),
               plotlyOutput(ns("gt_score_plot"), height = "400px"))
        ),
        card(card_header("Round Log"), tableOutput(ns("gt_log_table")))
      )
    ),

    # ================================================================
    # TAB 2: Nash Equilibrium Finder
    # ================================================================
    nav_panel("Nash Equilibrium",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$p(class = "fw-bold", "Player 1 payoffs (row player):"),
          layout_column_wrap(width = 1/2,
            numericInput(ns("gt_ne_a11"), "(1,1)", value = 3, width = "100%"),
            numericInput(ns("gt_ne_a12"), "(1,2)", value = 0, width = "100%"),
            numericInput(ns("gt_ne_a21"), "(2,1)", value = 5, width = "100%"),
            numericInput(ns("gt_ne_a22"), "(2,2)", value = 1, width = "100%")
          ),
          tags$p(class = "fw-bold mt-3", "Player 2 payoffs (column player):"),
          layout_column_wrap(width = 1/2,
            numericInput(ns("gt_ne_b11"), "(1,1)", value = 3, width = "100%"),
            numericInput(ns("gt_ne_b12"), "(1,2)", value = 5, width = "100%"),
            numericInput(ns("gt_ne_b21"), "(2,1)", value = 0, width = "100%"),
            numericInput(ns("gt_ne_b22"), "(2,2)", value = 1, width = "100%")
          ),
          tags$hr(),
          selectInput(ns("gt_ne_preset"), "Load preset",
            choices = c("Custom", names(game_payoffs)),
            selected = "Custom"),
          actionButton(ns("gt_ne_find"), "Find Equilibria", icon = icon("magnifying-glass"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Nash Equilibrium Finder"),
          tags$p("A Nash equilibrium is a strategy profile where no player benefits
                  from unilateral deviation. In a 2\u00d72 game, we check each cell: if
                  Player 1's payoff is the best in its column AND Player 2's payoff
                  is the best in its row, that cell is a pure-strategy Nash equilibrium."),
          tags$p("When no pure-strategy equilibrium exists (or in addition to pure ones),
                  players can randomize. A mixed-strategy Nash equilibrium specifies
                  probabilities for each strategy such that the opponent is indifferent.
                  The mixing probabilities are found by setting each player's expected
                  payoffs equal across their strategies."),
          tags$p("Every finite game has at least one Nash equilibrium (possibly in
                  mixed strategies) \u2014 this is Nash's famous existence theorem (1950).
                  Enter your own payoffs or load a classic game to explore."),
          guide = tags$ol(
            tags$li("Enter payoff values for both players in the 2\u00d72 matrix."),
            tags$li("Or load a preset game from the dropdown."),
            tags$li("Click 'Find Equilibria' to see pure and mixed-strategy NE."),
            tags$li("The best response plot shows each player's optimal mixing probability as a function of the opponent's mix.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(card_header("Payoff Matrix & Equilibria"), uiOutput(ns("gt_ne_matrix"))),
          card(full_screen = TRUE, card_header("Best Response Functions"),
               plotlyOutput(ns("gt_ne_br_plot"), height = "400px"))
        ),
        card(card_header("Equilibrium Analysis"), uiOutput(ns("gt_ne_summary")))
      )
    ),

    # ================================================================
    # TAB 3: Iterated PD Tournament
    # ================================================================
    nav_panel("IPD Tournament",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          checkboxGroupInput(ns("gt_ipd_strats"), "Strategies in tournament",
            choices = names(ipd_strategies),
            selected = c("Tit-for-Tat", "Always Cooperate", "Always Defect",
                         "Grudger", "Random")),
          sliderInput(ns("gt_ipd_rounds"), "Rounds per matchup",
                      min = 50, max = 500, value = 200, step = 50),
          actionButton(ns("gt_ipd_run"), "Run Tournament", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Iterated Prisoner\u2019s Dilemma Tournament"),
          tags$p("In the one-shot Prisoner's Dilemma, defection is the only rational
                  choice. But when the game is repeated, cooperation can emerge.
                  Robert Axelrod\u2019s famous computer tournaments (1984) showed that
                  Tit-for-Tat \u2014 a simple strategy that cooperates first and then
                  mirrors the opponent\u2019s last move \u2014 consistently outperformed more
                  complex strategies."),
          tags$p("Successful strategies tend to share four properties: they are
                  nice (never defect first), retaliatory (punish defection), forgiving
                  (return to cooperation after punishment), and clear (easy for
                  opponents to understand and adapt to). These findings have
                  implications for biology, economics, and international relations."),
          tags$p("Select strategies for a round-robin tournament. Each pair plays
                  the specified number of rounds. Payoffs: mutual cooperation = 3,
                  mutual defection = 1, temptation to defect = 5, sucker's payoff = 0."),
          guide = tags$ol(
            tags$li("Select at least 2 strategies."),
            tags$li("Set the number of rounds per matchup (more rounds favor cooperative strategies)."),
            tags$li("Click 'Run Tournament' to see final rankings and head-to-head results."),
            tags$li("Try removing or adding strategies to see how the ecosystem changes.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(full_screen = TRUE, card_header("Tournament Standings"),
               plotlyOutput(ns("gt_ipd_standings"), height = "400px")),
          card(full_screen = TRUE, card_header("Head-to-Head Results"),
               plotlyOutput(ns("gt_ipd_heatmap"), height = "400px"))
        ),
        card(card_header("Strategy Descriptions"), uiOutput(ns("gt_ipd_descriptions")))
      )
    ),

    # ================================================================
    # TAB 4: Evolutionary Dynamics
    # ================================================================
    nav_panel("Evolutionary Dynamics",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          selectInput(ns("gt_evo_game"), "Game",
            choices = c("Prisoner's Dilemma", "Chicken (Hawk-Dove)", "Stag Hunt",
                        "Matching Pennies"),
            selected = "Chicken (Hawk-Dove)"),
          sliderInput(ns("gt_evo_p0"), "Initial proportion of Strategy 1",
                      min = 0.01, max = 0.99, value = 0.5, step = 0.01),
          sliderInput(ns("gt_evo_gens"), "Generations",
                      min = 50, max = 500, value = 200, step = 50),
          sliderInput(ns("gt_evo_speed"), "Selection intensity",
                      min = 0.1, max = 5, value = 1, step = 0.1),
          actionButton(ns("gt_evo_run"), "Simulate", icon = icon("play"),
                       class = "btn-success w-100 mt-2")
        ),
        explanation_box(
          tags$strong("Evolutionary Game Theory"),
          tags$p("Evolutionary game theory applies game-theoretic ideas to populations
                  of agents who are randomly matched to play a game. Instead of rational
                  deliberation, strategies spread through differential reproduction:
                  strategies that earn higher payoffs grow in frequency. This is captured
                  by the replicator equation, the fundamental dynamic of evolutionary
                  game theory."),
          tags$p("An Evolutionarily Stable Strategy (ESS) is a strategy that, once
                  adopted by most of the population, cannot be invaded by a rare mutant.
                  Not every Nash equilibrium is an ESS. In the Hawk-Dove game, the mixed
                  equilibrium is the ESS — pure populations of Hawks or Doves are both
                  invadable. In the Stag Hunt, both pure equilibria are Nash, but only
                  Hare-Hare is robust against small perturbations."),
          tags$p("Adjust the initial population mix and watch the replicator dynamics
                  converge (or cycle). The selection intensity controls how strongly
                  payoff differences translate into fitness differences."),
          guide = tags$ol(
            tags$li("Choose a game and set the initial proportion of Strategy 1."),
            tags$li("Run the simulation to see population dynamics over generations."),
            tags$li("In Chicken/Hawk-Dove, the population converges to the mixed ESS regardless of starting point."),
            tags$li("In Stag Hunt, the outcome depends on the initial proportion — there is a tipping point.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(full_screen = TRUE, card_header("Population Dynamics"),
               plotlyOutput(ns("gt_evo_dynamics"), height = "400px")),
          card(full_screen = TRUE, card_header("Phase Diagram"),
               plotlyOutput(ns("gt_evo_phase"), height = "400px"))
        ),
        card(card_header("Equilibrium Summary"), uiOutput(ns("gt_evo_summary")))
      )
    ),

    # ================================================================
    # TAB 5: Traveling Salesman Problem
    # ================================================================
    nav_panel("Traveling Salesman",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gt_tsp_n"), "Number of cities",
                      min = 5, max = 30, value = 10, step = 1),
          actionButton(ns("gt_tsp_generate"), "Generate Cities",
                       icon = icon("map-pin"), class = "btn-outline-primary w-100"),
          tags$hr(),
          selectInput(ns("gt_tsp_algo"), "Algorithm",
            choices = c("Nearest Neighbor", "2-Opt Improvement", "Random Tour"),
            selected = "Nearest Neighbor"),
          actionButton(ns("gt_tsp_solve"), "Solve", icon = icon("route"),
                       class = "btn-success w-100 mt-2"),
          actionButton(ns("gt_tsp_compare"), "Compare All", icon = icon("chart-bar"),
                       class = "btn-outline-info w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "The TSP asks: given a set of cities, what is the shortest tour that visits
             every city exactly once and returns to the start?")
        ),
        explanation_box(
          tags$strong("Traveling Salesman Problem"),
          tags$p("The Traveling Salesman Problem (TSP) is one of the most famous problems in
                  combinatorial optimisation and computer science. Given ", tags$em("n"), " cities,
                  the goal is to find the shortest route that visits every city exactly once
                  and returns to the starting city."),
          tags$p("TSP is ", tags$strong("NP-hard"), ": no known algorithm solves all instances
                  in polynomial time. The number of possible tours grows as (n\u22121)!/2 — for
                  just 20 cities, that's over 60 trillion routes. This combinatorial explosion
                  makes brute-force search infeasible for all but the smallest instances, so
                  we rely on heuristics and approximation algorithms."),
          tags$p(tags$strong("Nearest Neighbor:"), " Start at a random city, always travel to the nearest
                  unvisited city. Fast (O(n\u00b2)) but can produce poor tours — it tends to leave
                  long edges for the end."),
          tags$p(tags$strong("2-Opt Improvement:"), " Start with a tour (e.g., from NN) and iteratively
                  remove two edges and reconnect the segments if it shortens the tour. This
                  local search reliably improves initial solutions."),
          guide = tags$ol(
            tags$li("Set the number of cities and click 'Generate Cities' to place them randomly."),
            tags$li("Select an algorithm and click 'Solve' to see its tour."),
            tags$li("Click 'Compare All' to run all three algorithms and compare distances."),
            tags$li("Increase the number of cities to see how the algorithms' performance diverges.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(full_screen = TRUE, card_header("Tour Map"),
               plotlyOutput(ns("gt_tsp_map"), height = "450px")),
          card(card_header("Results"),
               uiOutput(ns("gt_tsp_results")))
        ),
        card(card_header("Algorithm Comparison"), tableOutput(ns("gt_tsp_comparison")))
      )
    ),

    # ================================================================
    # TAB 6: Stable Matching
    # ================================================================
    nav_panel("Stable Matching",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gt_sm_n"), "Number of pairs",
                      min = 3, max = 8, value = 4, step = 1),
          actionButton(ns("gt_sm_generate"), "Generate Preferences",
                       icon = icon("shuffle"), class = "btn-outline-primary w-100"),
          tags$hr(),
          radioButtons(ns("gt_sm_side"), "Who proposes?",
            choices = c("Group A proposes" = "A", "Group B proposes" = "B"),
            selected = "A"),
          actionButton(ns("gt_sm_run"), "Run Gale-Shapley", icon = icon("heart"),
                       class = "btn-success w-100 mt-2"),
          actionButton(ns("gt_sm_both"), "Compare Both Sides", icon = icon("arrows-left-right"),
                       class = "btn-outline-info w-100 mt-2"),
          tags$hr(),
          tags$p(class = "text-muted small",
            "The algorithm is guaranteed to find a stable matching where no unmatched
             pair would prefer each other over their assigned partners.")
        ),
        explanation_box(
          tags$strong("Stable Matching (Gale-Shapley)"),
          tags$p("The Stable Matching problem asks: given two groups of equal size, each member
                  with a ranked preference list over the other group, can we find a matching
                  where no unmatched pair both prefer each other over their assigned partners?
                  Such a pair would be a ", tags$strong("blocking pair"), ", and a matching with
                  no blocking pairs is called ", tags$strong("stable"), "."),
          tags$p("The ", tags$strong("Gale-Shapley algorithm"), " (1962) guarantees a stable matching
                  using deferred acceptance: proposers ask their top remaining choice; receivers
                  tentatively accept their best offer and reject the rest. The process repeats
                  until everyone is matched. It always terminates in at most n\u00b2 steps."),
          tags$p("A key insight: the algorithm is ", tags$strong("proposer-optimal"), " \u2014
                  every proposer gets the best partner they could have in ", tags$em("any"),
                  " stable matching, while receivers get their worst stable partner. Swapping
                  who proposes changes the outcome. Shapley and Roth won the 2012 Nobel Prize
                  in Economics for this work and its applications to school choice, kidney
                  exchange, and medical residency matching."),
          guide = tags$ol(
            tags$li("Set the number of pairs and click 'Generate Preferences' to create random preference lists."),
            tags$li("Choose which side proposes and click 'Run Gale-Shapley'."),
            tags$li("Read the step-by-step trace to see how the algorithm unfolds."),
            tags$li("Click 'Compare Both Sides' to see how the matching changes when the other side proposes.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(card_header("Group A Preferences"), tableOutput(ns("gt_sm_pref_a"))),
          card(card_header("Group B Preferences"), tableOutput(ns("gt_sm_pref_b")))
        ),
        card(card_header("Matching Result"), uiOutput(ns("gt_sm_result"))),
        card(card_header("Algorithm Trace"), uiOutput(ns("gt_sm_trace")))
      )
    ),

    # ================================================================
    # TAB 7: University Admission (many-to-one matching)
    # ================================================================
    nav_panel("University Admission",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          sliderInput(ns("gt_ua_nstu"), "Number of students",
                      min = 4, max = 20, value = 8, step = 1),
          sliderInput(ns("gt_ua_nuni"), "Number of universities",
                      min = 2, max = 6, value = 3, step = 1),
          sliderInput(ns("gt_ua_quota"), "Seats per university",
                      min = 1, max = 6, value = 3, step = 1),
          actionButton(ns("gt_ua_generate"), "Generate Preferences",
                       icon = icon("shuffle"), class = "btn-outline-primary w-100"),
          tags$hr(),
          radioButtons(ns("gt_ua_side"), "Who proposes?",
            choices = c("Students propose" = "students",
                        "Universities propose" = "universities"),
            selected = "students"),
          actionButton(ns("gt_ua_run"), "Run Gale-Shapley", icon = icon("graduation-cap"),
                       class = "btn-success w-100 mt-2"),
          actionButton(ns("gt_ua_both"), "Compare Both Sides", icon = icon("arrows-left-right"),
                       class = "btn-outline-info w-100 mt-2"),
          tags$hr(),
          uiOutput(ns("gt_ua_capacity_note"))
        ),
        explanation_box(
          tags$strong("University Admission (Many-to-One Matching)"),
          tags$p("University admission is the classic ", tags$strong("many-to-one matching"),
                 " problem: many students compete for limited seats at universities.
                  Each student ranks universities by preference, and each university
                  ranks applicants. Universities have a ", tags$strong("quota"),
                 " — the number of seats available."),
          tags$p("The Gale-Shapley algorithm extends naturally to this setting. In the
                  ", tags$strong("student-proposing"), " version, students apply to their
                  top-choice university; each university tentatively holds the best applicants
                  up to its quota, rejecting the rest. Rejected students apply to their next
                  choice. This produces a ", tags$strong("student-optimal stable matching"),
                 " — no student can improve by switching to a university that would also
                  prefer them."),
          tags$p("In the ", tags$strong("university-proposing"), " version, universities
                  make offers to their highest-ranked students. This yields a
                  ", tags$strong("university-optimal"), " result. The two versions can
                  produce very different outcomes, especially when competition is fierce."),
          tags$p("If total seats < total students, some students will be unmatched.
                  Real-world applications include the NRMP medical residency match (USA),
                  university admissions in Hungary and China, and school choice systems
                  in Boston, New York, and many other cities."),
          guide = tags$ol(
            tags$li("Set the number of students, universities, and seats per university."),
            tags$li("Click 'Generate Preferences' to create random rankings."),
            tags$li("Choose who proposes and click 'Run Gale-Shapley'."),
            tags$li("Click 'Compare Both Sides' to see how the outcome shifts depending on who proposes."),
            tags$li("Try setting total seats < students to see what happens when not everyone can be placed.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(card_header("Student Preferences"), tableOutput(ns("gt_ua_stu_prefs"))),
          card(card_header("University Preferences & Quotas"), tableOutput(ns("gt_ua_uni_prefs")))
        ),
        card(card_header("Matching Result"), uiOutput(ns("gt_ua_result"))),
        card(card_header("Algorithm Trace"), uiOutput(ns("gt_ua_trace")))
      )
    ),

    # ================================================================
    # TAB 8: Exam Timetabling
    # ================================================================
    nav_panel("Exam Timetabling",
      layout_sidebar(
        sidebar = sidebar(
          width = 300,
          tags$p(class = "fw-bold", icon("calendar-days"), " Phase 1: Schedule"),
          sliderInput(ns("gt_et_nmand"), "Mandatory subjects",
                      min = 2, max = 6, value = 3, step = 1),
          sliderInput(ns("gt_et_smand"), "Sessions per mandatory",
                      min = 2, max = 6, value = 4, step = 1),
          sliderInput(ns("gt_et_nelec"), "Elective subjects",
                      min = 0, max = 4, value = 2, step = 1),
          sliderInput(ns("gt_et_selec"), "Sessions per elective",
                      min = 1, max = 4, value = 2, step = 1),
          sliderInput(ns("gt_et_days"), "Available days",
                      min = 5, max = 25, value = 12, step = 1),
          sliderInput(ns("gt_et_gap"), "Min days between exams",
                      min = 1, max = 5, value = 3, step = 1),
          sliderInput(ns("gt_et_maxday"), "Max sessions per slot",
                      min = 1, max = 6, value = 1, step = 1),
          actionButton(ns("gt_et_solve"), "Generate & Solve",
                       icon = icon("wand-magic-sparkles"), class = "btn-success w-100"),
          tags$hr(),
          tags$p(class = "fw-bold", icon("users"), " Phase 2: Students"),
          sliderInput(ns("gt_et_nstu"), "Number of students",
                      min = 10, max = 200, value = 50, step = 10),
          sliderInput(ns("gt_et_estu"), "Electives per student",
                      min = 0, max = 3, value = 1, step = 1),
          actionButton(ns("gt_et_assign"), "Assign Students",
                       icon = icon("user-check"), class = "btn-outline-info w-100 mt-2"),
          uiOutput(ns("gt_et_stu_picker"))
        ),
        explanation_box(
          tags$strong("Exam Timetabling Problem"),
          tags$p("Exam timetabling is a classic ", tags$strong("NP-hard"), " constraint
                  satisfaction problem. Given a set of exam sessions to schedule over a
                  limited number of days, the goal is to assign each session to a time
                  slot while ensuring students have adequate rest between exams."),
          tags$p("The problem can be solved efficiently in ", tags$strong("two phases"), ":"),
          tags$p(tags$strong("Phase 1 \u2014 Graph colouring."), " Build a conflict graph
                  where each exam session is a node, and two nodes are connected if any
                  student could sit both. Mandatory subjects conflict with each other
                  (every student takes them all); electives conflict with mandatory exams.
                  The 'colours' are time slots (day + morning/afternoon). The constraint:
                  connected nodes must be at least ", tags$em("k"), " days apart.
                  A valid colouring = a valid schedule."),
          tags$p(tags$strong("Phase 2 \u2014 Assign students to sessions."), " Once the
                  timetable is fixed, distribute students across parallel sessions of each
                  subject. Because Phase 1 guarantees sufficient gaps, any assignment
                  automatically satisfies rest-day constraints."),
          tags$p("Real-world applications: university exam scheduling, standardised
                  test administration, conference session planning, and sports
                  tournament scheduling."),
          guide = tags$ol(
            tags$li("Configure subjects, sessions, days, and the minimum gap."),
            tags$li("Click 'Generate & Solve' \u2014 the greedy graph-colouring solver runs
                     automatically."),
            tags$li("Examine the conflict graph (connected = must be spaced apart) and
                     timetable calendar."),
            tags$li("Set student counts and click 'Assign Students' for Phase 2."),
            tags$li("Select a student to view their personal exam schedule and rest days.")
          )
        ),
        layout_column_wrap(width = 1/2,
          card(full_screen = TRUE, card_header("Timetable Calendar"),
               uiOutput(ns("gt_et_calendar"))),
          card(full_screen = TRUE, card_header("Conflict Graph"),
               plotlyOutput(ns("gt_et_graph"), height = "420px"))
        ),
        card(card_header("Solution Summary"), uiOutput(ns("gt_et_summary"))),
        card(card_header("Student Schedule"), uiOutput(ns("gt_et_student_view")))
      )
    )
  )
)
}

# ── Exam timetabling helpers (subject names / colours) ────────────────
et_mand_names <- c("Mathematics", "Physics", "Chemistry",
                    "Biology", "English", "History")
et_elec_names <- c("Art", "Music", "Computer Sci", "Economics")
et_abbrevs    <- c("Math", "Phys", "Chem", "Bio", "Eng", "Hist",
                    "Art", "Mus", "CS", "Econ")
et_colors     <- c("#b58900", "#cb4b16", "#dc322f", "#d33682",
                    "#6c71c4", "#268bd2", "#2aa198", "#859900",
                    "#93a1a1", "#657b83")

# ── Server ─────────────────────────────────────────────────────────────

game_theory_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  # ==================================================================
  # TAB 1: Classic Games
  # ==================================================================
  gt_history <- reactiveValues(
    p1_moves = integer(0), p2_moves = integer(0),
    p1_scores = numeric(0), p2_scores = numeric(0)
  )

  # Update button and opponent labels when game changes
  output$gt_move_labels <- renderUI({
    g <- game_payoffs[[input$gt_game]]
    tags$p(class = "text-muted small mt-2",
      paste0("Strategy 1 = ", g$row_labels[1], " | Strategy 2 = ", g$row_labels[2]))
  })

  output$gt_opponent_ui <- renderUI({
    g <- game_payoffs[[input$gt_game]]
    choices <- c(
      setNames("always1", paste0("Always ", g$col_labels[1])),
      setNames("always2", paste0("Always ", g$col_labels[2])),
      setNames("copy", "Copy Your Last Move"),
      setNames("random", "Random")
    )
    selectInput(session$ns("gt_opponent"), "Opponent strategy",
      choices = choices, selected = "copy")
  })

  observeEvent(input$gt_game, {
    gt_history$p1_moves <- integer(0)
    gt_history$p2_moves <- integer(0)
    gt_history$p1_scores <- numeric(0)
    gt_history$p2_scores <- numeric(0)
  })

  observeEvent(input$gt_reset, {
    gt_history$p1_moves <- integer(0)
    gt_history$p2_moves <- integer(0)
    gt_history$p1_scores <- numeric(0)
    gt_history$p2_scores <- numeric(0)
  })

  play_round <- function(my_move) {
    g <- game_payoffs[[input$gt_game]]
    opp <- opponent_choice(input$gt_opponent, gt_history$p2_moves, gt_history$p1_moves)
    gt_history$p1_moves <- c(gt_history$p1_moves, my_move)
    gt_history$p2_moves <- c(gt_history$p2_moves, opp)
    p1_pay <- g$p1[my_move, opp]
    p2_pay <- g$p2[my_move, opp]
    gt_history$p1_scores <- c(gt_history$p1_scores, p1_pay)
    gt_history$p2_scores <- c(gt_history$p2_scores, p2_pay)
  }

  observeEvent(input$gt_move1, play_round(1L))
  observeEvent(input$gt_move2, play_round(2L))

  # Payoff matrix display
  output$gt_payoff_table <- renderUI({
    g <- game_payoffs[[input$gt_game]]
    n <- length(gt_history$p1_moves)
    last_r <- if (n > 0) gt_history$p1_moves[n] else 0
    last_c <- if (n > 0) gt_history$p2_moves[n] else 0

    rows <- lapply(1:2, function(i) {
      cells <- lapply(1:2, function(j) {
        highlight <- if (i == last_r && j == last_c)
          "background-color: rgba(38,139,210,0.25); font-weight: bold;" else ""
        tags$td(style = paste0("text-align:center; padding: 12px; ", highlight),
          paste0(g$p1[i, j], " , ", g$p2[i, j]))
      })
      tags$tr(tags$th(style = "padding: 10px; font-weight: 600;", g$row_labels[i]), cells)
    })

    tagList(
      tags$div(class = "text-muted small mb-3", HTML(g$desc)),
      tags$table(class = "table table-bordered",
        tags$thead(tags$tr(
          tags$th(style = "width:25%;", "You \\ Opponent"),
          tags$th(style = "text-align:center;", g$col_labels[1]),
          tags$th(style = "text-align:center;", g$col_labels[2])
        )),
        tags$tbody(rows)
      ),
      if (n > 0) tags$p(class = "text-info fw-bold",
        sprintf("Round %d: You played %s, Opponent played %s → You: %d, Opponent: %d",
          n, g$row_labels[last_r], g$col_labels[last_c],
          g$p1[last_r, last_c], g$p2[last_r, last_c])
      )
    )
  })

  # Score plot — markers colored by the strategy chosen each round
  output$gt_score_plot <- renderPlotly({
    n <- length(gt_history$p1_scores)
    req(n > 0)
    g <- game_payoffs[[input$gt_game]]
    rounds <- seq_len(n)
    cum_p1 <- cumsum(gt_history$p1_scores)
    cum_p2 <- cumsum(gt_history$p2_scores)

    # Green (#2aa198) for Strategy 1, Red (#dc322f) for Strategy 2
    s1_col <- "#2aa198"; s2_col <- "#dc322f"
    p1_cols <- ifelse(gt_history$p1_moves == 1, s1_col, s2_col)
    p2_cols <- ifelse(gt_history$p2_moves == 1, s1_col, s2_col)
    p1_hover <- paste0("Round ", rounds, "<br>You: ", g$row_labels[gt_history$p1_moves],
                       "<br>Score: ", cum_p1)
    p2_hover <- paste0("Round ", rounds, "<br>Opponent: ", g$col_labels[gt_history$p2_moves],
                       "<br>Score: ", cum_p2)

    plot_ly() |>
      add_trace(x = rounds, y = cum_p1, type = "scatter", mode = "lines+markers",
        name = "You", line = list(color = "#268bd2", width = 2),
        marker = list(color = p1_cols, size = 8,
                      line = list(color = "#073642", width = 1)),
        hoverinfo = "text", text = p1_hover) |>
      add_trace(x = rounds, y = cum_p2, type = "scatter", mode = "lines+markers",
        name = "Opponent", line = list(color = "#b58900", width = 2),
        marker = list(color = p2_cols, size = 8,
                      line = list(color = "#073642", width = 1)),
        hoverinfo = "text", text = p2_hover) |>
      layout(
        xaxis = list(title = "Round"), yaxis = list(title = "Cumulative Score"),
        legend = list(orientation = "h", x = 0.2, y = 1.12),
        annotations = list(
          list(x = 0.98, y = 0.98, xref = "paper", yref = "paper",
               text = paste0("<span style='color:", s1_col, "'>\u25cf</span> ", g$row_labels[1],
                             "  <span style='color:", s2_col, "'>\u25cf</span> ", g$row_labels[2]),
               showarrow = FALSE, font = list(size = 11),
               xanchor = "right", yanchor = "top")),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        margin = list(t = 40))
  })

  # Log table
  output$gt_log_table <- renderTable({
    n <- length(gt_history$p1_moves)
    req(n > 0)
    g <- game_payoffs[[input$gt_game]]
    data.frame(
      Round = seq_len(n),
      You = g$row_labels[gt_history$p1_moves],
      Opponent = g$col_labels[gt_history$p2_moves],
      `Your Score` = gt_history$p1_scores,
      `Opp Score` = gt_history$p2_scores,
      check.names = FALSE
    ) |> (\(d) d[rev(seq_len(nrow(d))), ])()  # newest first
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ==================================================================
  # TAB 2: Nash Equilibrium Finder
  # ==================================================================

  # Load preset payoffs
  observeEvent(input$gt_ne_preset, {
    req(input$gt_ne_preset != "Custom")
    g <- game_payoffs[[input$gt_ne_preset]]
    updateNumericInput(session, "gt_ne_a11", value = g$p1[1,1])
    updateNumericInput(session, "gt_ne_a12", value = g$p1[1,2])
    updateNumericInput(session, "gt_ne_a21", value = g$p1[2,1])
    updateNumericInput(session, "gt_ne_a22", value = g$p1[2,2])
    updateNumericInput(session, "gt_ne_b11", value = g$p2[1,1])
    updateNumericInput(session, "gt_ne_b12", value = g$p2[1,2])
    updateNumericInput(session, "gt_ne_b21", value = g$p2[2,1])
    updateNumericInput(session, "gt_ne_b22", value = g$p2[2,2])
  })

  gt_ne_result <- reactiveVal(NULL)
  observeEvent(input$gt_ne_find, {
    gt_ne_result({
    A <- matrix(c(input$gt_ne_a11, input$gt_ne_a12,
                  input$gt_ne_a21, input$gt_ne_a22), nrow = 2, byrow = TRUE)
    B <- matrix(c(input$gt_ne_b11, input$gt_ne_b12,
                  input$gt_ne_b21, input$gt_ne_b22), nrow = 2, byrow = TRUE)

    # Find pure NE: cell (i,j) is NE if A[i,j] >= A[k,j] for all k AND B[i,j] >= B[i,l] for all l
    pure_ne <- list()
    for (i in 1:2) for (j in 1:2) {
      p1_best <- A[i, j] >= max(A[, j])
      p2_best <- B[i, j] >= max(B[i, ])
      if (p1_best && p2_best) pure_ne <- c(pure_ne, list(c(i, j)))
    }

    # Mixed strategy NE
    # P1 mixes to make P2 indifferent: q*B[1,1] + (1-q)*B[1,2] = q*B[2,1] + (1-q)*B[2,2]
    # Solving for q (P1's probability of row 1):
    denom_q <- (B[1,1] - B[1,2]) - (B[2,1] - B[2,2])
    # P2 mixes to make P1 indifferent: p*A[1,1] + (1-p)*A[2,1] = p*A[1,2] + (1-p)*A[2,2]
    denom_p <- (A[1,1] - A[2,1]) - (A[1,2] - A[2,2])

    mixed <- NULL
    if (abs(denom_q) > 1e-10 && abs(denom_p) > 1e-10) {
      q <- (B[2,2] - B[1,2]) / denom_q   # P1's prob of Strategy 1
      p <- (A[2,2] - A[2,1]) / denom_p   # P2's prob of Strategy 1
      if (q > 0 && q < 1 && p > 0 && p < 1) {
        mixed <- list(q = q, p = p)
      }
    }

    list(A = A, B = B, pure_ne = pure_ne, mixed = mixed)
    })
  })

  output$gt_ne_matrix <- renderUI({
    res <- gt_ne_result()
    req(res)
    ne_cells <- res$pure_ne

    rows <- lapply(1:2, function(i) {
      cells <- lapply(1:2, function(j) {
        is_ne <- any(sapply(ne_cells, function(x) x[1] == i && x[2] == j))
        bg <- if (is_ne) "background-color: rgba(42,161,152,0.25); font-weight:bold;" else ""
        tags$td(style = paste0("text-align:center; padding:12px;", bg),
          paste0(res$A[i,j], " , ", res$B[i,j]),
          if (is_ne) tags$span(class = "badge bg-success ms-1", "NE"))
      })
      tags$tr(tags$th(paste0("Strategy ", i)), cells)
    })

    tags$table(class = "table table-bordered",
      tags$thead(tags$tr(
        tags$th("P1 \\ P2"), tags$th(style = "text-align:center;", "Strategy 1"),
        tags$th(style = "text-align:center;", "Strategy 2")
      )),
      tags$tbody(rows)
    )
  })

  # Best response plot
  output$gt_ne_br_plot <- renderPlotly({
    res <- gt_ne_result()
    req(res)
    A <- res$A; B <- res$B

    # P2's best response to P1 mixing with probability q (prob of Strat 1)
    # P2 plays Strat 1 if q*B[1,1] + (1-q)*B[2,1] > q*B[1,2] + (1-q)*B[2,2]
    q_seq <- seq(0, 1, length.out = 200)

    # P2's expected payoff from Strat 1 vs Strat 2 as function of q
    p2_s1 <- q_seq * B[1,1] + (1 - q_seq) * B[2,1]
    p2_s2 <- q_seq * B[1,2] + (1 - q_seq) * B[2,2]
    p2_br <- ifelse(p2_s1 > p2_s2, 1, ifelse(p2_s2 > p2_s1, 0, 0.5))

    # P1's expected payoff from Strat 1 vs Strat 2 as function of p
    p_seq <- seq(0, 1, length.out = 200)
    p1_s1 <- p_seq * A[1,1] + (1 - p_seq) * A[1,2]
    p1_s2 <- p_seq * A[2,1] + (1 - p_seq) * A[2,2]
    p1_br <- ifelse(p1_s1 > p1_s2, 1, ifelse(p1_s2 > p1_s1, 0, 0.5))

    p <- plot_ly() |>
      add_trace(x = q_seq, y = p2_br, type = "scatter", mode = "lines",
        name = "P2's Best Response", line = list(color = "#dc322f", width = 3)) |>
      add_trace(x = p1_br, y = p_seq, type = "scatter", mode = "lines",
        name = "P1's Best Response", line = list(color = "#268bd2", width = 3))

    # Mark equilibria
    for (idx in seq_along(res$pure_ne)) {
      ne <- res$pure_ne[[idx]]
      p <- p |> add_markers(x = ne[1] - 1, y = ne[2] - 1,
        marker = list(color = "#2aa198", size = 14, symbol = "star"),
        name = "Pure NE", showlegend = (idx == 1))
    }
    if (!is.null(res$mixed)) {
      p <- p |> add_markers(x = res$mixed$q, y = res$mixed$p,
        marker = list(color = "#b58900", size = 14, symbol = "diamond"),
        name = "Mixed NE")
    }

    p |> layout(
      xaxis = list(title = "P1 prob(Strategy 1)", range = c(-0.05, 1.05)),
      yaxis = list(title = "P2 prob(Strategy 1)", range = c(-0.05, 1.05)),
      legend = list(orientation = "h", x = 0, y = 1.15),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      margin = list(t = 40))
  })

  output$gt_ne_summary <- renderUI({
    res <- gt_ne_result()
    req(res)
    parts <- list()

    if (length(res$pure_ne) > 0) {
      ne_text <- paste(sapply(res$pure_ne, function(x)
        sprintf("(Strategy %d, Strategy %d) → payoffs (%g, %g)",
                x[1], x[2], res$A[x[1], x[2]], res$B[x[1], x[2]])),
        collapse = "<br>")
      parts <- c(parts, list(
        tags$h6(icon("check-circle", class = "text-success"), " Pure-Strategy Nash Equilibria"),
        tags$p(HTML(ne_text))
      ))
    } else {
      parts <- c(parts, list(
        tags$p(class = "text-warning", icon("exclamation-triangle"),
          " No pure-strategy Nash equilibrium exists.")
      ))
    }

    if (!is.null(res$mixed)) {
      ep1 <- res$mixed$q * (res$mixed$p * res$A[1,1] + (1 - res$mixed$p) * res$A[1,2]) +
             (1 - res$mixed$q) * (res$mixed$p * res$A[2,1] + (1 - res$mixed$p) * res$A[2,2])
      ep2 <- res$mixed$q * (res$mixed$p * res$B[1,1] + (1 - res$mixed$p) * res$B[1,2]) +
             (1 - res$mixed$q) * (res$mixed$p * res$B[2,1] + (1 - res$mixed$p) * res$B[2,2])
      parts <- c(parts, list(
        tags$h6(icon("shuffle", class = "text-info"), " Mixed-Strategy Nash Equilibrium"),
        tags$p(sprintf(
          "P1 plays Strategy 1 with probability %.3f; P2 plays Strategy 1 with probability %.3f",
          res$mixed$q, res$mixed$p)),
        tags$p(sprintf("Expected payoffs: P1 = %.2f, P2 = %.2f", ep1, ep2))
      ))
    } else {
      parts <- c(parts, list(
        tags$p(class = "text-muted",
          "No interior mixed-strategy equilibrium (players may be using pure strategies).")
      ))
    }

    tagList(parts)
  })

  # ==================================================================
  # TAB 3: IPD Tournament
  # ==================================================================
  gt_ipd_result <- reactiveVal(NULL)
  observeEvent(input$gt_ipd_run, {
    withProgress(message = "Simulating iterated game...", value = 0.1, {
    gt_ipd_result({
    req(length(input$gt_ipd_strats) >= 2)
    strats <- input$gt_ipd_strats
    n_rounds <- input$gt_ipd_rounds

    # PD payoff: CC = 3,3; CD = 0,5; DC = 5,0; DD = 1,1
    pd_payoff <- function(a, b) {
      if (a == 1 && b == 1) c(3, 3)
      else if (a == 1 && b == 2) c(0, 5)
      else if (a == 2 && b == 1) c(5, 0)
      else c(1, 1)
    }

    # Run all pairwise matchups
    n_s <- length(strats)
    scores <- matrix(0, n_s, n_s, dimnames = list(strats, strats))

    for (i in 1:n_s) for (j in 1:n_s) {
      if (i == j) next
      h_i <- integer(0); h_j <- integer(0)
      s_i <- 0; s_j <- 0
      for (r in seq_len(n_rounds)) {
        a <- ipd_strategies[[strats[i]]](h_i, h_j)
        b <- ipd_strategies[[strats[j]]](h_j, h_i)
        pay <- pd_payoff(a, b)
        s_i <- s_i + pay[1]; s_j <- s_j + pay[2]
        h_i <- c(h_i, a); h_j <- c(h_j, b)
      }
      scores[i, j] <- s_i
    }

    total <- rowSums(scores)
    list(scores = scores, total = total, strats = strats, n_rounds = n_rounds)
    })
    })
  })

  output$gt_ipd_standings <- renderPlotly({
    res <- gt_ipd_result()
    req(res)
    df <- data.frame(Strategy = factor(names(res$total), levels = names(sort(res$total))),
                     Total = as.numeric(res$total))
    plot_ly(df, y = ~Strategy, x = ~Total, type = "bar", orientation = "h",
      marker = list(color = "#268bd2"),
      hovertemplate = "%{y}: %{x:.0f}<extra></extra>",
      textposition = "none") |>
      layout(xaxis = list(title = "Total Score"),
             yaxis = list(title = ""),
             paper_bgcolor = "transparent", plot_bgcolor = "transparent",
             margin = list(l = 120))
  })

  output$gt_ipd_heatmap <- renderPlotly({
    res <- gt_ipd_result()
    req(res)
    avg <- res$scores / res$n_rounds
    plot_ly(x = colnames(avg), y = rownames(avg), z = avg, type = "heatmap", xgap = 2, ygap = 2,
      colorscale = list(c(0, "#fdf6e3"), c(0.5, "#93a1a1"), c(1, "#073642")),
      hovertemplate = "Row %{y} vs Col %{x}: %{z:.2f}/round<extra></extra>") |>
      layout(
        xaxis = list(title = "Opponent"), yaxis = list(title = "Strategy"),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        margin = list(l = 120, b = 80))
  })

  output$gt_ipd_descriptions <- renderUI({
    descs <- list(
      "Tit-for-Tat" = "Cooperate first, then copy opponent's last move. Nice, retaliatory, forgiving.",
      "Always Cooperate" = "Always cooperate regardless. Vulnerable to exploitation.",
      "Always Defect" = "Always defect regardless. Cannot be exploited, but cannot build cooperation.",
      "Grudger" = "Cooperate until opponent defects once, then defect forever. Retaliatory but unforgiving.",
      "Pavlov" = "Cooperate if last round both played the same; defect otherwise. Win-stay, lose-switch.",
      "Random" = "Cooperate or defect with equal probability each round.",
      "Tit-for-Two-Tats" = "Like Tit-for-Tat but only retaliates after two consecutive defections. More forgiving."
    )
    items <- lapply(input$gt_ipd_strats, function(s) {
      tags$li(tags$strong(s), " \u2014 ", descs[[s]])
    })
    tags$ul(class = "mb-0", items)
  })

  # ==================================================================
  # TAB 4: Evolutionary Dynamics
  # ==================================================================
  gt_evo_result <- reactiveVal(NULL)
  observeEvent(input$gt_evo_run, {
    withProgress(message = "Running evolutionary simulation...", value = 0.1, {
    gt_evo_result({
    g <- game_payoffs[[input$gt_evo_game]]
    A <- g$p1  # Payoff matrix (row player vs column player)
    p0 <- input$gt_evo_p0
    gens <- input$gt_evo_gens
    w <- input$gt_evo_speed

    # Replicator dynamics: dp/dt = w * p * (1-p) * (E[S1] - E[S2])
    # E[S1] = p*A[1,1] + (1-p)*A[1,2]
    # E[S2] = p*A[2,1] + (1-p)*A[2,2]
    dt <- 0.05
    p_vec <- numeric(gens + 1)
    p_vec[1] <- p0

    for (t in seq_len(gens)) {
      p <- p_vec[t]
      e1 <- p * A[1,1] + (1 - p) * A[1,2]
      e2 <- p * A[2,1] + (1 - p) * A[2,2]
      dp <- w * p * (1 - p) * (e1 - e2) * dt
      p_vec[t + 1] <- max(0.001, min(0.999, p + dp))
    }

    # Find ESS / equilibria
    # Interior equilibrium: e1 = e2 → p* = (A[2,2] - A[1,2]) / (A[1,1] - A[1,2] - A[2,1] + A[2,2])
    denom <- A[1,1] - A[1,2] - A[2,1] + A[2,2]
    p_star <- if (abs(denom) > 1e-10) (A[2,2] - A[1,2]) / denom else NA
    interior_eq <- if (!is.na(p_star) && p_star > 0 && p_star < 1) p_star else NA

    # Check stability of interior equilibrium (stable if d/dp of fitness diff is negative at p*)
    stable <- FALSE
    if (!is.na(interior_eq)) {
      # derivative of (e1-e2) w.r.t. p at p*
      deriv <- (A[1,1] - A[1,2]) - (A[2,1] - A[2,2])
      stable <- deriv < 0
    }

    list(p_vec = p_vec, gens = gens, p_star = interior_eq, stable = stable,
         A = A, labels = g$row_labels, game = input$gt_evo_game)
    })
    })
  })

  output$gt_evo_dynamics <- renderPlotly({
    res <- gt_evo_result()
    req(res)
    gen_seq <- 0:res$gens
    plot_ly() |>
      add_trace(x = gen_seq, y = res$p_vec, type = "scatter", mode = "lines",
        name = res$labels[1], line = list(color = "#268bd2", width = 2.5)) |>
      add_trace(x = gen_seq, y = 1 - res$p_vec, type = "scatter", mode = "lines",
        name = res$labels[2], line = list(color = "#dc322f", width = 2.5)) |>
      layout(
        xaxis = list(title = "Generation"), yaxis = list(title = "Population Proportion", range = c(0, 1)),
        legend = list(orientation = "h", x = 0.25, y = 1.12),
        paper_bgcolor = "transparent", plot_bgcolor = "transparent",
        margin = list(t = 40))
  })

  output$gt_evo_phase <- renderPlotly({
    res <- gt_evo_result()
    req(res)
    A <- res$A; w <- input$gt_evo_speed

    p_seq <- seq(0.01, 0.99, length.out = 100)
    e1 <- p_seq * A[1,1] + (1 - p_seq) * A[1,2]
    e2 <- p_seq * A[2,1] + (1 - p_seq) * A[2,2]
    dp <- w * p_seq * (1 - p_seq) * (e1 - e2)

    hover_txt <- paste0("p = ", round(p_seq, 3), "<br>dp/dt = ", round(dp, 4))

    p <- plot_ly() |>
      add_trace(x = p_seq, y = dp, type = "scatter", mode = "lines",
                line = list(color = "#268bd2", width = 2.5),
                hoverinfo = "text", text = hover_txt, showlegend = FALSE)

    shapes <- list(
      list(type = "line", x0 = 0, x1 = 1, y0 = 0, y1 = 0,
           line = list(color = "#93a1a1", dash = "dash", width = 1))
    )

    annotations <- list()
    if (!is.na(res$p_star)) {
      eq_col <- if (res$stable) "#2aa198" else "#dc322f"
      p <- p |> add_trace(x = res$p_star, y = 0, type = "scatter", mode = "markers",
                           marker = list(color = eq_col, size = 12, symbol = "diamond"),
                           hoverinfo = "text",
                           text = paste0("p* = ", round(res$p_star, 3),
                                          "<br>", if (res$stable) "Stable (ESS)" else "Unstable"),
                           showlegend = FALSE)
    }

    p |> layout(
      xaxis = list(title = paste0("Proportion of ", res$labels[1])),
      yaxis = list(title = "Rate of change (dp/dt)"),
      shapes = shapes,
      margin = list(t = 20)
    ) |> config(displayModeBar = FALSE)
  })

  output$gt_evo_summary <- renderUI({
    res <- gt_evo_result()
    req(res)
    final_p <- round(res$p_vec[length(res$p_vec)], 3)

    parts <- list(
      tags$p(tags$strong("Final proportions: "),
        sprintf("%s = %.1f%%, %s = %.1f%%",
          res$labels[1], final_p * 100, res$labels[2], (1 - final_p) * 100))
    )

    if (!is.na(res$p_star)) {
      stability <- if (res$stable) "stable (ESS)" else "unstable"
      parts <- c(parts, list(
        tags$p(tags$strong("Interior equilibrium: "),
          sprintf("p* = %.3f (%s)", res$p_star, stability))
      ))
    } else {
      parts <- c(parts, list(
        tags$p(class = "text-muted",
          "No interior equilibrium — boundary solutions only (p = 0 or p = 1).")
      ))
    }

    parts <- c(parts, list(
      tags$p(class = "text-muted small",
        "In the phase diagram, the curve shows the rate of change of Strategy 1's proportion.
         Where the curve crosses zero from positive to negative is a stable equilibrium (ESS).")
    ))

    tagList(parts)
  })

  # ==================================================================
  # TAB 5: Traveling Salesman Problem
  # ==================================================================

  gt_tsp <- reactiveValues(cities = NULL, tour = NULL, comparison = NULL)

  observeEvent(input$gt_tsp_generate, {
    withProgress(message = "Generating cities...", value = 0.1, {
    n <- input$gt_tsp_n
    gt_tsp$cities <- data.frame(
      id = seq_len(n),
      x  = runif(n),
      y  = runif(n)
    )
    gt_tsp$tour <- NULL
    gt_tsp$comparison <- NULL
    })
  })

  # Distance between two cities
  tsp_dist <- function(cities, i, j) {
    sqrt((cities$x[i] - cities$x[j])^2 + (cities$y[i] - cities$y[j])^2)
  }

  # Total tour distance (returns to start)
  tour_distance <- function(cities, tour) {
    n <- length(tour)
    d <- 0
    for (k in seq_len(n)) {
      nxt <- if (k < n) k + 1 else 1
      d <- d + tsp_dist(cities, tour[k], tour[nxt])
    }
    d
  }

  # Nearest Neighbor heuristic
  tsp_nearest_neighbor <- function(cities) {
    n <- nrow(cities)
    best_tour <- NULL
    best_dist <- Inf
    for (start in seq_len(n)) {
      visited <- logical(n)
      tour <- integer(n)
      tour[1] <- start
      visited[start] <- TRUE
      for (step in 2:n) {
        curr <- tour[step - 1]
        min_d <- Inf
        nxt <- 0
        for (j in seq_len(n)) {
          if (!visited[j]) {
            d <- tsp_dist(cities, curr, j)
            if (d < min_d) { min_d <- d; nxt <- j }
          }
        }
        tour[step] <- nxt
        visited[nxt] <- TRUE
      }
      d <- tour_distance(cities, tour)
      if (d < best_dist) { best_dist <- d; best_tour <- tour }
    }
    list(tour = best_tour, distance = best_dist)
  }

  # 2-Opt improvement
  tsp_two_opt <- function(cities, init_tour = NULL) {
    if (is.null(init_tour)) init_tour <- tsp_nearest_neighbor(cities)$tour
    tour <- init_tour
    n <- length(tour)
    improved <- TRUE
    while (improved) {
      improved <- FALSE
      for (i in 1:(n - 1)) {
        for (j in (i + 1):n) {
          # Reverse segment between i and j
          new_tour <- tour
          new_tour[i:j] <- rev(tour[i:j])
          new_d <- tour_distance(cities, new_tour)
          old_d <- tour_distance(cities, tour)
          if (new_d < old_d) {
            tour <- new_tour
            improved <- TRUE
          }
        }
      }
    }
    list(tour = tour, distance = tour_distance(cities, tour))
  }

  # Random tour
  tsp_random <- function(cities) {
    n <- nrow(cities)
    best_tour <- NULL; best_dist <- Inf
    n_tries <- min(1000, factorial(min(n, 8)))
    for (i in seq_len(n_tries)) {
      tour <- sample(n)
      d <- tour_distance(cities, tour)
      if (d < best_dist) { best_dist <- d; best_tour <- tour }
    }
    list(tour = best_tour, distance = best_dist)
  }

  observeEvent(input$gt_tsp_solve, {
    withProgress(message = "Solving TSP route...", value = 0.1, {
    req(gt_tsp$cities)
    cities <- gt_tsp$cities
    result <- switch(input$gt_tsp_algo,
      "Nearest Neighbor"   = tsp_nearest_neighbor(cities),
      "2-Opt Improvement"  = tsp_two_opt(cities),
      "Random Tour"        = tsp_random(cities)
    )
    gt_tsp$tour <- list(
      tour = result$tour, distance = result$distance, algo = input$gt_tsp_algo
    )
    })
  })

  observeEvent(input$gt_tsp_compare, {
    withProgress(message = "Comparing algorithms...", value = 0.1, {
    req(gt_tsp$cities)
    cities <- gt_tsp$cities
    nn    <- tsp_nearest_neighbor(cities)
    topt  <- tsp_two_opt(cities, nn$tour)
    rand  <- tsp_random(cities)
    gt_tsp$comparison <- data.frame(
      Algorithm = c("Nearest Neighbor", "2-Opt Improvement", "Random (best of 1000)"),
      Distance  = round(c(nn$distance, topt$distance, rand$distance), 4),
      stringsAsFactors = FALSE
    )
    # Show best tour on map
    best <- which.min(c(nn$distance, topt$distance, rand$distance))
    tours <- list(nn, topt, rand)
    algos <- c("Nearest Neighbor", "2-Opt Improvement", "Random Tour")
    gt_tsp$tour <- list(
      tour = tours[[best]]$tour, distance = tours[[best]]$distance, algo = algos[best]
    )
    })
  })

  output$gt_tsp_map <- renderPlotly({
    req(gt_tsp$cities)
    cities <- gt_tsp$cities

    p <- plot_ly()
    if (!is.null(gt_tsp$tour)) {
      tour <- gt_tsp$tour$tour
      tour_closed <- c(tour, tour[1])
      p <- p |> add_trace(
        x = cities$x[tour_closed], y = cities$y[tour_closed],
        type = "scatter", mode = "lines",
        line = list(color = "#268bd2", width = 2),
        showlegend = FALSE, hoverinfo = "skip"
      )
    }
    p <- p |> add_trace(
      x = cities$x, y = cities$y,
      type = "scatter", mode = "markers+text",
      marker = list(color = "#dc322f", size = 12, line = list(color = "#073642", width = 1)),
      text = cities$id, textposition = "top center",
      textfont = list(size = 10),
      hovertemplate = "City %{text}<br>(%{x:.2f}, %{y:.2f})<extra></extra>",
      showlegend = FALSE
    )
    p |> layout(
      xaxis = list(title = "X", range = c(-0.05, 1.05), scaleanchor = "y"),
      yaxis = list(title = "Y", range = c(-0.05, 1.05)),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      margin = list(t = 20)
    )
  })

  output$gt_tsp_results <- renderUI({
    req(gt_tsp$cities)
    n <- nrow(gt_tsp$cities)
    n_tours <- if (n <= 20) format(factorial(n - 1) / 2, big.mark = ",") else paste0("> 10^", round(log10(factorial(n - 1) / 2)))

    parts <- list(
      tags$p(tags$strong("Cities: "), n),
      tags$p(tags$strong("Possible tours: "), n_tours,
        tags$span(class = "text-muted small", paste0("  ((", n, "-1)!/2)")))
    )
    if (!is.null(gt_tsp$tour)) {
      parts <- c(parts, list(
        tags$hr(),
        tags$p(tags$strong("Algorithm: "), gt_tsp$tour$algo),
        tags$p(tags$strong("Tour distance: "),
          tags$span(class = "text-info fw-bold", round(gt_tsp$tour$distance, 4))),
        tags$p(class = "text-muted small", tags$strong("Tour order: "),
          paste(gt_tsp$tour$tour, collapse = " \u2192 "), " \u2192 ", gt_tsp$tour$tour[1])
      ))
    }
    tagList(parts)
  })

  output$gt_tsp_comparison <- renderTable({
    req(gt_tsp$comparison)
    gt_tsp$comparison
  }, striped = TRUE, hover = TRUE, width = "100%")

  # ==================================================================
  # TAB 6: Stable Matching
  # ==================================================================

  gt_sm <- reactiveValues(
    prefs_a = NULL, prefs_b = NULL, result = NULL, comparison = NULL
  )

  observeEvent(input$gt_sm_generate, {
    withProgress(message = "Generating preferences...", value = 0.1, {
    n <- input$gt_sm_n
    # Random preference lists
    gt_sm$prefs_a <- lapply(seq_len(n), function(i) sample(n))
    gt_sm$prefs_b <- lapply(seq_len(n), function(i) sample(n))
    gt_sm$result <- NULL
    gt_sm$comparison <- NULL
    })
  })

  # Gale-Shapley algorithm with trace
  gale_shapley <- function(prop_prefs, recv_prefs, prop_label = "A", recv_label = "B") {
    n <- length(prop_prefs)
    # Next person to propose to (index into preference list)
    next_proposal <- rep(1L, n)
    # Current match: -1 = unmatched
    prop_match <- rep(-1L, n)
    recv_match <- rep(-1L, n)
    # Build receiver ranking matrices for O(1) comparison
    recv_rank <- matrix(0L, n, n)
    for (r in seq_len(n)) {
      for (pos in seq_len(n)) {
        recv_rank[r, recv_prefs[[r]][pos]] <- pos
      }
    }

    free_props <- seq_len(n)
    trace <- list()

    while (length(free_props) > 0) {
      p <- free_props[1]
      r <- prop_prefs[[p]][next_proposal[p]]
      next_proposal[p] <- next_proposal[p] + 1L

      if (recv_match[r] == -1L) {
        prop_match[p] <- r
        recv_match[r] <- p
        free_props <- free_props[-1]
        trace <- c(trace, list(sprintf(
          "%s%d proposes to %s%d \u2014 %s%d accepts (was free).",
          prop_label, p, recv_label, r, recv_label, r)))
      } else {
        current <- recv_match[r]
        if (recv_rank[r, p] < recv_rank[r, current]) {
          prop_match[current] <- -1L
          prop_match[p] <- r
          recv_match[r] <- p
          free_props <- c(free_props[-1], current)
          trace <- c(trace, list(sprintf(
            "%s%d proposes to %s%d \u2014 %s%d accepts (drops %s%d).",
            prop_label, p, recv_label, r, recv_label, r, prop_label, current)))
        } else {
          trace <- c(trace, list(sprintf(
            "%s%d proposes to %s%d \u2014 %s%d rejects (prefers %s%d).",
            prop_label, p, recv_label, r, recv_label, r, prop_label, current)))
        }
      }
    }

    # Check stability
    blocking <- character(0)
    for (p in seq_len(n)) {
      for (r in seq_len(n)) {
        if (prop_match[p] != r) {
          p_prefers_r <- which(prop_prefs[[p]] == r) < which(prop_prefs[[p]] == prop_match[p])
          r_prefers_p <- recv_rank[r, p] < recv_rank[r, recv_match[r]]
          if (p_prefers_r && r_prefers_p) {
            blocking <- c(blocking, sprintf("(%s%d, %s%d)", prop_label, p, recv_label, r))
          }
        }
      }
    }

    list(
      prop_match = prop_match, recv_match = recv_match,
      trace = trace, blocking = blocking,
      prop_label = prop_label, recv_label = recv_label
    )
  }

  observeEvent(input$gt_sm_run, {
    withProgress(message = "Running stable matching...", value = 0.1, {
    req(gt_sm$prefs_a, gt_sm$prefs_b)
    if (input$gt_sm_side == "A") {
      gt_sm$result <- gale_shapley(gt_sm$prefs_a, gt_sm$prefs_b, "A", "B")
    } else {
      gt_sm$result <- gale_shapley(gt_sm$prefs_b, gt_sm$prefs_a, "B", "A")
    }
    gt_sm$comparison <- NULL
    })
  })

  observeEvent(input$gt_sm_both, {
    withProgress(message = "Running both algorithms...", value = 0.1, {
    req(gt_sm$prefs_a, gt_sm$prefs_b)
    res_a <- gale_shapley(gt_sm$prefs_a, gt_sm$prefs_b, "A", "B")
    res_b <- gale_shapley(gt_sm$prefs_b, gt_sm$prefs_a, "B", "A")
    gt_sm$result <- res_a
    gt_sm$comparison <- list(a_proposes = res_a, b_proposes = res_b)
    })
  })

  output$gt_sm_pref_a <- renderTable({
    req(gt_sm$prefs_a)
    n <- length(gt_sm$prefs_a)
    df <- do.call(rbind, lapply(seq_len(n), function(i) {
      setNames(
        as.data.frame(t(paste0("B", gt_sm$prefs_a[[i]]))),
        paste0("Rank ", seq_len(n))
      )
    }))
    df <- cbind(Member = paste0("A", seq_len(n)), df)
    df
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$gt_sm_pref_b <- renderTable({
    req(gt_sm$prefs_b)
    n <- length(gt_sm$prefs_b)
    df <- do.call(rbind, lapply(seq_len(n), function(i) {
      setNames(
        as.data.frame(t(paste0("A", gt_sm$prefs_b[[i]]))),
        paste0("Rank ", seq_len(n))
      )
    }))
    df <- cbind(Member = paste0("B", seq_len(n)), df)
    df
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$gt_sm_result <- renderUI({
    req(gt_sm$result)
    res <- gt_sm$result
    n <- length(res$prop_match)
    pl <- res$prop_label; rl <- res$recv_label

    match_rows <- lapply(seq_len(n), function(i) {
      tags$tr(
        tags$td(paste0(pl, i)),
        tags$td(icon("heart", class = "text-danger")),
        tags$td(paste0(rl, res$prop_match[i]))
      )
    })

    parts <- list(
      tags$p(tags$strong("Proposer: "), paste0("Group ", pl),
             " \u2014 ", tags$strong("Receiver: "), paste0("Group ", rl)),
      tags$table(class = "table table-sm table-striped",
        tags$thead(tags$tr(
          tags$th("Proposer"), tags$th(""), tags$th("Matched to")
        )),
        tags$tbody(match_rows)
      )
    )

    if (length(res$blocking) == 0) {
      parts <- c(parts, list(
        tags$p(class = "text-success fw-bold",
          icon("check-circle"), " This matching is stable — no blocking pairs.")
      ))
    } else {
      parts <- c(parts, list(
        tags$p(class = "text-danger fw-bold",
          icon("exclamation-triangle"),
          sprintf(" Blocking pairs found: %s", paste(res$blocking, collapse = ", ")))
      ))
    }

    if (!is.null(gt_sm$comparison)) {
      ra <- gt_sm$comparison$a_proposes
      rb <- gt_sm$comparison$b_proposes
      same <- all(ra$prop_match == rb$recv_match)
      parts <- c(parts, list(
        tags$hr(),
        tags$h6(icon("arrows-left-right"), " Comparison"),
        tags$p(
          if (same) {
            "Both sides produce the same stable matching (unique stable matching for these preferences)."
          } else {
            "The two sides produce different stable matchings — the proposing side always does better."
          }
        ),
        tags$table(class = "table table-sm table-bordered",
          tags$thead(tags$tr(
            tags$th("Pair"), tags$th("A proposes"), tags$th("B proposes")
          )),
          tags$tbody(
            lapply(seq_len(n), function(i) {
              tags$tr(
                tags$td(i),
                tags$td(paste0("A", i, " \u2194 B", ra$prop_match[i])),
                tags$td(paste0("B", i, " \u2194 A", rb$prop_match[i]))
              )
            })
          )
        )
      ))
    }

    tagList(parts)
  })

  output$gt_sm_trace <- renderUI({
    req(gt_sm$result)
    trace <- gt_sm$result$trace
    steps <- lapply(seq_along(trace), function(i) {
      tags$li(class = "mb-1", tags$span(class = "text-muted small", paste0("Step ", i, ": ")), trace[[i]])
    })
    tags$ol(class = "ps-3", style = "font-size: 0.9rem; max-height: 400px; overflow-y: auto;", steps)
  })

  # ==================================================================
  # TAB 7: University Admission (many-to-one matching)
  # ==================================================================

  uni_names <- c("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta")

  gt_ua <- reactiveValues(
    stu_prefs = NULL, uni_prefs = NULL, quotas = NULL,
    n_stu = NULL, n_uni = NULL,
    result = NULL, comparison = NULL
  )

  output$gt_ua_capacity_note <- renderUI({
    n_stu <- input$gt_ua_nstu
    n_uni <- input$gt_ua_nuni
    quota <- input$gt_ua_quota
    total_seats <- n_uni * quota
    col <- if (total_seats >= n_stu) "text-success" else "text-warning"
    icon_name <- if (total_seats >= n_stu) "check-circle" else "exclamation-triangle"
    tags$p(class = paste("small fw-bold", col),
      icon(icon_name),
      sprintf(" %d students, %d total seats (%d \u00d7 %d)",
              n_stu, total_seats, n_uni, quota),
      if (total_seats < n_stu) " — some students will be unmatched!"
    )
  })

  observeEvent(input$gt_ua_generate, {
    withProgress(message = "Generating auction...", value = 0.1, {
    n_stu <- input$gt_ua_nstu
    n_uni <- input$gt_ua_nuni
    quota <- input$gt_ua_quota
    gt_ua$n_stu <- n_stu
    gt_ua$n_uni <- n_uni
    gt_ua$quotas <- rep(quota, n_uni)
    gt_ua$stu_prefs <- lapply(seq_len(n_stu), function(i) sample(n_uni))
    gt_ua$uni_prefs <- lapply(seq_len(n_uni), function(i) sample(n_stu))
    gt_ua$result <- NULL
    gt_ua$comparison <- NULL
    })
  })

  # Student-proposing GS for many-to-one
  gs_student_proposing <- function(stu_prefs, uni_prefs, quotas) {
    n_stu <- length(stu_prefs)
    n_uni <- length(uni_prefs)

    # Build university ranking lookup: uni_rank[u, s] = rank of student s at university u
    uni_rank <- matrix(0L, n_uni, n_stu)
    for (u in seq_len(n_uni)) {
      for (pos in seq_along(uni_prefs[[u]])) {
        uni_rank[u, uni_prefs[[u]][pos]] <- pos
      }
    }

    next_prop <- rep(1L, n_stu)
    stu_match <- rep(-1L, n_stu)  # which university each student is matched to
    # Each university holds a set of tentatively accepted students
    uni_held <- lapply(seq_len(n_uni), function(u) integer(0))
    free <- seq_len(n_stu)
    trace <- list()

    while (length(free) > 0) {
      s <- free[1]
      if (next_prop[s] > n_uni) {
        # Student exhausted all choices
        free <- free[-1]
        trace <- c(trace, list(sprintf(
          "Student %d has been rejected by all universities \u2014 remains unmatched.", s)))
        next
      }
      u <- stu_prefs[[s]][next_prop[s]]
      next_prop[s] <- next_prop[s] + 1L
      u_name <- uni_names[u]

      if (length(uni_held[[u]]) < quotas[u]) {
        # University has room
        uni_held[[u]] <- c(uni_held[[u]], s)
        stu_match[s] <- u
        free <- free[-1]
        trace <- c(trace, list(sprintf(
          "Student %d applies to %s \u2014 accepted (seats available: %d/%d filled).",
          s, u_name, length(uni_held[[u]]), quotas[u])))
      } else {
        # Compare with worst currently held student
        held_ranks <- uni_rank[u, uni_held[[u]]]
        worst_idx <- which.max(held_ranks)
        worst_stu <- uni_held[[u]][worst_idx]
        if (uni_rank[u, s] < uni_rank[u, worst_stu]) {
          # Replace worst with s
          stu_match[worst_stu] <- -1L
          uni_held[[u]][worst_idx] <- s
          stu_match[s] <- u
          free <- c(free[-1], worst_stu)
          trace <- c(trace, list(sprintf(
            "Student %d applies to %s \u2014 accepted (displaces Student %d).",
            s, u_name, worst_stu)))
        } else {
          trace <- c(trace, list(sprintf(
            "Student %d applies to %s \u2014 rejected (full, prefers current students).",
            s, u_name)))
        }
      }
    }

    list(stu_match = stu_match, uni_held = uni_held, trace = trace, side = "students")
  }

  # University-proposing GS for many-to-one
  gs_uni_proposing <- function(stu_prefs, uni_prefs, quotas) {
    n_stu <- length(stu_prefs)
    n_uni <- length(uni_prefs)

    # Build student ranking lookup: stu_rank[s, u] = rank of university u for student s
    stu_rank <- matrix(0L, n_stu, n_uni)
    for (s in seq_len(n_stu)) {
      for (pos in seq_along(stu_prefs[[s]])) {
        stu_rank[s, stu_prefs[[s]][pos]] <- pos
      }
    }

    next_prop <- rep(1L, n_uni)  # next student to propose to for each university
    stu_match <- rep(-1L, n_stu)
    uni_held <- lapply(seq_len(n_uni), function(u) integer(0))
    trace <- list()

    repeat {
      # Find universities that still need to fill seats and have students left to propose to
      active <- which(sapply(seq_len(n_uni), function(u)
        length(uni_held[[u]]) < quotas[u] && next_prop[u] <= n_stu))
      if (length(active) == 0) break

      for (u in active) {
        if (length(uni_held[[u]]) >= quotas[u]) next
        if (next_prop[u] > n_stu) next
        s <- uni_prefs[[u]][next_prop[u]]
        next_prop[u] <- next_prop[u] + 1L
        u_name <- uni_names[u]

        if (stu_match[s] == -1L) {
          uni_held[[u]] <- c(uni_held[[u]], s)
          stu_match[s] <- u
          trace <- c(trace, list(sprintf(
            "%s offers Student %d \u2014 Student accepts (was unmatched).",
            u_name, s)))
        } else {
          curr_u <- stu_match[s]
          if (stu_rank[s, u] < stu_rank[s, curr_u]) {
            # Student prefers this university
            uni_held[[curr_u]] <- setdiff(uni_held[[curr_u]], s)
            uni_held[[u]] <- c(uni_held[[u]], s)
            stu_match[s] <- u
            trace <- c(trace, list(sprintf(
              "%s offers Student %d \u2014 Student accepts (leaves %s).",
              u_name, s, uni_names[curr_u])))
          } else {
            trace <- c(trace, list(sprintf(
              "%s offers Student %d \u2014 Student declines (prefers %s).",
              u_name, s, uni_names[curr_u])))
          }
        }
      }
    }

    list(stu_match = stu_match, uni_held = uni_held, trace = trace, side = "universities")
  }

  observeEvent(input$gt_ua_run, {
    withProgress(message = "Running auction...", value = 0.1, {
    req(gt_ua$stu_prefs, gt_ua$uni_prefs)
    if (input$gt_ua_side == "students") {
      gt_ua$result <- gs_student_proposing(gt_ua$stu_prefs, gt_ua$uni_prefs, gt_ua$quotas)
    } else {
      gt_ua$result <- gs_uni_proposing(gt_ua$stu_prefs, gt_ua$uni_prefs, gt_ua$quotas)
    }
    gt_ua$comparison <- NULL
    })
  })

  observeEvent(input$gt_ua_both, {
    withProgress(message = "Running both auctions...", value = 0.1, {
    req(gt_ua$stu_prefs, gt_ua$uni_prefs)
    res_s <- gs_student_proposing(gt_ua$stu_prefs, gt_ua$uni_prefs, gt_ua$quotas)
    res_u <- gs_uni_proposing(gt_ua$stu_prefs, gt_ua$uni_prefs, gt_ua$quotas)
    gt_ua$result <- res_s
    gt_ua$comparison <- list(student_proposing = res_s, uni_proposing = res_u)
    })
  })

  output$gt_ua_stu_prefs <- renderTable({
    req(gt_ua$stu_prefs)
    n_uni <- gt_ua$n_uni
    df <- do.call(rbind, lapply(seq_along(gt_ua$stu_prefs), function(i) {
      setNames(
        as.data.frame(t(uni_names[gt_ua$stu_prefs[[i]]])),
        paste0("Choice ", seq_len(n_uni))
      )
    }))
    df <- cbind(Student = paste0("S", seq_along(gt_ua$stu_prefs)), df)
    df
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$gt_ua_uni_prefs <- renderTable({
    req(gt_ua$uni_prefs)
    n_stu <- gt_ua$n_stu
    df <- do.call(rbind, lapply(seq_along(gt_ua$uni_prefs), function(i) {
      setNames(
        as.data.frame(t(paste0("S", gt_ua$uni_prefs[[i]]))),
        paste0("Rank ", seq_len(n_stu))
      )
    }))
    df <- cbind(
      University = uni_names[seq_along(gt_ua$uni_prefs)],
      Seats = gt_ua$quotas,
      df
    )
    df
  }, striped = TRUE, hover = TRUE, width = "100%")

  output$gt_ua_result <- renderUI({
    req(gt_ua$result)
    res <- gt_ua$result
    n_stu <- gt_ua$n_stu
    n_uni <- gt_ua$n_uni

    side_label <- if (res$side == "students") "Student-proposing (student-optimal)" else
                  "University-proposing (university-optimal)"

    # Build per-university table
    uni_rows <- lapply(seq_len(n_uni), function(u) {
      students <- res$uni_held[[u]]
      stu_str <- if (length(students) > 0) paste0("S", sort(students), collapse = ", ") else "\u2014"
      tags$tr(
        tags$td(tags$strong(uni_names[u])),
        tags$td(paste0(length(students), " / ", gt_ua$quotas[u])),
        tags$td(stu_str)
      )
    })

    unmatched <- which(res$stu_match == -1L)

    parts <- list(
      tags$p(tags$strong("Mode: "), side_label),
      tags$table(class = "table table-sm table-striped",
        tags$thead(tags$tr(
          tags$th("University"), tags$th("Filled / Quota"), tags$th("Admitted Students")
        )),
        tags$tbody(uni_rows)
      )
    )

    if (length(unmatched) > 0) {
      parts <- c(parts, list(
        tags$p(class = "text-warning fw-bold",
          icon("exclamation-triangle"),
          sprintf(" %d unmatched student(s): %s",
                  length(unmatched), paste0("S", unmatched, collapse = ", ")))
      ))
    } else {
      parts <- c(parts, list(
        tags$p(class = "text-success fw-bold",
          icon("check-circle"), " All students matched!")
      ))
    }

    # Per-student assignment list
    stu_items <- lapply(seq_len(n_stu), function(s) {
      if (res$stu_match[s] == -1L) {
        tags$tr(tags$td(paste0("S", s)), tags$td(class = "text-muted", "Unmatched"))
      } else {
        u <- res$stu_match[s]
        # What rank was this university in the student's list?
        rank_got <- which(gt_ua$stu_prefs[[s]] == u)
        tags$tr(
          tags$td(paste0("S", s)),
          tags$td(paste0(uni_names[u], " (their choice #", rank_got, ")"))
        )
      }
    })

    parts <- c(parts, list(
      tags$hr(),
      tags$h6("Student Assignments"),
      tags$table(class = "table table-sm",
        tags$thead(tags$tr(tags$th("Student"), tags$th("Assigned to"))),
        tags$tbody(stu_items)
      )
    ))

    # Average rank obtained
    matched <- which(res$stu_match != -1L)
    if (length(matched) > 0) {
      avg_rank <- mean(sapply(matched, function(s) which(gt_ua$stu_prefs[[s]] == res$stu_match[s])))
      parts <- c(parts, list(
        tags$p(class = "text-muted small",
          sprintf("Average student satisfaction: choice #%.1f (lower is better)", avg_rank))
      ))
    }

    # Comparison table
    if (!is.null(gt_ua$comparison)) {
      rs <- gt_ua$comparison$student_proposing
      ru <- gt_ua$comparison$uni_proposing
      same <- identical(rs$stu_match, ru$stu_match)

      avg_s <- mean(sapply(which(rs$stu_match != -1L), function(s)
        which(gt_ua$stu_prefs[[s]] == rs$stu_match[s])))
      avg_u <- mean(sapply(which(ru$stu_match != -1L), function(s)
        which(gt_ua$stu_prefs[[s]] == ru$stu_match[s])))

      parts <- c(parts, list(
        tags$hr(),
        tags$h6(icon("arrows-left-right"), " Student-proposing vs University-proposing"),
        if (same) {
          tags$p("Both produce the same matching (unique stable matching for these preferences).")
        } else {
          tagList(
            tags$table(class = "table table-sm table-bordered",
              tags$thead(tags$tr(
                tags$th("Student"), tags$th("Students propose"), tags$th("Universities propose")
              )),
              tags$tbody(
                lapply(seq_len(n_stu), function(s) {
                  a1 <- if (rs$stu_match[s] == -1) "Unmatched" else uni_names[rs$stu_match[s]]
                  a2 <- if (ru$stu_match[s] == -1) "Unmatched" else uni_names[ru$stu_match[s]]
                  diff <- a1 != a2
                  tags$tr(
                    class = if (diff) "table-info" else "",
                    tags$td(paste0("S", s)),
                    tags$td(a1),
                    tags$td(a2)
                  )
                })
              )
            ),
            tags$p(class = "text-muted small",
              sprintf("Avg student satisfaction — students propose: #%.1f | universities propose: #%.1f",
                      avg_s, avg_u)),
            tags$p(class = "text-muted small",
              "Highlighted rows differ between the two matchings. Students generally do better
               (lower choice #) when they propose; universities do better when they propose.")
          )
        }
      ))
    }

    tagList(parts)
  })

  output$gt_ua_trace <- renderUI({
    req(gt_ua$result)
    trace <- gt_ua$result$trace
    steps <- lapply(seq_along(trace), function(i) {
      tags$li(class = "mb-1",
        tags$span(class = "text-muted small", paste0("Step ", i, ": ")),
        trace[[i]])
    })
    tags$ol(class = "ps-3", style = "font-size: 0.9rem; max-height: 400px; overflow-y: auto;", steps)
  })

  # ==================================================================
  # TAB 8: Exam Timetabling
  # ==================================================================

  gt_et <- reactiveValues(
    sessions = NULL, conflicts = NULL, solution = NULL,
    slots = NULL, n_days = NULL, n_days_avail = NULL,
    all_placed = FALSE,
    students = NULL, stu_assignments = NULL
  )

  # ---- Phase 1: generate sessions, build conflicts, solve ----
  observeEvent(input$gt_et_solve, {
    withProgress(message = "Solving exam timetable...", value = 0.1, {
    n_mand <- input$gt_et_nmand;  s_mand <- input$gt_et_smand
    n_elec <- input$gt_et_nelec;  s_elec <- input$gt_et_selec
    n_days <- input$gt_et_days;   min_gap <- input$gt_et_gap
    max_per_day <- input$gt_et_maxday

    # Build sessions table
    rows <- list(); id <- 1L
    for (s in seq_len(n_mand)) {
      for (k in seq_len(s_mand)) {
        rows[[id]] <- data.frame(
          id = id, subject = et_mand_names[s], subject_idx = s,
          type = "mandatory", session_num = k,
          label = paste0(et_abbrevs[s], "-", k),
          color = et_colors[s], stringsAsFactors = FALSE)
        id <- id + 1L
      }
    }
    if (n_elec > 0) {
      for (s in seq_len(n_elec)) {
        for (k in seq_len(s_elec)) {
          si <- n_mand + s
          rows[[id]] <- data.frame(
            id = id, subject = et_elec_names[s], subject_idx = si,
            type = "elective", session_num = k,
            label = paste0(et_abbrevs[si], "-", k),
            color = et_colors[si], stringsAsFactors = FALSE)
          id <- id + 1L
        }
      }
    }
    sessions <- do.call(rbind, rows)
    n_sess <- nrow(sessions)

    # Conflict matrix
    # Same subject  = no conflict (alternative sittings)
    # Different mandatory subjects = conflict (every student takes all)
    # Elective vs mandatory = conflict
    # Different electives   = no conflict (simplification)
    conflicts <- matrix(FALSE, n_sess, n_sess)
    for (i in seq_len(n_sess - 1)) {
      for (j in (i + 1):n_sess) {
        si <- sessions$subject_idx[i]; sj <- sessions$subject_idx[j]
        if (si == sj) next
        ti <- sessions$type[i]; tj <- sessions$type[j]
        if (ti == "mandatory" && tj == "mandatory")                   { conflicts[i,j] <- TRUE; conflicts[j,i] <- TRUE }
        if (xor(ti == "elective", tj == "elective") &&
            (ti == "mandatory" || tj == "mandatory"))                 { conflicts[i,j] <- TRUE; conflicts[j,i] <- TRUE }
      }
    }

    # Time-slot grid: 2 per day (AM / PM)
    slots <- data.frame(
      day    = rep(seq_len(n_days), each = 2),
      period = rep(c("AM", "PM"), n_days),
      stringsAsFactors = FALSE)
    n_slots <- nrow(slots)

    # ---- Block-based solver ------------------------------------------------
    # Each subject is a block of consecutive slots (AM/PM/AM/PM...).
    # Conflicting blocks must have >= min_gap days between last day of one
    # and first day of the other.  Minimises total days used.
    # All mandatory blocks are the same size (s_mand) and all elective
    # blocks are the same size (s_elec), so ordering within each group
    # cannot improve the result — one greedy pass suffices.

    subj_ids  <- unique(sessions$subject_idx)
    subj_n    <- sapply(subj_ids, function(s) sum(sessions$subject_idx == s))
    subj_type <- sapply(subj_ids, function(s) sessions$type[sessions$subject_idx == s][1])
    n_subj    <- length(subj_ids)

    # Subject-level conflict matrix
    sc <- matrix(FALSE, n_subj, n_subj)
    for (i in seq_len(n_subj - 1)) for (j in (i + 1):n_subj) {
      ti <- subj_type[i]; tj <- subj_type[j]
      if (ti == "mandatory" && tj == "mandatory" ||
          ti != tj && (ti == "mandatory" || tj == "mandatory")) {
        sc[i, j] <- TRUE; sc[j, i] <- TRUE
      }
    }

    block_days <- function(start_slot, ns) {
      c((start_slot - 1L) %/% 2L + 1L,
        (start_slot + ns - 2L) %/% 2L + 1L)
    }

    # Greedy block placement: put each subject at earliest valid start slot
    # Always returns starts vector (NAs for subjects that couldn't be placed)
    try_placement <- function(ord) {
      starts <- rep(NA_integer_, n_subj)
      usage  <- rep(0L, n_slots)
      for (i in ord) {
        ns <- subj_n[i]
        for (t in seq_len(n_slots - ns + 1L)) {
          cand <- t:(t + ns - 1L)
          if (any(usage[cand] >= max_per_day)) next
          d <- block_days(t, ns)
          ok <- TRUE
          for (j in which(sc[i, ] & !is.na(starts))) {
            jd <- block_days(starts[j], subj_n[j])
            gap <- if (d[1] > jd[2]) d[1] - jd[2]
                   else if (jd[1] > d[2]) jd[1] - d[2]
                   else 0L
            if (gap < min_gap) { ok <- FALSE; break }
          }
          if (ok) {
            starts[i] <- t
            usage[cand] <- usage[cand] + 1L
            break
          }
        }
      }
      starts
    }

    mand_idx <- which(subj_type == "mandatory")
    elec_idx <- which(subj_type == "elective")
    ord      <- c(mand_idx, elec_idx)      # mandatory first, then electives

    starts <- try_placement(ord)

    # Convert block starts → per-session slot assignments (NA for unplaced)
    best_asgn <- rep(NA_integer_, n_sess)
    for (i in which(!is.na(starts))) {
      si <- which(sessions$subject_idx == subj_ids[i])
      si <- si[order(sessions$session_num[si])]
      for (k in seq_along(si)) best_asgn[si[k]] <- starts[i] + k - 1L
    }
    placed_subj <- which(!is.na(starts))
    best_max_day <- if (length(placed_subj) > 0)
      max(sapply(placed_subj, function(i) block_days(starts[i], subj_n[i])[2]))
    else 0L

    gt_et$sessions       <- sessions
    gt_et$conflicts      <- conflicts
    gt_et$solution       <- best_asgn
    gt_et$slots          <- slots
    gt_et$n_days         <- if (best_max_day > 0) best_max_day else n_days
    gt_et$n_days_avail   <- n_days
    gt_et$all_placed     <- all(!is.na(best_asgn))
    gt_et$students       <- NULL
    gt_et$stu_assignments <- NULL
    })
  })

  # ---- Timetable calendar ----
  output$gt_et_calendar <- renderUI({
    req(gt_et$sessions)
    sessions <- gt_et$sessions; slots <- gt_et$slots; asgn <- gt_et$solution

    make_cell <- function(sess_ids) {
      if (length(sess_ids) == 0) return(tags$td(class = "text-muted", "\u2014"))
      badges <- lapply(sess_ids, function(id) {
        tags$span(class = "badge me-1 mb-1",
                  style = paste0("background-color:", sessions$color[id],
                                 "; font-size:0.78rem;"),
                  sessions$label[id])
      })
      tags$td(tagList(badges))
    }

    rows <- lapply(seq_len(gt_et$n_days), function(d) {
      am <- which(asgn == (d - 1) * 2 + 1)
      pm <- which(asgn == (d - 1) * 2 + 2)
      has_exam <- length(am) + length(pm) > 0
      tags$tr(
        class = if (!has_exam) "table-light" else "",
        tags$td(tags$strong(paste0("Day ", d))),
        make_cell(am), make_cell(pm))
    })

    tags$div(style = "max-height:440px; overflow-y:auto;",
      tags$table(class = "table table-sm table-bordered mb-0",
        tags$thead(tags$tr(
          tags$th("Day"), tags$th("Morning (AM)"), tags$th("Afternoon (PM)"))),
        tags$tbody(rows)))
  })

  # ---- Conflict graph (circular layout) ----
  output$gt_et_graph <- renderPlotly({
    req(gt_et$sessions, gt_et$conflicts)
    sessions <- gt_et$sessions; conf <- gt_et$conflicts
    n <- nrow(sessions)

    theta <- seq(0, 2 * pi, length.out = n + 1)[-(n + 1)]
    nx <- cos(theta); ny <- sin(theta)

    # Edges as NA-separated segments
    ex <- c(); ey <- c()
    for (i in seq_len(n - 1)) for (j in (i + 1):n) {
      if (conf[i, j]) { ex <- c(ex, nx[i], nx[j], NA); ey <- c(ey, ny[i], ny[j], NA) }
    }

    p <- plot_ly()
    if (length(ex) > 0) {
      p <- p |> add_trace(x = ex, y = ey, type = "scatter", mode = "lines",
        line = list(color = "rgba(147,161,161,0.25)", width = 0.7),
        hoverinfo = "skip", showlegend = FALSE)
    }
    p <- p |> add_trace(
      x = nx, y = ny, type = "scatter", mode = "markers+text",
      marker = list(color = sessions$color, size = 14,
                    line = list(color = "#073642", width = 1)),
      text = sessions$label, textposition = "top center",
      textfont = list(size = 9),
      hovertemplate = "%{text}<br>%{customdata}<extra></extra>",
      customdata = paste0(sessions$subject, " (", sessions$type, ")"),
      showlegend = FALSE)
    p |> layout(
      xaxis = list(visible = FALSE, scaleanchor = "y"),
      yaxis = list(visible = FALSE),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      margin = list(t = 10, b = 10, l = 10, r = 10))
  })

  # ---- Solution summary ----
  output$gt_et_summary <- renderUI({
    req(gt_et$sessions)
    sessions <- gt_et$sessions; asgn <- gt_et$solution; slots <- gt_et$slots
    n_sess   <- nrow(sessions)
    n_placed <- sum(!is.na(asgn))
    days_used <- length(unique(slots$day[asgn[!is.na(asgn)]]))

    parts <- list()
    if (n_placed == n_sess) {
      parts <- c(parts, list(tags$p(class = "text-success fw-bold",
        icon("check-circle"),
        sprintf(" All %d sessions scheduled in %d days (minimum needed; %d available).",
                n_sess, days_used, gt_et$n_days_avail))))
    } else {
      # Identify unplaced subjects (not just sessions)
      unplaced_idx  <- which(is.na(asgn))
      unplaced_subj <- unique(sessions$subject[unplaced_idx])
      n_unplaced_sess <- length(unplaced_idx)
      parts <- c(parts, list(
        tags$p(class = "text-danger fw-bold", icon("exclamation-triangle"),
          sprintf(" %d of %d sessions could not be placed (%d subject%s).",
                  n_unplaced_sess, n_sess, length(unplaced_subj),
                  if (length(unplaced_subj) != 1) "s" else "")),
        tags$p(class = "text-danger",
          "Unplaced: ", paste(unplaced_subj, collapse = ", ")),
        if (n_placed > 0)
          tags$p(class = "text-info",
            sprintf("Partial schedule shown: %d sessions placed across %d days.",
                    n_placed, days_used)),
        tags$p(class = "text-muted",
          "Try increasing available days, reducing the gap, or allowing more sessions per slot.")))
    }

    parts <- c(parts, list(
      tags$p(tags$strong("Conflict edges: "), sum(gt_et$conflicts) / 2,
             " | ", tags$strong("Gap: "), "\u2265 ",
             input$gt_et_gap, " days",
             " | ", tags$strong("Max/slot: "), input$gt_et_maxday)))

    # Per-subject summary
    subj_ids <- unique(sessions$subject_idx)
    subj_rows <- lapply(subj_ids, function(s) {
      idx <- which(sessions$subject_idx == s)
      placed <- idx[!is.na(asgn[idx])]
      used_days <- sort(unique(slots$day[asgn[placed]]))
      tags$tr(
        tags$td(tags$span(class = "badge",
          style = paste0("background-color:", et_colors[s]), sessions$subject[idx[1]])),
        tags$td(sessions$type[idx[1]]),
        tags$td(length(idx)),
        tags$td(length(placed)),
        tags$td(if (length(used_days) > 0) paste(used_days, collapse = ", ") else "\u2014"))
    })

    parts <- c(parts, list(
      tags$table(class = "table table-sm table-striped mt-2",
        tags$thead(tags$tr(
          tags$th("Subject"), tags$th("Type"), tags$th("Sessions"),
          tags$th("Placed"), tags$th("Scheduled Days"))),
        tags$tbody(subj_rows))))

    tagList(parts)
  })

  # ---- Phase 2: assign students ----
  observeEvent(input$gt_et_assign, {
    req(gt_et$all_placed)
    n_stu      <- input$gt_et_nstu
    n_elec_per <- min(input$gt_et_estu, input$gt_et_nelec)
    sessions   <- gt_et$sessions
    asgn       <- gt_et$solution
    mand_subjs <- unique(sessions$subject_idx[sessions$type == "mandatory"])
    elec_subjs <- unique(sessions$subject_idx[sessions$type == "elective"])

    students <- lapply(seq_len(n_stu), function(i) {
      subjs <- mand_subjs
      if (n_elec_per > 0 && length(elec_subjs) > 0) {
        subjs <- c(subjs, sample(elec_subjs, min(n_elec_per, length(elec_subjs))))
      }
      subjs
    })

    # Round-robin assignment to sessions
    stu_sess <- lapply(seq_len(n_stu), function(i) {
      sapply(students[[i]], function(subj) {
        ids <- which(sessions$subject_idx == subj & !is.na(asgn))
        if (length(ids) == 0) return(NA_integer_)
        ids[((i - 1L) %% length(ids)) + 1L]
      })
    })

    gt_et$students        <- students
    gt_et$stu_assignments <- stu_sess
  })

  output$gt_et_stu_picker <- renderUI({
    req(gt_et$stu_assignments)
    ns <- session$ns
    tags$div(class = "mt-2",
      selectInput(ns("gt_et_stu_id"), "View student schedule:",
        choices = setNames(seq_along(gt_et$students),
                           paste0("Student ", seq_along(gt_et$students))),
        width = "100%"))
  })

  # ---- Student schedule viewer ----
  output$gt_et_student_view <- renderUI({
    if (is.null(gt_et$stu_assignments)) {
      return(tags$p(class = "text-muted",
        "Generate & Solve Phase 1 first, then click 'Assign Students'."))
    }
    req(input$gt_et_stu_id)
    sid <- as.integer(input$gt_et_stu_id)
    req(sid <= length(gt_et$students))

    sessions <- gt_et$sessions; slots <- gt_et$slots; asgn <- gt_et$solution
    stu_sess <- gt_et$stu_assignments[[sid]]
    valid    <- !is.na(stu_sess)
    sess_ids <- stu_sess[valid]

    if (length(sess_ids) == 0)
      return(tags$p(class = "text-muted", "No sessions assigned to this student."))

    # Build exam info sorted by day
    edf <- data.frame(
      Subject  = sessions$subject[sess_ids],
      Session  = sessions$label[sess_ids],
      Day      = slots$day[asgn[sess_ids]],
      Period   = slots$period[asgn[sess_ids]],
      Color    = sessions$color[sess_ids],
      stringsAsFactors = FALSE)
    edf <- edf[order(edf$Day, edf$Period), ]

    # Gaps between consecutive exam days
    exam_days <- sort(unique(edf$Day))
    gaps <- diff(exam_days)
    min_gap_stu <- if (length(gaps) > 0) min(gaps) else NA
    avg_gap_stu <- if (length(gaps) > 0) round(mean(gaps), 1) else NA

    # Exam table
    exam_rows <- lapply(seq_len(nrow(edf)), function(r) {
      tags$tr(
        tags$td(tags$span(class = "badge",
          style = paste0("background-color:", edf$Color[r]), edf$Subject[r])),
        tags$td(edf$Session[r]),
        tags$td(paste0("Day ", edf$Day[r])),
        tags$td(edf$Period[r]))
    })

    # Mini-calendar highlighting this student's exam days
    cal_rows <- lapply(seq_len(gt_et$n_days), function(d) {
      today <- edf[edf$Day == d, , drop = FALSE]
      if (nrow(today) == 0) return(NULL)
      badges <- lapply(seq_len(nrow(today)), function(r) {
        tags$span(class = "badge me-1",
          style = paste0("background-color:", today$Color[r], "; font-size:0.75rem;"),
          today$Session[r])
      })
      tags$tr(
        tags$td(paste0("Day ", d)),
        tags$td(today$Period[1]),
        tags$td(tagList(badges)))
    })
    cal_rows <- Filter(Negate(is.null), cal_rows)

    gap_class <- if (!is.na(min_gap_stu) && min_gap_stu >= input$gt_et_gap)
      "text-success" else if (!is.na(min_gap_stu)) "text-warning" else "text-muted"

    tagList(
      tags$h6(paste0("Student ", sid, " \u2014 ",
                     length(sess_ids), " exams over ",
                     length(exam_days), " days")),
      layout_column_wrap(width = 1/2,
        tags$div(
          tags$table(class = "table table-sm table-striped",
            tags$thead(tags$tr(
              tags$th("Subject"), tags$th("Session"),
              tags$th("Day"), tags$th("Period"))),
            tags$tbody(exam_rows))),
        tags$div(
          tags$p(class = paste("fw-bold", gap_class),
            if (!is.na(min_gap_stu))
              sprintf("Min gap: %d days | Avg gap: %s days", min_gap_stu, avg_gap_stu)
            else "Only one exam day"),
          tags$table(class = "table table-sm table-bordered",
            tags$thead(tags$tr(
              tags$th("Day"), tags$th("Period"), tags$th("Exam"))),
            tags$tbody(cal_rows)))))
  })

  # Memory cleanup: clear data after 90s of inactivity
  setup_memory_cleanup(session, "Game Theory", list(gt_ne_result, gt_ipd_result, gt_evo_result))
  })
}
