library(dplyr)
library(sparklyr)
library(data.table)
library(lgr)

lg <- get_logger("ilog")
lg$add_appender(AppenderJson$new("/mnt/s3/ilog/log.jsonl"))

outfile <- "/mnt/s3/ilog/meta.csv"

# funs ---------------------------------------------------------------------

hdfs_list <- function(dir = "/dataset"){
  dd <- system2("hdfs", paste("dfs -ls", dir), stdout = TRUE)
  gsub(".*\\d{2}:\\d{2}\\s", "", dd)[-1]
}

clean_paths <- function(x){
  grep("\\$$", x, value = TRUE, invert = TRUE)
}


# globals -----------------------------------------------------------------

# just so that we do not always have to query them from the hdfs which is slow

sensors <- readRDS("~/BDHackathon2019AT/ilog/sensors.rds")
respondents <- readRDS("~/BDHackathon2019AT/ilog/respondents.rds")

# respondents <- clean_paths(hdfs_list("/dataset/iLog/data/"))


# inputs ------------------------------------------------------------------

lg$info("connecting to spark")
Sys.setenv("SPARK_HOME" = "/usr/lib/spark")
sc <- spark_connect(master = "local")

#' @param sc a spark connection
#' @param respondent hdfs path to a parquet file
summarise_sensor <- function(sc, sensor){
  stopifnot(inherits(sc, "spark_connection"))
  res <- sparklyr::spark_read_parquet(sc = sc, name = "sensors_temp", path = sensor)
  sparklyr::sdf_nrow(res)
}


#' @param sc a spark connection
#' @param respondent hdfs path to the respondent (a directory of parquet files with sensor data)
summarise_respondent <- function(sc, respondent, sensors){
  stopifnot(inherits(sc, "spark_connection"))
  stopifnot(is.character(respondent) && length(respondent) == 1)
  stopifnot(is.character(sensors))
  infiles <- file.path(
    respondent, sensors
  )
  res <- lapply(infiles, function(.x) summarise_sensor(sc = sc, sensor = .x))
  setNames(res, sensors)
}

lg$info("starting collection")

cur <- data.table::fread(outfile)
respondents <- respondents[!respondents %in% cur$respondent]

for (r in respondents){
  r <- file.path("/dataset/iLog/data", r)
  s <- paste0(sensors, ".parquet")
  res <- summarise_respondent(sc = sc, respondent = r, sensors = s)
  res <- as.data.table(res)
  res[, respondent := basename(r)]
  data.table::fwrite(res, file = outfile, append = TRUE)
  lg$info("collected: %s", basename(r))
}
