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
#' @inheritParams construct_action
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
  .validate_character_scalar(
    parameter = key,
    parameter_name = "key"
  )


  return(
    construct_action(
      fn = .req_has_query_impl,
      key = key,
      values = values,
      negate = negate
    )
  )
}

#' Check a Request for a Query with a Key
#'
#' Report whether a request includes a `QUERY_STRING` object with a specified
#' `key`, and optionally a specific value for that key.
#'
#' @inheritParams .shared-parameters
#' @param key The key that must be present, as a length-1 character vector.
#' @param values Details about what to look for in the `key`. `NULL` indicates
#'   that the `key` must be present but its contents are unimportant for this
#'   action. Otherwise the actual value of the query must be present in
#'   `values`.
#'
#' @return A length-1 logical vector.
#' @keywords internal
.req_has_query_impl <- function(request, key, values = NULL) {
  query <- shiny::parseQueryString(request$QUERY_STRING)

  return(
    key %in% names(query) &&
      (is.null(values) || query[[key]] %in% values)
  )
}
