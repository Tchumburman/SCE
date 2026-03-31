#' Launch Statistical Concepts Explorer
#'
#' Starts the Shiny application in the default web browser.
#'
#' @param port Port number for the app (default: a random available port).
#' @param host Host address (default: "127.0.0.1").
#' @param ... Additional arguments passed to \code{\link[shiny]{runApp}}.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function(port = getOption("shiny.port"), host = "127.0.0.1", ...) {
  app_dir <- system.file("app", package = "SCE")
  if (app_dir == "") {
    stop("Could not find the app directory. Try reinstalling the `SCE` package.",
         call. = FALSE)
  }
  shiny::runApp(app_dir, port = port, host = host, ...)
}
