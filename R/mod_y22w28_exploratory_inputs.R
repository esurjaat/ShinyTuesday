#' y22w28_exploratory_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_y22w28_exploratory_inputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    column(width = 3,
           selectInput(ns("year_from"),
                       label = "Year From",
                       choices = 2016:2020,
                       selected = 2019)),
    column(width = 3,
           selectInput(ns("year_to"),
                       label = "Year To",
                       choices = 2017:2021,
                       selected = 2020)),
    column(width = 3,
           selectInput(ns("comparison_type"),
                       label = "Comparison Type",
                       choices = c("Calendar Year", "Quarterly", "Monthly"),
                       selected = "Calendar Year")),
    conditionalPanel(
      sprintf("input['%s'] == 'Quarterly'", ns("comparison_type")),
      column(width = 3,
             radioButtons(ns("quarter"),
                          label = "Quarter",
                          choices = paste0("Q",1:4),
                          selected = "Q1"))
    ),
    conditionalPanel(
      sprintf("input['%s'] == 'Monthly'", ns("comparison_type")),
      column(width = 3,
             selectInput(ns("month"),
                         label = "Month",
                         choices = month.abb,
                         selected = "Jan"))
    )
  )
}

#' y22w28_exploratory_inputs Server Functions
#'
#' @noRd
mod_y22w28_exploratory_inputs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$year_from, {
      updateSelectInput(
        session = session,
        inputId = "year_to",
        choices = 2017:2021 %>% subset(. > input$year_from),
        selected = input$year_to
      )
    })

    observeEvent(input$year_to, {
      updateSelectInput(
        session = session,
        inputId = "year_from",
        choices = 2016:2020 %>% subset(. < input$year_to),
        selected = input$year_from
      )
    })

    return(
      list(
        year_from = reactive({ input$year_from }),
        year_to = reactive({ input$year_to }),
        comparison_type = reactive({ input$comparison_type }),
        quarter = reactive({ input$quarter }),
        month = reactive({ input$month })
      )
    )

  })
}

## To be copied in the UI
# mod_y22w28_exploratory_inputs_ui("y22w28_exploratory_inputs_1")

## To be copied in the server
# mod_y22w28_exploratory_inputs_server("y22w28_exploratory_inputs_1")
