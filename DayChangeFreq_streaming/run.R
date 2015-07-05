system("cd $HADOOP_HOME")

system(paste("bin/hadoop jar 
             /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar ",
             " -input /ML_DAY",
             " -output /ML_CHANGE_FREQUENCY",
             " -file /usr/local/hadoop/SzDayAnalyzer/tock_mapper.R",
             " -mapper /usr/local/hadoop/SzDayAnalyzer/stock_mapper.R",
             " -file /usr/local/hadoop/SzDayAnalyzer/stock_reducer.R",
             " -reducer /usr/local/hadoop/SzDayAnalyzer/stock_mapper.R"))

dir <- system("bin/hadoop dfs -ls /ML_CHANGE_FREQUENCY", intern = TRUE)