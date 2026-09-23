# Installs the quantmod package, which is used for financial data retrieval and analysis
install.packages("quantmod")

# Installs the PerformanceAnalytics package, which provides tools for return and risk analysis
install.packages("PerformanceAnalytics")

# Loads the quantmod package into the current R session
library(quantmod)

# Downloads historical daily stock price data for Apple (AAPL) from Yahoo Finance
getSymbols("SPY", src = "yahoo", from = "2008-01-01", to = "2022-12-31")

# Calculates daily log returns using Apple’s closing prices
SPY_logret <- diff(log(Cl(SPY)))

# Displays the first few observations of the log return series
head(SPY_logret)

# Removes missing values generated during the return calculation
SPY_logret <- na.omit(SPY_logret)

# Renames the column for clarity and easier interpretation
colnames(SPY_logret) <- "SPY_Log_Return"

# Displays the first few rows of the cleaned log return data
head(SPY_logret)

# Plots Apple’s closing stock price over time as a line chart
plot(Cl(SPY), type = "l",
     main = "SPY Closing Price",
     xlab = "Date",
     ylab = "Price (USD)")

# Plots the time series of Apple’s log returns
plot(SPY_logret,
     main = "Log Returns of SPY",
     col = "blue")

# Creates a histogram showing the frequency distribution of log returns
hist(SPY_logret,
     breaks = 50,
     main = "Frequency Distribution of SPY Log Returns",
     xlab = "Log return",
     col = "lightblue",
     border = "white")

# Creates a density histogram of log returns
hist(SPY_logret,
     breaks = 50,
     freq = FALSE,
     main = "SPY Log Returns with Normal Curve",
     xlab = "Log return",
     col = "lightgray")

# Overlays a normal distribution curve using the sample mean and standard deviation
curve(dnorm(x,
            mean(SPY_logret, na.rm = TRUE),
            sd(SPY_logret, na.rm = TRUE)),
      add = TRUE,
      col = "red",
      lwd = 2)

# Loads the PerformanceAnalytics package
library(PerformanceAnalytics)

# Displays summary statistics such as mean, volatility, skewness, and kurtosis
table.Stats(SPY_logret)
