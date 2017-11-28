#!/usr/bin/python3
## file: simulate_LLN.py
import numpy as np
import matplotlib.pyplot as plt 
True_P=0.5
def sampling(N):
    ## 产生Bernouli样本
    x=np.random.rand(N)<True_P
    return x
M=10000 #模拟次数
xbar=np.zeros(M)
N=np.array([i+1 for i in range(M)])
x=sampling(M)
for n in range(M):
    if n==0:
        xbar[n]=x[n]
    else:
        xbar[n]=(x[n]+xbar[n-1]*n)/(n+1)

## 画图
plt.rcParams['figure.figsize'] = (10.0, 8.0)
## xbar
plt.plot(N,xbar,label=r'$\bar{x}$',color='pink')
## true xbar
xtrue=np.ones(M)*True_P
plt.plot(N,xtrue,label=r'$0.5$',color='black')
plt.xlabel('N')
plt.ylabel(r'$\bar{x}$')
plt.legend(loc='upper right', frameon=True)
plt.savefig("simulate_LLN.eps")
