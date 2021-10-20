// zipf_law.do
clear
use datasets/citydata.dta
keep if Year==2011
sort v87
gen rank=_N-_n+1
gen log_rank=log10(rank)
gen log_pop=log10(v87*10000) // 数据的单位为万人
twoway (scatter log_pop log_rank if _n<_N-5) (scatter log_pop log_rank if _n>=_N-5, mlabel(City)), legend(off) xtitle("城市大小排序的对数（从大到小）") ytitle("人口的对数")
graph export zipf_law.pdf, replace
