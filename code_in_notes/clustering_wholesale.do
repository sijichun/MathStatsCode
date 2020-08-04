// clustering.do
// 导入数据
clear
set more off
import delimited "datasets/wholesale.csv"

/* 进行聚类，使用层次聚类:
average linkage
angular（角度，余弦相似度）*/
cluster averagelinkage fresh milk grocery frozen detergents_paper delicassen, measure(angular)
// 画图
//cluster dendrogram, cutnumber(30)
// 分5类
cluster gen cluster1=groups(5)
// kmeans 聚类，使用层次聚类的结果作为初试类别
cluster kmeans fresh milk grocery frozen, /*
	*/k(5) measure(angular) start(group(cluster1))
rename _clus_2 cluster_kmeans
// 画图，比如fresh和grocery
twoway (scatter fresh grocery if cluster_kmeans==1)/*
	 */(scatter fresh grocery if cluster_kmeans==2)/*
	 */(scatter fresh grocery if cluster_kmeans==3)/*
	 */(scatter fresh grocery if cluster_kmeans==4)/*
	 */(scatter fresh grocery if cluster_kmeans==5), legend(off)
