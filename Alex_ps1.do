********* WWS508c PS# *******************
*  Spring 2018			                *
*  Authors: Alex Kaufman, Lachlan Carey *
*  Email: ak29@princeton.edu            *
*  Update: 2/16                         *
*****************************************
//any disclaimer...//
//credit: the rest of group members' names//

set more off
cap cd "\\files\ak29\ClusterDownloads\Econometrics"
cap cd "C:\Users\TerryMoon\Dropbox\TeachingPrinceton\wws508c2018S\ps\ps#"
cap log close
cap ssc install tabout
cap ssc install copydesc
cap ssc install diff
log using ps1.log, replace
local data 
use project_star_ps1.dta, clear


*generate an urban rural variable
gen rural = schtypek
replace rural = 1 if rural != 3
replace rural = 2 if rural == 3
label define urb 1 "non-rural" 2 "rural"
label values rural urb

*make race a dummy
replace srace = . if srace == 6

********************************************************************************
**                                   P1                                       **
********************************************************************************
//summarie all variables in the data//
sum

sum, det

*output table
qui estpost sum
esttab using sum.tex, cells("count mean sd min max") booktabs replace




//examine specific variables of interest//
foreach var of varlist ssex srace sesk cltypek hdegk totexpk tracek schtypek {
tab `var'
}

foreach var of varlist ssex srace sesk rural {
	estpost tab `var' cltypek
	esttab using `var'_tab.tex, label booktabs replace
}

//examine distribution of variables//
foreach var of varlist tcombssk treadssk tmathssk {
hist `var', freq normal
graph export "`var'_hist.png", as(png) replace
}

********************************************************************************
**                                   P2                                       **
********************************************************************************
//do crosstabs of classroom size and baseline student characteristics//
**code**
foreach var of varlist ssex srace sesk rural {
	tab cltyp `var', row chi2 


	*output tables
	qui tabout cltypek `var' using `var'_ctab.txt, ///
	c(freq row) stats(chi2) ///
	style(tex) bt cl1(2-7) cl2(2-3 4-5 6-7) replace 

}
********************************************************************************
**                                   P3 & 4                                   **
********************************************************************************
//compare mean math scores in small and regular (+ aid) classes//

*create groupings for small classes and regular (+ aid) classes
gen small_reg = cltypek   - 1
gen small_reg_a = cltypek - 1

label define class 0 "small class" 1 "regular class"

label values small_reg   class
label values small_reg_a class

replace small_reg =   . if small_reg == 2
replace small_reg_a = . if small_reg == 0

*loop through each student outcome variable
foreach var of varlist tcomb tmath tread { 

	estpost tabstat `var' , by(cltypek ) statistics(mean sd n) columns(statistics)

	*output table
	esttab using `var'_means.tex, cells("mean sd count") replace

	/*calculate t statistic by hand (why??)//
	----------------------------------------------------------------------------
	t = (Xbar_1 - Xbar_2) / sqrt[ds1/n1 + sd2/n2]
	--------------------------------------------------------------------------*/
	ereturn list
	matrix means = e(mean)
	matrix sds = e(sd)
	matrix counts = e(count)

	*difference between scores in small and regular classes
	di "t score for difference between `var' scores in small and regular classes"
	di (means[1,1]-means[1,2]) / sqrt(((sds[1,1]^2)/counts[1,1])+ ///
	((sds[1,2]^2)/counts[1,2]))


	*difference between scores in regular and regular+aid classes
	di "t score for difference between `var' scores in regular and regual+aid classes"
	di (means[1,2]-means[1,3]) / sqrt(((sds[1,2]^2)/counts[1,2])+ ///
	((sds[1,3]^2)/counts[1,3]))

	//calculate t statistic using ttest//
	

	*perform t test
	ttest `var', by(small_reg)
	ttest `var', by(small_reg_a)

	*output tables
	estpost ttest `var', by(small_reg)
	esttab using `var'_ttest_1.tex, c(mu_1 mu_2 t p)  label replace

	estpost ttest `var', by(small_reg_a)
	esttab using `var'_ttest_2.tex, c(mu_1 mu_2 t p)  label replace

	esize twosample `var', by(small_reg)
	esize twosample `var', by(small_reg_a)
	

	
}

