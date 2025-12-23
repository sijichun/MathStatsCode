// bayes_lambda_gamma.do
clear all
// generate data, P(10)
set obs 100
set seed 15634145
gen lambda = rgamma(5,2)
gen x = rpoisson(lambda)
sum x
local sum_x = r(sum)
local N = _N
// compute posterior
frame create posterior a b alpha beta posterior
forvalues a=5(0.03)15{
	forvalues b=1(0.05)40{
		local alpha = `a'^2/`b'
		local beta = `b'/`a'
		gen log_gamma_alpha_p_x = lngamma(`alpha'+x)
		qui: su log_gamma_alpha_p_x
		local log_gamma_alpha_p_x = r(sum)
		drop log_gamma_alpha_p_x
		local posterior = `sum_x'*log(`beta')+`log_gamma_alpha_p_x'-`N'*lngamma(`alpha')-(`alpha'*`N'+`sum_x')*log(1+`beta')
		frame post posterior (`a') (`b') (`alpha') (`beta') (`posterior')
		di "." _continue
	}
}
gen scatter_label="(10.49, 25.2)" if _n==143408
frame posterior: twoway (contourline posterior b a, levels(15)) (scatter b a if _n==143408, mlabel(scatter_label))
graph export bayes_lambda_gamma.pdf, replace