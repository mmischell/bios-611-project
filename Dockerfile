FROM rocker/verse 
RUN Rscript --no-restore --no-save -e "remotes::install_github('eddelbuettel/rcppcorels')"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c(\"wrapfig\",\"ec\",\"ulem\",\"amsmath\",\"capt-of\"))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c(\"hyperref\",\"iftex\",\"pdftexcmds\",\"infwarerr\"))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c(\"kvoptions\",\"epstopdf\",\"epstopdf-pkg\"))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c(\"etoolbox\",\"xcolor\",\"geometry\"))"
RUN apt update && apt-get install -y openssh-server python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install scikit-learn pandas
RUN R -e "install.packages(\"reticulate\")"
RUN pip3 install jupyter jupyterlab bokeh jupyter_bokeh
RUN R -e "install.packages(\"imputeTS\")"
RUN R -e "install.packages(\"rdist\")"
