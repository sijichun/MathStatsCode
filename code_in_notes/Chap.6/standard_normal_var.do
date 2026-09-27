// standard_normal_var.do
cap program drop std_normal_var
program define std_normal_var, rclass
	version 12
	syntax [,obs(integer 10) mu(real 0) sigma(real 1)]
	drop _all
	set obs `obs'
	tempvar x
	gen `x'=`sigma'*rnormal()+`mu'
	su `x'
	return scalar std_var=(`obs'-1)*r(Var)/(`sigma'^2)
end

simulate std_var=r(std_var), reps(20000): std_normal_var


sort std_var
gen chi2_den=chi2den(9,std_var)
label variable chi2_den "Chi2 Density"
twoway (hist std_var, density) (line chi2_den std_var), graphr(fcolor(white) color(white)) xtitle("")
graph export standard_normal_var.pdf, replace
