// CI_small_sample.do
clear
set seed 97
set more off
cap program drop CIt
program define CIt, rclass
	syntax [, obs(integer 10) mu(real 0) sigma(real 1) confident_level(real 0.95)]
	quietly{
		drop _all
		set obs `obs'
		tempvar x 
		tempname lb ub df alpha
		local `alpha'=1-`confident_level'
		local `df'=`obs'-1
		gen `x'=`sigma'*rnormal()+`mu'
		su `x'
		local `lb'=r(mean)-invttail(``df'',``alpha''/2)*r(sd)/sqrt(`obs')
		local `ub'=r(mean)+invttail(``df'',``alpha''/2)*r(sd)/sqrt(`obs')
		return scalar lb=``lb''
		return scalar ub=``ub''
		return scalar include_true=(``lb''<=`mu' & ``ub''>=`mu')
	}
end

simulate it=r(include_true), reps(10000): CIt, obs(10) mu(5) sigma(10)
su