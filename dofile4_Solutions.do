********************************************************************************
********************************* STATA COURSE *********************************
********************************************************************************

********************************************************************************
******************************   Marc Guinjoan    ******************************
*********************** Universitat Oberta de Catalunya ************************
****************************** mguinjoan@uoc.edu *******************************
********************************************************************************


********************************************************************************
********************************* 4) Practice **********************************
********************************************************************************

***Session 2: 

*1. Use a survey of your choice 
*We will use the WVS, feel free to use this one or another survey (the ESS, or the CIS or CEO surveys)

capture cd "databases\"
unzipfile "WVS\WVS7.zip"
use "WVS_Wave7.dta", clear

*2. Select data from a country (drop the other countries--if it applies)

tab B_COUNTRY 

tab B_COUNTRY, nol

fre B_COUNTRY, all

keep if B_COUNTRY== 484

*3. Select up to 10 variables of interest for you (drop the others). Make sure you have categorical and continuous variables

rename Q240 ideology 
rename Q262 age
rename Q222 vote
rename Q199 polinterest
rename Q250 democracy
rename Q130 immigration 
rename Q275 education 


*4. Fix, if necessary, the labels

fre ideology Q260 age vote polinterest democracy immigration education

label variable education "highest level of education" 

*5. Recode the variables so that missing values are properly treated

*ideology
fre ideology
replace ideology=. if ideology <0

*gender
fre Q260
recode Q260 (1=0 "men") (2=1 "women"), gen (female) 
label variable female "female"

*age 
fre age 
replace age=. if age<0

*democracy
fre democracy 
replace democracy=. if democracy <0 

*education 
fre education 
recode education (0 1=1 "primary") (2 3 4 =2 "secondary") (5/8=3 "university") (else=.), gen(edu3)

*6. Summarize two variables
sum edu3 ideology
sum edu3 ideology, d

*7. Create and edit an histogram of one of the selected variables.
histogram age 
histogram age, title (Age) percent ytitle (percentage) 
histogram age, title (Age) percent ytitle (percentage) bin (20)
histogram age, title (Age) percent ytitle (percentage) bin (20) xlabel (18 20(5)100)

graph export histogramage.pdf, replace

erase "WVS_Wave7.dta"

**********************************

*****Session 3

*1. Use a database of your choice
*We will use the V-Dem database. The Chapel Hill Experts Survey is also a good choice for practising. 

unzipfile vdem.zip, replace
use "V-Dem-CY-Core-v11.dta", clear

*2. Choose two categorical variables and cross-tabulate them

fre v2psbars_ord
rename v2psbars_ord barriers
fre v2exrescon_ord
rename v2exrescon_ord constitution
tab barriers constitution, row // percentage row
tab barriers constitution, row nofreq // show only percentage

*3. Choose one continuous and one categorical variable and show the mean of the continuous variable across the different values of the categorical variable (tabstat)

rename v2x_libdem demliberal
tabstat demliberal, by (barriers) // by always with ()

*4. Choose (up to) 5 continuous variables and check the degree of correlation between them and the signification

cor v2x_frassoc_thick v2x_freexp_altinf v2clacfree v2x_freexp
pwcorr v2x_frassoc_thick v2x_freexp_altinf v2clacfree v2x_freexp, sig 

*5. Chose two continuous variables and draw a scatter plot. Tune it up or better visualisation and to contain the basic information

twoway scatter v2x_frassoc_thick v2x_freexp_altinf
graph twoway (scatter v2x_frassoc_thick v2x_freexp_altinf) (lfit v2x_frassoc_thick v2x_freexp_altinf)


*6. Test several hypothesis with the variables use in #2 (categorical) or in #3 (continuous variable). Recall that the ttest can only be used with a dichotomous categorical variable. If the variable you were using has more than 2 categories, recode it to have just two. 

fre barriers
recode barriers (0/2=0 "barriers") (3/4=1 "no barriers"), gen(barriers2)
fre barriers2 
ttest v2x_frassoc_thick, by(barriers2)
ttest v2x_frassoc_thick=0.4 // just testing if the mean is equal to 0.4
ttest v2x_frassoc_thick=v2x_freexp_altinf // testing if the variables are the same

*7. Repeat the scatterplot in #5 by splitting the sample with the dichotomous variable in #6. Use either the "by()" or the "if==+graph combine" strategy. 

graph twoway (scatter v2x_frassoc_thick v2x_freexp_altinf) (lfit v2x_frassoc_thick v2x_freexp_altinf), by(barriers2)
label variable barriers2 "barriers to parties"
graph twoway (scatter v2x_frassoc_thick v2x_freexp_altinf) (lfit v2x_frassoc_thick v2x_freexp_altinf), by(barriers2)

erase "V-Dem-CY-Core-v11.dta"