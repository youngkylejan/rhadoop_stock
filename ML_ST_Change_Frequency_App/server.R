Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv("HIVE_HOME" = "/usr/local/hadoop/hive-1.2.0")
Sys.setenv("RHIVE_FS_HOME" = "/home/hadoop/rhive")

library(rhdfs)
library(rmr2)
library(shiny)
library(datasets)
library(ggplot2)

hdfs.init()

freqData <- from.dfs("/ML_CHANGE_FREQUENCY", format = make.input.format("csv", sep = ","))
colnames(freqData$val) <- c("stock", "change", "frequency")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    subset(freqData$val, freqData$val$stock == input$stockID)
  })

  # Show the first "n" observations
  output$view <- renderPlot({
    print(ggplot(datasetInput(), aes(x=change, y=frequency)) + geom_smooth() + geom_point())
  })
})