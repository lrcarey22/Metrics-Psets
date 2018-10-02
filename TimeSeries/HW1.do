/*******************************************************************************
Author: Alex Kaufman
Description: HW 1 - Unit Root tests
Date: 9/24
*******************************************************************************/
cap log using HW1, replace

cd "\\files\ak29\ClusterDownloads\Econometrics\Metrics-Psets/TimeSeries"

*install programs
cap ssc install ersur
cap ssc install kpss

*load the data
webuse lutkepohl2

keep if qtr > 15 & qtr < 88

*declare data to be time series
tsset qtr

*define varialbes to test
local test_vars ln_inc ln_inv

*perform tests for unit root on the selected variables
foreach var of local test_vars {

	di "----------------------results for the `var' varible--------------------"
	
	*Dickey_Fuller
	di "Dickey Fuller: `var'"
	dfuller `var', lags(1) trend
	
	*Augmented Dickey_Fuller
	di "Augmented Dickey Fuller: `var'"
	dfuller `var', trend
	
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


cap log close
translate HW1.smcl HW1.pdf
