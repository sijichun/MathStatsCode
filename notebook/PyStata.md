# 在 Jupyter 中使用 Stata（PyStata / stata_setup 使用说明）

本目录（`MathStatsCode/notebook/`）下的教学 notebook 通过 **PyStata** 在 Jupyter 中直接调用 Stata，
以便把 Stata 代码、输出与图形和讲解文字放在同一个 notebook 中，方便课堂演示。

本文说明 `stata_setup` 的安装、配置与常用方法。

---

## 1. 环境要求

- **Stata 17 或更高版本**（本机为 Stata 18.0 MP，安装路径为 `/opt/Stata`）；
- **Python 3.7+**（本机使用 Anaconda，Python 3.11；Jupyter 内核选择 `anaconda`）；
- Python 包 **`stata_setup`**（见下一节安装）。

## 2. 安装 stata_setup

在命令行（或 Anaconda Prompt）中执行：

```bash
pip install --upgrade stata_setup
```

> 备选方式：也可以直接使用 Stata 安装目录中自带的 PyStata（无需安装额外的包）：
> ```python
> import sys
> sys.path.append("/opt/Stata/utilities")   # 换成你的 Stata 安装路径
> from pystata import config
> config.init("mp")                          # 版本：mp / se / be
> ```
> 两种方式任选一种即可，本仓库的 notebook 采用第一种（`stata_setup`）。

## 3. 配置与启动

在 Python 或 Jupyter 中点击“运行”以下单元即可启动 Stata：

```python
import stata_setup
stata_setup.config("/opt/Stata", "mp")   # 参数：安装路径、版本（mp/se/be）
```

成功后会在输出中看到 Stata 的启动信息（banner），并自动注册 `%stata` / `%%stata` 魔法命令。
注意：**每个 notebook 都需要先运行配置单元**，然后再运行含有 Stata 代码的单元。

## 4. 在 notebook 中使用 Stata

### 4.1 单元魔法 `%%stata`（最常用）

整个单元作为一段 Stata 命令执行（相当于执行一个 do 文件片段）：

````
%%stata
use ../datasets/chfs_ind.dta, clear
summarize labor_inc
graph box labor_inc
````

常用参数（写在 `%%stata` 之后）：

| 参数 | 作用 |
|---|---|
| `-d DATA` | 把 pandas DataFrame / NumPy 数组作为当前数据载入 Stata |
| `-doutd DF` | 单元执行完后，把 Stata 数据存为 pandas DataFrame |
| `-ret DICT` / `-eret DICT` | 把当前 `r()` / `e()` 结果存入 Python 字典 |
| `-qui` | 安静模式（不显示输出） |
| `-nogr` | 不显示图形（只执行代码） |
| `-gw WIDTH` / `-gh HEIGHT` | 设置图形显示尺寸（英寸/像素/厘米） |

### 4.2 行魔法 `%stata`

执行单行 Stata 命令：

````
%stata display 1+1
````

### 4.3 编程式调用 `stata.run()`

也可以在一个普通 Python 单元里调用：

```python
from pystata import stata
stata.run("sysuse auto, clear")
stata.run("summarize price")
```

### 4.4 Python 与 Stata 数据互通（pandas / NumPy）

```python
import pandas as pd
from pystata import stata

# Python → Stata
df = pd.DataFrame({"x": [1, 2, 3], "y": [4, 5, 6]})
stata.pdataframe_from_dataframe(df, force=True)   # 载入为当前数据

# Stata → Python
df2 = stata.pdataframe_to_dataframe()             # 把当前数据取回为 DataFrame
```

其它类似函数：`pdataframe_from_numpy`、`pdataframe_to_numpy`、`nparray_from_dataframe`、
`nparray_to_data` 等（`from pystata import stata` 后可用）。

## 5. 本仓库 notebook 的使用约定

- **工作目录**：每个 notebook 的配置单元会先把工作目录切换到
  `MathStatsCode/code_in_notes/Chap.n`，使 Stata 中的相对路径（如 `../datasets/...`）
  与同名 .do 文件完全一致；请保持 notebook 所在目录不变并按顺序运行单元。
- **图形**：图形由 PyStata 自动内联显示；notebook 中**省略了** `graph export` 导出命令
  （导出保留在 `code_in_notes` 的 .do 文件中，用于生成书中的插图）。
- **注释**：PyStata 交互模式下命令**行内**的 `// 注释` 会报语法错，
  注释请单独成行（`// 注释`、`* 注释` 或 `/* 注释 */` 均可）。
- **代码块完整性**：`program ... end`、`mata: ... end` 以及 `foreach/forvalues { ... }`
  代码块要放在同一个单元内，不要拆开。

## 6. 常见问题

- **内核重启/崩溃（Kernel died）**：本机 Stata 18.0 MP 对少数复杂图形的
  `graph export` 存在概率性段错误（双轴组合图、cibar 图等更容易触发）。
  规避方法：notebook 中不执行 `graph export`（本仓库已按此约定处理）；
  在 do 文件中执行导出时遇到崩溃，重新运行一般即可通过。
- **`stata_setup.config` 报错**：检查 Stata 安装路径与版本参数是否正确；
  确认 Python 环境中已安装 `stata_setup`。
- **找不到命令/数据文件**：确认已运行配置单元（负责注册魔法命令、切换工作目录），
  且 notebook 是从 `MathStatsCode/notebook/Chap.n/` 目录打开的。
- **用 nbconvert 批量执行 notebook 时报 `jupyter_contrib_nbextensions` 错误**：
  这是本机 Jupyter 配置文件的问题，可改用 nbclient（或在干净配置目录下运行）：

  ```python
  import nbformat
  from nbclient import NotebookClient
  nb = nbformat.read("路径/文件名.ipynb", as_version=4)
  NotebookClient(nb, timeout=600, kernel_name="anaconda",
                 resources={"metadata": {"path": "notebook 所在目录"}}).execute()
  ```
