// CI_large_sample.do
clear
set seed 97
set more off
cap program drop CIz
program define CIz, rclass
	syntax [, obs(integer 100) mu(real 3) confident_level(real 0.95)]
	quietly{
		drop _all
		set obs `obs'
		tempvar d x 
		tempname lb ub alpha
		local `alpha'=1-`confident_level'
		gen `d'=runiform()<0.5
		gen `x'=`d'*(rnormal()+`mu')+(1-`d')*(rnormal()-`mu')
		su `x'
		local `lb'=r(mean)-invnormal(1-``alpha''/2)*r(sd)/sqrt(`obs')
		local `ub'=r(mean)+invnormal(1-``alpha''/2)*r(sd)/sqrt(`obs')
		return scalar lb=``lb''
		return scalar ub=``ub''
		return scalar include_true=(``lb''<=0 & ``ub''>=0)
	}
end

simulate it=r(include_true), reps(10000): CIz, obs(10)
su
simulate it=r(include_true), reps(10000): CIz, obs(100)
su
