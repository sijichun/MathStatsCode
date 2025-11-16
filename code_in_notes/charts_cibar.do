// charts_cibar.do
use datasets/chfs_ind.dta, clear
label def sex 1 "男"
label def sex 2 "女", add
label values a2003 sex
label def education 1 "文盲"
label def education 2 "小学", add
label def education 3 "初中", add
label def education 4 "高中", add
label def education 5 "中专/职高", add
label def education 6 "大专/高职", add
label def education 7 "大学本科", add
label def education 8 "硕士研究生", add
label def education 9 "博士研究生", add
label values a2012 education
cibar labor_inc , over1( a2003 ) over2( a2012 ) bargap(5) barcol(gs10 gs5) graphopts(xlabel(,angle(20)))
graph export charts_cibar.pdf, replace