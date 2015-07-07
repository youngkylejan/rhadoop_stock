Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(xts)
library(quantmod)

returns_reducer <- function(k, v) {
  v = as.character(v)
  df = as.data.frame(do.call(rbind, strsplit(v, ",")))
  names(df) = c("date", "open", "high", "low", "close")
  df$date = as.Date(as.character(df$date))
  df$open = as.numeric(df$open)
  df$high = as.numeric(df$high)
  df$low = as.numeric(df$low)
  df$close = as.numeric(df$close)
  
  ohlcXTS = xts(df[, 2:5], order.by = df$date)
  returns = allReturns(ohlcXTS)
  returns = data.frame(date = index(returns), coredata(returns))
  keyval(k, returns)
}