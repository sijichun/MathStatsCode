// bootstrap_student.do
clear all
use datasets/OHIE_QJE.dta
// bootstrap
bootstrap b=_b[treatment] se=_se[treatment], reps(200) seed(55) cluster(household_id) saving(bootstrap_student.dta, replace): reg birthyear_list treatment, vce(bootstrap)
// 进行回归，保存系数和标准误
reg birthyear_list treatment
local b=_b[treatment]
local se=_se[treatment]
// 打开一个数据框，装入bootstrap_student.dta
frame create bootstrap_sample
frame change bootstrap_sample
use bootstrap_student.dta
gen t=(b-`b')/se
sort t
local alpha_25=(t[floor(_N*0.025)]+t[ceil(_N*0.025)])/2
local alpha_975=(t[floor(_N*0.975)]+t[ceil(_N*0.975)])/2
// 计算好分位数，返回
frame change default
rm bootstrap_student.dta
// 计算置信区间
di "置信区间为：" _skip "[" `b'-`alpha_975'*`se' "," `b'-`alpha_25'*`se' "]"
