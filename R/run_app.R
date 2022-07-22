#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @import shinydashboard
#' @import ggplot2
#' @import tibble
#' @import tidyr
#' @import readr
#' @import purrr
#' @import dplyr
#' @import stringr
#' @import forcats
#' @import ggthemes
#' @import lubridate
#' @import shinipsum
#' @import tools
#' @import janitor
#' @import rvest
#' @import leaflet
#' @import ggmap
#' @import glue

run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
