% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/change.R
\name{change_scene}
\alias{change_scene}
\title{Choose Between Scenes}
\usage{
change_scene(..., fall_through = default_ui)
}
\arguments{
\item{...}{One or more \code{\link[=shiny_scene-class]{shiny_scenes}}.}

\item{fall_through}{A ui to display if no scenes are valid. The
default value, \code{\link[=default_ui]{default_ui()}}, returns an HTTP 422 status code indicating
that the request cannot be processed.}
}
\value{
A function that processes the request object to deliver a Shiny ui.
}
\description{
Specify a function that uses actions and the request object to choose which
Shiny UI to serve.
}
\examples{
scene1 <- set_scene(
  "A shiny ui",
  req_has_query("scene", 1)
)
scene2 <- set_scene(
  "Another shiny ui",
  req_has_query("scene", 2)
)

ui <- change_scene(
  scene1,
  scene2
)
ui
}
