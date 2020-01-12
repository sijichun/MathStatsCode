// t-test of two means comparison
use datasets/cfps_adult.dta, clear
gen log_income=log(1+p_income)
// 方差相同假设下的检验
ttest log_income, by(cfps_gender)
// 方差不相同假设下的检验
ttest log_income, by(cfps_gender) unequal
// 方差不相同的假设下比较
