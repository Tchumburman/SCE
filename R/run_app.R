#' Launch Statistical Concepts Explorer
#'
#' Starts the interactive Shiny application in your default browser.
#' The app features 65+ modules covering statistics, game theory,
#' data analysis, psychometrics, and machine learning.
#'
#' @param port Port to run the app on. Defaults to a random available port.
#' @param host Host address. Defaults to \"127.0.0.1\" (localhost).
#' @param launch.browser Whether to open the app in a browser. Defaults to TRUE.
#'
#' @return This function does not return; it runs the Shiny app until stopped.
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
#'
#' @export
run_app <- function(port = getOption("shiny.port"),
                    host = getOption("shiny.host", "127.0.0.1"),
                    launch.browser = TRUE) {
  app_dir <- system.file("app", package = "SCE")
  if (app_dir == "") {
    stop("Could not find app directory. Try reinstalling the SCE package.")
  }
  shiny::runApp(
    app_dir,
    port = port,
    host = host,
    launch.browser = launch.browser,
    display.mode = "normal"
  )
}
