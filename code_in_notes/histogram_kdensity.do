// histogram_kdensity.do
use datasets/chfs_ind.dta, clear
// 生成对数变量
gen log_income=log10(labor_inc)
twoway (hist log_income,bin(100) density) (kdensity log_income)
graph export hist_kdens.pdf, replace
