// simulation_lm_ols_test.do
clear
set more off
set seed 42
// test statistic
cap program drop ols_lm_test_stat
program define ols_lm_test_stat, rclass
	syntax [,obs(integer 100) beta(real 0) alpha(real 1) sigma(real 1)]
	clear
	tempvar x y e xe
	quietly{
		set obs `obs'
		gen `x'=rnormal(0,2)
		gen `y'=`x'*`beta'+`alpha'+rnormal(0,`sigma')
		su `y'
		gen `e'=`y'-r(mean)
		gen `xe'=`x'*`e'
		sum `xe'
		return scalar chi2_stat=(r(sum)^2)/(`obs'*r(Var))
	}
end
// upper tail of chi2(1)
local cv=invchi2tail(1,0.05)
// simulation under H0
simulate chi2=r(chi2_stat),reps(5000): ols_lm_test_stat
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lm_ols_test0.pdf, replace
gen p_005=chi2>=`cv'
su p_005
// simulation under H1
clear
simulate chi2=r(chi2_stat),reps(5000): ols_lm_test_stat, beta(0.2)
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lm_ols_test1.pdf, replace
gen p_005=chi2>=`cv'
su p_005
