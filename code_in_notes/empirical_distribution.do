// empirical_distribution.do
use datasets/chfs_ind.dta, clear
// 生成对数变量
gen log_income=log10(labor_inc)
// 排序
sort log_income
// 生成排序序号，注意处理可能的缺失值
gen notmissing=log_income~=.
qui: su notmissing
gen cum_log_income=_n/r(sum) if notmissing
// 画图
qui: su log_income, de
local median_log_income=r(p50)
line cum_log_income log_income, xline(`median_log_income', lp(dot)) yline(0.5, lp(dot))
graph export empirical_distribution.pdf, replace
