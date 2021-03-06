********* WWS508c PS5 *******************
*  Spring 2018			                *
*  Authors: Alex Kaufman, Lachlan Carey *
*  Email: lachlanc@princeton.edu           *
*****************************************

clear all
set more off
cap cd "C:\Users\Locky\Documents\STATA Assignment\Econometrics\ps5"
cap cd  "\\files\ak29\ClusterDownloads\ps5\ps5"
cap log close
cap ssc install tabout
cap ssc install copydesc
cap ssc install diff
cap ssc install estout
cap log using ps5.log, replace
local data wws508c_crime_ps5.dta
cap use `data', clear
cap use "\\files\ak29\ClusterDownloads\ps5\ps5\wws508c_crime_ps5.dta"


/*******************************************************************************
                                    P1                                          
*******************************************************************************/
// Summarize and Describe the Data

*view data
sum, det

*view variables
desc

*get some statistics and output them
estpost tabstat * , by( ) statistics(mean sd n) columns(statistics)

esttab using _means.tex, cells("mean sd count") replace

*break down scores by birth year
estpost tabstat conscripted crimerate arms property sexual murder threat drug, by(birthyr) statistics(mean sd n) columns(statistics)

esttab using crim_by_birth.tex, cells("mean sd count") replace

/*******************************************************************************
                                    P2                                          
*******************************************************************************/
//estimate baseline regressions

foreach var in crimerate arms property sexual murder threat drug whitecollar {
	*no controls
	reg `var' conscripted 
	outreg2 using P2_`var', label tex(fragment pretty) ctitle(No Controls) replace

	*controls
	reg `var' conscripted argentine indigenous naturalized, r
	outreg2 using P2_`var', label tex(fragment pretty) ctitle(With Controls) append 

	*fixed effects with controls
	xtreg `var' conscripted argentine indigenous naturalized, i(birthyr) fe robust
	outreg2 using P2_`var', label tex(fragment pretty) ctitle(With Controls) addtext(Birth Year FE, YES) append
	}
	
/*******************************************************************************
                                    P3                                          
*******************************************************************************/
//generate eligibility variable

gen elig = 0
recode elig (0=1) if draftnumber>=175&birthyr==1958
recode elig (0=1) if draftnumber>=320&birthyr==1959
recode elig (0=1) if draftnumber>=341&birthyr==1960
recode elig (0=1) if draftnumber>=350&birthyr==1961
recode elig (0=1) if draftnumber>=320&birthyr==1962

/*******************************************************************************
                                    P4                                          
*******************************************************************************/
//First stage regression
	
	
	*no controls
	reg conscripted elig, r
	outreg2 using P4, label tex(fragment pretty) ctitle(No Controls) replace

	*controls
	reg conscripted elig argentine indigenous naturalized, r
	outreg2 using P4, label tex(fragment pretty) ctitle(With Controls) append 

	*fixed effects with controls
	xtreg conscripted elig argentine indigenous naturalized, i(birthyr) fe robust
	matrix fstage  = e(b)
	scalar conscripted_beta_Z = fstage[1,1]
	outreg2 using P4, label tex(fragment pretty) ctitle(With Controls) addtext(Birth Year FE, YES) append
	
/*******************************************************************************
                                    P5                                          
*******************************************************************************/
//Reduced form regressions



foreach var in crimerate arms property sexual murder threat drug whitecollar {
	
	*reduced form
	xtreg `var' elig argentine indigenous naturalized, i(birthyr) fe robust
	matrix `var'_rform  = e(b)
	scalar `var'_beta_Z = `var'_rform[1,1]
	di `var'_beta_Z
}
/*******************************************************************************
                                       P6                        
*******************************************************************************/
//estimate the IV coefficient using the coefficients from red. form and stage 1

foreach var in crimerate arms property sexual murder threat drug whitecollar {

di "The coefficient for the IV estimate of conscription on `var' is "
di `var'_beta_Z/conscripted_beta_Z

}
	
/*******************************************************************************
                                       P7                        
*******************************************************************************/
//Using the 2sls routine to get the same estimates

foreach var in crimerate arms property sexual murder threat drug whitecollar {

	ivregress 2sls `var' argentine indigenous naturalized i.birthyr (conscripted = elig)	
	
}	
	
/*******************************************************************************
                                       P8                        
*******************************************************************************/
//Using the 2sls routine to get the same estimates
	
