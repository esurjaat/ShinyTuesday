#' y22w28_exploratory_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_y22w28_exploratory_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    "Year over Year Change",
    textOutput(ns("years")),
    textOutput(ns("custom")),
    leafletOutput(ns("leaflet"))
  )
}

#' y22w28_exploratory_plot Server Functions
#'
#' @noRd
mod_y22w28_exploratory_plot_server <- function(id, inputs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    years_text <- reactive({
      glue::glue("{inputs$year_from()} & {inputs$year_to()}")
    })

    custom_text <-
      reactive({
        if (inputs$comparison_type() == 'Calendar Year') {
          'Annual Comparison'
        } else if (inputs$comparison_type() == 'Quarterly') {
          glue::glue("Quarter Comparison: {inputs$quarter()}")
        } else if (inputs$comparison_type() == 'Monthly') {
          glue::glue("Month Comparison: {inputs$month()}")
        }
      })

    output$years <- renderText({ years_text() })
    output$custom <- renderText({ custom_text() })

    data <-
      reactive({
        if(inputs$comparison_type() == "Calendar Year"){
          y22w28$flights %>%
            group_by(apt_icao, pivot_label, state_name, year) %>%
            rename(airport_name = pivot_label, country = state_name) %>%
            summarise(flights = sum(flt_tot_1), .groups = "drop") %>%
            filter(year %in% c(inputs$year_from(), inputs$year_to())) %>%
            pivot_wider(names_from = year, values_from = flights) %>%
            set_names(c("apt_icao", "airport_name", "country", "from", "to")) %>%
            mutate(perc_change = (to - from)/ from) %>%
            left_join(temp, by = "apt_icao") %>%
            filter(!is.na(latitude))
        } else if(inputs$comparison_type() == "Quarterly"){
          y22w28$flights %>%
            mutate(quarter = case_when(
              month(flt_date) >= 1 & month(flt_date) <= 3 ~ "Q1",
              month(flt_date) >= 4 & month(flt_date) <= 6 ~ "Q2",
              month(flt_date) >= 7 & month(flt_date) <= 9 ~ "Q3",
              TRUE ~ "Q4"
            )) %>%
            filter(quarter == inputs$quarter()) %>%
            group_by(apt_icao, pivot_label, state_name, year) %>%
            rename(airport_name = pivot_label, country = state_name) %>%
            summarise(flights = sum(flt_tot_1), .groups = "drop") %>%
            filter(year %in% c(inputs$year_from(), inputs$year_to())) %>%
            pivot_wider(names_from = year, values_from = flights) %>%
            set_names(c("apt_icao", "airport_name", "country", "from", "to")) %>%
            mutate(perc_change = (to - from)/ from) %>%
            left_join(temp, by = "apt_icao") %>%
            filter(!is.na(latitude))
        } else if(inputs$comparison_type() == "Monthly"){
          y22w28$flights %>%
            mutate(month = month.abb[month(flt_date)]) %>%
            filter(month == inputs$month()) %>%
            group_by(apt_icao, pivot_label, state_name, year) %>%
            rename(airport_name = pivot_label, country = state_name) %>%
            summarise(flights = sum(flt_tot_1), .groups = "drop") %>%
            filter(year %in% c(inputs$year_from(), inputs$year_to())) %>%
            pivot_wider(names_from = year, values_from = flights) %>%
            set_names(c("apt_icao", "airport_name", "country", "from", "to")) %>%
            mutate(perc_change = (to - from)/ from) %>%
            left_join(temp, by = "apt_icao") %>%
            filter(!is.na(latitude))
        }
      })

    output$leaflet <-
      renderLeaflet({
        pal <-
          leaflet::colorBin(
            palette = c("#880d1e", # Dark Red (< -50%)
                        "#dd2d4a", # Red (< - 25%)
                        "#f26a8d", # Light Red (< -10%)
                        "#f49cbb", # Pink (< 0%)
                        "#9ef01a", # Lightest Green(> 0%)
                        "#70e000", # Lighter Green(> 10%)
                        "#38b000", # Light Green (> 25%)
                        "#008000"  # Green (> 50%)
                        ),
            bins = c(-9999, -.5, -.25, -.1, 0, .1, .25, .5, 9999))


          data() %>%
            leaflet() %>%
            addProviderTiles(provider = "CartoDB") %>%
            leaflet::addCircles(popup = glue::glue("{data()$airport_name} <br>
                                    <b>Country:</b> {data()$country} <br>
                                    <b>% Change:</b> {(data()$perc_change * 100) %>% round(2)}% <br>
                                    <b>{inputs$year_from()} Flights:</b> {(data()$from) %>% scales::number(big.mark = ',', accuracy = 1)} <br>
                                    <b>{inputs$year_to()} Flights:</b> {(data()$to) %>% scales::number(big.mark = ',', accuracy = 1)}"),
                                color = ~pal(data()$perc_change)) %>%
            addLegend(position = "topright",
                      colors = c("#880d1e", # Dark Red (< -50%)
                                 "#dd2d4a", # Red (< - 25%)
                                 "#f26a8d", # Light Red (< -10%)
                                 "#f49cbb", # Pink (< 0%)
                                 "#9ef01a", # Lightest Green(> 0%)
                                 "#70e000", # Lighter Green(> 10%)
                                 "#38b000", # Light Green (> 25%)
                                 "#008000"  # Green (> 50%)
                                 ),
                      labels = c("> 50% Decrease",
                                 "25% - 50% Decrease",
                                 "10% - 25% Decrease",
                                 "0% - 10% Decrease",
                                 "0% - 10% Increase",
                                 "10% - 25% Increase",
                                 "25% - 50% Increase",
                                 "> 50% Increase"),
                      opacity = 1)

      })

  })
}

## To be copied in the UI
# mod_y22w28_exploratory_plot_ui("y22w28_exploratory_plot_1")

## To be copied in the server
# mod_y22w28_exploratory_plot_server("y22w28_exploratory_plot_1", inputs)
