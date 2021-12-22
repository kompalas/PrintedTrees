class Population:

    def __init__(self):
        self.population = []
        self.fronts = [[]]

    def __len__(self):
        return len(self.population)

    def __iter__(self):
        return self.population.__iter__()

    def extend(self, new_individuals):
        self.population.extend(new_individuals)

    def append(self, new_individual):
        self.population.append(new_individual)

    def clear_population(self):
        self.population.clear()

    def clear_fronts(self):
        for front in self.fronts:
            front.clear()

    def clear_all(self):
        self.clear_population()
        self.clear_fronts()
