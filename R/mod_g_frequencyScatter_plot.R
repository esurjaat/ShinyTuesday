#' g_frequencyScatter_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_g_frequencyScatter_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("frequency_scatter"))
  )
}

#' g_frequencyScatter_plot Server Functions
#'
#' @noRd
mod_g_frequencyScatter_plot_server <- function(id, inputs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    plot <-
      reactive({
        if(inputs$radio_view() == "By County") {
          y22w27$rent %>%
            ggplot(aes(x = date, y = county)) +
            geom_jitter(alpha = 0.2) +
            scale_x_date(date_breaks = "1 years", date_labels = "%Y") +
            ggthemes::theme_few() +
            theme(axis.text.x = element_text(angle = 45, vjust = 0, hjust = 0)) +
            labs(
              x = "Date",
              y = "County",
              title = "Craigslist Posts by County"
            )
        } else if(inputs$radio_view() == "County-Level Neighborhoods") {
          y22w27$rent %>%
            filter(county == (inputs$select_county() %>% tolower())) %>%
            mutate(nhood = factor(nhood)) %>%
            ggplot(aes(x = date, y = nhood)) +
            geom_jitter(alpha = 0.2) +
            scale_x_date(date_breaks = "1 years", date_labels = "%Y") +
            ggthemes::theme_few() +
            theme(axis.text.x = element_text(angle = 45, vjust = 0, hjust = 0)) +
            labs(
              x = "Date",
              y = "Neighborhood",
              title = "Craigslist Posts by Neighborhood",
              subtitle = glue::glue("{inputs$select_county()} County")
            )
        }
      })

    output$frequency_scatter <-
      renderPlot({
        plot()
      })


  })
}

## To be copied in the UI
# mod_g_frequencyScatter_plot_ui("g_frequencyScatter_plot_1")

## To be copied in the server
# mod_g_frequencyScatter_plot_server("g_frequencyScatter_plot_1", inputs)
