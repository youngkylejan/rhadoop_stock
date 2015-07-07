#!/usr/bin/Rscript

current.key <- NA
current.val <- NA

conn <- file("stdin", open = "r")

lines <- readLines(conn)

for (i in 1:length(lines)) {
  fields <- unlist(strsplit(lines[i], "\t"))
  
  key = as.character(fields[1])
  date = as.character(fields[2])
  open = as.double(fields[3])
  high = as.double(fields[4])
  low = as.double(fields[5])
  close = as.double(fields[6])
  val = paste(date, open, high, low, close, sep = ",")
  
  if (is.na(current.key)) {
    current.key = key
    current.val = val
  } else {
    if (current.key == key) {
      current.val = paste(current.val, val, sep = "|")
    } else {
      write(paste(current.key, current.val, sep = "\t"), stdout())
      current.key = key
      current.val = val
    }
  }
}

write(paste(current.key, current.val, sep = "\t"), stdout())
close(conn)
