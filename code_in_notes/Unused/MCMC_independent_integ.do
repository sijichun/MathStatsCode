// MCMC_independent_integ.do
// 独立的Metropolis-Hastings算法计算积分示例
clear all
set more off
set seed 19880505

// 设定参数
local M = 10000

mata:
// 目标密度：二元正态分布，mu=(0.5,-0.1)，方差分别为1/180和1/90
real scalar pai(real rowvector x)
{
	real scalar s1, s2
	s1 = 1/180
	s2 = 1/90
	return(1/(2*pi()*sqrt(s1)*sqrt(s2))*exp(-(x[1]-0.5)^2/(2*s1) - (x[2]+0.1)^2/(2*s2)))
}

// 被积函数：定义域指示函数
real scalar h(real rowvector x)
{
	return(x[1]>=-1 && x[1]<=1 && x[2]>=-1 && x[2]<=1)
}

// 工具密度：标准二元正态分布
real scalar q(real rowvector x)
{
	return(1/(2*pi())*exp(-(x[1]^2+x[2]^2)/2))
}

// 从工具分布中抽样
real rowvector q_sampler()
{
	return(rnormal(1, 2, 0, 1))
}

// 独立的MCMC算法，输入：
//    N_samples  : 抽样次数
//      pai(x)   : 目标密度函数
//      q(y)     : 工具密度函数
//   q_sampler   : 从q中抽样的函数
//      x0       : 初始值
real matrix MH_independent(real scalar N_samples, pointer pai, pointer q,
                           pointer q_sampler, real rowvector x0)
{
	real matrix X
	real rowvector x, y
	real scalar i, rho, u
	X = J(N_samples, length(x0), .)
	x = x0
	for (i=1; i<=N_samples; i++) {
		y = (*q_sampler)()
		rho = min((1, (*pai)(y)*(*q)(x)/((*pai)(x)*(*q)(y))))
		u = runiform(1, 1)
		if (u <= rho) {
			x = y
		}
		X[i, .] = x
	}
	return(X)
}

// 使用独立的Metropolis-Hastings算法从pai(x)中抽样
X = MH_independent(`M', &pai(), &q(), &q_sampler(), (0,0))

// 计算积分：I = pi/(90*sqrt(2)) * E_pi[h(x)]
H = J(`M', 1, .)
for (i=1; i<=`M'; i++) {
	H[i] = h(X[i, .])
}
integral = pi()/(90*sqrt(2))*mean(H)
printf("Integral = %f\n", integral)
end
