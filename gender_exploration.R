library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

# Gender over time
nat_gen <- df %>%
  filter(
    (locationabbr == 'US') & 
      (stratificationcategoryid1 == 'GEN') & 
      (question == 'Percent of adults aged 18 years and older who have obesity')
  ) %>%
  arrange(yearstart)

nat_gender_plt <- ggplot(nat_gen, aes(yearstart, data_value)) + geom_line(aes(color=gender))
ggsave("figures/national_gender_plt.png", nat_gender_plt)
