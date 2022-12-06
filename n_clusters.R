library(tidyverse)

args <- commandArgs(trailingOnly=TRUE)
y <- args[1]
print(y)

shannon <- function(sequence){
  tbl <- (table(sequence)/length(sequence)) %>% as.numeric();
  -sum(tbl*log2(tbl))
}

mutinf <- function(a,b){
  sa <- shannon(a);
  sb <- shannon(b);
  sab <- shannon(sprintf("%d:%d", a, b));
  sa + sb - sab;
}

normalized_mutinf <- function(a,b){
  2*mutinf(a,b)/(shannon(a)+shannon(b));
}

avg_mutual_infs <- data.frame()
for(n in 3:10){ # Loop through the number of clusters
  # Read all csvs for this year, this number of clusterings
  clusterings <- list()
  mutual_informations <- c()
  result_files <- list.files('derived_data',
                             pattern=sprintf("^clustering_results_%s_%s", y, n))
  for(filename in result_files){
    new_clustering <- read_csv(paste0('derived_data/', filename))$labels
    for(clustering in clusterings){
      print(clustering)
      mut_inf <- normalized_mutinf(new_clustering, clustering)
      mutual_informations <- c(mutual_informations, mut_inf)
    }
    clusterings <- append(clusterings, list(new_clustering))
  }
  new_row <- data.frame(n, mean(mutual_informations))
  avg_mutual_infs <- rbind(avg_mutual_infs, new_row)
}

plt <- ggplot(avg_mutual_infs, aes(n, mean.mutual_informations.)) + geom_point() +
  ggtitle(sprintf("Mean Mutual Information for n Clusters, %s Data", y)) +
  xlab("Number of Clusters") + ylab("Mean Mutual Information")
ggsave(sprintf("figures/n_clusters_mut_inf_%s.png", y), plt) 
