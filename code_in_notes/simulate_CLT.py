#!/usr/bin/python3
## file: simulate_CLT.py
import numpy as np
from numpy import random as nprd

def sampling(N):
    ## 产生一组样本，以0.5的概率为z+3，0.5的概率为z-3
    ## 其中z~N(0,1)
    d=nprd.rand(N)<0.5
    z=nprd.randn(N)
    x=[z[i]+3 if d[i] else z[i]-3 for i in range(N)]
    x=np.array(x)
    return x

N=[2,3,4,10,100,1000] # sample size
M=2000
MEANS=[]
for n in N:
    mean_x=np.zeros(M)
    for i in range(M):
        x=sampling(n)
        ## 标准化，因为var(x)=10
        mean_x[i]=np.mean(x)/np.sqrt(10/n)
    MEANS.append(mean_x)

## 导入matplotlib
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
# 设定图像大小
plt.rcParams['figure.figsize'] = (10.0, 8.0)

x=sampling(3000)
plt.xlabel('x')
plt.ylabel('Density')
plt.title('Histogram of Mixed Normal')
plt.hist(x,bins=30,normed=1) ## histgram
plt.savefig("simulate_CLT_mix.eps")

## 均值
ax1 = plt.subplot(2,3,1)
ax2 = plt.subplot(2,3,2)
ax3 = plt.subplot(2,3,3)
ax4 = plt.subplot(2,3,4)
ax5 = plt.subplot(2,3,5)
ax6 = plt.subplot(2,3,6)

## normal density
x=np.linspace(-3,3,100)
d=[1.0/np.sqrt(2*np.pi)*np.exp(-i**2/2) for i in x]

def plot_density(ax,data,N):
    ax.hist(data,bins=30,normed=1) ## histgram
    ax.plot(x,d)
    ax.set_title(r'Histogram of $\bar{x}$:N=%d' % N)

plot_density(ax1,MEANS[0],N[0])
plot_density(ax2,MEANS[1],N[1])
plot_density(ax3,MEANS[2],N[2])
plot_density(ax4,MEANS[3],N[3])
plot_density(ax5,MEANS[4],N[4])
plot_density(ax6,MEANS[5],N[5])
plt.savefig("simulate_CLT.eps")
