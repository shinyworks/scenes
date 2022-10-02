#' Link a UI to Required Actions
#'
#' A scene is a shiny ui and the actions that trigger it.
#'
#' @param ui A shiny ui.
#' @param ... One or more `scene_action` objects.
#'
#' @return A `shiny_scene` object, which is a list with components `ui` and
#'   `actions`.
#' @export
set_scene <- function(ui, ...) {
  actions <- rlang::list2(...)

  # Standardize zero-length-vector actions and NULL actions to be the same
  # thing.
  if (!length(actions)) actions <- NULL

  # Wrap them up and return them.
  return(
    .new_shiny_scene(
      ui = ui,
      actions = actions
    )
  )
}

#' Structure a Shiny Scene
#'
#' @param ui The ui to return for this set of actions.
#' @param actions Zero or more actions required in order to invoke this ui.
#'
#' @return A `shiny_scene` object, which is a `list` with components `ui` and
#'   `actions`.
#' @keywords internal
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
