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

# Plot obesity by demographic data in US
# Inputs are cleaned risk factor data 
# Outputs figures by demographic to figures directory
figures/national_gender_plt.png \
figures/income_phys_plt.png \
figures/income_time_plt.png \
figures/race_time_plt.png \
figures/age_time_plt.png \
figures/edu_time_plt.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  demographic_exploration.R
	Rscript demographic_exploration.R
	
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
# Removed PCA for now, because may not return same results every time
# Also runs a linear model without PCA, which showed many more significant variables, such has fruit consumption
# Outputs plot of fruit consumption against obesity rate too 
figures/perc_obesity_pca.png figures/perc_obesity_fruit.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  pca_exploration.R
	Rscript pca_exploration.R
	
	
# PCA 
# Performs PCA starting with all questions. For states averaged across all years
# as well as for a few individual years. Plot first two components for each. 
# Outputs PCA results and plots. 
derived_data/states_avgs.csv \
derived_data/states_2011.csv \
derived_data/states_2012.csv \
derived_data/states_2016.csv \
derived_data/states_2018.csv \
derived_data/states_2020.csv \
derived_data/clustering_data_state_avgs.csv \
derived_data/clustering_data_2011.csv \
derived_data/clustering_data_2012.csv \
derived_data/clustering_data_2016.csv \
derived_data/clustering_data_2018.csv \
derived_data/clustering_data_2020.csv \
figures/pca_plot_state_avgs.png \
figures/pca_plot_2011.png \
figures/pca_plot_2012.png \
figures/pca_plot_2016.png \
figures/pca_plot_2018.png \
figures/pca_plot_2020.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  pca.R
	Rscript pca.R
	
# Spectral clustering
derived_data/clustering_results_state_avgs.csv: .created-dirs \
  derived_data/clustering_data_state_avgs.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_state_avgs.csv \
	-o derived_data/clustering_results_state_avgs.csv
	
# Spectral clustering for 2011
derived_data/clustering_results_2011.csv: .created-dirs \
  derived_data/clustering_data_2011.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_2011.csv \
	-o derived_data/clustering_results_2011.csv

# Spectral clustering for 2012
derived_data/clustering_results_2012.csv: .created-dirs \
  derived_data/clustering_data_2012.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_2012.csv \
	-o derived_data/clustering_results_2012.csv

# Spectral clustering for 2016
derived_data/clustering_results_2016.csv: .created-dirs \
  derived_data/clustering_data_2016.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_2016.csv \
	-o derived_data/clustering_results_2016.csv

# Spectral clustering for 2018
derived_data/clustering_results_2018.csv: .created-dirs \
  derived_data/clustering_data_2018.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_2018.csv \
	-o derived_data/clustering_results_2018.csv

# Spectral clustering for 2020
derived_data/clustering_results_2020.csv: .created-dirs \
  derived_data/clustering_data_2020.csv \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f derived_data/clustering_data_2020.csv \
	-o derived_data/clustering_results_2020.csv



# Build final report as pdf
report.pdf: .created-dirs \
  figures/national_gender_plt.png \
  figures/nc_phys_legislation.png \
  figures/nc_obesity_leg.png \
  figures/perc_obesity_fruit.png \
  figures/income_phys_plt.png \
  figures/national_gender_plt.png \
  figures/race_time_plt.png \
  figures/edu_time_plt.png \
  figures/age_time_plt.png \
  figures/income_time_plt.png \
  report.tex
	pdflatex report.tex
