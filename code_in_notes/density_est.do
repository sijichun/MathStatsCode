// density_est.do
clear
set more off

// define histogram
cap program drop densest
program define densest
  version 15
  syntax varlist(max=1), interval(real) gen(name)
  tempvar in_interval
  tempname N i
quietly{
  gen `gen'=.
  su `varlist'
  local `N'=r(N)
  forvalues `i'=1/``N''{
    if `varlist'[``i'']~=. {
      gen `in_interval'=/*
        */ ( `varlist'<=(`varlist'[``i'']+`interval')/*
        */ & `varlist'>=(`varlist'[``i'']-`interval'))
      su `in_interval'
      replace `gen'=r(mean) if _n==``i''
      drop `in_interval'
    }
  }
}
end

set obs 1000
gen x=rnormal()
densest x, interval(0.55) gen(d)
sort x 
twoway (hist x, den) (line d x)
