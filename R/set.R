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
  # TODO: Validate that the UI will work in .parse_ui. I actually might want to
  # enquo it in case they wrapped it, for example if we give them the option to
  # wrap a ui to add cookie handlers. For now we'll "validate" it simply by
  # passing it along.

  # TODO: Validate the actions. Make sure they expect a single argument. Maybe
  # require that that argument is named `request`? If there's no action, this is
  # a default.

  # TODO: Figure out whether the htmlDependencies part is anything. I do this
  # all with the request, right? Maybe provide helper wrappers for uis to add
  # them?

  actions <- rlang::list2(...)

  # Standardize zero-length-vector actions and NULL actions to be the same
  # thing.
  if (!length(actions)) actions <- NULL

  # TODO: Something to watch for: incompatible actions, like requiring POST but
  # then other actions are GET only. See shiny:::uiHttpHandler for why that
  # matters. Right now we'd let that through by allowing all of the methods, but
  # it could lead to errors downstream.

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
