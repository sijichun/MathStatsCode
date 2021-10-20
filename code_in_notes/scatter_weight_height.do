// scatter_weight_height.do
clear
use datasets/cfps_adult.dta
drop if qp101<0
drop if qp102<0
twoway (scatter qp102 qp101 if mod(_n,10)==0) (lfit qp102 qp101), legend(pos(11) ring(0) label(1 "体重") label(2 "拟合"))
graph export scatter_weight_height.pdf, replace
