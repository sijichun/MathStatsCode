// importance_sampling.do
// 重要性抽样计算积分示例
clear all
set more off
set seed 8855

// 设定参数
local M = 10000
// 工具密度m(x)为独立的二元正态分布
local mu1 = 0.5
local mu2 = -0.1
local sigma1 = sqrt(1/180)
local sigma2 = sqrt(1/90)

// 从m(x)中抽样
set obs `M'
gen x1 = rnormal(`mu1', `sigma1')
gen x2 = rnormal(`mu2', `sigma2')

// 目标函数h1_star(x)=4*h1(x)
gen h1_star = 4*0.5*exp(-90*(x1-0.5)^2 - 45*(x2+0.1)^2)
// 原密度pai(x)=1/4*I(x\in[-1,1]^2)
gen pai = 1/4*(x1>=-1 & x1<=1 & x2>=-1 & x2<=1)
// 工具密度m(x)
gen m = 1/(2*_pi*`sigma1'*`sigma2') ///
	*exp(-(x1-`mu1')^2/(2*`sigma1'^2) - (x2-`mu2')^2/(2*`sigma2'^2))

// 计算积分
gen H = h1_star*pai/m
qui: su H
local integral = r(mean)
local se = r(sd)/sqrt(`M')
di "Integral = " `integral'
di "s.e. of Integral = " `se'
di "95% C.I.: " `integral'-1.96*`se' " ~ " `integral'+1.96*`se'
