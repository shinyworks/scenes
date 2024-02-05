test_that("construct_action() rejects bad methods", {
  expect_error(
    construct_action(
      fn = function() {},
      methods = "bad_method"
    ),
    "GET"
  )
})

test_that("construct_action() rejects bad value of negate", {
  expect_error(
    construct_action(
      fn = function() {},
      methods = "GET",
      negate = 27
    ),
    class = "scenes_error_logical_scalar"
  )
})

test_that("construct_actions() returns the expected object", {
  test_action <- construct_action(fn = function(request) {})
  expect_s3_class(test_action, c("scene_action", "list"), exact = TRUE)
  expect_named(test_action, c("check_fn", "methods"))
  expect_type(test_action$check_fn, "closure")
  expect_identical(test_action$methods, "GET")
})

test_that("construct_actions() negates", {
  simple_function <- function(request) {
    !missing(request) && length(request) > 1
  }

  test_action <- construct_action(fn = simple_function)
  test_action_negate <- construct_action(fn = simple_function, negate = TRUE)

  expect_false(test_action$check_fn(1))
  expect_true(test_action$check_fn(1:2))
  expect_true(test_action_negate$check_fn(1))
  expect_false(test_action_negate$check_fn(1:2))
})
