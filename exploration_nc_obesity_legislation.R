library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

nc_obesity <- df %>% 
  filter(
    (locationabbr == 'NC') & 
      (stratificationcategoryid1 == 'OVR') & 
      (question == 'Percent of adults aged 18 years and older who have an overweight classification')
  )

# Bring in legislative data
leg_df <- read_csv('derived_data/clean_legislation.csv')

nc_leg <- leg_df %>% 
  filter(
    (locationabbr == 'NC') & 
      (status == 'Enacted') & 
      (yearstart >= min(nc_obesity$yearstart)) & 
      (yearstart <= max(nc_obesity$yearstart))
  )

plt <- ggplot(nc_obesity, aes(yearstart, data_value)) + geom_line() + 
  geom_vline(xintercept = nc_leg$yearstart, color='red')

ggsave("figures/nc_obesity_leg.png", plt)

nc_leg[nc_leg$yearstart == 2017, ]
