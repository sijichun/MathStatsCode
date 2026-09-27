// GMM_mini_chi2.do
clear all
set more off
set seed 20231213
cap program drop est_lambda_chi2
program est_lambda_chi2, rclass
	syntax varname [, lambda(real 1) lambda0(real 10) n(integer 100)]
	tempvar x2 m1_0 m2_0
	tempname mean_m1_0 mean_m2_0 vec_g chi2_est chi2_true wmatrix objf
	quietly{
		gen `x2'=`varlist'^2
		gmm (`varlist'-{lambda=`lambda'}) (`x2'-({lambda}+{lambda}^2)), winit(identity)
		local `chi2_est'=e(J)
		mat `wmatrix'=e(W)
		gen `m1_0'=`varlist'-`lambda0'
		gen `m2_0'=`x2'-(`lambda0'+`lambda0'^2)
		su `m1_0'
		local `mean_m1_0'=r(sum)
		su `m2_0'
		local `mean_m2_0'=r(sum)
		mat `vec_g'=(``mean_m1_0'' \ ``mean_m2_0'')
		mat `objf'=`vec_g''*`wmatrix'*`vec_g'
		local `chi2_true'=`objf'[1,1]/`n'
	}
	return scalar chi2_est = ``chi2_est''
	return scalar chi2_true = ``chi2_true''
end

frame create simulation chi2_est chi2_true
forvalues i=1/2000{
	quietly{
		clear
		set obs 100
		gen x=rpoisson(10)
		est_lambda_chi2 x, lambda0(10) n(100)
		frame post simulation (r(chi2_est)) (r(chi2_true))
	}
}
frame change simulation
label variable chi2_est "估计值处的目标函数"
label variable chi2_true "真值处的目标函数"
gen density_chi2_1=chi2den(1,chi2_est)
label variable density_chi2_1 "Chi(1)密度函数"
gen density_chi2_2=chi2den(2,chi2_est)
label variable density_chi2_2 "Chi(2)密度函数"
sort chi2_est
twoway  (hist chi2_est, density) (line density_chi2_1 chi2_est  if chi2_est>0.3) (line density_chi2_2 chi2_est  if chi2_est>0.3), legend(pos(1) ring(0) label(1 "估计值处的目标函数密度")) xtitle("")
graph export GMM_mini_chi2_1.pdf, replace
twoway  (hist chi2_true, density) (line density_chi2_1 chi2_est  if chi2_est>0.3) (line density_chi2_2 chi2_est  if chi2_est>0.3), legend(pos(1) ring(0) label(1 "真值处的目标函数密度")) xtitle("")
graph export GMM_mini_chi2_2.pdf, replace