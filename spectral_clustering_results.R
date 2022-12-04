library(tidyverse)

args <- commandArgs(trailingOnly=TRUE)
suffix <- args[1]
print(suffix)

state_data <- read_csv(sprintf("derived_data/states_%s.csv", suffix))
pca_data <- read_csv(sprintf("derived_data/clustering_data_%s.csv", suffix))
results <- read_csv(sprintf("derived_data/clustering_results_%s.csv", suffix))

plt <- ggplot(pca_data %>% select(PC1, PC2), aes(PC1, PC2, label=state_data$locationabbr)) +
  geom_point(aes(color=factor(results$labels))) +
  geom_text(hjust=0, vjust=0) + 
  guides(color = "none", size = "none")
ggsave(sprintf("figures/clustered_plot_%s.png", suffix), plt)

