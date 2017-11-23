clear
set more off
cap program drop std_normal_mean
program define std_normal_mean, rclass
	version 12
	syntax [,obs(integer 10) mu(real 0) sigma(real 1)]
	drop _all
	set obs `obs'
	tempvar x
	gen `x'=`sigma'*(rnormal()+`mu')
	su `x'
	return scalar mean1=sqrt(`obs')*(r(mean)-`mu')/`sigma'
	return scalar mean2=sqrt(`obs')*(r(mean)-`mu')/r(sd)
end
local N=8
local df=`N'-1
simulate std_mean=r(mean1) sample_mean=r(mean2),/*
*/    reps(20000): std_normal_mean, obs(`N')

// standardised with sigma
sort std_mean
gen normal_den_std_mean=normalden(std_mean)
label variable normal_den_std_mean "Std Normal Density"
gen student_den_std_mean=tden(`df',std_mean)
label variable student_den_std_mean "t(`df') Density"
twoway (hist std_mean, density) ///
     (line normal_den_std_mean std_mean) ///
		 (line student_den_std_mean std_mean) ///
		 , graphr(fcolor(white) color(white))  xtitle("") ///
		 saving(standard_normal_mean_1, replace)

// standardised with std deviation
sort sample_mean
gen normal_den_std_mean2=normalden(sample_mean)
label variable normal_den_std_mean2 "Std Normal Density"
gen t_den_std_sample_mean=tden(`df',sample_mean)
label variable t_den_std_sample_mean "t(`df') Density"
twoway (hist sample_mean, density) ///
     (line normal_den_std_mean2 sample_mean) ///
		 (line t_den_std_sample_mean sample_mean) ///
		 , graphr(fcolor(white) color(white)) xtitle("") ///
		 saving(standard_normal_mean_2, replace)

graph combine standard_normal_mean_1.gph /*
  */  standard_normal_mean_2.gph, ///
      graphr(fcolor(white) color(white)) col(2)
graph export standard_normal_mean.eps, replace
