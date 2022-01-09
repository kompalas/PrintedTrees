from matplotlib import pyplot as plt
from src import project_dir
import numpy as np
import math

x = np.linspace(0, 2.4, 10)
y = np.log(x)

fig, ax = plt.subplots(figsize=(7,5))
ax.plot(x, y, color="C1", marker="D", ms=20)
ax.grid(True)
ax.set_xticklabels([])
ax.set_yticklabels([])
ax.tick_params(
    axis='x',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom=False,      # ticks along the bottom edge are off
    top=False,         # ticks along the top edge are off
    labelbottom=False)
ax.tick_params(
    axis='y',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom=False,      # ticks along the bottom edge are off
    top=False,         # ticks along the top edge are off
    labelbottom=False)
ax.set_xlabel("Area", fontsize=40)
ax.set_ylabel("Accuracy", fontsize=40)

plt.savefig(f'{project_dir}/figures/dummy_pareto.png')