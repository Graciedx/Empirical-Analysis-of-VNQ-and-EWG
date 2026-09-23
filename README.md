# Empirical Analysis of VNQ and EWG

## Overview

This project conducts an empirical analysis of financial asset returns, risk, volatility, and portfolio behaviour using **R**.

The analysis focuses primarily on the **Vanguard Real Estate ETF (VNQ)** and the **iShares MSCI Germany ETF (EWG)**, with additional market and fixed-income benchmarks including the **S&P 500 ETF (SPY)**, **iShares Core U.S. Aggregate Bond ETF (AGG)**, and the **3-Month U.S. Treasury rate (DGS3MO)**.

The project applies a combination of classical financial econometrics, asset pricing models, and volatility modelling techniques to investigate return behaviour and risk dynamics over the period **2008–2022**.

---

## Objectives

The main objectives of this project are to:

- Examine the historical price and return behaviour of VNQ and EWG.
- Calculate and analyse daily log returns.
- Evaluate return distributions and descriptive statistics.
- Investigate the relationship between asset returns and the broader market.
- Estimate systematic risk using the **Capital Asset Pricing Model (CAPM)**.
- Examine volatility clustering and conditional heteroskedasticity.
- Apply different **GARCH-family models** to model time-varying volatility.
- Compare different volatility specifications, including asymmetric models.
- Analyse the risk-return characteristics of the selected assets and benchmarks.
- Provide an empirical framework for understanding financial market risk and portfolio behaviour.

---

## Data

The project uses historical financial data retrieved programmatically from:

- **Yahoo Finance** – historical prices for VNQ, EWG, SPY and AGG.
- **Federal Reserve Economic Data (FRED)** – 3-Month U.S. Treasury rate (DGS3MO).

### Analysis period

**1 January 2008 – 31 December 2022**

### Main assets

| Ticker | Asset |
|--------|-------|
| VNQ | Vanguard Real Estate ETF |
| EWG | iShares MSCI Germany ETF |
| SPY | SPDR S&P 500 ETF Trust |
| AGG | iShares Core U.S. Aggregate Bond ETF |
| DGS3MO | 3-Month U.S. Treasury Rate |

---

## Methodology

### 1. Data Retrieval

Historical financial data are downloaded directly from Yahoo Finance using the `quantmod` package.

The project retrieves daily market data and uses closing prices to calculate asset returns.

The 3-Month Treasury rate is obtained from FRED and used as a proxy for the risk-free rate.

---

### 2. Return Calculation

Daily logarithmic returns are calculated using:

```
R_t = log(P_t) - log(P_{t-1})
```
### 
3. Descriptive Analysis

The project examines the distribution and behaviour of asset returns using:

- Time-series plots
- Histograms
- Density plots
- Summary statistics
- Mean returns
- Volatility
- Skewness
- Kurtosis

These analyses provide an initial assessment of the characteristics of financial returns.

---

## 4. CAPM Analysis

The **Capital Asset Pricing Model (CAPM)** is used to examine the relationship between asset excess returns and market excess returns.

The model is specified as:

```text
R_i - R_f = α_i + β_i(R_m - R_f) + ε_i
```
The analysis uses the S&P 500 as a market benchmark and the 3-Month Treasury rate as the risk-free rate.
---

## Volatility Analysis

Financial returns often exhibit periods of relatively high and low volatility. Therefore, the project investigates whether volatility is time-varying rather than constant.

### Diagnostic Tests

Several statistical tests are applied before estimating GARCH models, including:

- Autocorrelation Function (ACF)
- ACF of squared returns
- Engle's ARCH test
- Ljung-Box tests

These tests are used to investigate:

- Serial correlation
- Volatility clustering
- Conditional heteroskedasticity
- Dependence in squared returns

---

## GARCH Models

The project estimates several volatility models using the `rugarch` package.

### GARCH(1,1)

A standard GARCH(1,1) model is estimated to capture time-varying conditional volatility.

The model allows current volatility to depend on:

- Previous squared shocks
- Previous conditional variance

The resulting conditional volatility series is extracted and visualised.

---

### EGARCH(1,1)

