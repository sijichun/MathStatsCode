import numpy as np
from numpy import random as nprd

True_P = 0.5


def sampling(N):
    ## 产生Bernouli样本
    x = nprd.rand(N) < True_P
    return x


M = 10000  #模拟次数
xbar = np.zeros(M)
N = np.array([i + 1 for i in range(M)])
x = sampling(M)
for i in range(M):
    if i == 0:
        xbar[i] = x[i]
    else:
        xbar[i] = (x[i] + xbar[i - 1] * i) / (i + 1)

## 导入matplotlib
import matplotlib.pyplot as plt
# 设定图像大小
plt.rcParams['figure.figsize'] = (10.0, 8.0)

plt.plot(N, xbar, label=r'$\bar{x}$', color='pink')  ## xbar
xtrue = np.ones(M) * True_P
plt.plot(N, xtrue, label=r'$0.5$', color='black')  ## true xbar
plt.xlabel('N')
plt.ylabel(r'$\bar{x}$')
plt.legend(loc='upper right', frameon=True)
plt.savefig("simulate_LLN.pdf")
plt.show() 