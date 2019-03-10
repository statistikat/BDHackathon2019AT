library(dplyr)
library(sparklyr)
library(data.table)



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

sensors <- readRDS("ilog/sensors.rds")
respondents <- readRDS("ilog/respondents.rds")

# respondents <- clean_paths(hdfs_list("/dataset/iLog/data/"))
respondents <- save
  c(
    "/dataset/iLog/data/a10337e274ebe5094c21df3f614ddfe2c2811f07",
    "/dataset/iLog/data/a199652981c653b290b21f2871fb64ba02a52cbc",
    "/dataset/iLog/data/a1deb035ff938318fff519d56d5c384dd6a2d6f0",
    "/dataset/iLog/data/a33b62941138d3c620714bfc58274b75da3a7e44",
    "/dataset/iLog/data/a3fb844979b37f59b235d9f9b6230ff9bc716a60",
    "/dataset/iLog/data/a482264728b8842b63429182b8cb6766375ce485",
    "/dataset/iLog/data/a4ca7dd3ada3acf6fbe2df9b08f9347ecd81249e",
    "/dataset/iLog/data/a563afd0d5fd2f19fbc4fd6a9e829249c5b0d426",
    "/dataset/iLog/data/a5d910f1ec1618fe8f9d5b2528c9ab451d7d3f8a",
    "/dataset/iLog/data/a66b74003a6957d73c1a7c4c6d028c56c243c23a",
    "/dataset/iLog/data/a7c88fb695983a1a1e77324fd315a56d14b23984",
    "/dataset/iLog/data/a88959ff4c486edb13b4487aa709a82d2572f19f",
    "/dataset/iLog/data/a9e79c94dc8f56d8c6cac255bb2c254366aa418c",
    "/dataset/iLog/data/ace7c1339ce6b225c8d53c5742af1390c4b20047",
    "/dataset/iLog/data/ad253874b4a26415551f3abc81a4edc8752d8c53",
    "/dataset/iLog/data/aeb1c17ee018714b6993a6d9cf5d8b05362ce9c7",
    "/dataset/iLog/data/b001148e448ee95f78ab2270971a226c34139a67",
    "/dataset/iLog/data/b0669d468a31362405befe4dfd4400ff83de4dc4",
    "/dataset/iLog/data/b3759365eda4a3b0680d23f74f5afde0f1a1bc0f",
    "/dataset/iLog/data/b3a504f822eab62fcb4ee845207325ce0067b1a9",
    "/dataset/iLog/data/b3e7eaef4a70f8e5431d5376083d3d1c8c6a2bc3",
    "/dataset/iLog/data/b4c4a09b7dcb69c2c326892594ff3aec0eba6f77",
    "/dataset/iLog/data/b5429c0e7e813c8d2d9c9f5f38eaf9bd59bebc15",
    "/dataset/iLog/data/b75496de7d42a5c42fac7664520424eaa2765ebd",
    "/dataset/iLog/data/b86d874913443dc5450e24583c713bc4a907645e",
    "/dataset/iLog/data/b8f2de9374c79748c8da8cac21c5492f1929e4aa",
    "/dataset/iLog/data/bb81e66f943d77af9abc1c2d0bf761e57a16e142",
    "/dataset/iLog/data/bb8e1134d3848e3bcac8677cff44fbfbde3d7003",
    "/dataset/iLog/data/bbbbd61cfc3f665d4a4d310ec28ffa0118a7fed8",
    "/dataset/iLog/data/bc170ac14c384c947ae90086d86a2315b87c2bb9",
    "/dataset/iLog/data/be2df9b8fea6d45b8eaf7f2c5d3b2d72174a0908",
    "/dataset/iLog/data/be59d8bb288af4ae7edaeba750698c4634eb8ed3",
    "/dataset/iLog/data/beb633728130e0c241b93354547600dba71152ef",
    "/dataset/iLog/data/c1081df1f7a6f048a9918b342fbc03f888eee9d0",
    "/dataset/iLog/data/c12e1cc5bcb89f2895a5675e23c5299cc722d605",
    "/dataset/iLog/data/c292e6462c214446204399da862235cd9f0085a3",
    "/dataset/iLog/data/c3d64521bd4395bda51ade6f99bd12a560fddb27",
    "/dataset/iLog/data/c435d9ffb02ad5074ada96cb6538cb9c23f52479",
    "/dataset/iLog/data/c47e4950cb444183f28df80d59377cfc7db0cf0a",
    "/dataset/iLog/data/c5306ea444e6139cd99cb4df80405cf8d227eab8",
    "/dataset/iLog/data/c564507a22a32b37cfe4b995c1ff39e5e3f8b6f8",
    "/dataset/iLog/data/c5d43b519560321d3b4ed547967c0331307dd029",
    "/dataset/iLog/data/c692dab4302f39e3b69204f5bebd4d3a07e0af31",
    "/dataset/iLog/data/c7060dc4cc5ab605954127d0fa0ed4c1d43ed2ec",
    "/dataset/iLog/data/c885d5c1361dcd464c8f42e1de8a59029ddc9d9b",
    "/dataset/iLog/data/c8ba04cef170db03e3bfa941028b6ea55f5b02bc",
    "/dataset/iLog/data/c96c2b302bdbab08593e8700a8d2e7f1510123a0",
    "/dataset/iLog/data/ca61c6cd8cb5ec5875788ef4dd0c66048d97e341",
    "/dataset/iLog/data/cb76396d5be743891c15c981da1db9bb76aa0df4",
    "/dataset/iLog/data/cbc4b0703c3e38bb91a3c75ba58f41c6210cb31c",
    "/dataset/iLog/data/cc15e6b7dddfe55fb8ec82865c823a3b3ff906d5",
    "/dataset/iLog/data/cccdeec1abac5214484f141ab9380491fd1e8d04",
    "/dataset/iLog/data/ce4bd460ebd49cc22556a4478e97b6a2c23bece8",
    "/dataset/iLog/data/d1716955c2af327f8ed070ad0baa7ea86621b364",
    "/dataset/iLog/data/d6012f147c843393375b64fe2e7297e05e49780d",
    "/dataset/iLog/data/d64a211a8982ae8c224fe2a4ea0e30625380b75f",
    "/dataset/iLog/data/d6928ce308abe646c822a4323f059d2520a8bb42",
    "/dataset/iLog/data/d6dcf90295353f35d2fb1a96fccde3e4ebe3b0a6",
    "/dataset/iLog/data/d74064fb1ad82e65521409ed6fbc531c1aab26dd",
    "/dataset/iLog/data/d77bc45511a2a91ab10bbc5152b5ac58fc501b39",
    "/dataset/iLog/data/d8c8588f0070de734bde392f38e80114fe2fc507",
    "/dataset/iLog/data/d97981cc999aae8fb7c79c45a0deb4435d3ccbd0",
    "/dataset/iLog/data/d99287d08cba304fe6506b99e7b761335a5efcc6",
    "/dataset/iLog/data/db8bbb5cfc4dadfaee6719a6894bc1ffbee18a91",
    "/dataset/iLog/data/dc13410841a225624940b4c6c606f49fa3a6adce",
    "/dataset/iLog/data/dd7ae5fa49f4ea8d07a30e73e914ab0002776779",
    "/dataset/iLog/data/e0a02eb8ce801ddd18597e2f2a14481ae37a880e",
    "/dataset/iLog/data/e0b5893c1c866040717e1dd30f57934d76bb4c65",
    "/dataset/iLog/data/e15e76888290810cd8be82048731f6d09908c30d",
    "/dataset/iLog/data/e264ae57742b7bbcaa4149b7cea99bde800722d7",
    "/dataset/iLog/data/e349410317d7f2b3b6898512af5c4f6669b2e5d8",
    "/dataset/iLog/data/e520de0d3c88741b8940bba5361f47822b1ff46c",
    "/dataset/iLog/data/e85b237d8d4dbee2fef1be22a5e501786e3a0ed1",
    "/dataset/iLog/data/e9d4fb934c038718aadfc4776cb7d0297593f191",
    "/dataset/iLog/data/eafab3d93aba061e8332b8a20b71dbce572f4012",
    "/dataset/iLog/data/eb1c2cbd277961dfae169518d91f1ba5b59d4767",
    "/dataset/iLog/data/ebe492e15dcbd0cbf8a02f2ddde0e58e3d0e4069",
    "/dataset/iLog/data/ec1e20557bc2bddb0db40048aacb023b4082b6ab",
    "/dataset/iLog/data/eded34bf267a235c4d8637faa7619fd3422daf6e",
    "/dataset/iLog/data/ef55c116d31fb3da9cb86ef492b51d25e46e668a",
    "/dataset/iLog/data/f0057160d19020d9be6e05c2ad88d17aa01b515b",
    "/dataset/iLog/data/f15e2d9fff53369bb9ca76bda4eb54116831fa40",
    "/dataset/iLog/data/f176ca75de232ff4a33b57da3b35832cc3cc301a",
    "/dataset/iLog/data/f1f6b17e2136f5995e53a04e6b72b9b0869d84f0",
    "/dataset/iLog/data/f46f158265d9991dce9770aabe65a176080d0bce",
    "/dataset/iLog/data/f48cfd6433f6899e33ab02d99bd45d2a296ee15a",
    "/dataset/iLog/data/f4efc39a54874d6034312a0ebe6e262d5368da73",
    "/dataset/iLog/data/f67c9c4b2f0543559bff223be423fc918a9d2235",
    "/dataset/iLog/data/f757eb660ad08a1985e512d9774c1d251e07945d",
    "/dataset/iLog/data/f8193476d4a2a3b023b9c40ef5a649a64e43096e",
    "/dataset/iLog/data/f8a9b657d162f60b5c8951de926a822f9815c8a8",
    "/dataset/iLog/data/fb375a50df10470dc9323386ad4e09f84277beb9",
    "/dataset/iLog/data/fbd86e9c5dc516a3aea4f3de5dda3978e3080907",
    "/dataset/iLog/data/fc6121723a1088c61152b705434695cdba731a5d",
    "/dataset/iLog/data/fe185fa8e67e93be76a07f58200f0b888adc116c",
    "/dataset/iLog/data/ffff327d0ab1fba6c304b4413cecce0677cd8917"
  )


