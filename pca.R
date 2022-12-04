library(tidyverse)
set.seed(124)

subset_by_year <- function(y){
  states_year <- formatted %>% 
    filter(yearstart == y) %>%
    select(-yearstart) %>%
    group_by(locationabbr) %>% 
    summarise_all("mean", na.rm=T)
  write_csv(states_year, sprintf('derived_data/states_%s.csv', y))
  
  states_year
}

run_pca <- function(data, label){
  pca_data <- data %>% select(-locationabbr) %>% replace(is.na(.), 0)
  pca_data <- pca_data[,apply(pca_data, 2, var, na.rm=TRUE) != 0]
  results <- prcomp(pca_data, scale=T, center=T)
  pca_results <- results$x %>% as_tibble() %>% select(PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8, PC9)
  write_csv(pca_results, sprintf('derived_data/clustering_data_%s.csv', label))
  
  results
}

plot_pca <- function(state_data, results, label){
  plt <- ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2, label=state_data$locationabbr)) +
    geom_point(aes(color=factor(state_data$locationabbr))) +
    geom_text(hjust=0, vjust=0) + 
    guides(color = "none", size = "none")
  ggsave(sprintf("figures/pca_plot_%s.png", label), plt)
}

pca_plot_by_year <- function(y){
  states_year <- subset_by_year(y)
  results <- run_pca(states_year, y)
  plot_pca(states_year, results, y)
}

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

formatted <- df %>% 
  filter(locationabbr != 'US') %>%
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

# State Avgs
state_avgs <- formatted %>% 
  select(-yearstart) %>%
  group_by(locationabbr) %>% 
  summarise_all("mean", na.rm=T)
write_csv(state_avgs, sprintf('derived_data/states_%s.csv', 'state_avgs'))

# PCA
results <- run_pca(state_avgs, 'state_avgs')
plot_pca(state_avgs, results, 'state_avgs')

pca_plot_by_year(2011)
pca_plot_by_year(2012)
pca_plot_by_year(2016)  
pca_plot_by_year(2018) 
pca_plot_by_year(2020) 


# states_year <- formatted %>% 
#   filter(yearstart == 2012) %>%
#   select(-yearstart) %>%
#   group_by(locationabbr) %>% 
#   summarise_all("mean", na.rm=T)
# 
# # PCA
# pca_data <- states_year %>% select(-locationabbr) %>% replace(is.na(.), 0)
# pca_data <- pca_data[,apply(pca_data, 2, var, na.rm=TRUE) != 0]
# results <- prcomp(pca_data, scale=T, center=T)
# pca_results <- results$x %>% as_tibble() %>% select(PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8, PC9)
# write_csv(pca_results %>% as_tibble(), sprintf('derived_data/pca_results%s.csv', 2012))
# 
# ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2, label=states_year$locationabbr)) +
#   geom_point(aes(color=factor(states_year$locationabbr))) +
#   geom_text(hjust=0, vjust=0) + 
#   guides(color = "none", size = "none");
# 
# # Affinity matrix
# library(rdist)
# dist_matrix <- pdist(pca_results)
# ggplot(dist_matrix[upper.tri(dist_matrix)] %>% as.tibble(), aes(value)) + geom_density()
# thresh <- 2
# aff_matrix <- ifelse(dist_matrix <= thresh, 1, 0)
# write_csv(aff_matrix %>% as_tibble(), sprintf('derived_data/clustering_data_%s.csv', 2012))
