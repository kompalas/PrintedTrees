from copy import deepcopy


class Individual(object):
    """Individual to be used for evolution in a GA"""
    def __init__(self, objective_functions):
        """
        Initialize individual
        ----------
        objective_functions : list of functions to be used for fitness evaluation
        """
        self.rank = None
        self.crowding_distance = None
        self.domination_count = None
        self.dominated_solutions = []
        self.features = []
        self.objectives = []
        self.objectives_calculated = False
        self.objective_functions = objective_functions

    def set_features(self, new_features):
        """Set the features of the chromosome of the individual"""
        self.features = deepcopy(new_features)
        self.objectives_calculated = False

    def set_objectives(self, new_objectives):
        """Set the objectives of an individual to new values"""
        self.objectives = deepcopy(new_objectives)
        self.objectives_calculated = True

    def __eq__(self, other):
        """Equal chromosomes belong to equal individuals"""
        if isinstance(self, other.__class__):
            return self.features == other.features
        return False

    def __hash__(self):
        return hash(tuple(self.features))

    def __len__(self):
        """Return chromosome length"""
        return len(self.features)

    def calculate_objectives(self, thread_index=None):
        """Calculate the objective functions. Index is a parameter used for
        identifying an individual during parallel execution"""
        if not self.objectives_calculated:
            # self.objectives = [f(self.features) for f in self.objective_functions]

            # NOTE: use this (the 0 index) for specific case: only one objective 
            # function returning all objective values
            self.objectives = self.objective_functions[0](
                self.features,
                thread_index=thread_index
                )[:len(self.objective_functions)]
            self.objectives_calculated = True
        return self.objectives

    def dominates(self, other_individual):
        """Check if this instance dominates another individual"""
        and_condition = True
        or_condition = False
        for first, second in zip(self.objectives, other_individual.objectives):
            and_condition = and_condition and first <= second
            or_condition = or_condition or first < second
        return and_condition and or_condition
