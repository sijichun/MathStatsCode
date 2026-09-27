// simulation_lm_test.do
clear
set more off
set seed 42
// test statistic
cap program drop lm_test_stat
program define lm_test_stat, rclass
	syntax [,obs(integer 100) lambda(real 10)]
	clear
	tempvar x x_10
	quietly{
		set obs `obs'
		gen `x'=rpoisson(`lambda')
		gen `x_10'=`x'-10
		su `x_10'
		return scalar chi2_stat=(r(sum))^2/(`obs'*10)
	}
end
// upper tail of chi2(1)
local cv=invchi2tail(1,0.05)
// simulation under H0
simulate chi2=r(chi2_stat),reps(5000): lm_test_stat
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lm_test0.pdf, replace
gen p_005=chi2>=`cv'
su p_005
// simulation under H1
clear
simulate chi2=r(chi2_stat),reps(5000): lm_test_stat, lambda(11.5)
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lm_test1.pdf, replace
gen p_005=chi2>=`cv'
su p_005
