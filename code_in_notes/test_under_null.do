clear
set more off

// test under H0: mu=mu0 at 5% significant level
cap program drop test_normal_mean
program define test_normal_mean, rclass
	version 12
	syntax [,obs(integer 10) mu(real 0) mu0(real 0) sigma(real 1)]
	drop _all
	set obs `obs'
	tempvar x
	gen `x'=`sigma'*rnormal()+`mu'
	quietly: su `x'
	tempname std_mean rejected
	scalar `std_mean'=sqrt(`obs')*(r(mean)-`mu0')/r(sd)
	di `std_mean'
	if abs(`std_mean')>invt(`obs'-1,1-0.05/2){
		scalar `rejected'=1
	}
	else{
		scalar `rejected'=0
	}
	return scalar rejected=`rejected'
end

simulate rejected=r(rejected),reps(10000): test_normal_mean
su rejected
