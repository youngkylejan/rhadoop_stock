Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(xts)
library(quantmod)

cluster_reducer <- function(k, v) {
  correspond_v = v[v$stock == k,]
  v$date = as.character(v$date)
  new_v = as.data.frame(cbind(v$date, v$open, v$high, v$low, v$close), stringsAsFactors = FALSE)
  names(new_v) = c("date", "open", "high", "low", "close")
  keyval(k, new_v)
}