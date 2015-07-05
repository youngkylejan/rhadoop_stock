Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv("HIVE_HOME" = "/usr/local/hadoop/hive-1.2.0")
Sys.setenv("RHIVE_FS_HOME" = "/home/hadoop/rhive")

library(rhdfs)
library(rmr2)
library(RHive)

rhive.init()
hdfs.init()

rhive.connect("127.0.0.1")

tickDataFile = hdfs.file("/HK_2014_Tick/00001.txt", "r", buffersize = 104857600)
tempStream = hdfs.read(tickDataFile)
tickData = iconv(rawToChar(tempStream), from="gb2312", to="utf-8")
