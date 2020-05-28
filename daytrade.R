#acoes selecionadas
tickers <- c("AAPL")

#acessando os dados de cotacoes intraday - Algo Trading - 7 dias
av_api_key("api-key")
stocks_data <- tq_get(tickers, 
                      get = "alphavantage",
                      av_fun = "TIME_SERIES_INTRADAY",
                      interval = "1min",
                      outputsize = "full")
