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
**                                   P3                                       **
********************************************************************************
//create bar graphs//

*generate a variable for family income
gen income = 0
replace income = 1 if faminc_20t75 == 1
replace income = 2 if faminc_gt75 == 1

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

label variable race "Race"
label define ethn 0 "white" 1 "black" 2 "hispanic"
label values race ethn


*genereate graph for health outcomes over income levels
graph bar (mean) bad_health, over(income) ytitle(Percent self-reporting low health) title(Health Outcomes Over Income)

*generate graph for health outcomes over education levels
graph bar (mean) bad_health, over(edu) ytitle(Percent self-reporting low health) title(Health Outcomes Over Education)

*generate graph for health outcomes over ethnicity
graph bar (mean) bad_health, over(race) ytitle(Percent self-reporting low health) title(Health Outcomes by Race)



log close
