## code to prepare `y22w27` dataset goes here

# Load libraries
library(tidyverse)
library(rvest)
library(lubridate)
library(tidytuesdayR)
library(glue)

# Load via github ===
tuesdata <- tidytuesdayR::tt_load(x = "2022-07-05")

# Rent ====
rent <-
  tuesdata$rent %>%
  mutate(date = ymd(date),
         era = case_when(
           post_id %>% str_detect("^pre2013") ~ "Pre-2013",
           TRUE ~ "Post-2013"),
         id = post_id %>% str_replace("^pre2013_", "")) %>%
  select(id, era, everything(), -post_id) %>%
  arrange(date, nhood, city, county)

# SF Permits ====
sf_permits <-
  tuesdata$sf_permits %>%
  mutate(
    across(.cols = c(permit_type, existing_construction_type, proposed_construction_type),
           .fns = ~factor(.x)),
    across(.cols = c(permit_number, zipcode, record_id), .fns = ~as.character(.x)),
    status_concise = case_when(
      status %in% c("appeal", "issued", "issuing", "plancheck",
                    "reinstated", "filed") ~ "pending",
      status %in% c("approved", "complete") ~ "approved",
      status %in% c("cancelled", "denied", "disapproved", "expired",
                    "overruled", "revoked", "suspend", "withdrawn") ~ "rejected",
      TRUE ~ "Other"
    ))

# New Construction ====
new_construction <-
  tuesdata$new_construction %>%
  mutate(
    county =
      county %>%
      str_replace(" County$", "") %>%
      forcats::as_factor(),
    year = paste0(year,"0101") %>% ymd()
    )

# Combine
y22w27 <-
  list(
    rent = rent,
    sf_permits = sf_permits,
    new_construction = new_construction
  )

# Output
usethis::use_data(y22w27, overwrite = TRUE)
