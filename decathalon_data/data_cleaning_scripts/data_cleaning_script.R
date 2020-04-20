library(readr)
library(tidyverse)
library(here)
library(janitor)
library(data.table)

# reading in the file and cleaning the variabe names
decathalon_data <- readRDS(here("raw_data/decathlon.rds"))

# removing row names
setDT(decathalon_data, keep.rownames = TRUE)

# making the data longer 
decathalon_data_long <- decathalon_data %>%  pivot_longer(cols = 2:11, 
               names_to = "sport_type",
              values_to = "result")

# renaming a column and tidying the names
decathalon_data_long <- decathalon_data_long %>% rename(name = rn) %>% 
  clean_names() 

decathalon_data_long <- decathalon_data_long %>% 
  mutate(name = tolower(name))

  

# writing to a csv file 
write_csv(decathalon_data_long, "clean_data/decathalon.csv")
