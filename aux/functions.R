#### Aux functions for shiny app project ####
require(plyr)
require(dplyr)
require(jsonlite)
require(gtrendsR)
## BTC PRICE ##
getBTCPrice <- function(){
  btc_price <- read.csv(file = "https://data.bitcoinity.org/export_data.csv?currency=USD&data_type=price_volume&r=day&t=lb&timespan=5y&vu=curr",
                        stringsAsFactors = FALSE)
  btc_price$price_p <- btc_price$price/max(btc_price$price)*100
  btc_price$date <- as.Date(btc_price$Time)
  return(btc_price)
}
## Crypto Price ##
getPriceCrypto <- function(pair="BTC_ETH"){
  url <- paste0("https://poloniex.com/public?command=returnChartData&currencyPair=",pair,"&start=1435699200&end=9999999999&period=14400")
  data <- fromJSON(url)
  data$date <- as.Date(as.POSIXct(x = data$date,
                                  origin="1970-01-01"))
  crypto_df <- ddply(.data = data,
                     .variables = .(date),
                     .fun = summarize,
                     priceBTC=mean(close))
  return(crypto_df)
}

## Get trends ##
getTrends <- function(keywrd="bitcoin"){
  trends <- gtrends(keyword = keywrd)
  trends_df <- data.frame(date=as.Date(trends$interest_over_time$date),
                          percent=trends$interest_over_time$hits)
  return(trends_df)
}
