#' g_timeSeries_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_g_timeSeries_inputs_ui <- function(id, color_label, color_choices, selected = NULL){
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("color"),
      label = color_label,
      choices = color_choices,
      selected = selected,
      multiple = TRUE
      )
  )
}

#' g_timeSeries_inputs Server Functions
#'
#' @noRd
mod_g_timeSeries_inputs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    return(
      list(
        color = reactive({ input$color })
      )
    )

  })
}

## To be copied in the UI
# mod_g_timeSeries_inputs_ui("g_timeSeries_inputs_1", color_label, color_choices)

## To be copied in the server
# mod_g_timeSeries_inputs_server("g_timeSeries_inputs_1")
