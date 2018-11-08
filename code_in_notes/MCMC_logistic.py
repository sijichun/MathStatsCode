#!/usr/bin/python3
## file: MonteCarlo.py

import numpy as np
from numpy import random as nprd

##设定参数
M =20000
#真值
beta_0=1
beta_1=1
beta_2=-1
#样本量
N=200
#Logistic函数
Logistic=lambda x: 1.0/(1+np.exp(-1*x))

##产生数据
def gen_logit(N):
    Data=[]
    for n in range(N):
        x1=nprd.normal()*1.414+1
        x2=nprd.chisquare(2)
        d_star=beta_0+beta_1*x1+beta_2*x2
        p_star=Logistic(d_star)
        d=(1 if nprd.uniform()<p_star else 0)
        Data.append((d,x1,x2))
    return Data

#计算接受率
def rho(beta_x,beta_y,Data):
    log_post_pai_x=(-1*beta_x[0]**2-beta_x[1]**2-beta_x[2]**2)/2
    log_post_pai_y=(-1*beta_y[0]**2-beta_y[1]**2-beta_y[2]**2)/2
    log_ratio=log_post_pai_y-log_post_pai_x
    for data in Data:
        w_b_x=beta_x[0]+data[1]*beta_x[1]+data[2]*beta_x[2]
        w_b_y=beta_y[0]+data[1]*beta_y[1]+data[2]*beta_y[2]
        F_b_x=Logistic(w_b_x)
        F_b_y=Logistic(w_b_y)
        log_post_pai_x=np.log((F_b_x if data[0]==1 else 1-F_b_x))
        log_post_pai_y=np.log((F_b_y if data[0]==1 else 1-F_b_y))
        log_ratio+=(log_post_pai_y-log_post_pai_x)
    return min(1,np.exp(log_ratio))

#随机游走
def q_sampler(beta):
    return [b+nprd.normal(0,0.1) for b in beta]

##独立的MCMC算法，输入：
##    N_samples  : 抽样次数
##      rho(x,y,Data)   : 计算接受率
##   q_sampler(x): 给定x，从q中抽样的函数
##      x0       : 初始值
##     data      : 数据
def MH_RW(N_samples, rho, q_sampler, x0, data):
    X=[]
    x=x0
    for i in range(N_samples):
        y=q_sampler(x)
        if nprd.uniform()<=rho(x,y,data):
            X.append(y)
            x=y
        else:
            X.append(x)
    return X

## 从后验抽样：
data=gen_logit(N)
beta_post=MH_RW(M, rho, q_sampler, [0,0,0], data)
beta0_post=[b[0] for b in beta_post]
sub_beta0=beta0_post[int(M*0.2):]
beta1_post=[b[1] for b in beta_post]
sub_beta1=beta1_post[int(M*0.2):]
beta2_post=[b[2] for b in beta_post]
sub_beta2=beta2_post[int(M*0.2):]
#后验均值
mean_beta0=np.mean(sub_beta0)
mean_beta1=np.mean(sub_beta1)
mean_beta2=np.mean(sub_beta2)
print("Mean beta0=",mean_beta0)
print("Mean beta1=",mean_beta1)
print("Mean beta2=",mean_beta2)
