****************************************************************************
*          Macroeconometric Forecasting with DSGE Models (ATMF)
*                      Vietnamese German University  
*                           Spring Semester 2024
*                       Prof. Michael Binder, Ph.D.
*
*             Take home PROJECT 2024: Pham Minh Tu - 21323009
****************************************************************************

cls           // clear display in results window
clear         // clear previous work out of memory 
cd "/Users/professortu/Documents/GFE/9.ATMF/Project/"

*The data set data_project_atmf24.xls on the course website contains quarterly observations from 1970:Q1 to 2024:Q1 for the following variables:
* ly: U.S. real GDP (in logarithm)
* lc: U.S. real consumption expenditure (in logarithm)
* pi: U.S. rate of inflation (based on the GDP deflator)
* r: U.S. interest rate (Federal Funds rate)
*For all of the following problems, use 1971:Q3 to 2021:Q3 as the in-sample period, and 2021:Q4 to 2024:Q1 as the out-of-sample period.

// Load Data
import excel using "data_project_atmf24.xls", first

// Define in-sample and out-of-sample periods
global insample tin(1971q3, 2021q3)
global outsample tin(2021q4, 2024q1)

// Generate time variables
generate quarters = _n 
generate time = tq(1970q1)+quarters-1
label variable time " "

// Declare data to be time-series
tsset time, quarterly
drop quarters
edit



**Questions 1
// Line graph for each variable
tsline ly, title("Real GDP (ly)") name(ly_graph, replace)
tsline lc, title("Real Consumption Expenditure (lc)") name(lc_graph, replace)
tsline pi, title("Inflation Rate (pi)") name(pi_graph, replace)
tsline r, title("Interest Rate (r)") name(r_graph, replace)

// Combine all graphs into one file
graph combine ly_graph lc_graph pi_graph r_graph, title("Macroeconomic Variables") cols(2)
graph export combined_graphs.pdf, replace


																	
**Questions 2

* Selecting ARMA(p,q) Model
arimasoc ly if $insample, maxar(3) maxma(3)

* Preferred Model 
arima ly if $insample, arima(3,0,0)
predict lyhat if $insample, xb
summarize lyhat if $insample
* Line Graph
label variable ly "Actual"
label variable lyhat "Predicted, ARMA(3,0)"
tsline ly lyhat if $insample,                                   ///
       title(Actual vs. In-Sample Predicted Values)              ///
       subtitle(Real GDP for the United States)                               ///
	   name(InSampleFit, replace)
graph export USARealGDP.pdf, replace        ///
             logo(off) orientation(portrait)
* Forecasting
predict ly_f1, t0(tq(1971q3)) 
label variable ly_f1 "One-Step, ARMA(3,0)"
predict ly_f2, dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly_f2 "Multi-Step, ARMA(3,0)"
tsline ly ly_f1 ly_f2 if $outsample,                                     ///
       title("Actual vs. One- and Multi-Step Forecasted Values")       ///
       subtitle("(Real GDP for the United States)")           ///
       name(Forecast, replace) 
graph export GDPActualForecast_ARMA.pdf, replace
* Root Mean-Square Forecast Errors
predict ly_f1e, residuals t0(tq(1971q3)) 
generate rmsearma = sqrt(ly_f1e^2) if $outsample
summarize rmsearma

*Extend the Out-of-Sample Period and Genserate Long-Run Forecasts
// Extend the time series to 2030q4 for long-run forecasting
tsappend, add(304) // Adding 304 quarters (76 years) to extend the period to 2099q4
global newoutsample tin(2021q4,2099q4)	
predict ly_f2e, dynamic(tq(2021q4)) t0(tq(1971q3)) 
label variable ly_f2e "Multi-Step, ARMA(3,0)"
* Forecast Results
tsline ly_f2e if $newoutsample,                                        ///            
       title("Multi-Step Forecasted Values")                          ///            
       subtitle("(GDP of the United States)")          ///
       name(ComparisonForecastMultiStepe, replace) 
graph export USGDPMultiStepForecast_ARMA.pdf, replace           ///

