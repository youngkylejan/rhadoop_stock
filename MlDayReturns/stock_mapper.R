#!/usr/bin/Rscript

input = file("stdin", "r")

lines = readLines(input)

for (i in 1:length(lines)) {
    currentLine <- lines[i]
    fields <- unlist(strsplit(currentLine, ","))

    date <- as.character(fields[1])
    stockID <- as.character(fields[2])
    open <- as.double(fields[3])
    high <- as.double(fields[4])
    low <- as.double(fields[5])
    close <- as.double(fields[6])

    write(paste(stockID, date, open, high, low, close, sep = "\t"), stdout())
}

close(input)
