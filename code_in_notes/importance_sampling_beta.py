#!/usr/bin/python3
## file: importance_sampling_beta.py
import numpy as np
import numpy.random as nprd
import scipy.special as scisp
# 设定参数
alpha=4
beta=2
# 计算密度函数最大值
x_star=(1-alpha)/(2-alpha-beta)
M=1/scisp.beta(alpha,beta)*x_star**(alpha-1)*x_star**(beta-1)
print(M)
# 随机抽两个均匀分布，一个为(0,1)，一个为(0,M)，抽300个
N=300
u1=nprd.random(N)
u2=nprd.random(N)*M
# 画图
import matplotlib.pyplot as plt
# 设定图像大小
plt.rcParams['figure.figsize'] = (10.0, 10.0)
# 横线和竖线
x=
# 标题
plt.xlabel('$u_1$')
plt.ylabel("$u_2$")
plt.title('Relationship of x and y')
plt.scatter(u1,u2,color='blue') ## 画出散点图
plt.savefig("importance_sampling_beta.eps")
