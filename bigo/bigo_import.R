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

meals_json_files <- lapply(
  list.files("/mnt/s3/bigO/self_reports"),
  function(x) {
    json_files <- grep("json",list.files(paste0("/mnt/s3/bigO/self_reports/",x,"/meals"),full.names = TRUE),value=TRUE)
    json_in <- lapply(json_files,
           function(y){
           read_json(y, simplifyVector = FALSE)
           }
    )
    
    json_in <- do.call(rbind,json_in)
    
    }
  
)
meals_json_files <- unlist(meals_json_files)

#json_file <- meals_json_files[1]
#json <- read_json(json_file, simplifyVector = FALSE)


library("jsonlite")
help(package="jsonlite")
