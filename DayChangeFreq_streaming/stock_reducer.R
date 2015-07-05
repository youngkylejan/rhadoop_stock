#!/usr/bin/Rscript

current.key <- NA
current.val <- 0.0
current.stock <- NA
current.scale <- 0.0

conn <- file("stdin", open = "r")

lines <- readLines(conn)

for (i in 1:length(lines)) {
  currentLine = lines[i]
  fields <- strsplit(currentLine, "\t")
  
  key <- as.character(fields[[1]][1])
  # key <- as.character(fields[[1]][2])

  val <- as.numeric(fields[[1]][4])
  stock <- as.character(fields[[1]][2])
  scale <- as.numeric(fields[[1]][3])

  if (is.na(current.key)) {
    current.key <- key
    current.val <- val
    current.stock <- stock
    current.scale <- scale
  } else {
    if (current.key == key) {
      current.val <- current.val + val
    } else {
      write(paste(current.stock, current.scale, current.val, sep = ","), stdout())
      current.key <- key
      current.val <- val
      current.stock <- stock
      current.scale <- scale
    }
  }
}

write(paste(current.stock, current.scale, current.val, sep = ","), stdout())
close(conn)
