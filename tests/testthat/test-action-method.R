test_that("req_has_method works.", {
  # Construct objects that I'll use in tests.
  result_get1 <- req_has_method(
    method = "get"
  )
  result_get1n <- req_has_method(
    method = "get",
    negate = TRUE
  )
  result_get2 <- req_has_method(
    method = "GET"
  )
  result_get2n <- req_has_method(
    method = "GET",
    negate = TRUE
  )
  result_post1 <- req_has_method(
    method = "post"
  )
  result_post1n <- req_has_method(
    method = "post",
    negate = TRUE
  )
  result_post2 <- req_has_method(
    method = "POST"
  )
  result_post2n <- req_has_method(
    method = "POST",
    negate = TRUE
  )

  # Check basic properties to make sure they're being constructed right.
  expect_s3_class(result_get1, c("scene_action", "list"), exact = TRUE)

  # The methods are important here.
  expect_identical(result_get1$methods, "GET")
  expect_identical(result_get2$methods, "GET")
  expect_identical(result_post1$methods, "POST")
  expect_identical(result_post2$methods, "POST")

  # Set up a bunch of queries to use for tests.
  request_missing <- list()
  request_empty <- list(REQUEST_METHOD = NULL)
  request_get <- list(REQUEST_METHOD = "GET")
  request_post <- list(REQUEST_METHOD = "POST")
  request_other <- list(REQUEST_METHOD = "OTHER")

  # result_get1
  expect_false(result_get1$check_fn(request_missing))
  expect_false(result_get1$check_fn(request_empty))
  expect_true(result_get1$check_fn(request_get))
  expect_false(result_get1$check_fn(request_post))
  expect_false(result_get1$check_fn(request_other))

  expect_true(result_get1n$check_fn(request_missing))
  expect_true(result_get1n$check_fn(request_empty))
  expect_false(result_get1n$check_fn(request_get))
  expect_true(result_get1n$check_fn(request_post))
  expect_true(result_get1n$check_fn(request_other))

  # result_get2
  expect_false(result_get2$check_fn(request_missing))
  expect_false(result_get2$check_fn(request_empty))
  expect_true(result_get2$check_fn(request_get))
  expect_false(result_get2$check_fn(request_post))
  expect_false(result_get2$check_fn(request_other))

  expect_true(result_get2n$check_fn(request_missing))
  expect_true(result_get2n$check_fn(request_empty))
  expect_false(result_get2n$check_fn(request_get))
  expect_true(result_get2n$check_fn(request_post))
  expect_true(result_get2n$check_fn(request_other))

  # result_post1
  expect_false(result_post1$check_fn(request_missing))
  expect_false(result_post1$check_fn(request_empty))
  expect_false(result_post1$check_fn(request_get))
  expect_true(result_post1$check_fn(request_post))
  expect_false(result_post1$check_fn(request_other))

  expect_true(result_post1n$check_fn(request_missing))
  expect_true(result_post1n$check_fn(request_empty))
  expect_true(result_post1n$check_fn(request_get))
  expect_false(result_post1n$check_fn(request_post))
  expect_true(result_post1n$check_fn(request_other))

  # result_post2
  expect_false(result_post2$check_fn(request_missing))
  expect_false(result_post2$check_fn(request_empty))
  expect_false(result_post2$check_fn(request_get))
  expect_true(result_post2$check_fn(request_post))
  expect_false(result_post2$check_fn(request_other))

  expect_true(result_post2n$check_fn(request_missing))
  expect_true(result_post2n$check_fn(request_empty))
  expect_true(result_post2n$check_fn(request_get))
  expect_false(result_post2n$check_fn(request_post))
  expect_true(result_post2n$check_fn(request_other))

  # Add errors.
})
