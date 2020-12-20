// Titanic.do
clear all
use datasets/titanic.dta
// 按照性别加总
collapse (sum)num_aboard (sum)num_death, by(sex)
// 计算幸存人数
gen num_survive=num_aboard-num_death
// 计算死亡总人数、幸存总人数
qui: sum num_death
local death=r(sum)
qui: sum num_survive
local survive=r(sum)
local N=`death'+`survive'
// 计算理论死亡、幸存人数
gen e_num_death=num_aboard*`death'/`N'
gen e_num_survive=num_aboard*`survive'/`N'
// 计算检验统计量
gen chi2_death=(num_death-e_num_death)^2/e_num_death
gen chi2_survive=(num_survive-e_num_survive)^2/e_num_survive
gen chi2=chi2_death+chi2_survive
qui: su chi2
local test_stat=r(sum)
di "test statistics= `test_stat'"
local p=1-chi2(2 ,`test_stat')
di "p-value= `p'" 
