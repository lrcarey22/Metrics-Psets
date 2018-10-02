/*******************************************************************************
Author: Alex Kaufman
Description: HW 2 - Unit Root tests
Date: 10/2
*******************************SET UP******************************************/
cd "\\files\ak29\ClusterDownloads\Econometrics\Metrics-Psets/TimeSeries"

cap log using HW2, replace


*install programs
cap ssc install ersur
cap ssc install kpss
cap ssc install egranger

*load the data
clear
import excel "\\files\ak29\ClusterDownloads\Chow-Wang Data.xls", sheet("Sheet1")

********************************PREP DATA***************************************
ren A year
ren B P
ren C M2
ren D Y

sort year
gen log_M2_Y = log(M2/Y)
gen log_P    = log(P)


*declare data to be time series
tsset year

*********************************ANALYSIS***************************************

*replicate equation 1
reg log_P log_M
predict resid, res

*replicate equation 2
reg D.log_P D.log_M2 l.D.log_P l.resid

*Dickey Fuller Tests for Stationarity
dfuller log_P, lags(1) trend
dfuller log_M2_Y

*Johansen test for cointegration
vecrank log*, lags(5) 

*Engle Granger test
egranger log_P log_M, ecm lag(1)

*Check E granger results by hand
reg D.log_P l.D.log_P l.d.log_M l.resid 

*check whether the original variables are really non-stationary
ersur log_P
ersur log_M

kpss log_P
kpss log_M 

*check whether residuals are really stationary
ersur resid
kpss resid

cap log close
translate HW2.smcl HW2.pdf
