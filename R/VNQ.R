# Installs the quantmod package, which is used for financial data retrieval and analysis
install.packages("quantmod")

# Installs the PerformanceAnalytics package, which provides tools for return and risk analysis
install.packages("PerformanceAnalytics")

# Loads the quantmod package into the current R session
library(quantmod)

# Downloads historical daily stock price data for Apple (AAPL) from Yahoo Finance
getSymbols("VNQ", src = "yahoo", from = "2008-01-01", to = "2022-12-31")

# Calculates daily log returns using Apple’s closing prices
VNQ_logret <- diff(log(Cl(VNQ)))

# Displays the first few observations of the log return series
head(VNQ_logret)

# Removes missing values generated during the return calculation
VNQ_logret <- na.omit(VNQ_logret)

# Renames the column for clarity and easier interpretation
colnames(VNQ_logret) <- "VNQ_Log_Return"

# Displays the first few rows of the cleaned log return data
head(VNQ_logret)

# Plots Apple’s closing stock price over time as a line chart
plot(Cl(VNQ), type = "l",
     main = "VNQ Closing Price",
     xlab = "Date",
     ylab = "Price (USD)")

# Plots the time series of Apple’s log returns
plot(VNQ_logret,
     main = "Log Returns of VNQ",
     col = "blue")

# Creates a histogram showing the frequency distribution of log returns
hist(VNQ_logret,
     breaks = 50,
     main = "Frequency Distribution of VNQ Log Returns",
     xlab = "Log return",
     col = "lightblue",
     border = "white")

# Creates a density histogram of log returns
hist(VNQ_logret,
     breaks = 50,
     freq = FALSE,
     main = "VNQ Log Returns with Normal Curve",
     xlab = "Log return",
     col = "lightgray")

# Overlays a normal distribution curve using the sample mean and standard deviation
curve(dnorm(x,
            mean(VNQ_logret, na.rm = TRUE),
            sd(VNQ_logret, na.rm = TRUE)),
      add = TRUE,
      col = "red",
      lwd = 2)

# Loads the PerformanceAnalytics package
library(PerformanceAnalytics)

# Displays summary statistics such as mean, volatility, skewness, and kurtosis
table.Stats(VNQ_logret)
# Loads the quantmod package for financial data retrieval and manipulation
library(quantmod)

