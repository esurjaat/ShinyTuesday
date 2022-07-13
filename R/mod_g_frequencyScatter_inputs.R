#' g_frequencyScatter_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_g_frequencyScatter_inputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    view = radioButtons(
      ns("radio_view"),
      label = "View Type",
      choices = c("By County", "County-Level Neighborhoods"),
      selected = "By County",
      inline = TRUE),
    county =
      conditionalPanel(
        sprintf("input['%s'] == 'County-Level Neighborhoods'", ns("radio_view")),
        selectInput(
          ns("select_county"),
          label = "Select County",
          choices = y22w27$rent %>%
            filter(!is.na(county)) %>%
            distinct(county) %>%
            arrange(county) %>%
            pull(county) %>%
            toTitleCase(),
          selected = "San Francisco"))
    )
}

#' g_frequencyScatter_inputs Server Functions
#'
#' @noRd
mod_g_frequencyScatter_inputs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    return(
      list(
        radio_view = reactive({ input$radio_view }),
        select_county = reactive({ input$select_county })
      )
    )
  })
}

## To be copied in the UI
# mod_g_frequencyScatter_inputs_ui("g_frequencyScatter_inputs_1")

## To be copied in the server
# mod_g_frequencyScatter_inputs_server("g_frequencyScatter_inputs_1")
