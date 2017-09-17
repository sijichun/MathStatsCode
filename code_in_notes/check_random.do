set more off
clear
set obs 1000
// 产生行号
gen id=_n-1
// 行号是奇数还是偶数
gen group=floor(id/2)
gen varibale_id=2*(id/2-floor(id/2))
drop id
// 产生序贯的随机数
gen x=runiform()
// 将奇数观测作为x1，偶数观测作为x0
reshape wide x, i(group) j(varibale_id)
// 画散点图
scatter x1 x0
// 保存图片
graph export check_random_stata.eps, replace
