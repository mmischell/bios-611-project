library(tidyverse)
library(ggplot2)

df <- read_csv('derived_data/clean_obesity_risk_factors.csv')

plot_demographic_over_time <- function(strat_id, title=""){
  dem_data <- df %>%
    filter(
      (locationabbr == 'US') & 
        (stratificationcategoryid1 == strat_id) & 
        (question == 'Percent of adults aged 18 years and older who have obesity')
    ) %>%
    arrange(yearstart)
  
  ggplot(dem_data, aes(yearstart, data_value)) + 
    geom_line(aes(color=stratification1)) + 
    scale_x_continuous(breaks=seq(min(dem_data$yearstart),max(dem_data$yearstart))) + 
    ggtitle(title)
}

# Gender over time
nat_gender_plt <- plot_demographic_over_time('GEN', "Gender")

ggsave("figures/national_gender_plt.png", nat_gender_plt)

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

inc_plt <- ggplot(nat_2020_inc, aes(factor(income, levels=inc_levels), data_value)) +   
  geom_bar(aes(fill = question), position = "dodge", stat="identity") + 
  theme(legend.position = "bottom") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave("figures/income_phys_plt.png", inc_plt)

inc_time_plt <- plot_demographic_over_time('INC', "Income")
ggsave("figures/income_time_plt.png", inc_time_plt)


# Race/Ethnicity
race_time_plt <- plot_demographic_over_time('RACE', "Race/Ethnicity")
ggsave("figures/race_time_plt.png", race_time_plt)

# Age
age_time_plt <- plot_demographic_over_time('AGEYR', "Age")
ggsave("figures/age_time_plt.png", age_time_plt)

# Education
edu_time_plt <- plot_demographic_over_time('EDU', "Education")
ggsave("figures/edu_time_plt.png", edu_time_plt)