Sys.setenv("HADOOP_CMD" = "/usr/local/hadoop/bin/hadoop")
Sys.setenv("HADOOP_HOME" = "/usr/local/hadoop")
Sys.setenv("HADOOP_STREAMING" = "/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv("HIVE_HOME" = "/usr/local/hadoop/hive-1.2.0")
Sys.setenv("RHIVE_FS_HOME" = "/home/hadoop/rhive")

library(rhdfs)
library(rmr2)
library(shiny)

stockIDs <- from.dfs("/ML_STOCK_ID", format = "text")$val

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mainland Stock Candle Chart and Returns"),
  titlePanel(" "),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("stockID", label = h3("Choose a Stock ID"), 
                  choices = stockIDs),
      dateRangeInput("dateRange", label = h3("Date Range"),
                     start = "2005-01-01",
                     end = "2015-06-30"),
      selectInput("returnType", label = h3("Choose Time Interval of Returns"),
                  c("daily" = "daily", "weekly" = "weekly", "monthly" = "monthly",
                    "quarterly" = "quarterly", "yearly" = "yearly"))
    ),
    
    # Show a summary of the dataset and an HTML table with the requested
    # number of observations
    mainPanel(
      h3("Stock Time Chart"),
      plotOutput("chart"),
      h3(" "),
      h3("Time Interval Returns"),
      plotOutput("returns")
    )
  )
))