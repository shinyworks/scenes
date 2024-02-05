#' Choose Between Scenes
#'
#' Specify a function that uses actions and the request object to choose which
#' Shiny UI to serve.
#'
#' @param ... One or more [`shiny_scenes`][shiny_scene-class].
#' @param fall_through A ui to display if no scenes are valid. The
#'   default value, [default_ui()], returns an HTTP 422 status code indicating
#'   that the request cannot be processed.
#'
#' @return A function that processes the request object to deliver a Shiny ui.
#' @export
#' @examples
#' scene1 <- set_scene(
#'   "A shiny ui",
#'   req_has_query("scene", 1)
#' )
#' scene2 <- set_scene(
#'   "Another shiny ui",
#'   req_has_query("scene", 2)
#' )
#'
#' ui <- change_scene(
#'   scene1,
#'   scene2
#' )
#' ui
change_scene <- function(..., fall_through = default_ui) {
  scenes <- rlang::list2(...)
  .multi_scene_ui <- .create_multi_scene_ui(scenes, fall_through)
  attr(.multi_scene_ui, "http_methods_supported") <- .compile_methods(scenes)
  return(.multi_scene_ui)
}

.create_multi_scene_ui <- function(scenes, fall_through) {
  force(scenes)
  # This is covered but covr doesn't grok that it is.
  #
  # nocov start
  return(
    function(request) {
      # Structure partially inspired by purrr::detect, at least in that it made
      # it feel ok to do this with a for loop from which we escape.
      for (scene in scenes) {
        if (
          !length(scene$actions) ||
          purrr::every(scene$actions, ~ .x$check_fn(request))
        ) {
          return(.parse_ui(scene$ui, request))
        }
      }
      return(.parse_ui(fall_through, request))
    }
  )
  # nocov end
}

#' Find Methods Used by Actions
#'
#' @param scenes A list of `shiny_scene` objects.
#'
#' @return A character vector of methods accepted by those scenes.
#' @keywords internal
.compile_methods <- function(scenes) {
  return(.extract_methods(scenes) %||% "GET")
}

.extract_methods <- function(scenes) {
  actions <- purrr::flatten(purrr::map(scenes, "actions"))
  return(unique(unlist(purrr::map(actions, "methods"))))
}

#' Prepare a Shiny UI for Display
#'
#' @param ui A 0- or 1-argument function defining the UI of a Shiny app, or a
#'   [shiny::tagList()].
#' @param request The shiny request object.
#'
#' @return A shiny ui as a [shiny::tagList()].
#' @keywords internal
.parse_ui <- function(ui, request) {
  if (is.function(ui)) {
    if (length(formals(ui))) {
      ui <- ui(request)
    } else {
      ui <- ui()
    }
  }

  return(ui)
}

#' Default UI for Unprocessable Requests
#'
#' A plain text UI that returns an HTTP status of 422, indicating that the
#' request was well-formed, but semantically incorrect.
#'
#' @return A plain text UI with status code 422.
#' @export
#' @examples
#' default_ui()
default_ui <- function() {
  cli::cli_warn(
    "No ui specified for this request. Loading default ui.",
    class = "scenes_warning_default_ui"
  )
  shiny::httpResponse(
    status = 422,
    content_type = "text/plain",
    content = paste(
      "422: Unprocessable Entity.",
      "The conditions necessary to choose a UI were not met."
    )
  )
}
