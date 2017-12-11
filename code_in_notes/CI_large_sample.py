#!/usr/bin/python3
## file: CI_large_sample.py
import numpy as np
from numpy import random as nprd
from scipy import special as func

def sampling(N):
    ## 产生一组样本，以0.5的概率为z+3，0.5的概率为z-3，
    #其中z~N(0,1)，因而期望为0，方差为10
    d=nprd.rand(N)<0.5
    z=nprd.randn(N)
    x=[z[i]+3 if d[i] else z[i]-3 for i in range(N)]
    x=np.array(x)
    return x

## true value
N=[10,50,100,500,1000] # sample size
## iteration times
M=1000
## confidence level
alpha=0.05
for n in N:
    ## results
    included=np.zeros(M)
    for i in range(M):
        x=sampling(n)
        xmean=np.mean(x)
        xstd=np.std(x)
        lower=xmean-1.96*xstd/np.sqrt(n)
        upper=xmean+1.96*xstd/np.sqrt(n)
        # 如果包含真值
        #print(mu, lower, upper, mu>=lower, mu<=upper)
        if 0>=lower and 0<=upper:
            included[i]=1
    print("Sample size=%s, the prob. of included=" % n,\
     np.mean(included))
