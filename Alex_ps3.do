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
**                                   P2                                       **
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
replace race = . if black == . & hisp == .

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

*run logit
logit mort5 age edyr hisp black##faminc_g faminc_2, r

*get all the marginal effects
margins, dydx(*)

*get the marginal effect of income for high income blacks
margins black, dydx(faminc_g)

*baseline is low income white, so we only need to determine the sign of being high-income black 
*looks like high income blacks have a very slightly lower mortatilty risk 

********************************************************************************
**                                   P7                                       **
********************************************************************************
//investigating impact of insurance and behavior//

*Recode behaviors into proper dummy variables**
recode smokev (10=0) (20=1), gen(smoke100)
recode alc5upyr (1/max=1), gen(drink5)

*correlations*
pwcorr bad_health mort5 uninsured income black hisp edu drink5 smoke100 vig10fwk bacon, sig

*Reg 1 - Bad health uninsured no age*
reg bad_health faminc_20t75 faminc_gt75 uninsured, robust
logistic bad_health faminc_20t75 faminc_gt75 uninsured, robust
mfx compute

*Reg 2 - Bad health uninsured w/ age*
reg bad_health faminc_20t75 faminc_gt75 uninsured, robust
logistic bad_health faminc_20t75 faminc_gt75 uninsured, robust
mfx compute

*Reg 3 - Bad health behavior*
reg bad_health age faminc_20t75 faminc_gt75 drink5 smoke100 vig10fwk, robust
logistic bad_health age faminc_20t75 faminc_gt75 drink5 smoke100 vig10fwk, robust
mfx compute

*Reg 4 - bad heath uninsured & behavior w/age*
reg bad_health age faminc_20t75 faminc_gt75 uninsured drink5 smokev vig10fwk, robust
logistic bad_health age faminc_20t75 faminc_gt75 uninsured drink5 smokev vig10fwk, robust
mfx compute


********************************************************************************
**                                   P8                                       **
********************************************************************************
//relationship between health and mortality//

*simmple probit regression
probit mort5 health, r

*predict values
predict p_prob_mort

*plot the predicted mortality against health
scatter p_prob_mort health

*controll probit regression
probit mort5 health age fam* race edyrs, r

*predict values
predict p_prob_mort_cont

*plot the predicted mortality against health
scatter p_prob_mort_cont health

*therefore the relationship is monotonic, however it mortality increases faster when self-reported health outcomes become fair or poor


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
cap drop avg_*
cap drop mat*

*predict probabilities for each value and estimate probabilities
foreach race of varlist white black {
	forvalues i = 1/5 {
		*predict prob_health_`i'_`race' , outcome(`i') // predict prob of health == i
		*predict the average probability of health ranking i at the average values of other variables (by race)
		margins, atmeans by(`race') predict(outcome(`i')) 
		matrix mat_`i' = r(table) //retrieve value of estimate
		gen avg_`race'_`i'_p = mat_`i'[1,2] //create a new variable with that estimate
	}
}

graph bar avg_black*, ytitle(Average Predicted Probability) title(Predicted Health Ratings for Blacks) legend(label(1 "Excellent") label(2 "Very Good") label(3 "Good") label(4 "Fair") label(5 "Poor"))

graph bar avg_white*, ytitle(Average Predicted Probability) title(Predicted Health Ratings for Whites) legend(label(1 "Excellent") label(2 "Very Good") label(3 "Good") label(4 "Fair") label(5 "Poor"))


*generate historgrams for comparison
hist health if black == 1
hist health if white == 1

log close
