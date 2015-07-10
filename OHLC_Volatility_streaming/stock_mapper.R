#!/usr/bin/Rscript

input = file("stdin", "r")

lines = readLines(input)

for (i in 1:length(lines)) {
    fields <- unlist(strsplit(lines[i], "\t"))
    stock = fields[1]
    ohlcData = fields[2]
    
    write(paste(stock, ohlcData, sep = "\t"), stdout())
}

close(input)
