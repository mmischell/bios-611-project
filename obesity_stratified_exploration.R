library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')


nat_obesity <- df %>% 
   filter(
     (locationabbr == 'US') & 
       (question == 'Percent of adults aged 18 years and older who have obesity')
   )

ggplot(nat_obesity, aes(yearstart, data_value) ) +
  geom_line(aes(color=stratification1)) +
  facet_wrap(~stratificationcategoryid1
             , scales = "free_y"
             , labeller="label_both"
             , nrow=length(unique(nat_obesity$stratificationcategoryid1))
  )  +
  theme(strip.background = element_blank(),
        strip.placement = "outside")
