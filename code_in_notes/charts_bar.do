// charts_bar.do
use datasets/cfps_adult.dta, clear
drop if te4<0
graph bar, over(te4, label(angle(15)))
graph export chart_bar1.pdf, replace
graph bar (count), over(te4, label(angle(15)))
graph export chart_bar2.pdf, replace
graph hbar (mean) p_income, over(te4)
graph export chart_bar3.pdf, replace
collapse (count) p_income (mean) mean_income = p_income (median) median_income = p_income, by(te4)
gen te4_left=te4-0.2
gen te4_right=te4+0.2
twoway (bar mean_income te4_left, barw(0.2)) (bar median_income te4, barw(0.2)) (bar p_income te4_right, yaxis(2) barw(0.2)), xlabel(1 "文盲" 2 "小学" 3 "初中" 4 "高中" 5 "大专'" 6 "本科" 7 "研究生") ytitle("金额", axis(1)) ytitle("人数", axis(2)) legend(pos(11) ring(0) label(1 "收入均值") label(2 "收入中位数") lab(3 "人数"))
graph export chart_bar4.pdf, replace
