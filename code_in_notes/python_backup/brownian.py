import numpy as np
import numpy.random as nprd

t=np.linspace(0.0,5.0,5000)
B1=np.zeros(len(t))
B2=np.zeros(len(t))
B3=np.zeros(len(t))
B4=np.zeros(len(t))
B5=np.zeros(len(t))
B6=np.zeros(len(t))
b1=b2=b3=b4=b5=b6=0
epsilon=np.sqrt(t[1]-t[0])
for tt in range(len(t)):
    B1[tt]=b1
    b1=b1+nprd.normal(0,epsilon)
    B2[tt]=b2
    b2=b2+nprd.normal(0,epsilon)
    B3[tt]=b3
    b3=b3+nprd.normal(0,epsilon)
    B4[tt]=b4
    b4=b4+nprd.normal(0,epsilon)
    B5[tt]=b5
    b5=b5+nprd.normal(0,epsilon)
    B6[tt]=b6
    b6=b6+nprd.normal(0,epsilon)

import matplotlib.pyplot as plt
# 设定图像大小
plt.rcParams['figure.figsize'] = (10.0, 10.0)
plt.figure(0)
plt.plot(t,B1,label=r'Brownian Motion1',color='blue')
plt.plot(t,B2,label=r'Brownian Motion2',color='red')
plt.plot(t,B3,label=r'Brownian Motion3',color='pink')
plt.plot(t,B4,label=r'Brownian Motion4',color='green')
plt.plot(t,B5,label=r'Brownian Motion5',color='orange')
plt.plot(t,B6,label=r'Brownian Motion6',color='yellow')
plt.legend(loc='upper left', frameon=True)
plt.savefig("brownian_motion.eps")

t=np.linspace(0.0,5.0,10000)
B1=np.zeros(len(t))
B2=np.zeros(len(t))
B3=np.zeros(len(t))
B4=np.zeros(len(t))
B5=np.zeros(len(t))
B6=np.zeros(len(t))
b1=b2=b3=b4=b5=b6=0
epsilon=np.sqrt(t[1]-t[0])
for tt in range(len(t)):
    B1[tt]=b1
    b1=b1+nprd.normal(0,epsilon)
    B2[tt]=b2
    b2=b2+nprd.normal(0,epsilon)
    B3[tt]=b3
    b3=b3+nprd.normal(0,epsilon)
    B4[tt]=b4
    b4=b4+nprd.normal(0,epsilon)
    B5[tt]=b5
    b5=b5+nprd.normal(0,epsilon)
    B6[tt]=b6
    b6=b6+nprd.normal(0,epsilon)

plt.figure(1)
plt.plot(B1,B2,label=r'Brownian Motion1',color='blue')
plt.plot(B3,B4,label=r'Brownian Motion2',color='red')
plt.plot(B5,B6,label=r'Brownian Motion3',color='green')
plt.legend(loc='upper left', frameon=True)
plt.savefig("brownian_motion_2d.eps")
