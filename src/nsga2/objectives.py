import logging


logger = logging.getLogger(__name__)


def translate_chromosome(chromosome):
    pass


def calc_fitness(chromosome, tree, x_test, y_test, area_lut, **kwargs):
    sth = translate_chromosome(chromosome)

    accuracy = ''
    area = ''

    return accuracy, area


def null_objective_function(*args, **kwargs):
    pass