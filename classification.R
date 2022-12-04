library(tidyverse)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

formatted <- df %>% 
  select(
    yearstart
    , locationabbr
    , questionid
    , data_value
    , stratification1
  ) %>%
  pivot_wider(
    id_cols=c(yearstart, locationabbr, stratification1)
    , names_from=c(questionid)
    , values_from=data_value
    , values_fill=0
  ) %>%
  group_by(locationabbr, stratification1) %>%
  select(-yearstart) %>%
  summarise_all("mean", na.rm=T)

# Separate obesity rate from other cols
# Obesity rate id: Q036
# Overweight rate id: Q037
obesity_cols = formatted %>% select(locationabbr, stratification1, Q036, Q037)
formatted <- formatted %>% select(-Q036, -Q037)

# PCA
pca_data <- formatted %>% ungroup() %>% select(-locationabbr, -stratification1) %>% replace(is.na(.), 0)
results <- prcomp(pca_data)
results
summary(results)
# 95% of variance explained in first 2 components

# Plot
ggplot(results$x %>% as_tibble() %>% select(PC1, PC2)
       , aes(PC1, PC2, label=formatted$locationabbr)) +
  geom_point(aes(color=factor(formatted$locationabbr))) +
  geom_text(hjust=0, vjust=0);
# Impossible to read, super ugly plot, but definitely see some clusters! (come back to this)

# Plot the obesity rates, see if there is a natural cutoff
hist(obesity_cols$Q036)
# Looks pretty normal, maybe make everything above 40% high, 20-40 medium, and below 20 can be low? 

