library(tidyverse)

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

state_2011 <- read_csv(sprintf("derived_data/states_%s.csv", 2011))
clustering_2011 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2011))
state_labels_2011 <- cbind(state_2011 %>% select(locationabbr), clustering_2011)

state_2013 <- read_csv(sprintf("derived_data/states_%s.csv", 2013))
clustering_2013 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2013))
state_labels_2013 <- cbind(state_2013 %>% select(locationabbr), clustering_2013)

state_2015 <- read_csv(sprintf("derived_data/states_%s.csv", 2015))
clustering_2015 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2015))
state_labels_2015 <- cbind(state_2015 %>% select(locationabbr), clustering_2015)

state_2017 <- read_csv(sprintf("derived_data/states_%s.csv", 2017))
clustering_2017 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2017))
state_labels_2017 <- cbind(state_2017 %>% select(locationabbr), clustering_2017)

state_2019 <- read_csv(sprintf("derived_data/states_%s.csv", 2019))
clustering_2019 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2019))
state_labels_2019 <- cbind(state_2019 %>% select(locationabbr), clustering_2019)

joined <- state_labels_2011 %>% 
  inner_join(state_labels_2013, by='locationabbr', suffix=c('2011','2013')) %>%
  inner_join(state_labels_2015, by='locationabbr', suffix=c('','2015')) %>%
  rename(labels2015=labels) %>%
  inner_join(state_labels_2017, by='locationabbr', suffix=c('','2017')) %>% 
  rename(labels2017=labels) %>%
  inner_join(state_labels_2019, by='locationabbr', suffix=c('','2019')) %>%
  rename(labels2019=labels)

get_mut_inf <- function(c1, c2){
  a <- joined[,c1]
  b <- joined[,c2]
  normalized_mutinf(a, b)
}

years <- c(2011, 2013, 2015, 2017, 2019)
mut_infs <- as_tibble(t(combn(years,2)))
mut_infs <- mut_infs %>%
  mutate(c1 = paste0('labels', V1), c2=paste0('labels', V2))
mut_infs$mut_inf <- mapply(get_mut_inf, mut_infs$c1, mut_infs$c2)
mut_infs$V1 <- factor(mut_infs$V1, levels=years)
mut_infs$V2 <- factor(mut_infs$V2, levels=years)

plt <- ggplot(mut_infs, aes(V1, V2, fill= mut_inf)) + 
  geom_tile() + 
  ggtitle("Normalized Mutual Information for Clustering Per Year") +
  xlab("Year") + ylab("Year") + 
  guides(fill=guide_legend(title="Normalize Mutual Information"))
ggsave("figures/mut_inf_heatmap.png", plt) 
