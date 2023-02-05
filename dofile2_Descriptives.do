********************************************************************************
********************************* STATA COURSE *********************************
********************************************************************************

********************************************************************************
******************************   Marc Guinjoan    ******************************
*********************** Universitat Oberta de Catalunya ************************
****************************** mguinjoan@uoc.edu *******************************
********************************************************************************


********************************************************************************
************************** 2) Descriptive statistics ***************************
********************************************************************************

/***OUTLINE
- Descriptives and frequencies
- Install external packages
- Variable recodification
- Label variables and values
- Histograms and graph edition
*/

***Today we will work with data from the World Values Survey, Wave 7 (2017-2020). Data can be found in the folder \databases\WVS_Wave7.dta, as well as the questionnaire (WVS_Wave7_questionnaire.pdf)

use "databases\WVS\WVS_Wave7.dta", clear

***1. Explore the database: tabulate data

tab B_COUNTRY // lists the countries and the number of observations per country (surveys)

*if we open the database we can ser that this is a numeric variable: how do we know which is the code number for each country?

tab B_COUNTRY, nol

*--> Not quite straightforward. We need a better option.
*Some extensions created by the STATA community to improve the experience. 

ssc install fre // if we know the exact name of the extension

fre B_COUNTRY // summary of the countries
fre B_COUNTRY, all  // all countries and codes


***2. Explore the data: summarise a variable 

*The variable age is called Q262....

sum Q262 // N, Mean, std dev, min and max
sum Q262, detail // if we want to have more details 

*Caution: -5 years? Most data needs to be treated before being descrived!


***3. Recode variables 
fre Q262

recode Q262 (-5=.) (-2=.), gen(age) // Values not included in the command are kept equally
sum age  // now it makes more sense!

*But what if we want to recode people by groups?
recode Q262 (18/24=1 "From 16 to 24 years old") (25/34=2 "From 25 to 34 years old") (35/44=3 "From 35 to 44 years old") (45/54=4 "From 45 to 54 years old") (55/64=5 "From 55 to 64 years old") (65/103=6 "65 and more years old") (else=.), gen(age_6groups)  // we have missed individuals below 18 and no valid answers. Note that we have placed a label name to each category. 

fre age_6groups


***4. Replace variable 
*In some occasions we just need to drop some missing values
*In this occasion we introduce the use of the function "replace" and "if". "If" sets up the condition that is asked to be met in order to proceed as asked. 

fre H_SETTLEMENT // values -5 and -4 are not valid settlement types

replace H_SETTLEMENT=. if H_SETTLEMENT==-5   // If, and only if, H_SETTLEMENT is equal to -5, then replace the variable H_SETTLEMENT with a missing character (".")
replace H_SETTLEMENT=. if H_SETTLEMENT==-4

*or, which is the same:
replace H_SETTLEMENT=. if H_SETTLEMENT==-4 | H_SETTLEMENT==-5

*or: 
replace H_SETTLEMENT=. if H_SETTLEMENT<-1 

*replace if can be used combining two different variables if they are connected. 


***5. Create and drop variables
gen settlement= H_SETTLEMENT  // does not keep the labels
clonevar settlement_label = H_SETTLEMENT  // it keeps the label! :)

gen always1 = 1
drop always1

gen missing=.
drop missing

gen retired=0
replace retired=1 if age>64 
fre retired
drop retired

*We can also use the "keep" command, which does the same but in the inverse way: it keeps only the variables mentioned. 


***6. Create and drop observations in a variable
*In some occasions we do not want to drop a variable but just some of the observations of the variable. For instance, in this case we could be interested in interviews that took place in 2018, but not those that were performed in 2017, 2019 and 2020. How to proceed? Various ways:
fre A_YEAR

drop if A_YEAR==2017 | A_YEAR>2018

*or
keep if A_YEAR==2018


***7. Label variables and values
*Most variable names are not easy to identify.

fre Q240 // ideology
rename Q240 ideology  // We can rename it to make it easier to identify

label variable ideology "Ideology, from 1 to 10" // We can create a label easy to identify

replace ideology=. if ideology<0

label define ideologylabel 1 "Left" 5 "Centre" 10 "Right"  // create a new variable
label values ideology ideologylabel  // attribute new variable to old variable (important to set the new values)


***8. Histograms
*Sometimes we want to graphically describe variables--frequencies are often not enught easy to read. 

*let us know decide to work with only one country to make the processing of plots faster. Does Nigeria works for you?
keep if B_COUNTRY==566  // B_COUNTRY 566 is Nigeria

*Ideology
hist ideol  // That's a start, but it can be clearly improved

hist ideol, title("Ideology")  // Title

hist ideol, title("Ideology") xtitle(Left-right scale)  // Title in the x-axis

hist ideol, title("Ideology") xtitle(Left-right scale) percent  // Percentage in the y-axis instead of density

hist ideol, title("Ideology") xtitle(Left-right scale) percent xlabel(1 "Left" 2 3 4 5 "Centre" 6 7 8 9 10 "Right")  // labels in the x-axis values

hist ideol, title("Ideology") xtitle(Left-right scale, height(7)) ytitle(, height(5)) percent xlabel(1 "Left" 2 3 4 5 "Centre" 6 7 8 9 10 "Right")  // ylabel and more space in the xlabel

hist ideol, title("Ideology") xtitle(Left-right scale, height(7)) ytitle(, height(5)) percent xlabel(1 "Left" 2 3 4 5 "Centre" 6 7 8 9 10 "Right") scheme(s1mono) // another scheme

hist ideol, title("Ideology") xtitle(Left-right scale, height(7)) ytitle(, height(5)) percent xlabel(1 "Left" 2 3 4 5 "Centre" 6 7 8 9 10 "Right") scheme(s1mono) bin(19)  // columns wider

hist ideol, title("Ideology") xtitle(Left-right scale, height(7)) ytitle(, height(5)) percent xlabel(1 `""Extreme"" ""Left""' 2 3 4 5 "Centre" 6 7 8 9 10 `""Extreme  "" ""Right  ""') scheme(s1mono) bin(19) // Two lines labels

hist ideol, title("Ideology") xtitle(Left-right scale, height(7)) ytitle(, height(5)) percent xlabel(1 `""Extreme"" ""Left""' 2 3 4 5 "Centre" 6 7 8 9 10 `""Extreme  "" ""Right  ""') scheme(s1mono) bin(19) scale(0.9) // Font smaller

*Finally, we want to save the figture....
graph save results\ideology, replace // STATA editable: for future edition
graph export results\ideology.pdf, replace  // Vectorial printing--high quality: for publication
*PNG, JPG, TIFF, .., formats also available, but PDF is superior in terms of quality. 


************************************ PRACTICE ***********************************

*1. Reload the WVS survey
*2. Select data from a country (drop the others)
*3. Select up to 10 variables of interest for you (drop the others). Make sure you have categorical and continuous variables
*4. Fix, if necessary, the labels
*5. Recode the variables so that missing values are properly treated
*6. Summarize two variables
*7. Create and edit an histogram of one of the selected variables.
