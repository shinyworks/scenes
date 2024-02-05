test_that("req_has_cookie works.", {
  # Construct objects that I'll use in tests.
  result_name_only <- req_has_cookie(
    cookie_name = "testcookie"
  )
  result_with_validator <- req_has_cookie(
    cookie_name = "testcookie",
    validation_fn = function(my_arg_name) {
      return(my_arg_name == "expected_value")
    }
  )
  result_with_validator2 <- req_has_cookie(
    cookie_name = "testcookie",
    validation_fn = function(my_arg_name, expected_value) {
      return(my_arg_name == expected_value)
    },
    expected_value = "expected_value"
  )
  result_name_only_negate <- req_has_cookie(
    cookie_name = "testcookie",
    negate = TRUE
  )
  result_with_validator_negate <- req_has_cookie(
    cookie_name = "testcookie",
    validation_fn = function(my_arg_name) {
      return(my_arg_name == "expected_value")
    },
    negate = TRUE
  )
  result_with_validator2_negate <- req_has_cookie(
    cookie_name = "testcookie",
    validation_fn = function(cookie_value, expected_value) {
      return(cookie_value == expected_value)
    },
    expected_value = "expected_value",
    negate = TRUE
  )

  # Check basic properties to make sure they're being constructed right.
  expect_s3_class(result_name_only, c("scene_action", "list"), exact = TRUE)
  expect_identical(result_name_only$methods, "GET")

  # Set up a bunch of request objects to use for tests.
  req_missing <- list()
  req_empty <- list(HTTP_COOKIE = NULL)
  req_other <- list(HTTP_COOKIE = "other=1; other2=2")
  req_only_test <- list(HTTP_COOKIE = "testcookie=expected_value")
  req_test_1 <- list(
    HTTP_COOKIE = "testcookie=expected_value; other=1; other2=2"
  )
  req_test_2 <- list(
    HTTP_COOKIE = "other=1; testcookie=expected_value; other2=2"
  )
  req_test_3 <- list(
    HTTP_COOKIE = "other=1; other2=2; testcookie=expected_value"
  )
  req_test_bad <- list(HTTP_COOKIE = "testcookie=bad_value")

  # Make sure the check functions do what's expected.

  # Name only is true whenever the cookie is there.
  expect_false(result_name_only$check_fn(req_missing))
  expect_false(result_name_only$check_fn(req_empty))
  expect_false(result_name_only$check_fn(req_other))
  expect_true(result_name_only$check_fn(req_only_test))
  expect_true(result_name_only$check_fn(req_test_1))
  expect_true(result_name_only$check_fn(req_test_2))
  expect_true(result_name_only$check_fn(req_test_3))
  expect_true(result_name_only$check_fn(req_test_bad))

  # Negated is opposite.
  expect_true(result_name_only_negate$check_fn(req_missing))
  expect_true(result_name_only_negate$check_fn(req_empty))
  expect_true(result_name_only_negate$check_fn(req_other))
  expect_false(result_name_only_negate$check_fn(req_only_test))
  expect_false(result_name_only_negate$check_fn(req_test_1))
  expect_false(result_name_only_negate$check_fn(req_test_2))
  expect_false(result_name_only_negate$check_fn(req_test_3))
  expect_false(result_name_only_negate$check_fn(req_test_bad))

  # The basic validator needs the "expected_value".
  expect_false(result_with_validator$check_fn(req_missing))
  expect_false(result_with_validator$check_fn(req_empty))
  expect_false(result_with_validator$check_fn(req_other))
  expect_true(result_with_validator$check_fn(req_only_test))
  expect_true(result_with_validator$check_fn(req_test_1))
  expect_true(result_with_validator$check_fn(req_test_2))
  expect_true(result_with_validator$check_fn(req_test_3))
  expect_false(result_with_validator$check_fn(req_test_bad))

  # Negated is opposite.
  expect_true(result_with_validator_negate$check_fn(req_missing))
  expect_true(result_with_validator_negate$check_fn(req_empty))
  expect_true(result_with_validator_negate$check_fn(req_other))
  expect_false(result_with_validator_negate$check_fn(req_only_test))
  expect_false(result_with_validator_negate$check_fn(req_test_1))
  expect_false(result_with_validator_negate$check_fn(req_test_2))
  expect_false(result_with_validator_negate$check_fn(req_test_3))
  expect_true(result_with_validator_negate$check_fn(req_test_bad))

  # The two-argument validator should behave the same.
  expect_false(result_with_validator2$check_fn(req_missing))
  expect_false(result_with_validator2$check_fn(req_empty))
  expect_false(result_with_validator2$check_fn(req_other))
  expect_true(result_with_validator2$check_fn(req_only_test))
  expect_true(result_with_validator2$check_fn(req_test_1))
  expect_true(result_with_validator2$check_fn(req_test_2))
  expect_true(result_with_validator2$check_fn(req_test_3))
  expect_false(result_with_validator2$check_fn(req_test_bad))

  # Negated is opposite.
  expect_true(result_with_validator2_negate$check_fn(req_missing))
  expect_true(result_with_validator2_negate$check_fn(req_empty))
  expect_true(result_with_validator2_negate$check_fn(req_other))
  expect_false(result_with_validator2_negate$check_fn(req_only_test))
  expect_false(result_with_validator2_negate$check_fn(req_test_1))
  expect_false(result_with_validator2_negate$check_fn(req_test_2))
  expect_false(result_with_validator2_negate$check_fn(req_test_3))
  expect_true(result_with_validator2_negate$check_fn(req_test_bad))
})

test_that("req_has_cookie errors cleanly.", {
  expect_error(
    req_has_cookie(NULL),
    class = "scenes_error_character_scalar"
  )
  expect_error(
    req_has_cookie(letters),
    class = "scenes_error_character_scalar"
  )
  expect_error(
    req_has_cookie(1),
    class = "scenes_error_character_scalar"
  )
})
