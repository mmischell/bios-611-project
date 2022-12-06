library(tidyverse)
set.seed(124)

formatted <- read_csv('derived_data/pca_formatted.csv')

pca_data <- formatted %>% select(-locationabbr) %>% replace(is.na(.), 0)
pca_data <- pca_data[,apply(pca_data, 2, var, na.rm=TRUE) != 0]

results <- prcomp(pca_data, scale=T, center=T)
print(summary(results))
results_subset <- results$x %>% as_tibble() %>% 
  select(PC1:PC38)

# Subset data into averages and by year and write to csvs
joined <- cbind(formatted %>% select(yearstart, locationabbr), results_subset)
state_avgs <- joined %>% 
  select(-yearstart) %>%
  group_by(locationabbr) %>% 
  summarise_all("mean", na.rm=T)
write_csv(state_avgs, 'derived_data/states_avgs.csv')
write_csv(state_avgs %>% select(-locationabbr), 'derived_data/clustering_data_avgs.csv')

years <- c(2011, 2013, 2015, 2017, 2019)
for(y in years){
  year_pca_data <- joined %>%
    filter(yearstart == y) %>%
    select(-yearstart)
  write_csv(year_pca_data, sprintf('derived_data/states_%s.csv', y))
  write_csv(year_pca_data %>% select(-locationabbr), sprintf('derived_data/clustering_data_%s.csv', y))
}

plt <- ggplot(results$x %>% as_tibble() %>% select(PC1, PC2),
              aes(PC1, PC2, label=formatted$locationabbr)) +
  geom_point(aes(color=factor(formatted$locationabbr))) +
  geom_text(hjust=0, vjust=0) + 
  guides(color = "none", size = "none")
ggsave("figures/pca_plot.png", plt)


