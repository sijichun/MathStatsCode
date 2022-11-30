// MM_beta.do
clear all
set more off
set seed 20221130
cap program drop est_beta
program est_beta, eclass
	syntax varlist(max=1) [, alpha(real 1) beta(real 1)]
	tempvar x2
	quietly{
		gen `x2'=`varlist'^2
		gmm (`varlist'-({alpha=`alpha'}/({alpha}+{beta=`beta'}))) (`x2'-({alpha}*{beta}+{alpha}^2*({alpha}+{beta}+1))/(({alpha}+{beta})^2*({alpha}+{beta}+1))), winit(identity)
	}
	mat b=e(b)
	mat V=e(V)
	ereturn post b V
	ereturn display
end

frame create simulation alpha beta
forvalues i=1/1000{
	clear
	quietly{
		set obs 100
		gen x=rbeta(1.2,0.5)
		est_beta x
		frame post simulation (_b[/alpha]) (_b[/beta])
	}
}
frame simulation: su