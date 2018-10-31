#!/usr/bin/python3
## file: MonteCarlo.py

import numpy as np
from numpy import random as nprd

##设定参数
N=10000
h=lambda x: 0.5*np.exp(-90*(x[0]-0.5)**2-45*(x[1]+0.1)**2)

##抽样
x=[(nprd.random()*2-1,nprd.random()*2-1) for i in range(N)]

##计算h(x)
sample=list(map(h,x))
integral=4*np.mean(sample)
se=4*np.std(sample)/np.sqrt(N)
subsample_001=list(filter(lambda x: x>0.01, sample))
print("Intgral=",integral)
print("s.e. of Integral=",se)
print("95% C.I.:",integral-1.96*se,"~",integral+1.96*se)
print("Ratio of >0.01 samples:",len(subsample_001)/N)
