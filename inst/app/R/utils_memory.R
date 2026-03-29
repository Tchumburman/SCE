# ---------------------------------------------------------------------------
# Memory reclamation for heavy modules
# Clears reactive data after a module has been inactive for `timeout_secs`.
# Relies on session$userData$active_module being set in the main server.
# ---------------------------------------------------------------------------
setup_memory_cleanup <- function(session, tab_name, reactive_vals,
                                 timeout_secs = 90) {
  left_at <- reactiveVal(NULL)

  observe({
    active <- session$userData$active_module
    if (!identical(active, tab_name)) {
      if (is.null(left_at())) left_at(proc.time()[["elapsed"]])
    } else {
      left_at(NULL)
    }
  })

  observe({
    req(left_at())
    invalidateLater(timeout_secs * 1000)
    elapsed <- proc.time()[["elapsed"]] - left_at()
    if (elapsed >= timeout_secs) {
      for (rv in reactive_vals) {
        try(rv(NULL), silent = TRUE)
      }
      left_at(NULL)
      # Tell JS to re-show "Press [button]" hints next time user visits
      session$sendCustomMessage("resetStartHints", tab_name)
    }
  })
}
