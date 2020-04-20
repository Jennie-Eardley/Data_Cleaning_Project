library(tidyverse)
library(readxl)
library(janitor)
library(stringr)

# loading data
ship_data <- read_excel("raw_data/seabirds.xls")

bird_data <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")

ship_data <- ship_data %>% clean_names()

# running queries to discover which columns didn't have any unique values and then removing them (atmp and sal)
ship_data <- ship_data %>% 
  select(-atmp, -sal)


# running queries to discover which column didn't have any unique values and then removing it (sex) and also 
# cleaning names
bird_data <- bird_data %>% 
  clean_names() %>% 
  select(-sex) 

# renaming columns to reflect their future contents 
bird_data <-  bird_data %>% rename(species_common_name = species_common_name_taxon_age_sex_plumage_phase,
                                   species_scientific_name = species_scientific_name_taxon_age_sex_plumage_phase, 
                                   observations = count)

# joining the bird data and ship data together
ship_bird_data <- inner_join(bird_data, ship_data, "record_id") 

# creating a regex pattern
regex_pattern <- "[A-Z0-9 ]+$"

# creating a replacement column without unnecessary information
subbed <- (sub(regex_pattern, '', ship_bird_data$species_common_name))

# removing the old column and adding a new one 
ship_bird_data <- ship_bird_data %>% 
  select(-species_common_name) %>%
  mutate(species_common_names = subbed)

# changing the order of the columns
ship_bird_data <- ship_bird_data[, c(1, 2, 49, 3:48)]

# creating a replacement column without unnecessary information
subbed_scientific <- (sub(regex_pattern, '', ship_bird_data$species_scientific_name))

# removing the old column and adding a new one
ship_bird_data <- ship_bird_data %>% 
  select(-species_scientific_name) %>%
  mutate(species_scientific_names = subbed_scientific)

# changing the order of the columns
ship_bird_data <- ship_bird_data[, c(1, 2, 3, 49, 4:48)]

# removing unnecessary information from abbreviation column
ship_bird_data <- ship_bird_data %>% 
  separate(species_abbreviation, c("abbreviation", "remove"), sep = " ") %>% 
  select(-remove)

# writing script to a csv file 
write_csv(ship_bird_data, "clean_data/ship_bird_data")




