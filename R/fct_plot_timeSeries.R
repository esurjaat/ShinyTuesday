#' plot_timeSeries
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
plot_timeSeries <- function(df,
                            x,
                            y,
                            color,
                            x_lab = waiver(),
                            y_lab = waiver(),
                            color_lab = waiver(),
                            title = waiver()){
  df %>%
    ggplot(
      aes(
        x = !!sym(x),
        y = !!sym(y),
        color = !!sym(color)
      )
    ) +
    geom_line() +
    geom_point(size = 0.8) +
    labs(x = x_lab, y = y_lab, title = title, color = color_lab) +
    scale_y_continuous(labels = scales::number_format(big.mark = ","),
                       breaks = seq(-8000, 8000, 1000)) +
    scale_x_date(date_breaks = "2 years", labels = scales::date_format("%Y")) +
    ggthemes::theme_few()
}
