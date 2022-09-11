# This is a demo that will eventually move into tests and/or a vignette, as soon
# as I figure out a good way to do that.

ui1 <- shiny::fluidPage(
  shiny::p(
    "This is the default app."
  )
)

ui2 <- shiny::fluidPage(
  shiny::p(
    "This is the app to process a query parameter named 'switch'."
  )
)

server <- function(input, output, session) {
  # This doesn't actually do anything yet.
}

# shiny::shinyApp(
#   ui = ui1,
#   server = server
# )

# Add scenes.
shiny::shinyApp(
  ui = scenes::change_scene(
    # First option: Load the app if they have a specific query parameter. Add
    # ?switch to the URL to demonstrate.
    scenes::set_scene(
      ui = ui2,
      scenes::req_has_query("switch")
    ),
    # Second option: Default/fall-through.
    scenes::set_scene(ui = ui1)
  ),
  server = server
)
