// MCMC_independent_mh.do
// 独立的Metropolis-Hastings算法
clear all
set more off

mata:
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
end
