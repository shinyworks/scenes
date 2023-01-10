#' Construct a Scene Action
#'
#' Generate the check function for an action, and use it to create a
#' `scene_action` object.
#'
#' @param fn A function that takes a request (and potentially other arguments)
#'   and returns `TRUE` or `FALSE`.
#' @param ... Additional parameters passed on to `fn`.
#' @param negate If `TRUE`, trigger the corresponding scene when this action is
#'   `not` matched.
#' @param methods The http methods which needs to be accepted in order for this
#'   function to make sense. Default "GET" should work in almost all cases.
#'
#' @return A `scene_action` object.
#' @export
#'
#' @examples
#' simple_function <- function(request) {
#'   !missing(request) && length(request) > 0
#' }
#' sample_action <- construct_action(simple_function)
#' sample_action$check_fn()
#' sample_action$check_fn(list())
#' sample_action$check_fn(list(a = 1))
construct_action <- function(fn,
                             ...,
                             negate = FALSE,
                             methods = "GET") {
  rlang::arg_match(
    methods,
    c(
      "GET",
      "POST",
      "PUT",
      "HEAD",
      "DELETE",
      "PATCH",
      "OPTIONS",
      "CONNECT",
      "TRACE"
    ),
    multiple = TRUE
  )
  stopifnot(
    is.logical(negate),
    length(negate) == 1
  )

  check_fn <- fn
  if (...length()) {
    check_fn <- purrr::partial({{ fn }}, ...)
  }

  if (negate) {
    check_fn <- Negate(check_fn)
  }

  return(
    .new_action(
      check_fn = check_fn,
      methods = methods
    )
  )
}

#' Structure a Scene Action
#'
#' @param check_fn The function that processes the request to determine if an
#'   associated scene should be returned.
#' @param methods The http methods supported by this action.
#'
#' @return A `scene_action` object, which is a `list` with components `check_fn`
#'   and `methods`.
#' @keywords internal
.new_action <- function(check_fn, methods) {
  return(
    structure(
      list(
        check_fn = check_fn,
        methods = methods
      ),
      class = c("scene_action", "list")
    )
  )
}
