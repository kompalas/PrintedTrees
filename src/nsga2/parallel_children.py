from time import  time
import logging

logger = logging.getLogger(__name__)


def create_children_core_outside(population, thread_id=None, selection_f=None, crossover_f=None, mutation_f=None):
    """Core function to create and evaluate children"""
    # select two non-equal parents
    parent1 = selection_f(population)
    parent2 = parent1
    while parent1 == parent2:
        parent2 = selection_f(population)

    # crossover the parents' chromosomes to get children
    children = crossover_f(parent1, parent2)
    for child in children:
        # stochastically mutate the children's chromosomes
        mutation_f(child)
        # calculate their objective function
        s = time()
        child.calculate_objectives(thread_index=thread_id)
        logger.debug(f"Child (in thread {thread_id}) evaluated in time: {time() - s:.3f}s")
    return children


def create_children_per_thread_outside(population, thread_id=None,
                                       sols_per_thread=None, remaining_sols=None, num_of_children_to_return=None,
                                       selection_function=None, crossover_function=None, mutation_function=None):
    """Calculation of a single thread: Create children from an initial population"""
    # see 'create_initial_population_per_thread' for info on per-thread segments
    start = thread_id * sols_per_thread + min(remaining_sols, thread_id)
    end = start + sols_per_thread if thread_id < remaining_sols else start + sols_per_thread + 1

    part_of_population = []
    for idx in range(start, end, num_of_children_to_return):
        children = create_children_core_outside(
            population, thread_id, selection_function, crossover_function, mutation_function
        )
        part_of_population.extend(children)
    return part_of_population


def create_children_parallel_outside(self, population):
    """Create children from a parent population. Schedule in parallel an equal amount of serial evaluations for
     each thread *without* carrying the utils object (self)"""
    children = []
    with cf.ThreadPoolExecutor(max_workers=self.threads) as executor:
        futures = {
            executor.submit(
                create_children_per_thread_outside, population=population, thread_id=thread_id,
                sols_per_thread=self.sols_per_thread, remaining_sols=self.remaining_sols,
                num_of_children_to_return=self.num_of_children_to_return,
                selection_function=self.__selection_f, crossover_function=self.__crossover_f,
                mutation_function=self.__mutation_f
            )
            for thread_id in range(self.threads)
        }
        for future_object in cf.as_completed(futures):
            children.extend(future_object.result())
    return children
