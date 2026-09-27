# 《数理统计》、《随机过程》课程代码

该项目中主要包含上海对外经贸大学司继春《数理统计》课程以及《随机过程》的相关代码，主要包括讲义中的示意性代码（Stata），以及在 Jupyter 中使用 Stata 的教学 Notebook 和 Python 语言的教学/作业参考 Notebook。

仓库结构：

```
MathStatsCode/
├── code_in_notes/    # 讲义中的 Stata 代码（按章节整理）
├── notebook/         # 在 Jupyter 中使用 Stata 的教学 Notebook（PyStata）
└── code_in_python/   # Python 教学/作业参考 Notebook
```

## 讲义中的 Stata 代码

讲义中的代码主要包含在以下地址中：[Code in Notes](https://github.com/sijichun/MathStatsCode/tree/master/code_in_notes)，按讲义章节整理为子文件夹（`Chap.n` 对应讲义第 n 章，另含 `Appendix.B`、`Chap.MCMC` 等），Stata 数据文件包含在以下地址中：[Datasets](https://github.com/sijichun/MathStatsCode/tree/master/code_in_notes/datasets)。

* 每个章节子文件夹中为讲义中展示的 `.do` 文件，运行后在同目录下生成讲义所使用的图形；
* [RUN_ALL.do](https://github.com/sijichun/MathStatsCode/blob/master/code_in_notes/RUN_ALL.do) 可依次运行全部章节的示例代码；
* 部分示例使用了 Stata 用户命令（如 `cibar` 等），首次运行前可用 `ssc install` 安装。

## Stata 教学 Notebook（PyStata）

[Notebook](https://github.com/sijichun/MathStatsCode/tree/master/notebook) 目录提供了与 `code_in_notes` 章节结构一一对应的 Jupyter Notebook：在 Jupyter 中通过 PyStata 直接运行讲义中的 Stata 代码，每个代码单元均配有详细讲解，适合课堂演示与自学。

* 环境安装与使用方法见：[PyStata.md](https://github.com/sijichun/MathStatsCode/blob/master/notebook/PyStata.md)；
* Notebook 中省略了 `graph export` 导出命令（导出保留在 `.do` 文件中），图形直接在 Notebook 中内联显示。

## Python Notebook

除 Stata 代码以外，本课程还提供一些 Python 的 Jupyter Notebook（位于 [code_in_python](https://github.com/sijichun/MathStatsCode/tree/master/code_in_python)），可以作为编程作业的参考：

### 《数理统计》代码

* [Numpy+Matplotlib+random 介绍](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/Numpy%2BMatplotlib%2Brandom.ipynb)
* [生成多元正态分布](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/Normal.ipynb)
* [大数定律与中心极限定律](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/LLN_CLT.ipynb)
* [矩估计、极大似然估计与区间估计](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/estimation.ipynb)
* [假设检验](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/Testing.ipynb)

### 《随机过程》代码

* [马尔可夫链](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/DiscreteMarkov.ipynb)
* [泊松过程](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/Poisson_Process.ipynb)
* [布朗运动](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/Brownian.ipynb)
* [蒙特卡洛](https://github.com/sijichun/MathStatsCode/blob/master/code_in_python/MonteCarlo.ipynb)
