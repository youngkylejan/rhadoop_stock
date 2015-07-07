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
      returns = allReturns(ohlcXTS)
      returns = data.frame(date = index(returns), coredata(returns))
      output = cbind(current.key, returns)
      names(output) = c("stock", "daily", "weekly", "monthly", "quarterly", "yearly")
      write.csv(output, stdout())
      
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
returns = allReturns(ohlcXTS)
returns = data.frame(date = index(returns), coredata(returns))
output = cbind(current.key, returns)
names(output) = c("stock", "daily", "weekly", "monthly", "quarterly", "yearly")
write.csv(output, stdout())

close(conn)
