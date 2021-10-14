// geometric_mean.do
use datasets/hs300index.dta, clear
// 按照时间排序，用行号作为新的时间
sort day
gen t=_n
tsset t
// 计算增长率
gen r=clsindex/L.clsindex
gen log_r=log(r)
su log_r
local geo_mean=exp(r(mean))
di "几何平均数=`geo_mean'"
di "第一天沪深300指数=" clsindex[1]
di "最后一天沪深300指数=" clsindex[_N]
di "使用几何平均数计算：" clsindex[1]*(`geo_mean'^(_N-1))
