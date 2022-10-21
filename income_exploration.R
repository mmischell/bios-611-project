library(tidyverse)
library(ggplot2)

df <- read.csv("derived_data/clean_obesity_risk_factors.csv")

# Income
nat_2020_inc <- df %>%
  filter(
    (yearstart == 2020) & 
      (locationabbr == 'US') & 
      (stratificationcategoryid1 == 'INC')
  ) %>%
  select(question, data_value, income)

inc_levels <- c(
  'Less than $15,000'
  , '$15,000 - $24,999'
  , '$25,000 - $34,999'
  , '$35,000 - $49,999'
  , '$50,000 - $74,999'
  , '$75,000 or greater'
  , 'Data not reported'
)

plt <- ggplot(nat_2020_inc, aes(factor(income, levels=inc_levels), data_value)) +   
  geom_bar(aes(fill = question), position = "dodge", stat="identity") + 
   theme(legend.position = "bottom") + 
   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
# Looks like no leisure time activity is correlated with income
# not necessarily obesity though

ggsave("figures/income_phys_plt.png", plt)
