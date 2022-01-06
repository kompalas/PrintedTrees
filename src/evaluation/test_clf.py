import os
import pickle
import argparse
import shutil
import graphviz
import numpy as np
from glob import glob
from sklearn import tree
from src import ALL_DATASETS, project_dir
from src.evaluation.pareto import get_results_file, extract_fronts
from src.datasets import get_data
from src.nsga2.objectives import translate_chromosome, calculate_accuracy


def print_dt_info(classifier):
    # basic information about the classifier
    n_nodes = classifier.tree_.node_count
    children_left = classifier.tree_.children_left
    children_right = classifier.tree_.children_right
    feature = classifier.tree_.feature
    threshold = classifier.tree_.threshold

    node_depth = np.zeros(shape=n_nodes, dtype=np.int64)
    is_leaves = np.zeros(shape=n_nodes, dtype=bool)
    stack = [(0, 0)]  # start with the root node id (0) and its depth (0)
    while len(stack) > 0:
        # `pop` ensures each node is only visited once
        node_id, depth = stack.pop()
        node_depth[node_id] = depth

        # If the left and right child of a node is not the same we have a split node
        is_split_node = children_left[node_id] != children_right[node_id]
        # If a split node, append left and right children and depth to `stack` so we can loop through them
        if is_split_node:
            stack.append((children_left[node_id], depth + 1))
            stack.append((children_right[node_id], depth + 1))
        else:
            is_leaves[node_id] = True

    print(f"The binary tree structure has {n_nodes} nodes and has the following tree structure:\n")
    for i in range(n_nodes):
        if is_leaves[i]:
            print("{space}node={node} is a leaf node.".format(space=node_depth[i] * "\t", node=i))
        else:
            print(
                "{space}node={node} is a split node: "
                "go to node {left} if X[:, {feature}] <= {threshold} else "
                "to node {right}.".format(
                    space=node_depth[i] * "\t",
                    node=i,
                    left=children_left[i],
                    feature=feature[i],
                    threshold=threshold[i],
                    right=children_right[i]
                )
            )


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Genetic algorithm for Approximate Decision Trees")
    parser.add_argument("--input-bits", "-b", dest="input_bits", type=int, default=4,
                        help="Specify the input bitwidth. If not specified, the input bits will be part of the "
                             "exploration, as an additional variable in the chromosome")
    loaded_or_created = parser.add_mutually_exclusive_group(required=True)
    loaded_or_created.add_argument("--dataset", "-d",
                                   choices=ALL_DATASETS + [dataset.lower() for dataset in ALL_DATASETS],
                                   help=f"Choose a dataset. Possible choices are {' | '.join(ALL_DATASETS)}")
    loaded_or_created.add_argument("--load-from", '-l', dest='load_from',
                                   help='Specify the directory where GA results are stored. From '
                                        'there, the approximate Decision Tree will be constructed')
    parser.add_argument('--load-mode', '-lm', dest='ga_mode',
                        choices=['init', 'max_acc', 'max_area', 'all'], default='init',
                        help="Select an action when loading a decision tree from a GA experiment. Options are: "
                             "'max_acc' for selecting the solution on the pareto front with maximum accuracy, "
                             "'min_area' for selecting the solution on the pareto front with smallest area, "
                             "'init' (default) for selecting the accurate classifier of the GA experiment, "
                             "'all' for selecting all approximate classifiers from the pareto front")
    parser.add_argument('--keep-pareto-solutions', '-k', dest='keep', type=int, default=20,
                        help="Specify the number of pareto solutions to keep, sorted by accuracy. "
                             "Only effective with the 'all' option for --load-mode. Default is 20")
    parser.add_argument("--results-dir", "-rd", help="Set the directory where results will be stored")
    parser.add_argument("--to-pdf", dest='to_pdf', action='store_true', help="Set to export tree structure to pdf")
    args = parser.parse_args()

    # create results directory
    args.results_dir = f"{project_dir}/results/tree" if args.results_dir is None else args.results_dir
    args.results_dir = args.results_dir[:-1] if args.results_dir[-1] == '/' else args.results_dir
    os.makedirs(args.results_dir, exist_ok=True)

    # remove results from previous experiments
    # for resfile in glob(f"{args.results_dir}/*"):
    #     if os.path.isfile(resfile):
    #         os.remove(resfile)
    #    elif os.path.isdir(resfile):
    #        shutil.rmtree(resfile)

    # create a new classifier or load one from a GA experiment
    if not args.load_from:
        clf = tree.DecisionTreeClassifier()
        x_train, x_test, y_train, y_test = get_data(args.dataset, input_bits=args.input_bits)
        clf.fit(x_train, y_train)
        dataset = args.dataset
        print(f"Created a new classifier with dataset: {dataset}")

        # save the decision tree object with pickle
        with open(f"{args.results_dir}/dtree.pkl", "wb") as f:
            pickle.dump(clf, f)

        y_pred = clf.predict(x_test)
        acc = calculate_accuracy(y_test, y_pred, 'accuracy')
        with open(f"{args.results_dir}/accuracy.txt", "w") as f:
            f.write(str(acc))

    else:
        args.load_from = args.load_from[:-1] if args.load_from[-1] == '/' else args.load_from
        resfile = get_results_file(generation=-1, results_dir=args.load_from)

        # load population file from experiment
        with open(f"{args.load_from}/{resfile}", "rb") as f:
            population = pickle.load(f)
        print(f"Extracted fronts from: {args.load_from}/{resfile}")
        fronts = extract_fronts(population)

        # load initialization data from experiment
        with open(f"{args.load_from}/clf.pkl", "rb") as f:
            data, info, clf = pickle.load(f)
        og_thresholds = clf.tree_.threshold
        dataset = info["dataset"]

        # figure out thresholds from chromosome
        chromosomes = {
            'init': None,
            'min_area': [min(fronts[0], key=lambda ind: ind.objectives[1]).features],
            'max_acc': [min(fronts[0], key=lambda ind: ind.objectives[0]).features],
            'all': list(map(
                lambda ind: ind.features,
                sorted(fronts[0], key=lambda ind: ind.objectives[0]),
            ))
        }.get(args.ga_mode)

        if chromosomes is not None:
            chromosomes = chromosomes[:args.keep] if len(chromosomes) > args.keep else chromosomes
            for idx, chromosome in enumerate(chromosomes):

                # reset thresholds
                for i, og_threshold in enumerate(og_thresholds):
                    clf.tree_.threshold[i] = og_threshold

                current_results_dir = f"{args.results_dir}/{idx}"
                os.makedirs(current_results_dir, exist_ok=True)

                # translate the chromosome to thresholds
                new_thresholds, constants, bits = translate_chromosome(
                    chromosome=chromosome,
                    bitwidth=info['bitwidth'],
                    leeway=info['leeway'],
                    candidates=info['candidates']
                )
                # add new thresholds (constants) to decision tree
                new_thresholds_i = iter(new_thresholds)
                for i in range(len(clf.tree_.threshold)):
                    if clf.tree_.threshold[i] > 0:
                        clf.tree_.threshold[i] = next(new_thresholds_i)

                # save bits per feature for later use, whether the same or different
                assert bits != [] or info['bitwidth'] is not None
                bits = [info['bitwidth']] * len(constants) if bits == [] else bits
                with open(f'{current_results_dir}/inp_bits.pkl', 'wb') as f:
                    pickle.dump(bits, f)
                # save the decision tree object with pickle
                with open(f"{current_results_dir}/dtree.pkl", "wb") as f:
                    pickle.dump(clf, f)

                # get accuracy of approximate classifier
                y_pred = clf.predict(data['x_test'])
                acc = calculate_accuracy(data['y_test'], y_pred, 'accuracy')
                with open(f"{current_results_dir}/accuracy.txt", "w") as f:
                    f.write(str(acc))

        else:
            # save the decision tree object with pickle
            with open(f"{args.results_dir}/dtree.pkl", "wb") as f:
                pickle.dump(clf, f)

            y_pred = clf.predict(data['x_test'])
            acc = calculate_accuracy(data['y_test'], y_pred, 'accuracy')
            with open(f"{args.results_dir}/accuracy.txt", "w") as f:
                f.write(str(acc))

    print_dt_info(classifier=clf)

    # export graph in dot and pdf format
    if args.to_pdf:
        dot_data = tree.export_graphviz(
            decision_tree=clf,
            node_ids=True,
        )
        graph = graphviz.Source(dot_data, format='pdf')
        graph.render(filename=f'{args.results_dir}/{dataset}_dtree_graph')

    print(f"Results were saved to: {args.results_dir}")
