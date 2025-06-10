from sklearn.ensemble import RandomForestClassifier
import pandas as pd

# Load
df = pd.read_csv("data/cleaned_navigation.csv")
X = df[['route_length', 'traffic_density']]
y = df['on_time']

# Train
clf = RandomForestClassifier()
clf.fit(X, y)
print("Model trained.")
