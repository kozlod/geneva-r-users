
my_ts <- ts(1:24, start = c(2017, 1), end = c(2018, 12), frequency = 12) 
my_ts

suppressWarnings(library(Quandl))
Quandl.api_key("spcnEszf9Pry3bkjnbSU")

cheese_ts <- Quandl("FRED/M01072USM149NNBR", type = "ts")

class(cheese_ts)
str(cheese_ts)

cheese_ts

start(cheese_ts)
end(cheese_ts)
frequency(cheese_ts)
summary(cheese_ts)

window(cheese_ts, start=c(1937, 1), end=c(1942, 12)) 

plot(cheese_ts)

head(as.numeric(cheese_ts))
head(time(cheese_ts))

 x <- decompose(cheese_ts)
str(x)

acf(cheese_ts)

library(forecast)

forecast(cheese_ts, 12)

plot(forecast(cheese_ts, 12), xlim = c(1940, 1945))

library(lubridate)
library(xts)

my_xts <- xts(
           matrix(1:24, ncol = 2), 
           order.by = as.Date('2017-01-01') %m+% months(0:11)
        )
my_xts

cheese_xts <- Quandl("FRED/M01072USM149NNBR", type = "xts")

class(cheese_xts)
str(cheese_xts)

head(cheese_xts)

head(coredata(cheese_xts))

head(index(cheese_xts))

cheese_xts["192501"]

cheese_xts["1925"]

cheese_xts["1941/"]

cheese_xts["T06:00/T10:00"]


first(cheese_xts, '5 month')

last(cheese_xts, '1 year')

xts1 <- xts(c(1,3,2,5), order.by = as.Date(c('2017-01-01', '2017-01-04', '2017-01-05', '2017-01-06')))
xts2 <- xts(c(5,6,4,7), order.by = as.Date(c('2017-01-01', '2017-01-02', '2017-01-03', '2017-01-04')))

xts1 + xts2

merge(xts1, xts2, join = 'inner')

m = merge(xts1, xts2, join = 'outer')
m

na.omit(m)

na.locf(m)

na.approx(m)

apply.yearly(cheese_xts, sum)

end2y = endpoints(cheese_xts, on="years", k=2)
end2y

period.apply(cheese_xts, end2y, sum)

to.yearly(cheese_xts, OHLC = F)

cheese_roll <- rollapply(cheese_xts, 12, sum, align = "left")
head(cheese_roll)

library(quantmod)
btc = getSymbols("BTC-USD", src = "yahoo", auto.assign = F)
str(btc)


library(PerformanceAnalytics)
btc_mth = to.monthly(btc)
head(btc_mth)

ret_btc = Return.calculate(btc_mth$btc.Close)
head(ret_btc)

table.CalendarReturns(ret_btc)

charts.PerformanceSummary(ret_btc, ylog = TRUE) 

library(tidyquant)

cheese_df <- Quandl("FRED/M01072USM149NNBR", type = "raw")

str(cheese_df)

tq_transmute_fun_options()

cheese_df_y <- cheese_df %>%
    tq_transmute(
        select     = VALUE,
        mutate_fun = apply.yearly, 
        FUN        = sum,
        na.rm      = TRUE,
        col_rename = "year_value"
    )
head(cheese_df_y)

library(tsibble)

cheese_tsbl <- cheese_df %>%
  as_tsibble(
    key = id(), 
    index = DATE
  )

head(cheese_tsbl)

class(cheese_tsbl)

x %>% f(y)

f(x, y)

cheese_tsbl %>%
  index_by(year = floor_date(DATE, 'year')) %>% 
  summarise(
    year_value = sum(VALUE)
  ) %>%
  head()
