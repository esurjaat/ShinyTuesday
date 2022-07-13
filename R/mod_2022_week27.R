#' 2022_week27 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_2022_week27_ui <- function(id){
  ns <- NS(id)
  tagList(
    # Sidebar Items ====
    sidebar =
      # Main - SF Rentals ====
      menuItem(
        text = "2022 Week 27 - SF Rentals",
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
          includeMarkdown("inst/app/www/text/y22w27/prep_intro.Rmd")
        ),
        column(width = 2)
      ),
      br(),
      # Item Boxes ====
      fluidRow(
        id = "prep-row",
        # Item 1: SF Rent ====
        box(
          title = "SF Rent",
          width = 6,
          collapsible = TRUE,
          solidHeader = TRUE,
          collapsed = FALSE,
          status = "info",
          includeMarkdown("inst/app/www/text/y22w27/prep_sfRent.Rmd")
          ),
        br(),
        # Item 2: SF Permits ====
        box(
          title = "SF Permits",
          width = 6,
          collapsible = TRUE,
          solidHeader = TRUE,
          collapsed = TRUE,
          status = "info",
          includeMarkdown("inst/app/www/text/y22w27/prep_sfPermits.Rmd")
          ),
        br(),
        # Item 3: New Construction ====
        box(
          width = 6,
          title = "New Construction",
          collapsible = TRUE,
          solidHeader = TRUE,
          collapsed = TRUE,
          status = "info",
          includeMarkdown("inst/app/www/text/y22w27/prep_newConstruction.Rmd")
        )
        )
      ),
    # Exploratory Page Content ====
    exploratory = tabItem(
      tabName = ns("exploratory"),
      fluidRow(h1("Exploratory Data Analysis")),
      br(),
      ## 1st Item - Production by County ====
      fluidRow(
        id = "descriptor-row",
        column(
          width = 8,
          box(
            title = "Total Production by County",
            width = 12,
            collapsible = FALSE,
            solidHeader = TRUE,
            collapsed = FALSE,
            status = "info",
            column(width = 12, mod_g_timeSeries_plot_ui(ns("g_timeSeries_plot_1"))),
            column(width = 3,
                   mod_g_timeSeries_inputs_ui(ns("g_timeSeries_inputs_1"),
                                              color_label = "County",
                                              color_choices = y22w27$new_construction$county,
                                              selected = "San Francisco")
            )
          )
        ),
        column(
          id = "descriptor-col",
          width = 4,
          includeMarkdown("inst/app/www/text/y22w27/exploratory_production.Rmd")
        )
      ),
      br(),
      ## 2nd Item - Posting Frequency ====
      fluidRow(
        id = "descriptor-row",
        column(
          id = "descriptor-col",
          width = 4,
          includeMarkdown("inst/app/www/text/y22w27/exploratory_postFrequency.Rmd")
        ),
        column(
          width = 8,
          box(
            title = "Posting Frequency",
            width = 12,
            collapsible = FALSE,
            solidHeader = TRUE,
            collapsed = FALSE,
            status = "info",
            column(
              width = 6,
              mod_g_frequencyScatter_inputs_ui(ns("g_frequencyScatter_inputs_1"))$view
              ),
            column(
              width = 12,
              mod_g_frequencyScatter_plot_ui(ns("g_frequencyScatter_plot_1"))
              ),
            column(
              width = 3,
              mod_g_frequencyScatter_inputs_ui(ns("g_frequencyScatter_inputs_1"))$county
            )
          )
        )
      ),
      br(),
    )
  )
}


#' 2022_week27 Server Functions
#'
#' @noRd
mod_2022_week27_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Exploratory ====
    ## Item 1
    inputs <- mod_g_timeSeries_inputs_server("g_timeSeries_inputs_1")
    mod_g_timeSeries_plot_server("g_timeSeries_plot_1",
                                 df = y22w27$new_construction,
                                 x = "year",
                                 y = "totalproduction",
                                 color = "county",
                                 x_lab = "Year",
                                 y_lab = "Total Production",
                                 color_lab = "County",
                                 title = "New Construction",
                                 inputs = inputs)

    ## Item 2
    inputs_exp2 <- mod_g_frequencyScatter_inputs_server("g_frequencyScatter_inputs_1")
    mod_g_frequencyScatter_plot_server("g_frequencyScatter_plot_1", inputs = inputs_exp2)

    output$text_exploratory_description_2 <-
      renderText({
        random_text(nchars = 500)
      })


  })
}

## To be copied in the UI
# mod_2022_week27_ui("2022_week27_1")

## To be copied in the server
# mod_2022_week27_server("2022_week27_1")
