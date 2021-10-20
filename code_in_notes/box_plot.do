// box_plot.do
clear
use datasets/cfps_adult.dta
drop if qp101<0
graph box qp101, noout
graph export box_plot.pdf, replace
graph hbox qp101, over(cfps_gender)
graph export box_plot_by_sex.pdf, replace