********************************************************************************
**                                   P5                                       **
********************************************************************************
//Estimate effect size by student background characteristic//






*****Begin Loop Through Student Characteristic Variables************************

local testscore tcombssk

foreach var of varlist rural srace sesk {

	*test effect for group1 students
	ttest `testscore' if `var'==1, by(small_reg)

	*store difference and standard deviation
	local sd_1 r(sd)
	local x_bar_1 (r(mu_1) - r(mu_2))
	local n_1 (r(N_1)+r(N_2))/2



	*test effect for group2 students
	ttest `testscore' if `var'==2, by(small_reg)

	*store difference and standard deviation
	local sd_2 r(sd)
	local x_bar_2 (r(mu_1) - r(mu_2))
	local n_2 (r(N_1)+r(N_2))/2




	/*/estimate difference in means//
	------------------------------------------------------------------------
	T score  estimated as:                    x_bar-1 - x_bar_2 
										 --------------------------
									   sqrt(sd_1^2/n_1 + sd_2^2/n_2)							
	----------------------------------------------------------------------*/

	local sigma_p sqrt(((`n_1'-1)*(`sd_1'^2) + (`n_2'-1)*(`sd_1'^2)) /(`n_1'+`n_2'-2))

	local tscore (`x_bar_1' - `x_bar_2') / sqrt((`sd_1'^2)/`n_1'+(`sd_2'^2)/`n_2')

	di "t score for the differene in class size effect across `var':"
	di `tscore'
	
	di "P score for the differene in class size effect across `var':"
	di 2*ttail(2,`tscore')

	*output tables
	estpost ttest `testscore' if `var'==1, by(small_reg)
	esttab using ttest_`var'_1.tex, c(mu_1 mu_2 t p)  label replace
	estpost ttest `testscore' if `var'==2, by(small_reg)
	esttab using ttest_`var'_2.tex, c(mu_1 mu_2 t p) label replace

	
	
	//Actually compare differences the correct way using the Diff command//
	gen d1_`var' = `var' - 1 // convert the demographic varaible to a dummy
	
	*create a varaible that interacts the "treatment" with large class size
	gen t1t2 = d1_`var'*small_reg
	
	*use a regression to get the difference in difference coefficient
	reg `testscore' t1t2 `var' small_reg
	drop t1t2
	
	*The coefficient on pt is the difference-in-difference estimator. 
	*The t-statistic on that regression coefficient is the t-test for equality of the differences.


	
	
}
********************************************************************************

********************************************************************************
**                                   P6                                       **
********************************************************************************

foreach var of varlist ssex srace sesk rural {

preserve

collapse (mean) tcombssk tmathssk treadssk , by(classid `var' small_reg)

//Actually compare differences the correct way using the Diff command//
	gen d1_`var' = `var' - 1 // convert the demographic varaible to a dummy
	
	*create a varaible that interacts the "treatment" with large class size
	gen t1t2 = d1_`var'*small_reg
	
	*use a regression to get the difference in difference coefficient
	reg `testscore' t1t2 `var' small_reg
	drop t1t2

restore

}

********************************************************************************
**                                   P7                                       **
********************************************************************************
//determine the effect size of student characteristic variables//

foreach var of varlist rural srace sesk ssex {

	ttest treadssk , by(`var')
	ttest tmathssk, by(`var')

	estpost ttest treadssk, by(`var')
	esttab using `var'_read_effect.tex, c(mu_1 mu_2 t p) label replace
	estpost ttest tmathssk, by(`var')
	esttab using `var'_math_effect.tex, c(mu_1 mu_2 t p) label replace
}

cap log close
