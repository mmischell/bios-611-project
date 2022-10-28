# Overview

In this project, I explore the Nutrition, Physical Activity, and Obesity -- Behavioral Risk Factor Surveillance System dataset provided by the CDC (https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7). This dataset contains responses to questions about diet and physical activity stratified by geographic and demographic information for adults in the US for the years 2011-2020.

I am interested in analyzing the relationships between different demographics and obesity over time, as well as differences in how different groups experience obesity. Questions I explore include: Were there any changes in who was overweight, had poor nutrition, infrequent exercise, or were the demographics consistent over time? Which groups are currently most afflicted? Does obesity happen at different times of life for different races or income levels? Do some groups struggle with nutrition, while others with exercise? Understanding the trends and demographics around obesity could help to guide future policies and provide more focused care. 

I also explore the CDC Nutrition, Physical Activity, and Obesity - Legislation dataset (https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/CDC-Nutrition-Physical-Activity-and-Obesity-Legisl/nxst-x9p4). This contains information on legislation related to obesity and its risk factors from 2001 to 2017. I hope to compare this to the risk factor dataset to see what effect legislation has had on obesity.

Copies of both datasets are included int the source_data directory.

# Using This Repository
This project should be run in a Docker container (see https://www.docker.com/). 

To build the image, run: 
```
docker build . -t 611-final
```

Then run the container and start an Rstudio server using: 
```
docker run -v $(pwd):/home/rstudio  -p 8787:8787 -e PASSWORD=pwd --rm -it 611-final 
```

Navigate to localhost:8787 via a browser to access the development environment. Sign in with username rstudio and passoword pwd. 

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
