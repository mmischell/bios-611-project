from sklearn.cluster import SpectralClustering
from argparse import ArgumentParser
import numpy as np
import pandas;

parser = ArgumentParser()
parser.add_argument("-f", "--input_file", help="file with data to cluster")
parser.add_argument("-o", "--output_file", help="file to write results")
args = parser.parse_args()

data = pandas.read_csv(args.input_file).values;

clustering = SpectralClustering(n_clusters=4,
        assign_labels='discretize',
        random_state=0).fit(data)
clustering.labels_

print(clustering.labels_)
df = pandas.DataFrame({"labels":clustering.labels_});
df.to_csv(args.output_file, index=False);
