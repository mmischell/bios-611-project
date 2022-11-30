library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

# Reformat data -- this could be useful if I go the route of finding things associated with high obesity rate
# obesity_rates <- df %>%
#   filter(questionid == 'Q036') %>%
#   select(
#     yearstart
#     , locationabbr
#     , stratification1
#     , data_value
#   ) %>%
#   rename(
#     obesity_rate=data_value
#   )
# 
# vars <- df %>% 
#   select(
#     yearstart
#     , locationabbr
#     , questionid
#     , data_value
#     , stratification1
#   ) %>%
#   filter(
#     !questionid %in% c('Q036', 'Q037')
#   ) %>%
#   pivot_wider(
#     id_cols=c(yearstart, locationabbr, stratification1)
#     , names_from=questionid
#     , values_from=data_value
#   )
# 
# ;

# Should I look at a single year? Just cluster by obesity rates and then see common factors? 
# formatted <- obesity_rates %>% inner_join(vars) %>% filter(yearstart==2020) %>% replace(is.na(.), 0)
# formatted <- obesity_rates %>% 
#   filter(yearstart==2020) %>%
#   pivot_wider(
#     id_cols=c(locationabbr, stratification1)
#     , names_from=yearstart
#     , values_from=obesity_rate
#   ) 
# formatted <- obesity_rates %>%
#   filter(yearstart==2020) %>%
#   pivot_wider(
#     id_cols=c(locationabbr)
#     , names_from=c(yearstart, stratification1)
#     , values_from=obesity_rate
#   )
# formatted <- obesity_rates %>% 
#   filter(yearstart==2020) %>%
#   pivot_wider(
#     id_cols=c(stratification1)
#     , names_from=c(yearstart, locationabbr)
#     , values_from=obesity_rate
#   ) 


# TSNE
# library(reticulate);
# use_python("/usr/bin/python3");
# manifold <- import("sklearn.manifold");
# tsne_instance <- manifold$TSNE(n_components=as.integer(2));
# results <- tsne_instance$fit_transform(
#   formatted %>% 
#     # select(-yearstart, -locationabbr, -stratification1) %>% 
#     select(-locationabbr) %>%
#     replace(is.na(.), 0) %>%
#   as.matrix()) %>%
#   as_tibble();
# ggplot(results, aes(V1, V2)) + geom_point(aes(color=factor(formatted$locationabbr)));
# ggplot(results, aes(V1, V2)) + geom_point(aes(color=factor(formatted$stratification1)));



### Vincent's ideas
formatted <- df %>% 
  select(
    yearstart
    , locationabbr
    , questionid
    , data_value
    , stratification1
  ) %>%
  pivot_wider(
    id_cols=c(yearstart, locationabbr)
    , names_from=c(questionid, stratification1)
    , values_from=data_value
    , values_fill=0
  ) 

state_avgs <- formatted %>% 
  select(-yearstart) %>%
  group_by(locationabbr) %>% 
  summarise_all("mean", na.rm=T)
  
# PCA
pca_data <- state_avgs %>% select(-locationabbr) %>% replace(is.na(.), 0)
results <- prcomp(pca_data)
results
summary(results)
# Looks like to get ~90% variance, need about 7 or 8 components
# Might not ever see anything plotting 2 dimensions


# Plot first two components from PCA
ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2, label=state_avgs$locationabbr)) +
  geom_point(aes(color=factor(state_avgs$locationabbr))) +
  geom_text(hjust=0, vjust=0);
# From this it kind of looks like there might be a couple of clusters

# Cluster
kmeans_results <- kmeans(pca_data, centers=3);
state_avgs_ex <- state_avgs %>% 
  mutate(cluster=kmeans_results$cluster) 
state_clusters <- state_avgs_ex %>% 
  select(locationabbr, cluster) %>% 
  group_by(locationabbr, cluster)

# Try spectral clustering
pca_results <- results$x %>% as_tibble() %>% select(PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8, PC9)
write_csv(pca_results, 'derived_data/clustering_data.csv')
# Run do_spectral_clustering.py
spectral_results <- read_csv("derived_data/spectral_clustering_labels.csv")
state_clusters_spectral <- cbind(state_avgs$locationabbr, spectral_results$labels)

# Plot for each year -- looking for clusters that change over time
year <- min(df$yearstart)
formatted_2011 <- formatted %>% filter(yearstart == year)
pca_data <- state_avgs %>% select(-locationabbr) %>% replace(is.na(.), 0)
results <- prcomp(pca_data)
results
summary(results)
# Looks like to get ~90% variance, need about 7 or 8 components
# Might not ever see anything plotting 2 dimensions


# Plot first two components from PCA
ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2, label=state_avgs$locationabbr)) +
  geom_point(aes(color=factor(state_avgs$locationabbr))) +
  geom_text(hjust=0, vjust=0);


# Questions/Notes:
# How do I choose the number of clusters for k-means/spectral clustering? 
# How do I evaluate the clusters if plotting in 2 dim doesn't show much?
# What I have so far will tell me which states are similar in regards to all of these questions. 
# I guess then I can look at each cluster, and see what is going on in each. 
# Are the states similar in the laws they pass? In their demographics? 
# Another idea I had was to try to predict obesity rate for a given state/year based on the questions. 
# This would tell me which variables are most important in predicting obesity, 
# and then potentially could say from this something like surprisingly/interestingly, 
# these are the most important risk factors  or these risk factors don't seem to matter

