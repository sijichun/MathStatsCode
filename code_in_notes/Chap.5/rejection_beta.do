// rejection_beta.do
clear
set obs 10000
set seed 505
local alpha=4
local beta=2
// 求密度函数极值
local M=betaden(`alpha',`beta',(`alpha'-1)/(`alpha'+`beta'-2))
gen u=runiform()*`M'
gen x=runiform()
// 计算密度函数
gen density=betaden(`alpha',`beta',x)
// 抽样
keep if u<density
// 查看抽样的描述性统计
su x