// bubble_chart.do
clear
use datasets/citydata.dta
keep if Year==2011
// 省份代码、判断东中西部
gen prov=floor(CityCode/10000)
gen east=inlist(prov,11,12,13,21,31,32,33,35,37,44,46)
gen middle=inlist(prov,14,22,23,34,36,41,43,42)
gen west=inlist(prov,15,45,50,51,52,53,54,61,62,63,64,65)
// 产生变量
gen log_gdp_per_capita=log(v84)-log(v86)
gen log_pop=log(v86)
gen log_waste_water=log(v266)
// 画图
twoway (scatter log_waste_water log_gdp_per_capita [fw=v86] if east, msize(tiny) mcolor(blue%30)) (scatter log_waste_water log_gdp_per_capita [fw=v86] if middle, msize(tiny) mcolor(green%30)) (scatter log_waste_water log_gdp_per_capita [fw=v86] if west, msize(tiny) mcolor(red%30)), legend(off) xtitle("对数人均GDP") ytitle("对数工业废水排放量")
graph export bubble_chart.pdf, replace
