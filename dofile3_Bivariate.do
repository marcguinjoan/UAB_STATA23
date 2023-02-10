********************************************************************************
********************************* STATA COURSE *********************************
********************************************************************************

********************************************************************************
******************************   Marc Guinjoan    ******************************
*********************** Universitat Oberta de Catalunya ************************
****************************** mguinjoan@uoc.edu *******************************
********************************************************************************


********************************************************************************
************************ 3) Bivariate statistics *************************
********************************************************************************

/***OUTLINE
- Contingency tables
- Correlations
- Scatterplots
- T-Tests
- Filters and sample splitting
*/

***Now we will work with an aggregated-level database: the Vdem dataset, a database on the quality of democracy around the world created by the homonym institute, that also includes myriad political variable from other sources.
*In this practice we move forward from the descriptive statistics seen in the previous session, to deal with bivariate statistics. These incude signification tests.

capture cd "databases\"
unzipfile "vdem.zip", replace
use "V-Dem-CY-Core-v11.dta", clear

***1. Contingency tables
*We often want to cross-tabulate different categorical variables. 
*For instance, our first research question is whether the form of government (presidential or parliamentarian) is associated with vote buying. 
fre v2elvotbuy_ord 
rename v2elvotbuy_ord votebuying

fre v2xel_elecpres
recode v2xel_elecpres (0=0 "Parliamentarian") (1=1 "Presidential"), gen(presidential) // we did no changes into the variable but just with a line of code we changed the name of the variable and included label in the categories

*Let's cross-tabulate the two variables:
tab votebuying presidential // Very complicated to dilucidate it!
tab votebuying presidential , col  // it seems that presidential elections have engaege to a larger degree in vote buying mechanisms (higher values in systematic, not systematic and restricted)
tab votebuying presidential , col nofreq  // even easier to read

*More complicated: if one of the variables is continuous and not categorical we can also create a cross-tabulation with the mean value of the continuous variable (or another statistic).

*For instance, we want to calculate the mean level of electoral democracy (v2x_polyarchy) depending on the practice of vote buying.
sum v2x_polyarchy
rename v2x_polyarchy dem_electoral

tabstat dem_electoral, by(votebuying)  // as expected, as we move from more vote-buying countries to countries with no vote-buying at all, the electoral democracy index improves
tabstat dem_electoral, by(votebuying) stats(mean N sd median p25 p75) // we can also include more information

*Tabstat has many other features:
help tabstat

***2. Correlations
*How much correlated are the different democratic indicators?
rename v2x_libdem dem_liberal
rename v2x_partipdem dem_particpatory
rename v2x_delibdem dem_deliberative
rename v2x_egaldem dem_egalitarian

*Let's first try a 2x2 correlation
cor dem_electoral dem_liberal // extremely high!

*We can also include other correlations
cor dem_electoral dem_liberal dem_particpatory dem_deliberative dem_egalitarian

*Or, which is the same...
cor dem_*  // The "*" means all. In this case we have asked STATA to include all variables that start with "dem_", irrespective of how do they end. 


***3. Statistical signification in correlations
*Are electoral democracies more decentralised?
sum v2xel_regelec
rename v2xel_regelec regionalism

pwcorr regionalism dem_electoral, sig
pwcorr regionalism dem_electoral, sig ob star(0.01)


***4. Scatterplots
*Are countries with higher participation from the civil society more egalitarian in democratic terms?
sum v2x_cspart 
rename  v2x_cspart civsoc_part

*Let's plot a first scatterplot
twoway scatter civsoc_part dem_egalitarian  // Basic graph

twoway scatter civsoc_part dem_egalitarian, title("Civil society participation and egalitarian democracy") scale(0.9)  // title and scale

twoway scatter civsoc_part dem_egalitarian, title("Civil society participation and egalitarian democracy") xtitle(, height(5)) ytitle(, height(5)) scale(0.9)  // height x and ytitles

graph twoway (scatter civsoc_part dem_egalitarian) (lfit civsoc_part dem_egalitarian), title("Civil society participation and egalitarian democracy") xtitle(, height(5)) ytitle(, height(5)) scale(0.9) // we add a second graph: the line fit. Note that the code is rather different: graph twoway (scatter var1 var2) (lfit var1 var2)

