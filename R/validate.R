# This may all be updated to use github.com/jonthegeek/stbl or something similar
# in the future.

.validate_logical_scalar <- function(x,
                                     arg = rlang::caller_arg(x),
                                     call = rlang::caller_env()) {
  if (rlang::is_scalar_logical(x)) {
    return(x)
  }
  .abort_obj_type_scalar(x, "logical", arg, call)
}

.abort_obj_type_scalar <- function(x, target_class, arg, call) {
  cli::cli_abort(
    c(
      "{.arg {arg}} must be a length-1 {target_class} vector.",
      "{.arg {arg}} is {.obj_type_friendly {x}}."
    ),
    call = call,
    class = glue::glue("scenes_error_{target_class}_scalar")
  )
}

.validate_character_scalar <- function(x,
                                       arg = rlang::caller_arg(x),
                                       call = rlang::caller_env()) {
  if (rlang::is_scalar_character(x)) {
    return(x)
  }
  .abort_obj_type_scalar(x, "character", arg, call)
}
