#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(
      dashboardHeader(title = "ShinyTuesday"),
      dashboardSidebar(
        sidebarMenu(
          menuItem(text = "About",
                   tabName = "about",
                   icon = icon("info-sign", lib = "glyphicon")),
          mod_2022_week27_ui("2022_week27_1")$sidebar
        )
      ),
      dashboardBody(
        tabItems(
          # About
          tabItem(tabName = "about",
                  mod_about_ui("about_1")),
          # 2022 Week 27
          mod_2022_week27_ui("2022_week27_1")$prep,
          mod_2022_week27_ui("2022_week27_1")$exploratory
          ),
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinytuesday"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
