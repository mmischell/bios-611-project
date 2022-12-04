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

state_2012 <- read_csv(sprintf("derived_data/states_%s.csv", 2012))
clustering_2012 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2012))
state_labels_2012 <- cbind(state_2012 %>% select(locationabbr), clustering_2012)

state_2016 <- read_csv(sprintf("derived_data/states_%s.csv", 2016))
clustering_2016 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2016))
state_labels_2016 <- cbind(state_2016 %>% select(locationabbr), clustering_2016)

state_2018 <- read_csv(sprintf("derived_data/states_%s.csv", 2018))
clustering_2018 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2018))
state_labels_2018 <- cbind(state_2018 %>% select(locationabbr), clustering_2018)

state_2020 <- read_csv(sprintf("derived_data/states_%s.csv", 2020))
clustering_2020 <- read_csv(sprintf("derived_data/clustering_results_%s.csv", 2020))
state_labels_2020 <- cbind(state_2020 %>% select(locationabbr), clustering_2020)

joined <- state_labels_2011 %>% 
  inner_join(state_labels_2012, by='locationabbr', suffix=c('2011','2012')) %>%
  inner_join(state_labels_2016, by='locationabbr', suffix=c('','2016')) %>%
  rename(labels2016=labels) %>%
  inner_join(state_labels_2018, by='locationabbr', suffix=c('','2018')) %>% 
  rename(labels2018=labels) %>%
  inner_join(state_labels_2020, by='locationabbr', suffix=c('','2020')) %>%
  rename(labels2020=labels)

get_mut_inf <- function(c1, c2){
  a <- joined[,c1]
  b <- joined[,c2]
  normalized_mutinf(a, b)
}

years <- c(2011, 2012, 2016, 2018, 2020)
mut_infs <- as_tibble(t(combn(years,2)))
mut_infs <- mut_infs %>%
  mutate(c1 = paste0('labels', V1), c2=paste0('labels', V2))
mut_infs$mut_inf <- mapply(get_mut_inf, mut_infs$c1, mut_infs$c2)
mut_infs$V1 <- factor(mut_infs$V1, levels=c(2011,2012,2016,2018,2020))
mut_infs$V2 <- factor(mut_infs$V2, levels=c(2011,2012,2016,2018,2020))

plt <- ggplot(mut_infs, aes(V1, V2, fill= mut_inf)) + 
  geom_tile()
ggsave("figures/mut_inf_heatmap.png", plt)
