// 2SLS by hand
cap program drop twosls
program twosls, eclass
	version 15.0
	syntax varlist(max=1), endo(varlist) instru(varlist) /*
		*/control(varlist)
	tempname dep Xhat XhhX pred_endo pred_var b sigma2 V
	tempvar resid
	local `dep' "`varlist'"
	quietly{
		// get the predicted value of endo x
		local `pred_var' ""
		foreach x of varlist `endo'{
			reg `x' `instru' `control'
			predict `pred_endo'_`x'
			local `pred_var' "``pred_var'' `pred_endo'_`x'"
		}
		local `Xhat' "``pred_var'' `control'"
		// ols of y on Xhat, get b
		reg ``dep'' ``Xhat''
		matrix `b'=e(b)
		mat colnames `b'= `endo' `control' _cons
		///// compute variance under homoskedasticity
		// first compute residuals
		gen `resid'=``dep''
		foreach x of varlist `endo' `control'{
			replace `resid'=`resid'-`b'[1,colnumb(`b',"`x'")]*`x'
		}
		replace `resid'=`resid'-`b'[1,colnumb(`b',"_cons")]
		su `resid'
		scalar `sigma2'=r(Var)
		// then compute XhhX
		matrix accum `XhhX'=``Xhat''
		matrix `V'=`sigma2'*invsym(`XhhX')
		mat colnames `V'= `endo' `control' _cons
		mat rownames `V'= `endo' `control' _cons
		drop ``pred_var''
	}
	ereturn clear
	ereturn post `b' `V'
	ereturn local depvar "``dep''"
	ereturn display
end
// test the program
clear
set more off
set obs 1000
// generate fake data
gen z=rnormal()
gen u=rnormal()
gen x1=z+rnormal()+u
gen x2=z+0.5*rnormal()
gen y=2+x1+x2+u
// compare it with ivregress commmand
ivregress 2sls y (x1=z) x2
twosls y, endo(x1) instru(z) control(x2)
