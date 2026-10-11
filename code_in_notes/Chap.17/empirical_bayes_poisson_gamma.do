// empirical_bayes_poisson_gamma.do
clear all
// 产生与例中相同的模拟数据
set obs 100
set seed 15634145
gen lambda = rgamma(5,2)
gen x = rpoisson(lambda)
// 定义计算对数似然函数的程序
cap drop program eb_pg
program define eb_pg
	args todo b lnf
	tempvar la lb
	mleval `la' = `b', eq(1)
	mleval `lb' = `b', eq(2)
	mlsum `lnf' = lngamma(x+exp(`la')) - lngamma(exp(`la')) + x*(`lb') - (x+exp(`la'))*log(1+exp(`lb'))
end
// 极大似然估计
ml model d0 eb_pg (lalpha: x = ) (lbeta: x = )
ml maximize
// 计算a=αβ以及b=αβ^2
nlcom (a: exp([lalpha]_cons + [lbeta]_cons)) (b: exp([lalpha]_cons + 2*[lbeta]_cons))
// 预测每个个体的lambda
gen lambda_hat = (x+exp([lalpha]_cons))*exp([lbeta]_cons)/(1+exp([lbeta]_cons))

// 对OHIE数据做同样的分析
clear
import delimited "../datasets/OHIE_ED_visit.csv"
keep if !missing(num_visit_pre_cens_ed)
rename num_visit_pre_cens_ed x
ml model d0 eb_pg (lalpha: x = ) (lbeta: x = )
ml maximize
nlcom (a: exp([lalpha]_cons + [lbeta]_cons)) (b: exp([lalpha]_cons + 2*[lbeta]_cons))
// 预测每个个体的lambda
gen lambda_hat = (x+exp([lalpha]_cons))*exp([lbeta]_cons)/(1+exp([lbeta]_cons))
// 列出x=0到17对应的lambda预测值
bysort x: gen first = (_n==1)
list x lambda_hat if first & x<=17, noobs
