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


gen_data <- df %>%
  filter(
    (locationabbr == 'US') & 
      (stratificationcategoryid1 == 'GEN') & 
      (question == 'Percent of adults aged 18 years and older who have obesity')
  ) %>%
  arrange(yearstart)
## twice-difference the gender obesity data
fem_d2 <- diff(gen_data[gen_data$stratification1 == 'Female',]$data_value, differences = 1)
male_d2 <- diff(gen_data[gen_data$stratification1 == 'Male',]$data_value, differences = 1)
plot(fem_d2, ylab = expression("Female Obesity Rate"))
plot(male_d2, ylab = expression("Male Obesity Rate"))


# Linear Regression to compare slopes
lm_model <- lm(data_value~yearstart + as.factor(stratification1), gen_data)
summary(lm_model)

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


inc_data <- df %>%
  filter(
    (locationabbr == 'US') & 
      (stratificationcategoryid1 == 'INC') & 
      (question == 'Percent of adults aged 18 years and older who have obesity')
  ) %>%
  arrange(yearstart)

# Linear Regression to compare slopes
lm_model_inc <- lm(data_value~yearstart + as.factor(stratification1) + yearstart*as.factor(stratification1), inc_data)
summary(lm_model_inc)

# Race/Ethnicity
race_time_plt <- plot_demographic_over_time('RACE', "Race/Ethnicity")
ggsave("figures/race_time_plt.png", race_time_plt)


race_data <- df %>%
  filter(
    (locationabbr == 'US') & 
      (stratificationcategoryid1 == 'RACE') & 
      (question == 'Percent of adults aged 18 years and older who have obesity')
  ) %>%
  arrange(yearstart)

# Linear Regression to compare slopes
lm_model_race <- lm(data_value~yearstart + as.factor(stratification1) + yearstart*as.factor(stratification1), race_data)
summary(lm_model_race)

# Age
age_time_plt <- plot_demographic_over_time('AGEYR', "Age")
ggsave("figures/age_time_plt.png", age_time_plt)

# Education
edu_time_plt <- plot_demographic_over_time('EDU', "Education")
ggsave("figures/edu_time_plt.png", edu_time_plt)