Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)

source('~/Documents/Cherry/OHLC_Volatility_rmr2/mapper.R')
source('~/Documents/Cherry/OHLC_Volatility_rmr2/reducer.R')

hdfs.init()

data = from.dfs('/ML_OHLC_STREAMING', format = make.input.format("csv", sep = "\t"))
names(data$val) = c("stock", "ohlcData")
data = to.dfs(data$val)

data.mr = mapreduce(
  input = data,
  map = returns_mapper,
  reduce = returns_reducer,
  combine = TRUE,
  output = "/ML_VOLATILITY"
)

y = from.dfs(data.mr)
