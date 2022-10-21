FROM rocker/verse 
RUN R -e "install.packages(\"tinytex\")"
RUN R -e "tinytex::install_tinytex(force=TRUE)"

