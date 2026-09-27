// dgp_mle_censor.ado 
// 数据生成过程
cap program drop dgp_mle_censor
program dgp_mle_censor
	syntax newvarlist(max=1) [, obs(integer 500) mu(real 3.2) sigma2(real 0.5)]
	quietly{
		clear
		set obs `obs'
		tempvar xstar x
		gen `xstar'=sqrt(`sigma2')*rnormal()+`mu'
		gen `x'= `xstar' if `xstar'<4 & `xstar'>3
		replace `x'=4 if `xstar'>=4
		replace `x'=3 if `xstar'<=3
		gen `varlist'=10^`x'
	}
end
