Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv("HIVE_HOME" = "/usr/local/hadoop/hive-1.2.0")
Sys.setenv("RHIVE_FS_HOME" = "/home/hadoop/rhive")

library(rhdfs)
library(rmr2)

source('~/Documents/Cherry/DayAnalyzer_rmr2/mapper.R')
source('~/Documents/Cherry/DayAnalyzer_rmr2/reducer.R')

hdfs.init()

data = from.dfs('/ML_DAY', format = make.input.format("csv", sep = ","))
names(data$val) = c("date", "stock", "open", "high", "low", "close")
data = to.dfs(data$val)

data.mr = mapreduce(
  input = data,
  map = returns_mapper,
  reduce = returns_reducer,
  combine = TRUE,
  output = "/ML_RMR2_RETURNS"
)

