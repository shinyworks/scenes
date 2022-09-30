test_that("set_scene constructs a scene", {
  # There isn't really much special that happens here yet. Eventually we'll test
  # the validation steps, but right now this is just a pass-through.
  expect_snapshot(
    set_scene(
      ui = shiny::HTML("This is not a UI.")
    )
  )

  # Snapshots that include functions fail with covr.
  test_result <- set_scene(
    ui = shiny::HTML("This is not a UI."),
    req_has_query("testkey")
  )
  expect_identical(
    names(test_result),
    c("ui", "actions")
  )
  expect_true(
    test_result$actions[[1]]$check_fn(list(QUERY_STRING = "?testkey=a"))
  )
  test_result$actions[[1]]$check_fn <- "ok"
  expect_snapshot(
    test_result
  )
})
