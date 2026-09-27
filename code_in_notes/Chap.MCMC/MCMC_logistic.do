// MCMC_logistic.do
// Logistic回归的Metropolis-Hastings算法示例
clear all
set more off
set seed 8855

// 设定参数
local M = 20000
// 真值
local beta_0 = 1
local beta_1 = 1
local beta_2 = -1
// 样本量
local N = 200

mata:
// Logistic函数
real matrix Logistic(real matrix x)
{
	return(1:/(1:+exp(-x)))
}

// 产生数据
real matrix gen_logit(real scalar N)
{
	real colvector x1, x2, d_star, p_star, d
	x1 = rnormal(N, 1, 0, 1)*1.414 :+ 1
	x2 = rchi2(N, 1, 2)
	d_star = `beta_0' :+ (`beta_1')*x1 :+ (`beta_2')*x2
	p_star = Logistic(d_star)
	d = runiform(N, 1) :< p_star
	return((d, x1, x2))
}

// 计算接受率
real scalar rho(real rowvector beta_x, real rowvector beta_y, real matrix Data)
{
	real scalar log_post_pai_x, log_post_pai_y, log_ratio, ll_x, ll_y
	real colvector d, F_b_x, F_b_y
	d = Data[., 1]
	// 先验（独立标准正态分布）的对数密度比
	log_post_pai_x = (-beta_x[1]^2-beta_x[2]^2-beta_x[3]^2)/2
	log_post_pai_y = (-beta_y[1]^2-beta_y[2]^2-beta_y[3]^2)/2
	log_ratio = log_post_pai_y - log_post_pai_x
	// 对数似然比
	F_b_x = Logistic(beta_x[1] :+ Data[., 2]:*beta_x[2] :+ Data[., 3]:*beta_x[3])
	F_b_y = Logistic(beta_y[1] :+ Data[., 2]:*beta_y[2] :+ Data[., 3]:*beta_y[3])
	ll_x = sum(d:*log(F_b_x) :+ (1:-d):*log(1:-F_b_x))
	ll_y = sum(d:*log(F_b_y) :+ (1:-d):*log(1:-F_b_y))
	log_ratio = log_ratio + ll_y - ll_x
	return(min((1, exp(log_ratio))))
}

// 随机游走的提议分布
real rowvector q_sampler(real rowvector beta)
{
	return(beta + rnormal(1, 3, 0, 0.1))
}

// 随机游走的MCMC算法，输入：
//    N_samples      : 抽样次数
//   rho(x,y,Data)   : 计算接受率
//   q_sampler(x)    : 给定x，从q中抽样的函数
//      x0           : 初始值
//      Data         : 数据
real matrix MH_RW(real scalar N_samples, pointer rho, pointer q_sampler,
                  real rowvector x0, real matrix Data)
{
	real matrix X
	real rowvector x, y
	real scalar i, u
	X = J(N_samples, length(x0), .)
	x = x0
	for (i=1; i<=N_samples; i++) {
		y = (*q_sampler)(x)
		u = runiform(1, 1)
		if (u <= (*rho)(x, y, Data)) {
			x = y
		}
		X[i, .] = x
	}
	return(X)
}

// 从后验分布中抽样
Data = gen_logit(`N')
beta_post = MH_RW(`M', &rho(), &q_sampler(), (0,0,0), Data)

// 去掉前20%的burn-in，计算后验均值
burn = floor(`M'*0.2)
sub_beta = beta_post[(burn+1)..`M', .]
mean_beta = mean(sub_beta)
printf("Mean beta0 = %f\n", mean_beta[1])
printf("Mean beta1 = %f\n", mean_beta[2])
printf("Mean beta2 = %f\n", mean_beta[3])
end
