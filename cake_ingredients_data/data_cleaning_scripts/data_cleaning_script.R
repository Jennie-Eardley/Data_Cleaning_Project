library(tidyverse)
library(readr)
library(here)
library(janitor)
# reading in the files 
cake_ingredients_code <- read_csv(here("../raw_data/cake_ingredient_code.csv"))
cake_ingredients_1961 <- read_csv(here("../raw_data/cake-ingredients-1961.csv"))
# changing the shape of the data to make it tidier 
cake_ingredients_1961_long <- cake_ingredients_1961 %>% pivot_longer(cols = 2:35, 
                                               names_to = "code", 
                                               values_to = "quantity")
# making the column names lower case
cake_ingredients_1961_long <- clean_names(cake_ingredients_1961_long)

# replacing the NA values with 0 because they describe quantities and all of the NA values
# represent 0 of the quantity
cake_ingredients_1961_long <- cake_ingredients_1961_long %>% 
  mutate(quantity = replace(quantity, is.na(quantity),0))

# joining the data frames together
joined_cake_ingredients <- cake_ingredients_1961_long %>% 
  inner_join(cake_ingredients_code, "code")

joined_cake_ingredients <-joined_cake_ingredients %>% select(- "code")

# reordering columns to improve readability
col_order <- c("cake", "ingredient", "quantity", "measure")
ordered_joined_cake_ingredients <- joined_cake_ingredients[, col_order]

# replacing the sour cream NA and removing the accidental cup in sour cream
ordered_joined_cake_ingredients <- ordered_joined_cake_ingredients %>% 
  mutate(measure = replace(measure, is.na(measure), "cup")) %>% 
  mutate(ingredient = str_replace(ingredient, "Sour cream cup", "Sour cream"))

write_csv(ordered_joined_cake_ingredients, "../data_cleaning_scripts/clean_cake_ingredients.csv")
