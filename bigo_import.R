library(dplyr)

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
tables_a[ ,id:=as.numeric(substr(file,start=31, stop=33))]
tables_b[ ,id:=as.numeric(substr(file,start=31, stop=33))]
tables_c[ ,id:=as.numeric(substr(file,start=31, stop=33))]

meals <- lapply(
  list.files("/mnt/s3/bigO/self_reports"),
  
  function(x) {
    meal <- strsplit(grep("jpg",list.files(paste0("/mnt/s3/bigO/self_reports/",x,"/meals")),value=TRUE),".",fixed=TRUE)
    if(length(meal)>0){
    meal <- unlist(sapply(meal,function(x)x[[1]]))
    meal_paths <- paste0(paste0("/mnt/s3/bigO/self_reports/",x,"/meals/",meal,".jpg"))
    meals <- data.frame(meal,meal_paths,pid=x)
    }else{
      meals <- NULL
  }
}
)
meals <- data.table::rbindlist(meals)

data.table::setDT(meals)


list.files("/mnt/s3/bigO/self_reports/819/meals")
help(package="jsonlite")