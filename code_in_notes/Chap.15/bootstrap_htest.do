// bootstrap_htest.do
clear all
use ../datasets/chfs2017_hh.dta
drop if total_income<0
set seed 250211
// 计算原始样本的t统计量
su total_income
local theta_hat = r(mean)
local t = (r(mean)-90000)/(r(sd)/sqrt(r(N)))
di "t = " `t'
// bootstrap学生氏化统计量并保存结果
bootstrap (sqrt(r(N))*(r(mean)-`theta_hat')/r(sd)), reps(1000) saving(bootstrap_htest.dta, replace): su total_income
// 载入bootstrap结果进行计算
preserve
use bootstrap_htest.dta, clear
rename _bs_1 tstar
// bootstrap临界值
_pctile tstar, p(2.5 95 97.5)
di "右侧检验临界值 = " r(r2)
di "双侧检验临界值 = [" r(r1) ", " r(r3) "]"
// bootstrap p值
count if tstar>`t'
di "右侧检验p值 = " r(N)/_N
count if abs(tstar)>abs(`t')
di "双侧检验p值 = " r(N)/_N
restore
rm bootstrap_htest.dta
