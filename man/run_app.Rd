\name{run_app}
\alias{run_app}
\title{Launch Statistical Concepts Explorer}
\usage{
run_app(
  port = getOption("shiny.port"),
  host = getOption("shiny.host", "127.0.0.1"),
  launch.browser = TRUE
)
}
\arguments{
\item{port}{Port to run the app on. Defaults to a random available port.}
\item{host}{Host address. Defaults to "127.0.0.1" (localhost).}
\item{launch.browser}{Whether to open the app in a browser. Defaults to TRUE.}
}
\description{
Starts the interactive Shiny application in your default browser.
The app features 65+ modules covering statistics, game theory,
data analysis, psychometrics, and machine learning.
}
\examples{
if (interactive()) {
  run_app()
}
}
