# Someday this should be a package.

#' Ensure that an Argument is Length-1 Character
#'
#' @param parameter The argument to test.
#' @param parameter_name The argument's name. Eventually this should be
#'   automatically handled through rlang or something, in theory.
#' @param valid_values (optional) Expected values of the parameter.
#'
#' @return The parameter if it is character-scalar.
#' @keywords internal
.validate_character_scalar <- function(parameter,
                                       parameter_name,
                                       valid_values) {
  UseMethod(".validate_character_scalar")
}

#' @export
.validate_character_scalar.default <- function(parameter,
                                               parameter_name,
                                               valid_values) {
  .error_message(
    parameter,
    parameter_name,
    valid_values,
    special_message = paste(
      "{parameter_name} is a {.cls {class(parameter)}} vector,",
      "not a {.cls character} vector."
    )

  )
}

#' @export
.validate_character_scalar.character <- function(parameter,
                                                 parameter_name,
                                                 valid_values) {
  if (length(parameter) == 1) {
    return(.validate_values(parameter, parameter_name, valid_values))
  }

  .error_message(
    parameter,
    parameter_name,
    valid_values,
    special_message = "{parameter_name} has {length(parameter)} values."
  )
}

#' @export
.validate_character_scalar.NULL <- function(parameter,
                                            parameter_name,
                                            valid_values) {
  .error_message(
    parameter,
    parameter_name,
    valid_values,
    special_message = "{parameter_name} is missing or NULL."
  )
}

#' Ensure that an Argument has Certain Values
#'
#' @inheritParams .validate_character_scalar
#'
#' @return The parameter.
#' @keywords internal
.validate_values <- function(parameter, parameter_name, valid_values) {
  if (!missing(valid_values) && !all(parameter %in% valid_values)) {
    .error_message(
      parameter,
      parameter_name,
      valid_values,
      special_message = "Unknown {parameter_name}: '{parameter}'",
      level = 3
    )
  }
  return(parameter)
}

#' Generate an Error Message
#'
#' @inheritParams .validate_character_scalar
#' @param special_message A message tailored to the type of error.
#' @param level How deep the check is relative to the original function. Default
#'   = 2.
#'
#' @keywords internal
.error_message <- function(parameter,
                           parameter_name,
                           valid_values,
                           special_message,
                           level = 2) {
  parameter_name <- glue::backtick(parameter_name)
  error_message <- special_message
  if (!missing(valid_values)) {
    valid_values <- glue::glue_collapse(
      valid_values,
      sep = ", ",
      last = " or "
    )
    one <- cli::style_italic("one")
    error_message <- c(
      error_message,
      i = "{parameter_name} must be {one} of {valid_values}."
    )
  }
  cli::cli_abort(
    error_message,
    call = rlang::caller_env(level)
  )
}
