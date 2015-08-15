# Clean up EDE data a bit
library(readr)
library(dplyr)

data <- read_csv('ede_data.csv') %>%
  mutate(PLANETDISCMETH=str_replace_all(PLANETDISCMETH, '(Raidal Velocity|RV)', 'Radial Velocity')) %>%
  filter(PLANETDISCMETH != "") %>%
  filter(!(is.na(MASS) | is.na(PER)) & MASS > 0)

saveRDS(data, 'ede_data.rds')
