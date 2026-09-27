// MCMC_random_walk.do
// 随机游走的Metropolis-Hastings算法示例
clear all
set more off
set seed 8855

// 设定参数
local M = 10000

mata:
// 目标密度（未归一化）
real scalar pai(real rowvector x)
{
	return(exp(-90*(x[1]-0.5)^2 - 45*(x[2]+0.1)^2))
}

// 被积函数：定义域指示函数
real scalar h(real rowvector x)
{
	return(x[1]>=-1 && x[1]<=1 && x[2]>=-1 && x[2]<=1)
}

// 另一个被积函数
real scalar h2(real rowvector x)
{
	return(sin(10*x[1])^2 + log(abs(1+x[2]*10)))
}

// 随机游走的提议分布：给定x，从q(y|x)中抽样
real rowvector sample_q(real rowvector x)
{
	return(x + 0.2*rnormal(1, 2, 0, 1))
}

// 随机游走的MCMC算法，输入：
//    N_samples   : 抽样次数
//      pai(x)    : 目标密度函数
//   q_sampler(x) : 给定x，从q中抽样的函数
//      x0        : 初始值
real matrix MH_RW(real scalar N_samples, pointer pai, pointer q_sampler,
                  real rowvector x0)
{
	real matrix X
	real rowvector x, y
	real scalar i, rho, u
	X = J(N_samples, length(x0), .)
	x = x0
	for (i=1; i<=N_samples; i++) {
		y = (*q_sampler)(x)
		rho = min((1, (*pai)(y)/(*pai)(x)))
		u = runiform(1, 1)
		if (u < rho) {
			x = y
		}
		X[i, .] = x
	}
	return(X)
}

// 使用随机游走的Metropolis-Hastings算法从pai(x)中抽样
X = MH_RW(`M', &pai(), &sample_q(), (0,0))

// 计算两个被积函数在每条链上的取值
H = J(`M', 1, .)
H2 = J(`M', 1, .)
for (i=1; i<=`M'; i++) {
	H[i] = h(X[i, .])
	H2[i] = h2(X[i, .])
}

// 计算积分：去掉前20%的burn-in，取后面80%的样本
burn = floor(`M'*0.2)
// 第一个积分
integral = pi()/(90*sqrt(2))*mean(H[(burn+1)..`M'])
printf("Integral1 = %f\n", integral)
// 第二个积分
integral2 = pi()/(90*sqrt(2))*mean(H2[(burn+1)..`M'])
printf("Integral2 = %f\n", integral2)
end
