#!/usr/bin/python3
## file: rejection.py
import numpy as np
import numpy.random as nprd
import scipy.special as scisp
## 设定参数
c=3 #抽取大于5的正态分布样本
N=1000 #抽取200个
## 直接使用正态分布进行拒绝抽样
times=0 #产生了多少次正态分布
accept=0 #接受了多少个
sample1=[] #结果
while accept<N:
    x=nprd.normal()
    if x>=c:
        sample1.append(x)
        accept=accept+1
    times=times+1
print("接受率=",N/times)

## 使用指数分布进行拒绝抽样
times=0 #产生了多少次指数分布
accept=0 #接受了多少个
sample2=[] #结果
# 计算参数
lam=(c+np.sqrt(c**2+4))/2
M=np.exp((lam**2-2*lam*c)/2)/(np.sqrt(2*np.pi)* \
    lam*(1-scisp.ndtr(c)))
normal_m=1/np.sqrt(2*np.pi) #正态分布密度函数前面的常数
# 截断正态分布密度函数
f_trunc_normal = lambda x: \
    normal_m*np.exp(-0.5*x**2)/(1-scisp.ndtr(c))
# 指数分布密度函数
f_exponential = lambda x: lam*np.exp(-1*lam*(x-c))
while accept<N:
    ## 产生指数分布
    x=c-np.log(nprd.uniform())/lam
    ## 接受概率
    r=f_trunc_normal(x)/(M*f_exponential(x))
    if nprd.uniform()<=r:
        sample2.append(x)
        accept=accept+1
    times=times+1
print("接受率=",N/times)
