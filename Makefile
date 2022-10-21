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
derived_data/clean_obesity_risk_factors.csv derived_data/clean_legislation.csv: .created-dirs \
  source_data/Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv \
  source_data/CDC_Nutrition__Physical_Activity__and_Obesity_-_Legislation.csv \
  tidy_data.R
	Rscript tidy_data.R

# Plot obesity by gender in US
figures/national_gender_plt.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  explore_gender.R
	Rscript explore_gender.R
	
# Plot physical activity in NC with legislation 
figures/nc_phys_legislation.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	derived_data/clean_legislation.csv \
	nc_physical_activity_exploration.R
	Rscript nc_physical_activity_exploration.R
	
# Plot obesity in NC with legislation 
figures/nc_obesity_leg.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	derived_data/clean_legislation.csv \
	exploration_nc_obesity_legislation.R
	Rscript exploration_nc_obesity_legislation.R
	
# PCA and LM to predict obesity from stratifications
figures/perc_obesity_pca.png: .created-dirs \
	derived_data/clean_obesity_risk_factors.csv \
	derived_data/clean_legislation.csv \
	pca_exploration.R
	Rscript pca_exploration.R

# Build final report as pdf
report.pdf: .created-dirs \
  figures/national_gender_plt.png \
  figures/nc_phys_legislation.png \
  report.tex
	pdflatex report.tex
