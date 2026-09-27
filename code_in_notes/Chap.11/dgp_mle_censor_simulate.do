// dgp_mle_censor_simulate.do
clear
set seed 8855
dgp_mle_censor x , obs(500) mu(3.3) sigma2(1)
hist x
graph export dgp_mle_censor_hist.pdf, replace
sort x
gen p=_n/_N
line p x, xline(1000 10000, lpattern(dot))
graph export dgp_mle_censor_cdf.pdf, replace
