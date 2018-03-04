* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix              ///
  byte    age       1-2    ///
  byte    sex       3-3    ///
  int     race      4-6    ///
  int     educ      7-9    ///
  byte    wkswork1  10-11  ///
  byte    uhrswork  12-13  ///
  long    incwage   14-19  ///
  using `"cps_00003.dat"'



label var age      `"Age"'
label var sex      `"Sex"'
label var race     `"Race"'
label var educ     `"Educational attainment recode"'
label var wkswork1 `"Weeks worked last year"'
label var uhrswork `"Usual hours worked per week (last yr)"'
label var incwage  `"Wage and salary income"'

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label values sex sex_lbl

label define race_lbl 100 `"White"'
label define race_lbl 200 `"Black/Negro"', add
label define race_lbl 300 `"American Indian/Aleut/Eskimo"', add
label define race_lbl 650 `"Asian or Pacific Islander"', add
label define race_lbl 651 `"Asian only"', add
label define race_lbl 652 `"Hawaiian/Pacific Islander only"', add
label define race_lbl 700 `"Other (single) race, n.e.c."', add
label define race_lbl 801 `"White-Black"', add
label define race_lbl 802 `"White-American Indian"', add
label define race_lbl 803 `"White-Asian"', add
label define race_lbl 804 `"White-Hawaiian/Pacific Islander"', add
label define race_lbl 805 `"Black-American Indian"', add
label define race_lbl 806 `"Black-Asian"', add
label define race_lbl 807 `"Black-Hawaiian/Pacific Islander"', add
label define race_lbl 808 `"American Indian-Asian"', add
label define race_lbl 809 `"Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 810 `"White-Black-American Indian"', add
label define race_lbl 811 `"White-Black-Asian"', add
label define race_lbl 812 `"White-American Indian-Asian"', add
label define race_lbl 813 `"White-Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 814 `"White-Black-American Indian-Asian"', add
label define race_lbl 820 `"Two or three races, unspecified"', add
label define race_lbl 830 `"Four or five races, unspecified"', add
label values race race_lbl

label define educ_lbl 000 `"NIU or no schooling"'
label define educ_lbl 001 `"NIU"', add
label define educ_lbl 002 `"None or preschool"', add
label define educ_lbl 010 `"Grades 1, 2, 3, or 4"', add
label define educ_lbl 011 `"Grade 1"', add
label define educ_lbl 012 `"Grade 2"', add
label define educ_lbl 013 `"Grade 3"', add
label define educ_lbl 014 `"Grade 4"', add
label define educ_lbl 020 `"Grades 5 or 6"', add
label define educ_lbl 021 `"Grade 5"', add
label define educ_lbl 022 `"Grade 6"', add
label define educ_lbl 030 `"Grades 7 or 8"', add
label define educ_lbl 031 `"Grade 7"', add
label define educ_lbl 032 `"Grade 8"', add
label define educ_lbl 040 `"Grade 9"', add
label define educ_lbl 050 `"Grade 10"', add
label define educ_lbl 060 `"Grade 11"', add
label define educ_lbl 070 `"Grade 12"', add
label define educ_lbl 071 `"12th grade, no diploma"', add
label define educ_lbl 072 `"12th grade, diploma unclear"', add
label define educ_lbl 073 `"High school diploma or equivalent"', add
label define educ_lbl 080 `"1 year of college"', add
label define educ_lbl 081 `"Some college but no degree"', add
label define educ_lbl 090 `"2 years of college"', add
label define educ_lbl 091 `"Associate's degree, occupational/vocational program"', add
label define educ_lbl 092 `"Associate's degree, academic program"', add
label define educ_lbl 100 `"3 years of college"', add
label define educ_lbl 110 `"4 years of college"', add
label define educ_lbl 111 `"Bachelor's degree"', add
label define educ_lbl 120 `"5+ years of college"', add
label define educ_lbl 121 `"5 years of college"', add
label define educ_lbl 122 `"6+ years of college"', add
label define educ_lbl 123 `"Master's degree"', add
label define educ_lbl 124 `"Professional school degree"', add
label define educ_lbl 125 `"Doctorate degree"', add
label define educ_lbl 999 `"Missing/Unknown"', add
label values educ educ_lbl

