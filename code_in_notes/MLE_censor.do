// MLE_censor.do
clear all
set more off
set seed 20221130
// 定义极大似然目标函数
cap program drop mle_obj_censor
program mle_obj_censor
	args lnfj theta1 theta2
	tempvar lnx
	quietly{
		gen `lnx'=log10($ML_y1)
		replace `lnfj'=lnnormalden((`lnx'-`theta1')/sqrt(`theta2'))-log(sqrt(`theta2')) if `lnx'>3 & `lnx'<4
		replace `lnfj'=lnnormal((3-`theta1')/sqrt(`theta2')) if `lnx'==3
		replace `lnfj'=log(1-normal((4-`theta1')/sqrt(`theta2'))) if `lnx'==4
	}
end
// 极大似然估计
cap program drop mle_censor
program mle_censor, eclass
	syntax varlist(max=1)
	quietly{
		ml model lf mle_obj_censor (mu: `varlist'=, freeparm) /sigma2
		ml search
		noisily: ml maximize
		mat b=e(b)
		mat V=e(V)
		ereturn post b V
	}
end
// 简单展示
dgp_mle_censor x, obs(800) mu(3.2) sigma2(0.5)
mle_censor x