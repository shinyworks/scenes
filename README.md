
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scenes <a href="https://r4ds.github.io/scenes/"><img src="man/figures/logo.svg" align="right" height="424" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/scenes)](https://CRAN.R-project.org/package=scenes)
[![Codecov test
coverage](https://codecov.io/gh/r4ds/scenes/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r4ds/scenes?branch=main)
[![R-CMD-check](https://github.com/r4ds/scenes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r4ds/scenes/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of {scenes} is to make it easy to switch a {shiny} app between
alternative UIs. It was designed to abstract the login-wrapper concept
implemented in [{shinyslack}](https://github.com/r4ds/shinyslack).

## Installation

Install the released version of {scenes} from CRAN:

``` r
install.packages("scenes")
```

Or install the development version of scenes from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("r4ds/scenes")
```

## Use Cases

You can see a demonstration of {scenes}
[here](https://r4dscommunity.shinyapps.io/scenes/).

Some examples of how you might use {scenes} to switch between different
UIs in a Shiny app:

- **Login Wrapper**: Use {scenes} to switch between a login page and the
  main content of the app. This is the original use case for {scenes}.
  It ws designed to abstract the login-wrapper concept implemented in
  [{shinyslack}](https://github.com/r4ds/shinyslack).

- **App Modes**: Use {scenes} to switch between different modes of the
  app, such as a view-only mode and an edit mode, via a query parameter
  (`yourapp.shinyapps.io?mode=edit`).

- **User Roles**: Use {scenes} to switch between different UIs based on
  user roles. For example, a non-admin user might see a different UI
  than an admin user.

The **Login Wrapper** example might look like this:

``` r
library(shiny)
library(scenes)

# Define the different scenes for the app
login_ui <- fluidPage(
  textInput("username", "Username"),
  passwordInput("password", "Password"),
  actionButton("login", "Login")
)

main_ui <- fluidPage(
  h1("Welcome"),
  textOutput("username")
)

# Use the `set_scene()` function to define the different scenes, and
# `change_scene()` to switch between them.
ui <- change_scene(
  set_scene(
    main_ui,
    req_has_cookie(
      "validate_login",
      validation_fn = my_validation_fn
    )
  ),
  fall_through = login_ui
)

server <- function(input, output, session) {
  observeEvent(input$login, {
    use_cookies_package_to_save_cookie_fn(input$username, input$password)
  })

  output$username <- renderText({
    input$username
  })
}

shinyApp(ui = ui, server = server)
```

See [{shinyslack}](https://github.com/r4ds/shinyslack) for a fully
implemented example.

## Similar Packages

Other packages have implemented features in this domain.

- [{brochure}](https://github.com/ColinFay/brochure): This package
  appears to have a great deal of overlap with {scenes}. Colin Fay’s
  implementation appears to potentially be more robust and more complete
  than {scenes}, but at the cost of diverging farther from a “normal”
  shiny app.
- [{shiny.router}](https://appsilon.com/shiny-router-020/): This package
  from [Appsilon](https://appsilon.com) appears to be conceptually
  similar to {scenes}, but focused on routing based on URL. Of the three
  packages listed here, this is the only one available on CRAN.
- [{blaze}](https://github.com/nteetor/blaze): This package from Nate
  Teetor also focuses on routing based on URL. The resulting shiny apps
  are switched via the server function.

## Code of Conduct

Please note that the scenes project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
