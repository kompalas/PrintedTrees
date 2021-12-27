from os import path
from glob import glob

ALL_DATASETS = [
    'Arrhythmia', 'Cardio', 'PenDigits', 'GasID', 'RedWine', 'WhiteWine', 'HAR',
    'Mammographic', 'Seeds', 'Balance',  'Breast_Cancer', 'Vertebral'
]

ALL_ACCURACY_METRICS = ['accuracy', 'f1', 'precision', 'recall']

project_dir = path.dirname(path.dirname(__file__))

MAX_ERROR = 2**33
MAX_DELAY = 10
MAX_STDEV = 1

MAX_CROWDING_DISTANCE = 10**9