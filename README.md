# Overview

In this project, I explore the Nutrition, Physical Activity, and Obesity -- Behavioral Risk Factor Surveillance System dataset provided by the CDC (https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7). This dataset contains responses to questions about diet and physical activity stratified by geographic and demographic information for adults in the US for the years 2011-2020.

Questions I explore include: How do different states experience obesity and its risk factors? Are there groups of states with similar behaviors relating to nutrition and exercise? How has their weight status changed over time? Has the grouping changed over time? 

A copy of the dataset is included in the source_data directory.

# Using This Repository
This project should be run in a Docker container (see https://www.docker.com/). 

To build the image, run: 
```
docker build . -t 611-final
```

Then run the container and start an Rstudio server using: 
```
docker run -v $(pwd):/home/rstudio -p 8787:8787 -e PASSWORD=pwd --rm -it 611-final 
```

Navigate to localhost:8787 via a browser to access the development environment. Sign in with username rstudio and password pwd. 

Alternatively, if you are just interested in building the final report, run: 
```
docker run -v $(pwd):/home/rstudio  --user="rstudio" --workdir="/home/rstudio/" --rm -t 611-final make report.pdf
```

# Project Organization
The entrypoint for this project is the Makefile, which describes the organization of this project, and how to build the final report and its dependencies. 

To build the final report, if you are using the Rstudio development environment, go to the Terminal tab and run
```
make report.pdf
```

This will build the report and any missing dependencies. 
