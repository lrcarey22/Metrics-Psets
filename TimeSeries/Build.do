cd "\\files\ak29\ClusterDesktop\TimeSeries Data\"

*-------------------------------Make Consumption Data--------------------------*

*get consumption inequality ratio
use consumption-inequality.dta, clear

keep if country == "United States"

keep year mean* share*

save consump_ratio.dta, replace

*get durable inflation rates
import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\Durable_Inflation.xls", sheet("FRED Graph") cellrange(A11:B74) firstrow clear
ren obs date
ren CUSR CPI
gen year = year(date)
replace CPI = CPI / 100

save durable_cpi.dta, replace

import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\CNP16OV.xls", sheet("FRED Graph") cellrange(A12:B81) clear
ren A yr
ren B population
replace population = population * 1000
gen year = year(yr)

save population.dta, replace

*get durable consumption
import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\nom_PCE-durable.xls", sheet("FRED Graph") cellrange(A11:B82) firstrow clear
ren obs date
ren PC nom_dur_c 
gen year = year(date)

merge 1:1 year using durable_cpi.dta
drop _merge

gen real_durable_cons = (nom*(1000000000))/CPI

*calculate consumption shares
merge 1:1 year using consump_ratio.dta
drop _merge

ren sharetop1 share01
ren sharetop5 share05

*sum shares to match Zucman income and wealth data
gen share_btm_90 = share1 + share2 +  share3 + share4 + share5 + share6 + share7 + share8 + share9
gen share_btm_50 = share1 + share2 +  share3 + share4 + share5 
gen share_mid_40 = share3 + share4 + share5 + share6

*calculate fractional share of aggregate real durable consumption
gen total_btm_90 = share_btm_90 * real_durable_cons
gen total_btm_50 = share_btm_50 * real_durable_cons
gen total_mid_40 = share_mid_40 * real_durable_cons
gen total_top_10 = share10      * real_durable_cons

merge 1:1 year using population.dta
drop _merge

*calculate per capita share of aggregate real durable consumption (in 2014 dollars)
gen c_btm_90 = total_btm_90 / (.9 * population) * 1.873
gen c_btm_50 = total_btm_50 / (.5 * population) * 1.873
gen c_mid_40 = total_mid_40 / (.4 * population) * 1.873
gen c_top_10 = total_top_10 / (.1 * population) * 1.873

replace c_btm_90 = log(c_btm_90)
replace c_btm_50 = log(c_btm_50)
replace c_mid_40 = log(c_mid_40)
replace c_top_10 = log(c_top_10)


save consumption.dta, replace

*------------------------------Make labor Income Data--------------------------*

*get average fiscal incomes
import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\PSZ2017AppendixTablesII(Distrib).xlsx", sheet("TD3") cellrange(A19:H111) clear
ren A year
ren B All_income
ren C btm_90pct
ren D btm_50pct
ren E mid_40pct

ren F top_10pct
ren G top_5pct
ren H top_1pct

drop if year == .
save total_incomes.dta, replace

*get average labor componenet 
import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\PSZ2017AppendixTablesII(Distrib).xlsx", sheet("TD2") cellrange(A59:AA119) clear
keep A B D I K P R
ren A year
ren B btm_90pct_pct
ren D btm_90pct_labor_pct
ren I btm_50pct_pct
ren K btm_50pct_labor_pct
ren P mid_40pct_pct
ren R mid_40pct_labor_pct

drop if year == .
save labor_components1.dta, replace

import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\PSZ2017AppendixTablesII(Distrib).xlsx", sheet("TD2b") cellrange(A59:AA119) clear
keep A B D 
ren A year
ren B top_10pct_pct
ren D top_10pct_labor_pct

drop if year == .
merge 1:1 year using labor_components1.dta
drop _merge

*add top 10% labor component
gen btm_90pct_labor_component = btm_90pct_labor_pct / btm_90pct_pct
gen btm_50pct_labor_component = btm_50pct_labor_pct / btm_50pct_pct
gen mid_40pct_labor_component = mid_40pct_labor_pct / mid_40pct_pct
gen top_10pct_labor_component = top_10pct_labor_pct / top_10pct_pct

drop if year == .

merge 1:1 year using total_incomes.dta
drop _merge

*calcualte labor income income
gen y_btm_90 = btm_90pct_labor_component * btm_90pct
gen y_btm_50 = btm_50pct_labor_component * btm_50pct
gen y_mid_40 = mid_40pct_labor_component * mid_40pct
gen y_top_10 = top_10pct_labor_component * top_10pct

replace y_btm_90 = log(y_btm_90)
replace y_btm_50 = log(y_btm_50)
replace y_mid_40 = log(y_mid_40)
replace y_top_10 = log(y_top_10)


save income.dta, replace

*--------------------------------Make Wealth Data------------------------------*

*get wealth data

import excel "\\files\ak29\ClusterDesktop\TimeSeries Data\PSZ2017AppendixTablesII(Distrib).xlsx", sheet("TE3") cellrange(A59:H111) clear

ren A year
ren B All_wealth
ren C w_btm_90
ren D w_btm_50
ren E w_mid_40
ren F w_top_10
ren G w_top_5
ren H w_top_1

replace w_btm_90 = log(w_btm_90)
replace w_btm_50 = log(w_btm_50)
replace w_mid_40 = log(w_mid_40)
replace w_top_10 = log(w_top_10)


drop if year == .
save wealth.dta, replace

*combine data

merge 1:1 year using income.dta
drop _merge
merge 1:1 year using consumption.dta

keep if year > 1961 & year < 2015

save project.dta, replace
