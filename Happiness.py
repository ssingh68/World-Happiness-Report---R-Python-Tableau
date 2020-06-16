# -*- coding: utf-8 -*-
"""
Created on Mon May  6 20:43:22 2019

@author: shrey
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans, AgglomerativeClustering

Happiness = pd.read_excel('C:/Users/shrey/Desktop/Happiness.xlsx')
Happiness.head()

#EDA
Happiness_Predicting = Happiness.iloc[:,[4,5,6,7,8,9,10,11]]
cor = Happiness_Predicting.corr() 
sns.heatmap(cor, square = True)
#We have obtained the heatmap of correlation among the variables. The color palette in the side represents the amount of 
#correlation among the variables. The lighter shade represents high correlation. We can see that happiness score is highly
#correlated with GDP per capita, family and life expectancy. It is least correlated with generosity.

#Scaling of data
ss = StandardScaler()
ss.fit_transform(Happiness_Predicting)

#k-means clustering
def doAgglomerative(X, nclust=2):
    model = AgglomerativeClustering(n_clusters=nclust, affinity = 'euclidean', linkage = 'ward')
    clust_labels1 = model.fit_predict(X)
    return (clust_labels1)

clust_labels1 = doAgglomerative(Happiness_Predicting, 3)
agglomerative = pd.DataFrame(clust_labels1)
Happiness_Predicting.insert((Happiness_Predicting.shape[1]),'agglomerative',agglomerative)
#Plot the clusters obtained using Agglomerative clustering or Hierarchical clustering
fig = plt.figure()
ax = fig.add_subplot(111)
scatter = ax.scatter(Happiness_Predicting['Economy (GDP per Capita)'],Happiness_Predicting['Trust (Government Corruption)'],
                     c=agglomerative[0],s=50)
ax.set_title('Agglomerative Clustering')
ax.set_xlabel('GDP per Capita')
ax.set_ylabel('Corruption')
plt.colorbar(scatter)

#In general, k-means is the first choice for clustering because of its simplicity. Here, the user has to define the number
#of clusters (Post on how to decide the number of clusters would be dealt later). The clusters are formed based on the 
#closeness to the center value of the clusters. The initial center value is chosen randomly. K-means clustering is top-down 
#approach, in the sense, we decide the number of clusters (k) and then group the data points into k clusters.