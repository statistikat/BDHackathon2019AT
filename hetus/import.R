library(magrittr)
library(data.table)
library(dplyr)

hetus <- list.files("/mnt/s3/eu/", full.names = TRUE) %>% 
  lapply(readr::read_csv) %>% 
  data.table::rbindlist()

## number of activities per country
hetus %$% COUNTRY %>% table() %T>% print() %>% plot

# number of respondents per country
hetus %>% filter(!duplicated(paste(COUNTRY, HID, PID))) %$% 
  COUNTRY %>% table() %T>% print() %>% plot()

saveRDS("mnt/s3/hetus.rds")

