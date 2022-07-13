#' plot_frequencyScatter
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
plot_frequencyScatter <- function(df, x, y , x_lab = waiver(), y_lab = waiver(), title = waiver()){
  df %>%
    ggplot(aes(x = !!sym(x), y = !!sym(y))) +
    geom_jitter(alpha = 0.2) +
    scale_x_date(date_breaks = "1 years", date_labels = "%Y") +
    ggthemes::theme_few() +
    theme(axis.text.x = element_text(angle = 45, vjust = 0, hjust = -1)) +
    labs(
      x = x_lab,
      y = y_lab,
      title = title
    )
}

