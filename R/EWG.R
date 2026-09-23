# Downloads historical daily stock price data for Apple (AAPL) from Yahoo Finance
getSymbols("EWG", src = "yahoo", from = "2008-01-01", to = "2022-12-31")

# Calculates daily log returns using Apple’s closing prices
EWG_logret <- diff(log(Cl(EWG)))

# Displays the first few observations of the log return series
head(EWG_logret)

# Removes missing values generated during the return calculation
EWG_logret <- na.omit(EWG_logret)

# Renames the column for clarity and easier interpretation
colnames(EWG_logret) <- "EWG_Log_Return"

# Displays the first few rows of the cleaned log return data
head(EWG_logret)

# Plots Apple’s closing stock price over time as a line chart
plot(Cl(EWG), type = "l",
     main = "EWG Closing Price",
     xlab = "Date",
     ylab = "Price (USD)")

# Plots the time series of Apple’s log returns
plot(EWG_logret,
     main = "Log Returns of EWG",
     col = "blue")

# Creates a histogram showing the frequency distribution of log returns
hist(EWG_logret,
     breaks = 50,
     main = "Frequency Distribution of EWG Log Returns",
     xlab = "Log return",
     col = "lightblue",
     border = "white")

# Creates a density histogram of log returns
hist(EWG_logret,
     breaks = 50,
     freq = FALSE,
     main = "EWG Log Returns with Normal Curve",
     xlab = "Log return",
     col = "lightgray")

# Overlays a normal distribution curve using the sample mean and standard deviation
curve(dnorm(x,
            mean(EWG_logret, na.rm = TRUE),
            sd(EWG_logret, na.rm = TRUE)),
      add = TRUE,
      col = "red",
      lwd = 2)

# Loads the PerformanceAnalytics package
library(PerformanceAnalytics)

# Displays summary statistics such as mean, volatility, skewness, and kurtosis
table.Stats(EWG_logret)
# Loads the quantmod package for financial data retrieval and manipulation
library(quantmod)

# Downloads S&P 500 (^GSPC) and Apple (AAPL) price data from Yahoo Finance
getSymbols(c("SPY", "EWG"),
           src  = "yahoo",
           from = "2008-01-01",
           to   = "2022-12-31")

# Downloads the 3-Month Treasury Bill rate from the FRED database
getSymbols("DGS3MO",
           src  = "FRED",
           from = "2008-01-01",
           to   = "2022-12-31")

# Loads the zoo package for time-series data handling
library(zoo)

# Converts the annualized risk-free rate to a daily rate and forward-fills missing values
rf <- na.locf(DGS3MO) / 100 / 252

# Forward-fills missing values in Apple stock prices
EWG_filled <- na.locf(EWG)

# Forward-fills missing values in S&P 500 index prices
SPY_filled <- na.locf(SPY)

# Calculates daily log returns for Apple using closing prices
EWG_logret <- diff(log(Cl(EWG_filled)))

# Calculates daily log returns for the market (S&P 500)
mkt_logret <- diff(log(Cl(SPY_filled)))

# Merges Apple returns, market returns, and the risk-free rate into one dataset
df <- merge(EWG_logret, mkt_logret, rf, all = FALSE)

# Renames columns for clarity
colnames(df) <- c("EWG_ret", "MKT_ret", "RF")

# Computes Apple’s excess returns over the risk-free rate
EWG_excess <- EWG_logret - rf

# Computes market excess returns over the risk-free rate
market_excess <- mkt_logret - rf

# Runs the CAPM regression: Apple excess return on market excess return
model <- lm(EWG_excess ~ market_excess, data = df)

# Displays regression results including alpha, beta, and statistical significance
summary(model)

# Loads the xts package for time-series object handling
library(xts)

# Merges excess return series and removes missing observations
df_capm <- na.omit(merge(market_excess, EWG_excess))

# Renames columns for plotting and analysis
colnames(df_capm) <- c("MKT_excess", "EWG_excess")

# Converts the xts object into a standard data frame (removes date index)
df_capm <- data.frame(
  MKT_excess  = coredata(df_capm$MKT_excess),
  EWG_excess = coredata(df_capm$EWG_excess)
)

# Creates a scatter plot of market excess returns versus Apple excess returns
plot(df_capm$MKT_excess,
     df_capm$EWG_excess,
     main = "Scatter Plot",
     xlab = "Market Excess Return",
     ylab = "EWG Excess Return",
     pch  = 19,
     col  = rgb(0, 0, 1, 0.4))

# Adds the CAPM regression line to the scatter plot
abline(model, col = "red", lwd = 2)
# Installs the rugarch package for estimating GARCH-family volatility models
install.packages("rugarch")

# Loads the rugarch package
library(rugarch)

# Loads quantmod for financial data retrieval
library(quantmod)

# Downloads Apple (AAPL) daily price data from Yahoo Finance
getSymbols("EWG",
           src  = "yahoo",
           from = "2008-01-01",
           to   = "2022-12-31")

# Forward-fills missing observations in Apple price data
EWG_filled <- na.locf(EWG)

