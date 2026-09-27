// bootstrap_lognormal_np.do
clear all
set more off
set seed 1000
set obs 10
// 产生样本
local mu=2
gen z=rnormal(`mu',sqrt(2))
gen x=exp(z)
// 定义估计的program
cap drop program lognormalest
program define lognormalest, rclass
	syntax varname
	quietly {
		su `varlist'
		local mu=log(r(mean))-1
		return scalar mu=`mu'
	}
end
// bootstrap
local B=1000
bootstrap mu=r(mu), reps(`B'): lognormalest x
estat bootstrap 