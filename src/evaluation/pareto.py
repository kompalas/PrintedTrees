from glob import glob
from collections import namedtuple
from src import project_dir
import argparse
import os
import logging
import re
import pickle


logger = logging.getLogger(__name__)


def logger_cfg(args):
    logging.getLogger("matplotlib").setLevel(logging.INFO)
    logger.setLevel(logging.DEBUG)
    # formatters
    stream_formatter = logging.Formatter('%(levelname)s %(message)s')
    file_formatter = logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s', datefmt='%d/%m/%Y %H:%M:%S'
    )
    # handlers
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(stream_formatter)
    stream_handler.setLevel(logging.INFO)
    file_handler = logging.FileHandler(args.logfile, mode='w')
    file_handler.setFormatter(file_formatter)
    file_handler.setLevel(logging.DEBUG)
    # add handlers to logger
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)


def get_results_file(generation=None, results_dir=None):
    resfile = f"population{generation}.pkl"
    if generation == -1:
        resfile = "final_population.pkl"

        if not os.path.exists(f"{results_dir}/{resfile}"):
            all_pop_files = glob(f"{results_dir}/population*.pkl")
            assert all_pop_files != []
            max_gen = max([
                int(re.search("population(\d+).pkl", resfile).group(1)) for resfile in all_pop_files
            ])
            resfile = f"population{max_gen}.pkl"

    return resfile


def extract_fronts(population):
    Individual = namedtuple('Individual', ['objectives', 'features'])
    all_fronts = []
    for front in population:
        all_features, all_objectives = front
        population_front = []
        for indiv_id, (features, objectives) in enumerate(zip(all_features, all_objectives)):
            ind = Individual(features=features, objectives=objectives)
            population_front.append(ind)
        all_fronts.append(population_front)

    return all_fronts


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Evaluate fronts from a specified GA experiment")
    parser.add_argument("--results-dir", "-rd", help="Set the directory where GA results are stored")
    parser.add_argument("--generation", "-g", type=int, default=-1, help="Set generation to extract results")
    args = parser.parse_args()

    assert args.results_dir is not None
    resfile = get_results_file(generation=args.generation, results_dir=args.results_dir)
    logger.info(f"Results were loaded from {args.results_dir}/{resfile}")

    with open(f"{args.results_dir}/{resfile}", "rb") as f:
        pop = pickle.load(f)
    with open(f"{args.results_dir}/clf.pkl", "rb") as f:
        data, clf, candidates = pickle.load(f)

    all_fronts = extract_fronts(population=pop)

    logger.info(f"Results were stored in {args.results_dir}")
    # logger.info(f"Results were stored in {args.results_dir}")

