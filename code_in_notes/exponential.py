#!/usr/bin/python3
## file: exponential.py

# 导入math包，使用math中的log()函数
import math
import random as rd
# 获取5个均匀分布随机数
x=[-1*math.log(rd.random()) for i in range(5)]
print(x)
# 导入numpy包，使用其中的log()函数
import numpy as np
import numpy.random as nprd
# 获取5个均匀分布随机数
x=-1*np.log(nprd.random(5))
print(x)
