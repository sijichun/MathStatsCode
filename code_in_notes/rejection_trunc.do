// rejection_trunc.do
clear
set more off
set obs 1000
// 参数
scalar c=3
// 计算lambda和M
scalar pi=3.1415926
scalar temp_cons=sqrt(2*pi)*(1-normal(c))
// 最优lambda
scalar lam=(c+sqrt(c^2+4))/2
// 实验lambda
scalar lam=2.5
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
twoway (hist x if selected==1, ///
     color(gs13) fcolor(gs13) barwidth(0.02)) ///
     (line density_exp x) ///
     (line density x) ///
     (scatter u_y x if selected==0, msize(tiny)) ///
     (scatter u_y x if selected==1, msize(tiny)) ///
     , legend(on ring(0) pos(1) order(2 4 3 5 1) ///
     label(4 "Rejected") label(5 "Accepted") ///
     label(1 "Density of Accepted")) ///
     graphr(fcolor(white) color(white))
graph export rejection_trunc.eps, replace
