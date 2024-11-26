// simulate_LLN.do
clear
set more off
set seed 8855
local M=5000
set obs `M'
gen u=runiform()
gen x=u>=0.5
gen x_bar=.
forvalues i=1/`M'{
	qui{
		su x if _n<=`i'
		replace x_bar = r(mean) if _n==`i'
	}
}
gen n=_n
line x_bar n, yline(0.5)
graph export simulate_LLN.pdf, replace
