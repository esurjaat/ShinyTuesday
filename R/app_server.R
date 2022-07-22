#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_2022_week27_server("2022_week27_1")
  mod_2022_week28_server("2022_week28_1")
}