An **Exponential GARCH (EGARCH)** model is estimated to investigate asymmetric responses in volatility.

Unlike the standard GARCH model, EGARCH allows the impact of positive and negative shocks to differ.

This is particularly relevant when analysing financial assets because negative market shocks may have a different effect on volatility compared with positive shocks.

---

### GJR-GARCH(1,1)

A **GJR-GARCH** model is also estimated to allow asymmetric volatility responses.

The model is used to investigate whether negative shocks generate a different volatility response from positive shocks.

---

### GARCH-in-Mean (GARCH-M)

A **GARCH-in-Mean** specification is estimated to investigate whether conditional volatility enters the return equation.

This provides a framework for examining the relationship between expected returns and volatility.

---
## Results

### 1. Return Distribution

The empirical analysis shows that both VNQ and EWG exhibit non-normal return distributions characterised by negative skewness and high kurtosis.

- VNQ has a positive average daily return of approximately 0.01%, while EWG has an average daily return of approximately -0.01%.
- Both ETFs have medians close to zero, indicating relatively small typical daily price movements.
- VNQ exhibits higher daily volatility than EWG.
- Both VNQ and EWG display negative skewness, indicating greater downside asymmetry.
- VNQ has more negative skewness and a lower minimum return, suggesting greater downside exposure.
- Both ETFs exhibit high kurtosis and fat-tailed distributions, with VNQ showing more extreme tail behaviour.
- Large negative observations are particularly visible around major market stress periods such as the 2008 financial crisis and the COVID-19 shock.

Compared with the two benchmark assets, SPY exhibits higher average returns with moderate volatility, while AGG shows relatively stable daily returns but can still experience occasional sharp downside movements.

### 2. Systematic Risk Exposure

CAPM analysis indicates that both VNQ and EWG have betas above one:

| Asset | Beta |
|-------|------|
| VNQ | 1.175 |
| EWG | 1.104 |

This indicates that both ETFs respond more than proportionally to movements in the SPY market benchmark.

VNQ has the higher beta, suggesting greater sensitivity to systematic market movements.

The estimated alpha for VNQ is not statistically significant, providing no evidence of abnormal returns beyond its market exposure.

For EWG, the estimated alpha is approximately -0.0003 and statistically significant at the 5% level, indicating a negative abnormal return relative to the CAPM benchmark over the examined period.

### 3. Volatility Dynamics

The time-series analysis indicates clear evidence of volatility clustering in both VNQ and EWG, with periods of relatively low volatility interrupted by large positive and negative shocks.

The analysis uses several volatility models:

- GARCH(1,1)
- EGARCH(1,1)
- GJR-GARCH(1,1)
- GARCH-in-Mean (GARCH-M)

The GJR-GARCH results indicate asymmetric volatility behaviour for both ETFs. Negative shocks have a larger impact on conditional volatility than positive shocks of similar magnitude.

The results also indicate strong persistence in volatility clusters, particularly during periods of market stress.

The GARCH-M analysis does not provide statistically significant evidence that higher conditional volatility leads to higher expected daily returns for either VNQ or EWG.

### 4. Downside Risk

Several downside risk measures were used to compare VNQ and EWG with SPY and AGG, including:

- Semi-deviation
- Loss deviation
- Value at Risk (VaR)
- Expected Shortfall (ES)
- Sortino ratio
- Omega ratio

VNQ records the highest semi-deviation at approximately 1.42%, followed by EWG at approximately 1.24%. SPY has a lower semi-deviation of approximately 0.95%, while AGG has the lowest.

At the 5% confidence level, historical VaR estimates are approximately:

| Asset | Historical VaR |
|-------|----------------|
| VNQ | -2.53% |
| EWG | -2.62% |
| SPY | -1.97% |
| AGG | -0.43% |

The historical and Gaussian VaR/ES results indicate that VNQ and EWG are more exposed to extreme downside outcomes than the benchmark assets.

VNQ has a historical Expected Shortfall that is more negative than its VaR, indicating that losses beyond the VaR threshold can become substantially larger during the worst observations.

The Omega ratios for all four ETFs are above 1, indicating that upside gains exceed downside losses under the selected threshold. However, VNQ and particularly EWG have lower Omega ratios than the benchmark assets.

