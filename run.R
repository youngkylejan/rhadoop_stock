Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv("HIVE_HOME" = "/usr/local/hadoop/hive-1.2.0")
Sys.setenv("RHIVE_FS_HOME" = "/home/hadoop/rhive")

library(rhdfs)
library(rmr2)
library(plyr)
library(highfrequency)

hdfs.init()

data = from.dfs('/ML_DAY', format = make.input.format('csv', sep = ","))
data = data$val
names(data) = c("date", "stock", "open", "high", "low", "close")
data$date = as.Date(data$date)
data$stock = as.character(data$stock)

conn = file("~/Documents/Cherry/SZ_Day_Data/stocks.txt", open = "r")
stocks = readLines(conn)

for (i in 1:length(stocks)) {
  id = as.character(stocks[i])
  dayData = data[data$stock == id,]
  dayXts = xts(dayData[, 3:6], order.by = dayData$date)
  returns = allReturns(dayXts)
  returns = data.frame(date=index(returns), coredata(returns))
  to.dfs(returns, output = paste("/ML_RETURNS/", id, sep = ""), format = make.output.format("csv", sep = ","))
}


