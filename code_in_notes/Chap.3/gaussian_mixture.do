// check_random.do
set more off
clear
set obs 1000
// generate x1 and x0
gen x0=rnormal(2.5,sqrt(0.8))
gen x1=rnormal(-2,1)
// about 30% patient
gen d=runiform()<0.7
// generate x
gen x=d*x1+(1-d)*x0
// histogram
hist x
