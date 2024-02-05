test_that("Basic scene change validation works.", {
  expect_warning(
    change_scene(),
    "No scene provided",
    class = "scenes_warning_no_scenes"
  )
})

test_that("Scene changing works in the most basic case.", {
  test_result <- change_scene(
    set_scene(ui = "default ui")
  )
  expect_type(test_result, "closure")
  expect_identical(
    attr(test_result, "http_methods_supported"),
    "GET"
  )
  expect_identical(
    test_result(list(a = 1)),
    "default ui"
  )
})

test_that("Scene change functions work as expected", {
  # The environment of the returned function changes. Right now I don't *think*
  # we need to avoid that (via rlang) but I'm noting it. And it means snapshots
  # won't work. That's fine because it's the RESULT that actually matters.
  testkey_ui_a <- "testkey ui a"
  testkey_ui_b <- "testkey ui b"
  default_ui <- "default ui"
  test_result <- change_scene(
    set_scene(
      ui = testkey_ui_a,
      req_has_query("testkey", "a")
    ),
    set_scene(
      ui = testkey_ui_b,
      req_has_query("testkey", "b")
    ),
    set_scene(ui = default_ui)
  )
  expect_type(test_result, "closure")
  expect_identical(
    attr(test_result, "http_methods_supported"),
    "GET"
  )

  # As with actions, different queries should yield different outputs.
  query_missing <- list()
  query_empty <- list(QUERY_STRING = NULL)
  query_no_testkey <- list(QUERY_STRING = "?other=1")
  query_testkey_a1 <- list(QUERY_STRING = "?testkey=a&other=1")
  query_testkey_a2 <- list(QUERY_STRING = "?other=1&testkey=a")
  query_testkey_b <- list(QUERY_STRING = "?testkey=b&other=1")
  query_testkey_z <- list(QUERY_STRING = "?testkey=z&other=1")

  # It should return different "UIs" depending on the request.
  expect_identical(
    test_result(query_missing),
    default_ui
  )
  expect_identical(
    test_result(query_empty),
    default_ui
  )
  expect_identical(
    test_result(query_no_testkey),
    default_ui
  )
  expect_identical(
    test_result(query_testkey_a1),
    testkey_ui_a
  )
  expect_identical(
    test_result(query_testkey_a2),
    testkey_ui_a
  )
  expect_identical(
    test_result(query_testkey_b),
    testkey_ui_b
  )
  expect_identical(
    test_result(query_testkey_z),
    default_ui
  )
})

test_that("Scene changes work for ui functions.", {
  simple_ui_function <- function() {
    return("0-arg ui")
  }
  test_result <- change_scene(
    set_scene(ui = simple_ui_function)
  )
  expect_type(test_result, "closure")
  expect_identical(
    attr(test_result, "http_methods_supported"),
    "GET"
  )
  expect_identical(
    test_result(),
    "0-arg ui"
  )

  req_ui_function <- function(request) {
    return(as.character(length(request)))
  }
  test_result2 <- change_scene(
    set_scene(ui = req_ui_function)
  )
  expect_type(test_result2, "closure")
  expect_identical(
    attr(test_result2, "http_methods_supported"),
    "GET"
  )
  expect_identical(
    test_result2(list(a = 1)),
    "1"
  )
})

test_that("The default ui works as expected.", {
  expect_snapshot(default_ui())
})
