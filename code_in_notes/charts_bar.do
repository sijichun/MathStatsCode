// charts_bar.do
use datasets/chfs_ind.dta, clear
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
graph bar, over(a2012, label(angle(15)))
graph export chart_bar1.pdf, replace
graph bar (count), over(a2012, label(angle(15)))
graph export chart_bar2.pdf, replace
graph hbar (mean) labor_inc, over(a2012)
graph export chart_bar3.pdf, replace
collapse (count) labor_inc (mean) mean_income = labor_inc (median) median_income = labor_inc, by(a2012)
gen edu_left=a2012-0.2
gen edu_right=a2012+0.2
twoway (bar mean_income edu_left, barw(0.2)) (bar median_income a2012, barw(0.2)) (bar labor_inc edu_right, yaxis(2) barw(0.2)), xlabel(1 "文盲" 2 "小学" 3 "初中" 4 "高中" 5 "中专/职高'" 6 "大专/高职" 7 "大学本科" 8 "硕士研究生" 9 "博士研究生", angle(20)) xtitle("文化程度") ytitle("金额", axis(1)) ytitle("人数", axis(2)) legend(pos(11) ring(0) label(1 "收入均值") label(2 "收入中位数") lab(3 "频数") row(3) symxsize(4))
graph export chart_bar4.pdf, replace
