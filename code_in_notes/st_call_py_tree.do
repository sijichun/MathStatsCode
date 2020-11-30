clear
set more off
use datasets/soep_female_labor.dta

// 定义变量
local y "employment"
local controls "chld6 chld16 age income husworkhour husemployment region edu husedu"

// 首先做logit回归做初步探索
logit `y' `controls'
predict ps_employment_logit
gen predict_employment_logit = ps_employment_logit>=0.5
gen accuracy_logit = employment == predict_employment_logit

//放到Python中去做回归树
python
import numpy as np
import pandas as pd
from sfi import Data, Macro, Missing
def stata2numpy(varname):
    data=Data.get(varname)
    x=[d if not Missing.isMissing(d) else np.nan for d in data]
    return np.array(x)

y_var_name = Macro.getLocal("y")
x_var_name = Macro.getLocal("controls").split(" ")
y=stata2numpy(y_var_name)
X=pd.DataFrame()
for x in x_var_name:
    X[x]=stata2numpy(x)
print(X)
from sklearn import tree
dtree=tree.DecisionTreeClassifier(max_depth=10) ##设定最大深度
dtree.fit(X,y) ##训练
prob_df=dtree.predict_proba(X)[:,1]
pred_df=dtree.predict(X)

def array2stata(npname):
    return [n if np.isfinite(n) else Missing.getValue() for n in npname]

prob=array2stata(prob_df)
pred=array2stata(pred_df)
Data.addVarDouble("predict_employment_tree")
Data.addVarDouble("ps_employment_tree")
Data.store("predict_employment_tree",None,pred)
Data.store("ps_employment_tree",None,prob)
end

gen accuracy_tree = employment == predict_employment_tree
su accuracy_logit accuracy_tree