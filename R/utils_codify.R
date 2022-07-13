#' codify
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
codify <- function(text){
   'new_construction <-
  tuesdata$new_construction %>%
  mutate(
    county =
      county %>%
      str_replace(" County$", "") %>%
      forcats::as_factor(),
    year = paste0(year,"0101") %>% ymd()
    )' %>%
    cat(sep = "\n")
}
