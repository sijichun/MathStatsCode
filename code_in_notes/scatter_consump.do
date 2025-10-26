// scatter_consump.do
use datasets/chfs_hh.dta, clear
gen log_total_consump=log(total_consump)
gen log_total_income=log(total_income)
twoway (scatter log_total_consump log_total_income if mod(_n,10)==0) (lfit log_total_consump log_total_income), legend(pos(11) ring(0) label(1 "对数消费") label(2 "拟合"))
graph export scatter_consump.pdf, replace
