library(dplyr)
library(sparklyr)


hdfs_list <- function(dir = "/dataset"){
  dd <- system2("hdfs", paste("dfs -ls", dir), stdout = TRUE)
  gsub(".*\\d{2}:\\d{2}\\s", "", dd)[-1]
}

hdfs_list()

sc <- spark_connect(
  master = "http://ip-10-0-1-192.eu-west-1.compute.internal:8998",
  method = "livy"
)


sparklyr::spark_web(sc)


y <- sparklyr::stream_read_parquet(sc, "hdfs:///dataset/iLog/data/a10337e274ebe5094c21df3f614ddfe2c2811f07/accelerometerevent.parquet/")

