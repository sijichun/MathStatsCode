// overid_reg_sq.do
clear
set seed 250211
set obs 100
// DGP
gen x  = rnormal()*2
gen x2 = x^2
gen x3 = x^3
gen y  = 1+2*x+x2+rnormal()*2
// GMM est and test
gmm (y-{xb: x}-{alpha}), instruments(x x2 x3)
estat overid