# Developing Data Products Course Project

	This is the final project of the Coursera Data Science course Developing Data Products from JHU.
	The objective of this project is to make an aplication using Shiny that will get the price history of 3 Cryptocurrencies (Bitcoin,Ethereum and Litecoin) and plot it in the user interface. The user can choose to get the google trends data from those cryptocurrencies too and this will be ploted just bellow the price plot. 
	Litecoin and Ethereum price data are get using the [Poloniex](https://poloniex.com) API and the Bitcoin price is get from [https://data.bitcoinity.org](https://data.bitcoinity.org). The USD price of Litecoin and Ethereum are calculated in the server by comparing the price in satoshi of those cryptocurrencies with the Bitcoin price.

## Getting started

### Requeriments

**Tested using Ubuntu 16.04**

- R ([instructions](https://blog.zenggyu.com/en/post/2018-01-29/installing-r-r-packages-e-g-tidyverse-and-rstudio-on-ubuntu-linux/))
```
deb https://cloud.r-project.org/bin/linux/ubuntu xenial/
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

sudo apt update
sudo apt-get r-base r-base-dev
```

- RStudio ([instructions](https://www.rstudio.com/products/rstudio/download/#download))


#### R packages

- Shiny package

```
install.packages("shiny")
```

- gTrendsR package

```
install.packages("gtrendsR")
```

- ggplot2

```
install.packages("ggplot2")
```

- lubridate

```
install.packages("lubridate")
```

- jsonlite

```
install.packages("jsonlite")
```

- dplyr and plyr

```
install.packages(c("plyr",dplyr"))
```

