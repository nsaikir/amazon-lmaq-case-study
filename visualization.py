import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("data/cleaned_navigation.csv")
plt.hist(df['route_length'])
plt.title("Route Length Distribution")
plt.savefig("route_histogram.png")
