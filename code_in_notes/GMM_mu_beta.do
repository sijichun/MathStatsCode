// GMM_mu_beta.do
clear all
set more off
set seed 20231130
cap program drop est_mu_beta
program est_mu_beta, eclass
	syntax varlist(max=1) [, mu(real 0) beta(real 1)]
	tempvar x2
	quietly{
		gen `x2'=`varlist'^2
		gmm (`varlist'-{mu=`mu'}) (`x2'-({beta=`beta'}+{mu}^2)) ((`varlist'-{mu})^3) ((`varlist'-{mu})^4-6*{beta}^2), winit(identity) twostep
	}
	mat b=e(b)
	mat V=e(V)
	ereturn post b V
	ereturn display
end

frame create simulation gmm_mu mm_mu gmm_beta mm_beta 
forvalues i=1/1000{
	clear
	quietly{
		set obs 100
		gen v=rexponential(5)
		gen y=rnormal(0,1)*sqrt(v)+10
		su y
		local mean_y = r(mean)
		gen y2=y^2
		su y2
		local mean_y2 = r(mean)
		local mm_mu=`mean_y'
		local mm_beta=`mean_y2'-`mean_y'^2
		est_mu_beta y
		frame post simulation (_b[/mu]) (`mm_mu') (_b[/beta]) (`mm_beta')
	}
}
frame simulation: su
