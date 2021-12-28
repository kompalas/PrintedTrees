import random
import logging.config
import logging
import os
import warnings
import pandas as pd
import numpy as np
from src import project_dir
from glob import glob
from multiprocessing import cpu_count
from datetime import datetime


__all__ = [
    'env_cfg', 'args_cfg', 'logging_cfg', 'get_area_lut', 'get_candidates'
]

logger = logging.getLogger(__name__)


def env_cfg(args):
    """Configure execution environment and command line arguments"""
    args_cfg(args)
    logging_cfg(args)


def args_cfg(args):
    """Configure command line arguments and check for errors"""
    assert args.generations >= 1, \
        f"Invalid number of generations {args.generations}. Set a positive number of generations."
    assert args.population_size >= 1, \
        f"Invalid population size {args.population_size}. Set a positive number for the population size."
    assert args.mutation_probability is None or 0 <= args.mutation_probability <= 1, \
        f"Invalid mutation probability {args.mutation_probability}. Set mutation probability to " \
        f"a real number between 0 and 1."
    assert 0 <= args.crossover_probability <= 1, \
        f"Invalid crossover probability {args.crossover_probability}. Set crossover probability to a " \
        f"real number between 0 and 1."
    if args.tournament_participants is not None:
        assert 0 < args.tournament_participants < 1,\
            f"Invalid percentage of tournament participants {args.tournament_participants}. Select a float number " \
            f"between 0 and 1, without 0 or 1."
    assert 0 <= args.tournament_probability <= 1, \
        f"Invalid tournament probability {args.tournament_probability}. Set tournament probability to a real number " \
        f"between 0 and 1."
    assert args.threads > 0,\
        f"Invalid number of threads given {args.threads}. Set as a positive integer."
    if args.threads > cpu_count():
        warnings.warn(f"Number of threads too large ({args.threads}). Setting to maximum available number of"
                      f"threads: {cpu_count()}")
        args.threads = cpu_count()
    assert 0 < args.save_frequency <= args.generations or args.save_frequency == -1,\
        f"Invalid frequency {args.save_frequency}. Set a positive integer, that doesn't exceed" \
        f" the number of generations ({args.generations}) or -1 for deactivating saving results"

    time = datetime.now().strftime("%d_%m_%Y__%H_%M")
    test = 'test__' if getattr(args, 'test', None) is True else ''
    args.results_dir = f"{project_dir}/results/ga/{test}{time}"
    args.results_dir = f"{project_dir}/results/temp"
    os.makedirs(args.results_dir, exist_ok=True)


def logging_cfg(args):
    """Configure logging for entire project"""
    logging.config.fileConfig(
        f'{project_dir}/logging.conf',
        disable_existing_loggers=False,
        defaults={
            'main_log_filename': f'{project_dir}/logs/{args.dataset}_out.log',
            'all_log_filename': f'{args.results_dir}/out.log',
            'console_level': 'DEBUG' if args.verbose else 'INFO'
        }
    )


def get_area_lut(area_record_file, filter_by_input_bits=None):
    """Get the area of multiple comparators with variable input bits and constants"""
    
    area_files = glob(area_record_file)
    area_file = [file for file in area_files if '50ms' in file]
    area_file = random.sample(area_files) if not area_file else area_file[0]

    area_df = pd.read_csv(area_file, sep='\t')
    if filter_by_input_bits:
        area_df = area_df.loc[area_df['InputBits'] == filter_by_input_bits]

    area_lut = {}
    for inp_bits in area_df['InputBits'].unique():
        area_lut[inp_bits] = {}
        constants_for_inp_bits = area_df.loc[area_df['InputBits'] == inp_bits]['Constant']
        for constant in constants_for_inp_bits:
            area_lut[inp_bits][constant] = area_df.loc[
                (area_df['InputBits'] == inp_bits) & (area_df['Constant'] == constant)
            ]['Area'].iloc[0]

    return area_lut


def get_candidates(decision_tree, bitwidth=None, leeway=0):
    """Get the chromosome candidate variables"""
    thresholds = decision_tree.tree_.threshold
    assert not all(threshold < 0 for threshold in thresholds), "No valid comparators in the decision tree!"
    logger.debug(f"Original thresholds: {thresholds}")

    if bitwidth is not None:
        thresholds = np.array([threshold for threshold in thresholds if threshold > 0])
        candidates = (2**bitwidth * thresholds).astype(int)
        variables_range = [
            tuple(range(
                candidate - leeway if candidate - leeway > 1 else 1,
                candidate + leeway + 1 if candidate + leeway + 1 < 2**bitwidth - 1 else 2**bitwidth - 1
            ))
            for candidate in candidates
        ]

    else:
        thresholds = np.array([threshold for threshold in thresholds if threshold > 0])
        print(len(thresholds))
        # TODO: find a more sophisticated way to represent variable input bits in candidates
        bits = [-1] * len(thresholds)
        candidates = [thresh_or_bit for thresh_and_bits in zip(thresholds, bits) for thresh_or_bit in thresh_and_bits]
        variables_range = [
            tuple(range(1, 9)) if candidate == -1 else
            tuple(range(
                candidate - leeway if candidate - leeway > 1 else 1,
                candidate + leeway + 1
            ))
            for candidate in candidates
        ]

    logger.debug(f"Kept thresholds {len(thresholds)}: {thresholds}")
    logger.debug(f"Candidates {len(candidates)}: {candidates}")
    logger.debug(f"Variables range {len(variables_range)}: {variables_range}")
    num_of_variables = len(candidates)
    return candidates, num_of_variables, variables_range
