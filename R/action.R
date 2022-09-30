#' Switch Scenes on Query
#'
#' Create a `scene_action` specifying a key that must be present (or absent) in
#' the query string (the part of the URL when the shiny app was called, after
#' "?"), and optionally a value or values for that key. For example, in
#' `myapps.shinyapps.io/myapp?param1=1&param2=text`, `?param1=1&param2=text` is
#' the query string, `param1` and `param2` are keys, and `1` and `text` are
#' their corresponding values.
#'
#' @inheritParams .req_has_query_impl
#' @inheritParams .construct_action
#'
#' @return A `scene_action` object, to be used in [set_scene()].
#' @export
#'
#' @examples
#' # Specify an action to detect a "code" parameter in the query.
#' req_has_query("code")
#'
#' # Specify an action to detect the *lack* of a "code" parameter in the query.
#' req_has_query("code", negate = TRUE)
#'
#' # Specify an action to detect a "language" parameter, with values containing
#' # "en" or "es".
#' req_has_query("language", "en|es")
req_has_query <- function(key, values = NULL, negate = FALSE) {
  # I consciously decided NOT to vectorize this, because I think that would
  # complicate the call.
  return(
    .construct_action(
      fn_body = rlang::expr({
        return(
          .req_has_query_impl(
            request = request,
            key = !!key,
            values = !!values
          )
        )
      }),
      negate = negate
    )
  )
}

#' Check a Request for a Query with a Key
#'
#' Report whether a request includes a `QUERY_STRING` object with a specified
#' `key`, and optionally a specific value for that key.
#'
#' @param request A shiny request object.
#' @param key The key that must be present, as a length-1 character vector.
#' @param values Details about what to look for in the `key`. `NULL` indicates
#'   that the `key` must be present but its contents are unimportant for this
#'   action. Otherwise `values` will be passed to the `pattern` argument of
#'   [stringr::str_detect()] (with the actual value of `key` passed to the
#'   `string` argument). Note that the default interpretation of `values` is
#'   therefore a regular expressions.
#'
#' @return A length-1 logical vector.
#' @keywords internal
.req_has_query_impl <- function(request, key, values = NULL) {
  stopifnot(
    is.character(key),
    length(key) == 1
  )

  query <- shiny::parseQueryString(request$QUERY_STRING)

  return(
    key %in% names(query) &&
      (is.null(values) || query[[key]] %in% values)
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
