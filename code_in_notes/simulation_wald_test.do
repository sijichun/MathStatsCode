// simulation_wald_test.do
clear
set more off
set seed 880505
// test statistic
cap program drop wald_test_stat
program define wald_test_stat, rclass
	syntax [,obs(integer 30) mu(real -1) sigma2(real 1)]
	clear
	tempvar x
	quietly{
		set obs `obs'
		gen `x'=rnormal(`mu',sqrt(`sigma2'))
		su `x'
		return scalar chi2_stat=`obs'*(r(mean)^2-1)^2/(4*r(mean)^2*r(Var))
	}
end
// simulation under H0
simulate chi2=r(chi2_stat),reps(5000): wald_test_stat
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2)
graph export simulation_wald_test0.pdf, replace
// simulation under H1
clear
simulate chi2=r(chi2_stat),reps(5000): wald_test_stat, mu(2)
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2)
graph export simulation_wald_test1.pdf, replace