// Compute Root Mean-Square Forecast Errors for extended period
predict ly_f2e_residual, residuals t0(tq(1971q3))
generate rmse_longrun = sqrt(ly_f2e_residual^2) if $newoutsample
summarize rmse_longrun



**Question 3:

// Select the lag order for ARFIMA model
arfimasoc ly if $insample, maxar(3) maxma(3)

// Estimate the ARFIMA model
arfima ly if $insample, ar(1) ma(1/3)

// One-step ahead forecast
predict ly_f3, xb
label variable ly_f3 "One-Step, ARFIMA(1,3)"

// Multi-step ahead forecast starting from 2021q4
predict ly_f4, xb dynamic(tq(2021q4))
label variable ly_f4 "Multi-Step, ARFIMA(1,3)"

// Forecast
tsline ly ly_f3 ly_f4 if $outsample,                                     ///
       title("Actual vs. One- and Multi-Step Forecasted Values")       ///
       subtitle("(Real GDP for the United States)")           ///
       name(Forecast, replace) 
graph export "GDPActualForecast_ARFIMA.pdf"	  

// Generate long-run forecasts starting from 2021q4
tsappend, add(304) // Adding 304 quarters (76 years) to extend the period to 2099q4
global newoutsample tin(2021q4,2099q4)	
predict ly_f4e, xb dynamic(tq(2021q4))
label variable ly_f4e "Long-Run Forecast, ARFIMA(1,3)"

// Plot the actual and long-run forecasted values
tsline ly_f4e if $newoutsample, ///
       title("Actual vs. Long-Run Forecasted Values") ///
       subtitle("(Real GDP for the United States)") ///
       name(LongRunForecast_ARFIMA, replace)
graph export "GDPActualLongRunForecast_ARFIMA.pdf"

// Compute Root Mean-Square Forecast Errors for extended period
predict ly_f3e, residuals 
generate rmse_arfima = sqrt(ly_f3e^2) if $newoutsample
summarize rmse_arfima

**Question 4

// Select the optimal ARIMA(p,1,q) model
arimasoc ly if $insample, maxar(6) maxma(0)
* Augmented Dickey Fuller
dfuller ly if $insample, lags(2) regress
* Dickey-Fuller GLS
dfgls ly if $insample, maxlag(6) notrend

arimasoc d.ly if $insample, maxar(3) maxma(3)
* Display Estimation Results for ARIMA(0,1,0) Model
arima ly if $insample, arima(0,1,0)
* Forecasting for ARIMA(2,1,2) Model
predict ly_f5, y t0(tq(1971q3))   // level forecasts
label variable ly_f5 "One-Step, ARIMA(2,1,2)"
predict ly_f6, y dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly_f6 "Multi-Step, ARIMA(2,1,2)"
label variable ly "Actual" 
tsline ly ly_f5 ly_f6 if $outsample,                                       ///
       title("Actual vs. One- and Multi-Step Forecasted Values")         ///
       subtitle("US GDP")                                     ///
       name(Forecast, replace)
graph export USGDPForecast_ARIMA.pdf, replace
* Root Mean-Square Forecast Errors
predict ly_f5e, yresiduals t0(tq(1971q3)) 
generate rmsearima = sqrt(ly_f5e^2) if $outsample
summarize rmsearima

// Generate long-run forecasts starting from 2021q4
tsappend, add(304) // Adding 304 quarters (76 years) to extend the period to 2099q4
global newoutsample tin(2021q4,2099q4)	
predict ly_f6e, y dynamic(tq(2021q4))
label variable ly_f6e "Long-Run Forecast, ARIMA(0,1,0)"

// Plot the actual and long-run forecasted values
tsline ly_f6e if $newoutsample, ///
       title("Long-Run Forecasted Values") ///
       subtitle("(Real GDP for the United States)") ///
       name(LongRunForecast_ARIMA, replace)
graph export "GDPLongRunForecast_ARIMA.pdf", replace

