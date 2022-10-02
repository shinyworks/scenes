#' Switch Scenes on Cookies
#'
#' Create a `scene_action` specifying a cookie that must be present (or absent)
#' and optionally a check function for that cookie.
#'
#' @inheritParams .req_has_cookie_impl
#' @inheritParams .construct_action
#'
#' @return A `scene_action` object, to be used in [set_scene()].
#' @export
#'
#' @examples
#' # Specify an action to detect a cookie named "mycookie".
#' req_has_cookie("mycookie")
#'
#' # Specify an action to detect the *lack* of a cookie named "mycookie".
#' req_has_cookie("mycookie", negate = TRUE)
#'
#' # Specify an action to detect a cookie named "mycookie" that has 27
#' # characters.
#' req_has_cookie(
#'   cookie_name = "mycookie",
#'   validation_fn = function(cookie_value) {
#'     nchar(cookie_value == 27)
#'   }
#' )
#'
#' # Specify an action to detect a cookie named "mycookie" that has N
#' # characters. This would make more sense in a case where validation_fn isn't
#' # an anonymous function.
#' req_has_cookie(
#'   cookie_name = "mycookie",
#'   validation_fn = function(cookie_value, N) {
#'     nchar(cookie_value == N)
#'   },
#'   N = 27
#' )
req_has_cookie <- function(cookie_name,
                           validation_fn = NULL,
                           ...,
                           negate = FALSE) {
  .validate_character_scalar(
    parameter = cookie_name,
    parameter_name = "cookie_name"
  )

  dots <- rlang::list2(...)
  return(
    .construct_action(
      fn_body = rlang::expr({
        return(
          .req_has_cookie_impl(
            request = request,
            cookie_name = !!cookie_name,
            validation_fn = !!validation_fn,
            !!!dots
          )
        )
      }),
      negate = negate
    )
  )
}

#' Check a Request for a Cookie
#'
#' Report whether a request includes a `HTTP_COOKIE` object with a specified
#' `cookie_name`, and optionally that the cookie passes
#'
#' @inheritParams .shared-parameters
#' @param cookie_name The cookie that must be present, as a length-1 character
#'   vector.
#' @param validation_fn A function that takes the value of the cookie as the
#'   first parameter, and returns `TRUE` if the cookie is valid, and `FALSE`
#'   otherwise.
#' @param ... Additional parameters passed on to `validation_fn`.
#'
#' @return A length-1 logical vector.
#' @keywords internal
.req_has_cookie_impl <- function(request,
                                 cookie_name,
                                 validation_fn,
                                 ...) {
  cookie_value <- .extract_cookie(request, cookie_name)

  # If that's NA the cookie wasn't there, so we're done.
  if (is.na(cookie_value)) {
    return(FALSE)
  }

  if (!is.null(validation_fn)) {
    return(validation_fn(cookie_value, ...))
  } else {
    return(TRUE)
  }
}