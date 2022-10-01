#' Construct a Scene Action
#'
#' Generate the check function for an action, and use it to create a
#' `scene_action` object.
#'
#' @inheritParams .construct_check_fn
#' @param negate If `TRUE`, trigger the corresponding scene when this action is
#'   `not` matched.
#' @param methods The http methods which needs to be accepted in order for this
#'   function to make sense. Default "GET" should work in almost all cases.
#'
#' @return A `scene_action` object.
#' @keywords internal
.construct_action <- function(fn_body,
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

  check_fn <- .construct_check_fn(fn_body)

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

#' Construct a Check Function
#'
#' This is a function factory for creating the actual function that will be
#' called to test the request.
#'
#' @param fn_body The quoted body of the function. This should be everything
#'   that would appear inside the `{}` of a function (and the brackets
#'   themselves), inside a call to [rlang::expr()]. Usually this will include
#'   variables that should be diffused using `!!`.
#'
#' @return A function.
#' @keywords internal
.construct_check_fn <- function(body) {
  return(
    rlang::new_function(
      rlang::pairlist2(request = ),
      body,
      env = rlang::env_parent()
    )
  )
}

#' Structure a Scene Action
#'
#' @param check_fn The function that processes the request to determine if an
#'   associated scene should be returned.
#' @param methods The http methods supported by this method.
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
