library(tidyverse)

df <- read_csv("source_data/Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv")
leg_df <- read_csv("source_data/CDC_Nutrition__Physical_Activity__and_Obesity_-_Legislation.csv")

# Clean col names
clean_colnames <- function(columns){
  new_names <- tolower(columns)
  new_names <- gsub("[()/]", "_", new_names)
  new_names
}
names(df) <- clean_colnames(names(df))
names(leg_df) <- clean_colnames(names(leg_df))

leg_df <- leg_df %>% rename(
  yearstart=year
  , class=healthtopic
)

# Save CSV
write_csv(df, 'derived_data/clean_obesity_risk_factors.csv', '|')
write_csv(leg_df, 'derived_data/clean_legislation.csv', '|')
