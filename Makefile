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

# Format data for PCA
# This includes imputing missing data
derived_data/pca_formatted.csv: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  format_pca_data.R
	Rscript format_pca_data.R

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
# Nothing stood out
# Inputs are clean risk factor and legislation data
# Outputs figure to figures direcotry
figures/nc_phys_legislation.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  derived_data/clean_legislation.csv \
  nc_physical_activity_exploration.R
	Rscript nc_physical_activity_exploration.R
	
# Plot obesity in NC with legislation
# Nothing stood out
# Inputs are clean risk factor and legislation data
# Outputs figure to figures directory
figures/nc_obesity_leg.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv \
  derived_data/clean_legislation.csv \
  nc_obesity_legislation_exploration.R
	Rscript nc_obesity_legislation_exploration.R
	
# PCA 
# Performs PCA starting with all questions and stratifications. 
# Plot first two components. 
# Outputs PCA results. 
derived_data/states_%.csv \
derived_data/clustering_data_%.csv \
figures/pca_plot_%.png: .created-dirs \
  derived_data/pca_formatted.csv \
  pca.R
	Rscript pca.R
	
# Spectral clustering for each year and state averages
# Run each clustering with different numbers of clusters 5 times
# Tried using precomputed affinity matrix, but the default kernal worked better
derived_data/clustering_results_%_3_0.csv \
derived_data/clustering_results_%_3_1.csv \
derived_data/clustering_results_%_3_2.csv \
derived_data/clustering_results_%_3_3.csv \
derived_data/clustering_results_%_3_4.csv \
derived_data/clustering_results_%_4_0.csv \
derived_data/clustering_results_%_4_1.csv \
derived_data/clustering_results_%_4_2.csv \
derived_data/clustering_results_%_4_3.csv \
derived_data/clustering_results_%_4_4.csv \
derived_data/clustering_results_%_5_0.csv \
derived_data/clustering_results_%_5_1.csv \
derived_data/clustering_results_%_5_2.csv \
derived_data/clustering_results_%_5_3.csv \
derived_data/clustering_results_%_5_4.csv \
derived_data/clustering_results_%_6_0.csv \
derived_data/clustering_results_%_6_1.csv \
derived_data/clustering_results_%_6_2.csv \
derived_data/clustering_results_%_6_3.csv \
derived_data/clustering_results_%_6_4.csv \
derived_data/clustering_results_%_7_0.csv \
derived_data/clustering_results_%_7_1.csv \
derived_data/clustering_results_%_7_2.csv \
derived_data/clustering_results_%_7_3.csv \
derived_data/clustering_results_%_7_4.csv \
derived_data/clustering_results_%_8_0.csv \
derived_data/clustering_results_%_8_1.csv \
derived_data/clustering_results_%_8_2.csv \
derived_data/clustering_results_%_8_3.csv \
derived_data/clustering_results_%_8_4.csv \
derived_data/clustering_results_%_9_0.csv \
derived_data/clustering_results_%_9_1.csv \
derived_data/clustering_results_%_9_2.csv \
derived_data/clustering_results_%_9_3.csv \
derived_data/clustering_results_%_9_4.csv \
derived_data/clustering_results_%_10_0.csv \
derived_data/clustering_results_%_10_1.csv \
derived_data/clustering_results_%_10_2.csv \
derived_data/clustering_results_%_10_3.csv \
derived_data/clustering_results_%_10_4.csv: derived_data/clustering_data_%.csv \
  .created-dirs \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f $< -s $*
	
# Final clustering results for each year and averages
# Using 4 clusters
derived_data/clustering_results_%.csv: derived_data/clustering_data_%.csv \
  .created-dirs \
  do_spectral_clustering.py
	python3 do_spectral_clustering.py -f $< -s $* -n 9

