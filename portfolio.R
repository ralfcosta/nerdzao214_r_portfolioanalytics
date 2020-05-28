#acoes selecionadas
tickers <- c("B3SA3.SA",
             "CYRE3.SA",
             "ECOR3.SA",
             "ABEV3.SA",
             "PETR4.SA",
             "ITUB4.SA",
             "CIEL3.SA",
             "MGLU3.SA",
             "GOLL4.SA",
             "VALE3.SA")

tickers <- sort(tickers)

#definindo o periodo historico de 1 ano para as cotacoes
from <- today() - years(2)
to <- today() - years(1)

stocks_data <- tq_get(tickers,
                      get = "stock.prices",
                      from = from,
                      to = to)

#retira dias sem operacoes
stocks_data <- stocks_data[complete.cases(stocks_data),]

#Retorno diario
stocks_data <- stocks_data %>%
  group_by(symbol) %>%
  tq_mutate(select = adjusted,
            mutate_fun = periodReturn, 
            period = "daily",
            type = "log",
            col_rename = "returns")

stocks_data <- stocks_data %>%
  group_by(symbol) %>%
  tq_mutate(select = returns,
            mutate_fun = runSum,
            n = 1,
            cumulative = T,
            col_rename = "returns_cumulative")

#Analise dos precos historicos e retornos
stocks_data %>%
  ggplot(aes(date, close, color = symbol)) +
  geom_line() +
  ggtitle("Historico de Precos") +
  theme_tq()

stocks_data %>%
  ggplot(aes(date, close, color = symbol)) +
  geom_line() +
  geom_smooth(method = "loess") +
  ggtitle("Historico de Precos") +
  theme_tq() +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y")

stocks_data %>%
  ggplot(aes(date)) +
  geom_bar(aes(date, volume / 1000000, color = symbol), stat = "identity") +
  ggtitle("Volume operados em milhoes de acoes") + 
  theme_tq() +
  facet_wrap(~ symbol, ncol = 2) 

stocks_data %>%
  ggplot(aes(date, returns_cumulative, color = symbol)) +
  geom_line() +
  ggtitle("Retorno Acumulado no Periodo") +
  theme_tq() +
  facet_wrap(~ symbol, ncol = 2)

#Risco
stocks_data %>%
  ggplot(aes(date, returns, color = symbol)) +
  geom_line() +
  ggtitle("Variacao de Risco e Retorno") +
  theme_tq() +
  facet_wrap(~ symbol, ncol = 2)

#Weighting and Optimization
stocks_data_returns <- stocks_data %>%
  select(date, symbol, returns) %>%
  spread(key = symbol, value = returns) %>%
  tk_ts(frequency = 1, silent = T, start = min(stocks_data$date))

#define quais acoes irao compor o portfolio
p <- portfolio.spec(assets = colnames(stocks_data_returns))

#define que os pesos definidos devem totalizar 1
p <- add.constraint(portfolio = p,
                    type = "full_investment")

#define que sera assumida apenas a posicao comprada nas acoes
p <- add.constraint(portfolio = p,
                    type = "long_only")

#define que o objetivo sera o menor risco
p <- add.objective(portfolio = p,
                   type = "risk",
                   name = "var")

#define que o objetivo sera o retorno
p <- add.objective(portfolio = p,
                   type = "return",
                   name = "mean")

#define que o objetivo sera evitar acoes grandes picos negativos
p <- add.objective(portfolio=p, 
                   type = "risk_budget",
                   name = "ETL",
                   arguments = list(p = 0.95),
                   max_prisk = 0.2,
                   min_concentration = T)

#visualiza o conjunto de criterios e objetivos escolhidos
print(p)

#realiza a otimizacao de pesos de acordo com os criterios e objetivos escolhidos
opt <- optimize.portfolio(R = stocks_data_returns,
                          portfolio = p,
                          optimize_method = "ROI",
                          trace = T)

opt

weights1 <- opt$weights
weights2 <- opt$weights

#insira neste trecho os pesos adquiridos para comparacao dos Portfolios
weights <- c(
  weights1,
  weights2
)

#cria uma tabela relacionado os pesos e o numero de portfolio a ser criado
weights_table <-  tibble(tickers) %>%
  tq_repeat_df(n = 2) %>%
  bind_cols(tibble(weights)) %>%
  group_by(portfolio)

#constroi o portfolio de acordo com a tabela de pesos
portfolio_returns <- stocks_data %>%
  tq_repeat_df(n = 2) %>%
  tq_portfolio(assets_col  = symbol, 
               returns_col = returns, 
               weights     = weights_table, 
               col_rename  = "returns")

#calcula o retorno acumulado dos portfolios
portfolio_returns <- portfolio_returns %>%
  group_by(portfolio) %>%
  tq_mutate(select = returns,
            mutate_fun = runSum,
            n = 1,
            cumulative = T,
            col_rename = "returns_cumulative")

#compara o retorno acumulado dos portfolios
portfolio_returns %>%
  ungroup %>% 
  mutate(portfolio = as.factor(portfolio)) %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(x = date, y = returns_cumulative, color = portfolio)) +
  theme_tq() +
  facet_wrap(~ portfolio, ncol = 1)

weights_table %>%
  ungroup %>% 
  mutate(portfolio = as.factor(portfolio)) %>% 
  ggplot(aes(x = tickers, y = weights, fill = portfolio)) +
  geom_bar(stat="identity") +
  theme_tq() +
  facet_wrap(~ portfolio, ncol = 1)
