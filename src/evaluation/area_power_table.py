from src import project_dir
from src.evaluation.all_paretos import get_ga_data, get_dt_data
from src.evaluation.tree2verilog import logging_cfg
import argparse
import yaml
import numpy as np


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Plot pareto front from GA measurements for all datasets")
    parser.add_argument('--skip-datasets', '-s', dest='skipped', nargs='*', default=[],
                        help="Specify the datasets' names to skip in order for 10 datasets to be kept in total")
    parser.add_argument('--accuracy-threshold', '-t', dest='threshold', type=float, default=1,
                        help='Specify the acceptable accuracy threshold for all measurements. Default is 1\\%')
    args = parser.parse_args()
    print(f"Command line arguments: {args.__dict__}")

    # configure logger to create the text file with the latex table
    logfile = f'{project_dir}/results/figures/paper/table.txt'
    logger = logging_cfg('table', logfile)

    caption = f"Area and power evaluation for an accuracy threshold of ${args.threshold}\\%$. Circuits highlighted in" \
              f" green can be powered by Blue Spark printed batteries ($<3mW$) and the design highlighted in orange " \
              f"can be self-powered, i.e. by an energy harvester ($<0.1mW$)"
    logger.debug(f"""
\\begin{{table}}[t]
\\caption{{{caption}}}\\centering
{{\\footnotesize
% \\setlength{{\\tabcolsep}}{{3pt}}
\\begin{{tabular}}{{c|c|c|c|c|c}}
\t\\hline""")

    initial_line = "\t\\textbf{Dataset} & \\textbf{Accuracy} & \\makecell{\\textbf{Area} \\\\ ($mm^2$)} & " \
                   "\\makecell{\\textbf{Norm.} \\\\ \\textbf{Area}} &  \\makecell{\\textbf{Power} \\\\ ($mW$)} & " \
                   "\\makecell{\\textbf{Norm.} \\\\ \\textbf{Power}} \\\\"
    logger.debug(f"{initial_line}\n\t\\hline")

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

    print()
    measurements = []
    for index, (dataset, exp_name) in enumerate(kept_paretos.items()):

        # load measurements from synopsys
        baseline_df, data_df = get_dt_data(
            results_file=f'{project_dir}/test/pareto/results/{exp_name}/results.txt'
        )

        print(f"Evaluating {dataset} dataset.")
        print(f"Baseline accuracy {baseline_df['Accuracy']}")
        # keep solutions only with acceptable accuracy threshold
        data_df = data_df.loc[data_df['Accuracy'] >= baseline_df['Accuracy'] - args.threshold*0.01]
        # find the solution with minimum power out of the ones with acceptable accuracy
        index_of_min_power = data_df.loc[data_df['Power'] == min(data_df['Power'])].index[0]
        sol_with_min_power = data_df.iloc[index_of_min_power - 1]
        print(f"Solution index with minimum power: {sol_with_min_power['Sol']}")

        accuracy = sol_with_min_power['Accuracy']
        accuracy_str = f"{accuracy:.2f}"
        area = sol_with_min_power['Area']
        area_str = f"{area/1e6:.2f}"
        area_norm = area/baseline_df['Area']
        area_norm_str = f"{area_norm:.3f}"
        power = sol_with_min_power['Power']
        power_str = f"{power*1e3:.2f}"
        power_norm = power/baseline_df['Power']
        power_norm_str = f"{power_norm:.3f}"

        measurements.append((1-area_norm, 1-power_norm))

        colors = ['Azure1', 'LightBlue1', 'PaleGreen1', 'DarkSeaGreen1', 'BurlyWood1']
        highlight = None if power > 0.03 else 'Azure1' if power > 0.003 else 'DarkSeaGreen1' if power > 0.0003 else 'Burlywood1'
        line = f"\t\\rowcolor{{{highlight}!50}} " if highlight is not None else "\t"

        dataset = dataset if dataset.lower() != 'mammographic' else 'Mammogr.'
        line += f"\\textbf{{{dataset}}} & {accuracy_str} & {area_str} & " \
               f"{area_norm_str} & {power_str} & {power_norm_str} \\\\\n\t\\hline"
        logger.debug(line)

    logger.debug(r"""
\end{tabular}
}
\label{tab:area_power}
\end{table}
""")

    print()
    area_norm, power_norm = list(zip(*measurements))
    print(f"Average area gains: {np.average(area_norm)}")
    print(f"Average power gains: {np.average(power_norm)}")
    print(f"Latex table was written in {logger.handlers[1].baseFilename}")
