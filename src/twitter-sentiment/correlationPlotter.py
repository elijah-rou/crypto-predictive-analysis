# Script to plot Pearson Coefficients (Sentiment & BTC Price Change) vs. various time shifts of sentiment

#%%
# Import pandas
import pandas as pd

#%%
# Define data points
pearson  =[0.02,0.07,-0.05,0.07,0.09,-0.01,-0.05,-0.08,-0.1]
df = pd.DataFrame(\
    {"Time Shift": [1,2,3,4,5,6,7,8,9],
     "Pearson Coefficient": pearson,\
     "p-Value": [0.71,0.26,0.46,0.31,0.16,0.87,0.43,0.21,0.14]})


#%%
# Plot data on a bar chart and save figure
ax = df.plot.bar(legend=False, figsize=(10,8),title="Pearson Correlation for various hourly time shifts on Twitter Sentiment vs. BTC price change", x="Time Shift", y="Pearson Coefficient", colormap="Paired")
ax.set_ylabel("Pearson Coefficient")
plt.savefig("output/pearson.png", dpi=300)
