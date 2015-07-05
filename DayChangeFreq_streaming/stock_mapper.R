#!/usr/bin/Rscript

input <- file("stdin", "r")

lines = readLines(input)

for (i in 1:length(lines)) {
    currentLine <- lines[i]
    fields <- unlist(strsplit(currentLine, ","))

    stockID <- as.character(fields[2])
    open <- as.double(fields[3])
    close <- as.double(fields[6])
    change <- as.character(round(close - open, 1))
    key <- paste(stockID, change, sep = ":")

    write(paste(key, stockID, change, 1, sep = "\t"), stdout())
}

close(input)