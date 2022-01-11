from src import project_dir
from src.evaluation.all_paretos import get_ga_data, get_dt_data
from src.evaluation.tree2verilog import logging_cfg
import argparse
import yaml
import re
import ast


def get_comparators(experiment_name):
    with open(f"{project_dir}/results/ga/{experiment_name}/out.log", "r") as f:
        log = f.read()
    thresholds = re.search("Original thresholds: (\[.*?\])", log, re.DOTALL)
    thresholds = thresholds.group(1).replace('\n', '').replace('[', '[ ').replace(']', ' ]')
    thresholds = re.split("\s+", thresholds)
    thresholds = [float(t) for t in thresholds if re.match('[-]?\d+[.]?\d*', t)]
    return thresholds


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Plot pareto front from GA measurements for all datasets")
    parser.add_argument('--skip-datasets', '-s', dest='skipped', nargs='*', default=[],
                        help="Specify the datasets' names to skip in order for 10 datasets to be kept in total")
    parser.add_argument('--accuracy-threshold', '-t', dest='threshold', type=float, default=1,
                        help='Specify the acceptable accuracy threshold for all measurements. Default is 1\\%')
    args = parser.parse_args()
    print(f"Command line arguments: {args.__dict__}")

    # configure logger to create the text file with the latex table
    logfile = f'{project_dir}/results/figures/paper/bl_table.txt'
    logger = logging_cfg('table', logfile)
    logger.debug("""
\\begin{table}[t]
\\caption{Evaluation of exact bespoke Decision Tree circuits for each examined dataset.}
\\centering
{\\footnotesize
\\setlength{\\tabcolsep}{4pt}
\\begin{tabular}{c|c|c|c|c|c}
\t\\hline
""")

    initial_line = "\t\\textbf{Dataset} & \\textbf{Accuracy} & \\textbf{\\#Comp.} & " \
                   "\\makecell{\\textbf{Delay} \\\\ ($ms$)} & \\makecell{\\textbf{Area} \\\\ ($mm^2$)} & " \
                   "\\makecell{\\textbf{Power} \\\\ ($mW$)} \\\\"
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

    for index, (dataset, exp_name) in enumerate(kept_paretos.items()):

        # load measurements from synopsys
        baseline_df, data_df = get_dt_data(
            results_file=f'{project_dir}/test/pareto/results/{exp_name}/results.txt'
        )
        accuracy_str = f"{baseline_df['Accuracy']:.3f}"
        delay_str = f"{baseline_df['Delay']/1e6:.1f}"
        area_str = f"{baseline_df['Area']/1e6:.2f}"
        power_str = f"{baseline_df['Power']*1e3:.2f}"
        comp = get_comparators(exp_name)
        comp = [threshold for threshold in comp if threshold > 0]

        dataset = dataset if dataset.lower() != 'mammographic' else 'Mammogr.'
        line = f"\t\\textbf{{{dataset}}} & {accuracy_str} & {len(comp)} & {delay_str} & {area_str} & {power_str} \\\\\n\t\\hline"
        logger.debug(line)

    logger.debug(r"""
\end{tabular}
}
\label{tab:baseline}
\end{table}
""")

    print(f"Latex table was written in {logger.handlers[1].baseFilename}")
