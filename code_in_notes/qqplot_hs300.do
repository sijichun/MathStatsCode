// qqplot.do
clear
use datasets/hs300index.dta
// 计算quantile，为了避免出现0和1，减去了0.5
sort retindex
gen q=(_n-0.5)/_N
// 计算均值、标准差
sum retindex
local mu=r(mean)
local sd=r(sd)
// 计算正态分布的quantile
gen normal_q = `sd'*invnormal(q)+`mu'
// 画图
twoway (scatter retindex normal_q) /*
    */(line normal_q normal_q), legend(off)
graph export "qqplot_manual_hs300.eps", as(eps) replace
// 官方命令
qnorm retindex
graph export "qqplot_hs300.eps", as(eps) replace
// 直方图
hist retindex, norm
graph export "hist_hs300.eps", as(eps) replace
