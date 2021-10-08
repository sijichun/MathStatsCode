// statistic_mean.do
clear all
set seed 19880505
frame create means m
forvalues i=1/10000{
    clear
    set obs 100
    gen x=rnormal(1,2)
    qui: su x
    frame post means (r(mean))
}
frame change means
su m
hist m
graph export statistc_mean.pdf, replace
