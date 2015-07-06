Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(xts)
library(quantmod)

returns_reducer <- function(k, v) {
  ohlc = v[as.character(v$stock) == as.character(k),]
  ohlc$date = as.Date(ohlc$date)
  ohlcXTS = xts(ohlc[, 3:6], order.by = ohlc$date)
  returns = allReturns(ohlcXTS)
  returns = data.frame(date = index(returns), coredata(returns))
  keyval(k, returns)
}