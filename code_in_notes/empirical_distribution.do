// empirical_distribution.do
clear
use datasets/cfps_adult.dta
drop if qp101<0
// 排序
sort qp101
// 生成排序序号
// 注意qp101中有缺失值，这里不删除缺失值，但是在计算时将其排除
gen notmissing_qp101=qp101~=.
qui: su notmissing_qp101
gen rank_qp101=_n/r(sum)
// 画图
qui: su qp101, de
local median_qp101=r(p50)
line rank_qp101 qp101, xline(`median_qp101')
graph export empirical_distribution.pdf, replace
