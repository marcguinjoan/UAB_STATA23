********************************************************************************
********************************* STATA COURSE *********************************
********************************************************************************

********************************************************************************
******************************   Marc Guinjoan    ******************************
*********************** Universitat Oberta de Catalunya ************************
****************************** mguinjoan@uoc.edu *******************************
********************************************************************************


********************************************************************************
***************************** 1) Introduction ****************************
********************************************************************************

/***OUTLINE
- The Stata interface
- Document types (.dta, .do, .gph) 
- How to use the do-file 
- Types of variables
- Import data (csv, excel, SPSS…)
- Conversion of variables
*/

***1. How to execute any command? Two options: "Execute (do)" botton (just up), or selection line and Ctrl+D
*All the code will also run if you type Ctrl+D and no text is selected


***2. First of all, we want to know in which directory we are working
*By default the directory is the one where the dofile is placed in each document, except if you have set a dafault STATA directory.
cd

**The recommendation is to have the dofile and database in the same folder. But berhaps we want to change the directory 
cd /* [new directory] */


***3. Let's open the auto.dta file
*Given that the dofile and database are in the same directory (see folder) we can just proceed by typing the name of the database. 
use "auto.dta", clear 

*If the file was not in the same folder, write the whole path
*For instance: use "C:\Users\Marc\Desktop\Stata_UAB_2022", clear

*It is important always to include ", clear" at the end of the use command. When STATA is empty (no data) the programm will charge the database. But if you already have an open database, STATA is conservative and it does not want to erase the data. The way to force STATA to open always the file is through the ", cler" command, or just typign "clear all" in a new line. 


***4. What if we work in more than a computer?
*"capture" command allows the do-file or program to continue despite errors. For instance: when finding a non-existent directory. 
capture use "C:\Users\Marc\Home\Stata_UAB_2022", clear
capture use "C:\Users\Marc\Work\Stata_UAB_2022", clear

*Whenever STATA finds an error it will stop. 
*to prevent it, "capture" is a very useful command that we may use when we want STATA to skip some errors in the document. 


***5. Let's run some basic code, now with the dofile
browse  // show database

edit // edit database

count  // display number of observations (rows in database)

**For all variables or specific variables
describe // display type of variables
describe price

codebook // display details on each variable
codebook price

list // print database in output window
list price

sum // summarise variables
sum price


***6. Ask for help
help // generic help
help summarize 

*Help in Stata is normally basic, but from there you can access the package's instructions (much more detailed)
*Find also help in Statalist (https://www.statalist.org/)


***7. Types of variables
browse
*Red: string variables: text [make]
*Black: numbers (byte, int, long, float, or double format) [price]
*Blue: numbers with label [foreign]


***8. How to open other files?
*The "import" command allows STATA to open files from a diversity of types.
*It is always recommendable to use the help command.
help import

*The most frequent databases you will need to use are Excel, CVS and SPSS files.
*Recall to use the clear command to ask STATA to open the new file anyway. 

**8.1 Excel
import excel using "databases\excelfile.xlsx", first
*Warning: no; data in memory would be lost. 

import excel using "databases\excelfile.xlsx", first clear
*now it works! :)
 
*use first if the first column is the variable name--otherwise variables will be labelled as var01 var02, etc.  
*sheet("name"), when there are various sheets in the Excel file. Default is first one. 
*cellrange(a1:d6), to import only part of the data

**8.2 Comma-separated value (CSV file, txt)
import delimited using "databases\csvfile.txt", clear

/*WARNING: MISSING DATA
Now browse the data and see what happens in row 7, variable "partyvote" and "satisfaction"
The partyvote variable contain letters A, B, C, D and E, as well as a ".". 
"." in STATA stand for a "missing value". In this case it could mean that the individual did not vote for a party--but rather abstained.  The same happens in the variable identifying the degree of satisfation with democracy. In this case the individual probably did not want to answer this question. 
In the next session we will return to this. 
*/

**8.3 SPSS 
import spss using "databases\cis3334.sav", clear  // A shortened version of the CIS database (100 observations instead of the original 3800)


***9. It is also possible to import from the net

**A STATA file 
use "https://www.chesdata.eu/s/CHES2019V3.dta", clear 

**But mostly you will import files from other format types. Proceed equally:
*A CSV file
import spss "http://upceo.ceo.gencat.cat/wsceop/7808/Microdades%20anonimitzades%20-985.sav", clear  

*Proceed equally for other types of variables:
*import delimited, import excel, etc.


***10. Save data from other format to STATA
*Sometimes it is recommendable to save the file open in a different format into a .dta file:
cd  // we can re-check again the directory. By default it will be saved in here
save "databases\ceo985", replace  // use replace when you plan to run the code more than once (or, in other words: always! ;))


***11. How to change variable type: from string to numeric

*Let's again use the auto.data

clear all
use auto.dta

encode make, gen(car)

*See also the "destring" and "tostring" option. Convert string variables to numeric variables and vice versa (less used--we normally require numeric values): https://www.stata.com/manuals/ddestring.pdf


************************************ PRACTICE ***********************************

*1. Open the cerdanyola_idescat.csv. This is data from Cerdanyola from the IDESCAT
*2. Try to open it with the adequate tool
*3. What happens?
*4. Open the cvs file and fix the database to have the adequate format 
*5. Open it again. Does it work?
*6. Get familiarised with the programm and the main tools described in #4. 
