// test_power_function.do
clear
set more off

** test under H0: mu=mu0 at 5% significant level
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

** replicate test for 1000 times by default
cap program drop compute_power
program define compute_power, rclass
	version 12
	syntax [,obs(integer 10) mu(real 0) mu0(real 0)/*
		*/ sigma(real 1) reps(integer 1000)]
	quietly{
	preserve // 缓存内存中现有的变量
	drop _all
	simulate rejected=r(rejected),reps(`reps'):/*
		*/ test_normal_mean, obs(`obs') mu(`mu')/*
		*/ mu0(`mu0') sigma(`sigma')
	quietly: su rejected
	return scalar power=r(mean)
	restore // 恢复preserve之前内存变量
	}
end

** draw power function for sample size=[5 30 100]
set obs 100
gen mu=-3+(_n-1)*6/99
tempname mu
gen power5=.
gen power30=.
gen power100=.
foreach ss in 5 30 100{
    forvalues i= 1/100{
        ** mu in [-3,3]
        local `mu'=-3+(`i'-1)*6/99
	compute_power, mu(``mu'') obs(`ss')
	replace power`ss'=r(power) in `i'
    }
}
label variable mu "Ture value of mu"
label variable  power5 "Power 5 Samples"
label variable  power30 "Power 30 Samples"
label variable  power100 "Power 100 Samples"
twoway (line power5 mu, lpattern(solid))/*
	*/ (line power30 mu, lpattern(dash))/*
	*/ (line power100 mu, lpattern(dot))
graph export power_function.pdf, replace
