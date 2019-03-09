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
    readr::read_csv(x, ) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()
