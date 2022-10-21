library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

df_wide <- df %>%
  filter(
    (!(question %in% c(
      'Percent of adults aged 18 years and older who have obesity'
      , 'Percent of adults aged 18 years and older who have an overweight classification'
      ))) & 
      (yearstart == 2019) & 
      (stratificationcategoryid1 == 'OVR')
  ) %>% 
  select(locationabbr, question, data_value) %>%
  pivot_wider(
    id_cols="locationabbr"
    , names_from = "question"
    , values_from="data_value"
    )

exp_data <- df_wide %>% select(-locationabbr)
pca_results <- prcomp(exp_data)
summary(pca_results)

viz_data <- pca_results$x[, c("PC1", "PC2")]

ggplot(viz_data %>% as.tibble(), aes(PC1, PC2)) + geom_point()

df_wide <- df %>%
  filter(
      (yearstart == 2019) & 
      (stratificationcategoryid1 != 'OVR') & 
      (question == 'Percent of adults aged 18 years and older who have obesity') 
  ) %>% 
  select(locationabbr, stratification1, data_value) %>%
  pivot_wider(
    id_cols="locationabbr"
    , names_from = "stratification1"
    , values_from="data_value"
  )

exp_data <- df_wide %>% select(-locationabbr)
pca_results <- prcomp(exp_data)
summary(pca_results)

viz_data <- pca_results$x[, c("PC1", "PC2")]
ggplot(viz_data %>% as.tibble(), aes(PC1, PC2)) + geom_point()

df_wide <- df %>%
  filter(
    (yearstart == 2019)  & 
      !(question %in% c('Percent of adults aged 18 years and older who have obesity', 'Percent of adults aged 18 years and older who have an overweight classification'))
  ) %>% 
  select(locationabbr, stratification1, question, data_value) %>%
  pivot_wider(
    id_cols=c("locationabbr", "stratification1")
    , names_from = "question"
    , values_from="data_value"
  )

exp_data <- df_wide %>% select(-locationabbr, -stratification1) 
exp_data <- na.omit(exp_data)
pca_results <- prcomp(exp_data)
summary(pca_results)

obesity_percs <- df %>% 
  filter(
    (question == 'Percent of adults aged 18 years and older who have obesity') &
      (yearstart == 2019)
    ) %>%
  select(locationabbr, stratification1, data_value) %>%
  rename(perc_adults_with_obesity = data_value)

joined <- obesity_percs %>% 
  inner_join(df_wide, by=c('locationabbr', 'stratification1')) %>%
  na.omit() %>%
  select(locationabbr, stratification1, perc_adults_with_obesity) %>%
  cbind(pca_results$x)

model <- lm(perc_adults_with_obesity ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7, joined)
summary(model)
# PC5 is just barely significant 

viz_data <- joined %>% select(PC5, perc_adults_with_obesity)
pca_plt <- ggplot(viz_data %>% as.tibble(), aes(PC5, perc_adults_with_obesity)) + geom_point()
ggsave("figures/perc_obesity_pca.png", pca_plt)

joined <- obesity_percs %>% 
  inner_join(df_wide, by=c('locationabbr', 'stratification1'))

