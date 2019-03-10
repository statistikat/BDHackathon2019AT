library(dplyr)
library(sparklyr)
library(data.table)
library(purrr)
library(lgr)

sensors <- readRDS("~/BDHackathon2019AT/ilog/sensors.rds")
respondents <- readRDS("~/BDHackathon2019AT/ilog/respondents.rds")

Sys.setenv("SPARK_HOME" = "/usr/lib/spark")
sc <- spark_connect(master = "local")

lg <- get_logger("ilog")
lg$add_appender(AppenderJson$new("/mnt/s3/ilog/log.jsonl"))

meta <- data.table::fread("/mnt/s3/ilog/meta.csv")
meta[, respondent := NULL]
# sensors <- vapply(meta, max, numeric(1))
sensors <- names(sensors[sensors < 2400])
sensors <- gsub(".parquet", "", sensors)

respondents <- rev(respondents)

walk(respondents, function(resp){
  cat(resp, "   ")
  
  outfile <- file.path("/mnt/s3/ilog/resp", paste0(basename(resp), ".rds"))
  
  if (file.exists(outfile)){
    cat(crayon::yellow("---- file exists ----\n"))
    return(NULL)
  }
  
  resp <- file.path("/dataset/iLog/data", resp)
  
  # reserve file 
  cat("", file = outfile)
  on.exit(unlink(outfile))
  
  sd <- try(lapply(file.path(resp, sensors), function(.x) {
    cat("*")
    .x <- paste0(.x, ".parquet")
    res <- collect(sparklyr::spark_read_parquet(sc = sc, name = "sensors_temp2", path = .x))
    res
  }))
  
  on.exit(NULL)
  
  if (inherits(sd, "try-error")){
    cat(crayon::red("!!! failed !!!\n"))
    return(NULL)
  }
  
  cat(crayon::green("ok"), "\n")
  
  lg$info("collected sensor data for %s", basename(resp))
  saveRDS(sd, outfile)
})
