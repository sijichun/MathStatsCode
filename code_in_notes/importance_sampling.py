#!/usr/bin/python3
## file: MonteCarlo.py

import numpy as np
from numpy import random as nprd

##设定参数
M =10000
h1=lambda x: 0.5*np.exp(-90*(x[0]-0.5)**2-45*(x[1]+0.1)**2)
domain=lambda x:(x[0]>=-1)*(x[1]>=-1)*(x[0]<=1)*(x[1]<=1)
pai=lambda x: 1/4*domain(x)
h=lambda x: 4*h1(x)
mu1=0.5
mu2=-0.1
sigma1=np.sqrt(1/180)
sigma2=np.sqrt(1/90)
m=lambda x: 1/(2*np.pi*sigma1*sigma2)* \
    np.exp(-1*(x[0]-mu1)**2/(2*sigma1**2)\
           -(x[1]-mu2)**2/(2*sigma2**2))

#从m(x)中采样
x=[(nprd.normal(mu1,sigma1),nprd.normal(mu2,sigma2))\
   for i in range(M)]

## 计算积分
H=list(map(lambda x:h(x)*pai(x)/m(x),x))
integral=np.mean(H)
se=np.std(H)/np.sqrt(M)
print("Intgral=",integral)
print("s.e. of Integral=",se)
print("95% C.I.:",integral-1.96*se,"~",integral+1.96*se)
