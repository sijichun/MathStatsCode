// MLE_beta.do
clear
set seed 8855
// 目标函数 
cap program drop betaobj 
program betaobj 	
	args todo b lnfj g1 g2
	tempvar alpha beta lnx ln1x
	mleval `alpha'=`b', eq(1)
	mleval `beta'=`b', eq(2)
	quietly{
		gen `lnx'=log($ML_y1)
		gen `ln1x'=log(1-$ML_y1)
		replace `lnfj'=lngamma(`alpha'+`beta')-lngamma(`alpha')-lngamma(`beta')+(`alpha'-1)*`lnx'+(`beta'-1)*`ln1x'
		if (`todo'==0) exit  //如果不需要计算导数，退出
		replace `g1'=digamma(`alpha'+`beta')-digamma(`alpha')+`lnx'
		replace `g2'=digamma(`alpha'+`beta')-digamma(`beta')+`ln1x'
	} 
end 
set obs 1000 
gen x=rbeta(0.5,3)
ml model lf1 betaobj (alpha: x = , freeparm) /beta
ml search 
ml maximize
