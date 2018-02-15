*************************************
********** Econometrics *********
********* Problem Set 1 *********
*************************************

clear all
set more off

cd "C:\Users\Locky\Documents\STATA Assignment\Econometrics\"
log using "C:\Users\Locky\Documents\STATA Assignment\Econometrics\Problem Set 1.scml"

use "project_star_ps1.dta"

**Summarize data**
summarize


*investigating further*
tab ssex
tab srace
tab sesk
**of note: roughly a third of students are black; half 'free lunch' half not**

*testing normality*
histogram tcombssk
sktest tcombssk
histogram treadssk
sktest treadssk
histogram tmathssk
sktest tmathssk
**therefore all the test scores are normally distributed**

*investigating classroom type*
tab cltypek
histogram cltypek
**note, there is not even distribution of students between the three classes**


*investigating teachers*
tab hdegk
**nearly two thirds of teachers only have a bachelors**
tab totexpk
histogram totexpk
sktest totexpk
**teacher experience is approximately normally distributed**
tab tracek
**83% of teachers are white compared to 66% of students**

tab schtypek
**approximately half are rural schools**

*testing for independent distribution*
tab cltypek ssex, row chi2
tab cltypek ssex, column chi2

tab cltypek srace, row chi2
tab cltypek srace, column chi2

tab cltypek sesk, row chi2
tab cltypek sesk, column chi2
**therefore the distribution of students between the three classroom types don't appear to be independent of race, sex, or SES**
***NB: IF IVE DONE CHI2 TEST CORRECTLY!***

**CLASS SIZE**

*generate new variable for small and regular class sizes*
gen size=0 if cltype ==1
replace size=1 if cltype ==2|cltype ==3

*Estimates of class size on scores*
summarize tcombssk if size ==0
summarize tcombssk if size ==1

summarize tmathssk if size ==0
summarize tmathssk if size ==1

summarize treadssk if size ==0
summarize treadssk if size ==1

*testing means*
*total*
dis (931.9419-918.2013)/(sqrt((76.35863^2/1738)+(72.21422^2/4048)))
ttest tcombssk, by(size)
*math*
dis (490.9313-482.9954)/(sqrt((49.51013^2/1762)+(46.70351^2/4109)))
ttest tmathssk, by(size)
*reading*
dis (440.5474-435.0842)/(sqrt((32.49738^2/1739)+(31.22122^2/4050)))
ttest treadssk, by(size)

**NB: difference in means is statistically significant for each type of test**

*TEACHERS AIDES**

*generate new variable for with and without teachers aid*
gen aid=0 if cltype ==2
replace aid=1 if cltype ==3

*Estimates of class size on scores*
summarize tcombssk if aid ==0
summarize tcombssk if aid ==1

summarize tmathssk if aid ==0
summarize tmathssk if aid ==1

summarize treadssk if aid ==0
summarize treadssk if aid ==1

*testing means*
*total*
ttest tcombssk, by(aid)
*math*
ttest tmathssk, by(aid)
*reading*
ttest treadssk, by(aid)

**NB: difference in means is statistically insignificant for each type of test**


