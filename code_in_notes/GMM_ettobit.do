// GMM_ettobit.do
clear
set more off
set obs 500
set seed 8997
// 生成数据
gen x=rnormal(3,2)
local a=10
local alpha=5
local beta=3
local sigma=2
gen y = exp(`alpha'+`beta'*x+rnormal()*sqrt(`sigma'))-`a'
// 生成工具
gen x2=x^2
gen x3=x^3
gen x_e=exp(x)
gen x_sin=sin(x)
// 计算a的初始值
su y
local a_init=-1*r(min)+5
// GMM估计
gmm (log({a=`a_init'}+y)-{alpha=0}-{beta=0}*x) ((log({a}+y)-{alpha}-{beta}*x)*x) ((log({a}+y)-{alpha}-{beta}*x)*x2) ((log({a}+y)-{alpha}-{beta}*x)*x3) ((log({a}+y)-{alpha}-{beta}*x)*x_e) ((log({a}+y)-{alpha}-{beta}*x)*x_sin), winit(identity)

