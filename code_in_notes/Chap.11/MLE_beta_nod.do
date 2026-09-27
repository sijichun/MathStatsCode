// MLE_beta_nod.do
clear
set seed 8855
// 目标函数 
cap program drop betaobj 
program betaobj 	
	args lnfj theta1 theta2
	quietly{ 		
		replace `lnfj'=log(betaden(`theta1',`theta2',x))
	} 
end 
// 产生Beta分布数据
set obs 1000 
gen x=rbeta(0.5,3)
// 定义极大似然问题 
ml model lf betaobj /alpha /beta 
// 寻找初始点（可选）
ml search 
// 最大化 并得到结果
ml maximize
