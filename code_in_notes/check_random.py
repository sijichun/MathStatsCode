#!/usr/bin/python3
## file: check_random.py
import numpy as np
import numpy.random as nprd
# 获取序贯的1000个均匀分布随机数
x=nprd.random(1000)
# 将1000个均匀分布随机数按照奇偶数分成两个序列x0 和x1
x0=np.array([x[i] for i in range(1000) if i%2==0])
x1=np.array([x[i] for i in range(1000) if i%2==1])
# 画图
import matplotlib.pyplot as plt
# 设定图像大小
plt.rcParams['figure.figsize'] = (8.0, 5.0)
plt.scatter(x0,x1,color='blue') ## 画出散点图
plt.savefig("check_random_py.eps")
