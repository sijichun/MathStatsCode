// descriptive_mode.do
use datasets/chfs_hh.dta, clear
su total_consump
local min_total_consump=r(min)
local max_total_consump=r(max)
local n_group=100
gen group=floor((total_consump-`min_total_consump')/(`max_total_consump'-`min_total_consump'+0.0001)*`n_group')
tab group
// 样本数最多的组为第2组
di "众数=" `min_total_consump'+(2+0.5)/`n_group'*(`max_total_consump'-`min_total_consump'+0.0001)
su total_consump, de