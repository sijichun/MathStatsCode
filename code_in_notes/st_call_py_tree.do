clear
set more off
use datasets/soep_female_labor.dta

// 首先做logit回归做初步探索
logit employment chld6 chld16 age income husworkhour husemployment region edu husedu
predict ps_employment_logit
gen predict_employment_logit = ps_employment_logit>=0.5
gen accuracy_logit = employment == predict_employment_logit
su accuracy_logit

//放到Python中去做回归树
