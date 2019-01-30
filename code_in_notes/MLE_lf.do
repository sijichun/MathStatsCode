** maximul likelihood
clear
set more off

set obs 1000

** generate data
gen z=rnormal()
gen u=rnormal()
gen x1=z+rnormal()+u
gen x2=z+0.5*rnormal()


gen y=x1+x2+u
reg y x1 x2
ivreg2 y (x1=z) x2

** control function
quietly: reg x1 z x2
predict x1r, residual
reg y x1 x2 x1r // 系数正确，标注误错误

** LIML
ivregress liml  y (x1=z) x2 // 最简单情况，与2SLS等价
** LIML by hand
cap program drop limlobj
program limlobj
	args lnfj theta1 theta2 theta3 theta4 theta5
	tempvar resid2 resid1
	tempname sigma1 sigma2
	quietly{
		gen `resid1'=.
		gen `resid2'=.
		replace `resid2'=$ML_y2 - `theta2'
		replace `resid1'=$ML_y1 - `theta1' - `theta3'*`resid2'
		su `resid1'
		scalar `sigma1'=r(sd)
		su `resid2'
		scalar `sigma2'=r(sd)
		replace `lnfj'=ln(normalden(`resid1',`sigma1'))+ln(normalden(`resid2',`sigma2'))
	}
end

***** liml by hand with derivatives
cap program drop limlobj_d
program limlobj_d
	args lnfj theta1 theta2 theta3 theta4 theta5
	tempvar resid2 resid1
	tempname sigma1 sigma2
	quietly{
		gen `resid1'=.
		gen `resid2'=.
		replace `resid2'=$ML_y2 - `theta2'
		replace `resid1'=$ML_y1 - `theta1' - `theta3'*`resid2'
		su `resid1'
		scalar `sigma1'=r(sd)
		su `resid2'
		scalar `sigma2'=r(sd)
		replace `lnfj'=ln(normalden(`resid1',`sigma1'))+ln(normalden(`resid2',`sigma2'))
	}
end

ml model lf limlobj (y = x1 x2) (x1 = x2 z) /rho
ml maximize

** with interaction term
gen x12=x1*x2
gen z12=z*x2
gen ynew=x1+x2+x12+u
ivreg2 ynew (x1 x12=z z12) x2

** control function
quietly: reg x1 z x2
predict x1rnew, residual
reg ynew x1 x2 x12 x1rnew

** liml by hand
ml model lf limlobj (ynew = x1 x2 x12) (x1 = x2 z) /rho
ml maximize
