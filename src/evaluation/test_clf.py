import pickle
import argparse
import graphviz
from sklearn import tree
from src import ALL_DATASETS, project_dir
from src.evaluation.pareto import get_results_file, extract_fronts
from src.datasets import get_data


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Genetic algorithm for Approximate Decision Trees")
    parser.add_argument("--input-bits", "-b", dest="input_bits", type=int, default=4,
                        help="Specify the input bitwidth. If not specified, the input bits will be part of the "
                             "exploration, as an additional variable in the chromosome")
    loaded_or_created = parser.add_mutually_exclusive_group(required=True)
    loaded_or_created.add_argument("--load-from", '-l', dest='load_from',
                                   help='Specify the directory where GA results are stored. From '
                                        'there, the approximate Decision Tree will be constructed')
    loaded_or_created.add_argument("--dataset", "-d",
                                   choices=ALL_DATASETS + [dataset.lower() for dataset in ALL_DATASETS],
                                   help=f"Choose a dataset. Possible choices are {' | '.join(ALL_DATASETS)}")
    parser.add_argument('--load-ga-clf', dest='ga_mode',
                        choices=['init', 'max_acc', 'max_area'], default='init',
                        help="Select an action when loading a decision tree from a GA experiment. Options are: "
                             "'max_acc' for selecting the solution on the pareto front with maximum accuracy, "
                             "'min_area' for selecting the solution on the pareto front with smallest area, "
                             "'init' (default) for selecting the accurate classifier of the GA experiment")
    parser.add_argument("--results-dir", "-rd", help="Set the directory where results will be stored")
    args = parser.parse_args()
    args.results_dir = f"{project_dir}/results" if args.results_dir is None else args.results_dir
    args.results_dir = args.results_dir[:-1] if args.results_dir[-1] == '/' else args.results_dir

    if not args.load_from:
        clf = tree.DecisionTreeClassifier()
        x_train, x_test, y_train, y_test = get_data(args.dataset, input_bits=args.input_bits)
        clf.fit(x_train, y_train)
        dataset = args.dataset

    else:
        args.load_from = args.load_from[:-1] if args.load_from[-1] == '/' else args.load_from
        resfile = get_results_file(generation=-1, results_dir=args.load_from)

        with open(f"{args.load_from}/{resfile}", "rb") as f:
            population = pickle.load(f)
        fronts = extract_fronts(population)

        with open(f"{args.load_from}/clf.pkl", "rb") as f:
            data, clf, candidates = pickle.load(f)
        dataset = data['dataset']
        bitwidth = data['bitwidth']
        assert bitwidth is not None, "Variable bitwidth in the chromosome is not supported yet"

        new_thresholds = {
            'init': [],
            'min_area': min(fronts[0], key=lambda ind: ind.objectives[1]).features,
            'max_acc': min(fronts[0], key=lambda ind: ind.objectives[0]).features
        }.get(args.ga_mode, [])
        new_thresholds = [threshold for i, threshold in enumerate(new_thresholds) if candidates[i] != -1]

        new_thresholds_i = iter(new_thresholds)
        for i in range(len(clf.tree_.threshold)):
            if clf.tree_.threshold[i] > 0:
                clf.tree_.threshold[i] = next(new_thresholds_i) * 1/(2**bitwidth)

    dot_data = tree.export_graphviz(
        decision_tree=clf,
        node_ids=True,
    )
    graph = graphviz.Source(
        dot_data, format='pdf'
    )
    graph.render(filename=f'{args.results_dir}/{dataset}_dtree_graph')

    with open(f"{args.results_dir}/dtree.pkl", "wb") as f:
        pickle.dump(clf, f)
