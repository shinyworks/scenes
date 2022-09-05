#' Link a UI to Required Actions
#'
#' A scene is a shiny ui and the actions that trigger it.
#'
#' @param ui A shiny ui.
#' @param ... One or more `scene_action` objects.
#'
#' @return
#' @export
#'
#' @examples
set_scene <- function(ui, ...) {
  # Validate that the UI will work in .parse_ui from shinyslack.

  # Validate the actions. Make sure it expects a single argument. Maybe require
  # that that argument is named `request`? I should probably have functions that
  # generate these action functions. Actually the action should also include an
  # (often empty) htmltools::htmlDependencies "html_dependency" object. Maybe
  # other things? And oh they're plural now 'cuz you might require multiple
  # things to be true, so I made them dots. If there's no action, this is the
  # default.

  # Something to watch for: incompatible actions, like requiring POST but then
  # other actions are GET only. See shiny:::uiHttpHandler for why that matters.

  # Consider composing these, so the request can be modified in one and passed
  # onto the next?
  actions <- rlang::list2(...)

  # Wrap them up and return them.
  return(
    .new_shiny_scene(
      ui = ui,
      actions = actions
    )
  )
}

.new_shiny_scene <- function(ui, actions) {
  return(
    structure(
      list(
        ui = ui,
        actions = actions
      ),
      class = c("shiny_scene", "list")
    )
  )
}
