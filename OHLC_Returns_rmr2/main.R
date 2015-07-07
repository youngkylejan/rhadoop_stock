Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)

source('~/Documents/Cherry/OHLC_Returns_rmr2/mapper.R')
source('~/Documents/Cherry/OHLC_Returns_rmr2/reducer.R')

hdfs.init()

data = from.dfs('/ML_OHLC_STREAMING', format = make.input.format("csv", sep = "\t"))$val
names(data) = c("stock", "ohlcData")
data = to.dfs(data)

data.mr = mapreduce(
  input = data,
  map = returns_mapper,
  reduce = returns_reducer,
  combine = TRUE
)

y = from.dfs(data.mr)