# Computes daily log returns from Apple closing prices
EWG_logreturn_diff <- diff(log(Cl(EWG_filled)))

# Removes missing values caused by differencing
EWG_logreturn <- na.omit(EWG_logreturn_diff)

# Displays the log return series in a data viewer
#View(EWG_logreturn)

# Plots the time series of Apple log returns
plot(EWG_logreturn)

# Plots a histogram to inspect the distribution of log returns
hist(EWG_logreturn, breaks = 60)

# Displays the autocorrelation function of log returns
acf(EWG_logreturn)

# Displays the autocorrelation function of squared log returns (volatility clustering)
acf(EWG_logreturn^2)

# Installs the FinTS package for ARCH/GARCH diagnostic tests
install.packages("FinTS")

# Loads the FinTS package
library(FinTS)

# Performs Engle’s ARCH test on log returns to detect conditional heteroskedasticity
ArchTest(as.numeric(EWG_logreturn), lags = 12)

# Fits an AR(1) model to the mean of log returns
mean_fit <- arima(EWG_logreturn, order = c(1, 0, 0))

# Extracts residuals from the mean equation
resid_mean <- residuals(mean_fit)

# Performs ARCH test on mean-adjusted residuals
ArchTest(as.numeric(resid_mean), lags = 12)

# Tests for autocorrelation in raw log returns
Box.test(EWG_logreturn, lag = 12, type = "Ljung-Box")

# Tests for autocorrelation in squared log returns
Box.test(EWG_logreturn^2, lag = 12, type = "Ljung-Box")

# Tests for autocorrelation in mean equation residuals
Box.test(resid_mean, lag = 12, type = "Ljung-Box")

# Tests for autocorrelation in squared residuals
Box.test(resid_mean^2, lag = 12, type = "Ljung-Box")

# Specifies a standard GARCH(1,1) model with AR(1) mean and normal errors
spec_garch <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(1, 0), include.mean = TRUE),
  distribution.model = "norm"
)

# Fits the GARCH(1,1) model to Apple log returns
fit_garch <- ugarchfit(spec = spec_garch, data = EWG_logreturn)

# Displays parameter estimates and diagnostics
show(fit_garch)

# Produces standard diagnostic plots for the GARCH model
plot(fit_garch)

# Extracts conditional volatility estimates from the GARCH model
EWG_sigma <- sigma(fit_garch)

# Plots the conditional volatility from the GARCH(1,1) model
plot(EWG_sigma,
     main = "Conditional Volatility from GARCH(1,1)",
     ylab = "Sigma_t",
     xlab = "Date")

# Specifies an EGARCH(1,1) model to capture leverage effects
spec_egarch <- ugarchspec(
  variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(1, 0), include.mean = TRUE),
  distribution.model = "norm"
)

# Fits the EGARCH(1,1) model
fit_egarch <- ugarchfit(spec = spec_egarch, data = EWG_logreturn)

# Displays EGARCH model results
show(fit_egarch)

# Produces diagnostic plots for the EGARCH model
plot(fit_egarch)

# Extracts conditional volatility from the EGARCH model
EWG_esigma <- sigma(fit_egarch)

# Plots conditional volatility from the EGARCH model
plot(EWG_esigma,
     main = "Conditional Volatility from EGARCH(1,1)",
     ylab = "Sigma_t",
     xlab = "Date")

# Re-plots EGARCH diagnostics (residuals, volatility, QQ-plot)
plot(fit_egarch)

# Specifies a GJR-GARCH(1,1) model to allow asymmetric volatility responses
spec_gjrgarch <- ugarchspec(
  variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)

# Fits the GJR-GARCH model
fit_gjrgarch <- ugarchfit(spec = spec_gjrgarch, data = EWG_logreturn)

# Displays GJR-GARCH estimation results
show(fit_gjrgarch)

# Produces diagnostic plots for the GJR-GARCH model
plot(fit_gjrgarch)

# Extracts conditional volatility from the GJR-GARCH model
EWG_gjrsigma <- sigma(fit_gjrgarch)

# Plots conditional volatility from the GJR-GARCH model
plot(EWG_gjrsigma,
     main = "Conditional Volatility from GJR-GARCH(1,1)",
     ylab = "Sigma_t",
     xlab = "Date")

# Specifies a GARCH-in-Mean (GARCH-M) model where volatility enters the mean equation
spec_garchM <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0),
                        include.mean = TRUE,
                        archm = TRUE,
                        archpow = 2),
  distribution.model = "norm"
)

# Fits the GARCH-M model
fit_garchM <- ugarchfit(spec = spec_garchM, data = EWG_logreturn)

# Displays GARCH-M estimation results
show(fit_garchM)

# Produces diagnostic plots for the GARCH-M model
plot(fit_garchM)

# Extracts conditional volatility from the GARCH-M model
EWG_garchmsigma <- sigma(fit_garchM)

# Plots conditional volatility from the GARCH-M model
plot(EWG_garchmsigma,
     main = "Conditional Volatility from GARCHM(1,1)",
     ylab = "Sigma_t",
     xlab = "Date")


