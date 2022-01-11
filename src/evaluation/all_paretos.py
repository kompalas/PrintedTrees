from matplotlib import pyplot as plt
from matplotlib import rcParams
from matplotlib.ticker import MaxNLocator
from string import ascii_lowercase
from scipy.stats import pearsonr
from src import project_dir
from src.evaluation.pareto import extract_fronts, get_results_file
import pandas as pd
import numpy as np
import logging
import pickle
import argparse
import yaml


def get_dt_data(results_file):
    df = pd.read_csv(results_file, sep='\t', header=0, engine='python')
    baseline = df.iloc[0]
    return baseline, df.iloc[1:]


def get_ga_data(num_of_solutions, experiment_dir):
    # load population file from experiment
    popfile = get_results_file(generation=-1, results_dir=experiment_dir)
    with open(f"{experiment_dir}/{popfile}", "rb") as f:
        population = pickle.load(f)
    fronts = extract_fronts(population)

    print(f"{num_of_solutions} pareto solutions are used for {experiment_dir}")
    # constrain pareto to the specified amount of solutions    
    pareto = fronts[0] if len(fronts[0]) <= num_of_solutions else \
        sorted(fronts[0], key=lambda ind: ind.objectives[0])[:num_of_solutions]

    obj1, obj2, *_ = zip(*[ind.objectives for ind in pareto])
    return obj1, obj2


def cfg_plot(ax):
    # ax.set_xlabel('Area')
    # ax.set_ylabel('Accuracy')
    ax.xaxis.grid(which="major", linestyle="-", alpha=.25)
    ax.xaxis.grid(which="minor", linestyle="--", alpha=.25)
    ax.yaxis.grid(which="major", linestyle="-", alpha=.25)
    ax.yaxis.grid(which="minor", linestyle="--", alpha=.25)
    ax.yaxis.set_major_locator(MaxNLocator(nbins=5, min_n_ticks=5))
    ax.xaxis.set_major_locator(MaxNLocator(nbins=5, min_n_ticks=5))


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Plot pareto front from GA measurements for all datasets")
    parser.add_argument('--skip-datasets', '-s', dest='skipped', nargs='*', default=[],
                        help="Specify the datasets' names to skip in order for 10 datasets to be kept in total")
    parser.add_argument('--include-estimated-pareto', '-e', action='store_true', dest='estimated',
                        help='Set to display estimated pareto lines')
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
        print(f"Skipping the evaluation of datasets: {' | '.join(args.skipped)}")
        assert len(kept_paretos) == 10, "Specify a different amount of datasets " \
                                        f"to skip: 10 datasets are needed but {len(kept_paretos)} were found"

    # font ans latex parameters
    rcParams['font.size'] = "16"
    rcParams.update({
        "text.usetex": True,
        "font.family": "serif",
        "font.serif": ["Computer Modern Roman"]
    })
    plt.ion()

    # initialize figure
    fig, axes = plt.subplots(
        nrows=2, ncols=5, figsize=(15, 5),  # tight_layout={'pad':0}
    )
    fig.tight_layout()

    # alphabet letters for each subplot
    letters = iter(ascii_lowercase)
    markersize = 12
    lettersize = 18
    labelsize = 20
    legendisize = 20

    corr = []
    letter_to_dataset = {}
    print()
    for index, (dataset, exp_name) in enumerate(kept_paretos.items()):
        letter = next(letters)
        letter_to_dataset[letter] = dataset

        row = index // 5
        column = index % 5
        ax = axes[row, column]

        # load measurements from synopsys
        baseline_df, data_df = get_dt_data(
            results_file=f'{project_dir}/test/pareto/results/{exp_name}/results.txt'
        )
        # load pareto objectives from ga experiment
        obj1, obj2 = get_ga_data(
            num_of_solutions=len(data_df.index), experiment_dir=f'{project_dir}/results/ga/{exp_name}'
        )
        corr.append(np.abs(pearsonr(obj2, data_df['Area'])))

        # plot: x is normalized area, y is accuracy. Estimated pareto, actual pareto + baseline point
        ax.plot(data_df['Area']/baseline_df['Area'], data_df['Accuracy'], 'g^', ms=markersize, label='True pareto')
        if args.estimated:
            ax.plot(obj2/baseline_df['Area'], 1 - np.array(obj1), 'b--', label='Estimated pareto')
        ax.plot(1, baseline_df['Accuracy'], 'r*', ms=markersize+2, label='Exact Bespoke')
        ax.text(
            0.55, 0.44, rf'\textbf{{({letter})}}',
            fontweight='bold', fontsize=lettersize,
            va='top', ha='left', transform=ax.transAxes,
        )
        cfg_plot(ax)

    print()
    print(f"Area correlation: {np.average(corr)}")
    print("Subfigure letters belong to:")
    for letter, dataset in letter_to_dataset.items():
        print(f"\t({letter}): {dataset}")

    # insert labels for all axes
    fig.text(
        -0.01, 0.5, "Accuracy", fontweight='bold', va='center', ha='left', rotation=90, fontsize=labelsize
    )
    fig.text(
        0.5, -0.01, "Normalized Area", fontweight='bold', va='center', ha='center', fontsize=labelsize
    )

    # configure legend
    handles, labels = ax.get_legend_handles_labels()
    leg = fig.legend(
        handles, labels,
        columnspacing=1, ncol=3 if args.estimated else 2,
        edgecolor=None, framealpha=0,
        fontsize=legendisize,
        bbox_to_anchor=(0.5, 0.93), loc='lower center'
    )

    savefile = f'{project_dir}/results/figures/paper/all_paretos.pdf'
    plt.savefig(savefile, bbox_inches='tight')
    print(f"Figure was saved in {savefile}")
