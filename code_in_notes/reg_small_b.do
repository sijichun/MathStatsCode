** 设置样本容量与自由度
local sample_size=4
local d_of_f=`sample_size'-2
local replications=1000

cap program drop random_b_reg
program define random_b_reg, rclass
	version 12
	syntax [,obs(integer 4) random(real 0)]
	drop _all
	set obs `obs'
	tempvar x y u
	gen `x'=_n+(rnormal()^2-1)/sqrt(2)*`random'
	gen `u'=rnormal()
	gen `y'=`x'+`u'
	reg `y' `x'
	return scalar b=(_b[`x']-1)
	return scalar std_b=(_b[`x']-1)/_se[`x']
end

simulate b=r(b) std_b=r(std_b), reps(`replications'): random_b_reg, obs(`sample_size') random(1.5)

// dist. of b
quietly: su b
replace b=(b-r(mean))/r(sd)
sort b
gen b_empirical=_n/_N
gen dist_normal=normal(b)
label variable dist_normal "Normal Distribution"
twoway (line b_empirical b) ///
        (line dist_normal b) ///
        , graphr(fcolor(white) color(white))  xtitle("") ///
        saving(reg_small_b_random, replace)


// dist. of standarized b
sort std_b
gen std_b_empirical=_n/_N
gen t_den=t(`d_of_f',std_b)
label variable t_den "t(`d_of_f') Distribution"
twoway (line std_b_empirical std_b) ///
        (line t_den std_b) ///
        , graphr(fcolor(white) color(white))  xtitle("") ///
        saving(reg_small_stdb_random, replace)


simulate b=r(b) std_b=r(std_b), reps(`replications'): random_b_reg, obs(`sample_size') random(0)
// dist. of b
quietly: su b
replace b=(b-r(mean))/r(sd)
sort b
gen b_empirical=_n/_N
gen dist_normal=normal(b)
label variable dist_normal "Normal Distribution"
twoway (line b_empirical b) ///
        (line dist_normal b) ///
        , graphr(fcolor(white) color(white))  xtitle("") ///
        saving(reg_small_b_fixed, replace)


// dist. of standarized b
sort std_b
gen std_b_empirical=_n/_N
gen t_den=t(`d_of_f',std_b)
label variable t_den "t(`d_of_f') Distribution"
twoway (line std_b_empirical std_b) ///
        (line t_den std_b) ///
        , graphr(fcolor(white) color(white))  xtitle("") ///
        saving(reg_small_stdb_fixed, replace)


graph combine reg_small_b_random.gph reg_small_stdb_random.gph ///
        reg_small_b_fixed.gph reg_small_stdb_fixed.gph, ///
        graphr(fcolor(white) color(white)) col(2)
graph export reg_small.eps, replace
