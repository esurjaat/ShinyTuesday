## code to prepare `y22w28` dataset goes here

# Libraries ====
library(tidyverse)
library(tidytuesdayR)
library(janitor)
library(rvest)

# Load via Github ====
tuesday <-
  "2022-07-12" %>%
  tidytuesdayR::tt_load()

# Flights Data ====
flights <-
  tuesday$flights %>%
  janitor::clean_names()

# Additional Data ====
## Define URLs Needed
url_icao_base <- "https://en.wikipedia.org/wiki/List_of_airports_by_ICAO_code:_"
starting_letters <-
  flights %>%
  distinct(apt_icao) %>%
  pull(apt_icao) %>%
  str_extract("^.") %>%
  unique()
urls_icao <- paste0(url_icao_base, starting_letters)

## Scrape
icao_list <-
  urls_icao %>%
  map_df(.f = function(x){
    html_object <- x %>% read_html() %>% html_nodes(xpath = "//li")

    node_which <-
      html_object %>%
      html_text() %>%
      str_which(
        pattern =
          flights %>%
          distinct(apt_icao) %>%
          mutate(x = glue::glue("(^{apt_icao})")) %>%
          pull(x) %>%
          paste0(collapse = "|")
      )

    html_object_sub <- html_object[node_which]

    tibble(
      apt_icao = html_object_sub %>% html_text() %>% str_extract(".{4}"),
      href = html_object_sub %>% html_element("a") %>% html_attr("href")
    )
  }) %>%
  # Manual additions of missing airports (in Flights data, but not in Wikipedia List)
  bind_rows(
    tribble(
      ~"apt_icao", ~"href",
      "LFSL", "/wiki/Brive–Souillac_Airport",
      "LEMO", "/wiki/Morón_Air_Base",
      "LEAB", "/wiki/Albacete_Airport",
      "LESJ", "/wiki/Palma_de_Mallorca_Airport",
  )) %>%
  # Manual fix of broken links scraped from Wikipedia (LERE & LFRM excluded as wikipedia page does not exist)
  mutate(
    href = case_when(
      apt_icao == "LDZL" ~ "/wiki/Lu%C4%8Dko_Airfield",
      apt_icao == "LERE" ~ as.character(NA),
      apt_icao == "LFRM" ~ as.character(NA),
      TRUE ~ href
    )
  )

## Scrape & Clean Coordinates off of Airport Wikipedia Pages
coordinates <-
  icao_list %>%
  filter(!is.na(href),
         apt_icao != "LKPR") %>% { # Excluding LKPR because it does not contain coordinates data
    pmap_df(.l = list(airport = .$apt_icao, link = .$href),
            .f = function(airport, link){
              html_object <-
                link %>%
                file.path("https://en.wikipedia.org", .) %>%
                read_html()
              tibble(
                apt_icao = airport,
                longitude =
                  html_object %>%
                  html_nodes(xpath = "//span[@class = 'longitude']") %>%
                  html_text() %>%
                  unique() %>%
                  .[[1]],
                latitude =
                  html_object %>%
                  html_nodes(xpath = "//span[@class = 'latitude']") %>%
                  html_text() %>%
                  unique() %>%
                  .[[1]]
              )
            })
    } %>%
  # Convert to degree format
  mutate(
    across(.cols = c(latitude, longitude),
           .fns = function(x){
             deg <- x %>% str_extract("[0-9]+°") %>% str_remove("°")
             min <- x %>% str_extract("[0-9]+′") %>% str_remove("′")
             sec <- x %>% str_extract("[0-9]+(\\.[0-9]+)?″") %>% str_remove("″")
             dir <- x %>% str_extract("[NEWS]$")
             case_when(
               dir == "S" ~ glue("-{deg} {min} {sec}") %>% str_replace("NA", "0"),
               dir == "W" ~ glue("-{deg} {min} {sec}") %>% str_replace("NA", "0"),
               TRUE ~ glue("{deg} {min} {sec}") %>% str_replace("NA", "0")
             )
           }),
    across(.cols = c(latitude, longitude),
           .fns = function(x){
             conv_unit(x, from = "deg_min_sec", to = "dec_deg") %>% as.numeric()
           })
  )

# List Format ====
y22w28 <-
  list(flights = flights,
       coordinates = coordinates)

# Output ====
usethis::use_data(y22w28, overwrite = TRUE)
