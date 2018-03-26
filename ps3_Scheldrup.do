
set more off
***Problem 1****
tab health
tab health, nol
recode health (1/3=0) (4/5=1), gen(bad_health)
tab bad_health
tabstat bad_health, s(count mean min med max v sk k)

**Problem 2***
*generate a variable for family income
gen faminc_3 = faminc_20t75
recode faminc_3 (0=2) if faminc_gt75==1

gen income = 0
replace income = 1 if faminc_20t75 == 1
replace income = 2 if faminc_gt75 == 1
replace income = . if faminc_gt75==.
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

***Problem 7***
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


***Problem 8****
pwcorr health mort5, sig
