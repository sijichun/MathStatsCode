// box_plot.do
use datasets/chfs_ind.dta, clear
// 生成对数变量
gen log_income=log10(labor_inc)
label variable log_income "对数收入"
// 箱线图
graph box log_income, noout
graph export box_plot.pdf, replace
// 加标签
label def sex 1 "男性"
label def sex 2 "女性", add
label values a2003 sex
graph hbox log_income, over(a2003)
graph export box_plot_by_sex.pdf, replace
