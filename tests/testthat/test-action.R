# This first one goes more overboard on the tests than other req_* functions
# should go. Once we know these come back right, we should trust the
# constructors.
test_that("req_has_query returns the expected object", {
  # Construct objects that I'll use in tests.
  result_key_only <- req_has_query(
    key = "testkey"
  )
  result_key_only_negate <- req_has_query(
    key = "testkey",
    negate = TRUE
  )
  result_value <- req_has_query(
    key = "testkey",
    values = "a"
  )
  result_value_negate <- req_has_query(
    key = "testkey",
    values = "a",
    negate = TRUE
  )
  result_values <- req_has_query(
    key = "testkey",
    values = c("a", "b", "c")
  )
  result_values_negate <- req_has_query(
    key = "testkey",
    values = c("a", "b", "c"),
    negate = TRUE
  )

  # Check that they're the expected shape.
  expect_s3_class(result_key_only, c("scene_action", "list"), exact = TRUE)
  expect_s3_class(
    result_key_only_negate, c("scene_action", "list"), exact = TRUE
  )
  expect_s3_class(result_value, c("scene_action", "list"), exact = TRUE)
  expect_s3_class(result_value_negate, c("scene_action", "list"), exact = TRUE)
  expect_s3_class(result_values, c("scene_action", "list"), exact = TRUE)
  expect_s3_class(result_values_negate, c("scene_action", "list"), exact = TRUE)

  expect_named(result_key_only, c("check_fn", "methods"))
  expect_named(result_key_only_negate, c("check_fn", "methods"))
  expect_named(result_value, c("check_fn", "methods"))
  expect_named(result_value_negate, c("check_fn", "methods"))
  expect_named(result_values, c("check_fn", "methods"))
  expect_named(result_values_negate, c("check_fn", "methods"))

  expect_type(result_key_only$check_fn, "closure")
  expect_type(result_key_only_negate$check_fn, "closure")
  expect_type(result_value$check_fn, "closure")
  expect_type(result_value_negate$check_fn, "closure")
  expect_type(result_values$check_fn, "closure")
  expect_type(result_values_negate$check_fn, "closure")

  # All of these are just "GET" method so I'll only test one. A later req_*
  # function will be better to test that.
  expect_identical(result_key_only$methods, "GET")

  # Set up a bunch of queries to use for tests.
  query_missing <- list()
  query_empty <- list(QUERY_STRING = NULL)
  query_no_testkey <- list(QUERY_STRING = "?other=1")
  query_testkey_a1 <- list(QUERY_STRING = "?testkey=a&other=1")
  query_testkey_a2 <- list(QUERY_STRING = "?other=1&testkey=a")
  query_testkey_b <- list(QUERY_STRING = "?testkey=b&other=1")
  query_testkey_z <- list(QUERY_STRING = "?testkey=z&other=1")

  # Make sure the check functions do what's expected.
  expect_false(result_key_only$check_fn(query_missing))
  expect_false(result_key_only$check_fn(query_empty))
  expect_false(result_key_only$check_fn(query_no_testkey))
  expect_true(result_key_only$check_fn(query_testkey_a1))
  expect_true(result_key_only$check_fn(query_testkey_a2))
  expect_true(result_key_only$check_fn(query_testkey_b))
  expect_true(result_key_only$check_fn(query_testkey_z))

  expect_true(result_key_only_negate$check_fn(query_missing))
  expect_true(result_key_only_negate$check_fn(query_empty))
  expect_true(result_key_only_negate$check_fn(query_no_testkey))
  expect_false(result_key_only_negate$check_fn(query_testkey_a1))
  expect_false(result_key_only_negate$check_fn(query_testkey_a2))
  expect_false(result_key_only_negate$check_fn(query_testkey_b))
  expect_false(result_key_only_negate$check_fn(query_testkey_z))

  expect_false(result_value$check_fn(query_missing))
  expect_false(result_value$check_fn(query_empty))
  expect_false(result_value$check_fn(query_no_testkey))
  expect_true(result_value$check_fn(query_testkey_a1))
  expect_true(result_value$check_fn(query_testkey_a2))
  expect_false(result_value$check_fn(query_testkey_b))
  expect_false(result_value$check_fn(query_testkey_z))

  expect_true(result_value_negate$check_fn(query_missing))
  expect_true(result_value_negate$check_fn(query_empty))
  expect_true(result_value_negate$check_fn(query_no_testkey))
  expect_false(result_value_negate$check_fn(query_testkey_a1))
  expect_false(result_value_negate$check_fn(query_testkey_a2))
  expect_true(result_value_negate$check_fn(query_testkey_b))
  expect_true(result_value_negate$check_fn(query_testkey_z))

  expect_false(result_values$check_fn(query_missing))
  expect_false(result_values$check_fn(query_empty))
  expect_false(result_values$check_fn(query_no_testkey))
  expect_true(result_values$check_fn(query_testkey_a1))
  expect_true(result_values$check_fn(query_testkey_a2))
  expect_true(result_values$check_fn(query_testkey_b))
  expect_false(result_values$check_fn(query_testkey_z))

  expect_true(result_values_negate$check_fn(query_missing))
  expect_true(result_values_negate$check_fn(query_empty))
  expect_true(result_values_negate$check_fn(query_no_testkey))
  expect_false(result_values_negate$check_fn(query_testkey_a1))
  expect_false(result_values_negate$check_fn(query_testkey_a2))
  expect_false(result_values_negate$check_fn(query_testkey_b))
  expect_true(result_values_negate$check_fn(query_testkey_z))

  # Also take snapshots in case I miss something manually. The negate ones are
  # hard to snapshot so for now I'm skipping them.
  expect_snapshot(result_key_only)
  # expect_snapshot(result_key_only_negate)
  expect_snapshot(result_value)
  # expect_snapshot(result_value_negate)
  expect_snapshot(result_values)
  # expect_snapshot(result_values_negate)
})
