// rejection_trunc.do
clear
set more off
set seed 505
set obs 1000
// 参数
scalar c=3
// 计算lambda和M
scalar pi=3.1415926
scalar temp_cons=sqrt(2*pi)*(1-normal(c))
scalar lam=2.5 // scalar lam=(c+sqrt(c^2+4))/2
scalar M=(exp(lam^2/2-lam*c-log(lam)))/temp_cons
// 产生均匀分布和指数分布
gen x=c-log(runiform())/lam
gen u=runiform()
// 截断正态分布密度函数
gen density=normalden(x)/(1-normal(c))
label variable density "f(x)"
// 指数分布密度函数（用M标准化，即 M*g(x)）
gen density_exp=M*lam*exp(-1*lam*(x-c))
label variable density_exp "M*g(x)"
// 挑出使得u<l/(M*g)的x，
gen selected=u<=(density/density_exp)
// 画图
sort x
// 显示方便，散点图y轴用标准化的密度函数值乘以u
gen u_y=u*density_exp
twoway (line density_exp x, lpattern(dash)) ///
     (line density x, lc(black)) ///
     (scatter u_y x if selected==0, msize(small) msymbol(x) mc(gs8)) ///
     (scatter u_y x if selected==1, msize(small) msymbol(v) mc(gs10)) ///
     , legend(on ring(0) pos(1)  ///
     label(3 "Rejected") label(4 "Accepted") ///
     label(2 "Density of Accepted")) ///
     graphr(fcolor(white) color(white))
graph export rejection_trunc.pdf, replace
