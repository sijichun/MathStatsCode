// bootstrap_lognormal.do
clear all
set more off
set seed 1000
set obs 10
// 产生样本
local mu=2
gen z=rnormal(`mu',sqrt(2))
gen x=exp(z)
// 进行估计
su x
local mu_hat=log(r(mean))-1
di `mu_hat'
// 进行再抽样，将再抽样结果放入到数据框bootstrap中
frame create bootstrap mu_star
local B=10000
forvalues i=1/`B'{
	quietly{
		gen z_star=rnormal(`mu_hat',sqrt(2))
		gen x_star=exp(z_star)
		su x_star
		local mu_star=log(r(mean))-1
		frame post bootstrap (`mu_star')
		drop z_star
		drop x_star
	}
}
frame bootstrap: hist mu_star
graph export bootstrap_lognormal.pdf, replace
frame bootstrap: su mu_star, de
local mu_star_bar=r(mean)
di "mu_bc=" _skip 2*`mu_hat'-`mu_star_bar'