#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("About"),
    br(),
    column(width = 2),
    column(
      id = "about-text",
      width = 8,
      markdown("
    My name is Eric Surjaatmadja and *ShinyTuesday* is my personal project that follows [TidyTuesday](https://github.com/rfordatascience/tidytuesday),
    a weekly data project hosted by [R for Data Science](https://www.rfordatasci.com/).

    My submission for these weekly posts will be added here, which can be viewed in an interactive format.
    All code for this can be found on my [github](https://github.com/esurjaat/shinytuesday).
    ")
    ),
    column(width = 2)
  )
}

#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