**Question 5
* VEC Models
* Unit Root Tests
* 1) r
* Lag Length Selection 
varsoc r if $insample, maxlag(6)
* Augmented Dickey Fuller
dfuller r if $insample, lags(5) regress
* Dickey-Fuller GLS
dfgls r if $insample, maxlag(6) notrend
* 2) pi
* Lag Length Selection
varsoc pi if $insample, maxlag(6)  
* Augmented Dickey Fuller
dfuller pi if $insample, lags(5) regress
* Dickey-Fuller GLS
dfgls pi if $insample, maxlag(4) notrend
* 3) ygap
* Lag Length Selection 
varsoc ly if $insample, maxlag(6) 
* Augmented Dickey Fuller
dfuller ly if $insample, lags(0) regress
* Dickey-Fuller GLS
dfgls ly if $insample, maxlag(6) notrend
* 4) ur
* Lag Length Selection 
varsoc lc if $insample, maxlag(6) 
* Augmented Dickey Fuller
dfuller lc if $insample, lags(0) regress
* Dickey-Fuller GLS
dfgls lc if $insample, maxlag(6) notrend

* Cointegration Rank Test
vecrank r pi ly lc if $insample, trend(rconstant) lags(3) levela

* VEC(3) Model
vec r pi ly lc if $insample, trend(rconstant) lags(3) rank(2) 

* VEC(3) Model Forecasts
predict ly_f7, level equation(D_ly) 
label variable ly_f7 "One-Step, VEC(3)"
fcast compute f8, step(21)
rename f8ly ly_f8
label variable ly_f8 "Multi-Step, VEC(3)"
tsline ly ly_f7 ly_f8 if $outsample,                                        ///   
       title("Actual vs. One- and Multi-Step Forecasted Values")          ///
       subtitle("US GDP")                                      ///
       name(Forecast, replace) 
graph export USGDPForecast_VEC.pdf, replace                    ///
      logo(off) orientation(portrait) 
* Root Mean-Square Forecast Errors
generate ly_f7e = ly-ly_f7 if $outsample
generate rmsevec = sqrt(ly_f7e^2) if $outsample
summarize rmsevec

// Generate long-run forecasts starting from 2021q4

tsappend, add(304) // Adding 304 quarters (76 years) to extend the period to 2099q4

// Generate multi-step ahead forecast for interest rate
fcast compute long_run_f, step(304)
rename long_run_fr long_run_forecast_r
label variable long_run_forecast_r "Multi-Step, VEC(3)"

// Generate multi-step ahead forecast for inflation rate
rename long_run_fpi long_run_forecast_pi
label variable long_run_forecast_pi "Multi-Step, VEC(3)"

// Generate multi-step ahead forecast for GDP
rename long_run_fly long_run_forecast_ly
label variable long_run_forecast_ly "Multi-Step, VEC(3)"

// Generate multi-step ahead forecast for consumption expenditure
rename long_run_flc long_run_forecast_lc
label variable long_run_dccforecast_lc "Multi-Step, VEC(3)"
// Plot the actual and forecasted values for interest rate
tsline r long_run_forecast_r if $outsample, ///
       title("Actual vs. Multi-Step Forecasted Values") ///
       subtitle("Interest Rate (Extended Period)") ///
       name(Forecast_r_extended, replace)

// Plot the actual and forecasted values for inflation rate
tsline pi long_run_forecast_pi if $outsample, ///
       title("Actual vs. Multi-Step Forecasted Values") ///
       subtitle("Inflation Rate (Extended Period)") ///
       name(Forecast_pi_extended, replace)

// Plot the actual and forecasted values for GDP
tsline ly long_run_forecast_ly if $outsample, ///
       title("Actual vs. Multi-Step Forecasted Values") ///
       subtitle("GDP (Extended Period)") ///
       name(Forecast_ly_extended, replace)

// Plot the actual and forecasted values for consumption expenditure
tsline lc long_run_forecast_lc if $outsample, ///
       title("Actual vs. Multi-Step Forecasted Values") ///
       subtitle("Consumption Expenditure (Extended Period)") ///
       name(Forecast_lc_extended, replace)

graph combine Forecast_ly_extended Forecast_lc_extended Forecast_pi_extended Forecast_r_extended, title("Macroeconomic Variables") cols(2)
graph export combined_graphs.pdf, replace