### 5. Risk-Return Performance

The annualised performance analysis produces the following results:

| Asset | Annualised Return | Standard Deviation |
|-------|-------------------|--------------------|
| VNQ | ~6.35% | >30% |
| EWG | ~0% | High |
| SPY | 8.81% | 20.75% |
| AGG | 2.53% | Low |

VNQ generates a relatively strong average return but with substantially higher volatility.

EWG produces an annual return close to zero despite relatively high volatility.

SPY combines a higher annualised return with moderate volatility, while AGG provides lower returns with substantially lower volatility.

The risk-adjusted performance analysis also shows that SPY and AGG have higher Sortino ratios than VNQ and EWG.

### 6. Portfolio Analysis

To evaluate the diversification contribution of VNQ and EWG, the analysis compares:

**60/40 Benchmark**
- 60% SPY
- 40% AGG

**Extended Portfolio**
- 30% SPY
- 20% AGG
- 25% VNQ
- 25% EWG

The results are:

| Metric | 60/40 SPY-AGG | 30/20/25/25 Portfolio |
|--------|---------------|------------------------|
| Annualised Return | 6.8% | 5.7% |
| Annualised Volatility | 10.2% | 15.6% |
| Sharpe Ratio | ~0.66 | ~0.36 |
| Sortino Ratio | ~0.30 | ~0.18 |
| Omega Ratio | 1.68 | 1.41 |

The extended portfolio has higher volatility and lower annualised return than the 60/40 benchmark over the examined period.

The cumulative return analysis also shows deeper drawdowns and lower terminal wealth for the portfolio containing VNQ and EWG.

### 7. Diversification Analysis

The correlation analysis shows that VNQ and EWG have relatively low correlations with SPY and AGG during normal market conditions, which can provide potential diversification benefits.

However, correlations increase during major market shocks.

This is particularly relevant during periods such as the COVID-19 shock, when global equities and real estate experienced simultaneous stress.

Therefore, the diversification benefit of VNQ and EWG is not constant over time. The benefits are more visible during relatively calm market conditions and become more limited during periods of severe market stress.

The rolling 36-month Sharpe ratio analysis also shows that the extended portfolio can approach the performance of the 60/40 benchmark during favourable periods, but tends to underperform during downturns.

## Key Findings

The empirical analysis produces several main findings:

1. **VNQ and EWG exhibit non-normal return distributions**, with negative skewness and high kurtosis.

2. **Both ETFs have beta values above one**, indicating relatively high sensitivity to systematic market movements.

3. **Volatility clustering is present** in both VNQ and EWG.

4. **Negative shocks have a stronger effect on volatility**, as shown by the GJR-GARCH analysis.

5. **Higher conditional volatility does not have a statistically significant effect on expected daily returns**, based on the GARCH-M models.

6. **VNQ and EWG exhibit greater downside risk** than the SPY and AGG benchmarks across several downside risk measures.

7. **VNQ provides relatively high average returns but also substantially higher volatility.**

8. **EWG provides relatively low average returns despite relatively high volatility** over the examined period.

9. **The 30/20/25/25 portfolio produces lower risk-adjusted performance than the 60/40 benchmark** in the examined sample.

10. **VNQ and EWG can provide diversification benefits during normal market conditions**, but these benefits become weaker during major market shocks when correlations increase.

## Conclusion

This project empirically examines whether adding US listed real estate exposure through VNQ and German equity exposure through EWG improves the risk-adjusted performance and diversification of a traditional stock-bond portfolio.

The analysis combines return distribution analysis, CAPM, volatility modelling, downside risk measurement and portfolio analysis.

Overall, the results show that VNQ and EWG introduce additional risk and do not improve the risk-adjusted performance of the examined portfolio relative to the 60/40 SPY-AGG benchmark over the 2008–2022 sample.

However, the relatively low correlations observed during normal market conditions suggest that both ETFs can still provide diversification benefits in certain market environments.

The findings therefore support viewing VNQ and EWG as potential **Tactical Asset Allocation (TAA)** exposures rather than relying on them as core **Strategic Asset Allocation (SAA)** components within the portfolio examined in this project.
