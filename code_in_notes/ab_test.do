// ab_test.do
// 导入数据
clear
set more off
import delimited "datasets/ba_sales_data.csv"

// 加总用户交易量
collapse (sum) sale_price (max) test_option, by(user_id)

// 进行检验
ttest sale_price, by(test_option)
