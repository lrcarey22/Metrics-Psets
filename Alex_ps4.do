cd "\\files\ak29\ClusterDownloads\ps4\ps4"
use wws508c_deming.dta, clear

log using ps4.log
/*******************************************************************************
                                    P1                                          
*******************************************************************************/
// Summarize Data

*view data
sum, det

*view variables
desc

*get some statistics and output them
estpost tabstat * , by( ) statistics(mean sd n) columns(statistics)

esttab using _means.tex, cells("mean sd count") replace

*break down scores by treatment
estpost tabstat comp*, by(head_start ) statistics(mean sd n) columns(statistics)

esttab using treat_scores.tex, cells("mean sd count") replace

/*******************************************************************************
                                    P2                                          
*******************************************************************************/
//estimate baseline regressions

*no controls
reg comp_score_5to6 head_start 

*controls
reg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed dadhome, r


*better controls
reg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed , r

*random effects with controls
xtreg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed , i(mom_id) re

*random effects with dad control
xtreg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed dad, i(mom_id) re

*random effects without control
xtreg comp_score_5to6 head_start , i(mom_id) re

/*******************************************************************************
                                    P3                                          
*******************************************************************************/
//estimate baseline regressions

*fixed effects with controls
xtreg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed , i(mom_id) fe robust

*fixed effects with dad control
xtreg comp_score_5to6 head_start black male hisp lnbw first lninc_0to3 momed dad, i(mom_id) fe robust

*fixed effects without control
xtreg comp_score_5to6 head_start , i(mom_id) fe robust

*fixed effects without control
xtreg comp_score_5to6 head_start male lnbw first, i(mom_id) fe robust

/*******************************************************************************
                                    P4                                          
*******************************************************************************/
//test whether there is selection into head start

*generate eleigibility variabe
gen elig = 0
replace elig = 1 if sibdiff == 1
replace elig = 1 if head_start == 1

*limit the regression 
reg head_start firstborn if sibdiff == 1

/*
bysort head_start sibdiff: egen ppvt_means = mean(ppvt)
bysort head_start : tab ppvt_means if sibdiff == 1
*/

*get the mean of childrens scores before head start by head start participation
mean ppvt_3 if sibdiff == 1, over(head_start)

*test the difference in means
ttest ppvt_3 if sibdiff == 1, by(head_start)


/*******************************************************************************
                                    P5                                          
*******************************************************************************/
//test score outcomes for later ages
foreach var of varlist comp* {

	*standardizes the test scores
	cap egen n_`var' = std(`var')
	
	*fixed effects with appropriate control
	xtreg n_`var' head_start male lnbw first, i(mom_id) fe robust
}

/*******************************************************************************
                                    P6                                          
*******************************************************************************/
//test other outcomes besides score

*change the name "repeat"
capture ren repeat rep

*loop over outcome variables and run fe reg on each
foreach var of varlist rep hsgrad somecoll fphealth { 

	xtreg `var' head_start male lnbw first, i(mom_id) fe robust
	
}

/*******************************************************************************
                                    P7                                          
*******************************************************************************/
//test effect within race and sex

*same loop as p6 by regression broken down by race and gender
foreach var of varlist rep hsgrad somecoll fphealth { 

	di "************************black****************************"
	xtreg `var' head_start male lnbw first if black == 1, i(mom_id) fe robust
	
	di "************************hispanic****************************"
	xtreg `var' head_start male lnbw first if hisp == 1 , i(mom_id) fe robust
	
	di "************************white****************************"
	xtreg `var' head_start male lnbw first if black == 0 & hisp == 0, i(mom_id) fe robust
	
	di "************************sex****************************"	
	xtreg `var' head_start##male lnbw first, i(mom_id) fe robust

	}


	
cap log close
