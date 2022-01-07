"""Contains main object to control the evolution of the genetic algorithm"""
# from copy import deepcopy
from glob import glob
import logging
import os
import pickle
import shutil
from datetime import datetime
from src.nsga2.utils import NSGA2Utils
from src.nsga2.population import Population
from time import time

logger = logging.getLogger(__name__)


class Evolution:
    def __init__(
            self,
            problem,
            num_of_generations=1000, num_of_individuals=100,
            num_of_tour_participants=2, tournament_prob=0.8,
            crossover_param=0.9, mutation_param=0.1,
            threads=1, save_frequency=1
            ):
        """
        Class to execute the evolution of the genetic algorithm
        ----------
        problem : holds problem-specific information regarding the structure of
            the chromosomes
        num_of_generations : Number of generation to run the evolution.
            The default is 1000.
        num_of_individuals : Number of individuals in the population.
            The default is 100.
        num_of_tour_particips : Numnber of individuals to participate in the
            tournament selection. The default is 2.
        tournament_prob : Probability to change selection during tournament
            selection (higher leads to keeping the first random participant more
            often). The default is 0.9.
        crossover_param : Used in Simulated Binary Crossover. The default is 2.
        mutation_param : Used in polynomial mutation. The default is 5.
        """

        self.utils = NSGA2Utils(
            problem=problem,
            num_of_individuals=num_of_individuals,
            num_of_tour_participants=num_of_tour_participants,
            tournament_prob=tournament_prob,
            crossover_param=crossover_param,
            mutation_param=mutation_param,
            threads=threads
        )
        logger.info(f"Results for this run are saved in {self.utils.problem.resdir}")
        self.population = None
        self.num_of_generations = num_of_generations
        self.num_of_individuals = num_of_individuals
        self.save_frequency = save_frequency

    def evolve(self):
        """Main function for evolution of Genetic Algorithm"""
        self.on_start()

        # initialize and sort population in fronts
        s = time()
        self.population = self.utils.create_initial_population()
        logger.info(f"Created initial population in time: {time() - s:.3f}")

        s = time()
        self.utils.fast_nondominated_sort(self.population)
        logger.debug(f"Initial non-dominated sort time: {time() - s:.3f}")

        # calculate crowding distance
        s = time()
        for front in self.population.fronts:
            self.utils.calculate_crowding_distance(front)
        logger.debug(f"Initial calculation of crowding distance in time: {time() - s:.3f}s")

        # iterate for given generations
        for i in range(self.num_of_generations):
            s = time()

            # create children
            ss = time()
            children = self.utils.create_children(self.population)
            logger.debug(f"{len(children)} children created")
            logger.info(f"Created children in time: {time() - ss:.3f}")

            # merge parent population with children
            ss = time()
            self.population.extend(children)
            logger.debug(f"Extending population with children in time: {time() - ss:.3f}")

            # sort merged population, which now becomes parent population
            ss = time()
            self.utils.fast_nondominated_sort(self.population)
            logger.debug(f"Sorted extended population in time: {time() - ss:.3f}")

            new_population = Population()
            front_num = 0
            ss = time()
            # populate new population, front by front
            while len(new_population) + len(self.population.fronts[front_num]) <= self.num_of_individuals:

                # calculate crowding distance of current front
                self.utils.calculate_crowding_distance(
                    self.population.fronts[front_num]
                )
                new_population.extend(self.population.fronts[front_num])
                front_num += 1
            logger.debug(f"Calculated crowding distance of extended population in time: {time() - ss:.3f}")

            # calculate crowding distance of last front, which overflows the
            # extended population (needs to be truncated)
            ss = time()
            self.utils.calculate_crowding_distance(
                self.population.fronts[front_num]
            )
            # sort last front by crowding distance
            self.population.fronts[front_num].sort(
                key=lambda individual: individual.crowding_distance,
                reverse=True
            )
            # the last individuals, as determined by crowding distance, are discarded
            new_population.extend(
                self.population.fronts[front_num]
                [0:self.num_of_individuals - len(new_population)]
            )
            logger.debug(f"New population length: {len(new_population)}")
            logger.debug(f"Truncated last front by crowding distance in time: {time() - ss:.3f}")

            # turn the final population into the parent population for the next generation
            # returned_population = self.population
            self.population = new_population

            # sort new population and calculate crowding distance
            ss = time()
            self.utils.fast_nondominated_sort(self.population)
            logger.debug(f"Sorted truncated population in time: {time() - ss:.3f}")

            ss = time()
            for front in self.population.fronts:
                self.utils.calculate_crowding_distance(front)
            logger.debug(f"Calculated crowding distance of parent population in time: {time() - ss:.3f}")

            # log information about current generation
            t = time() - s
            self.on_generation(i, t)

        self.on_completion()

    def on_start(self):
        """Utility function at beginning of evolution"""
        os.makedirs(self.utils.problem.resdir, exist_ok=True)
        files_to_rm = glob(f"{self.utils.problem.resdir}/population*.pkl")
        for file_to_rm in files_to_rm:
            os.remove(file_to_rm)

        # log information to start
        start_time = datetime.now()
        logger.info("----------------------------------")
        logger.info("Started at {}".format(start_time.strftime("%d/%m/%Y %H:%M:%S")))
        logger.info("---------- Generation 0 ----------")

    def on_generation(self, generation, time_elapsed):
        """Utility function at the end of each generation"""
        # save population to file
        if self.save_frequency != -1 and generation + 1 % self.save_frequency == 0:
            with open(self.utils.problem.resdir + f'/population{generation}.pkl', 'wb') as f:
                # save only the chromosomes and objective values
                simplified_fronts = []
                for front in self.population.fronts:
                    features, objectives = [], []
                    for individual in front:
                        features.append(individual.features)
                        objectives.append(individual.objectives)
                    simplified_fronts.append([features, objectives])

                pickle.dump(simplified_fronts, f)
            logger.debug(f"Saving current population in {self.utils.problem.resdir}/population{generation}.pkl")

        # log information
        logger.info(f"Pareto front contains {len(self.population.fronts[0])} solutions")
        # separate each objective into a tuple and print its range
        grouped_objectives = list(zip(*[ind.objectives for ind in self.population.fronts[0]]))
        for obj_idx, obj_list in enumerate(grouped_objectives):
            logger.info(f"Objective {obj_idx} ranges: {min(obj_list):.3e} -> {max(obj_list):.3e}")

        for i, front in enumerate(self.population.fronts[1:]):
            logger.debug(f"Front {i+1}: {len(front)} solutions")
        logger.info(f"Generation time: {time_elapsed:.3f}s")
        logger.info(f"------- Ended generation {generation} -------")
        if generation < self.num_of_generations - 1:
            logger.info(f"---------- Generation {generation + 1} ----------")

    def on_completion(self):
        """Utility function at the end of the evolution"""
        final_time = datetime.now()
        logger.info("Ended at {}".format(final_time.strftime("%d/%m/%Y %H:%M:%S")))
        logger.info("------------------------------------")

        if self.save_frequency != -1:
            with open(self.utils.problem.resdir + f'/final_population.pkl', 'wb') as f:
                # save only the chromosomes and objective values
                simplified_fronts = []
                for front in self.population.fronts:
                    features, objectives = [], []
                    for individual in front:
                        features.append(individual.features)
                        objectives.append(individual.objectives)
                    simplified_fronts.append([features, objectives])

                pickle.dump(simplified_fronts, f)

        logger.info(f"Saved final population in {self.utils.problem.resdir}/final_population.pkl")
