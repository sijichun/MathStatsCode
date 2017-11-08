cap program drop ginindex
program define ginindex, byable(onecall)
  version 15
  syntax varlist(max=1), gen(name)
quietly{
  if "`_byvars'"==""{
    tempvar class
    gen `class'=1
    local _byvars "`class'"
  }
  // 临时变量
  tempvar rank totalincome cum rat num rect B delta
  // 排序并产生排序变量
  sort `_byvars' `varlist'
  by `_byvars': gen `rank'=_n
  // 产生地区户数、总收入和累积收入及比例
  egen `num'=count(`varlist'), by(`_byvars')
  egen `totalincome'=total(`varlist'), by(`_byvars')
  gen `cum'=`varlist' if `rank'==1
  by `_byvars': replace `cum'=/*
          */  `cum'[_n-1]+`varlist'[_n] if `rank'>1
  gen `rat'=`cum'/`totalincome'
  // 计算每个个体的柱形面积
  by `_byvars': gen `rect'=`rat'/`num'
  // 调整小样本误差，即减去柱子最上面小三角的面积
  gen `delta'=`rat'/2 if `rank'==1
  by `_byvars': replace `delta'=/*
          */  `rat'[_n]-`rat'[_n-1] if `rank'>1
  replace `rect'=`rect'-`delta'/`num'/2
  //最终的指数
  egen `B'=total(`rect'), by(`_byvars')
  gen `gen'=1-2*`B'
}
end

use "cfps_family_econ.dta", clear
ginindex fincome1, gen(gini_all)
bysort provcd14: ginindex fincome1, gen(gini)
