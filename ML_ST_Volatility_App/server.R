Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(shiny)
library(ggplot2)

hdfs.init()

volatilitys = from.dfs("/ML_OHLC_VOLATILITY", format = make.input.format("csv", sep = ","))$val
names(volatilitys) = c("stock", "date", "close_to_close_vol", "garman_klass_vol",
                     "rogers_satchell_vol", "yang_zhang_vol")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the returns dataset
  returnsData <- reactive({
    df = volatilitys[volatilitys$stock == input$stockID,]
    df$close_to_close_vol = as.character(df$close_to_close_vol)
    df
  })  

  # Show the returns
  output$returns <- renderPlot({
    print(ggplot(returnsData(), aes(x = date, y = close_to_close_vol))
          + scale_x_date(limits = c(as.Date(input$dateRange[1]), as.Date(input$dateRange[2])))
          + geom_smooth())
  })
})