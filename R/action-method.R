#' Switch Scenes on Method
#'
#' Create a `scene_action` specifying the HTTP method that must be used (or not
#' used).
#'
#' @inheritParams .req_has_method_impl
#' @inheritParams .construct_action
#'
#' @return A `scene_action` object, to be used in [set_scene()].
#' @export
#'
#' @examples
#' req_has_method("GET")
#' req_has_method("POST")
req_has_method <- function(method, negate = FALSE) {
  valid_methods <- c(
    "get", "post", "put",
    "head", "delete", "patch",
    "options", "connect", "trace"
  )
  method <- tolower(method)

  stopifnot(
    length(method) == 1,
    method %in% valid_methods
  )

  return(
    .construct_action(
      fn_body = rlang::expr({
        return(
          .req_has_method_impl(
            request = request,
            method = !!method
          )
        )
      }),
      negate = negate,
      methods = toupper(method)
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
.req_has_method_impl <- function(request, method) {
  return(isTRUE(tolower(request$REQUEST_METHOD) == method))
}

#' @rdname req_has_method
#' @examples
#' req_is_get()
#' req_is_get(negate = TRUE)
req_is_get <- function(negate = FALSE) {
  return(
    req_has_method("GET", negate = negate)
  )
}

#' @rdname req_has_method
#' @examples
#' req_is_post()
#' req_is_post(negate = TRUE)
req_is_post <- function(negate = FALSE) {
  return(
    req_has_method("POST", negate = negate)
  )
}
