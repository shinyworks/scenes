#' Choose Between Scenes
#'
#' Specify a function that uses actions and the request object to choose which
#' Shiny UI to server.
#'
#' @param ... One or more `shiny_scene` objects.
#'
#' @return A function that processes the request object to delivery a Shiny ui.
#' @export
change_scene <- function(...) {
  scenes <- rlang::list2(...)

  if (!length(scenes)) {
    cli::cli_abort(
      "You must provide at least one scene.",
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
    for (i in seq_along(scenes)) {
      scene <- scenes[[i]]

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

utils::globalVariables("request")
