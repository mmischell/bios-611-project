library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

nc_pa <- df %>% 
  filter(
    (locationabbr == 'NC') & 
      (class == 'Physical Activity') &
      (stratificationcategoryid1 == 'OVR') & 
      (question == 'Percent of adults who engage in no leisure-time physical activity')
  )

# Bring in legislative data
leg_df <- read_csv('derived_data/clean_legislation.csv')

nc_pa_leg <- leg_df %>% 
  filter(
    (locationabbr == 'NC') & 
      (class == 'Physical Activity') & 
      (status == 'Enacted') & 
      (yearstart >= min(nc_pa$yearstart)) & 
      (yearstart <= max(nc_pa$yearstart))
  )


plt <- ggplot(nc_pa, aes(yearstart, data_value)) + geom_line() + 
  geom_vline(xintercept = nc_pa_leg$yearstart, color='red')

ggsave("figures/nc_phys_legislation.png", plt)
