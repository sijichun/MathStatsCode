clear
set more off
cap program drop standard_normal_mean
program define standard_normal_mean, rclass
	version 12
	syntax [,obs(integer 10) mu(real 0) sigma(real 1)]
	drop _all
	set obs `obs'
	tempvar x
	gen `x'=`sigma'*(rnormal()+`mu')
	su `x'
	return scalar std_mean=sqrt(`obs')*(r(mean)-`mu')/`sigma'
	return scalar std_sample_mean=sqrt(`obs')*(r(mean)-`mu')/r(sd)
end
local N=8
local df=`N'-1
simulate std_mean=r(std_mean) std_sample_mean=r(std_sample_mean),/*
*/    reps(20000): standard_normal_mean, obs(`N')

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
sort std_sample_mean
gen normal_den_std_sample_mean=normalden(std_sample_mean)
label variable normal_den_std_sample_mean "Std Normal Density"
gen student_den_std_sample_mean=tden(`df',std_sample_mean)
label variable student_den_std_sample_mean "t(`df') Density"
twoway (hist std_sample_mean, density) ///
     (line normal_den_std_sample_mean std_sample_mean) ///
		 (line student_den_std_sample_mean std_sample_mean) ///
		 , graphr(fcolor(white) color(white)) xtitle("") ///
		 saving(standard_normal_mean_2, replace)

graph combine standard_normal_mean_1.gph standard_normal_mean_2.gph, ///
      graphr(fcolor(white) color(white)) col(2)
graph export standard_normal_mean.eps, replace
