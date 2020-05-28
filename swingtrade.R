#acoes selecionadas
tickers <- c("B3SA3.SA")

#definindo o periodo historico de 1 ano para as cotacoes
from <- today() - years(2)
to <- today() - years(1)

stocks_data <- tq_get(tickers,
                      get = "stock.prices",
                      from = from,
                      to =)

#retira dias sem operacoes
stocks_data <- stocks_data[complete.cases(stocks_data),]

#transforma os dados em no formato xts
stocks_data_xts <- tbl_xts(stocks_data, cols_to_xts = "close", spread_by = "symbol")

#analise tecnica
chartSeries(stocks_data_xts, TA='addMACD()')
