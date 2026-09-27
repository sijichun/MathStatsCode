// simulation_lr_test.do
clear
set more off
set seed 42
// test statistic
cap program drop lr_test_stat
program define lr_test_stat, rclass
	syntax [,obs(integer 100) lambda(real 1)]
	clear
	tempvar x
	quietly{
		set obs `obs'
		gen `x'=rpoisson(`lambda')
		su `x'
		return scalar chi2_stat=2*`obs'*(log(r(mean))*r(mean)-r(mean)+1)
	}
end
// upper tail of chi2(1)
local cv=invchi2tail(1,0.05)
// simulation under H0
simulate chi2=r(chi2_stat),reps(5000): lr_test_stat
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lr_test0.pdf, replace
gen p_005=chi2>=`cv'
su p_005
// simulation under H1
clear
simulate chi2=r(chi2_stat),reps(5000): lr_test_stat, lambda(1.5)
gen density=chi2den(1,chi2) if chi2>0.1
sort chi2
twoway (hist chi2, density) (line density chi2), xline(`cv')
graph export simulation_lr_test1.pdf, replace
gen p_005=chi2>=`cv'
su p_005
