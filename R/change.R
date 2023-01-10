#' Choose Between Scenes
#'
#' Specify a function that uses actions and the request object to choose which
#' Shiny UI to server.
#'
#' @param ... One or more `shiny_scene` objects.
#' @param fall_through A ui to display if no conditions scense are valid. The
#'   default value, [default_ui()], returns an HTTP 422 statud code indicating
#'   that the request cannot be processed.
#'
#' @return A function that processes the request object to deliver a Shiny ui.
#' @export
change_scene <- function(..., fall_through = default_ui()) {
  scenes <- rlang::list2(...)

  if (!length(scenes)) {
    cli::cli_warn(
      "No scene provided. All users will see the fall_through ui.",
      class = "no_scenes"
    )
  }

  # Make sure the scenes object is "set" as far as this function is concerned.
  force(scenes)

  # We will actually return a *function*, which shiny will feed the request
  # object into. That function will then decide which UI to display.

  # covr doesn't grok this.

  # nocov start
  .multi_scene_ui <- function(request) {
    # Loop through the scenes, in order. If one passes, process it and return
    # it. The structure here is partially inspired by purrr::detect, at least
    # in that it made it feel ok to do this with a for loop that we escape
    # from.
    for (scene in scenes) {
      if (
        # A scene with no actions always triggers if we get to it.
        !length(scene$actions) ||
          # This seems backwards, but isn't! scene$actions is a list of actions,
          # each of which has a function, so we're taking each function, and
          # using it to test the request.
          purrr::every(
            scene$actions,
            ~ .x$check_fn(request)
          )
      ) {
        return(
          .parse_ui(scene$ui, request)
        )
      }
    }

    # If nothing succeeded, fall through.
    return(.parse_ui(fall_through, request))
  }
  # nocov end

  # Extract method information from the actions.
  methods <- .compile_methods(scenes)

  attr(.multi_scene_ui, "http_methods_supported") <- methods

  return(.multi_scene_ui)
}

#' Find Methods Used by Actions
#'
#' @param scenes A list of `shiny_scene` objects.
#'
#' @return A character vector of methods accepted by those scenes.
#' @keywords internal
.compile_methods <- function(scenes) {
  # Pull out the actions. We don't care which scene each action came from, so we
  # flatten that level.
  actions <- purrr::flatten(purrr::map(scenes, "actions"))

  # Extract the methods from inside each action.
  methods <- unique(
    unlist(
      purrr::map(actions, "methods")
    )
  )

  # If there aren't any actions methods can be NULL at this point, so fix that.
  if (!length(methods)) {
    methods <- "GET"
  }

  return(methods)
}

#' Prepare a Shiny UI for Display
#'
#' @param ui A function defining the UI of a Shiny app, or a [shiny::tagList()].
#' @param request The shiny request object.
#'
#' @return A shiny ui as a [shiny::tagList()].
#' @keywords internal
.parse_ui <- function(ui, request) {
  # ui can be a tagList, a 0-argument function, or a 1-argument function. Deal
  # with those.
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
default_ui <- function() {
  cli::cli_warn(
    "No ui specified for this request. Loading default ui."
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

utils::globalVariables("request")
