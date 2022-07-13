library(sass)

variable <-
  list(
    "themeCol_major" = "#367FA9",
    "themeCol_minor" = "#3C8DBC",
    "font_main" = "sans-serif",
    "descriptor_align" = "center"
  )

rule <-
  list(
    # Main
    'h1 {color: $themeCol_major; font-family: $font_main; text-align: $descriptor_align}',
    'div.box.box-solid.box-info>.box-header {background-color: $themeCol_minor; background: $themeCol_minor}',
    'div.box.box-solid.box-info {border-color: $themeCol_minor}',
    # Section - About
    'div[id="about-text"] {
      display: flex;
      text-align: center;
      flex-direction: column;
      justify-content: center;
    } ',
    # Section - Data Prep
    'div[id = "prep-intro"] {
      display: flex;
      align-items: left;
      justify-content: left;
    }',
    'div[id = "prep-intro-text"] {
      display: flex;
      flex-direction: column;
      text-align: left;
      align-items: left;
      justify-content: left;
    }',

    'div[id = "prep-row"] {
      display: flex;
      flex-direction: column;
      align-items: center
    }',
    # Section - Exploratory Data Analysis
    'div[id = "descriptor-row"] {
      display: flex;
      width: baseline;
    }',
    'div[id = "descriptor-col"] {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }',
    'div[class = "shiny-text-output shiny-bound-output"] {
      display: flex;
      align-items: center;
    }'
  )

# Rules ====
sass(input = list(variable, rule), output = "inst/app/www/custom.css")
