from src import project_dir
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
import pandas as pd


__all__ = [
    'get_data',
    'get_arrhythmia', 'get_balance', 'get_breast_cancer', 'get_cardio', 'get_gasid', 'get_har',
    'get_mammogr', 'get_pendigits', 'get_redwine', 'get_seeds', 'get_vertebral', 'get_whitewine'
]


def get_data(dataset, input_bits=None, test_size=0.3):
    """Retrieve training and test data from a given dataset"""
    dataset_factory = {
        'arrhythmia': get_arrhythmia,
        'balance': get_balance,
        'breast_cancer': get_breast_cancer,
        'cardio': get_cardio,
        'gasid': get_gasid,
        'har': get_har,
        'mammographic': get_mammogr,
        'pendigits': get_pendigits,
        'redwine': get_redwine,
        'seeds': get_seeds,
        'vertebral': get_vertebral,
        'whitewine': get_whitewine
    }
    get_dataset_f = dataset_factory.get(dataset.lower(), None)
    if get_dataset_f is None:
        raise NotImplementedError(f"Dataset {dataset} is not implementd.")

    dataX, dataY = get_dataset_f()
    # scale in the interval [0, 1]
    scaler = MinMaxScaler(feature_range=(0, 1))
    dataX = scaler.fit_transform(dataX.to_numpy())

    if input_bits is not None:
        # restrict inputs to input_bits
        dataX = 1/(2**input_bits) * (2**input_bits * dataX).astype(int)

    x_train, x_test, y_train, y_test = train_test_split(dataX, dataY, test_size=test_size)
    return x_train, x_test, y_train, y_test


def get_arrhythmia():
    df = pd.read_csv(f"{project_dir}/datasets/data/arrhythmia/arrhythmia.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_balance():
    df = pd.read_csv(f"{project_dir}/datasets/data/balance_scale/balance_scale.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_breast_cancer():
    df = pd.read_csv(f"{project_dir}/datasets/data/breast_cancer/breast-cancer-wisconsin.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_cardio():
    # df = pd.read_excel(
    #     f"{project_dir}/datasets/files/CTG.xls",
    #     sheet_name="Raw Data", usecols=list(range(3, 40)), skiprows=[1, 2128, 2129, 2130, 2131]
    # )
    # dataX = df.to_numpy()

    df = pd.read_csv(f"{project_dir}/datasets/data/cardio/cardio.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_gasid():
    raise NotImplementedError


def get_har():
    df = pd.read_csv(f"{project_dir}/datasets/data/har/har.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_mammogr():
    df = pd.read_csv(f"{project_dir}/datasets/data/mammographic/mammographic_masses.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_pendigits():
    df = pd.read_csv(f"{project_dir}/datasets/data/pendigits/pendigits.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_redwine():
    df = pd.read_csv(f"{project_dir}/datasets/data/wine/redwine.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_seeds():
    df = pd.read_csv(f"{project_dir}/datasets/data/seeds/seeds.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_vertebral():
    df = pd.read_csv(f"{project_dir}/datasets/data/vertebral/column_3C.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


def get_whitewine():
    df = pd.read_csv(f"{project_dir}/datasets/data/wine/redwine.csv", sep=';')
    dataY = df['Y']
    dataX = df.loc[:'Y']
    return dataX, dataY


if __name__ == "__main__":

    df = pd.read_csv(f"{project_dir}/datasets/data/arrhythmia/arrhythmia.csv", sep=';')
    scaler = MinMaxScaler(feature_range=(0, 1))
    dataX = scaler.fit_transform(df.loc[:'Y'])
    print(pd.DataFrame(dataX).describe())
    print(len(df.columns))
    print(df.columns)
