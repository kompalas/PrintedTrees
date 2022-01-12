from src import project_dir
from matplotlib import pyplot as plt
from matplotlib import rcParams
import pandas as pd

df = pd.read_csv(f'{project_dir}/results/comp_29_12_2021__18_04/results_50ms.txt', sep='\t')

fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(12,5))
fig.set_tight_layout(True)

rcParams['font.size'] = "30"
rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Computer Modern Roman"],
})

ax1.set_xlabel('Threshold value')
ax1.set_ylabel('Area [$mm^2$]')
ax2.set_xlabel('Threshold value')
ax2.set_ylabel(r'Area [$mm^2$]')
ax1.set_xlim((0, 63))
# ax1.set_ylim(bottom=0)
ax2.set_xlim(0, 255)
# ax2.set_ylim(bottom=0)

df['Area'] = df['Area']/1e6
df_6bits = df.loc[df['InputBits'] == 6]
df_8bits = df.loc[df['InputBits'] == 8]
ax1.plot(df_6bits['Constant'], df_6bits['Area'])
ax1.fill_between(df_6bits['Constant'], df_6bits['Area'], alpha=0.4)
ax2.plot(df_8bits['Constant'], df_8bits['Area'])
ax2.fill_between(df_8bits['Constant'], df_8bits['Area'], alpha=0.4)
ax1.tick_params(axis='both', labelsize=20)
ax2.tick_params(axis='both', labelsize=20)

fig.text(
    0.29, 0.97,
    "(a) 6 bits",
    fontweight="bold", va='center', ha='center'
)
fig.text(
    0.77, 0.97,
    "(b) 8 bits",
    fontweight="bold", va='center', ha='center'
)
savefile = f"{project_dir}/results/figures/paper/comp_area.pdf"
plt.savefig(savefile, bbox_inches='tight')
print(f"Figure was saved in: {savefile}")
