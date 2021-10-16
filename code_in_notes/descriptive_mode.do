// descriptive_mode.do
use datasets/cfps_adult.dta, clear
drop if qp101<0
su qp101
local min_qp101=r(min)
local max_qp101=r(max)
local n_group=15
gen group=floor((qp101-`min_qp101')/(`max_qp101'-`min_qp101'+0.0001)*`n_group')
tab group
// 样本数最多的组为第9组
di "众数=" `min_qp101'+(9+0.5)/`n_group'*(`max_qp101'-`min_qp101'+0.0001)
