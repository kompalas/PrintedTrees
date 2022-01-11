import re
import pandas as pd
import numpy as np
import logging
import pickle
import argparse
from matplotlib import pyplot as plt
from src.evaluation.pareto import extract_fronts, get_results_file
from src import project_dir


def get_dt_data(results_file):
    df = pd.read_csv(results_file, sep='\t', header=0, engine='python')
    baseline = df.iloc[0]
    return baseline, df.iloc[1:]


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Plot pareto front from GA measurements")
    parser.add_argument('--experiment-directory', '-e', dest='expdir', required=True,
                        help='Specify the directory where GA experiment population files are stored (required)')
    parser.add_argument('--generation', '-g', dest='gen', type=int, default=-1,
                        help='Specify the generation from which to obtain the pareto front. By default, the last'
                             ' generation is selected.')
    parser.add_argument('--results-file', '-rf', dest='results_file', required=True,
                        help='Specify the file where GA pareto measurements are stored (required)')
    parser.add_argument('--num-of-subplots', '-s', choices=[1, 2], type=int, default=2, dest='subplots',
                        help="Specify the amount of subplots in the final figure: 1 (area vs accuracy) or 2 "
                             "(plus power vs accuracy). Default is 2")
    args = parser.parse_args()

    # load measurements from synopsys
    baseline_df, data_df = get_dt_data(args.results_file)

    # load population file from experiment
    resfile = get_results_file(generation=args.gen, results_dir=args.expdir)
    with open(f"{args.expdir}/{resfile}", "rb") as f:
        population = pickle.load(f)
    fronts = extract_fronts(population)

    # constrain pareto to the specified amount of solutions
    num_of_solutions = len(data_df.index)
    print(f"{num_of_solutions} pareto solutions")
    pareto = fronts[0] if len(fronts[0]) <= num_of_solutions else \
        sorted(fronts[0], key=lambda ind: ind.objectives[0])[:num_of_solutions]
    obj1, obj2, *_ = zip(*[ind.objectives for ind in pareto])

    fig, axes = plt.subplots(nrows=1, ncols=args.subplots, figsize=(7.5 * args.subplots, 5))
    axes = [axes] if args.subplots == 1 else axes

    axes[0].grid(True)
    axes[0].set_xlabel('Area')
    axes[0].set_ylabel('Accuracy')
    # axes[0].semilogx()
    axes[0].plot(obj2, 1 - np.array(obj1), 'bx--', label='Estimated pareto')
    axes[0].plot(data_df['Area'], data_df['Accuracy'], 'k^-', label='True pareto')
    axes[0].plot(baseline_df['Area'], baseline_df['Accuracy'], 'rx', label='Accurate')
    axes[0].legend()

    if args.subplots == 2:
        axes[1].grid(True)
        axes[1].set_xlabel('Power')
        axes[1].set_ylabel('Accuracy')
        # axes[1].semilogx()
        axes[1].plot(data_df['Power'], data_df['Accuracy'], 'k^-', label='True pareto')
        axes[1].plot(baseline_df['Power'], baseline_df['Accuracy'], 'rx', label='Accurate')
        axes[1].legend()

    filename = re.search(
        '.*/(.*)$', (args.expdir[:-1] if args.expdir[-1] == '/' else args.expdir)
    ).group(1)
    savefile = f'{project_dir}/results/figures/{filename}.pdf'
    plt.savefig(savefile)
    print(f"Figure was saved in {savefile}")
