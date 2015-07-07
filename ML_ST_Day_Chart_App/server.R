Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(shiny)
library(datasets)
library(ggplot2)
library(quantmod)

hdfs.init()

chartData = from.dfs("/ML_OHLC_STREAMING", format = make.input.format("csv", sep = "\t"))$val
names(chartData) = c("stock", "ohlc")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the chart dataset
  chartXTS <- reactive({
    tmp = chartData[chartData$stock == input$stockID,]$ohlc
    tmp = as.character(tmp)
    
    tmp = unlist(strsplit(tmp, "\\|"))
    df = as.data.frame(do.call(rbind, strsplit(tmp, ",")))
    
    names(df) = c("date", "open", "high", "low", "close")
    df$date = as.Date(as.character(df$date))
    df$open = as.numeric(as.character(df$open))
    df$high = as.numeric(as.character(df$high))
    df$low = as.numeric(as.character(df$low))
    df$close = as.numeric(as.character(df$close))
    
    xts(df[, 2:5], order.by = df$date)
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