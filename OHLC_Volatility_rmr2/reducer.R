Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(xts)
library(quantmod)

returns_reducer <- function(k, v) {
  v = as.character(v)
  v = unlist(strsplit(v, "\\|"))
  df = as.data.frame(do.call(rbind, strsplit(v, ",")))
  names(df) = c("date", "open", "high", "low", "close")
  df$date = as.Date(as.character(df$date))
  df$open = as.numeric(df$open)
  df$high = as.numeric(df$high)
  df$low = as.numeric(df$low)
  df$close = as.numeric(df$close)
  
  ohlcXTS = xts(df[, 2:5], order.by = df$date)
  close_to_close_vol = volatility(ohlcXTS, calc = "close")
  close_to_close_vol = data.frame(date = index(close_to_close_vol), coredata(close_to_close_vol))
  names(close_to_close_vol) = c("date", "close_to_close_vol")
  
  garman_klass_vol = volatility(ohlcXTS, calc = "garman.klass")
  garman_klass_vol = data.frame(date = index(garman_klass_vol), coredata(garman_klass_vol))
  names(garman_klass_vol) = c("date", "garman_klass_vol")
  
  rogers_satchell_vol = volatility(ohlcXTS, calc = "rogers.satchell")
  rogers_satchell_vol = data.frame(date = index(rogers_satchell_vol), coredata(rogers_satchell_vol))
  names(rogers_satchell_vol) = c("date", "rogers_satchell_vol")

  yang_zhang_vol = volatility(ohlcXTS, calc = "yang.zhang")
  yang_zhang_vol = data.frame(date = index(yang_zhang_vol), coredata(yang_zhang_vol))
  names(yang_zhang_vol) = c("date", "yang_zhang_vol")
  
  volsDF = data.frame(cbind(as.character(close_to_close_vol$date), close_to_close_vol$close_to_close_vol,
                 garman_klass_vol$garman_klass_vol, rogers_satchell_vol$rogers_satchell_vol,
                 yang_zhang_vol$yang_zhang_vol))
  
  names(volsDF) = c("date", "close_to_close_vol", "garman_klass_vol",
                    "rogers_satchell_vol", "yang_zhang_vol")
  
  keyval(k, volsDF)
}