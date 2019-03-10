library(dplyr)
library(sparklyr)

sc <- spark_connect(
  master = "http://ip-10-0-1-192.eu-west-1.compute.internal:8998",
  method = "livy"
)


y <- sparklyr::spark_read_parquet(sc, "hdfs:///dataset/iLog/data/a10337e274ebe5094c21df3f614ddfe2c2811f07/timediariesconfirmation.parquet/")