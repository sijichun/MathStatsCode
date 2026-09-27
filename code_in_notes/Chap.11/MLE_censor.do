// MLE_censor.do
clear
// 定义目标函数
cap program drop ml_censor_obj
program ml_censor_obj
	args lnfj theta1 theta2
	tempvar lnx
	quietly{
		gen `lnx'=log10($ML_y1)
		replace `lnfj'=lnnormalden((`lnx'-`theta1')/sqrt(`theta2'))-log(sqrt(`theta2')) if `lnx'>3 & `lnx'<4
		replace `lnfj'=lnnormal((3-`theta1')/sqrt(`theta2')) if `lnx'==3
		replace `lnfj'=log(1-normal((4-`theta1')/sqrt(`theta2'))) if `lnx'==4
	}
end
// 进行极大似然估计
cap program drop mle_censor
program mle_censor, eclass
	syntax varlist(max=1)
	quietly{
		ml model lf ml_censor_obj (mu: `varlist'=, freeparm) /sigma2
		ml search
		noisily: ml maximize
		mat b=e(b)
		mat V=e(V)
		ereturn post b V
	}
end

set seed 8855
dgp_mle_censor x, obs(500) mu(3.3) sigma2(1)
mle_censor x