graph twoway (scatter civsoc_part dem_egalitarian) (lfit civsoc_part dem_egalitarian, lwidth(0.8)), title("Civil society participation and egalitarian democracy") xtitle(, height(5)) ytitle(Civil society participation index, height(5)) scale(0.9)  // some final tunning

graph twoway (scatter civsoc_part dem_egalitarian) (lfitci civsoc_part dem_egalitarian, lwidth(0.3)), title("Civil society participation and egalitarian democracy") xtitle(, height(5)) ytitle(Civil society participation index, height(5)) scale(0.9)  // instead of a line fine, a line fit with 95% confidence intervals (very small!)
graph close

***5. T-test
*Are differences statistically significant by groups? We want to assess whether (the different types of) democracy differs by form of government:

ttest dem_electoral, by(presidential)  // Electoral democracy: significant
ttest dem_liberal, by(presidential)  // Liberal-democracy: not significant
*Warning: "ttest, by" performs pairwise comparisons when one categorical variable has two categories. When attempting to run a ttest with more than 2 variables STATA will show an error text (more than 2 groups found, only 2 allowed)

*is a variable equal to a certain value?
ttest dem_egalitarian==0.4  // Significant= it is not erqual to 0.4!

*is the mean of a variable equal to the mean of another?
ttest dem_deliberative = dem_particpatory  // Significant: again, the means are not equal!


***6. Filters and sample splitting
*We have already seen the "by" option when using tabstat. The "by" option is very powerful in STATA. It splits the sample by the different categories of the variable selected. For instance, with graphs....

graph twoway (scatter civsoc_part dem_egalitarian) (lfit civsoc_part dem_egalitarian, lwidth(0.8)), by(presidential) // scatterplot between civil society participation and the degree of egalitarian democracy, by form of government

graph twoway (scatter civsoc_part dem_egalitarian) (lfit civsoc_part dem_egalitarian, lwidth(0.8)), by(presidential) xtitle(, height(5)) ytitle(Civil society participation index, height(5))  scale(0.9)  // some improvements

label variable presidential "Type of government"
graph twoway (scatter civsoc_part dem_egalitarian) (lfit civsoc_part dem_egalitarian, lwidth(0.8)), by(presidential) xtitle(, height(5)) ytitle(Civil society participation index, height(5))  scale(0.9)  // and last improvements

graph close

*The by option is also very useful for histograms


***7. Graph combine 
*In some occasions though we want to create more malleable graphs. The by option is quite restrictive in this sense and a good option is to use the "graph combine" option. Let's replicate the previous exercice....

graph twoway (scatter civsoc_part dem_egalitarian if presidential==0, mcolor(maroon)) (lfit civsoc_part dem_egalitarian if presidential==0, lcolor(black) lwidth(0.8)), title(Parliamentarian countries) xtitle(, height(5)) ytitle(Civil society participation index, height(5))  scale(0.9) name(parliamentarian, replace) // Parliamentarian countries in red.

graph twoway (scatter civsoc_part dem_egalitarian if presidential==1, mcolor(dkgreen)) (lfit civsoc_part dem_egalitarian if presidential==1, lcolor(black) lwidth(0.8)), title(Presidential countries) xtitle(, height(5)) ytitle(Civil society participation index, height(5))  scale(0.9) name(presidential, replace)  // Presidential countries in green.

graph combine parliamentarian presidential, name(combine, replace)  // that's not bad, but do we need to have two identical legends? the grc1leg solves this.

*Install grc1leg
net from http://www.stata.com
net cd users
net cd vwiggins
net install grc1leg

grc1leg parliamentarian presidential, name(combine, replace) // that's better!

grc1leg parliamentarian presidential, title("Civil society participation and egalitarian democracy") name(combine, replace)

graph close

************************************ PRACTICE ***********************************

*1. Reload the Vdem survey
*2. Choose one continuous and one categorical variable and show the mean of the continuous variable across the different vaues of the categorical variable (tabstat)
*3. Choose 5 continuous variables and check the degree of correlation between them and the signification
*4. Chose two continuous variables and draw a scatter plot. Tune it to contain the basic information
*5. Test several hypothesis with the variables use in #2. Recall that the ttest can only be used with a dichotomous categorical variable. If the variable you were using has more than 2 categories, recode it to have just two. 
*6. Repeat the scatterplot in #4 by splitting the sample with the dichotomous variable in #5. Use either the "by()" or the "if==+graph combine" strategy. 
