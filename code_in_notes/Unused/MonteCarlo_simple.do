// MonteCarlo_simple.do
// 简单的Monte Carlo方法示例
clear all
set more off
set seed 8855

// 设定参数
local M = 10000

// 抽样：从[-1,1]x[-1,1]的均匀分布中抽样
set obs `M'
gen x1 = runiform()*2-1
gen x2 = runiform()*2-1

// 计算h(x)
gen h = 0.5*exp(-90*(x1-0.5)^2 - 45*(x2+0.1)^2)
qui: su h
local integral = 4*r(mean)
local se = 4*r(sd)/sqrt(`M')
di "Integral = " `integral'
di "s.e. of Integral = " `se'
di "95% C.I.: " `integral'-1.96*`se' " ~ " `integral'+1.96*`se'
qui: count if h>0.01
di "Ratio of >0.01 samples: " r(N)/`M'
