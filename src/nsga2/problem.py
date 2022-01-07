from functools import partial
from src.nsga2.individual import Individual
import numpy as np
import pandas as pd
import random
import logging

logger = logging.getLogger(__name__)


class Problem:
    """Class to keep chromosome-specific attributes"""
    def __init__(
            self, objective_functions, num_of_variables, variables_range, variable_type, resdir=None
    ):
        """
        Initialize problem object
        ----------
        objectives : objective functions for fitness evaluation
        num_of_variables : length of a chromosome
        variables_range : range of values for the chromosome genes,
            specified as a tuple for each gene. 
            In the case of continuous variable_type: (low, high)
            In the case of discrete variable_type: (possible values)
        variable_type : type of variable to use: continuous, discrete
        same_range : boolean, whether to use the same range for all variables
        """

        self.num_of_objectives = len(objective_functions)
        self.num_of_variables = num_of_variables
        self.resdir = resdir

        self.objective_functions = objective_functions

        # configure function to generate new random individuals
        self.__generation_factory = {
            'real': self.generate_individual_continuous,
            'int': self.generate_individual_discrete
        }
        self.variable_type = variable_type
        # depending on the type of variable, choose generation function
        self.generate_individual = self.__generation_factory.get(self.variable_type)

        # populate a list with a range for every gene in a chromosome
        assert len(variables_range) == self.num_of_variables
        self.variables_range = variables_range

    def generate_individual_continuous(self):
        """Generate individual with real-valued genes"""
        individual = Individual(self.objective_functions)
        features = [random.uniform(*variable_range) for variable_range in self.variables_range]
        individual.set_features(features)
        return individual

    def generate_individual_discrete(self):
        """Generate individual with discrete-valued random genes, weighted towards a value"""
        # last option gets a higher chance of being selected
        # TODO: consider not hard coding the weights
        individual = Individual(self.objective_functions)
        features = [
            random.choices(
                variable_range,
                # weights=[1]*(len(variable_range) - 1) + [50],
                k=1
            )[0]
            for variable_range in self.variables_range
        ]
        individual.set_features(features)
        return individual
