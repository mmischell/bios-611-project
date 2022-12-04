library(tidyverse)
library(imputeTS)
set.seed(124)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')
formatted <- df %>% 
  filter(!(locationabbr %in% c('VI', 'GU', 'PR', 'US'))) %>%
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
  ) 

# Impute missing data
data_by_loc <- tibble()
for(loc in unique(formatted$locationabbr)){
  loc_data <- formatted %>% 
    filter(locationabbr==loc) %>%
    arrange(yearstart)
  for(col in names(loc_data %>% select(-locationabbr, -yearstart))){
    x <- ts(loc_data[,col], frequency = 1)
    x.withoutNA <- tryCatch({na_kalman(x)}, error=function(err){rep(0, length(x))})
    loc_data[,col] <- x.withoutNA
  }
  data_by_loc <- rbind(data_by_loc, loc_data)
}

formatted <- data_by_loc

write_csv(formatted, 'derived_data/pca_formatted.csv')