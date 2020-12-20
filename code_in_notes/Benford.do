// Benford.do
clear all
use datasets/citydata.dta
keep if Year==2011

// 将GDP转为字符串
tostring v84, gen(gdp_string)
// 取出GDP数字字符串的第一位
gen first_digit=substr(gdp_string, 1,1)
// 将第一位数字字符串转化为数字
destring first_digit, replace
// 统计频数
tab first_digit
// 创建一个数据框用于检验
frame create chi2test Ng Ng_star
quietly: su first_digit
local N=r(N)
forvalues i=1/9{
	quietly: su first_digit if first_digit==`i'
	local Ng=r(N)
	local Ng_star=`N'*(log10(`i'+1)-log10(`i'))
	frame post chi2test (`Ng') (`Ng_star')
}
frame chi2test: gen test_stat=(Ng-Ng_star)^2/Ng_star
frame chi2test: su test_stat
frame chi2test: local test_stat=r(sum)
di "test statistics= `test_stat'"
local p=1-chi2(8 ,`test_stat')
di "p-value= `p'" 
