// gencatutility.ado
// Chapter 2.6 in Happiness Quantified: a Satisfaction Calculus Approach, van Praag and Ferrer-i-Carbonell
cap program drop gencatutility
program define gencatutility
	version 16
	syntax varname, Gen(name) [Verbose]
	tempname level n_levels nl cum cum_nl sum_nl p_nl temp1 temp2 f last_f last_p u uu
	local `n_levels' = 0
	local `cum'=0
	local `cum_nl' ""
	local `sum_nl'=0
	local `p_nl' ""
	local `f' ""
	local `u' ""
	quietly{
		levelsof `varlist', local(`level')
		foreach l of local `level'{
			sum `varlist' if `varlist' == `l'
			local `nl' = r(N)
			local `cum'=``cum''+``nl''
			local `cum_nl' "``cum_nl'' ``cum''"
			local `n_levels'=``n_levels''+1
			local `sum_nl'=``sum_nl''+r(N)
		}
		foreach l of local `cum_nl'{
			local `nl'=`l'/``sum_nl''
			local `p_nl' "``p_nl'' ``nl''"
			local `temp1'=invnormal(``nl'')
			local `temp2'=normalden(``temp1'',0,1)
			if ``temp1''==.{
				local `temp2'=0
			}
			local `f' "``f'' ``temp2''"
		}
		forvalues i=1/``n_levels''{
			local `temp1': word `i' of ``f''
			local `temp2': word `i' of ``p_nl''
			if `i'==1{
				local `uu'=(0-``temp1'')/(``temp2'')
				local `u' "``u'' ``uu''"
				local `last_f'=``temp1''
				local `last_p'=``temp2''
			}
			else{
				local `uu'=(``last_f''-``temp1'')/(``temp2''-``last_p'')
				local `u' "``u'' ``uu''"
				local `last_f'=``temp1''
				local `last_p'=``temp2''
			}
		}
		gen `gen'=.
		if "`verbose'" == "verbose"{
			noisily: di "level --- utility"
		}
		forvalues i=1/``n_levels''{
			local `temp1': word `i' of ``level''
			local `temp2': word `i' of ``u''
			replace `gen'=``temp2'' if `varlist'==``temp1''
			if "`verbose'" == "verbose"{
				noisily: di "``temp1'' --- ``temp2''"
			}
		}
	}
end