# Choose number of clusters based on mean normalized mutual information
figures/n_clusters_mut_inf_%.png: .created-dirs \
  derived_data/clustering_results_%_3_0.csv \
  derived_data/clustering_results_%_3_1.csv \
  derived_data/clustering_results_%_3_2.csv \
  derived_data/clustering_results_%_3_3.csv \
  derived_data/clustering_results_%_3_4.csv \
  derived_data/clustering_results_%_4_0.csv \
  derived_data/clustering_results_%_4_1.csv \
  derived_data/clustering_results_%_4_2.csv \
  derived_data/clustering_results_%_4_3.csv \
  derived_data/clustering_results_%_4_4.csv \
  derived_data/clustering_results_%_5_0.csv \
  derived_data/clustering_results_%_5_1.csv \
  derived_data/clustering_results_%_5_2.csv \
  derived_data/clustering_results_%_5_3.csv \
  derived_data/clustering_results_%_5_4.csv \
  derived_data/clustering_results_%_6_0.csv \
  derived_data/clustering_results_%_6_1.csv \
  derived_data/clustering_results_%_6_2.csv \
  derived_data/clustering_results_%_6_3.csv \
  derived_data/clustering_results_%_6_4.csv \
  derived_data/clustering_results_%_7_0.csv \
  derived_data/clustering_results_%_7_1.csv \
  derived_data/clustering_results_%_7_2.csv \
  derived_data/clustering_results_%_7_3.csv \
  derived_data/clustering_results_%_7_4.csv \
  derived_data/clustering_results_%_8_0.csv \
  derived_data/clustering_results_%_8_1.csv \
  derived_data/clustering_results_%_8_2.csv \
  derived_data/clustering_results_%_8_3.csv \
  derived_data/clustering_results_%_8_4.csv \
  derived_data/clustering_results_%_9_0.csv \
  derived_data/clustering_results_%_9_1.csv \
  derived_data/clustering_results_%_9_2.csv \
  derived_data/clustering_results_%_9_3.csv \
  derived_data/clustering_results_%_9_4.csv \
  derived_data/clustering_results_%_10_0.csv \
  derived_data/clustering_results_%_10_1.csv \
  derived_data/clustering_results_%_10_2.csv \
  derived_data/clustering_results_%_10_3.csv \
  derived_data/clustering_results_%_10_4.csv \
  n_clusters.R
	Rscript n_clusters.R $*

# Plot clustering results
figures/clustered_plot_%.png: .created-dirs \
  derived_data/states_%.csv \
  derived_data/clustering_data_%.csv \
  derived_data/clustering_results_%.csv
	Rscript spectral_clustering_results.R $*
  
# Calculate mutual information for the clusters generated for each year
# Idea is to see if there is a big change in the clustering over time
# Outputs heatmap as illustration
figures/mut_inf_heatmap.png: .created-dirs \
  derived_data/states_2011.csv \
  derived_data/clustering_results_2011.csv \
  derived_data/states_2013.csv \
  derived_data/clustering_results_2013.csv \
  derived_data/states_2015.csv \
  derived_data/clustering_results_2015.csv \
  derived_data/states_2017.csv \
  derived_data/clustering_results_2017.csv \
  derived_data/states_2019.csv \
  derived_data/clustering_results_2019.csv \
  mutual_information.R
	Rscript mutual_information.R

# Build final report as pdf
report.pdf: .created-dirs \
  figures/national_gender_plt.png \
  figures/income_time_plt.png \
  figures/race_time_plt.png \
  figures/edu_time_plt.png \
  figures/age_time_plt.png \
  figures/clustered_plot_avgs.png \
  figures/clustered_plot_2011.png \
  figures/clustered_plot_2013.png \
  figures/clustered_plot_2015.png \
  figures/clustered_plot_2017.png \
  figures/clustered_plot_2019.png \
  figures/mut_inf_heatmap.png \
  figures/n_clusters_mut_inf_2013.png \
  report.tex
	pdflatex report.tex
