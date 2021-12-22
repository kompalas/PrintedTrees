from sklearn import tree
from functools import partial
from src import ALL_DATASETS, project_dir
from src.datasets import get_data
from src.utils import logging_cfg, get_area_lut
from src.nsga2.objectives import calc_fitness, null_objective_function
from src.nsga2.problem import Problem
from src.nsga2.evolution import Evolution
import argparse
import logging
import traceback


logger = logging.getLogger(__name__)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", "-d", choices=ALL_DATASETS + [dataset.lower() for dataset in ALL_DATASETS],
                        help=f"Choose a dataset. Possible choices are {' | '.join(ALL_DATASETS)}")
    parser.add_argument("--input-bits", "-ib", dest="input_bits", type=int, default=4,
                        help="Specify the input bitwidth. Default is 4 bits")
    parser.add_argument("--verbose", '-v', action='store_true',
                        help='Set to print debug logging messages to console.')
    parser.add_argument("--area-file", dest="area_file", default=f"{project_dir}/results/*/*.txt",
                        help="Specify the file where area measurements per comparator are taken")
    parser.add_argument("--num-of-objectives", "-o", dest='num_of_objectives', type=int, choices=[1, 2], default=2,
                        help='Choose the number of objectives: 1 or 2 (default)')
    parser.add_argument("--frequency", '-f', type=int, default=1, dest='save_frequency',
                        help="Specify the frequency of saving the population results, in terms of generations."
                             " Default is 1 for saving every generation")
    parser.add_argument("--threads", '-t', type=int, default=1,  # default=multiprocessing.cpu_count(),
                        help="Specify the number of threads to use for parallel execution."
                             "Default is 1 for serial execution")
    parser.add_argument("--generations", "-g", type=int, default=10,
                        help="Select number of generations. Default is 10 generations")
    parser.add_argument("--population-size", "-p", type=int, dest='population_size', default=10,
                        help="Select size of the population. Default is 10 individuals")
    parser.add_argument("--tournament-participants", "-tpart", type=float, dest='tournament_participants',
                        help="Select percentage of population for participation in tournament selection.\
                            Default is 5%% of the population")
    parser.add_argument("--tournament-probability", "-tprob", type=float, dest='tournament_probability', default=0.8,
                        help="Select probability for tournament selection [0, 1].\
                            Default is 0.8")
    parser.add_argument("--crossover-probability", "-cp", type=float, dest='crossover_probability', default=0.95,
                        help="Select probability for crossover [0, 1].\
                            Default is 0.95")
    parser.add_argument("--mutation-probability", "-mp", type=float, dest='mutation_probability',
                        help="Select probability for mutation [0, 1].\
                            Default is the reversed chromosome length")
    args = parser.parse_args()
    args.results_dir = f"{project_dir}/results"
    logging_cfg(args)
    logger.debug(f"Command line arguments: {args.__dict__}")

    classifier = tree.DecisionTreeClassifier()
    x_train, x_test, y_train, y_test = get_data(args.dataset, input_bits=args.input_bits)
    logger.debug(f"Training data: x {x_train.shape}, y {y_train.shape}")
    logger.debug(f"Test data: x {x_test.shape}, y {y_test.shape}")
    classifier.fit(x_train, y_train)

    comp_area_lut = get_area_lut(area_record_file=args.area_file, filter_by_input_bits=args.input_bits)

    objective_function = partial(
        calc_fitness,
        tree=classifier,
        x_test=x_test,
        y_test=y_test,
        area_lut=comp_area_lut,
        single_objective=args.num_of_objectives == 1,
        variables_range=variables_range
    )
    problem = Problem(
        objective_functions=[objective_function] + [null_objective_function] * (args.num_of_objectives - 1),
        num_of_variables=num_of_variables,
        variables_range=variables_range,
        variable_type='discrete',
        resdir=args.results_dir
    )
    GA = Evolution(
        problem=problem,
        num_of_generations=args.generations,
        num_of_individuals=args.population_size,
        num_of_tour_participants=int(args.tournament_participants * args.population_size)
        if args.tournament_participants is not None else int(0.05 * args.population_size),
        tournament_prob=args.tournament_probability,
        crossover_param=args.crossover_probability,
        mutation_param=args.mutation_probability
        if args.mutation_probability is not None else 1/num_of_variables,
        threads=args.threads,
        save_frequency=args.save_frequency
    )
    GA.evolve()


if __name__ == "__main__":
    try:
        main()
    except Exception:
        if logger is not None:
            # We catch unhandled exceptions here in order to log them to the log file
            # However, using the logger as-is to do that means we get the trace twice in stdout - once from the
            # logging operation and once from re-raising the exception. So we remove the stdout logging handler
            # before logging the exception
            handlers_bak = logger.handlers
            logger.handlers = [h for h in logger.handlers if type(h) != logging.StreamHandler]
            logger.error(traceback.format_exc())
            logger.handlers = handlers_bak
        raise
    except KeyboardInterrupt:
        logger.info("")
        logger.info("--- Keyboard Interrupt --- (Wait for termination)")
    finally:
        if logger.handlers:
            logfiles = [handler.baseFilename for handler in logger.handlers if type(handler) == logging.FileHandler]
            logger.info(f"Log file(s) for this run in {' | '.join(logfiles)}")




