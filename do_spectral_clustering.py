from sklearn.cluster import SpectralClustering
from argparse import ArgumentParser
import numpy as np
import pandas;

parser = ArgumentParser()
parser.add_argument("-f", "--input_file", help="file with data to cluster")
parser.add_argument("-s", "--suffix", help="file to write results")
parser.add_argument("-n", "--n_clusters", help="number of clusters", type=int)
args = parser.parse_args()

data = pandas.read_csv(args.input_file).values;

if args.n_clusters:
  out = f"derived_data/clustering_results_{args.suffix}.csv"
  clustering = SpectralClustering(n_clusters=args.n_clusters,
            assign_labels='discretize',
            random_state=0).fit(data)
  print(clustering.labels_)
  df = pandas.DataFrame({"labels":clustering.labels_})
  df.to_csv(out, index=False)
else:
  cluster_range = range(3,11)
  for n_clusters in cluster_range:
    for i in range(5):
      clustering = SpectralClustering(n_clusters=n_clusters,
              assign_labels='discretize',
              random_state=i).fit(data)
      print(clustering.labels_)
      df = pandas.DataFrame({"labels":clustering.labels_});
      out = f"derived_data/clustering_results_{args.suffix}_{n_clusters}_{i}.csv"
      df.to_csv(out, index=False);
