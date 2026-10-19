// weight_percentile.do
cap program drop weight_pctl
program weight_pctl, sortpreserve rclass
  version 15
  syntax varlist(max=1), weight(varname) p(numlist integer >0 <100 sort)
  tempvar cum_weight stand_weight sum_weight
  egen `sum_weight'=total(`weight') if `varlist'~=.
  gen `stand_weight'=`weight'/`sum_weight' if `varlist'~=.
  sort `varlist'
  gen `cum_weight'=`stand_weight' if _n==1
  replace `cum_weight'=`cum_weight'[_n-1]+`stand_weight'[_n] if _n>1
  tempname N i
  local `N'=_N
  local `i'=0
  foreach n of numlist `p'{
    while `++`i'' <= ``N''{
      if `cum_weight'[``i'']>=(`n'/100){
        return scalar p`n'=`varlist'[``i'']
        continue, break
      }
    }
  }
end

use "../datasets/chfs2017_hh.dta", clear
drop if a1111>=.
weight_pctl total_income, weight(a1111) p(25 33 50 67 75)
di r(p25) _skip r(p33) _skip r(p50) _skip r(p67) _skip r(p75)
su total_income [fweight=a1111], de