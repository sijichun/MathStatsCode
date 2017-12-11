#!/usr/bin/python3
## file: CI_small_sample.py
import numpy as np
from numpy import random as nprd
from scipy import special as func

def sampling(mu, sigma2, N):
    x=nprd.normal(mu,np.sqrt(sigma2),N)
    return x

## true value
mu=10
sigma2=30
N=10 # sample size
sqrtn=np.sqrt(N)
## iteration times
M=1000
## confidence level
alpha=0.05
## results
included=np.zeros(M)
for i in range(M):
    x=sampling(mu,sigma2,10)
    xmean=np.mean(x)
    xstd=np.std(x)
    lower=xmean-func.stdtrit(N-1,1-alpha/2)*xstd/sqrtn
    upper=xmean+func.stdtrit(N-1,1-alpha/2)*xstd/sqrtn
    # 如果包含真值
    if mu>=lower and mu<=upper:
        included[i]=1
print("The prob. of included=",np.mean(included))
