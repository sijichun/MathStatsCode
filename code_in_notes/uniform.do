// file: uniform.do
// 关闭--more--
set more off
// 清除工作区内所有数据
clear
// 设置样本量
set obs 100
// 设置seed
set seed 505
// 产生随机数
gen x=runiform()
