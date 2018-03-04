********* WWS508c PS# *******************
*  Spring 2018			                *
*  Authors: Alex Kaufman                *
*  Email: ak29@princeton.edu            *
*  Update: 3/4                          *
*****************************************

set more off
cap cd "\\files\ak29\ClusterDownloads\Econometrics\Metrics-Psets"
cap log close
log using ps1.log, replace

********************************************************************************
**                                   P2                                       **
********************************************************************************
//Prepare the data set for analysis//

/*---- prep the data ----*
run cps08.do
*/

local data cps08.dta
use `data', clear

*generate the wage variable
replace incwage = . if incwage == 0
gen wage = incwage / (wkswork1*uhrswork)
gen lwage = log(wage)
label variable lwage "Logged Wage"
label variable wage "Wage"

*generate race dummies
replace race = 300 if race > 200
tabulate race, generate(r)
rename r1 white
rename r2 black
rename r3 other

*generate years of education
gen yrsedu  = educ
label variable yrsedu "Years of Education"

replace yrsedu = 0 if educ == 2
replace yrsedu = 2.5   if educ == 10
replace yrsedu = 5.5   if educ == 20
replace yrsedu = 6.5   if educ == 30
replace yrsedu = 9     if educ == 40
replace yrsedu = 10    if educ == 50
replace yrsedu = 11    if educ == 60
replace yrsedu = 12    if educ == 71
replace yrsedu = 12    if educ == 73
replace yrsedu = 13.5  if educ == 81
replace yrsedu = 14    if educ == 91
replace yrsedu = 14    if educ == 92
replace yrsedu = 16    if educ == 111
replace yrsedu = 18    if educ == 123
replace yrsedu = 18    if educ == 124
replace yrsedu = 21    if educ == 125


*generate experience varaibles
gen experi = age - yrsedu - 5
replace experi = 0 if experi < 0
gen exper2 = experi^2

label variable experi "Work Experience"
label variable exper2 "Square of Work Experience"

*drop data we dont like (BAD!)
drop if wage == .
drop if yrsedu == .
drop if uhrswork < 35

*sumarize the data
sum

sum, det

*output table
qui estpost sum
esttab using sum.tex, label cells("count mean sd min max") booktabs replace

********************************************************************************
**                                   P3                                       **
********************************************************************************
// Run initial regressions of wage on education and experience //

*regress wages on education (only)
reg lwage yrsedu, beta
outreg2 using r1, tex(frag) label replace 

*confirm the correlation coefficient
corr lwage yrsedu


********************************************************************************
**                                   P4                                       **
********************************************************************************
// estimate the Mincerian Wage Equation regression and confirm using residuals//

*regress wages on education (only)
reg lwage yrsedu exp*
outreg2 using r2, tex(frag) label replace 

*regress residuals
reg lwage experi exper2
predict yhat, resid
reg yrsedu experi exper2
predict xhat1, resid
reg experi exper2
predict xhat2, resid
reg yhat xhat1 xhat2

********************************************************************************
**                                   P5                                       **
********************************************************************************
// estimate extended Mincerian Wage Equations //

reg lwage yrsedu exp* black white 
outreg2 using r3, tex(frag) label replace 

reg lwage yrsedu exp* sex 
outreg2 using r3, tex(frag) label append 

reg lwage yrsedu exp* black white sex
outreg2 using r3, tex(frag) label append 

********************************************************************************
**                                   P6                                       **
********************************************************************************
// estimate profile plot using Mincerian Wage Equations //


reg lwage yrsedu exp* black white sex

*get the coefficients
matrix b = e(b)

*get variable averages
sum yrs black white sex

*get variable means
tabstat yrs black white sex, save
matrix means = r(StatTotal)

*estimate the logged wage based on the extended regression 
gen hat_lwage = b[1,7] + b[1,1]*means[1,1] + b[1,2]*experi + b[1,3]*exper2 + ///
				b[1,4]*means[1,2] + b[1,5]*means[1,3] + b[1,6]*means[1,4]

label variable hat_lwage "Estimated Wage"

*plot a line representing the two variables
sort experi
line  hat_lwage experi

*export the graph
graph export extended.png, as(png) replace

********************************************************************************
**                                   P7                                       **
********************************************************************************
//Prepare the new data set for analysis//

local data nlsy79.dta
use `data', clear

*generate the wage variable
replace laborinc07 = . if laborinc07 == 0
gen wage = laborinc07 / hours07
gen lwage = log(wage)
label variable lwage "Logged Wage"
label variable wage "Wage"

*generate race dummies
gen white = 0
replace white = 1 if black != 1 & hisp != 1

*generate years of education
gen yrsedu  = educ
label variable yrsedu "Years of Education"

*generate experience varaibles
replace age = age + 28
gen experi = age - yrsedu - 5
replace experi = 0 if experi < 0
gen exper2 = experi^2

label variable experi "Work Experience"
label variable exper2 "Square of Work Experience"
ren male sex

*drop data we dont like (BAD!)
drop if wage == .
drop if yrsedu == .
gen hours_week = hours07/50
drop if hours_week < 35
drop hours_week

*sumarize the data
sum

sum, det

*output table
qui estpost sum
esttab using sum2.tex, label cells("count mean sd min max") booktabs replace


********************************************************************************
**                                   P8                                       **
********************************************************************************
// estimate extended Mincerian Wage Equations //

reg lwage yrsedu exp* black white 
outreg2 using r4, tex(frag) label replace 

reg lwage yrsedu exp* sex 
outreg2 using r4, tex(frag) label append 

reg lwage yrsedu exp* black white sex
outreg2 using r4, tex(frag) label append 


********************************************************************************
**                                   P10                                      **
********************************************************************************
// estimate controlled Mincerian Wage Equations //

reg lwage yrsedu exp* black white 
outreg2 using r5, tex(frag) label replace 

reg lwage yrsedu exp* sex 
outreg2 using r5, tex(frag) label append 

reg lwage yrsedu exp* black white sex
outreg2 using r5, tex(frag) label append 

reg lwage yrsedu exp* black white sex afqt81 
outreg2 using r5, tex(frag) label append 

reg lwage yrsedu exp* black white sex lib14 news14
outreg2 using r5, tex(frag) label append 

reg lwage yrsedu exp* black white sex afqt81 lib14 news14
outreg2 using r5, tex(frag) label append 
