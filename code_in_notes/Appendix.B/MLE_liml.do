clear
set more off

// LIML by hand
cap program drop limlobj
program limlobj
	args todo b lnfj g1 g2 g3
	tempvar theta1 theta2 theta3 resid2 resid1
	tempname sigma1 sigma2
	mleval `theta1'=`b', eq(1)
	mleval `theta2'=`b', eq(2)
	mleval `theta3'=`b', eq(3)
	quietly{
		gen `resid1'=.
		gen `resid2'=.
		replace `resid2'=$ML_y2 - `theta2'
		replace `resid1'=$ML_y1 - `theta1' - `theta3'*`resid2'
		su `resid1'
		scalar `sigma1'=r(sd)
		su `resid2'
		scalar `sigma2'=r(sd)
		replace `lnfj'=-log(`sigma1')-log(`sigma2') /*
			*/-`resid1'^2/(`sigma1'^2*2) /*
			*/-`resid2'^2/(`sigma2'^2*2)
		if (`todo'==0) exit
		replace `g1'=1/(`sigma1'^2)*`resid1'
		replace `g2'=-1/(`sigma1'^2)*`resid1'*`theta3'/*
			*/+1/(`sigma2'^2)*`resid2'
		replace `g3'=1/(`sigma1'^2)*`resid1'*`resid2'	
	}
end

cap program drop liml
program liml, eclass
	version 15.0
	// endo: 内生变量，至多一个
	// instru: 工具变量，control：控制变量
	// endofunc: 内生变量的函数
	syntax varlist(max=1), endo(varlist max=1) /*
		*/ instru(varlist) control(varlist) [endofc(varlist)]
	tempname dep x z b0 b1 initb
	local `dep' "`varlist'"
	local `x' "`endo' `endofc' `control'"
	local `z' "`instru' `control'"
	ml model lf1 limlobj (Structual:``dep'' = ``x'') /*
		*/ (First_stage:`endo' = ``z'') /rho
	quietly{ //使用最小二乘估计作为初始值
		reg ``dep'' ``x''
		mat `b0'=e(b)
		reg `endo' ``z''
		mat `b1'=e(b)
		mat `initb'=(`b0', `b1', 0)
		ml init `initb', copy
	}
	ml maximize
end

set obs 1000
// generate data
gen z=rnormal()
gen u=rnormal()
gen x1=z+rnormal()+u
gen x2=z+0.5*rnormal()
gen y=x1+x2+u
// 官方LIML
ivregress liml  y (x1=z) x2 // 最简单情况，与2SLS等价
// 手写LIML
liml y, endo(x1) instru(z) control(x2)
