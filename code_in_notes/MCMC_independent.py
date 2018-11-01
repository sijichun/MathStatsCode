#!/usr/bin/python3
## file: MonteCarlo.py

import numpy as np
from numpy import random as nprd

##设定参数
M =10000
pai_cons=90*np.sqrt(2)/(2*np.pi)
pai=lambda x: pai_cons*np.exp(-90*(x[0]-0.5)**2-45*(x[1]+0.1)**2)
domain=lambda x:(x[0]>=-1)*(x[1]>=-1)*(x[0]<=1)*(x[1]<=1)
q=lambda y: 1/(2*np.pi)*np.exp(-1*y[0]**2/2-y[1]**2/2)
h=lambda x: domain(x)
h2=lambda x: np.sin(x[0])**2+np.log(abs(1+x[1]))
#从均匀分布中采样
def sample_q():
    return (nprd.normal(),nprd.normal())


##独立的MCMC算法，输入：
##    N_samples  : 抽样次数
##      pai(x)   : 目标密度函数
##      q(y)     : 工具密度函数
##   q_sampler   : 给定x，从q中抽样的函数
##      x0       : 初始值
def MH_independent(N_samples, pai, q, q_sampler, x0):
    X=[]
    x=x0
    for i in range(N_samples):
        y=q_sampler()
        rho=min(1,pai(y)*q(x)/(pai(x)*q(y)))
        if nprd.uniform()<rho:
            X.append(y)
            x=y
        else:
            X.append(x)
    return X

## 计算积分
x=MH_independent(M, pai, q, sample_q, (0,0))
## 第一个积分
H=list(map(h,x))
## 取h后面80%的样本
subH=H[int(M*0.2):]
integral=np.pi/(90*np.sqrt(2))*np.mean(subH)
print("Intgral1=",integral)
## 第二个积分
H2=list(map(h2,x))
subH2=H2[int(M*0.2):]
integral2=np.pi/(90*np.sqrt(2))*np.mean(subH2)
print("Intgral2=",integral2)