# inputs ------------------------------------------------------------------

cat("\nConnecting to spark\n")

Sys.setenv("SPARK_HOME" = "/usr/lib/spark")

sc <- spark_connect(
  master = "local"
)

# connection to spark via rest api has atrocious overhead
#
# sc2 <- spark_connect(
#   master = "http://ip-10-0-1-192.eu-west-1.compute.internal:8998",
#   method = "livy",
#   version = "2.4.0"
# )

con <- sc

#' @param con a spark connection
#' @param respondent hdfs path to a parquet file
summarise_sensor <- function(con, sensor){
  stopifnot(inherits(con, "spark_connection"))
  res <- sparklyr::spark_read_parquet(sc = con, name = "sensors_temp", path = sensor)
  sparklyr::sdf_nrow(res)
}


#' @param con a spark connection
#' @param respondent hdfs path to the respondent (a directory of parquet files with sensor data)
summarise_respondent <- function(con, respondent, sensors){
  stopifnot(inherits(con, "spark_connection"))
  stopifnot(is.character(respondent) && length(respondent) == 1)
  stopifnot(is.character(sensors))
  infiles <- file.path(
    respondent, sensors
  )
  res <- lapply(infiles, function(.x) summarise_sensor(con = con, sensor = .x))
  setNames(res, sensors)
}

cat("\nstarting collection\n")

for (r in respondents){
  res <- summarise_respondent(con = sc, respondent = r, sensors = sensor_names)
  res <- as.data.table(res)
  res[, respondent := basename(r)]
  data.table::fwrite(res, file = "out.csv", append = TRUE)
  cat("collected: ", r, "\n")
}




resp <- respondents[[10]]



library(future)



sd <- future_lapply(file.path(resp, sensor_names), function(.x) {
  cat("collecting sensor: ", .x, " \n")
  collect(sparklyr::spark_read_parquet(sc = con, name = "sensors_temp2", path = .x))
  saveRDS()
})

