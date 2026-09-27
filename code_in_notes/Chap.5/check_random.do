// check_random.do
set more off
clear
set obs 1000
// 行号是奇数还是偶数
gen variable_id=mod(_n,2)
gen group=ceil(_n/2)
// 产生序贯的随机数
gen x=runiform()
// 将奇数观测作为x1，偶数观测作为x0
reshape wide x, i(group) j(variable_id)
// 画散点图
scatter x1 x0 ,  graphr(fcolor(white) color(white))
// 保存图片
graph export check_random_stata.pdf, replace
