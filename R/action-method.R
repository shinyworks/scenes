#' Switch Scenes on Method
#'
#' Create a `scene_action` specifying the HTTP method that must be used (or not
#' used).
#'
#' @inheritParams .req_uses_method_impl
#' @inheritParams construct_action
#'
#' @return A `scene_action` object, to be used in [set_scene()].
#' @export
#'
#' @examples
#' req_uses_method("GET")
#' req_uses_method("POST")
req_uses_method <- function(method, negate = FALSE) {
  valid_methods <- c(
    "GET", "POST", "PUT",
    "HEAD", "DELETE", "PATCH",
    "OPTIONS", "CONNECT", "TRACE"
  )

  if (missing(method)) {
    # I combine error messaging for the various 0-length cases, since toupper
    # coerces.
    method <- character(0)
  }

  method <- toupper(method)

  .validate_character_scalar(
    parameter = method,
    parameter_name = "method",
    valid_values = valid_methods
  )

  return(
    construct_action(
      fn = .req_uses_method_impl,
      method = method,
      negate = negate,
      methods = method
    )
  )
}

#' Check a Request for a Method
#'
#' Report whether a request includes a `REQUEST_METHOD` object with a specified
#' value.
#'
#' @inheritParams .shared-parameters
#' @param method The expected HTTP method.
#'
#' @return A length-1 logical vector.
#' @keywords internal
.req_uses_method_impl <- function(request, method) {
  return(isTRUE(toupper(request$REQUEST_METHOD) == method))
}

#' @rdname req_uses_method
#' @export
#' @examples
#' req_uses_get()
#' req_uses_get(negate = TRUE)
req_uses_get <- function(negate = FALSE) {
  return(
    req_uses_method("GET", negate = negate)
  )
}

#' @rdname req_uses_method
#' @export
#' @examples
#' req_uses_post()
#' req_uses_post(negate = TRUE)
req_uses_post <- function(negate = FALSE) {
  return(
    req_uses_method("POST", negate = negate)
  )
}
