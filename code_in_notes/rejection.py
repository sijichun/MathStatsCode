#!/usr/bin/python3
## file: rejection.py
import numpy as np
import numpy.random as nprd
import scipy.special as scisp
## 设定参数
c=3 #抽取大于5的正态分布样本
N=200 #抽取200个
## 直接使用正态分布进行拒绝抽样
times=0 #产生了多少次正态分布
accept=0 #接受了多少个
sample1=[] #结果
while accept<N:
    x=nprd.normal()
    if x>c:
        sample1.append(x)
        accept=accept+1
    times=times+1
print("接受率=",N/times)

## 使用指数分布进行拒绝抽样
times=0 #产生了多少次正态分布
accept=0 #接受了多少个
sample2=[] #结果
# 计算参数
lam=(c+np.sqrt(c**2+4))/2
M=np.exp((lam**2-2*lam*c)/2)/(np.sqrt(2*np.pi)*
    lam*(1-scisp.ndtr(c)))
normal_m=1/np.sqrt(2*np.pi) #正态分布密度函数前面的常数
while accept<N:
    ## 产生指数分布
    x=-1*np.log(nprd.uniform())/lam+c
    ## 接受概率
    r=normal_m*np.exp(-1*(x-c)**2/2)/(M*
        lam*np.exp(-1*lam*(x-c)))
    if nprd.uniform()<r:
        sample2.append(x)
        accept=accept+1
    times=times+1
print("接受率=",N/times)
print(sample1)
print(sample2)
