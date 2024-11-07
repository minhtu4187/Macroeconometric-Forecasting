# Macroeconometric Forecasting with DSGE Models: Course Take-Home Project

**Author**: Phạm Minh Tú  
**Student ID**: 21523009  
**Course**: GFE 2024  
**Date**: June 6, 2024 - June 12, 2024  
**Location**: Ho Chi Minh  

---

## Project Overview
This project focuses on macroeconometric forecasting of key economic indicators for the United States using various econometric models. The dataset includes variables such as Real GDP, Real Consumption Expenditure, Inflation Rate, and Interest Rate. The data spans an **in-sample period from 1971:Q3 to 2021:Q4** and extends to an **out-of-sample period from 2022:Q1 to 2024:Q1** for forecasting. Key models used in this project include ARIMA, ARFIMA, and VECM, with each model's performance evaluated using Root Mean Square Error (RMSE) as a criterion for accuracy.

---

## Table of Contents
- [Data Summary](#data-summary)
- [Methodology and Results](#methodology-and-results)
  - [ARIMA Model](#arima-model)
  - [ARFIMA Model](#arfima-model)
  - [VECM Model](#vecm-model)
- [Extended Forecasting](#extended-forecasting)
- [Conclusion](#conclusion)

---

## Data Summary
The dataset contains quarterly U.S. economic indicators for the period **1971:Q3 to 2024:Q1**:
- **Real GDP (ly)**: Consistent growth with downturns during major recessions and the COVID-19 pandemic.
- **Real Consumption Expenditure (lc)**: Growth trend with periodic slowdowns.
- **Inflation Rate (pi)**: Volatile in the 1970s and early 1980s, stabilizing around 2% in recent years, with a spike followed by a return to target levels.
- **Interest Rate (r)**: Volatile trend with a recent near-zero level.

### In-Sample and Out-of-Sample Periods
- **In-Sample Period**: 1971:Q3 to 2021:Q4, used to estimate model parameters.
- **Out-of-Sample Period**: 2022:Q1 to 2024:Q1, used for evaluating forecast accuracy.

<img width="862" alt="image" src="https://github.com/user-attachments/assets/5c1ece5a-172f-4cb3-ac48-895f6f1cb69f">

---

## Methodology and Results

### ARIMA Model
After evaluating multiple ARIMA specifications, the **ARIMA(3,0)** model was selected based on Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC). Key findings include:
- **AR(1)** coefficient (1.210): Significant positive relationship with immediate past GDP values.
- **AR(2)** coefficient (0.039): Insignificant.
- **AR(3)** coefficient (-0.249): Significant negative relationship, indicating cyclical behavior.
<img width="900" alt="image" src="https://github.com/user-attachments/assets/48d1eed2-7748-4e43-be6d-aa098a10c1fc">

**Forecasts**:
- **One-Step Ahead**: Closely follows actual GDP values.
- **Multi-Step**: Shows divergence over time, suggesting reduced accuracy for long-term forecasts.

**RMSE**: 0.0061, indicating a small forecast error.

<img width="928" alt="image" src="https://github.com/user-attachments/assets/53437306-a69b-4217-8aa2-dfcbba4e5706">



### ARFIMA Model
The **ARFIMA(1,3)** model was selected based on AIC, indicating long-memory characteristics in the GDP series:
- **AR(1)** coefficient (0.998): Suggests high persistence in GDP values.
- **MA(1)** coefficient (-0.3056): Negative effect, indicating adjustment for shocks.
- **Fractional Differencing Parameter (d = 0.3706)**: Indicates stationarity with long-term dependence.

<img width="900" alt="image" src="https://github.com/user-attachments/assets/5ab089b8-44c7-4981-be29-a7d80ae7568a">


**Forecasts**:
- **One-Step and Multi-Step**: Show greater volatility and deviation from actual values than ARIMA, particularly over longer horizons.

**RMSE**: 0.00498 for extended out-of-sample.

<img width="933" alt="image" src="https://github.com/user-attachments/assets/0751526a-517b-4afc-9239-09e4e6d39442">


### VECM Model
After cointegration tests, a **VEC(3)** model was developed with two cointegration relationships:
1. Interest rate, GDP, and consumption expenditure.
2. Inflation rate, GDP, and consumption expenditure.

**Forecasts**:
- **One-Step Ahead**: Tracks actual GDP values well.
- **Multi-Step**: Shows convergence toward the end of the forecast period.

<img width="863" alt="image" src="https://github.com/user-attachments/assets/ef610e9a-d4a4-495f-bb14-955e110c69e1">


The VECM captures both short-term dynamics and long-term relationships, balancing immediate adjustments with long-term equilibrium.

---

## Extended Forecasting
Each model was extended to forecast GDP to the last quarter of 2099:
- **ARIMA(3,0)**: Long-run forecasts show stable growth but reduced accuracy over time.
- **ARFIMA(1,3)**: Long-run forecasts reveal volatility due to long-memory effects.
- **ARIMA(0,1,0)**: Forecasts indicate continuous GDP growth driven by a positive drift term, with an RMSE of 0.0044 for out-of-sample forecasts.

<img width="902" alt="image" src="https://github.com/user-attachments/assets/59057a73-6ff5-4d53-92c6-f3afeac7a7b9">


---

## Conclusion
This project demonstrates that different econometric models offer unique insights and trade-offs in forecasting U.S. GDP. While the ARIMA model is highly accurate for short-term forecasts, the VECM captures long-term relationships between variables. The ARFIMA model, although less accurate in short-term forecasts, provides insights into the long-memory characteristics of GDP. These findings emphasize the importance of model selection in macroeconomic forecasting, with each model offering different advantages based on the forecast horizon and underlying data structure.

---

## Acknowledgements
This project was completed as part of the GFE 2024 course requirements. The author declares no external communication during the designated project period as per course regulations.
