library(dplyr)

tables_a <- lapply(
  list.files("/dataset/bigo/tables/table_a/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()

tables_b <- lapply(
  list.files("/dataset/bigo/tables/table_b/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()

tables_c <- lapply(
  list.files("/dataset/bigo/tables/table_c/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()


# character id
#tables_a[ ,id:=paste0("pid",substr(file,start=31, stop=33))]
# numeric id
tables_a[ ,id:=as.numeric(substr(file,start=31, stop=33))]
tables_a[,time_]
