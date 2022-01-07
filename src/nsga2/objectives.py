import logging
from sklearn import metrics

all = [
    'calculate_accuracy', 'calculate_area', 'translate_chromosome',
    'calc_fitness', 'null_objective_function'
]

logger = logging.getLogger(__name__)


def calculate_accuracy(y_true, y_pred, metric_name):
    """Calculate classifier accuracy"""
    return metrics.__dict__[metric_name + '_score'](y_true, y_pred)


def calculate_area(constants, area_lut, bits):
    """Estimate the area based on the comparator constants and the input bitwidth"""
    area = 0
    for bit, constant in zip(bits, constants):
        if bit not in area_lut:
            raise KeyError(f"Bitwidth {bit} not considered in area measurements!")
        area += area_lut[bit][constant] if constant in area_lut[bit] else 0
    return area


def translate_chromosome_discrete(chromosome, bitwidth, leeway, candidates, verbose=False):
    """Deconstruct chromosome of integer-valued genes into decision tree thresholds (for accuracy calculation),
     the comparison constants (for area calculation) and the bitwidth used (per gene or uniformly)"""

    if bitwidth is not None:
        # here the chromosome only uses integers for the comparison constants (thresholds)
        constants = chromosome
        # convert back to floating point but with fixed bitwidth
        thresholds = [gene * 1/(2**bitwidth) for gene in chromosome]
        bits = []

    else:
        constants, thresholds, bits = [], [], []
        # here the chromosome mixes bitwidth and thresholds as variables
        for i, (candidate, gene) in enumerate(zip(candidates, chromosome)):
            if candidate == -1:
                bit = gene
                bits.append(bit)
            else:
                margin = gene - leeway  # gene here represents a number between [0, 2*leeway]
                constant = int(round(candidate * (2**bit))) + margin  # to an integer close to original threshold
                constant = 0 if constant < 0 else constant  # comparing with a negative constant is mute
                constants.append(constant)
                threshold = constant * 1/(2**bit)  # back to floating point for new threshold
                threshold = 1 if threshold > 1 else threshold  # no point comparing with a number
                                                               # larger than 1, all data fall in [0, 1]
                thresholds.append(threshold)

                if verbose:
                    logger.debug(f"\tcandidate {candidate}, gene {gene}")
                    logger.debug(f"\tmargin {margin}, bit {bit}, constant {constant}, threshold {threshold}")

    return thresholds, constants, bits


def translate_chromosome_continuous(chromosome, bitwidth, leeway, candidates, verbose=False):
    """Deconstruct chromosome of real-valued genes into decision tree thresholds (for accuracy calculation),
     the comparison constants (for area calculation) and the bitwidth used (per gene or uniformly)"""

    if bitwidth is not None:
        constants, thresholds, bits = [], [], []
        pass

    else:
        constants, thresholds, bits = [], [], []
        pass

    raise NotImplementedError
    return thresholds, constants, bits


def translate_chromosome(chromosome, bitwidth, leeway, candidates, gene_type='int', verbose=False):
    return {
        'int': translate_chromosome_discrete,
        'real': translate_chromosome_continuous
    }.get(gene_type)(chromosome, bitwidth, leeway, candidates, verbose)


def calc_fitness(chromosome, tree, x_test, y_test, area_lut, bitwidth, leeway, original_thresholds,
                 candidates, variables_range, accuracy_metric, gene_type, verbose=False, thread_index=None):
    """Calculate the fitness of an approximate solution"""
    assert len(chromosome) == len(candidates) == len(variables_range)

    # reset thresholds
    for i, og_threshold in enumerate(original_thresholds):
        tree.tree_.threshold[i] = og_threshold

    thresholds, constants, bits = translate_chromosome(
        chromosome=chromosome,
        bitwidth=bitwidth,
        leeway=leeway,
        candidates=candidates,
        gene_type=gene_type,
        verbose=verbose
    )
    area = calculate_area(
        constants=constants,
        bits=bits if bitwidth is None else [bitwidth] * len(constants),
        area_lut=area_lut
    )

    thresholds_i = iter(thresholds)
    for i in range(len(original_thresholds)):
        if original_thresholds[i] > 0:
            tree.tree_.threshold[i] = next(thresholds_i)

    y_pred = tree.predict(x_test)
    accuracy = calculate_accuracy(y_test, y_pred, accuracy_metric)
    accuracy_loss = 1 - accuracy

    if verbose:
        logger.debug(f"Chromosome: {chromosome}")
        logger.debug(f"Constants: {constants}")
        logger.debug(f"Bits: {bits}")
        logger.debug(f"Thresholds: {thresholds}")
        logger.debug(f"New thresholds: {tree.tree_.threshold}")
        logger.debug(f"Accuracy: {accuracy:.3e}")
        logger.debug(f"Area: {area:.3e}")
        logger.debug("\n")

    return accuracy_loss, area


def null_objective_function(*args, **kwargs):
    """Dummy objective function"""
    pass
