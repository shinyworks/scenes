test_that("set_scene constructs a scene", {
  # There isn't really much special that happens here yet. Eventually we'll test
  # the validation steps, but right now this is just a pass-through.
  expect_snapshot(
    set_scene(
      ui = shiny::HTML("This is not a UI.")
    )
  )
  expect_snapshot(
    set_scene(
      ui = shiny::HTML("This is not a UI."),
      req_has_query("code")
    )
  )
})
