// simulate_CLT.do
clear all
set more off
set seed 8855
// 混合正态分布
set obs 1000
gen d=runiform()>=0.5
gen x=d*rnormal(3,1)+(1-d)*rnormal(-3,1)
hist x
graph export simulate_CLT_mix.pdf, replace
// 模拟
local graphs ""
foreach N in 2 3 4 10 100 1000{
	frame create mean`N' m
	frame mean`N': label variable m "样本均值"
	forvalues j=1/2000{
		clear
		set obs `N'
		gen d=runiform()>=0.5
		gen x=d*rnormal(3,1)+(1-d)*rnormal(-3,1)
		su x
		frame post mean`N' (r(mean))
	}
	frame mean`N': hist m, normal saving(simulate_CLT`N', replace) title("N=`N'")
	local graphs "`graphs' simulate_CLT`N'.gph"
}
graph combine `graphs', col(3)
graph export simulate_CLT.pdf, replace
