// file: exponential.do
set more off
clear
set obs 100
set seed 250211
// 产生随机数
gen x=-1*log(runiform())
