import concurrent.futures as cf
from src.nsga2.population import Population
from functools import partial
from time import time
from copy import deepcopy
import random
import logging
logger = logging.getLogger(__name__)


class NSGA2Utils:
    """
    Utility functions for the NSGA-II algorithm. More information in:
        Deb, K., Pratap, A., Agarwal, S., & Meyarivan,
        "A fast and elitist multiobjective genetic algorithm: NSGA-II."
        IEEE transactions on evolutionary computation 6.2 (2002): 182-197.
    """
    def __init__(
            self, problem, num_of_individuals=100,
            num_of_tour_participants=2, tournament_prob=0.8,
            crossover_param=0.9, mutation_param=0.1,
            threads=1
    ):

        self.problem = problem
        self.num_of_individuals = num_of_individuals
        self.num_of_tour_participants = num_of_tour_participants
        self.tournament_prob = tournament_prob

        # TODO: find a better way to assign params for 'real' variable type
        self.crossover_param = crossover_param if self.problem.variable_type == 'int' else 2
        self.mutation_param = mutation_param if self.problem.variable_type == 'int' else 5

        # parallel execution variables
        self.threads = threads
        self.sols_per_thread = self.num_of_individuals // self.threads
        self.remaining_sols = self.num_of_individuals % self.threads

        self.starts = {
            thread_id:  thread_id * self.sols_per_thread + min(self.remaining_sols, thread_id)
            for thread_id in range(self.threads)
        }
        self.ends = {
            i: start + self.sols_per_thread if i >= self.remaining_sols else start + self.sols_per_thread + 1
            for i, start in enumerate(self.starts.values())
        }

        # activate serial or parallel execution based on number of threads
        if self.threads == 1:
            self.create_children = self.create_children_serial
            self.create_initial_population = self.create_initial_population_serial
            logger.info("Serial execution on a single thread.")
        else:
            self.create_children = self.create_children_parallel
            self.create_initial_population = self.create_initial_population_parallel

        # select selection, crossover and mutation functions based on the type
        # of genes in the chromosomes: continues values or discrete
        self.__selection_factory = {
            'real': self.tournament,
            'int': self.tournament
        }
        self.__crossover_factory = {
            'real': self.sbc_crossover,
            'int': self.uniform_crossover_single_child
        }
        self.__mutation_factory = {
            'real': self.pol_mutation,
            'int': self.random_mutation
        }
        self.__selection_f = self.__selection_factory.get(
            self.problem.variable_type
        )
        self.__crossover_f = self.__crossover_factory.get(
            self.problem.variable_type
        )
        self.__mutation_f = self.__mutation_factory.get(
            self.problem.variable_type
        )

        logger.debug(f"Solutions per thread: {self.sols_per_thread}")
        logger.debug(f"Remaining solutions: {self.remaining_sols}")

        logger.debug(f"Tournament participants: {self.num_of_tour_participants}")
        logger.debug(f"Selection function: {self.__selection_f.__name__}")
        logger.debug(f"Crossover function: {self.__crossover_f.__name__}")
        logger.debug(f"Mutation function: {self.__mutation_f.__name__}")

    def create_initial_population_serial(self):
        """Create population of random individuals using a single process"""
        population = Population()
        for ind_id in range(self.num_of_individuals):
            individual = self.problem.generate_individual()
            # calculate the objectives of each individual
            self.problem.calculate_objectives(individual, thread_index=0)
            population.append(individual)
        return population

    def create_initial_population_per_thread(self, thread_id):
        """Execute the serial operation of a single thread to create individuals
        for the initial population"""
        # population should be partitioned to <self.threads> slices, each with
        # <self.sols_per_thread> individuals plus some of the <self.remaining_sols>
        # individuals, equally distributed to all available threads
        start = thread_id*self.sols_per_thread + min(self.remaining_sols, thread_id)
        end = start + self.sols_per_thread
        if thread_id < self.remaining_sols:
            end += 1

        individuals = []
        for ind_id in range(start, end):
            individual = self.problem.generate_individual()
            # calculate the objectives of each individual
            self.problem.calculate_objectives(individual, thread_index=thread_id)
            individuals.append(individual)
        return individuals

    def create_initial_population_parallel(self, *args):
        """Create population of random individuals using multiple processes"""
        population = Population()

        with cf.ProcessPoolExecutor(max_workers=self.threads) as executor:
            for part_of_population in executor.map(
                    self.create_initial_population_per_thread,
                    range(self.threads)
            ):
                population.extend(part_of_population)
        return population

    def create_and_evaluate_children_core(self, population, thread_id=None):
        """Core function to create and evaluate children"""
        # select two non-equal parents
        parent1 = self.__selection_f(population)
        parent2 = parent1

        while parent1 == parent2:
            parent2 = self.__selection_f(population)

        # crossover the parents' chromosomes to get children
        children = self.__crossover_f(parent1, parent2)
        for child in children:
            # stochastically mutate the children's chromosomes
            self.__mutation_f(child)
            # calculate their objective function
            self.problem.calculate_objectives(child, thread_index=thread_id)
        return children

    def create_children_parallel(self, population):
        """Create children from a parent population. Schedule in parallel all children evaluations"""
        children = []
        fit_core = partial(self.create_and_evaluate_children_core, population)
        with cf.ProcessPoolExecutor(max_workers=self.threads) as executor:
            for part_of_population in executor.map(fit_core, range(self.threads)):
                children.extend(part_of_population)
        return children

    def create_children_serial(self, population):
        """Create children from a parent population. Single process"""
        children = []

        while len(children) < len(population):
            some_children = self.create_and_evaluate_children_core(population=population, thread_id=0)
            children.extend(some_children)
        return children

    def fast_nondominated_sort(self, population):
        """Function to sort population into fronts based on domination"""
        population.fronts = [[]]
        for individual in population:
            individual.domination_count = 0
            individual.dominated_solutions = []
            for other_individual in population:
                if individual.dominates(other_individual):
                    individual.dominated_solutions.append(other_individual)
                elif other_individual.dominates(individual):
                    individual.domination_count += 1
            if individual.domination_count == 0:
                individual.rank = 0
                population.fronts[0].append(individual)

        i = 0
        while len(population.fronts[i]) > 0:
            temp = []
            for individual in population.fronts[i]:
                for other_individual in individual.dominated_solutions:
                    other_individual.domination_count -= 1
                    if other_individual.domination_count == 0:
                        other_individual.rank = i+1
                        temp.append(other_individual)
            i = i+1
            population.fronts.append(temp)

    def calculate_crowding_distance(self, front):
        """Calculate crowding distance of a particular front"""
        if len(front) > 0:
            solutions_num = len(front)
            for individual in front:
                individual.crowding_distance = 0

            for m in range(len(front[0].objectives)):
                front.sort(key=lambda individual: individual.objectives[m])
                front[0].crowding_distance = self.problem.max_objectives[m]
                front[solutions_num-1].crowding_distance = self.problem.max_objectives[m]
                for index, value in enumerate(front[1:solutions_num-1]):
                    front[index].crowding_distance = (front[index+1].crowding_distance - front[index-1].crowding_distance) /\
                                                     (self.problem.max_objectives[m] - self.problem.min_objectives[m])

                # front[0].crowding_distance = MAX_CROWDING_DISTANCE
                # front[solutions_num-1].crowding_distance = MAX_CROWDING_DISTANCE
                # m_values = [individual.objectives[m] for individual in front]
                # scale = max(m_values) - min(m_values)
                # if scale == 0:
                #     scale = 1
                # for i in range(1, solutions_num-1):
                #     front[i].crowding_distance += (front[i+1].objectives[m] - front[i-1].objectives[m])/scale

    def crowding_operator(self, individual, other_individual):
        """Compare two individuals based on their rank and crowding distance"""
        if (individual.rank < other_individual.rank) or \
            ((individual.rank == other_individual.rank) and (individual.crowding_distance > other_individual.crowding_distance)):
            return 1
        else:
            return -1

    def sbc_crossover(self, parent1, parent2):
        """Simulated binary crossover for real-valued genes"""
        child1 = self.problem.generate_individual()
        child2 = self.problem.generate_individual()

        for i in range(len(child1.features)):
            beta = self.__get_beta()
            x1 = (parent1.features[i] + parent2.features[i])/2
            x2 = abs((parent1.features[i] - parent2.features[i])/2)
            child1.features[i] = x1 + beta*x2
            child2.features[i] = x1 - beta*x2
        return child1, child2

    def uniform_crossover_single_child(self, *parents):
        """Uniform crossover for discrete-valued genes"""
        child = self.problem.generate_individual()

        for i in range(len(child.features)):
            # if crossover is selected for this gene...
            if random.random() < self.crossover_param:
                # ...the child randomly takes a chromosome of one parent
                parent = random.choice(parents)
                child.features[i] = parent.features[i]
        # return as a tuple
        return child,

    def __get_beta(self):
        u = random.random()
        if u <= 0.5:
            return (2*u)**(1/(self.crossover_param+1))
        return (2*(1-u))**(-1/(self.crossover_param+1))

    def pol_mutation(self, child):
        """Polynomial mutation for real-valued genes"""
        for gene in range(len(child.features)):
            u, delta = self.__get_delta()
            if u < 0.5:
                child.features[gene] += delta*(child.features[gene] - self.problem.variables_range[gene][0])
            else:
                child.features[gene] += delta*(self.problem.variables_range[gene][1] - child.features[gene])
            # if new features are too high, clip to highest boundaries
            if child.features[gene] < self.problem.variables_range[gene][0]:
                child.features[gene] = self.problem.variables_range[gene][0]
            elif child.features[gene] > self.problem.variables_range[gene][1]:
                child.features[gene] = self.problem.variables_range[gene][1]

    def __get_delta(self):
        u = random.random()
        if u < 0.5:
            return u, (2*u)**(1/(self.mutation_param + 1)) - 1
        return u, 1 - (2*(1-u))**(1/(self.mutation_param + 1))

    def random_mutation(self, child):
        """Random mutation for discrete-valued genes"""
        for gene in range(self.problem.num_of_variables):
            # randomly change a selected number of genes
            if self.__choose_with_prob(self.mutation_param):
                child.features[gene] = random.choice([
                    vrange for vrange in self.problem.variables_range[gene] if vrange != child.features[gene]
                ])

    def tournament(self, population):
        """Tournament selection function"""
        participants = random.sample(
            population.population, self.num_of_tour_participants
        )
        best = None
        for participant in participants:
            if best is None or \
                    (self.crowding_operator(participant, best) == 1
                     and self.__choose_with_prob(self.tournament_prob)):
                best = participant
        return best

    def __choose_with_prob(self, prob):
        """Assess if a given probability exceeds a randomly obtained one"""
        if random.random() <= prob:
            return True
        return False
