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
                        help='Specify the generation ')
    parser.add_argument('--keep-pareto-solutions', '-k', dest='keep', type=int, default=20,
                        help="Specify the number of pareto solutions to keep, sorted by accuracy. Default is 20")
    parser.add_argument('--results-file', '-rf', dest='results_file', required=True,
                        help='Specify the file where GA pareto measurements are stored (required)')
    # parser.add_argument()
    args = parser.parse_args()

    # load measurements from synopsys
    baseline_df, data_df = get_dt_data(args.results_file)

    # load population file from experiment
    resfile = get_results_file(generation=args.gen, results_dir=args.expdir)
    print(resfile)
    with open(f"{args.expdir}/{resfile}", "rb") as f:
        population = pickle.load(f)
    fronts = extract_fronts(population)

    # constrain pareto to the specified amount of solutions
    num_of_solutions = len(data_df.index)
    pareto = fronts[0] if len(fronts[0]) <= num_of_solutions else \
        sorted(fronts[0], key=lambda ind: ind.objectives[0])[:num_of_solutions]
    obj1, obj2, *_ = zip(*[ind.objectives for ind in pareto])

    print(1-np.array(obj1))
    exit(1)

    fig, (ax1, ax2) = plt.subplots(figsize=(15, 5))
    ax1.grid(True)
    ax1.set_xlabel('Area')
    ax1.set_ylabel('Accuracy')
    ax1.plot(obj2, 1 - np.array(obj1), 'bx--', label='Estimated pareto')
    ax1.plot(data_df['Area'], data_df['Accuracy'], 'k^-', label='True pareto')
    ax1.plot(baseline_df['Area'], baseline_df['Accuracy'], 'rx', label='Accurate')
    ax1.legend()

    ax2.grid(True)
    ax2.set_xlabel('Power')
    ax2.set_ylabel('Accuracy')
    ax2.plot(data_df['Power'], data_df['Accuracy'], 'k^-', label='True pareto')
    ax2.plot(baseline_df['Power'], baseline_df['Accuracy'], 'rx', label='Accurate')
    ax2.legend()

    filename = re.search(
        '.*/(.*)$', (args.expdir[:-1] if args.expdir[-1] == '/' else args.expdir)
    ).group(1)
    savefile = f'{project_dir}/results/figures/{filename}.pdf'
    plt.savefig(savefile)
