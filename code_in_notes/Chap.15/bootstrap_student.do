// bootstrap_student.do
clear all
use ../datasets/chfs2017_hh.dta
drop if total_income<0
set seed 250211
// compute theta_hat
su total_income
local theta_hat = r(mean)
local theta_se = r(sd)/sqrt(r(N))
// bootstrap
bootstrap (sqrt(r(N))*(r(mean)-`theta_hat')/r(sd)), reps(1000): su total_income
matrix cip = e(ci_percentile)
local cv_l=cip["ll",1]
local cv_r=cip["ul",1]
di "Critical Values = [`cv_l'" _skip "`cv_r']"
// compute CI
local CIl = `theta_hat'-`cv_r'*`theta_se'
local CIu = `theta_hat'-`cv_l'*`theta_se'
di "CI = [`CIl'" _skip "`CIu']"