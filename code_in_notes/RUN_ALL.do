clear
set more off
** 在 MathStatsCode/code_in_notes 目录下运行本文件
** 各章节代码已按 Chap.n / Appendix.B 分类到子文件夹
local root = c(pwd)

** Chap.3 多元随机变量
cd "`root'/Chap.3"
do gaussian_mixture.do

** Chap.5 随机数生成
cd "`root'/Chap.5"
do uniform.do
do check_random.do
do exponential.do
do rejection_trunc.do
do rejection_trunc_optimal.do

** Chap.6 统计学与统计量
cd "`root'/Chap.6"
do standard_normal_var.do
do standard_normal_mean.do
do statistic_mean.do

** Chap.7 描述性统计
cd "`root'/Chap.7"
do empirical_distribution.do
do histogram_kdensity.do
do charts_bar.do
do scatter_consump.do
do zipf_law.do
do bubble_chart.do
do box_plot.do

** Chap.8 大样本理论
cd "`root'/Chap.8"
do simulate_LLN.do
do simulate_CLT.do

** Chap.9 点估计和区间估计
cd "`root'/Chap.9"
do charts_cibar.do

** Chap.10 矩估计和广义矩估计
cd "`root'/Chap.10"
do GMM_mini_chi2.do

** Chap.11 极大似然估计
cd "`root'/Chap.11"
do dgp_mle_censor_simulate.do

** Chap.12 假设检验
cd "`root'/Chap.12"
do test_power_function.do

** Chap.13 假设检验的构造方法
cd "`root'/Chap.13"
do simulation_wald_test.do
do simulation_lm_test.do
do simulation_lm_ols_test.do
do simulation_lr_test.do

** Chap.14 常用检验
cd "`root'/Chap.14"
do qqplot_hs300.do

** Chap.15 Bootstrap方法
cd "`root'/Chap.15"
do bootstrap_lognormal.do

** Chap.16 贝叶斯方法
cd "`root'/Chap.16"
do bayes_lambda_gamma.do

cd "`root'"
