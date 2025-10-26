// descriptive_income_and_log.do
use datasets/chfs_ind.dta, clear
hist labor_inc, name(income_nolog) bin(100)
gen log_income = log10(labor_inc)
hist log_income, name(income_log) bin(100)
graph combine income_nolog income_log
graph export descriptive_income_and_log.pdf, replace
su log_income