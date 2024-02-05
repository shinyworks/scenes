#' Link a UI to Required Actions
#'
#' Define a [`shiny_scene`][shiny_scene-class] by linking a UI to zero or more
#' [`scene_action`][scene_action-class] requirements.
#'
#' @param ui A shiny ui.
#' @param ... Zero or more [`scene_actions`][scene_action-class].
#'
#' @return A [`shiny_scene`][shiny_scene-class].
#' @export
#' @examples
#' scene1 <- set_scene(
#'   "A shiny ui",
#'   req_has_query("scene", 1)
#' )
#' scene1
#' scene2 <- set_scene(
#'   "Another shiny ui",
#'   req_has_query("scene", 2)
#' )
#' scene2
set_scene <- function(ui, ...) {
  actions <- rlang::list2(...)
  if (!length(actions)) actions <- NULL
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
#' @return A [`shiny_scene`][shiny_scene-class].
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

#' `shiny_scene` class
#'
#' @description A `shiny_scene` object is a `list` with components `ui` and
#'   `actions`. It is used to define what should display in a Shiny app in
#'   different scenarios.
#'
#' @name shiny_scene-class
#' @aliases shiny_scene
#' @seealso [set_scene()]
NULL
