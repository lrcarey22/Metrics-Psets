/*******************************************************************************
Author: Alex Kaufman
Description: Project Analysis
Date: 10/23
*******************************************************************************/
cap log close
cap log using project, replace

cd "\\files\ak29\ClusterDesktop\TimeSeries Data\"

*install programs
cap ssc install ersur
cap ssc install kpss

*load the data
use project.dta, clear

*clean data
drop  w_top_5  w_top_1 share01 share05 

*declare data to be time series
ren year _year
tsset _year
drop yr

*define varialbes to test
local trend_vars w* c* y*

*perform tests for unit root on the selected variables
foreach var of varlist w* c* y* {

	di "---------unit root test results for the `var' varible------------------"

	
	*Phillips-Peron
	di "Phillips-Peron: `var'"
	pperron `var', trend 
	
	*DF-GLS
	di "DF-GLS: `var'"
	ersur `var', trend
	
	*KPSS
	di "KPSS: `var'"
	kpss `var', auto
	
}

local btm90 y_btm_90 w_btm_90 c_btm_90

local btm50 y_btm_50 w_btm_50 c_btm_50

local mid40 y_mid    w_mid    c_mid

local top10 y_top_10 w_top_10 c_top_10



di "--------------------cointegration test results ------------------------"


varsoc `btm90', maxlag(8)
varsoc `btm50', maxlag(8)
varsoc `mid40', maxlag(8)
varsoc `top10', maxlag(8)


*Johansen test for cointegration
vecrank `btm90', lags(2)
vecrank `btm50', lags(3) 
vecrank `mid40', lags(3) 
vecrank `top10', lags(3) 

		
*Check whether the original variables are really non-stationary
foreach var of local btm90 {
	ersur `var'
	kpss `var'
}
	
foreach var of local top10 {
	ersur `var'
	kpss `var'
}


*Estimate the ecm for cointegrated vectors
egranger `btm50', ecm lag(3)
egranger `top10', ecm lag(3)
	
*-------------------------------------------------------------------------------

var `btm90', lags(1/6) dfk small

vargranger

var `btm90', lags(1/6) dfk small

irf create order1, step(6) set(myirf1) replace

irf graph oirf, irf(order1) impulse(`btm90') response(`btm90') /// 
		yline(0,lcolor(black)) xlabel(0(1)6) byopts(yrescale)

		
	
matrix A1 = (1,0,0 \ .,1,0 \ .,.,1)

matrix B1 = (.,0,0 \ 0,.,0 \ 0,0,.)

svar `btm90', lags(1/3) aeq(A1) beq(B1)
	
irf create order2, step(6) set(myirf2) replace

irf graph sirf, irf(order2) impulse(`btm90') response(`btm90') /// 
		yline(0,lcolor(black)) xlabel(0(1)6) byopts(yrescale)

	
	
cap log close
translate project.smcl project.pdf
