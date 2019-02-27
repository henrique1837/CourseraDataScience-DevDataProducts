#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Cryptocurrencies Prices"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "crypto",
                  label = "Cryptocurrency",
                  choices = list("BTC"="BTC","ETH"="ETH","LTC"="LTC"),
                  selected = "BTC"),
      dateRangeInput("date",
                     label = "Dates",
                     start = Sys.Date() - months(1),
                     end = Sys.Date()-1,
                     min = Sys.Date() - years(3),
                     max=Sys.Date()-1),
      dateInput("sdate",
                label = "Select price at date",
                min = Sys.Date() - months(1),
                max=Sys.Date()-1,
                value = Sys.Date() - 1),
      checkboxInput("smooth",
                    label = "Smooth",
                    value = FALSE),
      checkboxInput("trends",
                    label = "Get Google Trends data",
                    value = FALSE),
      div(h4("Information"),
          p("Select the cryptocurrency to get data price (BTC,ETH or LTC)"),
          p("Select the range of dates to be ploted"),
          p("Select the date to display the price as text"),
          p("Check or uncheck the smooth box in order to apply or not smooth in the plots"),
          p("Check or uncheck the 'get trends data' in order to get google trends data from selected cryptocurrency")),
      div(h4("Data souce"),
          p("Bitcoin price data is from https://data.bitcoinity.org"),
          p("Litecoin and Ethereum price relative to BTC are from Poloniex and treated in R Server in order to get USD price"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       tags$div("Loading...",id="loadmessage")),
       textOutput("info"),
       textOutput(outputId = "textPrice"),
       plotOutput(outputId = "distPlot"),
       plotOutput(outputId = "trendsPlot")
    )
  )
))
