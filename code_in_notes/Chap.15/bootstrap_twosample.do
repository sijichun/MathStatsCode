// bootstrap_twosample.do
// 两样本均值比较的bootstrap假设检验
clear all
use ../datasets/chfs2017_ind.dta, clear
set seed 8855
// 计算观测样本的t统计量（男性-女性）
ttest a3136, by(a2003) unequal
scalar diff_obs = r(mu_1)-r(mu_2)
scalar t_obs = r(t)
di "diff = " diff_obs
di "t = " t_obs
// bootstrap重中心化的学生氏化统计量
capture program drop boot_twosample
program define boot_twosample, rclass
    ttest a3136, by(a2003) unequal
    return scalar tstar = ((r(mu_1)-r(mu_2))-diff_obs)/sqrt(r(sd_1)^2/r(N_1)+r(sd_2)^2/r(N_2))
end
bootstrap tstar=r(tstar), reps(1000) saving(bootstrap_twosample.dta, replace): boot_twosample
// 载入bootstrap结果进行计算
preserve
use bootstrap_twosample.dta, clear
// 右侧检验的临界值与p值（H1: 男性收入高于女性）
_pctile tstar, p(95)
di "右侧检验临界值 = " r(r1)
count if tstar>t_obs
di "右侧检验p值 = " r(N)/_N
// 双侧检验的临界值与p值
_pctile tstar, p(2.5 97.5)
di "双侧检验临界值 = [" r(r1) ", " r(r2) "]"
count if abs(tstar)>abs(t_obs)
di "双侧检验p值 = " r(N)/_N
restore
rm bootstrap_twosample.dta
