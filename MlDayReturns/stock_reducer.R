#!/usr/bin/Rscript

library(quantmod)

current.key <- NA
current.val <- data.frame(timeDate = character(0), stock = character(0), 
  open = double(0), high = double(0), low = double(0), close = double(0), stringsAsFactors = FALSE)

conn <- file("stdin", open = "r")

lines <- readLines(conn)

for (i in 1:length(lines)) {
  fields <- unlist(strsplit(lines[i], "\t"))
  
  key <- as.character(fields[1])
  date <- as.character(fields[2])
  open <- as.double(fields[3])
  high <- as.double(fields[4])
  low <- as.double(fields[5])
  close <- as.double(fields[6])

  if (is.na(current.key)) {
    current.key <- key
    current.val[rownums(current.val) + 1,] = c(key, date, open, high, low, close)
  } else {
    if (current.key == key) {
      current.val[rownums(current.val) + 1,] = c(key, date, open, high, low, close)
    } else {
      write.csv(current.val, stdout())
      current.key <- key
      current.val <- data.frame(timeDate = character(0), stock = character(0), 
        open = double(0), high = double(0), low = double(0), close = double(0), stringAsFactors = FALSE)
      current.val[rownums(current.val) + 1,] = c(key, date, open, high, low, close)
    }
  }
}

write.csv(current.val, stdout())
close(conn)
