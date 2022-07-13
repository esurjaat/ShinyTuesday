#' tt_setup
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
tt_setup <- function(date = tidytuesdayR::last_tuesday()){
  # Load libraries
  library(tidytuesdayR)

  # Get tt object ====
  a <- tidytuesdayR::tt_load(x = date)

  data <-
    map(.x = names(a),
        .f = function(x){
          a %>% .[[x]]
        }) %>%
    set_names(names(a))

  data
}


