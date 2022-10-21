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
  source_data/CDC_Nutrition__Physical_Activity__and_Obesity_-_Legislation.csv
	Rscript tidy_data.R

# Plot obesity by gender in US
figures/national_gender_plt.png: .created-dirs \
  derived_data/clean_obesity_risk_factors.csv
	Rscript explore_gender.R

# Build final report as pdf
report.pdf: .created-dirs \
  figures/national_gender_plt.png
	pdflatex report.tex
