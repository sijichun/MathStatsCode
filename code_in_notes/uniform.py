#!/usr/bin/python3
## file: uniform.py

# 导入random包
import random as rd
# 设置seed
rd.seed(505)
# 获取5个均匀分布随机数
x=[rd.random() for i in range(5)]
print(x)
# 导入numpy中的random包
import numpy.random as nprd
# 设置seed
nprd.seed(505)
# 获取5个均匀分布随机数
x=nprd.random(5)
print(x)
