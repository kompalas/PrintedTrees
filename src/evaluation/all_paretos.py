from matplotlib import pyplot as plt
from matplotlib import rcParams
from matplotlib.ticker import AutoMinorLocator,MaxNLocator,FormatStrFormatter
from src import project_dir
from src.evaluation.pareto import extract_fronts, get_results_file
import pandas as pd
import numpy as np
import logging
import pickle
import argparse
import re
import yaml


def get_dt_data(results_file):
    df = pd.read_csv(results_file, sep='\t', header=0, engine='python')
    baseline = df.iloc[0]
    return baseline, df.iloc[1:]


def get_ga_data(num_of_solutions, experiment_dir):
    # load population file from experiment
    popfile = get_results_file(generation=-1, results_dir=experiment_dir)
    with open(f"{args.expdir}/{popfile}", "rb") as f:
        population = pickle.load(f)
    fronts = extract_fronts(population)

    print(f"{num_of_solutions} pareto solutions")
    # constrain pareto to the specified amount of solutions    
    pareto = fronts[0] if len(fronts[0]) <= num_of_solutions else \
        sorted(fronts[0], key=lambda ind: ind.objectives[0])[:num_of_solutions]

    obj1, obj2, *_ = zip(*[ind.objectives for ind in pareto])
    return obj1, obj2


def cfg_plot(ax):
    ax.set_xlabel('Area')
    ax.set_ylabel('Accuracy')
    ax.xaxis.grid(which="major", linestyle="-", alpha=.25)
    ax.xaxis.grid(which="minor", linestyle="--", alpha=.25)
    ax.yaxis.grid(which="major", linestyle="-", alpha=.25)
    ax.yaxis.grid(which="minor", linestyle="--", alpha=.25)
    ax.legend()


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Plot pareto front from GA measurements for all datasets")
    parser.add_argument('--skip-datasets', '-s', dest='skipped', nargs='*', default=['balance'],
                        help="Specify the datasets' names to skip in order for 10 datasets to be kept in total")
    args = parser.parse_args()
    print(f"Command line arguments: {args.__dict__}")
    
    # load the pareto kept for each dataset
    dataset_yaml = f"{project_dir}/results/ga/kept_pareto.yaml"
    with open(dataset_yaml, 'r') as stream:
        kept_paretos = yaml.safe_load(stream)
    print(f"{len(kept_paretos)} datasets were read from {dataset_yaml}")

    # reduce datasets to 10
    if len(kept_paretos) != 10:
        kept_paretos = {
            dataset: experiment for dataset, experiment in kept_paretos.items()
            if dataset.lower() not in args.skipped and dataset not in args.skipped
        }
        print(f"Skipping the evaluation of datasets: {args.skipped}")
        assert len(kept_paretos) == 10, "Specify a different amount of datasets "\
            f"to skip: 10 datasets are needed but {len(kept_paretos)} were found"

    # font ans latex parameters
    rcParams['font.size'] = "12"
    rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Computer Modern Roman"]})
    plt.ion()

    # initialize figure
    fig, axes = plt.subplots(
        nrows=2, ncols=5, figsize=(12, 5),  # tight_layout={'pad':0}
    )

    for index, (dataset, exp_name) in enumerate(kept_paretos.items()):

        # load measurements from synopsys
        baseline_df, data_df = get_dt_data(
            results_file=f'{project_dir}/test/pareto/results/{exp_name}/results.txt'
        )
        # load pareto objectives from ga experiment
        obj1, obj2 = get_ga_data(
            num_of_solutions=len(data_df.index), experiment_dir=f'{project_dir}/results/ga/exp_name'
        )

        # plot: x is area, y is accuracy. Estimated pareto, actual pareto + baseline point
        axes[index].plot(obj2, 1 - np.array(obj1), 'bx--', label='Estimated pareto')
        axes[index].plot(data_df['Area'], data_df['Accuracy'], 'k^-', label='True pareto')
        axes[index].plot(baseline_df['Area'], baseline_df['Accuracy'], 'rx', label='Accurate')
        cfg_plot(axes[index])

    savefile = f'{project_dir}/results/figures/paper/all_paretos.pdf'
    plt.savefig(savefile)
    print(f"Figure was saved in {savefile}")
