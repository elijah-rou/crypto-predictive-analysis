# Plotting libraries
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
# Numpy
import numpy as np
# Pandas
import pandas as pd
# TSNE Algorithm from sklearn
from sklearn.manifold import TSNE
# Time
import time
# Seaborn
import seaborn as sns


# Read in the csv file locally into a pandas dataframe
blocks = pd.read_csv("data/btc_blockchain_all/blocks.csv")
blocks.rename(columns={"Unnamed: 0":"block#"}, inplace=True)
print('Size of the dataframe: {}'.format(blocks.shape))


# Take a subset of data
np.random.seed(35)
rndperm = np.random.permutation(blocks.shape[0])

N = 10000

# Take a subset of blocks and only the integer value columns
blocksInt = blocks.filter(["size", "number", "transaction_count"])
dfSubset = blocks.loc[rndperm[:N],:].copy()
blockCols = ["size", "number", "transaction_count"] 
dataSubset = dfSubset[blockCols].values

timeStart = time.time()
tsne = TSNE(n_components = 2, verbose = 1, perplexity = 40, n_iter=300)
tsne_results = tsne.fit_transform(dataSubset)

dfSubset["tsne-2d-one"] = tsne_results[:,0]
dfSubset["tsne-2d-two"] = tsne_results[:,1]
#dfSubset["tsne-3d-three"] = tsne_results[:,2]
plt.figure(figsize=(16,10))

sns.scatterplot(
    x = "tsne-2d-one", y = "tsne-2d-two",
    hue = "y",
    palette = sns.color_palette("hls", 10),
    data = dfSubset,
    legend = "full",
    alpha = 0.3
)

dfSubset.plot(x="tsne-2d-one", y="tsne-2d-two")
