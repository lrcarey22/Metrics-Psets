********* WWS508c PS# *******************
*  Spring 2018			                *
*  Authors: Alex Kaufman, Lachlan Carey *
*  Email: ak29@princeton.edu            *
*****************************************


set more off
cap cd "\\files\ak29\ClusterDownloads\ps3\ps3"
cap cd "C:\Users\TerryMoon\Dropbox\TeachingPrinceton\wws508c2018S\ps\ps3"
cap log close
cap ssc install tabout
cap ssc install copydesc
cap ssc install diff
cap ssc install estout
log using ps3.log, replace
local data nhis2000.dta
use `data', clear


********************************************************************************
**                                   P1                                       **
********************************************************************************
//create fair or poor health dummy and summarize data//
gen bad_health = 0
replace bad_health = 1 if health > 3

*summarize the data
sum, det

*output
qui estpost sum
esttab using sum3.tex, cells("count mean sd min max") booktabs replace


********************************************************************************
**                                   P1                                       **
********************************************************************************
//line graphs of rates of mortality and fair/poor health by age//

*generage means by gender
bysort age: egen av_mort_m = mean(mort5) if sex == 1
bysort age: egen av_mort_f = mean(mort5) if sex == 2

*plot
line av_mort_m age || line av_mort_f age, legend(label(1 "Average Male Mortality") label(2 "Average Female Mortality")) ytitle("Died within 5 years of survey")

*therefore average mortality increases with age and male mortality is generally higher than women's. this is as expected*

*generate means for health by gender
bysort age: egen av_health_m = mean(bad_health) if sex == 1
bysort age: egen av_health_f = mean(bad_health) if sex == 2

*plot
line av_health_m age || line av_health_f age, legend(label(1 "Average Male Health Outcome") label(2 "Average Female Health Outcome")) ytitle("Percent who reported poor or fair health")

*older citizens report worse health outcomes - also to be expected. There doesn't appear to be a sigificant difference by gender*


********************************************************************************
**                                   P3                                       **
********************************************************************************
//create bar graphs//

*generate a variable for family income
gen income = 0
replace income = 1 if faminc_20t75 == 1
replace income = 2 if faminc_gt75 == 1
replace income = . if faminc_20t75 == . &  faminc_gt75 == .

label variable income "Family Income Level"
label define inc 0 "Low " 1 "Middle " 2 "High "
label values income  inc

*generate variable for education levels
gen edu = 0 
replace edu = 1 if edy == 12
replace edu = 2 if edy > 12
replace edu = 3 if edy == 16 
replace edu = 4 if edy > 16 
replace edu = . if edy == .

label variable income "Educational Attainment"
label define ed 0 "< HS " 1 "HS " 2 "some college " 3 "BA" 4 "PG"
label values edu ed

*generate variable for race
gen race = 0 
replace race = 1 if black == 1
replace race = 2 if hisp ==  1
replace race == . if black == . & hisp == .

label variable race "Race"
label define ethn 0 "white" 1 "black" 2 "hispanic"
label values race ethn

*genereate graph for health outcomes over income levels
graph bar (mean) bad_health, over(income) ytitle(Percent self-reporting low health) title(Health Outcomes Over Income)

*generate graph for health outcomes over education levels
graph bar (mean) bad_health, over(edu) ytitle(Percent self-reporting low health) title(Health Outcomes Over Education)

*generate graph for health outcomes over ethnicity
graph bar (mean) bad_health, over(race) ytitle(Percent self-reporting low health) title(Health Outcomes by Race)

*the results are as expected.  poorer, less educated and minority status individuals have worse self reported outcomes

********************************************************************************
**                                   P4                                       **
********************************************************************************
// Regression analysis of health outomces on socio-demographic characteristics//

*loop throug each dependent variable
foreach var of varlist bad_health mort5 {

	*run LPM
	reg `var' age edyr black hisp fam*, r

	*run probit
	qui probit `var' age edyr black hisp fam*, r
	margins, dydx(*)
	
	*run logit
	qui logit `var' age edyr black hisp fam*, r
	margins, dydx(*)
}

*results are similar, coefficients on black not significamt

********************************************************************************
**                                   P5                                       **
********************************************************************************
//racial/income disparities//

*make a variable for white to make this easier to understand
gen white = 1
replace white == 0 if black == 1 | hisp == 1

*run logit
logit mort5 age edyr black hisp fam*, r
margins, dydx(*)
margins, dydx(black) 
margins, dydx(black) at(faminc_g ==1)
margins, dydx(black) at(faminc_2 ==1)



logit mort5 age edyr hisp black##faminc_g faminc_2, r
margins, dydx(*)
margins black, dydx(faminc_g)

*baseline is low income white, so we only need to determine the sign of being high-income black 
*looks like high income blacks have a very slightly lower mortatilty risk 

********************************************************************************
**                                   P9                                       **
********************************************************************************
//ordered probit//

*run ordered probit
oprobit health age edyr black hisp fam*, r

	
*run probit from question 4 for comparison
probit bad_health age edyr black hisp fam*, r

*results are pretty similar

*run ordered probit  margins
qui oprobit health age edyr black hisp fam*, r
margins, dydx(*)
	
*run probit margins from question 4 for comparison 
qui probit bad_health age edyr black hisp fam*, r
margins, dydx(*)

*but we do see significant variation in marginal effect sizes and magniutes with the ordered probit

*run probit
qui logit mort5 age edyr black white fam*, r
margins, dydx(white) at(faminc_2 ==1)
	
********************************************************************************
**                                   P10                                       **
********************************************************************************
//predictions from ordered probit//

*run ordered probit
oprobit health age edyr black hisp fam*, r
cap drop prob_health*
forvalues i = 1/5 {
	predict prob_health_`i', outcome(`i') // predict prob of health == i
}



*generate historgrams
hist health if black == 1
hist health if white == 1

log close
