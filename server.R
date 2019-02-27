#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(plyr)
library(gtrendsR)
library(jsonlite)
source("aux/functions.R")
shinyServer(function(input, output,session) {
        
        getPriceDate <- function(df,date){
          return(df$price[which(df$date == date)])
        }
        output$info <- renderText({paste0(" ")})
        btc_price <- getBTCPrice()
        output$info <- renderText({paste0(" ")})
        ltc_price <- getPriceCrypto(pair = "BTC_LTC")
        ltc_price <- ltc_price %>% 
          filter(date <= max(btc_price$date))
        ltc_price$price <- ltc_price$priceBTC *
          btc_price$price[which(btc_price$date %in% ltc_price$date)]
        eth_price <- getPriceCrypto(pair = "BTC_ETH")
        eth_price <- eth_price %>% 
          filter(date <= max(btc_price$date))
        eth_price$price <- eth_price$priceBTC *
          btc_price$price[which(btc_price$date %in% eth_price$date)]
        ## Ploting ##
        output$distPlot <- renderPlot({
          
          updateDateInput(session,
                          inputId = "sdate",
                          min=input$date[1],
                          max=input$date[2])
          if(input$crypto == "BTC"){
            
            btc_price <- btc_price %>% 
              filter(date >= input$date[1]) %>%
              filter(date <= input$date[2])
            p <- ggplot(data = btc_price,aes(x=date,y=price)) + 
              geom_line(col="blue") + 
              ggtitle(paste0("Bitcoin price since ",input$date[1],
                             " to ",input$date[2])) + 
              xlab("Date") +
              ylab("Price (USD)")
            if(input$smooth == TRUE){
              p <- p + geom_smooth(method = "loess")
            }
            tryCatch({
              if(input$sdate <= input$date[2] &&
                 input$sdate >= input$date[1]) {
                p <- p + 
                  geom_point(mapping = aes(x=input$sdate,
                                           y=(btc_price %>% filter(date==input$sdate))$price))
                
              
              }
              p
            },error=function(cond){
              updateDateInput(session,
                              inputId = "sdate",
                              value=input$date[2])
            })
            
              
          } else if(input$crypto == "LTC"){
            
            
            #ltc_price$price_p <- ltc_price$price/max(ltc_price$price)*100
            ltc_price <- ltc_price %>% 
              filter(date >= input$date[1]) %>%
              filter(date <= input$date[2])
            p <- ggplot(data = ltc_price,aes(x=date,y=price)) + 
              geom_line(col="blue") + 
              ggtitle(paste0("Litecoin price since ",input$date[1],
                             " to ",input$date[2])) + 
              xlab("Date") +
              ylab("Price (USD)")
            if(input$smooth == TRUE){
              p <- p + geom_smooth(method = "loess")
            }
            
            tryCatch({
              if(input$sdate <= input$date[2] &&
                 input$sdate >= input$date[1]) {
                p <- p + 
                  geom_point(mapping = aes(x=input$sdate,
                                           y=(ltc_price %>% filter(date==input$sdate))$price))
                
                
              }
              p
            },error=function(cond){
              updateDateInput(session,
                              inputId = "sdate",
                              value=input$date[2])
            })
            
            
          } else {
            
            # eth_price$price_p <- eth_price$price/max(eth_price$price)*100
            eth_price <- eth_price %>% 
              filter(date >= input$date[1]) %>%
              filter(date <= input$date[2])
            p <- ggplot(data = eth_price,aes(x=date,y=price)) + 
              geom_line(col="blue") + 
              ggtitle(paste0("Ether price since ",input$date[1],
                             " to ",input$date[2])) + 
              xlab("Date") +
              ylab("Price (USD)")
            if(input$smooth == TRUE){
              p <- p + geom_smooth(method = "loess")
            }
            tryCatch({
              if(input$sdate <= input$date[2] &&
                 input$sdate >= input$date[1]) {
                p <- p + 
                  geom_point(mapping = aes(x=input$sdate,
                                           y=(eth_price %>% filter(date==input$sdate))$price))
                
                
              }
              p
            },error=function(cond){
              updateDateInput(session,
                              inputId = "sdate",
                              value=input$date[2])
            })
          }
          
          
        })
        output$textPrice <- renderText({
           if(input$crypto=="BTC"){
             pDate <- getPriceDate(btc_price,
                                   date = input$sdate)
             paste0("BTC price in ",input$sdate," : $",round(pDate,2))
             
           } else if(input$crypto=="LTC"){
             pDate <- getPriceDate(ltc_price,
                                   date = input$sdate)
             paste0("LTC price in ",input$sdate," : $",round(pDate,2))
           } else {
             pDate <- getPriceDate(eth_price,
                                   date = input$sdate)
             paste0("ETH price in ",input$sdate," : $",round(pDate,2))
           }
          
        })
        output$trendsPlot <- renderPlot({
          if(input$trends == TRUE){
            if(input$crypto == "BTC"){
              
              trends <- gtrends(keyword = "bitcoin",
                                time = paste0(input$date[1]," ",input$date[2]))
              trends <- data.frame(date=as.Date(trends$interest_over_time$date),
                                   percent=trends$interest_over_time$hits)
              trends <- trends %>% 
                filter(date >= input$date[1]) %>%
                filter(date <= input$date[2])
              p <- ggplot(data = trends,aes(x=date,y=percent)) + 
                geom_line(col="blue") + 
                ggtitle(paste0("Bitcoin google search since ",input$date[1],
                               " to ",input$date[2])) + 
                xlab("Date") +
                ylab("Percent")
              if(input$smooth == TRUE){
                p <- p + geom_smooth(method = "loess")
              }
              p
            } else if(input$crypto == "LTC"){
              
              trends <- gtrends(keyword = "litecoin",
                                time = paste0(input$date[1]," ",input$date[2]))
              trends <- data.frame(date=as.Date(trends$interest_over_time$date),
                                   percent=trends$interest_over_time$hits)
              trends <- trends %>% filter(percent != "<1")
              trends$percent <- as.numeric(trends$percent)
              trends <- trends %>% 
                filter(date >= input$date[1]) %>%
                filter(date <= input$date[2])
              p <- ggplot(data = trends,aes(x=date,y=percent)) + 
                geom_line(col="blue") + 
                ggtitle(paste0("Litecoin google search since ",input$date[1],
                               " to ",input$date[2])) + 
                xlab("Date") +
                ylab("Percent")
              if(input$smooth == TRUE){
                p <- p + geom_smooth(method = "loess")
              }
              p
            } else {
              trends <- gtrends(keyword = "ethereum",
                                time = paste0(input$date[1]," ",input$date[2]))
              trends <- data.frame(date=as.Date(trends$interest_over_time$date),
                                   percent=trends$interest_over_time$hits)
              trends <- trends %>% filter(percent != "<1")
              trends$percent <- as.numeric(trends$percent)
              trends <- trends %>% 
                filter(date >= input$date[1]) %>%
                filter(date <= input$date[2])
              p <- ggplot(data = trends,aes(x=date,y=percent)) + 
                geom_line(col="blue") + 
                ggtitle(paste0("Ethereum google search since ",input$date[1],
                               " to ",input$date[2])) + 
                xlab("Date") +
                ylab("Percent")
              if(input$smooth == TRUE){
                p <- p + geom_smooth(method = "loess")
              }
              p
            }
          }

        })
})