label define wkswork1_lbl 00 `"NIU"'
label define wkswork1_lbl 01 `"1 week"', add
label define wkswork1_lbl 02 `"2 weeks"', add
label define wkswork1_lbl 03 `"3 weeks"', add
label define wkswork1_lbl 04 `"4 weeks"', add
label define wkswork1_lbl 05 `"5 weeks"', add
label define wkswork1_lbl 06 `"6 weeks"', add
label define wkswork1_lbl 07 `"7 weeks"', add
label define wkswork1_lbl 08 `"8 weeks"', add
label define wkswork1_lbl 09 `"9 weeks"', add
label define wkswork1_lbl 10 `"10 weeks"', add
label define wkswork1_lbl 11 `"11 weeks"', add
label define wkswork1_lbl 12 `"12 weeks"', add
label define wkswork1_lbl 13 `"13 weeks"', add
label define wkswork1_lbl 14 `"14 weeks"', add
label define wkswork1_lbl 15 `"15 weeks"', add
label define wkswork1_lbl 16 `"16 weeks"', add
label define wkswork1_lbl 17 `"17 weeks"', add
label define wkswork1_lbl 18 `"18 weeks"', add
label define wkswork1_lbl 19 `"19 weeks"', add
label define wkswork1_lbl 20 `"20 weeks"', add
label define wkswork1_lbl 21 `"21 weeks"', add
label define wkswork1_lbl 22 `"22 weeks"', add
label define wkswork1_lbl 23 `"23 weeks"', add
label define wkswork1_lbl 24 `"24 weeks"', add
label define wkswork1_lbl 25 `"25 weeks"', add
label define wkswork1_lbl 26 `"26 weeks"', add
label define wkswork1_lbl 27 `"27 weeks"', add
label define wkswork1_lbl 28 `"28 weeks"', add
label define wkswork1_lbl 29 `"29 weeks"', add
label define wkswork1_lbl 30 `"30 weeks"', add
label define wkswork1_lbl 31 `"31 weeks"', add
label define wkswork1_lbl 32 `"32 weeks"', add
label define wkswork1_lbl 33 `"33 weeks"', add
label define wkswork1_lbl 34 `"34 weeks"', add
label define wkswork1_lbl 35 `"35 weeks"', add
label define wkswork1_lbl 36 `"36 weeks"', add
label define wkswork1_lbl 37 `"37 weeks"', add
label define wkswork1_lbl 38 `"38 weeks"', add
label define wkswork1_lbl 39 `"39 weeks"', add
label define wkswork1_lbl 40 `"40 weeks"', add
label define wkswork1_lbl 41 `"41 weeks"', add
label define wkswork1_lbl 42 `"42 weeks"', add
label define wkswork1_lbl 43 `"43 weeks"', add
label define wkswork1_lbl 44 `"44 weeks"', add
label define wkswork1_lbl 45 `"45 weeks"', add
label define wkswork1_lbl 46 `"46 weeks"', add
label define wkswork1_lbl 47 `"47 weeks"', add
label define wkswork1_lbl 48 `"48 weeks"', add
label define wkswork1_lbl 49 `"49 weeks"', add
label define wkswork1_lbl 50 `"50 weeks"', add
label define wkswork1_lbl 51 `"51 weeks"', add
label define wkswork1_lbl 52 `"52 weeks"', add
label values wkswork1 wkswork1_lbl

label define uhrswork_lbl 00 `"NIU"'
label define uhrswork_lbl 01 `"1 hour"', add
label define uhrswork_lbl 02 `"2 hours"', add
label define uhrswork_lbl 03 `"3 hours"', add
label define uhrswork_lbl 04 `"4 hours"', add
label define uhrswork_lbl 05 `"5 hours"', add
label define uhrswork_lbl 06 `"6 hours"', add
label define uhrswork_lbl 07 `"7 hours"', add
label define uhrswork_lbl 08 `"8 hours"', add
label define uhrswork_lbl 09 `"9 hours"', add
label define uhrswork_lbl 10 `"10 hours"', add
label define uhrswork_lbl 11 `"11 hours"', add
label define uhrswork_lbl 12 `"12 hours"', add
label define uhrswork_lbl 13 `"13 hours"', add
label define uhrswork_lbl 14 `"14 hours"', add
label define uhrswork_lbl 15 `"15 hours"', add
label define uhrswork_lbl 16 `"16 hours"', add
label define uhrswork_lbl 17 `"17 hours"', add
label define uhrswork_lbl 18 `"18 hours"', add
label define uhrswork_lbl 19 `"19 hours"', add
label define uhrswork_lbl 20 `"20 hours"', add
label define uhrswork_lbl 21 `"21 hours"', add
label define uhrswork_lbl 22 `"22 hours"', add
label define uhrswork_lbl 23 `"23 hours"', add
label define uhrswork_lbl 24 `"24 hours"', add
label define uhrswork_lbl 25 `"25 hours"', add
label define uhrswork_lbl 26 `"26 hours"', add
label define uhrswork_lbl 27 `"27 hours"', add
label define uhrswork_lbl 28 `"28 hours"', add
label define uhrswork_lbl 29 `"29 hours"', add
label define uhrswork_lbl 30 `"30 hours"', add
label define uhrswork_lbl 31 `"31 hours"', add
label define uhrswork_lbl 32 `"32 hours"', add
label define uhrswork_lbl 33 `"33 hours"', add
label define uhrswork_lbl 34 `"34 hours"', add
label define uhrswork_lbl 35 `"35 hours"', add
label define uhrswork_lbl 36 `"36 hours"', add
label define uhrswork_lbl 37 `"37 hours"', add
label define uhrswork_lbl 38 `"38 hours"', add
label define uhrswork_lbl 39 `"39 hours"', add
label define uhrswork_lbl 40 `"40 hours"', add
label define uhrswork_lbl 41 `"41 hours"', add
label define uhrswork_lbl 42 `"42 hours"', add
label define uhrswork_lbl 43 `"43 hours"', add
label define uhrswork_lbl 44 `"44 hours"', add
label define uhrswork_lbl 45 `"45 hours"', add
label define uhrswork_lbl 46 `"46 hours"', add
label define uhrswork_lbl 47 `"47 hours"', add
label define uhrswork_lbl 48 `"48 hours"', add
label define uhrswork_lbl 49 `"49 hours"', add
label define uhrswork_lbl 50 `"50 hours"', add
label define uhrswork_lbl 51 `"51 hours"', add
label define uhrswork_lbl 52 `"52 hours"', add
label define uhrswork_lbl 53 `"53 hours"', add
label define uhrswork_lbl 54 `"54 hours"', add
label define uhrswork_lbl 55 `"55 hours"', add
label define uhrswork_lbl 56 `"56 hours"', add
label define uhrswork_lbl 57 `"57 hours"', add
label define uhrswork_lbl 58 `"58 hours"', add
label define uhrswork_lbl 59 `"59 hours"', add
label define uhrswork_lbl 60 `"60 hours"', add
label define uhrswork_lbl 61 `"61 hours"', add
label define uhrswork_lbl 62 `"62 hours"', add
label define uhrswork_lbl 63 `"63 hours"', add
label define uhrswork_lbl 64 `"64 hours"', add
label define uhrswork_lbl 65 `"65 hours"', add
label define uhrswork_lbl 66 `"66 hours"', add
label define uhrswork_lbl 67 `"67 hours"', add
label define uhrswork_lbl 68 `"68 hours"', add
label define uhrswork_lbl 69 `"69 hours"', add
label define uhrswork_lbl 70 `"70 hours"', add
label define uhrswork_lbl 71 `"71 hours"', add
label define uhrswork_lbl 72 `"72 hours"', add
label define uhrswork_lbl 73 `"73 hours"', add
label define uhrswork_lbl 74 `"74 hours"', add
label define uhrswork_lbl 75 `"75 hours"', add
label define uhrswork_lbl 76 `"76 hours"', add
label define uhrswork_lbl 77 `"77 hours"', add
label define uhrswork_lbl 78 `"78 hours"', add
label define uhrswork_lbl 79 `"79 hours"', add
label define uhrswork_lbl 80 `"80 hours"', add
label define uhrswork_lbl 81 `"81 hours"', add
label define uhrswork_lbl 82 `"82 hours"', add
label define uhrswork_lbl 83 `"83 hours"', add
label define uhrswork_lbl 84 `"84 hours"', add
label define uhrswork_lbl 85 `"85 hours"', add
label define uhrswork_lbl 86 `"86 hours"', add
label define uhrswork_lbl 87 `"87 hours"', add
label define uhrswork_lbl 88 `"88 hours"', add
label define uhrswork_lbl 89 `"89 hours"', add
label define uhrswork_lbl 90 `"90 hours"', add
label define uhrswork_lbl 91 `"91 hours"', add
label define uhrswork_lbl 92 `"92 hours"', add
label define uhrswork_lbl 93 `"93 hours"', add
label define uhrswork_lbl 94 `"94 hours"', add
label define uhrswork_lbl 95 `"95 hours"', add
label define uhrswork_lbl 96 `"96 hours"', add
label define uhrswork_lbl 97 `"97 hours"', add
label define uhrswork_lbl 98 `"98 hours"', add
label define uhrswork_lbl 99 `"99 hours plus"', add
label values uhrswork uhrswork_lbl

label define incwage_lbl 999999 `"999999"'
label values incwage incwage_lbl

save cps08,replace
