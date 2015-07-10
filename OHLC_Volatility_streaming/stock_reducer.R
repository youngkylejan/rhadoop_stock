#!/usr/bin/Rscript

library(quantmod)

current.key <- NA
current.val <- NA

conn <- file("stdin", open = "r")

lines <- readLines(conn)

for (i in 1:length(lines)) {
  fields <- unlist(strsplit(lines[i], "\t"))
  
  key = as.character(fields[1])
  val = as.character(fields[2])
  
  if (is.na(current.key)) {
    current.key = key
    current.val = val
  } else {
    if (current.key != key) {
      tmp = unlist(strsplit(current.val, "\\|"))
      df = as.data.frame(do.call(rbind, strsplit(tmp, ",")))
      
      names(df) = c("date", "open", "high", "low", "close")
      df$date = as.Date(as.character(df$date))
      df$open = as.numeric(as.character(df$open))
      df$high = as.numeric(as.character(df$high))
      df$low = as.numeric(as.character(df$low))
      df$close = as.numeric(as.character(df$close))
      
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
      volsDF = cbind(current.key, volsDF)
      
      names(volsDF) = c("stock", "date", "close_to_close_vol", "garman_klass_vol",
                        "rogers_satchell_vol", "yang_zhang_vol")
      
      volsDF$close_to_close_vol = round(as.double(as.character(volsDF$close_to_close_vol)), 5)
      volsDF$garman_klass_vol = round(as.double(as.character(volsDF$garman_klass_vol)), 5)
      volsDF$rogers_satchell_vol = round(as.double(as.character(volsDF$rogers_satchell_vol)), 5)
      volsDF$yang_zhang_vol = round(as.double(as.character(volsDF$yang_zhang_vol)), 5)
      
      write.csv(volsDF, stdout())
      
      current.key = key
      current.val = val
    }
  }
}

tmp = unlist(strsplit(current.val, "\\|"))
df = as.data.frame(do.call(rbind, strsplit(tmp, ",")))

names(df) = c("date", "open", "high", "low", "close")
df$date = as.Date(as.character(df$date))
df$open = as.numeric(as.character(df$open))
df$high = as.numeric(as.character(df$high))
df$low = as.numeric(as.character(df$low))
df$close = as.numeric(as.character(df$close))

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
volsDF = cbind(current.key, volsDF)

names(volsDF) = c("stock", "date", "close_to_close_vol", "garman_klass_vol",
                  "rogers_satchell_vol", "yang_zhang_vol")

volsDF$close_to_close_vol = round(as.double(as.character(volsDF$close_to_close_vol)), 5)
volsDF$garman_klass_vol = round(as.double(as.character(volsDF$garman_klass_vol)), 5)
volsDF$rogers_satchell_vol = round(as.double(as.character(volsDF$rogers_satchell_vol)), 5)
volsDF$yang_zhang_vol = round(as.double(as.character(volsDF$yang_zhang_vol)), 5)

write.csv(volsDF, stdout())

close(conn)
