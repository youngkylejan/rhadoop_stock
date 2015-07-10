Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")

library(rhdfs)
library(rmr2)
library(shiny)
library(ggplot2)

hdfs.init()

vols = from.dfs("/ML_OHLC_VOLATILITY", format = make.input.format("csv", sep = ","))$val
names(vols) = c("id", "stock", "date", "close_to_close_vol", "garman_klass_vol",
                     "rogers_satchell_vol", "yang_zhang_vol")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the returns dataset
  returnsData <- reactive({
    df = vols[vols$stock == input$stockID, 2:7]
    df$date = as.Date(df$date)
    df$close_to_close_vol = as.character(df$close_to_close_vol)
    df$garman_klass_vol = as.character(df$garman_klass_vol)
    df$rogers_satchell_vol = as.character(df$rogers_satchell_vol)
    df$yang_zhang_vol = as.character(as.double(sub("\\s+$", "", df$yang_zhang_vol)))
    df = df[, c("date", input$volType)]
    names(df) = c("date", "volatility")
    df
  })

  # Show the volatilities
  output$chart <- renderPlot({
    tmp = subset(returnsData(), date > input$dateRange[1] && date < input$dateRange[2])
    tmp$volatility = as.double(as.character(tmp$volatility))
    qplot(date, volatility, data = tmp, na.rm = TRUE) + ylim(0, 1.5)
  })
})