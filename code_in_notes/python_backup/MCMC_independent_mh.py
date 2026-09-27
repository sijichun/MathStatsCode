## mcmc_independent_mh.py
##独立的MCMC算法，输入：
##    N_samples  : 抽样次数
##      pai(x)   : 目标密度函数
##      q(y)     : 工具密度函数
##   q_sampler   : 给定x，从q中抽样的函数
##      x0       : 初始值
from numpy import random as nprd
def MH_independent(N_samples, pai, q, q_sampler, x0):
    X = []
    x = x0
    for i in range(N_samples):
        y = q_sampler()
        rho = min(1, pai(y) * q(x) / (pai(x) * q(y)))
        if nprd.uniform() <= rho:
            X.append(y)
            x = y
        else:
            X.append(x)
    return X
