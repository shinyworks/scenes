# This is the app created in the scenes.Rmd vignette.

# See ?shiny::loadSupport
options(shiny.autoload.r = FALSE)

pkgload::load_all(
  export_all = FALSE,
  helpers = FALSE,
  attach_testthat = FALSE,
  quiet = TRUE
)

# ui1 loads if none of the requirements are met.
ui1 <- shiny::tagList(
  shiny::p("This is UI 1."),
  shiny::a("Add '?code' to the URL to see UI 2.", href = "?code")
)

# ui2 allows us to create the cookie requirement for ui3.
ui2 <- cookies::add_cookie_handlers(
  shiny::tagList(
    shiny::p("This is UI 2."),
    shiny::actionButton("cookie_simple", "Store Simple Cookie"),
    shiny::p("Press the button to see UI 3.")
  )
)

# ui3 allows us to update that cookie to one that will pass validation.
ui3 <- cookies::add_cookie_handlers(
  shiny::tagList(
    shiny::p("This is UI 3."),
    shiny::actionButton("cookie_valid", "Store Valid Cookie"),
    shiny::p("Press the button to see UI 4.")
  )
)

# ui4 only loads when everything is all set. It has a button to reset things.
ui4 <- cookies::add_cookie_handlers(
  shiny::tagList(
    shiny::p("This is UI 4."),
    shiny::actionButton("reset", "Reset"),
    shiny::p("Press the button to go back to UI 2.")
  )
)

our_cookie_validator <- function(cookie_value, acceptable) {
  cookie_value == acceptable
}

scene4 <- set_scene(
  ui4,
  req_has_cookie(
    cookie_name = "our_cookie",
    validation_fn = our_cookie_validator,
    acceptable = "good value" # We can pass variables through to our validator.
  )
)
scene3 <- set_scene(
  ui3,
  req_has_cookie(
    cookie_name = "our_cookie"
  )
)
scene2 <- set_scene(
  ui2,
  req_has_query("code")
)

ui <- change_scene(
  scene4,
  scene3,
  scene2,
  fall_through = ui1
)

# Any UI that the user sees will use this shared server backend.
server <- function(input, output, session) {
  # If they press the button in ui2, save a cookie and reload.
  shiny::observeEvent(
    input$cookie_simple,
    {
      cookies::set_cookie("our_cookie", "bad value")
      session$reload()
    }
  )

  # If they press the button in ui3, save a "valid" cookie and reload.
  shiny::observeEvent(
    input$cookie_valid,
    {
      cookies::set_cookie("our_cookie", "good value")
      session$reload()
    }
  )

  # If they press the reset button in ui4, delete the cookie and reload.
  shiny::observeEvent(
    input$reset,
    {
      cookies::remove_cookie("our_cookie")
      session$reload()
    }
  )
}

shiny::shinyApp(
  ui = ui,
  server = server
)
