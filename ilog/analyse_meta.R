library(data.table)
library(plotly)



x <- fread("/mnt/s3/ilog/meta.csv")
data.table::setnames(x, names(x), gsub(".parquet", "", names(x)))


m <- as.matrix(x[, !"respondent"], rownames = x$respondent)

d <- as.integer(m > 0)
dim(d) <- dim(m)

colnames(d) <- colnames(m)
rownames(d) <- rownames(m)
d <- t(d)

d <- d[order(rowSums(d)), ]
d <- d[, rev(order(colSums(d)))]

colnames(d) <- strtrim(colnames(d), 6)

plot_ly(x=colnames(d), y=rownames(d), z = d, type = "heatmap", showscale = FALSE, colors = c("#66c2a4", "#238b45"))


sleep_events <-
  c(
    "accelerometerevent",
    "screenevent",
    "orientationevent",
    "rotationvectorevent",
    "linearaccelerationevent",
    "gravityevent",
    "touchevent",
    "gyroscopeevent",
    "headsetplugevent",
    "airplanemodeevent"
  )


d[rownames(d) %in% sleep_events] <- d[rownames(d) %in% sleep_events] + 2

plot_ly(x=colnames(d), y=rownames(d), z = d, type = "heatmap", showscale = FALSE, colors = c("#edf8fb", "#b2e2e2", "#66c2a4", "#238b45")) 