# Downloads S&P 500 (^GSPC) and Apple (AAPL) price data from Yahoo Finance
getSymbols(c("SPY", "VNQ"),
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
VNQ_filled <- na.locf(VNQ)

# Forward-fills missing values in S&P 500 index prices
SPY_filled <- na.locf(SPY)

# Calculates daily log returns for Apple using closing prices
VNQ_logret <- diff(log(Cl(VNQ_filled)))

# Calculates daily log returns for the market (S&P 500)
mkt_logret <- diff(log(Cl(SPY_filled)))

# Merges Apple returns, market returns, and the risk-free rate into one dataset
df <- merge(VNQ_logret, mkt_logret, rf, all = FALSE)

# Renames columns for clarity
colnames(df) <- c("VNQ_ret", "MKT_ret", "RF")

# Computes Apple’s excess returns over the risk-free rate
VNQ_excess <- VNQ_logret - rf

# Computes market excess returns over the risk-free rate
market_excess <- mkt_logret - rf

# Runs the CAPM regression: Apple excess return on market excess return
model <- lm(VNQ_excess ~ market_excess, data = df)

# Displays regression results including alpha, beta, and statistical significance
summary(model)

# Loads the xts package for time-series object handling
library(xts)

# Merges excess return series and removes missing observations
df_capm <- na.omit(merge(market_excess, VNQ_excess))

# Renames columns for plotting and analysis
colnames(df_capm) <- c("MKT_excess", "VNQ_excess")

# Converts the xts object into a standard data frame (removes date index)
df_capm <- data.frame(
  MKT_excess  = coredata(df_capm$MKT_excess),
  VNQ_excess = coredata(df_capm$VNQ_excess)
)

# Creates a scatter plot of market excess returns versus Apple excess returns
plot(df_capm$MKT_excess,
     df_capm$VNQ_excess,
     main = "Scatter Plot",
     xlab = "Market Excess Return",
     ylab = "VNQ Excess Return",
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
getSymbols("VNQ",
           src  = "yahoo",
           from = "2008-01-01",
           to   = "2022-12-31")

# Forward-fills missing observations in Apple price data
VNQ_filled <- na.locf(VNQ)

# Computes daily log returns from Apple closing prices
VNQ_logreturn_diff <- diff(log(Cl(VNQ_filled)))

# Removes missing values caused by differencing
VNQ_logreturn <- na.omit(VNQ_logreturn_diff)

# Displays the log return series in a data viewer
#View(VNQ_logreturn)

# Plots the time series of Apple log returns
plot(VNQ_logreturn)

# Plots a histogram to inspect the distribution of log returns
hist(VNQ_logreturn, breaks = 60)

# Displays the autocorrelation function of log returns
acf(VNQ_logreturn)

# Displays the autocorrelation function of squared log returns (volatility clustering)
acf(VNQ_logreturn^2)

# Installs the FinTS package for ARCH/GARCH diagnostic tests
install.packages("FinTS")

# Loads the FinTS package
library(FinTS)

# Performs Engle’s ARCH test on log returns to detect conditional heteroskedasticity
ArchTest(as.numeric(VNQ_logreturn), lags = 12)

# Fits an AR(1) model to the mean of log returns
mean_fit <- arima(VNQ_logreturn, order = c(1, 0, 0))

# Extracts residuals from the mean equation
resid_mean <- residuals(mean_fit)

# Performs ARCH test on mean-adjusted residuals
ArchTest(as.numeric(resid_mean), lags = 12)

# Tests for autocorrelation in raw log returns
Box.test(VNQ_logreturn, lag = 12, type = "Ljung-Box")

# Tests for autocorrelation in squared log returns
Box.test(VNQ_logreturn^2, lag = 12, type = "Ljung-Box")

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
fit_garch <- ugarchfit(spec = spec_garch, data = VNQ_logreturn)

# Displays parameter estimates and diagnostics
show(fit_garch)

# Produces standard diagnostic plots for the GARCH model
plot(fit_garch)

# Extracts conditional volatility estimates from the GARCH model
VNQ_sigma <- sigma(fit_garch)

# Plots the conditional volatility from the GARCH(1,1) model
plot(VNQ_sigma,
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
fit_egarch <- ugarchfit(spec = spec_egarch, data = VNQ_logreturn)

# Displays EGARCH model results
show(fit_egarch)

# Produces diagnostic plots for the EGARCH model
plot(fit_egarch)

# Extracts conditional volatility from the EGARCH model
VNQ_esigma <- sigma(fit_egarch)

# Plots conditional volatility from the EGARCH model
plot(VNQ_esigma,
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
fit_gjrgarch <- ugarchfit(spec = spec_gjrgarch, data = VNQ_logreturn)

# Displays GJR-GARCH estimation results
show(fit_gjrgarch)

# Produces diagnostic plots for the GJR-GARCH model
plot(fit_gjrgarch)

# Extracts conditional volatility from the GJR-GARCH model
VNQ_gjrsigma <- sigma(fit_gjrgarch)

# Plots conditional volatility from the GJR-GARCH model
plot(VNQ_gjrsigma,
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
fit_garchM <- ugarchfit(spec = spec_garchM, data = VNQ_logreturn)

# Displays GARCH-M estimation results
show(fit_garchM)

# Produces diagnostic plots for the GARCH-M model
plot(fit_garchM)

# Extracts conditional volatility from the GARCH-M model
VNQ_garchmsigma <- sigma(fit_garchM)

# Plots conditional volatility from the GARCH-M model
plot(VNQ_garchmsigma,
     main = "Conditional Volatility from GARCHM(1,1)",
     ylab = "Sigma_t",
     xlab = "Date")
# =========================
# 1) Packages
# =========================
library(quantmod)
library(PerformanceAnalytics)
library(xts)
install.packages("RobStatTM")
library(RobStatTM)


# =========================
# 2) Download data
# =========================

# Monthly prices (Yahoo)
getSymbols(
  Symbols = c("VNQ", "EWG", "SPY", "AGG"),
  src = "yahoo",
  from = "2008-01-01",
  to   = "2022-12-31", periodicity = "daily"
)

# Daily 3-Month Treasury yield (FRED), percent per annum (annualized)
getSymbols(
  Symbols = "DGS3MO",
  src  = "FRED",
  from = "2008-01-01",
  to   = "2022-12-31"
)
# =========================
# 3) Risk-free rate -> monthly + average (constant) Rf
# =========================
# Fill missing values in the 3-month Treasury yield
DGS3MO_filled <- na.locf(DGS3MO)

# Convert annualized % yield to an effective monthly return
rf_daily <- (1 + (DGS3MO_filled / 100))^(1/252) - 1

# Use ONE constant monthly risk-free rate (average across all available months)
rf_const_daily <- mean(as.numeric(rf_daily), na.rm = TRUE)

# =========================
# 4) Prices -> returns
# =========================

# Merge Adjusted prices (robust)
prices.data <- merge(Ad(VNQ), Ad(EWG), Ad(SPY), Ad(AGG))
colnames(prices.data) <- c("VNQ", "EWG", "SPY", "AGG")

# Monthly simple returns
returns.data <- CalculateReturns(prices.data, method = "discrete")
returns.datanew <- na.omit(returns.data)

# Quick check
head(returns.datanew)

# =========================
# 5) Downside risk table (constant Rf)
# =========================
table.DownsideRisk(
  R = returns.datanew,
  ci = 0.95,
  scale = 252,
  MAR = 0.01/252,
  Rf = rf_const_daily,
  p = 0.95,
  digits = 10
)

# Computes historical Value at Risk (VaR) at the 95% confidence level
VaR(returns.datanew, p = 0.95, method = "historical")

# Computes modified (Cornish-Fisher) Value at Risk accounting for skewness and kurtosis
VaR(returns.datanew, p = 0.95, method = "modified")

# Computes Gaussian (parametric) Value at Risk assuming normal returns
VaR(returns.datanew, p = 0.95, method = "gaussian")

# Computes Gaussian Expected Shortfall (Conditional VaR)
ES(returns.datanew, p = 0.95, method = "gaussian")

# Computes historical Expected Shortfall
ES(returns.datanew, p = 0.95, method = "historical")

# Computes modified Expected Shortfall accounting for higher moments
ES(returns.datanew, p = 0.95, method = "modified")

# Computes annualized returns and risk measures using the risk-free rate
table.AnnualizedReturns(returns.datanew, Rf = rf_const_daily)

# Estimates CAPM alpha and beta for the three stocks relative to the market
table.CAPM(returns.datanew[,c("VNQ", "EWG"), drop = FALSE],
           returns.datanew[,c("SPY", "AGG"), drop = FALSE],
           Rf = rf_const_daily)

# Computes the Sortino ratio using a zero minimum acceptable return
SortinoRatio(returns.datanew, MAR = 0)

# Computes the Sortino ratio using a positive minimum acceptable return
SortinoRatio(returns.datanew, MAR = 0.00006)

# Computes the Omega ratio using zero as the return threshold
Omega(returns.datanew, threshold = 0)

# Computes the Omega ratio using a positive return threshold
Omega(returns.datanew, threshold = 0.00006)
############################################################
# 0. Packages
############################################################
library(quantmod)
library(PerformanceAnalytics)
library(xts)
library(zoo)

############################################################
# 1. Get daily data from Yahoo
############################################################
getSymbols(c("SPY","AGG","VNQ", "EWG"),
           src  = "yahoo",
           from = "2008-01-01",
           to   = "2022-12-31")

############################################################
# 2. Convert to MONTHLY adjusted prices (explicit)
############################################################
to_monthly_adj <- function(x) {
  m <- to.monthly(Ad(x),
                  indexAt = "lastof",
                  drop.time = TRUE)
  m[,4]  # monthly adjusted close
}

SPY_m <- to_monthly_adj(SPY)
AGG_m <- to_monthly_adj(AGG)
VNQ_m <- to_monthly_adj(VNQ)
EWG_m <- to_monthly_adj(EWG)

prices_2 <- merge(SPY_m, AGG_m)
colnames(prices_2) <- c("SPY","AGG")

prices_3 <- merge(SPY_m, AGG_m, EWG_m, VNQ_m)
colnames(prices_3) <- c("SPY","AGG","EWG", "VNQ")

############################################################
# 3. Monthly DISCRETE returns (portfolio-consistent)
############################################################
R_2 <- na.omit(Return.calculate(prices_2, method="discrete"))
R_3 <- na.omit(Return.calculate(prices_3, method="discrete"))

R_2 <- R_2["2008-01/2022-12"]
R_3 <- R_3["2008-01/2022-12"]

############################################################
# 4. Portfolio weights
############################################################
# Stocks / Bonds
w_6040_2 <- c(SPY=0.60, AGG=0.40)

# Stocks / Bonds / Commodities
w_30202525_3 <- c(SPY=0.30, AGG=0.20, VNQ=0.25, EWG=0.25)

############################################################
# 5. Portfolio returns (monthly rebalancing)
############################################################
P_6040_2 <- Return.portfolio(R_2, weights=w_6040_2, rebalance_on="months")


P_30202525_3 <- Return.portfolio(R_3, weights=w_30202525_3, rebalance_on="months")

colnames(P_6040_2)     <- "S60_B40"
colnames(P_30202525_3) <- "S30_B20_VNQ25_EWG25"

############################################################
# 6. Combine assets + ALL portfolios
############################################################
R_assets <- R_3   # SPY, AGG, VNQ, EWG

P_all <- merge(P_6040_2,
               P_30202525_3)

R_all <- merge(R_assets, P_all)

############################################################
# 7. Summary statistics
############################################################
table.AnnualizedReturns(R_all)
table.Stats(R_all)
table.DownsideRisk(R_all)

############################################################
# 8. Risk-adjusted performance (RF = 0)
############################################################
SharpeRatio.annualized(R_all, Rf=0, scale=12)
SortinoRatio(R_all, MAR=0)
Omega(R_all, L=0)

############################################################
# 9. Risk measures
############################################################
ann_vol <- apply(R_all, 2, sd) * sqrt(12)
ann_vol

maxDrawdown(R_all)

############################################################
# 10. Core plots
############################################################
charts.PerformanceSummary(
  R_all,
  main="Assets and Asset-Allocation Portfolios"
)

chart.RiskReturnScatter(
  R_all,
  main="Risk–Return: Assets and Portfolios"
)

chart.Correlation(
  R_assets,
  histogram=TRUE,
  main="Correlation Structure (Monthly Returns)"
)

############################################################
# 11. Rolling 36-month Sharpe ratios
############################################################
roll_window <- 36

roll_sharpe <- rollapply(
  R_all,
  width = roll_window,
  FUN = function(x)
    as.numeric(SharpeRatio.annualized(x, Rf=0, scale=12)),
  by.column = TRUE,
  align = "right"
)

colnames(roll_sharpe) <- colnames(R_all)

chart.TimeSeries(
  roll_sharpe,
  main="Rolling 36-Month Sharpe (RF = 0)"
)
chart.TimeSeries(
  roll_sharpe,
  main = "Rolling 36-Month Sharpe (RF = 0)",
  legend.loc = "topleft",
  colorset = c(
    "black",      # SPY
    "darkgray",   # AGG
    "goldenrod",  # GSG
    "blue",       # EW 50/50
    "red",        # 60/40
    "darkgreen",  # EW 33/33/33
    "purple"      # 60/30/10
  ),
  lwd = 2
)
