import logging
from sklearn import metrics

all = [
    'calculate_accuracy', 'calculate_area', 'translate_chromosome',
    'calc_fitness', 'null_objective_function'
]

logger = logging.getLogger(__name__)


def calculate_accuracy(y_true, y_pred, metric_name):
    return metrics.__dict__[metric_name + '_score'](y_true, y_pred)


def calculate_area(chromosome, constants, area_lut, bitwidth):
    if bitwidth is not None:
        if bitwidth not in area_lut:
            raise KeyError(f"Bitwidth {bitwidth} not considered in area measurements!")

        area = sum(
            area_lut[bitwidth][constant] if constant in area_lut[bitwidth] else 0
            for constant in constants
        )

    else:
        area = sum(
            area_lut[chromosome[i+1]][chromosome[i]]
            for i in range(0, len(chromosome), 2)
        )
    return area


def translate_chromosome(chromosome, bitwidth, original_thresholds):
    if bitwidth is not None:
        constants = chromosome
        chromosome_i = iter(chromosome)
        thresholds = [
            next(chromosome_i) if original_thresholds[i] > 0 else original_thresholds[i]
            for i in range(len(original_thresholds))
        ]
        bits = None
    else:
        logger.error("Variable bitwidth in the chromosome is not supported yet")
        raise NotImplementedError

    return thresholds, constants, bits


def calc_fitness(chromosome, tree, x_test, y_test, area_lut, bitwidth, original_thresholds,
                 candidates, variables_range, accuracy_metric, thread_index=None):

    assert len(chromosome) == len(candidates) == len(variables_range)

    thresholds, constants, bits_i = translate_chromosome(chromosome, bitwidth, original_thresholds)
    area = calculate_area(chromosome, constants, area_lut, bitwidth)

    thresholds_i = iter(thresholds)
    for i in range(len(original_thresholds)):
        if original_thresholds[i] > 0:
            current_bitwidth = next(bits_i) if bitwidth is None else bitwidth
            threshold = next(thresholds_i)
            tree.tree_.threshold[i] = threshold * 1/(2**current_bitwidth)

    y_pred = tree.predict(x_test)
    accuracy = calculate_accuracy(y_test, y_pred, accuracy_metric)
    accuracy_loss = 1 - accuracy

    # logger.debug("")
    # logger.debug(f"Chromosome: {chromosome}")
    # logger.debug(f"Thresholds: {thresholds}")
    # logger.debug(f"Constants: {constants}")
    # logger.debug(f"Area calc: {[area_lut[bitwidth][constant] for constant in constants]}")
    # logger.debug(f"Area: {area:.3e}")
    # logger.debug(f"New thresholds: {tree.tree_.threshold}")
    # logger.debug(f"Accuracy: {accuracy:.3e}")

    return accuracy_loss, area


def null_objective_function(*args, **kwargs):
    pass
