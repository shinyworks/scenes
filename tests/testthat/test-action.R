test_that("action constructors work.", {
  test_action <- .construct_action(
    fn_body = rlang::expr({
      return(length(request) > 1)
    }),
    negate = FALSE
  )
  test_action_negate <- .construct_action(
    fn_body = rlang::expr({
      return(length(request) > 1)
    }),
    negate = TRUE
  )

  # Check that they're the expected shape.
  expect_s3_class(test_action, c("scene_action", "list"), exact = TRUE)
  expect_s3_class(test_action_negate, c("scene_action", "list"), exact = TRUE)
  expect_named(test_action, c("check_fn", "methods"))
  expect_named(test_action_negate, c("check_fn", "methods"))

  expect_type(test_action$check_fn, "closure")
  expect_type(test_action_negate$check_fn, "closure")

  expect_identical(test_action$methods, "GET")
  expect_identical(test_action_negate$methods, "GET")

  # Make sure they work as expected. The function should be TRUE if I pass in
  # something longer than length-1 (or the opposite for the negate).
  expect_false(test_action$check_fn(1))
  expect_true(test_action$check_fn(1:2))
  expect_true(test_action_negate$check_fn(1))
  expect_false(test_action_negate$check_fn(1:2))
})
