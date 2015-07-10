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
  titlePanel("Mainland Stock Volatility"),
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
      selectInput("volType", label = h3("Choose Volatility Type"),
                  c("close_to_close_vol" = "close_to_close_vol",
                    "garman_klass_vol" = "garman_klass_vol",
                    "rogers_satchell_vol" = "rogers_satchell_vol",
                    "yang_zhang_vol" = "yang_zhang_vol"))
    ),
    
    # Show a summary of the dataset and an HTML table with the requested
    # number of observations
    mainPanel(
      h3("Stock Volatility Chart"),
      plotOutput("chart")
    )
  )
))