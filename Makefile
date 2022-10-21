.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf .created-dirs
	rm -f report.pdf

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs

# Clean and prepare data for analysis and visualization
# Inputs from source_data: Obesity Risk Factor dataset and Legislation dataset
# Outputs versions of these data with cleaned columns to derived_data directory
derived_data/clean_obesity_risk_factors.csv derived_data/clean_legislation.csv: .created-dirs \
  source_data/Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv \
  source_data/CDC_Nutrition__Physical_Activity__and_Obesity_-_Legislation.csv \
  tidy_data.R
	Rscript tidy_data.R

# Plot obesity by gender in US
# Inputs are cleaned risk factor data 
# Outputs figure to figures directory
figures/national_gender_plt.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  gender_exploration.R
	Rscript gender_exploration.R
	
# Plot physical activity in NC with legislation 
# Inputs are clean risk factor and legislation data
# Outputs figure to figures direcotry
figures/nc_phys_legislation.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	derived_data/clean_legislation.csv \
	nc_physical_activity_exploration.R
	Rscript nc_physical_activity_exploration.R
	
# Plot obesity in NC with legislation
# Inputs are clean risk factor and legislation data
# Outputs figure to figures directory
figures/nc_obesity_leg.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	derived_data/clean_legislation.csv \
	nc_obesity_legislation_exploration.R
	Rscript nc_obesity_legislation_exploration.R
	
# PCA and LM to predict obesity from stratifications
# Inputs are clean risk factor data
# Performs PCA and a linear model and outputs a plot of a significant component against obesity rate
# Also runs a linear model without PCA, which showed many more significant variables, such has fruit consumption
# Outputs plot of fruit consumption against obesity rate too 
figures/perc_obesity_pca.png figures/perc_obesity_fruit.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	pca_exploration.R
	Rscript pca_exploration.R

# Build final report as pdf
report.pdf: .created-dirs \
  figures/national_gender_plt.png \
  figures/nc_phys_legislation.png \
  figures/nc_obesity_leg.png \
  figures/perc_obesity_pca.png \
  figures/perc_obesity_fruit.png \
  report.tex
	pdflatex report.tex
