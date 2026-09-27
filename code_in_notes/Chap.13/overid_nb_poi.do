// overid_nb_poi.do
clear
set seed 250211
set obs 100
gen x  = rnbinomial(5,0.2) // 期望为5×0.8/0.2=20
gen x2 = x^2
gmm (x-{lambda=1}) (x2-({lambda}+{lambda}^2)), winit(identity) igmm
estat overid 
replace x  = rpoisson(20)
replace x2 = x^2
gmm (x-{lambda=1}) (x2-({lambda}+{lambda}^2)), winit(identity) igmm
estat overid 