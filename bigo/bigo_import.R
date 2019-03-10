library(dplyr)
library(jsonlite)

tables_a <- lapply(
  list.files("/mnt/s3/bigO/tables/table_a/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()

tables_b <- lapply(
  list.files("/mnt/s3/bigO/tables/table_b/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()

tables_c <- lapply(
  list.files("/mnt/s3/bigO/tables/table_c/", full.names = TRUE), 
  function(x) {
    readr::read_csv(x) %>% mutate(file = x)
  }
) %>% data.table::rbindlist()



# numeric id
tables_a[ ,pid:=as.numeric(substr(file,start=30, stop=32))]
tables_b[ ,pid:=as.numeric(substr(file,start=30, stop=32))]
tables_c[ ,pid:=as.numeric(substr(file,start=30, stop=32))]

# parse time correctly
tables_a[, utc_timestamp := lubridate::dmy_hms(utc_timestamp)]
tables_b[, start_local := lubridate::dmy_hms(start_local)]
tables_b[, stop_local := lubridate::dmy_hms(stop_local)]
tables_c[, start_utc_timestamp := lubridate::dmy_hms(start_utc_timestamp)]
tables_c[, stop_utc_timestamp := lubridate::dmy_hms(stop_utc_timestamp)]

meals <- lapply(
  list.files("/mnt/s3/bigO/self_reports"),
  
  function(x) {
    meal <- strsplit(grep("jpg",list.files(paste0("/mnt/s3/bigO/self_reports/",x,"/meals")),value=TRUE),".",fixed=TRUE)
    if(length(meal)>0){
    meal <- unlist(sapply(meal,function(x)x[[1]]))
    meal_paths <- paste0(paste0("/mnt/s3/bigO/self_reports/",x,"/meals/",meal,".jpg"))
    meals <- data.frame(meal,meal_paths,pid=x,stringsAsFactors = FALSE)
    }else{
      meals <- NULL
  }
}
)
meals <- data.table::rbindlist(meals)
meals[ ,pid:=as.numeric(pid)]
meals[ ,meal:=as.numeric(meal)]

meals_json <- lapply(
  list.files("/mnt/s3/bigO/self_reports"),
  function(x) {
    json_files <- grep("json",list.files(paste0("/mnt/s3/bigO/self_reports/",x,"/meals"),full.names = TRUE),value=TRUE)
    json_in <- lapply(json_files,
                      function(y){
                        iny <- as.list(c(pid=x,unlist(read_json(y))))
                      }
    )
    json_in <- lapply(json_in, function(z) data.table::as.data.table(z))
    json_in <- data.table::rbindlist(json_in,fill = TRUE,use.names = TRUE)
  }
  
)
meals_json <- data.table::rbindlist(meals_json,fill = TRUE,use.names = TRUE)
meals_json[, start_datetime := lubridate::ymd_hms(start_datetime)]
meals_json[, pid := as.numeric(pid)]
meals_json[, meal := meals$meal]
