import pickle
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Genetic algorithm for Approximate Decision Trees")
    parser.add_argument("--results-dir", "-rd", help="Set the directory where results will be stored")
    args = parser.parse_args()

    assert args.results_dir is not None
    args.results_dir = args.results_dir[:-1] if args.results_dir[-1] == '/' else args.results_dir

    with open(f"{args.results_dir}/dtree.pkl", "rb") as f:
        tree = pickle.load(f)

