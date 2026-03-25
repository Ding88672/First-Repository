import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import pandas as pd

# ====================== 核心算法类 ======================
class D01KPSolver:
    def __init__(self, data_groups, capacity):
        self.groups = data_groups
        self.capacity = capacity
        self.best_value = 0
        self.solve_time = 0
        self.best_items = []

    def solve(self):
        start = time.time()
        n = len(self.groups)
        C = self.capacity
        dp = [[0] * (C + 1) for _ in range(n + 1)]

        for i in range(1, n + 1):
            group = self.groups[i - 1]
            for j in range(C + 1):
                dp[i][j] = dp[i - 1][j]
                for item in group:
                    w, v = item[0], item[1]
                    if j >= w and dp[i - 1][j - w] + v > dp[i][j]:
                        dp[i][j] = dp[i - 1][j - w] + v

        j = C
        self.best_items = []
        for i in range(n, 0, -1):
            if dp[i][j] != dp[i - 1][j]:
                for item in self.groups[i - 1]:
                    w, v = item[0], item[1]
                    if j >= w and dp[i - 1][j - w] + v == dp[i][j]:
                        self.best_items.append(item)
                        j -= w
                        break

        self.best_value = dp[n][C]
        self.solve_time = round(time.time() - start, 4)
        return self.best_value, self.best_items, self.solve_time

# ====================== 主界面类 ======================
class D01KPApp:
    def __init__(self, root):
        self.root = root
        self.root.title("D{0-1}KP 求解器")
        self.root.geometry("1000x750")

        self.all_data = []
        self.capacity = 0
        self.current_result = None

        self.create_widgets()

    def create_widgets(self):
        # -------- 顶部按钮 --------
        frame_top = ttk.Frame(self.root)
        frame_top.pack(pady=10, fill=tk.X)

        ttk.Button(frame_top, text="导入数据", command=self.load_data).grid(row=0, column=0, padx=8, pady=8)
        ttk.Button(frame_top, text="绘制散点图", command=self.draw_plot).grid(row=0, column=1, padx=8, pady=8)
        ttk.Button(frame_top, text="价值重量比排序", command=self.sort_by_ratio).grid(row=0, column=2, padx=8, pady=8)
        ttk.Button(frame_top, text="开始求解", command=self.calculate).grid(row=0, column=3, padx=8, pady=8)
        ttk.Button(frame_top, text="显示最优解饼图", command=self.draw_pie).grid(row=0, column=4, padx=8, pady=8)
        ttk.Button(frame_top, text="保存结果", command=self.save_result).grid(row=0, column=5, padx=8, pady=8)

        # -------- 结果显示 --------
        frame_mid = ttk.Frame(self.root)
        frame_mid.pack(pady=10, fill=tk.BOTH, expand=True)
        self.result_text = tk.Text(frame_mid, height=12, font=("微软雅黑", 10))
        self.result_text.pack(fill=tk.BOTH, expand=True, padx=10)

        # -------- 绘图区域 --------
        self.fig, (self.ax1, self.ax2) = plt.subplots(1, 2, figsize=(10, 3))
        self.canvas = FigureCanvasTkAgg(self.fig, self.root)
        self.canvas.get_tk_widget().pack(pady=10, padx=10, fill=tk.BOTH, expand=True)

    # ====================== 功能1：加载数据 ======================
    def load_data(self):
        path = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt")])
        if not path:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                lines = []
                for line in f:
                    stripped = line.strip()
                    if stripped:
                        lines.append(stripped)

            self.capacity = int(lines[0])
            groups = []
            group = []
            for line in lines[1:]:
                if line == "---":
                    if group:
                        groups.append(group)
                        group = []
                else:
                    parts = line.split()
                    if len(parts) == 2:
                        w = int(parts[0])
                        v = int(parts[1])
                        group.append([w, v])
            if group:
                groups.append(group)
            self.all_data = groups
            self.result_text.insert(tk.END, f"✅ 数据导入成功！容量：{self.capacity} 组数：{len(groups)}\n\n")
        except Exception as e:
            messagebox.showerror("错误", f"数据格式错误：{str(e)}")

    # ====================== 功能2：绘制散点图 ======================
    def draw_plot(self):
        if not self.all_data:
            messagebox.showwarning("提示", "请先导入数据")
            return
        ws, vs = [], []
        for g in self.all_data:
            for item in g:
                ws.append(item[0])
                vs.append(item[1])
        self.ax1.clear()
        self.ax1.scatter(ws, vs, c="blue", s=50)
        self.ax1.set_xlabel("重量")
        self.ax1.set_ylabel("价值")
        self.ax1.set_title("数据散点图")
        self.ax1.grid(True)
        self.canvas.draw()

    # ====================== 功能3：价值/重量比排序 ======================
    def sort_by_ratio(self):
        if not self.all_data:
            messagebox.showwarning("提示", "请先导入数据")
            return
        new_groups = []
        for g in self.all_data:
            g_sort = sorted(g, key=lambda x: x[1]/x[0] if x[0]!=0 else 0, reverse=True)
            new_groups.append(g_sort)
        self.all_data = new_groups
        self.result_text.insert(tk.END, "✅ 已按价值/重量比非递增排序\n\n")

    # ====================== 功能4：动态规划求解 ======================
    def calculate(self):
        if not self.all_data:
            messagebox.showwarning("提示", "请先导入数据")
            return
        solver = D01KPSolver(self.all_data, self.capacity)
        best_v, items, t = solver.solve()
        self.current_result = {"capacity":self.capacity, "max_value":best_v, "items":items, "time":t}
        self.result_text.insert(tk.END, "="*50+"\n")
        self.result_text.insert(tk.END, f"最优价值：{best_v}\n求解时间：{t}s\n选中物品：{items}\n")
        self.result_text.insert(tk.END, "="*50+"\n\n")

    # ====================== 扩展功能：饼图可视化 ======================
    def draw_pie(self):
        if not self.current_result:
            messagebox.showwarning("提示", "请先求解")
            return
        items = self.current_result["items"]
        if not items:
            messagebox.showwarning("提示", "未选中任何物品")
            return
        weights = [item[0] for item in items]
        labels = [f"w={item[0]},v={item[1]}" for item in items]
        self.ax2.clear()
        self.ax2.pie(weights, labels=labels, autopct="%1.1f%%", startangle=90)
        self.ax2.set_title("最优解物品重量占比")
        self.canvas.draw()

    # ====================== 功能5：保存结果 ======================
    def save_result(self):
        if not self.current_result:
            messagebox.showwarning("提示", "请先求解")
            return
        path = filedialog.asksaveasfilename(filetypes=[("TXT", "*.txt"), ("Excel", "*.xlsx")])
        if not path: return
        res = self.current_result
        if path.endswith(".txt"):
            with open(path, "w", encoding="utf-8") as f:
                f.write(f"背包容量：{res['capacity']}\n最优价值：{res['max_value']}\n求解时间：{res['time']}s\n物品：{res['items']}")
        else:
            df = pd.DataFrame([["背包容量",res["capacity"]],["最优价值",res["max_value"]],["时间(s)",res["time"]],["物品",str(res["items"])]],columns=["项目","数值"])
            df.to_excel(path, index=False)
        messagebox.showinfo("成功", "结果已保存！")

# ====================== 启动程序 ======================
if __name__ == "__main__":
    root = tk.Tk()
    app = D01KPApp(root)
    root.mainloop()
