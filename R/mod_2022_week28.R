#' 2022_week28 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_2022_week28_ui <- function(id){
  ns <- NS(id)
  tagList(

    # Sidebar Items ====
    sidebar =
      # Main - SF Rentals ====
    menuItem(
      text = "2022 Week 28 - Euro Flights",
      icon = icon("th", lib = "glyphicon"),
      # Sub - Prep ====
      menuSubItem(
        text = "Prep",
        tabName = ns("prep"),
        icon = icon("minus", lib = "glyphicon")
      ),
      # Sub - Exploratory ====
      menuSubItem(
        text = "Exploratory",
        tabName = ns("exploratory"),
        icon = icon("minus", lib = "glyphicon")
      )
    ),
    # Prep Page Content ====
    prep = tabItem(
      tabName = ns("prep"),
      fluidRow(h1("Data Preparation")),
      br(),
      # Intro Paragraph ====
      fluidRow(
        id = "prep-intro",
        width = 12,
        column(width = 2),
        column(
          id = "prep-intro-text",
          width = 6,
          includeMarkdown("inst/app/www/text/y22w28/prep_intro.Rmd")
        ),
        column(width = 2)
      ),
      br(),
      # Item Boxes ====
      fluidRow(
        id = "prep-row",
        # Item 1: SF Rent ====
        box(
          title = "Flights",
          width = 6,
          collapsible = TRUE,
          solidHeader = TRUE,
          collapsed = FALSE,
          status = "info",
          includeMarkdown("inst/app/www/text/y22w28/prep_flights.Rmd")
        ),
        br(),
        # Item 2: SF Permits ====
        box(
          title = "Coordinates",
          width = 6,
          collapsible = TRUE,
          solidHeader = TRUE,
          collapsed = TRUE,
          status = "info",
          includeMarkdown("inst/app/www/text/y22w28/prep_coordinates.Rmd")
        )
      )
    ),
    # Exploratory Page Content ====
    exploratory = tabItem(
      tabName = ns("exploratory"),
      fluidRow(h1("Exploratory Data Analysis")),
      br(),
      includeMarkdown("inst/app/www/text/y22w28/exploratory_intro.Rmd"),
      br(),
      fluidRow(
        column(width = 1),
        box(
          title = "Euro Airport Activity",
          width = 10,
          collapsible = FALSE,
          solidHeader = FALSE,
          collapse = FALSE,
          status = "info",
          mod_y22w28_exploratory_plot_ui(ns("y22w28_exploratory_plot_1"))
        ),
        column(width = 1)
      ),
      fluidRow(
        column(width = 1),
        box(
          title = "Map Inputs",
          width = 10,
          collapsible = FALSE,
          solidHeader = FALSE,
          collapse = FALSE,
          status = "info",
          mod_y22w28_exploratory_inputs_ui(ns("y22w28_exploratory_inputs_1"))
        ),
        column(width = 1)
      )
    )
  )
}

#' 2022_week28 Server Functions
#'
#' @noRd
mod_2022_week28_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    inputs_xyz <- mod_y22w28_exploratory_inputs_server("y22w28_exploratory_inputs_1")
    mod_y22w28_exploratory_plot_server("y22w28_exploratory_plot_1", inputs = inputs_xyz)

  })
}

## To be copied in the UI
# mod_2022_week28_ui("2022_week28_1")

## To be copied in the server
# mod_2022_week28_server("2022_week28_1")
