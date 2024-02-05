#' Construct a Scene Action
#'
#' Generate the check function for an action, and use it to create a
#' [`scene_action`][scene_action-class] object.
#'
#' @param fn A function that takes a request (and potentially other arguments)
#'   and returns `TRUE` or `FALSE`.
#' @param ... Additional parameters passed on to `fn`.
#' @param negate If `TRUE`, trigger the corresponding scene when this action is
#'   `not` matched.
#' @param methods The http methods which needs to be accepted in order for this
#'   function to make sense. Default "GET" should work in almost all cases.
#'
#' @return A [`scene_action`][scene_action-class].
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
  methods <- .validate_methods(methods)
  negate <- .validate_logical_scalar(negate)
  check_fn <- .decorate_check_fn(fn, ..., negate = negate)
  return(
    .new_action(
      check_fn = check_fn,
      methods = methods
    )
  )
}

.validate_methods <- function(methods, call = rlang::caller_env()) {
  rlang::arg_match(
    methods,
    c(
      "GET", "POST", "PUT", "HEAD", "DELETE",
      "PATCH", "OPTIONS", "CONNECT", "TRACE"
    ),
    multiple = TRUE,
    error_call = call
  )
}

.validate_logical_scalar <- function(x,
                                     arg = rlang::caller_arg(x),
                                     call = rlang::caller_env()) {
  if (rlang::is_scalar_logical(x)) {
    return(x)
  }
  cli::cli_abort(
    c(
      "Argument {.arg {arg}} must be a length-1 logical vector.",
      x = "{.arg {arg}} is {.obj_type_friendly {x}}."
    ),
    call = call,
    class = "scenes_error_logical_scalar"
  )
}

.decorate_check_fn <- function(fn, ..., negate) {

  check_fn <- purrr::partial({{ fn }}, ...)
  if (negate) {
    check_fn <- Negate(check_fn)
  }
  return(check_fn)
}

#' Structure a Scene Action
#'
#' @param check_fn The function that processes the request to determine if an
#'   associated scene should be returned.
#' @param methods The http methods supported by this action.
#'
#' @return A [`scene_action`][scene_action-class].
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

#' `scene_action` class
#'
#' @description A `scene_action` object is a `list` with components `check_fn`
#'   and `methods`. It is used to test whether a request should trigger a
#'   particlar scene.
#'
#' @name scene_action-class
#' @aliases scene_action
#' @seealso [construct_action()]
NULL
