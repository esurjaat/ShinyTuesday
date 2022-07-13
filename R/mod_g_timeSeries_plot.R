#' g_timeSeries_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_g_timeSeries_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(outputId = ns("plot"))
  )
}

#' g_timeSeries_plot Server Functions
#'
#' @noRd
mod_g_timeSeries_plot_server <- function(id, df, x, y, color, x_lab, y_lab, color_lab, title, inputs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    plot <-
      reactive({
        df %>%
          filter(!!sym(color) %in% inputs$color()) %>%
          plot_timeSeries(
            df = .,
            x = x,
            y = y,
            color = color,
            x_lab = x_lab,
            y_lab = y_lab,
            color_lab = color_lab,
            title = title)
      })

    output$plot <-
      renderPlot({
        plot()
      })

  })
}

## To be copied in the UI
# mod_g_timeSeries_plot_ui("g_timeSeries_plot_1")

## To be copied in the server
# mod_g_timeSeries_plot_server("g_timeSeries_plot_1", df, x, y, inputs)
