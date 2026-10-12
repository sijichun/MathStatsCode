// nlcom_exp_mean.do
clear all
// 产生与例中相同的模拟数据
set obs 1000
set seed 1900
// 生成数据
gen x = 1+rnormal()*sqrt(2)
// 使用回归计算均值
reg x
// delta method计算标准误
nlcom exp(_b[_cons])