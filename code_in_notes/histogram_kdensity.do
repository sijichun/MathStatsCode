// histogram_kdensity.do
clear
use datasets/cfps_adult.dta
drop if qp101<0
twoway (hist qp101,bin(40) density) (kdensity qp101)
graph export hist_kdens.pdf, replace
