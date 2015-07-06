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
library(quantmod)

hdfs.init()

chartData = from.dfs("/ML_OHLC_CLUSTER")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the chart dataset
  chartXTS <- reactive({
    seriesData = chartData$val[chartData$key == input$stockID,]
    names(seriesData) = c("date", "stock", "open", "high", "low", "close")
    seriesData$date = as.Date(seriesData$date)
    xts(seriesData[, 3:6], order.by = seriesData$date)
  })
  
  # Return the returns dataset
  returnsData <- reactive({
    returns = from.dfs(paste("/ML_RETURNS/", input$stockID, sep = ""),
                           format = make.input.format("csv", sep = ","))$val
    names(returns) = c("date", "daily", "weekly", "monthly", "quarterly", "yearly")
    returns$date = as.Date(returns$date)
    specificReturn = returns[, c("date", input$returnType)]
    names(specificReturn) = c("date", "returns")
    specificReturn
  })  
  
  # Show the stock price chart
  output$chart <- renderPlot({
    chartSeries(chartXTS(), theme = "white", TA = "addVo();addBBands();addCCI()",
                major.ticks = 'months',
                subset = paste(input$dateRange[1], input$dateRange[2], sep = "::"))
  })
  
  # Show the returns
  output$returns <- renderPlot({
    print(ggplot(returnsData(), aes(x = date, y = returns))
          + scale_x_date(limits = c(as.Date(input$dateRange[1]), as.Date(input$dateRange[2])))
          + geom_point() + geom_smooth())
  })
})