// GMM_Poisson.do
clear all
set more off
set seed 20231130
cap program drop est_beta
program est_beta, eclass
	syntax varlist(max=1) [, alpha(real 1) beta(real 1)]
	tempvar x2
	quietly{
		gen `x2'=`varlist'^2
		gmm (`varlist'-{lambda=1}) (`x2'-({lambda}+{lambda}^2)), winit(identity) onestep
	}
	mat b=e(b)
	mat V=e(V)
	ereturn post b V
	ereturn display
end

frame create simulation lambda xmean
forvalues i=1/1000{
	clear
	quietly{
		set obs 100
		gen x=rpoisson(10)
		su x
		local mean_x = r(mean)
		est_beta x
		frame post simulation (_b[/lambda]) (`mean_x')
	}
}
frame simulation: su
