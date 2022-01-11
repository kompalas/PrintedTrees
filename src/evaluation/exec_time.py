from src import ALL_DATASETS, project_dir
from src.evaluation.test_clf import logger_cfg
from src.datasets import get_data
from src.utils import get_candidates, get_area_lut
from src.nsga2.objectives import calc_fitness
from src.nsga2.problem import Problem
from src.nsga2.utils import NSGA2Utils
from sklearn import tree
from functools import partial
from copy import deepcopy
from random import choice
from time import time
import argparse
import logging
import numpy as np

logger = logging.getLogger(__name__)
logger_cfg(
    logger=logger,
    logfile=f"{project_dir}/logs/exec_time.log"
)

parser = argparse.ArgumentParser()
parser.add_argument('--num-of-trials', '-n', dest='num_of_trials', type=int, default=50,
                    help='Select the number of trials to average the execution time.')
parser.add_argument("--max-depth", "-md", type=int, help="Select the 'max_depth' parameter of the decision tree")
parser.add_argument("--input-bits", "-b", dest="input_bits", type=int,
                    help="Specify the input bitwidth. If not specified, the input bits will be part of the "
                         "exploration, as an additional variable in the chromosome")
parser.add_argument("--margin", "-m", type=int, default=5,
                    help="Specify the margin (+-) to consider for each approximation candidate")
parser.add_argument("--verbose", '-v', action='store_true',
                    help='Set to print debug logging messages to console.')
parser.add_argument("--area-file", dest="area_file", default=f"{project_dir}/results/*/*.txt",
                    help="Specify the file where area measurements per comparator are taken")
parser.add_argument('--gene-type', '-gt', choices=['real', 'int'], default='real', dest='gene_type',
                    help="Specify the numerical type of chromosome genes: 'real' or 'int'")
args = parser.parse_args()
logger.debug(f"Command line arguments: {args.__dict__}")
logger.info(f"Calculating the average execution time of a single random chromosome for each circuit ({args.num_of_trials} trials)")

for dataset in ALL_DATASETS:

    classifier = tree.DecisionTreeClassifier(criterion='entropy', max_depth=args.max_depth)
    try:
        x_train, x_test, y_train, y_test = get_data(dataset.lower(), input_bits=args.input_bits)
    except NotImplementedError:
        logger.info(f"Dataset '{dataset}' is not implemented.")
        logger.info("----------------------------------------------------")
        continue

    classifier.fit(x_train, y_train)
    y_pred = classifier.predict(x_test)
    logger.info(f"Initial test accuracy: {len(y_pred[y_pred == y_test])/len(y_pred):.3e}")
    
    candidates, num_of_variables, variables_range = get_candidates(
        classifier, bitwidth=args.input_bits, leeway=args.margin, gene_type=args.gene_type
    )
    comp_area_lut = get_area_lut(area_record_file=args.area_file, filter_by_input_bits=args.input_bits)

    objective_function = partial(
        calc_fitness,
        tree=classifier,
        x_test=x_test,
        y_test=y_test,
        area_lut=comp_area_lut,
        bitwidth=args.input_bits,
        leeway=args.margin,
        original_thresholds=deepcopy(classifier.tree_.threshold),
        candidates=candidates,
        variables_range=variables_range,
        accuracy_metric='accuracy',
        gene_type=args.gene_type,
        verbose=args.verbose
    )
    problem = Problem(
        objective_functions=[objective_function] * 2,
        num_of_variables=num_of_variables,
        variables_range=variables_range,
        variable_type=args.gene_type,
        resdir=None
    )
    utils = NSGA2Utils(
        problem=problem,
        num_of_individuals=50,
        threads=1
    )
    population = utils.create_initial_population()
    
    times = []
    for _ in range(args.num_of_trials):
        ind = choice([individual for individual in population])

        s = time()
        objective_function(ind.features)
        t = time() - s
        times.append(t)

    logger.info(f"{dataset}: {np.average(times):.3e}s")
    logger.info("----------------------------------------------------")
